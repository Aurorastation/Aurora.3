/// Access marker that, when placed above objects, adds its access requirements to them.
/// Adds, not replaces. So multiple access markers can be placed on the same object.
///
/// Intended use is to define a subtype in code, for example:
/// ```
/// /obj/effect/map_effect/marker/access/security
/// 	req_one_access = list(/datum/access/horizon/security::id)
/// ```
/// And then map that over doors, lockers, buttons, etc, instead of var-editing raw numeric access onto them.
///
/// Only objects that are of a type in `types_whitelist` will be modified.
/// This is the abstract type; define subtypes with the actual access set.
ABSTRACT_TYPE(/obj/effect/map_effect/marker/access)
	name = "access marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "access_marker"

	/// Access requirements added to objects under this marker. All of these are required.
	/// Rarely used, prefer `req_one_access`.
	req_access = null

	/// Access requirements added to objects under this marker. Any one of these is required.
	req_one_access = null

	/// If true, all existing access requirements are removed from the objects before adding this marker's own.
	/// Since markers run in no particular order, do not stack a clearing marker with other access markers.
	var/clear_access = FALSE

	/// Types (and their subtypes) this marker is allowed to add access requirements to.
	/// Anything else is left untouched.
	var/list/types_whitelist = list(
		// doors
		/obj/structure/machinery/door/airlock,
		/obj/structure/machinery/door/window,
		/obj/structure/machinery/door/urban,

		// buttons, controllers, panels
		/obj/structure/machinery/button,
		/obj/structure/machinery/access_button,
		/obj/structure/machinery/embedded_controller,
		/obj/structure/machinery/turretid,
		/obj/structure/machinery/ringer,
		/obj/structure/machinery/alarm,
		/obj/structure/machinery/power/apc,

		// computers and vendors
		/obj/structure/machinery/computer,
		/obj/structure/machinery/vending,
		/obj/structure/machinery/smartfridge/secure,
		/obj/structure/machinery/seed_storage,
		/obj/structure/machinery/chemical_dispenser,

		// lockers, crates, racks
		/obj/structure/closet/secure_closet,
		/obj/structure/closet/crate/secure,
		/obj/structure/closet/walllocker,
		/obj/structure/weapons_rack,
		/obj/item/storage/secure,

		// lockable machinery
		/obj/structure/machinery/porta_turret,
		/obj/structure/machinery/suit_cycler,
		/obj/structure/machinery/power/emitter,
		/obj/structure/machinery/shieldgen,
		/obj/structure/machinery/stasis_cage,

		// spawners and markers that pass their access on to what they spawn
		// note that init order between spawners and the access marker is not guaranteed
		// but it should not matter in practice
		// if marker runs first, spawner gets the access added, and adds it to what it spawns
		// if spawner runs first, then marker adds access to whatever was spawned
		/obj/effect/map_effect/window_spawner,
		/obj/effect/map_effect/marker/airlock,

		// misc
		/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator,
		/obj/structure/machinery/photocopier/faxmachine,
		/obj/structure/sign/double/barsign,
		/obj/item/quikpay,
		/obj/item/holomenu,
		/obj/item/rig,
	)

	/// Types (and their subtypes) this marker never touches, even if they match `types_whitelist`.
	/// For exceptions to a whitelisted parent type.
	var/list/types_blacklist = list(
		// intentionally has no access requirements, as the base type is used all over horizon,
		// on top of doors, so we don't want to change its default engineering access to different one
		// leaving this here as to explain the reasoning for not including it in the types whitelist
		/obj/structure/machinery/door/firedoor,
		// ideally it would be just this one and a subtype like `firedoor/horizon`, without base type
		/obj/structure/machinery/door/firedoor/noid,
	)

/obj/effect/map_effect/marker/access/Initialize(mapload, ...)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/access/LateInitialize()
	if(!isnull(req_access) && !islist(req_access))
		req_access = list(req_access)
	if(!isnull(req_one_access) && !islist(req_one_access))
		req_one_access = list(req_one_access)
	if(!isnull(types_whitelist) && !islist(types_whitelist))
		types_whitelist = list(types_whitelist)
	if(!isnull(types_blacklist) && !islist(types_blacklist))
		types_blacklist = list(types_blacklist)

	dbg_assert(clear_access || length(req_access) || length(req_one_access),
		"Access marker [type] at [x] [y] [z] has no access requirements set.")
	dbg_assert(length(types_whitelist),
		"Access marker [type] at [x] [y] [z] has an empty types whitelist.")

	for(var/obj/thing in loc)
		if(!is_type_in_list(thing, types_whitelist))
			continue
		if(is_type_in_list(thing, types_blacklist))
			continue
		if(clear_access)
			thing.req_access = null
			thing.req_one_access = null
		// `|` makes new lists, so the marker's lists are never shared with or mutated through the object
		if(length(req_access))
			thing.req_access = (thing.req_access || list()) | req_access
		if(length(req_one_access))
			thing.req_one_access = (thing.req_one_access || list()) | req_one_access

	qdel(src)

// ----------------------------------- common subtypes

