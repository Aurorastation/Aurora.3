#define BAR_CAP 12

/mob/living/heavy_vehicle/proc/refresh_hud()
	if(LAZYLEN(pilots))
		for(var/thing in pilots)
			var/mob/pilot = thing
			if(pilot.client)
				pilot.client.screen |= hud_elements
	if(client)
		client.screen |= hud_elements

/mob/living/heavy_vehicle/instantiate_hud()
	zone_sel = new
	if(!LAZYLEN(hud_elements))
		var/i = 1
		for(var/hardpoint in hardpoints)
			var/atom/movable/screen/mecha/hardpoint/H = new(src, hardpoint)
			H.screen_loc = "1:6,[15-i]" //temp
			hud_elements |= H
			hardpoint_hud_elements[hardpoint] = H
			i++

		var/list/additional_hud_elements = list(
			/atom/movable/screen/mecha/toggle/power_control,
			/atom/movable/screen/mecha/toggle/maint,
			/atom/movable/screen/mecha/eject,
			/atom/movable/screen/mecha/toggle/hardpoint,
			/atom/movable/screen/mecha/toggle/hatch,
			/atom/movable/screen/mecha/toggle/hatch_open,
			/atom/movable/screen/mecha/radio,
			/atom/movable/screen/mecha/toggle/sensor,
			/atom/movable/screen/mecha/toggle/megaspeakers,
			/atom/movable/screen/mecha/rename
			)

		if(body && body.pilot_coverage >= 100)
			additional_hud_elements += /atom/movable/screen/mecha/toggle/air

		i = 0
		var/pos = 7
		for(var/additional_hud in additional_hud_elements)
			var/atom/movable/screen/mecha/M = new additional_hud(src)
			var/y_position = i * -12
			if(M.icon_state == "large_base")
				y_position += 2
			if(!i)
				y_position += 2
			M.screen_loc = "1:6,[pos]:[y_position]"
			hud_elements |= M
			i++

		hud_health = new /atom/movable/screen/mecha/health(src)
		hud_health.screen_loc = "EAST-1:28,CENTER-3:11"
		hud_elements |= hud_health
		hud_open = locate(/atom/movable/screen/mecha/toggle/hatch_open) in hud_elements
		hud_power = new /atom/movable/screen/mecha/power(src)
		hud_power.screen_loc = "EAST-1:12,CENTER-4:25"
		hud_elements |= hud_power
		hud_power_control = locate(/atom/movable/screen/mecha/toggle/power_control) in hud_elements

	refresh_hud()

/mob/living/heavy_vehicle/handle_hud_icons()
	for(var/hardpoint in hardpoint_hud_elements)
		var/atom/movable/screen/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H) H.update_system_info()
	handle_hud_icons_health()
	handle_power_hud()
	refresh_hud()


/mob/living/heavy_vehicle/handle_hud_icons_health()

	hud_health?.overlays.Cut()

	if(!body || !get_cell() || (get_cell().charge <= 0))
		return


	if(!body.diagnostics || !body.diagnostics.is_functional() || ((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*2)))
		if(!GLOB.mecha_damage_overlay_cache["critfail"])
			GLOB.mecha_damage_overlay_cache["critfail"] = image(icon='icons/mecha/mecha_hud.dmi',icon_state="dam_error")
		hud_health?.overlays |= GLOB.mecha_damage_overlay_cache["critfail"]
		return

	var/list/part_to_state = list("legs" = legs,"body" = body,"head" = head,"arms" = arms)
	for(var/part in part_to_state)
		var/state = 0
		var/obj/item/mech_component/MC = part_to_state[part]
		if(MC)
			if((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*3))
				state = rand(0,4)
			else
				state = MC.damage_state
		if(!GLOB.mecha_damage_overlay_cache["[part]-[state]"])
			var/image/I = image(icon='icons/mecha/mecha_hud.dmi',icon_state="dam_[part]")
			switch(state)
				if(1)
					I.color = "#00ff00"
				if(2)
					I.color = "#f2c50d"
				if(3)
					I.color = "#ea8515"
				if(4)
					I.color = "#ff0000"
				else
					I.color = "#f5f5f0"
			GLOB.mecha_damage_overlay_cache["[part]-[state]"] = I

		hud_health?.overlays |= GLOB.mecha_damage_overlay_cache["[part]-[state]"]

/mob/living/heavy_vehicle/proc/handle_power_hud()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		var/power_percentage = round((get_cell()?.charge / get_cell()?.maxcharge) * 100)
		if(power_percentage >= 100)
			hud_power?.maptext_x = 21
		else if(power_percentage < 10)
			hud_power?.maptext_x = 25
		else
			hud_power?.maptext_x = 22
		hud_power?.maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 8px;\">[power_percentage]%</span>"
	else
		hud_power?.maptext_x = 13
		hud_power?.maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">NO CELL</span>"
