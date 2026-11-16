/datum/unit_test/survey_probe_data
	name = "SURVEY: Survey Data Disk Integrity"
	groups = list("generic")

/datum/unit_test/survey_probe_data/start_test()
	var/obj/item/disk/survey_data/atmosphere = new(null, null, "atmospheric")
	var/obj/item/disk/survey_data/ground = new(null, null, "ground")
	var/obj/item/disk/survey_data/geomagnetic = new(null, null, "geomagnetic")

	if(!atmosphere.origin_tech || !ground.origin_tech || !geomagnetic.origin_tech)
		fail("Survey data disks missing origin_tech")
		return 1

	if(atmosphere.origin_tech[TECH_BIO] != 4 || atmosphere.origin_tech[TECH_DATA] != 3 || atmosphere.origin_tech[TECH_ENGINEERING] != 3)
		fail("Atmosphere survey disk has invalid origin_tech values")
		return 1

	if(ground.origin_tech[TECH_MATERIAL] != 4 || ground.origin_tech[TECH_ENGINEERING] != 3 || ground.origin_tech[TECH_DATA] != 3)
		fail("Ground survey disk has invalid origin_tech values")
		return 1

	if(geomagnetic.origin_tech[TECH_MAGNET] != 4 || geomagnetic.origin_tech[TECH_POWER] != 3 || geomagnetic.origin_tech[TECH_DATA] != 3)
		fail("Geomagnetic survey disk has invalid origin_tech values")
		return 1

	qdel(atmosphere)
	qdel(ground)
	qdel(geomagnetic)
	pass("Survey data disks initialized correctly")
	return 1

/datum/unit_test/research_tech_nodes
	name = "RESEARCH: Tech Nodes and Point Unlocks"
	groups = list("generic")

/datum/unit_test/research_tech_nodes/start_test()
	if(!GLOB.tech_nodes || !GLOB.tech_nodes.len)
		fail("GLOB.tech_nodes not populated")
		return 1

	var/datum/tech_node/ind_basics = GLOB.tech_nodes["ind_basics"]
	var/datum/tech_node/ind_parts_adv = GLOB.tech_nodes["ind_parts_adv"]
	var/datum/tech_node/ind_parts_super = GLOB.tech_nodes["ind_parts_super"]
	if(!ind_basics || !ind_parts_adv || !ind_parts_super)
		fail("Expected tech nodes missing")
		return 1

	var/datum/research/R = new(null)
	if(!(ind_basics.id in R.unlocked_nodes))
		fail("ind_basics should start unlocked on standard research holder")
		return 1

	// Ensure Machinists' baseline (prosthetics, basic mechs, synthetic organs) and custom circuit tools are unlocked at roundstart
	var/list/roundstart_required = list(
		/datum/design/item/mechfab/prosthetic/internal/heart,
		/datum/design/item/mechfab/exosuit/ripley_torso,
		/datum/design/item/synthetic/power_core,
		/datum/design/item/integrated_electronics/custom_circuit_printer,
		/datum/design/item/integrated_electronics/custom_circuit_assembly,
		/datum/design/item/integrated_electronics/wirer,
		/datum/design/item/integrated_electronics/debugger,
		/datum/design/item/modular_weapon/modular_small,
		/datum/design/item/modular_weapon/modular_medium,
		/datum/design/item/modular_weapon/modular_cap,
		/datum/design/item/modular_weapon/modular_lens,
		/datum/design/item/modular_weapon/modular_laser,
		/datum/design/item/modular_weapon/modular_taser
	)
	for(var/req_design in roundstart_required)
		if(!(req_design in R.known_designs))
			fail("Roundstart design [req_design] missing from known_designs")
			qdel(R)
			return 1

	// Ensure prereq check works: ind_parts_super requires ind_parts_adv
	if(R.can_unlock_node(ind_parts_super.id))
		fail("ind_parts_super should not be unlockable before ind_parts_adv is unlocked")
		return 1

	if(/datum/design/item/stock_part/adv_capacitor in R.known_designs)
		fail("adv_capacitor design should not be unlocked before ind_parts_adv")
		return 1

	// Unlock ind_parts_adv
	R.research_points = 5000
	var/points_before = R.research_points
	if(!R.unlock_node(ind_parts_adv.id))
		fail("Failed to unlock ind_parts_adv with sufficient points and fulfilled prereqs")
		return 1

	if(!(ind_parts_adv.id in R.unlocked_nodes))
		fail("ind_parts_adv ID not present in unlocked_nodes")
		return 1

	if(R.research_points != points_before - ind_parts_adv.cost)
		fail("Research points not deducted correctly upon node unlock")
		return 1

	if(!(/datum/design/item/stock_part/adv_capacitor in R.known_designs))
		fail("adv_capacitor design not unlocked after unlocking ind_parts_adv")
		return 1

	// Now ind_parts_super should be unlockable
	if(!R.can_unlock_node(ind_parts_super.id))
		fail("ind_parts_super should be unlockable after ind_parts_adv unlock")
		return 1

	qdel(R)
	pass("Tech nodes, research points, and design unlocks function as expected")
	return 1

