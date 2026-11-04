// 513 does not allow white or no color as a filter color
/datum/unit_test/overmap_effects_shall_have_non_white_color
	name = "OVERMAP: Shall have non-white color"
	groups = list("map", "overmap")

/datum/unit_test/overmap_effects_shall_have_non_white_color/start_test()
	var/list/invalid_overmap_types = list()
	for(var/omt in subtypesof(/obj/effect/overmap))
		var/obj/overmap = omt
		var/color = initial(overmap.color)
		if(!color || color == COLOR_WHITE)
			invalid_overmap_types += omt

	if(invalid_overmap_types.len)
		TEST_FAIL("Following /obj/effect/overmap types types have invalid colors: [english_list(invalid_overmap_types)]")
	else
		TEST_PASS("All /obj/effect/overmap types have a valid color")

	return TRUE

/datum/unit_test/overmap_ships_shall_have_entrypoints
	name = "OVERMAP: Ships shall have at least four valid entry points"
	groups = list("map", "overmap")

/datum/unit_test/overmap_ships_shall_have_entrypoints/start_test()
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.initialized_sectors)
		if(length(S.entry_points) >= 4)
			TEST_PASS("[S.name] ([S.type]) has at least four entry points.")
		else
			TEST_FAIL("[S.name] ([S.type]) does not have at least four entry points!")
	return TRUE

/datum/unit_test/overmap_ships_shall_have_class
	name = "OVERMAP: Ships shall have class and designation"
	groups = list("map", "overmap")

/datum/unit_test/overmap_ships_shall_have_class/start_test()
	var/failures = 0
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.initialized_sectors)
		if(!length(S.class))
			TEST_FAIL("[S.name] ([S.type]) does not have a class defined.")
			failures++
		if(!length(S.designation))
			TEST_FAIL("[S.name] ([S.type]) does not have a designation defined.")
			failures++
	if(!failures)
		TEST_PASS("All ships have a class and designation.")
	return TRUE

// Lightweight combat doubles: they exercise the overmap collision and payload
// handoff without firing a real projectile across one of the live ship maps.
/obj/effect/overmap/visitable/unit_test_combat_target/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	// Avoid registering this lightweight collision target as a real sector.
	return INITIALIZE_HINT_NORMAL

/obj/effect/overmap/visitable/unit_test_combat_target/check_ownership(obj/object)
	return FALSE

/obj/effect/overmap/projectile/unit_test_combat
	/// Number of payload handoffs performed by this combat carrier.
	var/entry_calls = 0
	/// Whether the reconstructed projectile became the ammunition's physical owner.
	var/payload_transferred = FALSE
	/// Physical projectile created by the overmap entry code under test.
	var/obj/projectile/ship_ammo/reconstructed_projectile

/obj/effect/overmap/projectile/unit_test_combat/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	// Avoid starting the production movement timer before the test configures the carrier.
	return INITIALIZE_HINT_NORMAL

/obj/effect/overmap/projectile/unit_test_combat/check_entry_visitable(obj/projectile/ship_ammo/widowmaker, turf/target_turf)
	// Capture the handoff result without firing across a live ship map.
	entry_calls++
	payload_transferred = (widowmaker.ammo?.loc == widowmaker)
	reconstructed_projectile = widowmaker
	qdel(src)
	return TRUE

/obj/effect/unit_test_ship_ammo_impact/Initialize()
	return ..()

/datum/unit_test/overmap_projectile_entry_is_one_shot
	name = "OVERMAP: Combat projectile entry is one-shot"
	groups = list("map", "overmap")

/datum/unit_test/overmap_projectile_entry_is_one_shot/start_test()
	var/test_z = SSatlas.current_map?.overmap_z ? SSatlas.current_map.overmap_z : 1
	var/turf/combat_turf = locate(2, 2, test_z)
	TEST_ASSERT_NOTNULL(combat_turf, "Could not locate an overmap turf for the combat simulation.")

	var/obj/effect/overmap/visitable/unit_test_combat_target/combat_target = new(combat_turf)
	var/obj/effect/overmap/projectile/unit_test_combat/overmap_projectile = new(combat_turf)
	var/obj/item/ship_ammunition/ammunition = new(overmap_projectile)
	ammunition.fired_projectile_type = /obj/projectile/ship_ammo
	ammunition.overmap_behaviour = SHIP_AMMO_CAN_HIT_VISITABLES
	overmap_projectile.ammunition = ammunition
	overmap_projectile.target = combat_target

	TEST_ASSERT(overmap_projectile.check_entry(), "The projectile did not enter its overmap combat target.")
	TEST_ASSERT(overmap_projectile.entering, "The overmap projectile was not marked as entering.")
	TEST_ASSERT(overmap_projectile.check_entry(), "A repeated entry check did not report the handled collision.")
	TEST_ASSERT_EQUAL(overmap_projectile.entry_calls, 1, "The payload was translated more than once.")
	TEST_ASSERT(overmap_projectile.payload_transferred, "The ammunition was not transferred to the reconstructed projectile.")

	qdel(combat_target)
	qdel(overmap_projectile.reconstructed_projectile)
	qdel(overmap_projectile)
	TEST_PASS("An overmap combat projectile translates its payload only once.")
	return TRUE

