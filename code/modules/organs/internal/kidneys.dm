/obj/item/organ/internal/kidneys
	name = "left kidney"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = BP_KIDNEYS
	parent_organ = BP_GROIN
	robotic_name = "prosthetic left kidneys"
	robotic_sprite = "kidneys-prosthetic"
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
	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY / 2)
		else if(is_broken())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY / 2)

	if(is_bruised())
		if(prob(5) && reagents.get_reagent_amount("potassium") < 5)
			reagents.add_reagent("potassium", REM*5 / 2)
	if(is_broken())
		if(owner.reagents.get_reagent_amount("potassium") < 15)
			owner.reagents.add_reagent("potassium", REM*2 / 2)

	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(!owner.chem_effects[CE_ANTITOXIN])
		if(prob(33))
			if(is_broken())
				owner.adjustToxLoss(0.3)
			if(status & ORGAN_DEAD)
				owner.adjustToxLoss(0.5)

/obj/item/organ/internal/kidneys/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/hemostat))
		if(src.organ_tag == BP_KIDNEYS)
			to_chat(usr, "You prepare the kidney for placement on the right side.")
			organ_tag = BP_RKIDNEYS
			name = "right kidney"
		else if(organ_tag == BP_RKIDNEYS)
			organ_tag = BP_KIDNEYS
			to_chat(usr, "You prepare the kidney for placement on the left side.")
			name = "left kidney"
/obj/item/organ/internal/kidneys/right
	name = "right kidney"
	robotic_name = "prosthetic right kidney"
	organ_tag = BP_RKIDNEYS
