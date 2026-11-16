// Corporate Research Bounty System for the Destructive Analyzer

GLOBAL_LIST_INIT(research_bounty_corporations, list(
	"Hephaestus Industries",
	"NanoTrasen",
	"Zavodskoi Interstellar",
	"Idris Incorporated",
	"Zeng-Hu Pharmaceuticals",
	"Orion Express"
))

/datum/research_bounty
	var/id = ""
	var/category = "firearms"
	var/corporation = "NanoTrasen"
	var/list/allowed_corporations = null
	var/title = "Research Request"
	var/desc = ""
	var/list/criteria = list()
	var/reward_points = 1500
	var/completed = FALSE

/datum/research_bounty/New()
	..()
	if(length(allowed_corporations))
		corporation = pick(allowed_corporations)
	else
		corporation = pick(GLOB.research_bounty_corporations)

/datum/research_bounty/proc/matches_item(obj/item/I)
	return FALSE

/datum/research_bounty/proc/to_tgui_data(obj/item/loaded_item)
	return list(
		"id" = id,
		"category" = category,
		"corporation" = corporation,
		"title" = title,
		"description" = desc,
		"criteria" = criteria.Copy(),
		"reward_points" = reward_points,
		"matches_loaded" = loaded_item ? matches_item(loaded_item) : FALSE
	)

// =========================================================================
// Category 1: Custom Firearm Data (Prototype Modular Energy Weapons)
// =========================================================================
/datum/research_bounty/firearm
	category = "firearms"
	allowed_corporations = list("NanoTrasen", "Zavodskoi Interstellar", "Zeng-Hu Pharmaceuticals")

/datum/research_bounty/firearm/proc/get_gun_damage(obj/item/gun/energy/laser/prototype/P)
	var/l_modified_damage = 1 / max(1, P.burst - 1)
	for(var/obj/item/laser_components/l_component in list(P.capacitor, P.focusing_lens, P.modulator) + P.gun_mods)
		if(l_component.damage != 0)
			l_modified_damage *= l_component.damage
	return round(min(60, l_modified_damage), 1)

/datum/research_bounty/firearm/proc/get_gun_max_shots(obj/item/gun/energy/laser/prototype/P)
	var/l_modified_max_shots = 1
	for(var/obj/item/laser_components/l_component in list(P.capacitor, P.focusing_lens, P.modulator) + P.gun_mods)
		if(l_component.shots != 0)
			l_modified_max_shots *= l_component.shots
	return max(P.max_shots, round(l_modified_max_shots))

/datum/research_bounty/firearm/burst_carbine
	title = "High-Burst Prototype Carbine"
	reward_points = 1500
	allowed_corporations = list("NanoTrasen", "Zavodskoi Interstellar")
	criteria = list("Prototype Energy Weapon", "Burst >= 3", "Reliability >= 65%")

/datum/research_bounty/firearm/burst_carbine/New()
	..()
	desc = "[corporation] is requesting telemetry data on a multi-pulse prototype laser weapon capable of sustained burst fire without immediate emitter failure."

/datum/research_bounty/firearm/burst_carbine/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P))
		return FALSE
	return P.burst >= 3 && P.reliability >= 65

/datum/research_bounty/firearm/rapid_fire
	title = "Rapid-Cycling Emitter"
	reward_points = 1600
	criteria = list("Prototype Energy Weapon", "Fire Delay <= 4", "Max Shots >= 15")

/datum/research_bounty/firearm/rapid_fire/New()
	..()
	desc = "[corporation] requires firing cycle data for a fast-cycling energy weapon with sufficient capacitor capacity for prolonged engagements."

/datum/research_bounty/firearm/rapid_fire/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P))
		return FALSE
	return P.fire_delay <= 4 && get_gun_max_shots(P) >= 15

/datum/research_bounty/firearm/heavy_ordnance
	title = "High-Output Energy Cannon"
	reward_points = 2200
	criteria = list("Prototype Energy Weapon", "Damage >= 35", "Reliability >= 70%")

/datum/research_bounty/firearm/heavy_ordnance/New()
	..()
	desc = "[corporation] is commissioning high-yield thermal discharge data from an overdriven prototype weapon."

/datum/research_bounty/firearm/heavy_ordnance/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P))
		return FALSE
	return get_gun_damage(P) >= 35 && P.reliability >= 70

/datum/research_bounty/firearm/armor_piercing
	title = "Armor-Piercing Beam Research"
	reward_points = 2000
	criteria = list("Prototype Energy Weapon", "Armor Penetration >= 20%", "Damage >= 20")

/datum/research_bounty/firearm/armor_piercing/New()
	..()
	desc = "[corporation] seeks focused-beam penetration telemetry capable of defeating standard tactical armor plating."

/datum/research_bounty/firearm/armor_piercing/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P) || !P.projectile_type)
		return FALSE
	var/obj/projectile/proj = P.projectile_type
	return initial(proj.armor_penetration) >= 20 && get_gun_damage(P) >= 20

/datum/research_bounty/firearm/self_sustaining
	title = "Self-Recharging Field Sidearm"
	reward_points = 1800
	criteria = list("Prototype Energy Weapon", "Self-Recharging", "Max Shots >= 10")

/datum/research_bounty/firearm/self_sustaining/New()
	..()
	desc = "[corporation] is evaluating autonomous internal power regeneration architectures for long-duration expeditionary sidearms."

/datum/research_bounty/firearm/self_sustaining/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P))
		return FALSE
	return P.self_recharge && get_gun_max_shots(P) >= 10

/datum/research_bounty/firearm/high_reliability
	title = "Mil-Spec Reliability Standard"
	reward_points = 1700
	criteria = list("Prototype Energy Weapon", "Reliability >= 85%", "At least 2 Mods Installed")

