GLOBAL_LIST(fusion_reactions)

/singleton/fusion_reaction
	/// Primary reactant.
	var/p_react = ""
	/// Secondary reactant.
	var/s_react = ""
	var/minimum_energy_level = 1
	var/energy_consumption = 0
	var/energy_production = 0
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/minimum_reaction_temperature = 2000
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
 * Proton-Proton Branch I Chain
 * * Low minimum temperature
 * * Minimal power output
 * * Moderate radiation output
 */
/singleton/fusion_reaction/ppi_hydrogen_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_HYDROGEN
	energy_consumption = 1
	energy_production = 1
	products = list(GAS_DEUTERIUM = 1)
	radiation = 3
	priority = 1

/singleton/fusion_reaction/ppi_hydrogen_deuterium
	p_react = GAS_HYDROGEN
	s_react = GAS_DEUTERIUM
	energy_consumption = 2
	energy_production = 2
	products = list(GAS_HELIUMFUEL = 1)
	radiation = 4
	priority = 2

/singleton/fusion_reaction/ppi_helium3_helium3
	p_react = GAS_HELIUMFUEL
	s_react = GAS_HELIUMFUEL
	energy_consumption = 2
	energy_production = 3
	products = list(GAS_HELIUM = 1, GAS_HYDROGEN = 2)
	radiation = 1
	priority = 3

/**
 * Proton-Proton Branch II Chain
 * * Low-moderate minimum temperature
 * * Low power output
 * * High radiation output
 */
/singleton/fusion_reaction/ppii_helium3_helium
	p_react = GAS_HELIUMFUEL
	s_react = GAS_HELIUM
	energy_consumption = 3
	energy_production = 4
	products = list("beryllium" = 1)
	radiation = 6
	minimum_reaction_temperature = 36000
	priority = 13

/singleton/fusion_reaction/ppii_beryllium_decay
	p_react = "beryllium"
	s_react = "beryllium"
	energy_consumption = 4
	energy_production = 4
	products = list("lithium" = 2)
	radiation = 24
	instability = 2
	minimum_reaction_temperature = 36000
	priority = 13

/singleton/fusion_reaction/ppii_lithium_hydrogen
	p_react = "lithium"
	s_react = GAS_HYDROGEN
	energy_consumption = 3
	energy_production = 5
	products = list(GAS_HELIUM = 2)
	radiation = 2
	minimum_reaction_temperature = 36000
	priority = 15

/**
 * Proton-Proton Branch III Chain
 * * Moderate minimum temperature
 * * Moderate power output
 * * Low radiation output
 */
/singleton/fusion_reaction/ppiii_beryllium_hydrogen
	p_react = "beryllium"
	s_react = GAS_HYDROGEN
	energy_consumption = 3
	energy_production = 8
	products = list("boron" = 1)
	radiation = 3
	minimum_reaction_temperature = 72000
	priority = 20

/singleton/fusion_reaction/ppii_boron_decay
	p_react = "boron"
	s_react = "boron"
	energy_consumption = 3
	energy_production = 5
	products = list("beryllium" = 2)
	radiation = 4
	instability = 3
	minimum_reaction_temperature = 48000
	priority = 24

/singleton/fusion_reaction/deuterium_lithium
	p_react = GAS_DEUTERIUM
	s_react = "lithium"
	energy_consumption = 2
	energy_production = 0
	radiation = 3
	products = list(GAS_TRITIUM= 1)
	instability = 4
	minimum_reaction_temperature = 64000
	priority = 25

/singleton/fusion_reaction/deuterium_tritium
	p_react = GAS_DEUTERIUM
	s_react = GAS_TRITIUM
	energy_consumption = 1
	energy_production = 6
	products = list(GAS_HELIUM = 1)
	instability = 0.5
	radiation = 8
	priority = 25

// Unideal/material production reactions
/singleton/fusion_reaction/oxygen_oxygen
	p_react = GAS_OXYGEN
	s_react = GAS_OXYGEN
	energy_consumption = 10
	energy_production = 0
	instability = 8
	radiation = 30
	products = list("silicon"= 1)

/singleton/fusion_reaction/iron_iron
	p_react = "iron"
	s_react = "iron"
	products = list("silver" = 12, "gold" = 12, "platinum" = 12, "lead" = 12, ) // Not realistic but w/e
	energy_consumption = 14
	energy_production = 0
	instability = 2
	radiation = 12
	minimum_reaction_temperature = 250000

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

// Helium reduction
/singleton/fusion_reaction/helium_boron
	p_react = GAS_HELIUM
	s_react = "boron"
	minimum_energy_level = 200000
	energy_consumption = 3
	energy_production = 12
	radiation = 9
	instability = 4
	priority = 35

// Any now we go even further beyond!!!!
/singleton/fusion_reaction/iron_phoron
	p_react = "iron"
	s_react = GAS_PHORON
	minimum_energy_level = 300000
	energy_consumption = 10
	energy_production = 4
	radiation = 30
	instability = 5
	products = list("uranium" = 20, "borosilicate glass" = 80) // Psuedoscience but here we are
	priority = 5