/datum/unit_test/overmap_projectile_missing_type
	name = "OVERMAP: Combat carrier rejects a missing projectile type"
	groups = list("map", "overmap")

/datum/unit_test/overmap_projectile_missing_type/start_test()
	var/test_z = SSatlas.current_map?.overmap_z ? SSatlas.current_map.overmap_z : 1
	var/turf/combat_turf = locate(2, 2, test_z)
	TEST_ASSERT_NOTNULL(combat_turf, "Could not locate an overmap turf for the combat simulation.")

	var/obj/effect/overmap/visitable/unit_test_combat_target/combat_target = new(combat_turf)
	var/obj/effect/overmap/projectile/unit_test_combat/overmap_projectile = new(combat_turf)
	var/obj/item/ship_ammunition/ammunition = new(overmap_projectile)
	ammunition.overmap_behaviour = SHIP_AMMO_CAN_HIT_VISITABLES
	overmap_projectile.ammunition = ammunition
	overmap_projectile.target = combat_target

	TEST_ASSERT(overmap_projectile.check_entry(), "The malformed carrier collision was not handled.")
	TEST_ASSERT(QDELETED(overmap_projectile), "A carrier with no projectile type was not deleted.")
	TEST_ASSERT_EQUAL(overmap_projectile.entry_calls, 0, "Entry ran without a projectile type.")

	qdel(combat_target)
	qdel(overmap_projectile)
	TEST_PASS("An invalid overmap carrier is discarded without attempting reconstruction.")
	return TRUE

/datum/unit_test/overmap_all_ship_munitions
	name = "OVERMAP: All ship munitions reconstruct and explosive rounds detonate"
	groups = list("map", "overmap")

/datum/unit_test/overmap_all_ship_munitions/start_test()
	var/test_z = SSatlas.current_map?.overmap_z ? SSatlas.current_map.overmap_z : 1
	var/turf/combat_turf = locate(2, 2, test_z)
	TEST_ASSERT_NOTNULL(combat_turf, "Could not locate an overmap turf for the munitions simulation.")

	var/list/explosive_impacts = list(
		SHIP_AMMO_IMPACT_HE,
		SHIP_AMMO_IMPACT_BLASTER,
		SHIP_AMMO_IMPACT_BUNKERBUSTER,
		SHIP_AMMO_IMPACT_ZAT
	)
	var/tested_munitions = 0
	var/test_status = UNIT_TEST_PASSED

	// Enumerate typepaths so newly added loadable ammunition is covered automatically.
	for(var/ammunition_type in subtypesof(/obj/item/ship_ammunition))
		if(is_abstract(ammunition_type))
			continue

		var/obj/item/ship_ammunition/ammunition = new ammunition_type
		if(!ammunition.can_be_loaded())
			qdel(ammunition)
			continue

		tested_munitions++
		if(!ammunition.projectile_type_override)
			test_status = TEST_FAIL("[ammunition_type] has no explicit physical projectile type to reconstruct after overmap travel.")
			qdel(ammunition)
			continue

		// Probes intentionally remain on the overmap and never impact a visitable.
		if(!ammunition.overmap_behaviour)
			qdel(ammunition)
			continue

		var/obj/effect/overmap/visitable/unit_test_combat_target/combat_target = new(combat_turf)
		var/obj/effect/overmap/projectile/unit_test_combat/overmap_projectile = new(combat_turf)
		ammunition.forceMove(overmap_projectile)
		ammunition.fired_projectile_type = ammunition.projectile_type_override
		overmap_projectile.ammunition = ammunition
		overmap_projectile.target = combat_target

		if(!overmap_projectile.check_entry())
			test_status = TEST_FAIL("[ammunition_type] did not enter its overmap combat target.")
		else if(overmap_projectile.entry_calls != 1 || !overmap_projectile.payload_transferred || !overmap_projectile.reconstructed_projectile)
			test_status = TEST_FAIL("[ammunition_type] did not reconstruct and transfer its payload exactly once.")

		var/obj/projectile/ship_ammo/reconstructed = overmap_projectile.reconstructed_projectile
		var/should_explode = reconstructed && ((ammunition.impact_type in explosive_impacts) || max(reconstructed.explosion_strength) > 0)
		if(should_explode)
			// Calling the real on_hit() must enqueue an explosion. Remove that queued
			// work afterward so this test cannot damage the unit-test map.
			var/queued_explosions = length(SSexplosives.work_queue)
			var/obj/effect/unit_test_ship_ammo_impact/impact_target = new(combat_turf)
			reconstructed.forceMove(combat_turf)
			reconstructed.on_hit(impact_target)
			if(length(SSexplosives.work_queue) <= queued_explosions)
				test_status = TEST_FAIL("[ammunition_type] ([ammunition.impact_type]) did not produce an explosion on impact.")
			else
				var/list/test_explosions = SSexplosives.work_queue.Copy(queued_explosions + 1)
				SSexplosives.work_queue -= test_explosions
				QDEL_LIST(test_explosions)
			qdel(impact_target)

		qdel(reconstructed)
		qdel(combat_target)
		qdel(overmap_projectile)

	if(!tested_munitions)
		return TEST_FAIL("No loadable ship munitions were discovered.")
	if(test_status == UNIT_TEST_PASSED)
		TEST_PASS("All [tested_munitions] loadable ship munitions reconstructed; every explosive impact queued an explosion.")
	return TRUE