/datum/research_bounty/firearm/high_reliability/New()
	..()
	desc = "[corporation] needs structural stress analysis from a heavily modified prototype that maintains military-grade reliability."

/datum/research_bounty/firearm/high_reliability/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P))
		return FALSE
	return P.reliability >= 85 && length(P.gun_mods) >= 2

/datum/research_bounty/firearm/nonlethal_stun
	title = "Riot Suppression Prototype"
	reward_points = 1600
	allowed_corporations = list("NanoTrasen", "Zeng-Hu Pharmaceuticals")
	criteria = list("Prototype Energy Weapon", "Stun-Capable Projectile", "Max Shots >= 12")

/datum/research_bounty/firearm/nonlethal_stun/New()
	..()
	desc = "[corporation] is funding non-lethal incapacitation research for station security deployments."

/datum/research_bounty/firearm/nonlethal_stun/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P) || !P.projectile_type)
		return FALSE
	var/obj/projectile/proj = P.projectile_type
	return initial(proj.stun) > 0 && get_gun_max_shots(P) >= 12

/datum/research_bounty/firearm/high_capacity
	title = "Extended-Capacitor Carbine"
	reward_points = 1500
	criteria = list("Prototype Energy Weapon", "Max Shots >= 30", "Reliability >= 70%")

/datum/research_bounty/firearm/high_capacity/New()
	..()
	desc = "[corporation] wants discharge telemetry from a high-capacity energy weapon rated for at least 30 shots per charge."

/datum/research_bounty/firearm/high_capacity/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P))
		return FALSE
	return get_gun_max_shots(P) >= 30 && P.reliability >= 70

/datum/research_bounty/firearm/experimental_masterwork
	title = "Experimental Multi-Mod Prototype"
	reward_points = 3000
	criteria = list("Prototype Energy Weapon", "At least 4 Mods Installed", "Damage >= 30", "Reliability >= 75%")

/datum/research_bounty/firearm/experimental_masterwork/New()
	..()
	desc = "[corporation] is offering a premium research grant for a heavily customized flagship prototype combining high output and stability."

/datum/research_bounty/firearm/experimental_masterwork/matches_item(obj/item/I)
	var/obj/item/gun/energy/laser/prototype/P = I
	if(!istype(P))
		return FALSE
	return length(P.gun_mods) >= 4 && get_gun_damage(P) >= 30 && P.reliability >= 75

// =========================================================================
// Category 2: Xenobotany Research Bounties (Plant Seed Traits)
// =========================================================================
/datum/research_bounty/xenobotany
	category = "xenobotany"
	allowed_corporations = list("Zeng-Hu Pharmaceuticals", "NanoTrasen", "Idris Incorporated")

/datum/research_bounty/xenobotany/proc/get_seed(obj/item/I)
	var/obj/item/seeds/S = I
	if(!istype(S))
		return null
	return S.seed

/datum/research_bounty/xenobotany/high_potency
	title = "High-Potency Botanical Cultivar"
	reward_points = 1400
	allowed_corporations = list("Idris Incorporated", "Zeng-Hu Pharmaceuticals")
	criteria = list("Plant Seed Packet", "Potency >= 40", "Yield >= 4")

/datum/research_bounty/xenobotany/high_potency/New()
	..()
	desc = "[corporation] is commissioning genetic sequencing on a high-potency, high-yield designer agricultural cultivar."

/datum/research_bounty/xenobotany/high_potency/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_POTENCY) >= 40 && GET_SEED_TRAIT(S, TRAIT_YIELD) >= 4

/datum/research_bounty/xenobotany/rapid_harvest
	title = "Rapid-Cycle Perennial Strain"
	reward_points = 1600
	allowed_corporations = list("Idris Incorporated", "Zeng-Hu Pharmaceuticals")
	criteria = list("Plant Seed Packet", "Maturation <= 4", "Production <= 3", "Perennial (Repeat Harvest)")

/datum/research_bounty/xenobotany/rapid_harvest/New()
	..()
	desc = "[corporation] requires fast-maturing perennial seed genetics for orbital hydroponic colony rations."

/datum/research_bounty/xenobotany/rapid_harvest/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_MATURATION) <= 4 && GET_SEED_TRAIT(S, TRAIT_PRODUCTION) <= 3 && GET_SEED_TRAIT(S, TRAIT_HARVEST_REPEAT) >= 1

/datum/research_bounty/xenobotany/bioluminescent
	title = "Bioluminescent Flora Specimen"
	reward_points = 1500
	criteria = list("Plant Seed Packet", "Bioluminescent Trait", "Potency >= 25")

/datum/research_bounty/xenobotany/bioluminescent/New()
	..()
	desc = "[corporation] is researching organic photonic emission in stabilized bioluminescent plant strains."

/datum/research_bounty/xenobotany/bioluminescent/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_BIOLUM) >= 1 && GET_SEED_TRAIT(S, TRAIT_POTENCY) >= 25

/datum/research_bounty/xenobotany/voltaic_plant
	title = "Bio-Voltaic Energy Crop"
	reward_points = 1900
	criteria = list("Plant Seed Packet", "Produces Power Trait", "Endurance >= 40")

/datum/research_bounty/xenobotany/voltaic_plant/New()
	..()
	desc = "[corporation] seeks electrochemical botanical samples capable of generating bio-electric charge."

/datum/research_bounty/xenobotany/voltaic_plant/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_PRODUCES_POWER) >= 1 && GET_SEED_TRAIT(S, TRAIT_ENDURANCE) >= 40