/// Removes all access requirements from the objects under it, making them usable by anyone.
/obj/effect/map_effect/marker/access/none
	name = "access marker (no access)"
	icon_state = "access_marker_none"
	clear_access = TRUE

// ----------------------------------- generated from map var-edits, to be sorted out

/// Adds one access to `req_one_access` of the objects under it.
ABSTRACT_TYPE(/obj/effect/map_effect/marker/access/req_one)
	name = "access marker (req_one)"

/// Adds one access to `req_access` of the objects under it.
ABSTRACT_TYPE(/obj/effect/map_effect/marker/access/req_all)
	name = "access marker (req_all)"

/obj/effect/map_effect/marker/access/req_one/abandoned_casino
	name = "access marker (req_one: abandoned_casino)"
	req_one_access = list(/datum/access/other/abandoned_casino::id)

/obj/effect/map_effect/marker/access/req_one/armory
	name = "access marker (req_one: armory)"
	req_one_access = list(/datum/access/horizon/armory::id)

/obj/effect/map_effect/marker/access/req_one/atmospherics
	name = "access marker (req_one: atmospherics)"
	req_one_access = list(/datum/access/horizon/atmospherics::id)

/obj/effect/map_effect/marker/access/req_one/bar
	name = "access marker (req_one: bar)"
	req_one_access = list(/datum/access/horizon/bar::id)

/obj/effect/map_effect/marker/access/req_one/bridge_crew
	name = "access marker (req_one: bridge_crew)"
	req_one_access = list(/datum/access/horizon/bridge_crew::id)

/obj/effect/map_effect/marker/access/req_one/canary
	name = "access marker (req_one: canary)"
	req_one_access = list(/datum/access/horizon/canary::id)

/obj/effect/map_effect/marker/access/req_one/captain
	name = "access marker (req_one: captain)"
	req_one_access = list(/datum/access/horizon/captain::id)

/obj/effect/map_effect/marker/access/req_one/cargo
	name = "access marker (req_one: cargo)"
	req_one_access = list(/datum/access/horizon/cargo::id)

/obj/effect/map_effect/marker/access/req_one/ce
	name = "access marker (req_one: ce)"
	req_one_access = list(/datum/access/horizon/ce::id)

/obj/effect/map_effect/marker/access/req_one/cent_ccia
	name = "access marker (req_one: cent_ccia)"
	req_one_access = list(/datum/access/centcomm/cent_ccia::id)

/obj/effect/map_effect/marker/access/req_one/cent_creed
	name = "access marker (req_one: cent_creed)"
	req_one_access = list(/datum/access/centcomm/cent_creed::id)

/obj/effect/map_effect/marker/access/req_one/cent_general
	name = "access marker (req_one: cent_general)"
	req_one_access = list(/datum/access/centcomm/cent_general::id)

/obj/effect/map_effect/marker/access/req_one/cent_medical
	name = "access marker (req_one: cent_medical)"
	req_one_access = list(/datum/access/centcomm/cent_medical::id)

/obj/effect/map_effect/marker/access/req_one/cent_storage
	name = "access marker (req_one: cent_storage)"
	req_one_access = list(/datum/access/centcomm/cent_storage::id)

/obj/effect/map_effect/marker/access/req_one/cent_thunder
	name = "access marker (req_one: cent_thunder)"
	req_one_access = list(/datum/access/centcomm/cent_thunder::id)

/obj/effect/map_effect/marker/access/req_one/chapel_office
	name = "access marker (req_one: chapel_office)"
	req_one_access = list(/datum/access/horizon/chapel_office::id)

/obj/effect/map_effect/marker/access/req_one/coalition
	name = "access marker (req_one: coalition)"
	req_one_access = list(/datum/access/other/coalition::id)

/obj/effect/map_effect/marker/access/req_one/coalition_navy
	name = "access marker (req_one: coalition_navy)"
	req_one_access = list(/datum/access/other/coalition_navy::id)

/obj/effect/map_effect/marker/access/req_one/consular
	name = "access marker (req_one: consular)"
	req_one_access = list(/datum/access/horizon/consular::id)

/obj/effect/map_effect/marker/access/req_one/crevus_artisan_shop
	name = "access marker (req_one: crevus_artisan_shop)"
	req_one_access = list(/datum/access/other/crevus_artisan_shop::id)

/obj/effect/map_effect/marker/access/req_one/crevus_azaula_enforcer
	name = "access marker (req_one: crevus_azaula_enforcer)"
	req_one_access = list(/datum/access/other/crevus_azaula_enforcer::id)

/obj/effect/map_effect/marker/access/req_one/crevus_casino
	name = "access marker (req_one: crevus_casino)"
	req_one_access = list(/datum/access/other/crevus_casino::id)

/obj/effect/map_effect/marker/access/req_one/crevus_clothing_store
	name = "access marker (req_one: crevus_clothing_store)"
	req_one_access = list(/datum/access/other/crevus_clothing_store::id)

/obj/effect/map_effect/marker/access/req_one/crevus_firearm_store
	name = "access marker (req_one: crevus_firearm_store)"
	req_one_access = list(/datum/access/other/crevus_firearm_store::id)

