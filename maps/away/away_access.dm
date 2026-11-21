/*******
* Misc *
*******/
ABSTRACT_TYPE(/datum/access/away)

/datum/access/away/equipment
	id = 199
	desc = "Equipment"
	access_type = ACCESS_TYPE_NONE

/datum/access/away/crate_cash
	id = 200
	access_type = ACCESS_TYPE_NONE

/datum/access/away/exress_ship
	id = 201
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/exress_ship
	name = "access marker (req_one: exress_ship)"
	req_one_access = list(/datum/access/away/exress_ship::id)

/obj/effect/map_effect/marker/access/req_all/exress_ship
	name = "access marker (req_all: exress_ship)"
	req_access = list(/datum/access/away/exress_ship::id)

/datum/access/away/generic_away_site
	id = 202
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/generic_away_site
	name = "access marker (req_one: generic_away_site)"
	req_one_access = list(/datum/access/away/generic_away_site::id)

/obj/effect/map_effect/marker/access/req_all/generic_away_site
	name = "access marker (req_all: generic_away_site)"
	req_access = list(/datum/access/away/generic_away_site::id)

/datum/access/away/none
	id = -1
	access_type = ACCESS_TYPE_NONE

/datum/access/away/sol_ships
	id = 203
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/sol_ships
	name = "access marker (req_one: sol_ships)"
	req_one_access = list(/datum/access/away/sol_ships::id)

/obj/effect/map_effect/marker/access/req_all/sol_ships
	name = "access marker (req_all: sol_ships)"
	req_access = list(/datum/access/away/sol_ships::id)

/// 204 is vacant

/datum/access/away/ee_spy_ship
	id = 205
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/ee_spy_ship
	name = "access marker (req_all: ee_spy_ship)"
	req_access = list(/datum/access/away/ee_spy_ship::id)

/datum/access/away/civilian_station
	id = 206
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/away/elyran_naval_infantry_ship
	id = 207
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/elyran_naval_infantry_ship
	name = "access marker (req_all: elyran_naval_infantry_ship)"
	req_access = list(/datum/access/away/elyran_naval_infantry_ship::id)

/datum/access/away/skrell
	id = 208
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/skrell
	name = "access marker (req_all: skrell)"
	req_access = list(/datum/access/away/skrell::id)

/datum/access/away/pra
	id = 209
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/pra
	name = "access marker (req_one: pra)"
	req_one_access = list(/datum/access/away/pra::id)

/obj/effect/map_effect/marker/access/req_all/pra
	name = "access marker (req_all: pra)"
	req_access = list(/datum/access/away/pra::id)

/datum/access/away/unathi_pirate
	id = 210
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/unathi_pirate
	name = "access marker (req_one: unathi_pirate)"
	req_one_access = list(/datum/access/away/unathi_pirate::id)

/obj/effect/map_effect/marker/access/req_all/unathi_pirate
	name = "access marker (req_all: unathi_pirate)"
	req_access = list(/datum/access/away/unathi_pirate::id)

/datum/access/away/iac_rescue_shit
	id = 211
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/iac_rescue_shit
	name = "access marker (req_all: iac_rescue_shit)"
	req_access = list(/datum/access/away/iac_rescue_shit::id)

/datum/access/away/imperial_fleet_voidsman_ship
	id = 212
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/imperial_fleet_voidsman_ship
	name = "access marker (req_one: imperial_fleet_voidsman_ship)"
	req_one_access = list(/datum/access/away/imperial_fleet_voidsman_ship::id)

/obj/effect/map_effect/marker/access/req_all/imperial_fleet_voidsman_ship
	name = "access marker (req_all: imperial_fleet_voidsman_ship)"
	req_access = list(/datum/access/away/imperial_fleet_voidsman_ship::id)

/datum/access/away/nka
	id = 213
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/nka
	name = "access marker (req_all: nka)"
	req_access = list(/datum/access/away/nka::id)

/datum/access/away/dpra
	id = 214
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/dpra
	name = "access marker (req_one: dpra)"
	req_one_access = list(/datum/access/away/dpra::id)

/obj/effect/map_effect/marker/access/req_all/dpra
	name = "access marker (req_all: dpra)"
	req_access = list(/datum/access/away/dpra::id)

/datum/access/away/merchants_guild
	id = 215
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/merchants_guild
	name = "access marker (req_all: merchants_guild)"
	req_access = list(/datum/access/away/merchants_guild::id)

/datum/access/away/hephaestus
	id = 216
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/hephaestus
	name = "access marker (req_one: hephaestus)"
	req_one_access = list(/datum/access/away/hephaestus::id)

/obj/effect/map_effect/marker/access/req_all/hephaestus
	name = "access marker (req_all: hephaestus)"
	req_access = list(/datum/access/away/hephaestus::id)