/datum/unit_test/research_firearm_bounties
	name = "RESEARCH: Corporate Firearm Bounties"
	groups = list("generic")

/datum/unit_test/research_firearm_bounties/start_test()
	var/datum/research/R = new(null)
	if(length(R.active_bounties) != 18)
		fail("Expected 18 active bounties (3 firearm, 3 xenobotany, 3 xenobiology, 3 circuit, 3 survey, 3 xenoarch) on research initialization")
		qdel(R)
		return 1

	var/obj/item/disk/survey_data/SD = new(null, null, "atmospheric")
	if(!R.get_matching_bounty(SD))
		fail("Expected atmospheric survey disk to match an active survey bounty")
		qdel(SD)
		qdel(R)
		return 1
	qdel(SD)

	var/datum/research_bounty/xenoarch/physical_trigger/XB_art = new
	var/obj/structure/machinery/artifact/art = new(null)
	art.my_effect.trigger = TRIGGER_TOUCH
	if(!XB_art.matches_item(art))
		fail("Expected TRIGGER_TOUCH artifact to match physical_trigger xenoarch bounty")
		qdel(art)
		qdel(XB_art)
		qdel(R)
		return 1
	qdel(art)
	qdel(XB_art)

	var/datum/research_bounty/firearm/burst_carbine/B = new
	var/obj/item/gun/energy/laser/prototype/P = new(null)
	P.burst = 1
	P.reliability = 50
	if(B.matches_item(P))
		fail("Prototype gun with burst 1 and reliability 50 should not match burst_carbine bounty")
		qdel(P)
		qdel(B)
		qdel(R)
		return 1

	P.burst = 3
	P.reliability = 80
	if(!B.matches_item(P))
		fail("Prototype gun with burst 3 and reliability 80 should match burst_carbine bounty")
		qdel(P)
		qdel(B)
		qdel(R)
		return 1

	qdel(P)
	qdel(B)

	var/datum/research_bounty/xenobotany/bioluminescent/XB = new
	var/obj/item/seeds/pkt = new(null)
	var/datum/seed/S = new
	SET_SEED_TRAIT(S, TRAIT_BIOLUM, 0)
	SET_SEED_TRAIT(S, TRAIT_POTENCY, 10)
	pkt.seed = S
	if(XB.matches_item(pkt))
		fail("Seed without biolum and low potency should not match bioluminescent bounty")
		qdel(pkt)
		qdel(S)
		qdel(XB)
		qdel(R)
		return 1

	SET_SEED_TRAIT(S, TRAIT_BIOLUM, 1)
	SET_SEED_TRAIT(S, TRAIT_POTENCY, 30)
	if(!XB.matches_item(pkt))
		fail("Seed with biolum and potency 30 should match bioluminescent bounty")
		qdel(pkt)
		qdel(S)
		qdel(XB)
		qdel(R)
		return 1

	qdel(pkt)
	qdel(S)
	qdel(XB)

	var/datum/research_bounty/circuit/temp_c_to_k/CB = new
	var/obj/item/electronic_assembly/A = new(null)
	var/obj/item/integrated_circuit/input/numberpad/pad = new(A)
	var/obj/item/integrated_circuit/arithmetic/addition/add_ic = new(A)
	var/obj/item/integrated_circuit/output/screen/scr = new(A)
	pad.assembly = A
	add_ic.assembly = A
	scr.assembly = A
	// Wire pad -> add_ic(1), set add_ic(2) = 273.15, add_ic(out) -> scr(in), pad(pulse) -> add_ic(pulse) -> scr(pulse)
	var/datum/integrated_io/add_in2 = add_ic.inputs[2]
	add_in2.write_data_to_pin(273.15)
	var/datum/integrated_io/pad_out = pad.outputs[1]
	var/datum/integrated_io/add_in1 = add_ic.inputs[1]
	pad_out.linked |= add_in1
	add_in1.linked |= pad_out
	var/datum/integrated_io/add_out = add_ic.outputs[1]
	var/datum/integrated_io/scr_in = scr.inputs[1]
	add_out.linked |= scr_in
	scr_in.linked |= add_out
	var/datum/integrated_io/pad_act = pad.activators[1]
	var/datum/integrated_io/add_act1 = add_ic.activators[1]
	pad_act.linked |= add_act1
	add_act1.linked |= pad_act
	var/datum/integrated_io/add_act2 = add_ic.activators[2]
	var/datum/integrated_io/scr_act = scr.activators[1]
	add_act2.linked |= scr_act
	scr_act.linked |= add_act2

	if(!CB.matches_item(A))
		fail("Wired Celsius-to-Kelvin circuit failed automated unit tests: [CB.last_test_summary]")
		qdel(A)
		qdel(CB)
		qdel(R)
		return 1

	qdel(A)
	qdel(CB)
	qdel(R)
	pass("Corporate firearm, xenobiology seed, and custom circuit bounties evaluate items accurately")
	return 1