/obj/effect/map_effect/marker/access/req_one/crevus_general_store
	name = "access marker (req_one: crevus_general_store)"
	req_one_access = list(/datum/access/other/crevus_general_store::id)

/obj/effect/map_effect/marker/access/req_one/crevus_nt_pharmacy
	name = "access marker (req_one: crevus_nt_pharmacy)"
	req_one_access = list(/datum/access/other/crevus_nt_pharmacy::id)

/obj/effect/map_effect/marker/access/req_one/crevus_rhan_cresh
	name = "access marker (req_one: crevus_rhan_cresh)"
	req_one_access = list(/datum/access/other/crevus_rhan_cresh::id)

/obj/effect/map_effect/marker/access/req_one/crevus_the_lock
	name = "access marker (req_one: crevus_the_lock)"
	req_one_access = list(/datum/access/other/crevus_the_lock::id)

/obj/effect/map_effect/marker/access/req_one/decrepit_shipyard_staff
	name = "access marker (req_one: decrepit_shipyard_staff)"
	req_one_access = list(/datum/access/other/decrepit_shipyard_staff::id)

/obj/effect/map_effect/marker/access/req_one/dpra
	name = "access marker (req_one: dpra)"
	req_one_access = list(/datum/access/other/dpra::id)

/obj/effect/map_effect/marker/access/req_one/engine
	name = "access marker (req_one: engine)"
	req_one_access = list(/datum/access/horizon/engine::id)

/obj/effect/map_effect/marker/access/req_one/engine_equip
	name = "access marker (req_one: engine_equip)"
	req_one_access = list(/datum/access/horizon/engine_equip::id)

/obj/effect/map_effect/marker/access/req_one/enviro_testing_facility_access_sec
	name = "access marker (req_one: enviro_testing_facility_access_sec)"
	req_one_access = list(/datum/access/other/enviro_testing_facility_access_sec::id)

/obj/effect/map_effect/marker/access/req_one/eva
	name = "access marker (req_one: eva)"
	req_one_access = list(/datum/access/horizon/eva::id)

/obj/effect/map_effect/marker/access/req_one/exress_ship
	name = "access marker (req_one: exress_ship)"
	req_one_access = list(/datum/access/other/exress_ship::id)

/obj/effect/map_effect/marker/access/req_one/external_airlocks
	name = "access marker (req_one: external_airlocks)"
	req_one_access = list(/datum/access/horizon/external_airlocks::id)

/obj/effect/map_effect/marker/access/req_one/forensics_lockers
	name = "access marker (req_one: forensics_lockers)"
	req_one_access = list(/datum/access/horizon/forensics_lockers::id)

/obj/effect/map_effect/marker/access/req_one/gadpathur_navy
	name = "access marker (req_one: gadpathur_navy)"
	req_one_access = list(/datum/access/other/gadpathur_navy::id)

/obj/effect/map_effect/marker/access/req_one/gadpathur_navy_officer
	name = "access marker (req_one: gadpathur_navy_officer)"
	req_one_access = list(/datum/access/other/gadpathur_navy_officer::id)

/obj/effect/map_effect/marker/access/req_one/galley
	name = "access marker (req_one: galley)"
	req_one_access = list(/datum/access/horizon/galley::id)

/obj/effect/map_effect/marker/access/req_one/generic_away_site
	name = "access marker (req_one: generic_away_site)"
	req_one_access = list(/datum/access/other/generic_away_site::id)

/obj/effect/map_effect/marker/access/req_one/golden_deep
	name = "access marker (req_one: golden_deep)"
	req_one_access = list(/datum/access/other/golden_deep::id)

/obj/effect/map_effect/marker/access/req_one/golden_deep_owned
	name = "access marker (req_one: golden_deep_owned)"
	req_one_access = list(/datum/access/other/golden_deep_owned::id)

/obj/effect/map_effect/marker/access/req_one/guest_room_1
	name = "access marker (req_one: guest_room_1)"
	req_one_access = list(/datum/access/other/guest_room_1::id)

/obj/effect/map_effect/marker/access/req_one/guest_room_2
	name = "access marker (req_one: guest_room_2)"
	req_one_access = list(/datum/access/other/guest_room_2::id)

/obj/effect/map_effect/marker/access/req_one/guest_room_3
	name = "access marker (req_one: guest_room_3)"
	req_one_access = list(/datum/access/other/guest_room_3::id)

/obj/effect/map_effect/marker/access/req_one/guest_room_4
	name = "access marker (req_one: guest_room_4)"
	req_one_access = list(/datum/access/other/guest_room_4::id)

/obj/effect/map_effect/marker/access/req_one/guest_rooms
	name = "access marker (req_one: guest_rooms)"
	req_one_access = list(/datum/access/other/guest_rooms::id)

/obj/effect/map_effect/marker/access/req_one/heads
	name = "access marker (req_one: heads)"
	req_one_access = list(/datum/access/horizon/heads::id)

