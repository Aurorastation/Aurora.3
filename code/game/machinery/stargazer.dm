/obj/machinery/stargazer
	name = "stargazer system"
	icon = 'icons/obj/machinery/stargazer.dmi'
	icon_state = "stargazer_off"
	anchored = TRUE
	density = TRUE
	layer = CAMERA_LAYER
	pixel_x = -32
	pixel_y = -24
	var/image/star_system_image

/obj/machinery/stargazer/Initialize(mapload, d, populate_components)
	. = ..()
	star_system_image = image(icon, null, "stargazer_[SSatlas.current_sector.name]", EFFECTS_ABOVE_LIGHTING_LAYER)
	power_change()

/obj/machinery/stargazer/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!(stat & BROKEN) && !(stat & NOPOWER))
		. += SPAN_NOTICE("\The [src] shows the current sector to be <a href='?src=\ref[src];examine=1'>[SSatlas.current_sector.name]</a>.")

/obj/machinery/stargazer/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "stargazer_off"
		cut_overlays()
		set_light(0)
	else if(!(stat & NOPOWER))
		icon_state = "stargazer_on"
		add_overlay(star_system_image)
		var/stargazer_light_color = LIGHT_COLOR_HALOGEN
		if(SSatlas.current_sector.starlight_color)
			stargazer_light_color = SSatlas.current_sector.starlight_color
		set_light(6, 2, stargazer_light_color)
	else
		icon_state = "stargazer_off"
		cut_overlays()
		set_light(0)

/obj/machinery/stargazer/Topic(href, href_list, datum/ui_state/state)
	if((stat & BROKEN) || (stat & NOPOWER))
		return TRUE
	if(!is_in_sight(usr, src))
		return TRUE
	if(usr.incapacitated(INCAPACITATION_KNOCKOUT))
		return TRUE

	if(href_list["examine"])
		to_chat(usr, SSatlas.current_sector.get_chat_description())