// For the Golden Deep ghostrole. This is the access for the merchant and guards, but not for the owned synthetics.
/datum/access/away/golden_deep
	id = 217
	access_type = ACCESS_TYPE_CENTCOM
	desc = "Golden Deep"

/obj/effect/map_effect/marker/access/req_one/golden_deep
	name = "access marker (req_one: golden_deep)"
	req_one_access = list(/datum/access/away/golden_deep::id)

/obj/effect/map_effect/marker/access/req_all/golden_deep
	name = "access marker (req_all: golden_deep)"
	req_access = list(/datum/access/away/golden_deep::id)

/datum/access/away/portofcall_police
	id = 218
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/portofcall_police
	name = "access marker (req_one: portofcall_police)"
	req_one_access = list(/datum/access/away/portofcall_police::id)

/obj/effect/map_effect/marker/access/req_all/portofcall_police
	name = "access marker (req_all: portofcall_police)"
	req_access = list(/datum/access/away/portofcall_police::id)

/datum/access/away/portofcall_vendors
	id = 219
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/portofcall_vendors
	name = "access marker (req_one: portofcall_vendors)"
	req_one_access = list(/datum/access/away/portofcall_vendors::id)

/obj/effect/map_effect/marker/access/req_all/portofcall_vendors
	name = "access marker (req_all: portofcall_vendors)"
	req_access = list(/datum/access/away/portofcall_vendors::id)

/datum/access/away/idris
	id = 220
	desc = "Idris Ship Crew Member"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/idris
	name = "access marker (req_one: idris)"
	req_one_access = list(/datum/access/away/idris::id)

/obj/effect/map_effect/marker/access/req_all/idris
	name = "access marker (req_all: idris)"
	req_access = list(/datum/access/away/idris::id)

/datum/access/away/coalition
	id = 221
	desc = "Coalition of Colonies"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/coalition
	name = "access marker (req_one: coalition)"
	req_one_access = list(/datum/access/away/coalition::id)

/obj/effect/map_effect/marker/access/req_all/coalition
	name = "access marker (req_all: coalition)"
	req_access = list(/datum/access/away/coalition::id)

/datum/access/away/coalition_navy
	id = 222
	desc = "Coalition Navy"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/coalition_navy
	name = "access marker (req_one: coalition_navy)"
	req_one_access = list(/datum/access/away/coalition_navy::id)

/obj/effect/map_effect/marker/access/req_all/coalition_navy
	name = "access marker (req_all: coalition_navy)"
	req_access = list(/datum/access/away/coalition_navy::id)

/datum/access/away/gadpathur_navy
	id = 223
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/gadpathur_navy
	name = "access marker (req_one: gadpathur_navy)"
	req_one_access = list(/datum/access/away/gadpathur_navy::id)

/obj/effect/map_effect/marker/access/req_all/gadpathur_navy
	name = "access marker (req_all: gadpathur_navy)"
	req_access = list(/datum/access/away/gadpathur_navy::id)

/datum/access/away/gadpathur_navy_officer
	id = 224
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/gadpathur_navy_officer
	name = "access marker (req_one: gadpathur_navy_officer)"
	req_one_access = list(/datum/access/away/gadpathur_navy_officer::id)

/obj/effect/map_effect/marker/access/req_all/gadpathur_navy_officer
	name = "access marker (req_all: gadpathur_navy_officer)"
	req_access = list(/datum/access/away/gadpathur_navy_officer::id)

/datum/access/away/portofcall_corporate
	id = 225
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/away/house_volvalaad_ship
	id = 226
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/house_volvalaad_ship
	name = "access marker (req_all: house_volvalaad_ship)"
	req_access = list(/datum/access/away/house_volvalaad_ship::id)

/datum/access/away/moghes_wasteland_ozeuoi
	id = 227
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/moghes_wasteland_ozeuoi
	name = "access marker (req_all: moghes_wasteland_ozeuoi)"
	req_access = list(/datum/access/away/moghes_wasteland_ozeuoi::id)

/datum/access/away/autakh
	id = 228
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/autakh
	name = "access marker (req_all: autakh)"
	req_access = list(/datum/access/away/autakh::id)

// For the Golden Deep ghostrole. This is for the owned synthetics, so they lack some of the access their superiors enjoy.
/datum/access/away/golden_deep_owned
	id = 229
	access_type = ACCESS_TYPE_CENTCOM
	desc = "Golden Deep, Limited Access"

/obj/effect/map_effect/marker/access/req_one/golden_deep_owned
	name = "access marker (req_one: golden_deep_owned)"
	req_one_access = list(/datum/access/away/golden_deep_owned::id)

//guest rooms - for any ship/event that requires hotel-esque rooms