/obj/effect/map_effect/marker/access/req_one/hephaestus
	name = "access marker (req_one: hephaestus)"
	req_one_access = list(/datum/access/other/hephaestus::id)

/obj/effect/map_effect/marker/access/req_one/holding
	name = "access marker (req_one: holding)"
	req_one_access = list(/datum/access/horizon/holding::id)

/obj/effect/map_effect/marker/access/req_one/hop
	name = "access marker (req_one: hop)"
	req_one_access = list(/datum/access/horizon/hop::id)

/obj/effect/map_effect/marker/access/req_one/hydroponics
	name = "access marker (req_one: hydroponics)"
	req_one_access = list(/datum/access/horizon/hydroponics::id)

/obj/effect/map_effect/marker/access/req_one/idris
	name = "access marker (req_one: idris)"
	req_one_access = list(/datum/access/other/idris::id)

/obj/effect/map_effect/marker/access/req_one/imperial_fleet_voidsman_ship
	name = "access marker (req_one: imperial_fleet_voidsman_ship)"
	req_one_access = list(/datum/access/other/imperial_fleet_voidsman_ship::id)

/obj/effect/map_effect/marker/access/req_one/intrepid
	name = "access marker (req_one: intrepid)"
	req_one_access = list(/datum/access/horizon/intrepid::id)

/obj/effect/map_effect/marker/access/req_one/janitor
	name = "access marker (req_one: janitor)"
	req_one_access = list(/datum/access/horizon/janitor::id)

/obj/effect/map_effect/marker/access/req_one/journalist
	name = "access marker (req_one: journalist)"
	req_one_access = list(/datum/access/horizon/journalist::id)

/obj/effect/map_effect/marker/access/req_one/kataphract
	name = "access marker (req_one: kataphract)"
	req_one_access = list(/datum/access/centcomm/kataphract::id)

/obj/effect/map_effect/marker/access/req_one/kataphract_knight
	name = "access marker (req_one: kataphract_knight)"
	req_one_access = list(/datum/access/centcomm/kataphract/knight::id)

/obj/effect/map_effect/marker/access/req_one/lawyer
	name = "access marker (req_one: lawyer)"
	req_one_access = list(/datum/access/horizon/lawyer::id)

/obj/effect/map_effect/marker/access/req_one/library
	name = "access marker (req_one: library)"
	req_one_access = list(/datum/access/horizon/library::id)

/obj/effect/map_effect/marker/access/req_one/maint_tunnels
	name = "access marker (req_one: maint_tunnels)"
	req_one_access = list(/datum/access/horizon/maint_tunnels::id)

/obj/effect/map_effect/marker/access/req_one/medical
	name = "access marker (req_one: medical)"
	req_one_access = list(/datum/access/horizon/medical::id)

/obj/effect/map_effect/marker/access/req_one/medical_equip
	name = "access marker (req_one: medical_equip)"
	req_one_access = list(/datum/access/horizon/medical_equip::id)

/obj/effect/map_effect/marker/access/req_one/mining
	name = "access marker (req_one: mining)"
	req_one_access = list(/datum/access/horizon/mining::id)

/obj/effect/map_effect/marker/access/req_one/morgue
	name = "access marker (req_one: morgue)"
	req_one_access = list(/datum/access/horizon/morgue::id)

/obj/effect/map_effect/marker/access/req_one/nuclear_missile_silo_access
	name = "access marker (req_one: nuclear_missile_silo_access)"
	req_one_access = list(/datum/access/other/nuclear_missile_silo_access::id)

/obj/effect/map_effect/marker/access/req_one/nuclear_missile_silo_access_high
	name = "access marker (req_one: nuclear_missile_silo_access_high)"
	req_one_access = list(/datum/access/other/nuclear_missile_silo_access_high::id)

/obj/effect/map_effect/marker/access/req_one/paramedic
	name = "access marker (req_one: paramedic)"
	req_one_access = list(/datum/access/horizon/paramedic::id)

/obj/effect/map_effect/marker/access/req_one/pharmacy
	name = "access marker (req_one: pharmacy)"
	req_one_access = list(/datum/access/horizon/pharmacy::id)

/obj/effect/map_effect/marker/access/req_one/portofcall_police
	name = "access marker (req_one: portofcall_police)"
	req_one_access = list(/datum/access/other/portofcall_police::id)

/obj/effect/map_effect/marker/access/req_one/portofcall_vendors
	name = "access marker (req_one: portofcall_vendors)"
	req_one_access = list(/datum/access/other/portofcall_vendors::id)

/obj/effect/map_effect/marker/access/req_one/pra
	name = "access marker (req_one: pra)"
	req_one_access = list(/datum/access/other/pra::id)

/obj/effect/map_effect/marker/access/req_one/qm
	name = "access marker (req_one: qm)"
	req_one_access = list(/datum/access/horizon/qm::id)

/obj/effect/map_effect/marker/access/req_one/quark
	name = "access marker (req_one: quark)"
	req_one_access = list(/datum/access/horizon/quark::id)

/obj/effect/map_effect/marker/access/req_one/rd
	name = "access marker (req_one: rd)"
	req_one_access = list(/datum/access/horizon/rd::id)

