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

	if(owner.incapacitated())
		return

	if(is_broken())
		return

	to_chat(owner, SPAN_NOTICE("You query your internal diagnostics system and gather some information."))
	//open the tgui here

