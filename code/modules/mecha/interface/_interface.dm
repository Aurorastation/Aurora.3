#define BAR_CAP 12

/mob/living/heavy_vehicle/proc/refresh_hud()
	if(pilot && pilot.client)
		pilot.client.screen |= hud_elements
	if(client)
		client.screen |= hud_elements

/mob/living/heavy_vehicle/instantiate_hud()
	var/i = 1
	for(var/hardpoint in hardpoints)
		var/obj/screen/movable/mecha/hardpoint/H = new(src, hardpoint)
		H.screen_loc = "1:6,[15-i]" //temp
		hud_elements |= H
		hardpoint_hud_elements[hardpoint] = H
		i++

	var/list/additional_hud_elements = list(
		/obj/screen/movable/mecha/toggle/maint,
		/obj/screen/movable/mecha/eject,
		/obj/screen/movable/mecha/toggle/hardpoint,
		/obj/screen/movable/mecha/toggle/hatch,
		/obj/screen/movable/mecha/toggle/hatch_open,
		/obj/screen/movable/mecha/radio
		)
	i = 1
	var/pos = 7
	for(var/additional_hud in additional_hud_elements)
		/*var/obj/screen/movable/mecha/M = PoolOrNew(additional_hud,src) //TODO: Fix. Dunno what this does
		M.screen_loc = "1:6,[pos]"
		hud_elements |= M*/
		i++
		if(i>=3)
			i = 0
			pos--

	hud_open = locate(/obj/screen/movable/mecha/toggle/hatch_open) in hud_elements
	refresh_hud()

/mob/living/heavy_vehicle/handle_hud_icons()
	if(client || (pilot && pilot.client))
		for(var/hardpoint in hardpoint_hud_elements)
			var/obj/screen/movable/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
			if(H)
				H.update_system_info()
		handle_hud_icons_health()
		refresh_hud()

/mob/living/heavy_vehicle/handle_hud_icons_health()

	if(!hud_health)

		//hud_health = PoolOrNew(/obj/screen/movable/mecha/health,src) //TODO: Fix. Dunno what this does
		hud_health.screen_loc = "13:28,7:15"
		hud_elements |= hud_health

		// Debugging/placeholder, test another time.
		for(var/i=1;i<=5;i++)
			var/obj/screen/movable/mecha/internal_system/IS = new(src)
			hud_health.internal_components += IS
			IS.screen_loc = "13:28,[7-i]:15"

	hud_health.overlays.Cut()

	if(hud_health.display_internals)
		hud_elements |= hud_health.internal_components
	else
		if(client)
			client.screen -= hud_health.internal_components
		if(pilot && pilot.client)
			pilot.client.screen -= hud_health.internal_components
		hud_elements -= hud_health.internal_components

	if(!body.cell || (body.cell.charge <= 0))
		return

	if(!body.diagnostics || !body.diagnostics.is_functional() || ((hallucination>EMP_GUI_DISRUPT) && prob(hallucination*2))) //TODO: Fix is_functional()
		if(!mecha_damage_overlay_cache["critfail"])
			mecha_damage_overlay_cache["critfail"] = image(icon='icons/mecha/mecha_hud.dmi',icon_state="dam_error")
		hud_health.overlays |= mecha_damage_overlay_cache["critfail"]
		return

	var/list/part_to_state = list("legs" = legs,"body" = body,"head" = head,"arms" = arms)
	for(var/part in part_to_state)
		var/state = 0
		var/obj/item/mech_component/MC = part_to_state[part]
		if(MC)
			if((hallucination>EMP_GUI_DISRUPT) && prob(hallucination*3))
				state = rand(0,4)
			else
				state = MC.damage_state
		if(!mecha_damage_overlay_cache["[part]-[state]"])
			var/image/I = image(icon='icons/mecha/mecha_hud.dmi',icon_state="dam_[part]")
			switch(state)
				if(1)
					I.color = "#00FF00"
				if(2)
					I.color = "#F2C50D"
				if(3)
					I.color = "#EA8515"
				if(4)
					I.color = "#FF0000"
				else
					I.color = "#F5F5F0"
			mecha_damage_overlay_cache["[part]-[state]"] = I
		hud_health.overlays |= mecha_damage_overlay_cache["[part]-[state]"]