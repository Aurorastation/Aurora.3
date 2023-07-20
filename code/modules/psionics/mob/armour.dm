/datum/component/armor/psionic
	full_block_message = "You block the blow with your mind!"
	partial_block_message = "You soften the blow with your mind!"

/datum/component/armor/psionic/Initialize(list/armor, armor_type)
	. = ..()
	var/datum/psi_complexus/PC = parent
	PC.armor_component = src

/datum/component/armor/psionic/Destroy()
	var/datum/psi_complexus/PC = parent
	PC.armor_component = null
	return ..()
