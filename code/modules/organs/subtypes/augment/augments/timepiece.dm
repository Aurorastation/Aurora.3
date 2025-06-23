/obj/item/organ/internal/augment/timepiece
	name = "integrated timepiece"
	icon_state = "augment-clock"
	parent_organ = BP_HEAD
	action_button_name = "Activate Integrated Timepiece"
	activable = TRUE
	organ_tag = BP_AUG_TIMEPIECE
	action_button_icon = "augment-clock"
	cooldown = 10

/obj/item/organ/internal/augment/timepiece/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	to_chat(owner, SPAN_NOTICE("Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [GLOB.game_year]'. Have a lovely day."))

	if(GLOB.evacuation_controller.get_status_panel_eta())
		to_chat(owner, SPAN_WARNING("Notice: You have one (1) scheduled flight, ETA: [GLOB.evacuation_controller.get_status_panel_eta()]."))
