var/list/doppler_arrays = list()

/obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A highly precise sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array."
	icon = 'icons/obj/modular_console.dmi'
	icon_state = "computer"

	anchored = TRUE
	density = TRUE
	var/active = TRUE

/obj/machinery/doppler_array/Initialize()
	. = ..()
	doppler_arrays += src
	update_icon()

/obj/machinery/doppler_array/Destroy()
	doppler_arrays -= src
	return ..()

/obj/machinery/doppler_array/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("\The [src] is [active ? "listening for explosions" : "[SPAN_WARNING("inactive")]"]."))

/obj/machinery/doppler_array/attack_hand(mob/user)
	active = !active
	to_chat(user, SPAN_NOTICE("\The [src] is now [active ? "listening for explosions" : "[SPAN_WARNING("inactive")]"]."))

/obj/machinery/doppler_array/update_icon()
	icon_state = initial(icon_state)
	set_light(0)
	if(stat & BROKEN)
		icon_state = "broken"
	else
		cut_overlays()
		if(!(stat & NOPOWER))
			set_light(2, 1, COLOR_CYAN)
			add_overlay(image(icon, src, "teleport"))

/obj/machinery/doppler_array/proc/sense_explosion(var/x0,var/y0,var/z0,var/devastation_range,var/heavy_impact_range,var/light_impact_range)
	if(!active)
		return
	if(stat & NOPOWER)
		return
	if(z != z0)
		return

	var/dx = abs(x0-x)
	var/dy = abs(y0-y)
	var/distance

	if(dx > dy)
		distance = dx
	else
		distance = dy

	if(distance > 100)
		return

	var/message = "Explosive disturbance detected - Epicenter at: grid ([x0],[y0],[z0]). Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]."
	global_announcer.autosay(message, "Tachyon-Doppler Array", "Science")

	var/list/gained_tech
	switch(devastation_range)
		if(-INFINITY to 1) // minimum
			gained_tech = list(TECH_BLUESPACE = 1, TECH_COMBAT = 2, TECH_MATERIAL = 2)
		if(1 to 2) // starter bombs
			gained_tech = list(TECH_BLUESPACE = 2, TECH_PHORON = 2, TECH_COMBAT = 3, TECH_MATERIAL = 3)
		if(2 to 4) // max toxins can get
			gained_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 3, TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
		else
			gained_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 4, TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)

	new /obj/item/research_slip(get_turf(src), gained_tech)

/obj/machinery/doppler_array/power_change()
	..()
	update_icon()