/datum/access/away/guest_rooms
	id = 230
	desc = "Guest Rooms - All"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/guest_rooms
	name = "access marker (req_one: guest_rooms)"
	req_one_access = list(/datum/access/away/guest_rooms::id)

/datum/access/away/guest_room_1
	id = 231
	desc = "Guest Room 1"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/guest_room_1
	name = "access marker (req_one: guest_room_1)"
	req_one_access = list(/datum/access/away/guest_room_1::id)

/datum/access/away/guest_room_2
	id = 232
	desc = "Guest Room 2"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/guest_room_2
	name = "access marker (req_one: guest_room_2)"
	req_one_access = list(/datum/access/away/guest_room_2::id)

/datum/access/away/guest_room_3
	id = 233
	desc = "Guest Room 3"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/guest_room_3
	name = "access marker (req_one: guest_room_3)"
	req_one_access = list(/datum/access/away/guest_room_3::id)

/datum/access/away/guest_room_4
	id = 234
	desc = "Guest Room 4"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/guest_room_4
	name = "access marker (req_one: guest_room_4)"
	req_one_access = list(/datum/access/away/guest_room_4::id)

/datum/access/away/guest_room_5
	id = 235
	desc = "Guest Room 5"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/away/guest_room_6
	id = 236
	desc = "Guest Room 6"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/away/guest_room_7
	id = 237
	desc = "Guest Room 7"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/away/guest_room_8
	id = 238
	desc = "Guest Room 8"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/away/guest_room_9
	id = 239
	desc = "Guest Room 9"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/away/guest_room_10
	id = 240
	desc = "Guest Room 10"

/datum/access/away/unathi_trawler_access
	id = 241
	desc = "General Fishing Trawler Access"

/obj/effect/map_effect/marker/access/req_all/unathi_trawler_access
	name = "access marker (req_all: unathi_trawler_access)"
	req_access = list(/datum/access/away/unathi_trawler_access::id)

/datum/access/away/tramp_freighter_access
	id = 242
	desc = "Independent Freighter Access"

/obj/effect/map_effect/marker/access/req_one/tramp_freighter_access
	name = "access marker (req_one: tramp_freighter_access)"
	req_one_access = list(/datum/access/away/tramp_freighter_access::id)

/obj/effect/map_effect/marker/access/req_all/tramp_freighter_access
	name = "access marker (req_all: tramp_freighter_access)"
	req_access = list(/datum/access/away/tramp_freighter_access::id)

/datum/access/away/lone_spacer_access
	id = 243
	desc = "Independent Skiff Access"

/obj/effect/map_effect/marker/access/req_all/lone_spacer_access
	name = "access marker (req_all: lone_spacer_access)"
	req_access = list(/datum/access/away/lone_spacer_access::id)

/datum/access/away/cryo_outpost_access
	id = 244
	desc = "Outpost #187-D Access"

/datum/access/away/ruined_propellant_depot_access
	id = 245
	desc = "Propellant Depot AG5 Access"

/obj/effect/map_effect/marker/access/req_one/ruined_propellant_depot_access
	name = "access marker (req_one: ruined_propellant_depot_access)"
	req_one_access = list(/datum/access/away/ruined_propellant_depot_access::id)

/datum/access/away/splf_access
	id = 246
	desc = "SPLF Access"

/obj/effect/map_effect/marker/access/req_one/splf_access
	name = "access marker (req_one: splf_access)"
	req_one_access = list(/datum/access/away/splf_access::id)

/obj/effect/map_effect/marker/access/req_all/splf_access
	name = "access marker (req_all: splf_access)"
	req_access = list(/datum/access/away/splf_access::id)

/datum/access/away/nuclear_missile_silo_access
	id = 247
	desc = "Nuclear Missile Silo Access"

/obj/effect/map_effect/marker/access/req_one/nuclear_missile_silo_access
	name = "access marker (req_one: nuclear_missile_silo_access)"
	req_one_access = list(/datum/access/away/nuclear_missile_silo_access::id)

/obj/effect/map_effect/marker/access/req_all/nuclear_missile_silo_access
	name = "access marker (req_all: nuclear_missile_silo_access)"
	req_access = list(/datum/access/away/nuclear_missile_silo_access::id)

/datum/access/away/nuclear_missile_silo_access_high
	id = 248
	desc = "Nuclear Missile Silo Access High Security"

/obj/effect/map_effect/marker/access/req_one/nuclear_missile_silo_access_high
	name = "access marker (req_one: nuclear_missile_silo_access_high)"
	req_one_access = list(/datum/access/away/nuclear_missile_silo_access_high::id)

/datum/access/away/enviro_testing_facility_access_control
	id = 249
	desc = "Env-Test Facility Zoya, Control Access"