/datum/research_bounty/xenobotany/bluespace_flora
	title = "Bluespace-Active Botanical Sample"
	reward_points = 2200
	criteria = list("Plant Seed Packet", "Teleporting (Bluespace) Trait")

/datum/research_bounty/xenobotany/bluespace_flora/New()
	..()
	desc = "[corporation] is offering a grant for seed DNA exhibiting anomalous spatial translocation traits."

/datum/research_bounty/xenobotany/bluespace_flora/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_TELEPORTING) >= 1

/datum/research_bounty/xenobotany/volatile_flora
	title = "Volatile Bio-Compound Strain"
	reward_points = 2000
	criteria = list("Plant Seed Packet", "Explosive Trait", "Potency >= 30")

/datum/research_bounty/xenobotany/volatile_flora/New()
	..()
	desc = "[corporation] wants stabilized genetic telemetry from an explosive-fruiting botanical specimen."

/datum/research_bounty/xenobotany/volatile_flora/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_EXPLOSIVE) >= 1 && GET_SEED_TRAIT(S, TRAIT_POTENCY) >= 30

/datum/research_bounty/xenobotany/predatory_vine
	title = "Carnivorous Vine Cultivar"
	reward_points = 1800
	criteria = list("Plant Seed Packet", "Carnivorous Trait", "Spreading Growth (>= 1)")

/datum/research_bounty/xenobotany/predatory_vine/New()
	..()
	desc = "[corporation] is studying aggressive carnivorous flora capable of spreading beyond standard containment trays."

/datum/research_bounty/xenobotany/predatory_vine/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_CARNIVOROUS) >= 1 && GET_SEED_TRAIT(S, TRAIT_SPREAD) >= 1

/datum/research_bounty/xenobotany/hardy_strain
	title = "Extreme-Environment Hardy Strain"
	reward_points = 1700
	criteria = list("Plant Seed Packet", "Endurance >= 60", "Toxins Tolerance >= 5", "Heat Tolerance >= 20")

/datum/research_bounty/xenobotany/hardy_strain/New()
	..()
	desc = "[corporation] needs resilient extremophile flora genetics for hostile exoplanet terraforming."

/datum/research_bounty/xenobotany/hardy_strain/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_ENDURANCE) >= 60 && GET_SEED_TRAIT(S, TRAIT_TOXINS_TOLERANCE) >= 5 && GET_SEED_TRAIT(S, TRAIT_HEAT_TOLERANCE) >= 20

/datum/research_bounty/xenobotany/sporous_defense
	title = "Aerosolized Spore Specimen"
	reward_points = 2100
	allowed_corporations = list("NanoTrasen", "Zeng-Hu Pharmaceuticals")
	criteria = list("Plant Seed Packet", "Sporous Trait", "Stinging Trait")

/datum/research_bounty/xenobotany/sporous_defense/New()
	..()
	desc = "[corporation] is funding research into exotic sporous strains (such as K'ois-line variants) exhibiting spore emission and stinging defenses."

/datum/research_bounty/xenobotany/sporous_defense/matches_item(obj/item/I)
	var/datum/seed/S = get_seed(I)
	if(!S)
		return FALSE
	return GET_SEED_TRAIT(S, TRAIT_SPOROUS) >= 1 && GET_SEED_TRAIT(S, TRAIT_STINGS) >= 1

// =========================================================================
// Category 3: Custom Circuit Requests (Automated Unit-Tested Challenges)
// =========================================================================
/datum/research_bounty/circuit
	category = "circuits"
	allowed_corporations = list("NanoTrasen", "Hephaestus Industries", "Zeng-Hu Pharmaceuticals", "Zavodskoi Interstellar")
	var/input_spec = ""
	var/output_spec = ""
	var/last_test_summary = ""

/datum/research_bounty/circuit/to_tgui_data(obj/item/loaded_item)
	. = ..()
	.["input_spec"] = input_spec
	.["output_spec"] = output_spec
	if(istype(loaded_item, /obj/item/electronic_assembly))
		.["test_summary"] = last_test_summary

/datum/research_bounty/circuit/proc/prepare_assembly_for_test(obj/item/electronic_assembly/A)
	if(A.battery)
		A.battery.charge = A.battery.maxcharge
	for(var/obj/item/integrated_circuit/IC in A.contents)
		IC.next_use = 0

/datum/research_bounty/circuit/proc/get_screens(obj/item/electronic_assembly/A)
	var/list/screens = list()
	for(var/obj/item/integrated_circuit/output/screen/S in A.contents)
		screens += S
	return screens

/datum/research_bounty/circuit/proc/get_numberpads(obj/item/electronic_assembly/A)
	var/list/pads = list()
	for(var/obj/item/integrated_circuit/input/numberpad/P in A.contents)
		pads += P
	return pads

/datum/research_bounty/circuit/proc/get_textpads(obj/item/electronic_assembly/A)
	var/list/pads = list()
	for(var/obj/item/integrated_circuit/input/textpad/P in A.contents)
		pads += P
	return pads

/datum/research_bounty/circuit/proc/get_toggles(obj/item/electronic_assembly/A)
	var/list/toggles = list()
	for(var/obj/item/integrated_circuit/input/toggle_button/T in A.contents)
		toggles += T
	return toggles

/datum/research_bounty/circuit/proc/get_buttons(obj/item/electronic_assembly/A)
	var/list/btns = list()
	for(var/obj/item/integrated_circuit/input/button/B in A.contents)
		btns += B
	return btns

/datum/research_bounty/circuit/proc/set_output_val(obj/item/integrated_circuit/IC, val)
	if(!length(IC.outputs))
		return
	var/datum/integrated_io/O = IC.outputs[1]
	O.write_data_to_pin(val)

