GLOBAL_LIST(fusion_reactions)

/singleton/fusion_reaction
	/// Primary reactant.
	var/p_react = ""
	/// Minimum # of p required to react.
	var/minimum_p_react = 0
	/// Secondary reactant.
	var/s_react = ""
	/// This is the minimum energy to initiate a given reaction.
	var/minimum_energy_level = 150000
	/// This is the minimum energy to continue a given reaction, once started. Used for halting energy-consuming reactions.
	/// When not set, it will default to (minimum_energy_level * 0.8) to avoid tanking plasma temp in a single tick.
	var/minimum_reaction_temperature
	var/energy_consumption = 0
	var/energy_production = 0
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

/singleton/fusion_reaction/deuterium_tritium
	p_react = GAS_DEUTERIUM
	s_react = GAS_TRITIUM
	energy_consumption = 1
	energy_production = 20
	products = list(GAS_HELIUM = 1)
	instability = 1.5
	// deut-trit bad!!!
	radiation = 200
	minimum_energy_level = 2500
	priority = 1

/singleton/fusion_reaction/hydrogen_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_HYDROGEN
	energy_consumption = 1
	energy_production = 12
	products = list(GAS_DEUTERIUM = 1)
	radiation = 3
	priority = 1

/singleton/fusion_reaction/hydrogen_deuterium
	p_react = GAS_HYDROGEN
	s_react = GAS_DEUTERIUM
	energy_consumption = 2
	energy_production = 12
	products = list(GAS_HELIUMFUEL = 1)
	radiation = 16
	priority = 2

/singleton/fusion_reaction/helium3_hydrogen
	p_react = GAS_HELIUMFUEL
	s_react = GAS_HYDROGEN
	energy_consumption = 4
	energy_production = 16
	products = list(GAS_HYDROGEN = 2)
	radiation = 32
	instability = 1
	priority = 10

/singleton/fusion_reaction/helium_helium
	p_react = GAS_HELIUM
	s_react = GAS_HELIUM
	energy_consumption = 3
	energy_production = 18
	products = list(GAS_DEUTERIUM = 2, GAS_HYDROGEN = 1)
	radiation = 6
	instability = 0.5
	minimum_energy_level = 150000
	priority = 12

/singleton/fusion_reaction/helium3_helium
	p_react = GAS_HELIUMFUEL
	s_react = GAS_HELIUM
	energy_consumption = 3
	energy_production = 18
	products = list("beryllium-7" = 1)
	radiation = 6
	minimum_energy_level = 300000
	priority = 13

/singleton/fusion_reaction/beryllium7_decay
	p_react = "beryllium-7"
	s_react = "beryllium-7"
	energy_consumption = 2
	energy_production = 7
	products = list("lithium" = 2)
	radiation = 54
	instability = 1
	minimum_energy_level = 300000
	priority = 15

/singleton/fusion_reaction/lithium_hydrogen
	p_react = "lithium"
	s_react = GAS_HYDROGEN
	energy_consumption = 3
	energy_production = 5
	products = list(GAS_DEUTERIUM = 1, GAS_HELIUM = 1)
	radiation = 22
	instability = 0.3
	minimum_energy_level = 480000
	priority = 16

/singleton/fusion_reaction/deuterium_lithium
	p_react = "lithium"
	minimum_p_react = 2000
	s_react = GAS_DEUTERIUM
	energy_consumption = 1
	energy_production = 2
	radiation = 18
	instability = 1
	products = list(GAS_TRITIUM = 2)
	minimum_energy_level = 2000000
	priority = 30

/singleton/fusion_reaction/beryllium7_hydrogen
	p_react = "beryllium-7"
	s_react = GAS_HYDROGEN
	energy_consumption = 4
	energy_production = 12
	products = list("boron-8" = 1)
	radiation = 3
	instability = 0.5
	minimum_energy_level = 720000
	priority = 17

/singleton/fusion_reaction/boron8_decay
	p_react = "boron-8"
	s_react = "boron-8"
	energy_consumption = 4
	energy_production = 6
	products = list("beryllium-8" = 2)
	radiation = 64
	instability = 2.5
	priority = 18

/singleton/fusion_reaction/beryllium8_fission
	p_react = "beryllium-8"
	s_react = "beryllium-8"
	energy_consumption = 10
	energy_production = 16
	products = list(GAS_HELIUM = 2)
	radiation = 36
	instability = 3
	priority = 19

// This is just to delete lone beryllium-8 reactants that might get left over somehow
/singleton/fusion_reaction/beryllium8_hydrogen
	p_react = "beryllium-8"
	s_react = GAS_HYDROGEN
	energy_consumption = 10
	energy_production = 16
	products = list(GAS_HELIUM = 2)
	radiation = 36
	priority = 18

/singleton/fusion_reaction/helium3_helium3
	p_react = GAS_HELIUMFUEL
	s_react = GAS_HELIUMFUEL
	energy_consumption = 2
	energy_production = 96
	products = list(GAS_HELIUM = 1, GAS_HYDROGEN = 2)
	radiation = 1
	minimum_energy_level = 1400000
	priority = 30

// bad!!!
/singleton/fusion_reaction/oxygen_oxygen
	p_react = GAS_OXYGEN
	s_react = GAS_OXYGEN
	energy_consumption = 10
	energy_production = 0
	instability = 8
	radiation = 250
	products = list("silicon"= 1)

// Iron poisoning
/singleton/fusion_reaction/iron_poison
	p_react = "iron"
	s_react = "iron"
	energy_consumption = 64
	energy_production = 0
	radiation = 48
	priority = 35

// Gold poisoning
/singleton/fusion_reaction/gold_poison
	p_react = "gold"
	s_react = "gold"
	energy_consumption = 96
	energy_production = 0
	radiation = 96

/singleton/fusion_reaction/iron_iron
	p_react = "iron"
	s_react = "iron"
	// Much of the gold is going to be consumed to poison the reactor.
	products = list("silver" = 12, "gold" = 32, "platinum" = 12, "lead" = 12, ) // Not realistic but w/e
	energy_consumption = 64
	energy_production = 0
	instability = 4
	radiation = 12
	minimum_energy_level = 1800000
	priority = 40

/singleton/fusion_reaction/mhydrogen
	p_react = "mhydrogen"
	p_react = "mhydrogen"
	energy_consumption = 0
	energy_production = 50
	instability = -6
	radiation = 10
	products = list("deuterium" = 1, "osmium" = 3)
	minimum_energy_level = 800000

/singleton/fusion_reaction/iron_phoron
	p_react = "iron"
	s_react = GAS_PHORON
	minimum_energy_level = 3000000
	energy_consumption = 64
	energy_production = 18
	radiation = 64
	instability = 6.5
	products = list("uranium" = 30, "borosilicate glass" = 80, "osmium" = 20) // Psuedoscience but here we are
	priority = 40

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
