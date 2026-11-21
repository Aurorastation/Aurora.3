/***************
* Antag access *
***************/
ABSTRACT_TYPE(/datum/access/antag)

/datum/access/antag/syndicate
	id = 150//General
	access_type = ACCESS_TYPE_SYNDICATE

/obj/effect/map_effect/marker/access/req_one/syndicate
	name = "access marker (req_one: syndicate)"
	req_one_access = list(/datum/access/antag/syndicate::id)

/obj/effect/map_effect/marker/access/req_all/syndicate
	name = "access marker (req_all: syndicate)"
	req_access = list(/datum/access/antag/syndicate::id)

/datum/access/antag/syndicate_leader
	id = 151
	access_type = ACCESS_TYPE_SYNDICATE

/******************
* Central Command *
******************/
ABSTRACT_TYPE(/datum/access/centcomm)

//General facilities. - Everyone on central has that --> Use this for doors that every central role should have access to, but not the aurora people
/datum/access/centcomm/cent_general
	id = 101
	desc = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/cent_general
	name = "access marker (req_one: cent_general)"
	req_one_access = list(/datum/access/centcomm/cent_general::id)

/obj/effect/map_effect/marker/access/req_all/cent_general
	name = "access marker (req_all: cent_general)"
	req_access = list(/datum/access/centcomm/cent_general::id)

//Thunderdome.
/datum/access/centcomm/cent_thunder
	id = 102
	desc = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/cent_thunder
	name = "access marker (req_one: cent_thunder)"
	req_one_access = list(/datum/access/centcomm/cent_thunder::id)

/obj/effect/map_effect/marker/access/req_all/cent_thunder
	name = "access marker (req_all: cent_thunder)"
	req_access = list(/datum/access/centcomm/cent_thunder::id)

//Centcom Security - This access is used by the ERT / Odin Security and CCIA
// Separation between Odin Sec/CCIA and ERT is achieved via the ERT Commander Access (/datum/access/centcomm/cent_creed::id)
/datum/access/centcomm/cent_specops
	id = 103
	desc = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/cent_specops
	name = "access marker (req_all: cent_specops)"
	req_access = list(/datum/access/centcomm/cent_specops::id)

//Medical/Research - Thats the access for the medical section. Used for the odin doctors/chemists
/datum/access/centcomm/cent_medical
	id = 104
	desc = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/cent_medical
	name = "access marker (req_one: cent_medical)"
	req_one_access = list(/datum/access/centcomm/cent_medical::id)

//Living quarters, the access used by the odin bartenders/chefs
/datum/access/centcomm/cent_living
	id = 105
	desc = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/cent_living
	name = "access marker (req_all: cent_living)"
	req_access = list(/datum/access/centcomm/cent_living::id)

//Generic storage areas, used for the Maint Tunnels on Centcom
/datum/access/centcomm/cent_storage
	id = 106
	desc = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/cent_storage
	name = "access marker (req_one: cent_storage)"
	req_one_access = list(/datum/access/centcomm/cent_storage::id)

/obj/effect/map_effect/marker/access/req_all/cent_storage
	name = "access marker (req_all: cent_storage)"
	req_access = list(/datum/access/centcomm/cent_storage::id)

//107 is unused

//Creed's office. - ERT/TCFL Commander
/datum/access/centcomm/cent_creed
	id = 108
	desc = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/cent_creed
	name = "access marker (req_one: cent_creed)"
	req_one_access = list(/datum/access/centcomm/cent_creed::id)

/obj/effect/map_effect/marker/access/req_all/cent_creed
	name = "access marker (req_all: cent_creed)"
	req_access = list(/datum/access/centcomm/cent_creed::id)

//CCIA Access on Centcom
/datum/access/centcomm/cent_ccia
	id = 109
	desc = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/cent_ccia
	name = "access marker (req_one: cent_ccia)"
	req_one_access = list(/datum/access/centcomm/cent_ccia::id)

/obj/effect/map_effect/marker/access/req_all/cent_ccia
	name = "access marker (req_all: cent_ccia)"
	req_access = list(/datum/access/centcomm/cent_ccia::id)

/datum/access/centcomm/merchant
	id = 110//merchant
	desc = "Merchant Access"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/merchant
	name = "access marker (req_all: merchant)"
	req_access = list(/datum/access/centcomm/merchant::id)

/datum/access/centcomm/tcaf
	id = 111//tau
	desc = "Tau Ceti Armed Forces Access"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/tcaf
	name = "access marker (req_one: tcaf)"
	req_one_access = list(/datum/access/centcomm/tcaf::id)

/obj/effect/map_effect/marker/access/req_all/tcaf
	name = "access marker (req_all: tcaf)"
	req_access = list(/datum/access/centcomm/tcaf::id)

/datum/access/centcomm/distress
	id = 112
	desc = "General ERT Base Access"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_all/distress
	name = "access marker (req_all: distress)"
	req_access = list(/datum/access/centcomm/distress::id)

/****************************
* Kataphract Chapter Access *
****************************/
/datum/access/centcomm/kataphract
	id = 113
	desc = "Kataphract Chapter Access"
	access_type = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/kataphract
	name = "access marker (req_one: kataphract)"
	req_one_access = list(/datum/access/centcomm/kataphract::id)

/obj/effect/map_effect/marker/access/req_all/kataphract
	name = "access marker (req_all: kataphract)"
	req_access = list(/datum/access/centcomm/kataphract::id)

/datum/access/centcomm/kataphract/knight
	id = 114
	desc = "Kataphract Knight Access"

/obj/effect/map_effect/marker/access/req_one/kataphract_knight
	name = "access marker (req_one: kataphract_knight)"
	req_one_access = list(/datum/access/centcomm/kataphract/knight::id)