/datum/research_bounty/circuit/proc/num_matches(val, expected)
	if(isnull(val))
		return FALSE
	var/n = isnum(val) ? val : text2num("[val]")
	if(isnull(n))
		return FALSE
	return abs(n - expected) < 0.01

/datum/research_bounty/circuit/matches_item(obj/item/I)
	var/obj/item/electronic_assembly/A = I
	if(!istype(A))
		return FALSE
	return run_circuit_tests(A)

/datum/research_bounty/circuit/proc/run_circuit_tests(obj/item/electronic_assembly/A)
	return FALSE

// 1. Celsius to Kelvin Converter
/datum/research_bounty/circuit/temp_c_to_k
	title = "Celsius-to-Kelvin Telemetry Converter"
	reward_points = 1500
	allowed_corporations = list("NanoTrasen", "Hephaestus Industries")
	input_spec = "1 Number Pad (Temperature in °C)"
	output_spec = "1 Screen (Displays Temperature in K = C + 273.15)"
	criteria = list("Electronic Assembly", "1 Number Pad -> 1 Screen", "Output = Input + 273.15")

/datum/research_bounty/circuit/temp_c_to_k/New()
	..()
	desc = "[corporation] needs a compact atmospheric telemetry converter that takes a Celsius value and outputs its Kelvin equivalent (C + 273.15)."

/datum/research_bounty/circuit/temp_c_to_k/run_circuit_tests(obj/item/electronic_assembly/A)
	var/list/pads = get_numberpads(A)
	var/list/screens = get_screens(A)
	if(length(pads) < 1 || length(screens) < 1)
		last_test_summary = "Missing I/O: requires at least 1 Number Pad and 1 Screen."
		return FALSE
	var/obj/item/integrated_circuit/input/numberpad/pad = pads[1]
	var/obj/item/integrated_circuit/output/screen/scr = screens[1]
	var/list/cases = list(0, 20, -40, 100)
	for(var/c in cases)
		prepare_assembly_for_test(A)
		scr.stuff_to_display = null
		set_output_val(pad, c)
		pad.push_data()
		pad.activate_pin(1)
		var/expected = c + 273.15
		if(!num_matches(scr.stuff_to_display, expected))
			last_test_summary = "Failed on input [c]: expected [expected], got '[scr.stuff_to_display]'."
			return FALSE
	last_test_summary = "Passed all [length(cases)]/[length(cases)] unit tests."
	return TRUE

// 2. Dual-Input Adder
/datum/research_bounty/circuit/adder
	title = "Dual-Channel Arithmetic Adder"
	reward_points = 1300
	input_spec = "2 Number Pads (Inputs A and B)"
	output_spec = "1 Screen (Displays A + B)"
	criteria = list("Electronic Assembly", "2 Number Pads -> 1 Screen", "Output = A + B")

/datum/research_bounty/circuit/adder/New()
	..()
	desc = "[corporation] is testing a two-channel summing module that outputs the sum of two numeric inputs."

/datum/research_bounty/circuit/adder/run_circuit_tests(obj/item/electronic_assembly/A)
	var/list/pads = get_numberpads(A)
	var/list/screens = get_screens(A)
	if(length(pads) < 2 || length(screens) < 1)
		last_test_summary = "Missing I/O: requires at least 2 Number Pads and 1 Screen."
		return FALSE
	var/obj/item/integrated_circuit/input/numberpad/p1 = pads[1]
	var/obj/item/integrated_circuit/input/numberpad/p2 = pads[2]
	var/obj/item/integrated_circuit/output/screen/scr = screens[1]
	var/list/cases = list(list(3, 5, 8), list(10, -4, 6), list(0, 0, 0), list(42, 58, 100))
	for(var/list/tc in cases)
		prepare_assembly_for_test(A)
		scr.stuff_to_display = null
		set_output_val(p1, tc[1])
		set_output_val(p2, tc[2])
		p1.push_data()
		p2.push_data()
		p1.activate_pin(1)
		prepare_assembly_for_test(A)
		p2.activate_pin(1)
		if(!num_matches(scr.stuff_to_display, tc[3]))
			last_test_summary = "Failed on ([tc[1]], [tc[2]]): expected [tc[3]], got '[scr.stuff_to_display]'."
			return FALSE
	last_test_summary = "Passed all [length(cases)]/[length(cases)] unit tests."
	return TRUE

// 3. Maximum Value Selector
/datum/research_bounty/circuit/max_of_two
	title = "Peak Signal Comparator"
	reward_points = 1700
	input_spec = "2 Number Pads (Inputs A and B)"
	output_spec = "1 Screen (Displays max(A, B))"
	criteria = list("Electronic Assembly", "2 Number Pads -> 1 Screen", "Output = max(A, B)")

/datum/research_bounty/circuit/max_of_two/New()
	..()
	desc = "[corporation] requires a dual-sensor comparator circuit that outputs whichever of the two numeric inputs is greater."

/datum/research_bounty/circuit/max_of_two/run_circuit_tests(obj/item/electronic_assembly/A)
	var/list/pads = get_numberpads(A)
	var/list/screens = get_screens(A)
	if(length(pads) < 2 || length(screens) < 1)
		last_test_summary = "Missing I/O: requires at least 2 Number Pads and 1 Screen."
		return FALSE
	var/obj/item/integrated_circuit/input/numberpad/p1 = pads[1]
	var/obj/item/integrated_circuit/input/numberpad/p2 = pads[2]
	var/obj/item/integrated_circuit/output/screen/scr = screens[1]
	var/list/cases = list(list(5, 12, 12), list(25, 9, 25), list(-3, -10, -3), list(7, 7, 7))
	for(var/list/tc in cases)
		prepare_assembly_for_test(A)
		scr.stuff_to_display = null
		set_output_val(p1, tc[1])
		set_output_val(p2, tc[2])
		p1.push_data()
		p2.push_data()
		p1.activate_pin(1)
		prepare_assembly_for_test(A)
		p2.activate_pin(1)
		if(!num_matches(scr.stuff_to_display, tc[3]))
			last_test_summary = "Failed on ([tc[1]], [tc[2]]): expected [tc[3]], got '[scr.stuff_to_display]'."
			return FALSE
	last_test_summary = "Passed all [length(cases)]/[length(cases)] unit tests."
	return TRUE

