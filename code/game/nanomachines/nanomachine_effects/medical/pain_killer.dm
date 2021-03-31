/decl/nanomachine_effect/pain_killer
	name = "Nerve Duller"
	desc = "By attaching themselves to various vital nerves in the body, nanomachines can block the path of pain signals to the brain."

/decl/nanomachine_effect/pain_killer/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	H.add_chemical_effect(CE_PAINKILLER, 40) // almost as good as perconol