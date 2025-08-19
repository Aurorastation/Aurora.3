GLOBAL_LIST(fusion_reactions)

/**
 * Overview of fusion reactions. These largely follow real life, but have been simplified/gamified to fit our mechanics.
 * TLDR:
 * * proton-proton chain for minimal setup and basic power generation
 * * deut-trit, helium-3, aneutronic boron more advanced, productive standards
 * * weird shit after that
 *
 * p-pI branch ("hydrogen burning")
 * * Low temperatures (3 MK to 18 MK)
 * * Low power output
 * * High stability
 * p-pI reaction scheme
 * * 1 Hydrogen + 1 Hydrogen -> 1 Deuterium
 * * 1 Hydrogen + 1 Deuterium -> 1 Helium-3
 * * 1 Helium-3 + 1 Helium-3 -> 2 Hydrogen + 1 Helium-4
 *
 * p-pII branch ("lithium burning")
 * * Moderate temperatures (18 MK to 30 MK)
 * * Moderate power output
 * * Mid-high stability
 * p-pII reaction scheme
 * * 1 Hydrogen + 1 Hydrogen -> 1 Deuterium
 * * 1 Hydrogen + 1 Deuterium -> 1 Helium-3
 * * 1 Helium-3 + 1 Helium-4 -> Beryllium
 * * 1 Beryllium + 1 Beryllium -> 2 Lithium
 * * 1 Lithium + 1 Hydrogen -> 2 Helium-4
 *
 * WIP WIP WIP
 *
 */
/singleton/fusion_reaction
	/// Primary reactant.
	var/p_react = ""
	/// How much of the primary reactant to consume per reaction (multiplier).
	var/p_react_count = 1
	/// Secondary reactant.
	var/s_react = ""
	// How much of the secondary reactant to consume per reaction (multiplier).
	var/s_react_count = 1
	var/minimum_energy_level = 1
	var/minimum_reaction_temperature = 100
	/** 
	 * Some reactions are superseded by others above certain temps.
	 * Leaving this 0 makes reaction always possible above the minimum.
	 */
	var/maximum_reaction_temperature = 0
	var/energy_consumption = 0
	var/energy_production = 0
	/// Excess radiation produced. Usually gamma or free neutrons.
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/priority = 100

/singleton/fusion_reaction/proc/handle_reaction_special(obj/effect/fusion_em_field/holder)
	return 0

/proc/get_fusion_reaction(p_react, s_react, m_energy)
	if(!GLOB.fusion_reactions)
		GLOB.fusion_reactions = list()
		for(var/rtype in typesof(/singleton/fusion_reaction) - /singleton/fusion_reaction)
			var/singleton/fusion_reaction/cur_reaction = new rtype()
			if(!GLOB.fusion_reactions[cur_reaction.p_react])
				GLOB.fusion_reactions[cur_reaction.p_react] = list()
			GLOB.fusion_reactions[cur_reaction.p_react][cur_reaction.s_react] = cur_reaction
			if(!GLOB.fusion_reactions[cur_reaction.s_react])
				GLOB.fusion_reactions[cur_reaction.s_react] = list()
			GLOB.fusion_reactions[cur_reaction.s_react][cur_reaction.p_react] = cur_reaction

	if(GLOB.fusion_reactions.Find(p_react))
		var/list/secondary_reactions = GLOB.fusion_reactions[p_react]
		if(secondary_reactions.Find(s_react))
			return GLOB.fusion_reactions[p_react][s_react]

/**
 * Gaseous Reactants
 * * Hydrogen
 * * Deuterium
 * * Tritium
 * * Helium
 * * Helium-3
 * * Oxygen
 * * Phoron
 *
 * Solid Reactants
 * * Lithium
 * * Boron
 * * Beryllium
 * * Carbon
 * * 
 * * Iron
 * * Phoron
 * * Supermatter

 */ 
//  deuterium
//  tritium
//  phoron
//  supermatter

// reagent fuels
// hydrogen
//  helium
//  lithium
//  boron

// Basic power production reactions.
/// Hydrogen Burning (ppI reaction)
/singleton/fusion_reaction/ppi_hydrogen_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_HYDROGEN
	energy_consumption = 1
	energy_production = 2
	products = list(GAS_DEUTERIUM = 1)
	priority = 10