// 4. Threshold Alarm Classifier
/datum/research_bounty/circuit/threshold_alert
	title = "Pressure Threshold Classifier"
	reward_points = 1800
	input_spec = "1 Number Pad (Sensor Reading X)"
	output_spec = "1 Screen (Displays \"ALERT\" if X >= 100, else \"NORMAL\")"
	criteria = list("Electronic Assembly", "1 Number Pad -> 1 Screen", "X >= 100 -> ALERT, else NORMAL")

/datum/research_bounty/circuit/threshold_alert/New()
	..()
	desc = "[corporation] is ordering an automated threshold monitor that outputs \"ALERT\" when the input is 100 or higher, and \"NORMAL\" otherwise."

/datum/research_bounty/circuit/threshold_alert/run_circuit_tests(obj/item/electronic_assembly/A)
	var/list/pads = get_numberpads(A)
	var/list/screens = get_screens(A)
	if(length(pads) < 1 || length(screens) < 1)
		last_test_summary = "Missing I/O: requires at least 1 Number Pad and 1 Screen."
		return FALSE
	var/obj/item/integrated_circuit/input/numberpad/pad = pads[1]
	var/obj/item/integrated_circuit/output/screen/scr = screens[1]
	var/list/cases = list(list(50, "NORMAL"), list(99, "NORMAL"), list(100, "ALERT"), list(250, "ALERT"))
	for(var/list/tc in cases)
		prepare_assembly_for_test(A)
		scr.stuff_to_display = null
		set_output_val(pad, tc[1])
		pad.push_data()
		pad.activate_pin(1)
		if("[scr.stuff_to_display]" != tc[2])
			last_test_summary = "Failed on input [tc[1]]: expected '[tc[2]]', got '[scr.stuff_to_display]'."
			return FALSE
	last_test_summary = "Passed all [length(cases)]/[length(cases)] unit tests."
	return TRUE

// 5. String Concatenator
/datum/research_bounty/circuit/string_concat
	title = "Telemetry Tag Formatter"
	reward_points = 1600
	input_spec = "2 Text Pads (Prefix and Suffix)"
	output_spec = "1 Screen (Displays \"Prefix-Suffix\")"
	criteria = list("Electronic Assembly", "2 Text Pads -> 1 Screen", "Output = Prefix-Suffix")

/datum/research_bounty/circuit/string_concat/New()
	..()
	desc = "[corporation] needs a string-formatting circuit that joins two text inputs with a hyphen (\"Prefix-Suffix\")."

/datum/research_bounty/circuit/string_concat/run_circuit_tests(obj/item/electronic_assembly/A)
	var/list/pads = get_textpads(A)
	var/list/screens = get_screens(A)
	if(length(pads) < 2 || length(screens) < 1)
		last_test_summary = "Missing I/O: requires at least 2 Text Pads and 1 Screen."
		return FALSE
	var/obj/item/integrated_circuit/input/textpad/p1 = pads[1]
	var/obj/item/integrated_circuit/input/textpad/p2 = pads[2]
	var/obj/item/integrated_circuit/output/screen/scr = screens[1]
	var/list/cases = list(list("SEC", "01", "SEC-01"), list("MED", "BAY", "MED-BAY"), list("ENG", "99", "ENG-99"))
	for(var/list/tc in cases)
		prepare_assembly_for_test(A)
		scr.stuff_to_display = null
		set_output_val(p1, tc[1])
		set_output_val(p2, tc[2])
		p1.push_data()
		p2.push_data()
		p1.activate_pin(1)
		prepare_assembly_for_test(A)
		p2.activate_pin(1)
		if("[scr.stuff_to_display]" != tc[3])
			last_test_summary = "Failed on ('[tc[1]]', '[tc[2]]'): expected '[tc[3]]', got '[scr.stuff_to_display]'."
			return FALSE
	last_test_summary = "Passed all [length(cases)]/[length(cases)] unit tests."
	return TRUE

// 6. Logical AND Gate Controller
/datum/research_bounty/circuit/logic_and
	title = "Dual-Interlock AND Controller"
	reward_points = 1400
	input_spec = "2 Toggle Buttons (Interlocks A and B)"
	output_spec = "1 Screen (Displays 1 if both ON, else 0)"
	criteria = list("Electronic Assembly", "2 Toggle Buttons -> 1 Screen", "Output = A AND B (1 or 0)")

/datum/research_bounty/circuit/logic_and/New()
	..()
	desc = "[corporation] is requesting a safety interlock circuit that outputs 1 only when both toggle switches are ON (1), and 0 otherwise."

