/obj/item/organ/internal/augment/memory_inhibitor
	name = "memory inhibitor"
	desc = "A Zeng Hu implant that allows one to have control over their memories, " \
		+ "allowing you to set a timer and remove any memories developed within it. " \
		+ "This is most popular in Zeng Hu labs within Eridani."
	icon_state = "memory_inhibitor"
	organ_tag = BP_AUG_MEMORY
	parent_organ = BP_HEAD
	activable = TRUE
	cooldown = 20
	action_button_icon = "memory_inhibitor"
	action_button_name = "Activate Memory Inhibitor"
	var/ready_to_erase = FALSE

/obj/item/organ/internal/augment/memory_inhibitor/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(!ready_to_erase)
		to_chat(
			owner,
			SPAN_NOTICE("Your memories following this point will be deleted on the following activation.")
		)
		ready_to_erase = TRUE
	else
		to_chat(
			owner,
			SPAN_WARNING("You do not recall the events since the last time you activated your memory inhibitor!")
		)
		ready_to_erase = FALSE

/obj/item/organ/internal/augment/memory_inhibitor/do_broken_act()
	if(owner)
		to_chat(owner, SPAN_WARNING("You forgot everything that happened today!"))
	return TRUE

/obj/item/organ/internal/augment/memory_inhibitor/emp_act(severity)
	. = ..()

	if(prob(25))
		do_broken_act()