/obj/effect/map_effect/marker/access/req_one/research
	name = "access marker (req_one: research)"
	req_one_access = list(/datum/access/horizon/research::id)

/obj/effect/map_effect/marker/access/req_one/robotics
	name = "access marker (req_one: robotics)"
	req_one_access = list(/datum/access/horizon/robotics::id)

/obj/effect/map_effect/marker/access/req_one/ruined_propellant_depot_access
	name = "access marker (req_one: ruined_propellant_depot_access)"
	req_one_access = list(/datum/access/other/ruined_propellant_depot_access::id)

/obj/effect/map_effect/marker/access/req_one/sec_doors
	name = "access marker (req_one: sec_doors)"
	req_one_access = list(/datum/access/horizon/sec_doors::id)

/obj/effect/map_effect/marker/access/req_one/security
	name = "access marker (req_one: security)"
	req_one_access = list(/datum/access/horizon/security::id)

/obj/effect/map_effect/marker/access/req_one/sol_ships
	name = "access marker (req_one: sol_ships)"
	req_one_access = list(/datum/access/other/sol_ships::id)

/obj/effect/map_effect/marker/access/req_one/spark
	name = "access marker (req_one: spark)"
	req_one_access = list(/datum/access/horizon/spark::id)

/obj/effect/map_effect/marker/access/req_one/splf_access
	name = "access marker (req_one: splf_access)"
	req_one_access = list(/datum/access/other/splf_access::id)

/obj/effect/map_effect/marker/access/req_one/surgery
	name = "access marker (req_one: surgery)"
	req_one_access = list(/datum/access/horizon/surgery::id)

/obj/effect/map_effect/marker/access/req_one/syndicate
	name = "access marker (req_one: syndicate)"
	req_one_access = list(/datum/access/antag/syndicate::id)

/obj/effect/map_effect/marker/access/req_one/tcaf
	name = "access marker (req_one: tcaf)"
	req_one_access = list(/datum/access/centcomm/tcaf::id)

/obj/effect/map_effect/marker/access/req_one/tox
	name = "access marker (req_one: tox)"
	req_one_access = list(/datum/access/horizon/tox::id)

/obj/effect/map_effect/marker/access/req_one/tramp_freighter_access
	name = "access marker (req_one: tramp_freighter_access)"
	req_one_access = list(/datum/access/other/tramp_freighter_access::id)

/obj/effect/map_effect/marker/access/req_one/unathi_pirate
	name = "access marker (req_one: unathi_pirate)"
	req_one_access = list(/datum/access/other/unathi_pirate::id)

/obj/effect/map_effect/marker/access/req_one/xenoarch
	name = "access marker (req_one: xenoarch)"
	req_one_access = list(/datum/access/horizon/xenoarch::id)

/obj/effect/map_effect/marker/access/req_one/xenobiology
	name = "access marker (req_one: xenobiology)"
	req_one_access = list(/datum/access/horizon/xenobiology::id)

/obj/effect/map_effect/marker/access/req_one/xenobotany
	name = "access marker (req_one: xenobotany)"
	req_one_access = list(/datum/access/horizon/xenobotany::id)

/obj/effect/map_effect/marker/access/req_all/ai_upload
	name = "access marker (req_all: ai_upload)"
	req_access = list(/datum/access/horizon/ai_upload::id)

/obj/effect/map_effect/marker/access/req_all/armory
	name = "access marker (req_all: armory)"
	req_access = list(/datum/access/horizon/armory::id)

/obj/effect/map_effect/marker/access/req_all/atmospherics
	name = "access marker (req_all: atmospherics)"
	req_access = list(/datum/access/horizon/atmospherics::id)

/obj/effect/map_effect/marker/access/req_all/autakh
	name = "access marker (req_all: autakh)"
	req_access = list(/datum/access/other/autakh::id)

/obj/effect/map_effect/marker/access/req_all/bar
	name = "access marker (req_all: bar)"
	req_access = list(/datum/access/horizon/bar::id)

/obj/effect/map_effect/marker/access/req_all/captain
	name = "access marker (req_all: captain)"
	req_access = list(/datum/access/horizon/captain::id)

/obj/effect/map_effect/marker/access/req_all/cargo
	name = "access marker (req_all: cargo)"
	req_access = list(/datum/access/horizon/cargo::id)

/obj/effect/map_effect/marker/access/req_all/ce
	name = "access marker (req_all: ce)"
	req_access = list(/datum/access/horizon/ce::id)

/obj/effect/map_effect/marker/access/req_all/cent_ccia
	name = "access marker (req_all: cent_ccia)"
	req_access = list(/datum/access/centcomm/cent_ccia::id)

/obj/effect/map_effect/marker/access/req_all/cent_creed
	name = "access marker (req_all: cent_creed)"
	req_access = list(/datum/access/centcomm/cent_creed::id)

/obj/effect/map_effect/marker/access/req_all/cent_general
	name = "access marker (req_all: cent_general)"
	req_access = list(/datum/access/centcomm/cent_general::id)

