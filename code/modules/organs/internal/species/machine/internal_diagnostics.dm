/obj/item/organ/internal/machine/internal_diagnostics
	name = "internal diagnostics suite"
	desc = "An extremely complex suite of sensors, circuits and other electronic parts. They are used by the myriad components of an IPC to regulate its functions, while also allowing them to diagnose internal problems."
	organ_tag = BP_DIAGNOSTICS_SUITE
	parent_organ = BP_CHEST
	action_button_name = "Internal Diagnostics"

/obj/item/organ/internal/machine/internal_diagnostics/attack_self(var/mob/user)
	. = ..()
	if(owner.last_special > world.time)
		return

	if(user.stat == DEAD)
		return

	if(user.incapacitated(INCAPACITATION_KNOCKOUT|INCAPACITATION_STUNNED))
		return

	// it's an organ, should never be not human type
	var/mob/living/carbon/human/synth = user

	to_chat(synth, SPAN_NOTICE("You query your internal diagnostics system and gather some information."))

	var/datum/tgui_module/ipc_diagnostic/diagnostic = new /datum/tgui_module/ipc_diagnostic(synth)
	diagnostic.ui_interact(usr)

	synth.last_special = world.time

