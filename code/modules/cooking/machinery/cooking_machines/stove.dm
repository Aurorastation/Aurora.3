/obj/machinery/appliance/cooker/stove
	name = "stove"
	desc = "Don't touch it!"
	icon_state = "stove"
	cook_type = "pan-fried"
	appliancetype = SKILLET | SAUCEPAN | POT
	food_color = "#a34719"
	can_burn_food = TRUE
	active_power_usage = 6 KILO WATTS
	heating_power = 6000
	on_icon = "stove"
	off_icon = "stove"
	place_verb = "onto"

	resistance = 5000 // Approx. 2 minutes.
	idle_power_usage = 1 KILO WATTS
	//uses ~30% power to stay warm
	optimal_temp = T0C + 100 // can boil water!
	optimal_power = 1.2

	max_contents = 4

	stat = POWEROFF	//Starts turned off

	starts_with = list(
		/obj/item/reagent_containers/cooking_container/skillet,
		/obj/item/reagent_containers/cooking_container/pot,
		/obj/item/reagent_containers/cooking_container/saucepan
	)

	var/list/pan_positions = list(
		list(-7, 6),
		list(-7, -3),
		list(7, 6),
		list(7, -3)
	)

/obj/machinery/appliance/cooker/stove/update_icon()
	. = ..()
	ClearOverlays()
	var/list/pans = list()
	var/pan_number = 0
	for(var/obj/item/reagent_containers/cooking_container/CC in contents)
		var/pan_icon_state
		var/pan_position_number = clamp((pan_number)+1, 1, 4)
		var/list/positions = pan_positions[pan_position_number]
		switch(CC.appliancetype)
			if(SKILLET)
				pan_icon_state = "skillet"
				if(pan_position_number >= 3)
					pan_icon_state = "skillet_flip"
			if(SAUCEPAN)
				pan_icon_state = "pan"
				if(pan_position_number >= 3)
					pan_icon_state = "pan_flip"
			if(POT)
				pan_icon_state = "pot"
			else
				continue
		var/mutable_appearance/pan_overlay = mutable_appearance('icons/obj/machinery/cooking_machines.dmi', pan_icon_state)
		pan_overlay.pixel_x = positions[1]
		pan_overlay.pixel_y = positions[2]
		pan_overlay.color = CC.color
		pans += pan_overlay
		pan_number = pan_position_number
		//filling
		if(CC.reagents?.total_volume)
			var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/machinery/cooking_machines.dmi', "filling_overlay")
			filling_overlay.pixel_x = positions[1]
			filling_overlay.pixel_y = positions[2]
			filling_overlay.color = CC.reagents.get_color()
			switch(CC.appliancetype)
				if(SKILLET)
					filling_overlay.pixel_y -= 3
				if(SAUCEPAN)
					filling_overlay.pixel_y -= 2
			pans += filling_overlay
		// flame overlay
		if(!stat)
			var/mutable_appearance/flame_overlay = mutable_appearance('icons/obj/machinery/cooking_machines.dmi', "stove_flame")
			flame_overlay.pixel_x = positions[1]
			flame_overlay.pixel_y = positions[2]
			flame_overlay.color = "#006eff"
			pans += flame_overlay
	if(isemptylist(pans))
		return
	AddOverlays(pans)

/obj/machinery/appliance/cooker/stove/adhomai
	name = "adhomian stove"
	desc = "A rustic Adhomian stove. Warm enough to gather around the winter."
	icon_state = "adhomai_stove_off"

/obj/machinery/appliance/cooker/stove/adhomai/update_icon()
	ClearOverlays()
	if(!stat)
		icon_state = "adhomai_stove_on"
	else
		icon_state = "adhomai_stove_off"
	if(!stat && temperature)
		switch(temperature)
			if(T0C to T20C)
				AddOverlays("stove_fire0")
			if(T20C + 21 to T20C + 40)
				AddOverlays("stove_fire1")
			if(T20C + 21 to T20C + 40)
				AddOverlays("stove_fire2")
			if(T20C + 41 to T20C + 60)
				AddOverlays("stove_fire3")
			if(T20C + 61 to INFINITY)
				AddOverlays("stove_fire4")
