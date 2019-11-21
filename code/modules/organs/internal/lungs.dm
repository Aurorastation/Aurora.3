/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = BP_LUNGS
	parent_organ = BP_CHEST
	robotic_name = "gas exchange system"
	robotic_sprite = "lungs-prosthetic"
	var/rescued = FALSE // whether or not a collapsed lung has been rescued with a syringe

/obj/item/organ/internal/lungs/process()
	..()

	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//Respiratory tract infection

	if(is_broken() || (is_bruised() && !rescued)) // a thoracostomy can only help with a collapsed lung, not a mangled one
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(4))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 15

	if(is_bruised() && rescued)
		if(prob(4))
			to_chat(owner, span("warning", "It feels hard to breathe..."))
			if (owner.losebreath < 5)
				owner.losebreath = min(owner.losebreath + 1, 5) // it's still not good, but it's much better than an untreated collapsed lung