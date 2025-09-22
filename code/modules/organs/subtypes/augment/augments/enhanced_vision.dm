/obj/item/organ/internal/augment/enhanced_vision
	name = "vision enhanced retinas"
	desc = "Zeng Hu implants given to EMTs to assist with finding the injured. These eye implants allow one to see further than you normally could."
	icon_state = "enhanced_vision"
	organ_tag = BP_AUG_ENCHANED_VISION
	parent_organ = BP_HEAD
	action_button_name = "Activate Vision Enhanced Retinas"
	action_button_icon = "enhanced_vision"
	cooldown = 30
	activable = TRUE

/obj/item/organ/internal/augment/enhanced_vision/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	zoom(owner, 6, 7, FALSE, FALSE)
	owner.visible_message(
		zoom ? "<b>[owner]</b>'s pupils narrow..." : "<b>[owner]</b>'s pupils return to normal.",
		range = 3
	)

/obj/item/organ/internal/augment/enhanced_vision/emp_act(severity)
	. = ..()

	var/obj/item/organ/internal/eyes/E = owner.get_eyes()
	if(!E)
		return

	E.take_damage(5)
