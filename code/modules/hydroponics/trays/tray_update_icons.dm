/obj/machinery/portable_atmospherics/hydroponics/proc/need_update_icon()
	. = 0
	var/overlay_stage
	if (seed)
		if (mechanical && health <= (GET_SEED_TRAIT(seed, TRAIT_ENDURANCE) / 2))
			. |= TRAY_LOW_HEALTH

		if (dead)
			. |= TRAY_PLANT_DEAD
		else
			. |= TRAY_PLANT_LIVE
			if (harvest)
				. |= TRAY_PLANT_HARVEST

		if (. & TRAY_PLANT_LIVE)
			if(!seed.growth_stages)
				seed.update_growth_stages()
			overlay_stage = 1
			if(age >= GET_SEED_TRAIT(seed, TRAIT_MATURATION))
				overlay_stage = seed.growth_stages
			else
				var/maturation = GET_SEED_TRAIT(seed, TRAIT_MATURATION)/seed.growth_stages
				if(maturation < 1)
					maturation = 1
				overlay_stage = maturation ? max(1,round(age/maturation)) : 1

	if (mechanical)
		if (waterlevel <= 10)
			. |= TRAY_LOW_WATER
		if (nutrilevel <= 2)
			. |= TRAY_LOW_NUT
		if (pestlevel >= 5 || toxins >= 40)
			. |= TRAY_ALERT
		if (harvest)
			. |= TRAY_HARVEST
		if (stasis)
			. |= TRAY_STASIS

	if (closed_system)
		. |= TRAY_COVERED

	if (. != icon_status)
		do_update_icon(., overlay_stage)

/obj/machinery/portable_atmospherics/hydroponics/proc/do_update_icon(var/needed_state, var/plant_stage)
	. = list()
	if (mechanical)
		if (needed_state & TRAY_LOW_HEALTH)
			. += "over_lowhealth3"
		if (needed_state & TRAY_LOW_WATER)
			. += "over_lowwater3"
		if (needed_state & TRAY_LOW_NUT)
			. += "over_lownutri3"
		if (needed_state & TRAY_ALERT)
			. += "over_alert3"
		if (needed_state & TRAY_HARVEST)
			. += "over_harvest3"
		if (needed_state & TRAY_STASIS)
			. += "stasis"
	if (needed_state & TRAY_COVERED)
		. += "hydrocover"
	if (needed_state & TRAY_PLANT_DEAD)
		var/ikey = "[GET_SEED_TRAIT(seed, TRAIT_PLANT_ICON)]"
		var/image/dead_overlay = SSplants.plant_icon_cache["[ikey]"]
		if(!dead_overlay)
			dead_overlay = image('icons/obj/hydroponics_growing.dmi', "[ikey]")
			dead_overlay.color = DEAD_PLANT_COLOUR
		. += dead_overlay
	else if (needed_state & TRAY_PLANT_LIVE)
		var/image/plant_overlay = seed.get_icon(plant_stage ? plant_stage : displayed_stage)
		. += plant_overlay
		if (plant_stage) displayed_stage = plant_stage
		if (needed_state & TRAY_PLANT_HARVEST)
			var/ikey = "[GET_SEED_TRAIT(seed, TRAIT_PRODUCT_ICON)]"
			var/image/harvest_overlay = SSplants.plant_icon_cache["product-[ikey]-[GET_SEED_TRAIT(seed, TRAIT_PLANT_COLOUR)]"]
			if(!harvest_overlay)
				harvest_overlay = image('icons/obj/hydroponics_products.dmi', "[ikey]")
				harvest_overlay.color = GET_SEED_TRAIT(seed, TRAIT_PRODUCT_COLOUR)
				SSplants.plant_icon_cache["product-[ikey]-[GET_SEED_TRAIT(seed, TRAIT_PRODUCT_COLOUR)]"] = harvest_overlay
			. += harvest_overlay

	SetOverlays(.)
	icon_status = .

/// Refreshes the icon and sets the luminosity.
/obj/machinery/portable_atmospherics/hydroponics/update_icon()
	// Update name.
	if(seed)
		if(mechanical)
			name = "[base_name] (#[seed.uid])"
		else
			name = "[seed.seed_name]"
	else
		name = initial(name)

	if(labelled)
		name += " ([labelled])"

	need_update_icon()

	// Apply density and opacity if a large plant is growing in the plot. Exempt mechanical trays from density alterations, since they're always dense.
	if(seed && GET_SEED_TRAIT(seed, TRAIT_LARGE))
		if(!mechanical)
			density = TRUE
		opacity = TRUE
	else
		if(!mechanical)
			density = FALSE
		opacity = FALSE

	// Update bioluminescence.
	if(seed && GET_SEED_TRAIT(seed, TRAIT_BIOLUM))
		var/pwr
		if(GET_SEED_TRAIT(seed, TRAIT_BIOLUM_PWR) == 0)
			pwr = GET_SEED_TRAIT(seed, TRAIT_BIOLUM)
		else
			pwr = GET_SEED_TRAIT(seed, TRAIT_BIOLUM_PWR)
		var/clr
		if(GET_SEED_TRAIT(seed, TRAIT_BIOLUM_COLOUR))
			clr = GET_SEED_TRAIT(seed, TRAIT_BIOLUM_COLOUR)
		set_light(GET_SEED_TRAIT(seed, TRAIT_POTENCY)/10, pwr, clr)
		return

	if (last_biolum)
		set_light(0)
		last_biolum = null
	return

#undef TRAY_LOW_HEALTH
#undef TRAY_LOW_WATER
#undef TRAY_LOW_NUT
#undef TRAY_ALERT
#undef TRAY_STASIS
#undef TRAY_COVERED
#undef TRAY_PLANT_DEAD
#undef TRAY_PLANT_LIVE
#undef TRAY_HARVEST
