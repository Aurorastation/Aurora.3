// This should probably be something cooler than a button, eventually.
/obj/machinery/button/distress
	name = "distress beacon launcher"
	desc = "Press this button to launch a distress beacon."
	var/recorded_message

/obj/machinery/button/distress/Initialize(mapload, d, populate_components, is_internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/button/distress/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/button/distress/hear_talk(mob/M, text, verb, datum/language/speaking)
	recorded_message = text

/obj/machinery/button/distress/attack_hand(var/mob/user)
	if(..())
		return
	if(!linked)
		return
	if(linked.has_called_distress_beacon)
		to_chat(user, SPAN_WARNING("The distress beacon has already been launched!"))
		return
	use_power_oneoff(10)
	active = TRUE
	var/choice = alert(user, "Are you sure you want to launch a distress beacon?", "Distress Beacon", "Yes", "No")
	if(choice == "No" || !choice)
		active = FALSE
		return
	var/distress_message = tgui_input_text(user, "Enter a distress message that other vessels will receive.", "Distress Beacon", multiline = TRUE)
	if(distress_message)
		become_hearing_sensitive()
		user.say(distress_message)
		lose_hearing_sensitivity()
	else
		to_chat(user, SPAN_WARNING("The beacon refuses to launch without a message!"))
		active = FALSE
		return
	if(use_check_and_message(user)) //Lots of inputs, user may have moved.
		return
	SSdistress.trigger_overmap_distress_beacon(linked, distress_message, user)
	to_chat(user, SPAN_NOTICE("Distress beacon launched."))
	playsound(src, 'sound/effects/alert.ogg', 50)
	active = FALSE
