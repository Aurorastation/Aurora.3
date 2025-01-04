/obj/item/device/radio/microphone
	name = "handheld microphone"
	desc = "A handheld microphone, used for on-the-fly interviewing. Pose for the fans!"
	icon_state = "microphone"
	item_state = "microphone"
	var/second_speaker = FALSE //If true, waits for the clicked-on mob to speak next to the microphone before resetting relevant variables
	var/speaker //Stores the clicked-on mob's name so no one else broadcasts to the radio

/obj/item/device/radio/microphone/Initialize()
	. = ..()
	set_frequency(ENT_FREQ)
	internal_channels = list(num2text(ENT_FREQ) = list())

/obj/item/device/radio/microphone/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(user.a_intent == I_HELP && target_mob != src.get_holding_mob())
		visible_message("[SPAN_BOLD("[user]")] holds \the [src] over to [SPAN_BOLD("[target_mob]")].")
		set_broadcasting(TRUE)
		canhear_range = 1
		second_speaker = TRUE
		speaker = target_mob.name

/obj/item/device/radio/microphone/hear_talk(mob/M, msg, verb, datum/language/speaking)
	if(M.name != speaker || !broadcasting)
		return
	if(M.name == speaker && !M.Adjacent(get_turf(src)))
		to_chat(get_holding_mob(), SPAN_WARNING("[M] stepped too far out of range!"))
		second_speaker = FALSE
		canhear_range = initial(canhear_range)
		speaker = null
		set_broadcasting(FALSE)
		return
	else
		second_speaker = FALSE
		canhear_range = initial(canhear_range)
		speaker = null
		set_broadcasting(FALSE)
	return talk_into(M, msg, null, verb, speaking, TRUE)





