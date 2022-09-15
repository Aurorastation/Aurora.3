/obj/machinery/stargazer
	name = "stargazer system"
	icon = 'icons/obj/machinery/stargazer.dmi'
	icon_state = "stargazer_off"
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -32
	pixel_y = -32
	var/image/star_system_image

/obj/machinery/stargazer/Initialize(mapload, d, populate_components)
	. = ..()
	star_system_image = image(icon, null, "stargazer_[SSatlas.current_sector.name]", EFFECTS_ABOVE_LIGHTING_LAYER)
	power_change()

/obj/machinery/stargazer/examine(mob/user)
	. = ..()
	if(!(stat & BROKEN) && !(stat & NOPOWER))
		to_chat(user, SPAN_NOTICE("\The [src] shows the current sector to be <a href='?src=\ref[src];examine=1'>[SSatlas.current_sector.name]</a>."))

/obj/machinery/stargazer/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "stargazer_off"
		cut_overlays()
		set_light(0)
	else if(!(stat & NOPOWER))
		icon_state = "stargazer_on"
		add_overlay(star_system_image)
		set_light(6, 2, LIGHT_COLOR_BLUE)
	else
		icon_state = "stargazer_off"
		cut_overlays()
		set_light(0)

/obj/machinery/stargazer/Topic(href, href_list, datum/topic_state/state)
	if((stat & BROKEN) || (stat & NOPOWER))
		return TRUE
	if(!isInSight(usr, src))
		return TRUE
	if(usr.incapacitated(INCAPACITATION_KNOCKOUT))
		return TRUE

	if(href_list["examine"])
		to_chat(usr, SSatlas.current_sector.get_chat_description())