/datum/research_bounty/circuit/logic_and/run_circuit_tests(obj/item/electronic_assembly/A)
	var/list/toggles = get_toggles(A)
	var/list/screens = get_screens(A)
	if(length(toggles) < 2 || length(screens) < 1)
		last_test_summary = "Missing I/O: requires at least 2 Toggle Buttons and 1 Screen."
		return FALSE
	var/obj/item/integrated_circuit/input/toggle_button/t1 = toggles[1]
	var/obj/item/integrated_circuit/input/toggle_button/t2 = toggles[2]
	var/obj/item/integrated_circuit/output/screen/scr = screens[1]
	var/list/cases = list(list(0, 0, 0), list(1, 0, 0), list(0, 1, 0), list(1, 1, 1))
	for(var/list/tc in cases)
		prepare_assembly_for_test(A)
		scr.stuff_to_display = null
		set_output_val(t1, tc[1])
		set_output_val(t2, tc[2])
		t1.push_data()
		t2.push_data()
		t1.activate_pin(1)
		prepare_assembly_for_test(A)
		t2.activate_pin(1)
		if(!num_matches(scr.stuff_to_display, tc[3]))
			last_test_summary = "Failed on ([tc[1]], [tc[2]]): expected [tc[3]], got '[scr.stuff_to_display]'."
			return FALSE
	last_test_summary = "Passed all [length(cases)]/[length(cases)] unit tests."
	return TRUE

// 7. Pulse Counter / Accumulator
/datum/research_bounty/circuit/pulse_counter
	title = "Incremental Pulse Counter"
	reward_points = 2000
	input_spec = "1 Button (Increment Trigger)"
	output_spec = "1 Screen (Increments displayed number by +1 per press)"
	criteria = list("Electronic Assembly", "1 Button -> 1 Screen", "Each press increments output by +1")

/datum/research_bounty/circuit/pulse_counter/New()
	..()
	desc = "[corporation] wants a stateful digital counter that increments its displayed count by +1 each time its button is pressed."

/datum/research_bounty/circuit/pulse_counter/run_circuit_tests(obj/item/electronic_assembly/A)
	var/list/btns = get_buttons(A)
	var/list/screens = get_screens(A)
	if(length(btns) < 1 || length(screens) < 1)
		last_test_summary = "Missing I/O: requires at least 1 Button and 1 Screen."
		return FALSE
	var/obj/item/integrated_circuit/input/button/btn = btns[1]
	var/obj/item/integrated_circuit/output/screen/scr = screens[1]
	var/prev_val = null
	for(var/step in 1 to 4)
		prepare_assembly_for_test(A)
		btn.activate_pin(1)
		var/cur_val = isnum(scr.stuff_to_display) ? scr.stuff_to_display : text2num("[scr.stuff_to_display]")
		if(isnull(cur_val))
			last_test_summary = "Step [step]: expected numeric output on Screen, got '[scr.stuff_to_display]'."
			return FALSE
		if(!isnull(prev_val) && abs((cur_val - prev_val) - 1) >= 0.01)
			last_test_summary = "Step [step]: expected increment of +1 from [prev_val], got [cur_val]."
			return FALSE
		prev_val = cur_val
	last_test_summary = "Passed all 4/4 incremental pulse tests."
	return TRUE

// =========================================================================
// Category 4: Planetary Survey Data (Exoplanet Probe Disks)
// =========================================================================
/datum/research_bounty/survey
	category = "survey"
	allowed_corporations = list("NanoTrasen", "Hephaestus Industries", "Orion Express", "Zeng-Hu Pharmaceuticals", "Idris Incorporated")
	var/required_survey_type = ""

/datum/research_bounty/survey/matches_item(obj/item/I)
	var/obj/item/disk/survey_data/D = I
	if(!istype(D))
		return FALSE
	return D.survey_type == required_survey_type

/datum/research_bounty/survey/atmospheric
	title = "Exoplanet Atmospheric Survey Data"
	required_survey_type = "atmospheric"
	reward_points = 2500
	allowed_corporations = list("Hephaestus Industries", "Orion Express", "Idris Incorporated", "NanoTrasen")
	criteria = list("Planetary Survey Data Disk", "Source: Atmosphere Probe on an Exoplanet")

/datum/research_bounty/survey/atmospheric/New()
	..()
	switch(corporation)
		if("Idris Incorporated")
			desc = "[corporation] is evaluating resort world candidates for breathable climate telemetry. Deploy an Atmosphere Probe on an exoplanet surface and analyze the resulting survey disk."
		if("NanoTrasen")
			desc = "[corporation] is screening exoplanet atmospheres for trace phoronic and volatile gas deposits. Deploy an Atmosphere Probe on an exoplanet surface and analyze the resulting survey disk."
		else
			desc = "[corporation] is purchasing exoplanet atmospheric composition and gas-harvesting telemetry. Deploy an Atmosphere Probe on an exoplanet surface and analyze the resulting survey disk."

/datum/research_bounty/survey/ground
	title = "Exoplanet Geological Ground Survey Data"
	required_survey_type = "ground"
	reward_points = 2500
	allowed_corporations = list("Hephaestus Industries", "Orion Express", "NanoTrasen", "Idris Incorporated")
	criteria = list("Planetary Survey Data Disk", "Source: Ground Probe on an Exoplanet")

/datum/research_bounty/survey/ground/New()
	..()
	switch(corporation)
		if("NanoTrasen")
			desc = "[corporation] is prospecting for natural phoron deposits and subsurface crystal veins. Deploy a Ground Probe on an exoplanet surface and analyze the resulting survey disk."
		if("Idris Incorporated")
			desc = "[corporation] is assessing planetary terrain and crust stability for potential resort world development. Deploy a Ground Probe on an exoplanet surface and analyze the resulting survey disk."
		else
			desc = "[corporation] is seeking seismic and mineralogical ground survey data for resource extraction. Deploy a Ground Probe on an exoplanet surface and analyze the resulting survey disk."

/datum/research_bounty/survey/geomagnetic
	title = "Exoplanet Geomagnetic Field Survey Data"
	required_survey_type = "geomagnetic"
	reward_points = 2500
	allowed_corporations = list("Zeng-Hu Pharmaceuticals", "NanoTrasen", "Idris Incorporated", "Orion Express")
	criteria = list("Planetary Survey Data Disk", "Source: Geomagnetic Probe on an Exoplanet")

