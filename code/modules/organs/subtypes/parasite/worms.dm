/obj/item/organ/internal/parasite/nerveworm
	name = "bundle of nerve flukes"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "helminth"
	dead_icon = "helminth_dead"

	organ_tag = BP_WORM_NERVE
	parent_organ = BP_L_ARM //if desperate, can lop your arm off to remove the infection :)
	subtle = 1

	origin_tech = list(TECH_BIO = 4)

	egg = /singleton/reagent/toxin/nerveworm_eggs

/obj/item/organ/internal/parasite/nerveworm/process()
	..()

	if (!owner)
		return

	if(prob(4))
		owner.adjustNutritionLoss(10)

	if(stage >= 2) //after ~5 minutes
		owner.confused = max(owner.confused, 10)

	if(stage >= 3) //after ~10 minutes
		owner.slurring = max(owner.slurring, 100)
		owner.drowsiness = max(owner.drowsiness, 20)
		if(prob(1))
			owner.delayed_vomit()
		if(prob(2))
			to_chat(owner, SPAN_WARNING(pick("You feel a tingly sensation in your fingers.", "Is that pins and needles?", "An electric sensation jolts its way up your left arm.", "You smell something funny.", "You taste something funny.")))

	if(stage >= 4) //after ~15 minutes
		if(prob(2))
			to_chat(owner, SPAN_WARNING(pick("A deep, tingling sensation paralyses your left arm.", "You feel as if you just struck your funny bone.", "You feel a pulsing sensation within your left arm.")))
			owner.emote(pick("twitch", "shiver"))
			owner.stuttering = 20
		if(prob(1))
			owner.seizure()
		if(prob(5))
			owner.reagents.add_reagent(/singleton/reagent/toxin/nerveworm_eggs, 2)
			owner.adjustHalLoss(15)
			to_chat(owner, SPAN_WARNING("An <b>extreme</b>, nauseating pain erupts from deep within your left arm!"))
