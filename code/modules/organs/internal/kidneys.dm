/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = BP_KIDNEYS
	parent_organ = BP_GROIN
	robotic_name = "prosthetic kidneys"
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 10
	toxin_type = CE_NEPHROTOXIC

/obj/item/organ/internal/kidneys/process()

	..()

	if(!owner)
		return

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	var/singleton/reagent/drink/coffee = REAGENT_VOLUME(owner.reagents, /singleton/reagent/drink/coffee)
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1)
		else if(is_broken())
			owner.adjustToxLoss(0.3)

	if(is_bruised())
		if(prob(5) && REAGENT_VOLUME(reagents, /singleton/reagent/potassium) < 5)
			reagents.add_reagent(/singleton/reagent/potassium, REM*5)
	if(is_broken())
		if(REAGENT_VOLUME(owner.reagents, /singleton/reagent/potassium) < 15)
			owner.reagents.add_reagent(/singleton/reagent/potassium, REM*2)

	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(!owner.chem_effects[CE_ANTITOXIN])
		if(prob(33))
			if(is_broken())
				owner.adjustToxLoss(0.5)
			if(status & ORGAN_DEAD)
				owner.adjustToxLoss(1)