/obj/effect/map_effect/marker/access/req_all/cent_living
	name = "access marker (req_all: cent_living)"
	req_access = list(/datum/access/centcomm/cent_living::id)

/obj/effect/map_effect/marker/access/req_all/cent_specops
	name = "access marker (req_all: cent_specops)"
	req_access = list(/datum/access/centcomm/cent_specops::id)

/obj/effect/map_effect/marker/access/req_all/cent_storage
	name = "access marker (req_all: cent_storage)"
	req_access = list(/datum/access/centcomm/cent_storage::id)

/obj/effect/map_effect/marker/access/req_all/cent_thunder
	name = "access marker (req_all: cent_thunder)"
	req_access = list(/datum/access/centcomm/cent_thunder::id)

/obj/effect/map_effect/marker/access/req_all/chapel_office
	name = "access marker (req_all: chapel_office)"
	req_access = list(/datum/access/horizon/chapel_office::id)

/obj/effect/map_effect/marker/access/req_all/cmo
	name = "access marker (req_all: cmo)"
	req_access = list(/datum/access/horizon/cmo::id)

/obj/effect/map_effect/marker/access/req_all/coalition
	name = "access marker (req_all: coalition)"
	req_access = list(/datum/access/other/coalition::id)

/obj/effect/map_effect/marker/access/req_all/coalition_navy
	name = "access marker (req_all: coalition_navy)"
	req_access = list(/datum/access/other/coalition_navy::id)

/obj/effect/map_effect/marker/access/req_all/consular
	name = "access marker (req_all: consular)"
	req_access = list(/datum/access/horizon/consular::id)

/obj/effect/map_effect/marker/access/req_all/distress
	name = "access marker (req_all: distress)"
	req_access = list(/datum/access/centcomm/distress::id)

/obj/effect/map_effect/marker/access/req_all/dpra
	name = "access marker (req_all: dpra)"
	req_access = list(/datum/access/other/dpra::id)

/obj/effect/map_effect/marker/access/req_all/ee_spy_ship
	name = "access marker (req_all: ee_spy_ship)"
	req_access = list(/datum/access/other/ee_spy_ship::id)

/obj/effect/map_effect/marker/access/req_all/elyran_naval_infantry_ship
	name = "access marker (req_all: elyran_naval_infantry_ship)"
	req_access = list(/datum/access/other/elyran_naval_infantry_ship::id)

/obj/effect/map_effect/marker/access/req_all/engine
	name = "access marker (req_all: engine)"
	req_access = list(/datum/access/horizon/engine::id)

/obj/effect/map_effect/marker/access/req_all/engine_equip
	name = "access marker (req_all: engine_equip)"
	req_access = list(/datum/access/horizon/engine_equip::id)

/obj/effect/map_effect/marker/access/req_all/enviro_testing_facility_access_sec
	name = "access marker (req_all: enviro_testing_facility_access_sec)"
	req_access = list(/datum/access/other/enviro_testing_facility_access_sec::id)

/obj/effect/map_effect/marker/access/req_all/eva
	name = "access marker (req_all: eva)"
	req_access = list(/datum/access/horizon/eva::id)

/obj/effect/map_effect/marker/access/req_all/exress_ship
	name = "access marker (req_all: exress_ship)"
	req_access = list(/datum/access/other/exress_ship::id)

/obj/effect/map_effect/marker/access/req_all/external_airlocks
	name = "access marker (req_all: external_airlocks)"
	req_access = list(/datum/access/horizon/external_airlocks::id)

/obj/effect/map_effect/marker/access/req_all/forensics_lockers
	name = "access marker (req_all: forensics_lockers)"
	req_access = list(/datum/access/horizon/forensics_lockers::id)

/obj/effect/map_effect/marker/access/req_all/gadpathur_navy
	name = "access marker (req_all: gadpathur_navy)"
	req_access = list(/datum/access/other/gadpathur_navy::id)

/obj/effect/map_effect/marker/access/req_all/gadpathur_navy_officer
	name = "access marker (req_all: gadpathur_navy_officer)"
	req_access = list(/datum/access/other/gadpathur_navy_officer::id)

/obj/effect/map_effect/marker/access/req_all/galley
	name = "access marker (req_all: galley)"
	req_access = list(/datum/access/horizon/galley::id)

/obj/effect/map_effect/marker/access/req_all/generic_away_site
	name = "access marker (req_all: generic_away_site)"
	req_access = list(/datum/access/other/generic_away_site::id)

/obj/effect/map_effect/marker/access/req_all/genetics
	name = "access marker (req_all: genetics)"
	req_access = list(/datum/access/horizon/genetics::id)

/obj/effect/map_effect/marker/access/req_all/golden_deep
	name = "access marker (req_all: golden_deep)"
	req_access = list(/datum/access/other/golden_deep::id)

/obj/effect/map_effect/marker/access/req_all/heads
	name = "access marker (req_all: heads)"
	req_access = list(/datum/access/horizon/heads::id)

/obj/effect/map_effect/marker/access/req_all/hephaestus
	name = "access marker (req_all: hephaestus)"
	req_access = list(/datum/access/other/hephaestus::id)

