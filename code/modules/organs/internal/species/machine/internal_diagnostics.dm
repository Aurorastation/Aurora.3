/obj/item/organ/internal/machine/internal_diagnostics
	name = "internal diagnostics suite"
	desc = "An extremely complex suite of sensors, circuits and other electronic parts. They are used by the myriad components of an IPC to regulate its functions, while also allowing them to diagnose internal problems."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "analyser"
	organ_tag = BP_DIAGNOSTICS_SUITE
	parent_organ = BP_CHEST
	action_button_name = "Internal Diagnostics"

/obj/item/organ/internal/machine/internal_diagnostics/attack_self(var/mob/user)
	. = ..()
	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return

	to_chat(user, SPAN_NOTICE("You query your internal diagnostics system and gather some information."))
	open_diagnostics(user)

/obj/item/organ/internal/machine/internal_diagnostics/proc/open_diagnostics(mob/user)
	if(!ishuman(user))
		return

	if(status & ORGAN_DEAD)
		to_chat(user, SPAN_MACHINE_WARNING("You receive nothing but a critical error notifying you that \the [src] is unreachable."))
		return

	var/mob/living/carbon/human/human = user

	var/datum/tgui_module/ipc_diagnostic/diagnostic = new(human, owner)
	diagnostic.ui_interact(user)