/datum/access/away/enviro_testing_facility_access_medres
	id = 250
	desc = "Env-Test Facility Zoya, Medical-Research Access"

/datum/access/away/enviro_testing_facility_access_engops
	id = 251
	desc = "Env-Test Facility Zoya, Engineering-Operations Access"

/datum/access/away/enviro_testing_facility_access_sec
	id = 252
	desc = "Env-Test Facility Zoya, Security Access"
	id = 253
	desc = "Himean Military Patrol Vessel"

/obj/effect/map_effect/marker/access/req_one/enviro_testing_facility_access_sec
	name = "access marker (req_one: enviro_testing_facility_access_sec)"
	req_one_access = list(/datum/access/away/enviro_testing_facility_access_sec::id)

/obj/effect/map_effect/marker/access/req_all/enviro_testing_facility_access_sec
	name = "access marker (req_all: enviro_testing_facility_access_sec)"
	req_access = list(/datum/access/away/enviro_testing_facility_access_sec::id)

/datum/access/away/quarantined_outpost_engineer
	id = 254
	desc = "Outpost Nemora, Engineering Clearance"

/datum/access/away/decrepit_shipyard_staff
	id = 255
	desc = "Decrepit Shipyard, Staff Access"

/obj/effect/map_effect/marker/access/req_one/decrepit_shipyard_staff
	name = "access marker (req_one: decrepit_shipyard_staff)"
	req_one_access = list(/datum/access/away/decrepit_shipyard_staff::id)

/datum/access/away/voidtamer_ship
	id = 256
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/voidtamer_ship
	name = "access marker (req_all: voidtamer_ship)"
	req_access = list(/datum/access/away/voidtamer_ship::id)

/datum/access/away/abandoned_casino
	id = 257

/datum/access/away/crevus_rhan_cresh
	id = 258
	desc = "Rhan-Cresh Charities', Highway Patrol Office Access"

/obj/effect/map_effect/marker/access/req_one/crevus_rhan_cresh
	name = "access marker (req_one: crevus_rhan_cresh)"
	req_one_access = list(/datum/access/away/crevus_rhan_cresh::id)

/datum/access/away/crevus_azaula_enforcer
	id = 259
	desc = "Azaula Entertainment, Enforcer Office Access"

/obj/effect/map_effect/marker/access/req_one/crevus_azaula_enforcer
	name = "access marker (req_one: crevus_azaula_enforcer)"
	req_one_access = list(/datum/access/away/crevus_azaula_enforcer::id)

/datum/access/away/crevus_the_lock
	id = 260
	desc = "The Lock Hideout Access"

/obj/effect/map_effect/marker/access/req_one/crevus_the_lock
	name = "access marker (req_one: crevus_the_lock)"
	req_one_access = list(/datum/access/away/crevus_the_lock::id)

/datum/access/away/crevus_casino
	id = 261
	desc = "Keltra Zav Nikal, Casino Access"

/obj/effect/map_effect/marker/access/req_one/crevus_casino
	name = "access marker (req_one: crevus_casino)"
	req_one_access = list(/datum/access/away/crevus_casino::id)

/datum/access/away/crevus_general_store
	id = 262
	desc = "Ane-Mart Staff Access"

/obj/effect/map_effect/marker/access/req_one/crevus_general_store
	name = "access marker (req_one: crevus_general_store)"
	req_one_access = list(/datum/access/away/crevus_general_store::id)

/datum/access/away/crevus_firearm_store
	id = 263
	desc = "Firearm Store Access"

/obj/effect/map_effect/marker/access/req_one/crevus_firearm_store
	name = "access marker (req_one: crevus_firearm_store)"
	req_one_access = list(/datum/access/away/crevus_firearm_store::id)

/datum/access/away/crevus_nt_pharmacy
	id = 264
	desc = "NanoTrasen Pharmacy Access"

/obj/effect/map_effect/marker/access/req_one/crevus_nt_pharmacy
	name = "access marker (req_one: crevus_nt_pharmacy)"
	req_one_access = list(/datum/access/away/crevus_nt_pharmacy::id)

/datum/access/away/crevus_artisan_shop
	id = 265
	desc = "Artisan Shop Access"

/obj/effect/map_effect/marker/access/req_one/crevus_artisan_shop
	name = "access marker (req_one: crevus_artisan_shop)"
	req_one_access = list(/datum/access/away/crevus_artisan_shop::id)

/datum/access/away/crevus_clothing_store
	id = 266
	desc = "Clothing Store Access"

/obj/effect/map_effect/marker/access/req_one/crevus_clothing_store
	name = "access marker (req_one: crevus_clothing_store)"
	req_one_access = list(/datum/access/away/crevus_clothing_store::id)

/datum/access/away/modular_freelancer_ship
	id = 267
	desc = "Freelancer Ship Access"