/obj/effect/map_effect/marker/access/req_all/holding
	name = "access marker (req_all: holding)"
	req_access = list(/datum/access/horizon/holding::id)

/obj/effect/map_effect/marker/access/req_all/hop
	name = "access marker (req_all: hop)"
	req_access = list(/datum/access/horizon/hop::id)

/obj/effect/map_effect/marker/access/req_all/hos
	name = "access marker (req_all: hos)"
	req_access = list(/datum/access/horizon/hos::id)

/obj/effect/map_effect/marker/access/req_all/house_volvalaad_ship
	name = "access marker (req_all: house_volvalaad_ship)"
	req_access = list(/datum/access/other/house_volvalaad_ship::id)

/obj/effect/map_effect/marker/access/req_all/hydroponics
	name = "access marker (req_all: hydroponics)"
	req_access = list(/datum/access/horizon/hydroponics::id)

/obj/effect/map_effect/marker/access/req_all/iac_rescue_shit
	name = "access marker (req_all: iac_rescue_shit)"
	req_access = list(/datum/access/other/iac_rescue_shit::id)

/obj/effect/map_effect/marker/access/req_all/idris
	name = "access marker (req_all: idris)"
	req_access = list(/datum/access/other/idris::id)

/obj/effect/map_effect/marker/access/req_all/imperial_fleet_voidsman_ship
	name = "access marker (req_all: imperial_fleet_voidsman_ship)"
	req_access = list(/datum/access/other/imperial_fleet_voidsman_ship::id)

/obj/effect/map_effect/marker/access/req_all/intrepid
	name = "access marker (req_all: intrepid)"
	req_access = list(/datum/access/horizon/intrepid::id)

/obj/effect/map_effect/marker/access/req_all/janitor
	name = "access marker (req_all: janitor)"
	req_access = list(/datum/access/horizon/janitor::id)

/obj/effect/map_effect/marker/access/req_all/journalist
	name = "access marker (req_all: journalist)"
	req_access = list(/datum/access/horizon/journalist::id)

/obj/effect/map_effect/marker/access/req_all/kataphract
	name = "access marker (req_all: kataphract)"
	req_access = list(/datum/access/centcomm/kataphract::id)

/obj/effect/map_effect/marker/access/req_all/lawyer
	name = "access marker (req_all: lawyer)"
	req_access = list(/datum/access/horizon/lawyer::id)

/obj/effect/map_effect/marker/access/req_all/library
	name = "access marker (req_all: library)"
	req_access = list(/datum/access/horizon/library::id)

/obj/effect/map_effect/marker/access/req_all/lone_spacer_access
	name = "access marker (req_all: lone_spacer_access)"
	req_access = list(/datum/access/other/lone_spacer_access::id)

/obj/effect/map_effect/marker/access/req_all/mailsorting
	name = "access marker (req_all: mailsorting)"
	req_access = list(/datum/access/horizon/mailsorting::id)

/obj/effect/map_effect/marker/access/req_all/maint_tunnels
	name = "access marker (req_all: maint_tunnels)"
	req_access = list(/datum/access/horizon/maint_tunnels::id)

/obj/effect/map_effect/marker/access/req_all/medical
	name = "access marker (req_all: medical)"
	req_access = list(/datum/access/horizon/medical::id)

/obj/effect/map_effect/marker/access/req_all/medical_equip
	name = "access marker (req_all: medical_equip)"
	req_access = list(/datum/access/horizon/medical_equip::id)

/obj/effect/map_effect/marker/access/req_all/merchant
	name = "access marker (req_all: merchant)"
	req_access = list(/datum/access/centcomm/merchant::id)

/obj/effect/map_effect/marker/access/req_all/merchants_guild
	name = "access marker (req_all: merchants_guild)"
	req_access = list(/datum/access/other/merchants_guild::id)

/obj/effect/map_effect/marker/access/req_all/mining
	name = "access marker (req_all: mining)"
	req_access = list(/datum/access/horizon/mining::id)

/obj/effect/map_effect/marker/access/req_all/moghes_wasteland_ozeuoi
	name = "access marker (req_all: moghes_wasteland_ozeuoi)"
	req_access = list(/datum/access/other/moghes_wasteland_ozeuoi::id)

/obj/effect/map_effect/marker/access/req_all/morgue
	name = "access marker (req_all: morgue)"
	req_access = list(/datum/access/horizon/morgue::id)

/obj/effect/map_effect/marker/access/req_all/nka
	name = "access marker (req_all: nka)"
	req_access = list(/datum/access/other/nka::id)

/obj/effect/map_effect/marker/access/req_all/nuclear_missile_silo_access
	name = "access marker (req_all: nuclear_missile_silo_access)"
	req_access = list(/datum/access/other/nuclear_missile_silo_access::id)

/obj/effect/map_effect/marker/access/req_all/paramedic
	name = "access marker (req_all: paramedic)"
	req_access = list(/datum/access/horizon/paramedic::id)