/// Deuterium Burning (ppI reaction)
/singleton/fusion_reaction/ppi_deuterium_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_DEUTERIUM
	energy_consumption = 1
	energy_production = 2
	products = list(GAS_HELIUM = 1)
	priority = 0

/// Helium Burning (proton-proton branch I reaction)
/singleton/fusion_reaction/ppi_helium_helium
	p_react = GAS_HELIUM
	s_react = GAS_HELIUM
	energy_consumption = 3
	energy_production = 1
	radiation = 4
	products = list(GAS_HELIUM = 1, GAS_HYDROGEN = 2)
	priority = 0

/// Deuterium-Tritium Fusion (proton-proton branch I reaction)
/singleton/fusion_reaction/deuterium_tritium
	p_react = GAS_DEUTERIUM
	s_react = GAS_TRITIUM
	energy_consumption = 1
	energy_production = 2
	products = list(GAS_HELIUM = 1)
	instability = 1
	radiation = 3

// Advanced production reactions (todo)
/singleton/fusion_reaction/deuterium_helium
	p_react = GAS_DEUTERIUM
	s_react = GAS_HELIUM
	s_react_count = 2
	energy_consumption = 1
	energy_production = 5
	radiation = 2



/singleton/fusion_reaction/deuterium_lithium
	p_react = GAS_DEUTERIUM
	s_react = "lithium"
	energy_consumption = 2
	energy_production = 0
	radiation = 3
	products = list(GAS_TRITIUM= 1)
	instability = 1

// Unideal/material production reactions
/singleton/fusion_reaction/oxygen_oxygen
	p_react = GAS_OXYGEN
	s_react = GAS_OXYGEN
	energy_consumption = 10
	energy_production = 0
	instability = 5
	radiation = 5
	products = list("silicon"= 1)

/singleton/fusion_reaction/iron_iron
	p_react = "iron"
	s_react = "iron"
	products = list("silver" = 10, "gold" = 10, "platinum" = 10) // Not realistic but w/e
	energy_consumption = 10
	energy_production = 0
	instability = 2
	minimum_reaction_temperature = 10000

/singleton/fusion_reaction/phoron_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_PHORON
	energy_consumption = 10
	energy_production = 0
	instability = 5
	products = list("mhydrogen" = 1)
	minimum_reaction_temperature = 8000

// VERY UNIDEAL REACTIONS.
/singleton/fusion_reaction/phoron_supermatter
	p_react = "supermatter"
	s_react = GAS_PHORON
	energy_consumption = 0
	energy_production = 5
	radiation = 40
	instability = 20

/singleton/fusion_reaction/phoron_supermatter/handle_reaction_special(obj/effect/fusion_em_field/holder)

	wormhole_event(GetConnectedZlevels(holder))

	var/turf/origin = get_turf(holder)
	holder.Rupture()
	qdel(holder)
	var/radiation_level = rand(100, 200)

	// Copied from the SM for proof of concept. //Not any more --Cirra //Use the whole z proc --Leshana
	SSradiation.z_radiate(locate(1, 1, holder.z), radiation_level, 1)

	for(var/mob/living/mob in GLOB.living_mob_list)
		var/turf/T = get_turf(mob)
		if(T && (holder.z == T.z))
			if(istype(mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mob
				H.add_hallucinate(rand(100,150))

	for(var/obj/machinery/fusion_fuel_injector/I in range(world.view, origin))
		if(I.cur_assembly && I.cur_assembly.fuel_type == MATERIAL_SUPERMATTER)
			explosion(get_turf(I), 6)
			if(I && I.loc)
				qdel(I)

	sleep(5)
	explosion(origin, 8)

	return 1


// High end reactions.
/singleton/fusion_reaction/boron_hydrogen
	p_react = "boron"
	s_react = GAS_HYDROGEN
	minimum_energy_level = 15000
	energy_consumption = 3
	energy_production = 12
	radiation = 3
	instability = 2.5
	products = list(GAS_HELIUM = 1)

// Any now we go even further beyond!!!!
/singleton/fusion_reaction/iron_phoron
	p_react = "iron"
	s_react = GAS_PHORON
	minimum_energy_level = 100000
	energy_consumption = 10
	energy_production = 4
	radiation = 30
	instability = 5
	products = list("uranium" = 10, "lead" = 10, "borosilicate glass" = 10) // Psuedoscience but here we are
