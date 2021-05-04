/datum/technomancer/spell/gambit
	name = "Gambit"
	desc = "This function causes you to receive a random function, including those which you haven't purchased."
//	enhancement_desc = "Makes results less random and more biased towards what the function thinks you need in your current situation."
	enhancement_desc = "Instead of a purely random spell, it will give you a \"random\" spell."
	spell_power_desc = "Makes certain rare functions possible to acquire via Gambit which cannot be obtained otherwise, if above 100%."
	ability_icon_state = "tech_gambit"
	cost = 50
	obj_path = /obj/item/spell/gambit
	category = UTILITY_SPELLS

/var/global/list/all_technomancer_gambit_spells = subtypesof(/obj/item/spell) - list(
	/obj/item/spell/gambit,
	/obj/item/spell/projectile,
	/obj/item/spell/aura,
	/obj/item/spell/insert,
	/obj/item/spell/spawner,
	/obj/item/spell/summon,
	/obj/item/spell/modifier)

/obj/item/spell/gambit
	name = "gambit"
	desc = "Do you feel lucky?"
	icon_state = "gambit"
	cast_methods = CAST_USE
	aspect = ASPECT_UNSTABLE

/obj/item/spell/gambit/on_use_cast(mob/living/carbon/human/user)
	if(pay_energy(200))
		adjust_instability(3)
		if(check_for_scepter())
			give_new_spell(biased_random_spell())
		else
			give_new_spell(random_spell())
		qdel(src)

/obj/item/spell/gambit/proc/give_new_spell(var/spell_type)
	owner.drop_from_inventory(src, null)
	owner.place_spell_in_hand(spell_type)

// Gives a random spell.
/obj/item/spell/gambit/proc/random_spell()
	var/list/potential_spells = all_technomancer_gambit_spells.Copy()
	return pick(potential_spells)

// Gives a "random" spell.
/obj/item/spell/gambit/proc/biased_random_spell()
	var/list/potential_spells = list()

	// First the spell will concern itself with the health of the technomancer.
	if(prob(owner.getBruteLoss() + owner.getBruteLoss() * 2)) // Having 20 brute means a 40% chance of being added to the pool.
		if(!owner.isSynthetic())
			potential_spells |= /obj/item/spell/modifier/mend_life
		else
			potential_spells |= /obj/item/spell/modifier/mend_synthetic

	// Second, the spell will try to prepare the technomancer for threats.
	var/hostile_mobs = 0 // Counts how many hostile mobs.  Higher numbers make it more likely for AoE spells to be chosen.

	for(var/mob/living/L in view(owner))
		// Spiders, carp... bears.
		if(istype(L, /mob/living/simple_animal))
			var/mob/living/simple_animal/SM = L
			if(!is_ally(SM))
				hostile_mobs++
				if(SM.summoned || SM.supernatural) // Our creations might be trying to kill us.
					potential_spells |= /obj/item/spell/abjuration

		// Always assume borgs are hostile.
		if(istype(L, /mob/living/silicon/robot))
			if(!istype(L, /mob/living/silicon/robot/drone)) // Drones are okay, however.
				hostile_mobs++
				potential_spells |= /obj/item/spell/projectile/ionic_bolt

		// Finally we get to humanoids.
		if(istype(L, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = L
			if(is_ally(H)) // Don't get scared by our apprentice.
				continue

			for(var/obj/item/I in list(H.l_hand, H.r_hand))
				// Guns are scary.
				if(istype(I, /obj/item/gun)) // Toy guns will count as well but oh well.
					hostile_mobs++
					continue
				// Strong melee weapons are scary as well.
				else if(I.force >= 15)
					hostile_mobs++
					continue

	if(hostile_mobs)
		potential_spells |= /obj/item/spell/shield
		potential_spells |= /obj/item/spell/reflect
		potential_spells |= /obj/item/spell/targeting_matrix
		potential_spells |= /obj/item/spell/warp_strike

		if(hostile_mobs >= 3) // Lots of baddies, give them AoE.
			potential_spells |= /obj/item/spell/spawner/fire_blast
			potential_spells |= /obj/item/spell/condensation
			potential_spells |= /obj/item/spell/aura/frost
		else
			potential_spells |= /obj/item/spell/projectile/beam
			potential_spells |= /obj/item/spell/projectile/overload
			potential_spells |= /obj/item/spell/projectile/force_missile
			potential_spells |= /obj/item/spell/projectile/lightning

	// Third priority is recharging the core.
	if(core.energy / core.max_energy <= 0.5)
		potential_spells |= /obj/item/spell/energy_siphon
		potential_spells |= /obj/item/spell/instability_tap

	// Fallback method in case nothing gets added.
	if(!potential_spells.len)
		potential_spells = all_technomancer_gambit_spells.Copy()

	return pick(potential_spells)