/obj/effect/map_effect/marker/access/req_all/pharmacy
	name = "access marker (req_all: pharmacy)"
	req_access = list(/datum/access/horizon/pharmacy::id)

/obj/effect/map_effect/marker/access/req_all/portofcall_police
	name = "access marker (req_all: portofcall_police)"
	req_access = list(/datum/access/other/portofcall_police::id)

/obj/effect/map_effect/marker/access/req_all/portofcall_vendors
	name = "access marker (req_all: portofcall_vendors)"
	req_access = list(/datum/access/other/portofcall_vendors::id)

/obj/effect/map_effect/marker/access/req_all/pra
	name = "access marker (req_all: pra)"
	req_access = list(/datum/access/other/pra::id)

/obj/effect/map_effect/marker/access/req_all/psychiatrist
	name = "access marker (req_all: psychiatrist)"
	req_access = list(/datum/access/horizon/psychiatrist::id)

/obj/effect/map_effect/marker/access/req_all/qm
	name = "access marker (req_all: qm)"
	req_access = list(/datum/access/horizon/qm::id)

/obj/effect/map_effect/marker/access/req_all/rd
	name = "access marker (req_all: rd)"
	req_access = list(/datum/access/horizon/rd::id)

/obj/effect/map_effect/marker/access/req_all/research
	name = "access marker (req_all: research)"
	req_access = list(/datum/access/horizon/research::id)

/obj/effect/map_effect/marker/access/req_all/robotics
	name = "access marker (req_all: robotics)"
	req_access = list(/datum/access/horizon/robotics::id)

/obj/effect/map_effect/marker/access/req_all/sec_doors
	name = "access marker (req_all: sec_doors)"
	req_access = list(/datum/access/horizon/sec_doors::id)

/obj/effect/map_effect/marker/access/req_all/security
	name = "access marker (req_all: security)"
	req_access = list(/datum/access/horizon/security::id)

/obj/effect/map_effect/marker/access/req_all/ship_weapons
	name = "access marker (req_all: ship_weapons)"
	req_access = list(/datum/access/horizon/ship_weapons::id)

/obj/effect/map_effect/marker/access/req_all/skrell
	name = "access marker (req_all: skrell)"
	req_access = list(/datum/access/other/skrell::id)

/obj/effect/map_effect/marker/access/req_all/sol_ships
	name = "access marker (req_all: sol_ships)"
	req_access = list(/datum/access/other/sol_ships::id)

/obj/effect/map_effect/marker/access/req_all/splf_access
	name = "access marker (req_all: splf_access)"
	req_access = list(/datum/access/other/splf_access::id)

/obj/effect/map_effect/marker/access/req_all/surgery
	name = "access marker (req_all: surgery)"
	req_access = list(/datum/access/horizon/surgery::id)

/obj/effect/map_effect/marker/access/req_all/syndicate
	name = "access marker (req_all: syndicate)"
	req_access = list(/datum/access/antag/syndicate::id)

/obj/effect/map_effect/marker/access/req_all/tcaf
	name = "access marker (req_all: tcaf)"
	req_access = list(/datum/access/centcomm/tcaf::id)

/obj/effect/map_effect/marker/access/req_all/tcomsat
	name = "access marker (req_all: tcomsat)"
	req_access = list(/datum/access/horizon/tcomsat::id)

/obj/effect/map_effect/marker/access/req_all/tech_storage
	name = "access marker (req_all: tech_storage)"
	req_access = list(/datum/access/horizon/tech_storage::id)

/obj/effect/map_effect/marker/access/req_all/tox
	name = "access marker (req_all: tox)"
	req_access = list(/datum/access/horizon/tox::id)

/obj/effect/map_effect/marker/access/req_all/tramp_freighter_access
	name = "access marker (req_all: tramp_freighter_access)"
	req_access = list(/datum/access/other/tramp_freighter_access::id)

/obj/effect/map_effect/marker/access/req_all/unathi_pirate
	name = "access marker (req_all: unathi_pirate)"
	req_access = list(/datum/access/other/unathi_pirate::id)

/obj/effect/map_effect/marker/access/req_all/unathi_trawler_access
	name = "access marker (req_all: unathi_trawler_access)"
	req_access = list(/datum/access/other/unathi_trawler_access::id)

/obj/effect/map_effect/marker/access/req_all/virology
	name = "access marker (req_all: virology)"
	req_access = list(/datum/access/horizon/virology::id)

/obj/effect/map_effect/marker/access/req_all/voidtamer_ship
	name = "access marker (req_all: voidtamer_ship)"
	req_access = list(/datum/access/other/voidtamer_ship::id)

/obj/effect/map_effect/marker/access/req_all/xenoarch
	name = "access marker (req_all: xenoarch)"
	req_access = list(/datum/access/horizon/xenoarch::id)

/obj/effect/map_effect/marker/access/req_all/xenobiology
	name = "access marker (req_all: xenobiology)"
	req_access = list(/datum/access/horizon/xenobiology::id)

/obj/effect/map_effect/marker/access/req_all/xenobotany
	name = "access marker (req_all: xenobotany)"
	req_access = list(/datum/access/horizon/xenobotany::id)
