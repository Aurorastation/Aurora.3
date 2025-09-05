/obj/item/organ/internal/kidneys
	name = "kidneys"
	desc = "Found right above the kidshins."
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

	/// The amount of toxin damage to take per second from coffee while the kidneys are bruised.
	var/bruised_tox_damage_from_coffee = 0.2

	/// The amount of toxin damage to take per second from coffee while the kidneys are broken.
	var/broken_tox_damage_from_coffee = 0.6

	/// Bruised kidneys will leak up to this amount of potassium into the bloodstream.
	var/bruised_max_potassium = 5

	/**
	 * Damaged kidneys leak potassium into the blood when processing any medical chems.
	 * This is the amount of reagents of potassium per second added to the bloodstream while the kidneys are bruised.
	 */
	var/bruised_potassium_per_second = 0.1

	/// Broken kidneys will leak up to this amount of potassium into the bloodstream. This number should generally be higher than the bruised value.
	var/broken_max_potassium = 15

	/**
	 * Damaged kidneys leak potassium into the blood when processing any medical chems.
	 * This is the amount of reagents of potassium per second added to the bloodstream while the kidneys are broken.
	 */
	var/broken_potassium_per_second = 4

	/// The amount of toxin damage per second taken by a body with broken kidneys.
	var/broken_toxin_accumulation_per_second = 0.33

	/// The amount of toxin damage per second taken by a body with dead kidneys.
	var/dead_toxin_accumulation_per_second = 0.66

/obj/item/organ/internal/kidneys/process(seconds_per_tick)
	..()
	if(!owner)
		return

	if(owner.stasis_value > 0) // Decrease the effective tickrate when in stasis.
		seconds_per_tick /= owner.stasis_value

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	if(REAGENT_VOLUME(owner.reagents, /singleton/reagent/drink/coffee))
		if(is_bruised()) 
			owner.adjustToxLoss(bruised_tox_damage_from_coffee * seconds_per_tick)
		else if(is_broken())
			owner.adjustToxLoss(broken_tox_damage_from_coffee * seconds_per_tick)

	if(is_bruised())
		if(REAGENT_VOLUME(reagents, /singleton/reagent/potassium) < bruised_max_potassium)
			reagents.add_reagent(/singleton/reagent/potassium, bruised_potassium_per_second * seconds_per_tick)
	if(is_broken())
		if(REAGENT_VOLUME(owner.reagents, /singleton/reagent/potassium) < broken_max_potassium)
			owner.reagents.add_reagent(/singleton/reagent/potassium, broken_potassium_per_second * seconds_per_tick)

	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(!owner.chem_effects[CE_ANTITOXIN]) // Dylovene fully prevents the toxin accumulation from kidneys.
		if(is_broken())
			owner.adjustToxLoss(broken_toxin_accumulation_per_second * seconds_per_tick)
		if(status & ORGAN_DEAD)
			owner.adjustToxLoss(dead_toxin_accumulation_per_second * seconds_per_tick)
