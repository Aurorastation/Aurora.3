/obj/item/organ/internal/parasite/greimorian_eggcluster
	name = "cluster of greimorian eggs"
	icon = 'icons/effects/effects.dmi'
	icon_state = "eggs"
	dead_icon = "eggs"

	organ_tag = BP_GREIMORIAN_EGGCLUSTER
	parent_organ = BP_CHEST
	subtle = 1

	/// ~2 minutes/stage (at two seconds/tick)
	stage_interval = 60

	max_stage = 5

	origin_tech = list(TECH_BIO = 4)

	egg = /singleton/reagent/toxin/greimorian_eggs

	/// Everyone's favorite-named variable
	var/gestating_spiderlings = 0

	var/last_crawling_msg = 0

	/// True when it has ruptured; end additional behavior.
	var/ruptured = FALSE

/obj/item/organ/internal/parasite/greimorian_eggcluster/process()
	..()

	if(!owner && gestating_spiderlings)
		return

	if(ruptured)
		return

	var/obj/item/organ/external/affecting_organ = owner.organs_by_name[parent_organ]

	if(prob(8))
		gestating_spiderlings += 1

	if(prob(5))
		to_chat(affecting_organ.owner, SPAN_NOTICE("Your [affecting_organ.name] itches."))

	if(prob(33))
		owner.adjustNutritionLoss(3)

	if(stage >= 2) //after ~2.5 minutes
		if(prob(8))
			gestating_spiderlings += rand(1,2)

		if(prob(33))
			owner.adjustNutritionLoss(4)
		if(prob(5))
			owner.emote("whimper")
		if(prob(3))
			to_chat(owner, SPAN_WARNING(pick("You feel nauseous and hungry at the same time.", "You feel a burning pain in your [parent_organ].", "Your sense of balance seems broken.")))

	if(stage >= 3)  //after ~5 minutes
		if(prob(8))
			gestating_spiderlings += rand(1,3)

		if(prob(33))
			owner.adjustNutritionLoss(5)
		if(prob(10))
			affecting_organ.take_damage(rand(1,3))
			owner.adjustHalLoss(8)
			if(world.time > last_crawling_msg + 15 SECONDS)
				last_crawling_msg = world.time
				owner.visible_message(
					SPAN_WARNING("You think you see something moving around in \the [owner.name]'s [affecting_organ.name]."),
					SPAN_WARNING("You [prob(25) ? "see" : "feel"] something large move around in your [affecting_organ.name]!"))
		if(prob(1))
			owner.seizure(0.4)

	if(stage >= 4)  //after ~7.5 minutes
		if(prob(8))
			gestating_spiderlings += rand(1,4)

		if(prob(5))
			owner.reagents.add_reagent(/singleton/reagent/toxin/greimorian_eggs, (gestating_spiderlings / 3))
			owner.adjustHalLoss(12)
			to_chat(owner, SPAN_WARNING(pick("A sharp, caustic pain boils out from your [affecting_organ.name]!", "You can feel the flesh of your [affecting_organ.name] beginning to bulge!", "It's going to burst! Your [affecting_organ.name] is going to burst!")))
		if(prob(5))
			owner.seizure(0.5)

	if(stage >= 5)  //after ~9 minutes
		if(prob(8))
			gestating_spiderlings += rand(1,5)

		if(prob(10))
			owner.seizure(0.6)
		if(prob(5))
			ruptured = TRUE
			owner.adjustHalLoss(75)
			owner.seizure()
			src.owner.emote("scream")
			owner.visible_message(
				SPAN_DANGER("You can see the flesh of [owner.name]'s [affecting_organ.name] begin rippling violently!"),
				SPAN_DANGER("An <b>extreme</b>, nauseating pain erupts from your [affecting_organ.name]; you feel something burst inside it. The flesh begins to ripple violently!"))
			addtimer(CALLBACK(src, PROC_REF(rupture)), rand(30, 50))

/obj/item/organ/internal/parasite/greimorian_eggcluster/Destroy()
	var/obj/item/organ/external/affecting_organ = owner.organs_by_name[parent_organ]
	to_chat(src.owner, SPAN_WARNING("Mercifully, you feel something finally dissolve in your [affecting_organ.name]..."))
	..()

/**
 * Makes the victim spew out all of the spiderlings it has. It's triggered at the point
 * of the parasite hitting stage 5 of its growth.
 *
 * The proc also drops the limb if it's on a human, or gibs it if it's on the floor. For
 * maximum drama, of course!
 */
/obj/item/organ/internal/parasite/greimorian_eggcluster/proc/rupture()
	var/obj/item/organ/external/victim_external_organ = owner.organs_by_name[parent_organ]
	if(src.owner)
		src.owner.visible_message(
			SPAN_DANGER("A group of [src] burst out of [owner]'s [victim_external_organ.name]!"),
			SPAN_DANGER("A group of [src] burst out of your [victim_external_organ.name]!"))
		src.owner.emote("scream")

	var/target_loc = src.owner ? src.owner.loc : src.loc
	for(var/i = 0 to gestating_spiderlings)
		// For details on the spiderlings, check out 'code\game\objects\effects\spiders.dm'
		new /obj/effect/spider/spiderling(target_loc, src, 3)

	if(victim_external_organ.owner)
		victim_external_organ.droplimb(0, DROPLIMB_BLUNT)

	remove_parasite()
