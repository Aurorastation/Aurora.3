/obj/item/organ/internal/parasite/heartworm
	name = "bundle of heart flukes"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "helminth"
	dead_icon = "helminth_dead"

	organ_tag = BP_WORM_HEART
	parent_organ = BP_CHEST
	subtle = 1

	stage_interval = 450 //~7.5 minutes/stage

	origin_tech = list(TECH_BIO = 4)

	egg = /singleton/reagent/toxin/heartworm_eggs

/obj/item/organ/internal/parasite/heartworm/process()
	..()

	var/obj/item/organ/internal/heart = owner.internal_organs_by_name[BP_HEART]

	if (!owner)
		return

	if(BP_IS_ROBOTIC(heart))
		recession = 10
		return

	if(prob(4))
		owner.adjustNutritionLoss(10)

	if(stage >= 2) //after ~7.5 minutes
		if(prob(2))
			owner.emote("cough")

	if(stage >= 3)  //after ~15 minutes
		if(prob(7))
			heart.take_damage(rand(2,5))
		if(prob(5))
			to_chat(owner, SPAN_WARNING(pick("Your chest feels tight.", "Your chest is aching.", "You feel a stabbing pain in your chest!", "You feel a painful, tickly sensation within your chest.")))
			owner.adjustHalLoss(15)

	if(stage >= 4)  //after ~22.5 minutes
		if(prob(5))
			owner.reagents.add_reagent(/singleton/reagent/toxin/heartworm_eggs, 2)
			owner.adjustHalLoss(15)
			to_chat(owner, SPAN_WARNING("An <b>extreme</b>, nauseating pain erupts from the centre of your chest!"))