/datum/unit_test/research_persistence_decay
	name = "RESEARCH: Persistence Outermost Decay and Maintenance"
	groups = list("generic")

/datum/unit_test/research_persistence_decay/start_test()
	var/singleton/persistent_type/generic/research_tech_nodes/P = new /singleton/persistent_type/generic/research_tech_nodes()
	P.last_decay_time = 1000000

	var/datum/tech_node/parent = GLOB.tech_nodes["ind_parts_adv"]
	var/datum/tech_node/child = GLOB.tech_nodes["ind_parts_super"]
	P.node_investments[parent.id] = parent.cost
	P.node_investments[child.id] = child.cost

	if(P.is_outermost_node(parent.id))
		fail("Parent node ind_parts_adv should not be outermost when child ind_parts_super is unlocked")
		qdel(P)
		return 1

	if(!P.is_outermost_node(child.id))
		fail("Child node ind_parts_super should be outermost")
		qdel(P)
		return 1

	// Advance 0.5 IRL days: child loses 50% of its cost, parent loses 0
	P.apply_decay(1000000 + (0.5 DAYS))
	if(P.node_investments[parent.id] != parent.cost)
		fail("Non-outermost parent node decayed unexpectedly")
		qdel(P)
		return 1

	var/expected_half = child.cost - round(child.cost * 0.5)
	if(P.node_investments[child.id] != expected_half)
		fail("Expected child node to have [expected_half] pts after 0.5 days, got [P.node_investments[child.id]]")
		qdel(P)
		return 1

	// Test reinvesting / maintaining on a research holder
	var/datum/research/R = new(null)
	R.sync_persistence = FALSE
	R.unlocked_nodes |= parent.id
	R.unlocked_nodes |= child.id
	R.invested_points[parent.id] = parent.cost
	R.invested_points[child.id] = expected_half
	R.research_points = 5000
	var/spent = R.maintain_node(child.id)
	if(spent != (child.cost - expected_half) || R.invested_points[child.id] != child.cost)
		fail("maintain_node did not restore full invested points")
		qdel(R)
		qdel(P)
		return 1
	qdel(R)

	// Advance another 1.0 IRL day on P: child loses all remaining points and re-locks
	P.apply_decay(P.last_decay_time + (1 DAYS))
	if(child.id in P.node_investments)
		fail("Child node should have been re-locked after losing all invested points")
		qdel(P)
		return 1

	qdel(P)
	pass("Research persistence outermost decay and maintenance work as expected")
	return 1

