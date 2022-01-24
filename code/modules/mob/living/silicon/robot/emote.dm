/mob/living/silicon/robot/verb/powerwarn()
	set category = "Robot Commands"
	set name = "Power Warning"

	if(!is_component_functioning("power cell") || !cell?.charge)
		to_chat(src, SPAN_NOTICE("You announce you are operating in low power mode."))
		visible_message(SPAN_WARNING("The power warning light on \the [src] flashes urgently."))
		playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 50, 0)
	else
		to_chat(src, SPAN_WARNING("You can only use this emote when you're out of charge."))