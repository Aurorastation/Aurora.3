//
// Role Groups and Faction Groups Defines
//

// Groups
// Used to know what roles are part of which department or group.
// Notes on COMMAND_SUPPORT_ROLES: HRA is an admin job. Representative is under ALL_FACTION_ROLES. Consular intentionally not included as they are independent.
#define ADMIN_ROLES list(/datum/job/hra)

#define COMMAND_ROLES list(/datum/job/captain, /datum/job/xo, /datum/job/chief_engineer, /datum/job/cmo, /datum/job/rd, /datum/job/hos, /datum/job/operations_manager)
#define COMMAND_SUPPORT_ROLES list(/datum/job/bridge_crew)
#define SCIENCE_ROLES list(/datum/job/scientist, /datum/job/xenoarchaeologist, /datum/job/xenobiologist, /datum/job/xenobotanist, /datum/job/intern_sci)
#define MEDICAL_ROLES list(/datum/job/doctor, /datum/job/surgeon, /datum/job/pharmacist, /datum/job/psychiatrist, /datum/job/med_tech, /datum/job/intern_med)
#define ENGINEERING_ROLES list(/datum/job/engineer, /datum/job/atmos, /datum/job/intern_eng)
#define SERVICE_ROLES list(/datum/job/chaplain, /datum/job/bartender, /datum/job/chef, /datum/job/hydro, /datum/job/janitor, /datum/job/journalist, /datum/job/librarian)
#define CIVILIAN_ROLES list(/datum/job/assistant, /datum/job/visitor, /datum/job/passenger)
#define SECURITY_ROLES list(/datum/job/warden, /datum/job/investigator, /datum/job/officer, /datum/job/intern_sec)
#define OPERATIONS_ROLES list(/datum/job/hangar_tech, /datum/job/mining, /datum/job/machinist)
#define EQUIPMENT_ROLES list(/datum/job/ai, /datum/job/cyborg)

#define ALL_ROLES list(COMMAND_ROLES, COMMAND_SUPPORT_ROLES, ENGINEERING_ROLES, SERVICE_ROLES, CIVILIAN_ROLES, OPERATIONS_ROLES, MEDICAL_ROLES, SCIENCE_ROLES, SECURITY_ROLES, EQUIPMENT_ROLES)
#define ALL_FACTION_ROLES list(/datum/job/representative, /datum/job/assistant, /datum/job/visitor)

// Factions
// Used to know what what roles are allowed to play as which factions.
// Note that independent isn't a faction by itself, as faction in this case means a megacorporation.
#define SCC_ROLES list(COMMAND_ROLES, COMMAND_SUPPORT_ROLES, EQUIPMENT_ROLES, ALL_FACTION_ROLES)
#define NT_ROLES list(SCIENCE_ROLES, MEDICAL_ROLES, SERVICE_ROLES, ALL_FACTION_ROLES)
#define PMC_ROLES list(SECURITY_ROLES, MEDICAL_ROLES, ALL_FACTION_ROLES)
#define IDRIS_ROLES list(SECURITY_ROLES, SERVICE_ROLES, ALL_FACTION_ROLES)
#define ZAVOD_ROLES list(SECURITY_ROLES, SCIENCE_ROLES, ENGINEERING_ROLES, ALL_FACTION_ROLES)
#define ZENG_ROLES list(SCIENCE_ROLES, MEDICAL_ROLES, ALL_FACTION_ROLES)
#define HEPH_ROLES list(OPERATIONS_ROLES, ENGINEERING_ROLES, ALL_FACTION_ROLES)
#define ORION_ROLES list(OPERATIONS_ROLES, ALL_FACTION_ROLES)
#define INDEP_ROLES list(CIVILIAN_ROLES, /datum/job/merchant, /datum/job/consular, /datum/job/journalist, /datum/job/chaplain)