/datum/research_bounty/survey/geomagnetic/New()
	..()
	switch(corporation)
		if("Zeng-Hu Pharmaceuticals")
			desc = "[corporation] is scanning for exotic biosignatures and alien life-supporting magnetospheres. Deploy a Geomagnetic Probe on an exoplanet surface and analyze the resulting survey disk."
		if("Idris Incorporated")
			desc = "[corporation] is verifying solar radiation shielding for prospective resort world candidates. Deploy a Geomagnetic Probe on an exoplanet surface and analyze the resulting survey disk."
		else
			desc = "[corporation] is requesting magnetospheric and radiation field telemetry. Deploy a Geomagnetic Probe on an exoplanet surface and analyze the resulting survey disk."

// =========================================================================
// Category 5: Xenoarchaeology Finds (Alien Artifacts)
// =========================================================================
/datum/research_bounty/xenoarch
	category = "xenoarch"
	allowed_corporations = list("NanoTrasen", "Zeng-Hu Pharmaceuticals", "Idris Incorporated")

/datum/research_bounty/xenoarch/proc/get_artifact(obj/O)
	var/obj/structure/machinery/artifact/A = O
	if(!istype(A))
		return null
	return A

/datum/research_bounty/xenoarch/any_artifact
	title = "Anomalous Alien Artifact"
	reward_points = 2200
	criteria = list("Alien Artifact (Drag & Drop onto Analyzer)")

/datum/research_bounty/xenoarch/any_artifact/New()
	..()
	desc = "[corporation] is acquiring intact alien artifacts for destructive resonance analysis."

/datum/research_bounty/xenoarch/any_artifact/matches_item(obj/I)
	return !!get_artifact(I)

/datum/research_bounty/xenoarch/physical_trigger
	title = "Physically-Triggered Anomaly"
	reward_points = 2600
	criteria = list("Alien Artifact", "Primary Trigger: Physical / Touch (0-4)")

/datum/research_bounty/xenoarch/physical_trigger/New()
	..()
	desc = "[corporation] requests structural telemetry from an alien artifact activated by physical contact."

/datum/research_bounty/xenoarch/physical_trigger/matches_item(obj/I)
	var/obj/structure/machinery/artifact/A = get_artifact(I)
	if(!A || !A.my_effect)
		return FALSE
	return A.my_effect.trigger >= 0 && A.my_effect.trigger <= 4

/datum/research_bounty/xenoarch/energy_trigger
	title = "Energetically-Triggered Anomaly"
	reward_points = 2600
	criteria = list("Alien Artifact", "Primary Trigger: Energetic (5-8)")

/datum/research_bounty/xenoarch/energy_trigger/New()
	..()
	desc = "[corporation] is studying alien artifacts that respond to directed energy or electromagnetic stimulation."

/datum/research_bounty/xenoarch/energy_trigger/matches_item(obj/I)
	var/obj/structure/machinery/artifact/A = get_artifact(I)
	if(!A || !A.my_effect)
		return FALSE
	return A.my_effect.trigger >= 5 && A.my_effect.trigger <= 8

/datum/research_bounty/xenoarch/atmos_trigger
	title = "Atmospherically-Triggered Anomaly"
	reward_points = 2800
	criteria = list("Alien Artifact", "Primary Trigger: Atmospheric / Thermal (9-12)")

/datum/research_bounty/xenoarch/atmos_trigger/New()
	..()
	desc = "[corporation] seeks environmental-reactive alien artifacts triggered by gas composition or temperature."

/datum/research_bounty/xenoarch/atmos_trigger/matches_item(obj/I)
	var/obj/structure/machinery/artifact/A = get_artifact(I)
	if(!A || !A.my_effect)
		return FALSE
	return A.my_effect.trigger >= 9 && A.my_effect.trigger <= 12

/datum/research_bounty/xenoarch/dual_effect
	title = "Dual-Resonance Artifact"
	reward_points = 3000
	criteria = list("Alien Artifact", "Primary + Secondary Effect Present")

/datum/research_bounty/xenoarch/dual_effect/New()
	..()
	desc = "[corporation] is offering a grant for complex alien artifacts exhibiting both primary and secondary anomalous effects."

/datum/research_bounty/xenoarch/dual_effect/matches_item(obj/I)
	var/obj/structure/machinery/artifact/A = get_artifact(I)
	if(!A)
		return FALSE
	return !!A.my_effect && !!A.secondary_effect

/datum/research_bounty/xenoarch/exotic_field
	title = "Bluespace / Atomic Synthesis Artifact"
	reward_points = 3200
	criteria = list("Alien Artifact", "Effect Type: Bluespace Phasing or Atomic Synthesis")

/datum/research_bounty/xenoarch/exotic_field/New()
	..()
	desc = "[corporation] is prioritizing artifacts exhibiting interdimensional phasing or atomic synthesis signatures."

/datum/research_bounty/xenoarch/exotic_field/matches_item(obj/I)
	var/obj/structure/machinery/artifact/A = get_artifact(I)
	if(!A || !A.my_effect)
		return FALSE
	return A.my_effect.effect_type in list(6, 7)

/datum/research_bounty/xenoarch/energetic_field
	title = "Energetic / Particle Field Artifact"
	reward_points = 2700
	criteria = list("Alien Artifact", "Effect Type: Energy, EM, or Particle Field")

/datum/research_bounty/xenoarch/energetic_field/New()
	..()
	desc = "[corporation] needs spectral breakdown data from artifacts emitting concentrated energy, EM waves, or particle fields."

