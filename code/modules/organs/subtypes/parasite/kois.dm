/obj/item/organ/internal/parasite/kois
	name = "k'ois mycosis"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "kois-on"
	dead_icon = "kois-off"

	organ_tag = "kois"

	parent_organ = BP_CHEST
	stage_interval = 150
	drug_resistance = 1

	origin_tech = list(TECH_BIO = 3)

	egg = /singleton/reagent/kois

/obj/item/organ/internal/parasite/kois/process()
	..()

	if (!owner)
		return

	if(prob(10) && (owner.can_feel_pain()))
		to_chat(owner, SPAN_WARNING("You feel a stinging pain in your abdomen!"))
		owner.visible_message("<b>[owner]</b> winces slightly.")
		owner.adjustHalLoss(5)

	else if(prob(10) && !(owner.species.flags & NO_BREATHE))
		owner.emote("cough")

	else if(prob(10) && !(owner.species.flags & NO_BREATHE))
		owner.visible_message("<b>[owner]</b> coughs up blood!")
		owner.drip(10)

	if(stage >= 2)
		if(prob(10) && !(owner.species.flags & NO_BREATHE))
			owner.visible_message("<b>[owner]</b> gasps for air!")
			owner.losebreath += 5

	if(stage >= 3)
		set_light(1, l_color = "#E6E600")
		if(prob(10))
			to_chat(owner, SPAN_WARNING("You feel something squirming inside of you!"))
			owner.reagents.add_reagent(/singleton/reagent/toxin/phoron, 8)
			owner.reagents.add_reagent(/singleton/reagent/kois, 5)

	if(stage >= 4)
		if(prob(10))
			to_chat(owner, SPAN_DANGER("You feel something alien coming up your throat!"))
			owner.emote("cough")

			var/turf/T = get_turf(owner)

			var/datum/reagents/R = new/datum/reagents(100)
			R.add_reagent(/singleton/reagent/kois,10)
			R.add_reagent(/singleton/reagent/toxin/phoron,10)
			var/datum/effect/effect/system/smoke_spread/chem/spores/S = new("koisspore")

			S.attach(T)
			S.set_up(R, 20, 0, T, 40)
			S.start()

			if(owner.can_feel_pain())
				owner.emote("scream")
				owner.adjustHalLoss(15)
				owner.drip(15)
				owner.delayed_vomit()