/datum/unit_test/research_tech_processor_scaling
	name = "RESEARCH: Logarithmic Tech Processor Scaling"
	groups = list("generic")

/datum/unit_test/research_tech_processor_scaling/start_test()
	var/obj/structure/machinery/r_n_d/server/S = new(null)
	var/r1 = S.calculate_processor_cycle_points(1)
	var/r4 = S.calculate_processor_cycle_points(4)
	var/r16 = S.calculate_processor_cycle_points(16)

	if(r1 <= 0 || r4 <= r1 || r16 <= r4)
		fail("Tech processor output should strictly increase with total_rate")
		qdel(S)
		return 1

	// 4x rate should only yield 2x base output (log2(4) = 2 -> 1 + 0.5*2 = 2x), not 4x
	if(r4 > r1 * 2.1)
		fail("4x tech processor rate exceeded logarithmic scaling ([r4] vs [r1])")
		qdel(S)
		return 1

	// 16x rate should only yield 3x base output (log2(16) = 4 -> 1 + 0.5*4 = 3x), not 16x
	if(r16 > r1 * 3.1)
		fail("16x tech processor rate exceeded logarithmic scaling ([r16] vs [r1])")
		qdel(S)
		return 1

	qdel(S)
	pass("Tech processor logarithmic scaling verified")
	return 1

/datum/unit_test/xenoarch_artifact_persistence
	name = "XENOARCH: Artifact Persistence Serialization and Container Spawn"
	groups = list("generic")

/datum/unit_test/xenoarch_artifact_persistence/start_test()
	var/singleton/persistent_type/generic/xenoarch_artifacts/XA = GET_SINGLETON(/singleton/persistent_type/generic/xenoarch_artifacts)
	var/turf/T = locate(1, 1, 1)
	if(!T)
		pass("Skipped xenoarch artifact persistence test (no turf at 1,1,1)")
		return 1

	var/obj/structure/machinery/artifact/orig = new(T)
	orig.name = "test alien monolith"
	orig.icon_num = 5
	orig.my_effect.artifact_id = "alpha-777"
	orig.my_effect.trigger = TRIGGER_ENERGY
	orig.my_effect.effectrange = 7

	var/list/serialized = XA.serialize_artifact(orig, in_container = TRUE)
	qdel(orig)

	var/obj/structure/anomaly_container/box = new(T)
	var/obj/structure/machinery/artifact/restored = XA.spawn_artifact_from_data(T, serialized)
	if(!restored)
		fail("Failed to respawn artifact from serialized data")
		qdel(box)
		return 1

	if(box.contained != restored || restored.loc != box)
		fail("Restored artifact was not placed inside the anomaly container")
		qdel(restored)
		qdel(box)
		return 1

	if(restored.name != "test alien monolith" || restored.icon_num != 5 || restored.my_effect?.artifact_id != "alpha-777" || restored.my_effect?.trigger != TRIGGER_ENERGY)
		fail("Restored artifact did not preserve name, icon_num, or primary effect properties")
		qdel(box)
		return 1

	qdel(box)
	pass("Xenoarchaeology artifact persistence serialization and container spawning verified")
	return 1