/datum/research_bounty/xenoarch/energetic_field/matches_item(obj/I)
	var/obj/structure/machinery/artifact/A = get_artifact(I)
	if(!A || !A.my_effect)
		return FALSE
	return A.my_effect.effect_type in list(1, 3, 4)

/datum/research_bounty/xenoarch/psionic_bio
	title = "Psionic / Bio-Reactive Artifact"
	reward_points = 2800
	criteria = list("Alien Artifact", "Effect Type: Psionic Wavefront or Bio-Reactive")

/datum/research_bounty/xenoarch/psionic_bio/New()
	..()
	desc = "[corporation] is researching alien artifacts producing psionic wavefronts or organically reactive particles."

/datum/research_bounty/xenoarch/psionic_bio/matches_item(obj/I)
	var/obj/structure/machinery/artifact/A = get_artifact(I)
	if(!A || !A.my_effect)
		return FALSE
	return A.my_effect.effect_type in list(2, 5)

// =========================================================================
// Category 6: Xenobiology (Slime Extracts / Cores)
// =========================================================================
/datum/research_bounty/xenobiology
	category = "xenobiology"
	allowed_corporations = list("Zeng-Hu Pharmaceuticals", "NanoTrasen", "Idris Incorporated")
	var/required_extract_type = /obj/item/slime_extract

/datum/research_bounty/xenobiology/matches_item(obj/item/I)
	var/obj/item/slime_extract/E = I
	if(!istype(E, required_extract_type))
		return FALSE
	return E.uses > 0

/datum/research_bounty/xenobiology/gold
	title = "Gold Slime Core"
	reward_points = 2000
	required_extract_type = /obj/item/slime_extract/gold
	allowed_corporations = list("NanoTrasen", "Idris Incorporated")
	criteria = list("Gold Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/gold/New()
	..()
	desc = "[corporation] is purchasing an intact, unspent gold slime extract for cellular bio-synthesis analysis."

/datum/research_bounty/xenobiology/pink
	title = "Pink Slime Core"
	reward_points = 2000
	required_extract_type = /obj/item/slime_extract/pink
	allowed_corporations = list("Zeng-Hu Pharmaceuticals", "Idris Incorporated")
	criteria = list("Pink Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/pink/New()
	..()
	desc = "[corporation] seeks an active pink slime extract for docile xenofauna endocrine research."

/datum/research_bounty/xenobiology/green
	title = "Green Slime Core"
	reward_points = 2200
	required_extract_type = /obj/item/slime_extract/green
	allowed_corporations = list("Zeng-Hu Pharmaceuticals")
	criteria = list("Green Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/green/New()
	..()
	desc = "[corporation] is funding mutagenic enzyme trials using an unspent green slime extract."

/datum/research_bounty/xenobiology/oil
	title = "Oil Slime Core"
	reward_points = 2400
	required_extract_type = /obj/item/slime_extract/oil
	allowed_corporations = list("NanoTrasen", "Zeng-Hu Pharmaceuticals")
	criteria = list("Oil Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/oil/New()
	..()
	desc = "[corporation] requires a volatile, unspent oil slime extract for controlled exothermic reaction profiling."

/datum/research_bounty/xenobiology/black
	title = "Black Slime Core"
	reward_points = 2600
	required_extract_type = /obj/item/slime_extract/black
	allowed_corporations = list("Zeng-Hu Pharmaceuticals", "NanoTrasen")
	criteria = list("Black Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/black/New()
	..()
	desc = "[corporation] is acquiring an active black slime extract for advanced mutagenic transmutation studies."

/datum/research_bounty/xenobiology/lightpink
	title = "Light Pink Slime Core"
	reward_points = 2800
	required_extract_type = /obj/item/slime_extract/lightpink
	allowed_corporations = list("Zeng-Hu Pharmaceuticals", "Idris Incorporated")
	criteria = list("Light Pink Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/lightpink/New()
	..()
	desc = "[corporation] is offering a grant for an unspent light pink slime extract to study pacification pheromones."

/datum/research_bounty/xenobiology/adamantine
	title = "Adamantine Slime Core"
	reward_points = 2600
	required_extract_type = /obj/item/slime_extract/adamantine
	allowed_corporations = list("NanoTrasen", "Hephaestus Industries")
	criteria = list("Adamantine Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/adamantine/New()
	..()
	desc = "[corporation] requests an intact adamantine slime extract for crystalline lattice reinforcement research."

/datum/research_bounty/xenobiology/bluespace
	title = "Bluespace Slime Core"
	reward_points = 3000
	required_extract_type = /obj/item/slime_extract/bluespace
	allowed_corporations = list("NanoTrasen")
	criteria = list("Bluespace Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/bluespace/New()
	..()
	desc = "[corporation] is prioritizing an active bluespace slime extract for organic spatial-folding telemetry."

/datum/research_bounty/xenobiology/sepia
	title = "Sepia Slime Core"
	reward_points = 2800
	required_extract_type = /obj/item/slime_extract/sepia
	allowed_corporations = list("NanoTrasen", "Idris Incorporated")
	criteria = list("Sepia Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/sepia/New()
	..()
	desc = "[corporation] seeks an unspent sepia slime extract for temporal-stasis field calibration."

/datum/research_bounty/xenobiology/rainbow
	title = "Rainbow Slime Core"
	reward_points = 3500
	required_extract_type = /obj/item/slime_extract/rainbow
	allowed_corporations = list("NanoTrasen", "Zeng-Hu Pharmaceuticals", "Idris Incorporated")
	criteria = list("Rainbow Slime Extract", "Active (Uses > 0)")

/datum/research_bounty/xenobiology/rainbow/New()
	..()
	desc = "[corporation] is offering top-tier funding for a rare, active rainbow slime extract."
