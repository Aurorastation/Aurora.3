//
// Role and Faction Defines
//

// Singular Roles
#define OFF_DUTY_CREW_MEMBER_ROLE /datum/job/visitor
#define REPRESENTATIVE_ROLE /datum/job/representative
#define CONSULAR_ROLE /datum/job/consular
#define JOURNALIST_ROLE /datum/job/journalist
#define CHAPLAIN_ROLE /datum/job/chaplain

// Departments
// Used to know what roles are part of which department.
// Notes on COMMAND_SUPPORT_ROLES: HRA is an admin job. Representative is under ALL_FACTION_ROLES. Consular intentionally not included as they are independent.
#define ADMIN_ROLES list(/datum/job/hra)

#define COMMAND_ROLES list(/datum/job/captain, /datum/job/xo, /datum/job/chief_engineer, /datum/job/cmo, /datum/job/rd, /datum/job/hos, /datum/job/operations_manager)
#define COMMAND_SUPPORT_ROLES list(/datum/job/bridge_crew)
#define SCIENCE_ROLES list(/datum/job/scientist, /datum/job/xenoarchaeologist, /datum/job/xenobiologist, /datum/job/xenobotanist, /datum/job/intern_sci)
#define MEDICAL_ROLES list(/datum/job/doctor, /datum/job/surgeon, /datum/job/pharmacist, /datum/job/psychiatrist, /datum/job/med_tech, /datum/job/intern_med)
#define ENGINEERING_ROLES list(/datum/job/engineer, /datum/job/atmos, /datum/job/intern_eng)
#define SERVICE_ROLES list(/datum/job/chaplain, /datum/job/bartender, /datum/job/chef, /datum/job/hydro, /datum/job/janitor, /datum/job/journalist, /datum/job/librarian)
#define CIVILIAN_ROLES list(/datum/job/assistant, /datum/job/visitor)
#define NON_CREW_CIVILIAN_ROLES list(/datum/job/passenger, /datum/job/merchant)
#define SECURITY_ROLES list(/datum/job/warden, /datum/job/investigator, /datum/job/officer, /datum/job/intern_sec)
#define OPERATIONS_ROLES list(/datum/job/hangar_tech, /datum/job/mining, /datum/job/machinist)
#define EQUIPMENT_ROLES list(/datum/job/ai, /datum/job/cyborg)

#define ALL_ROLES list(COMMAND_ROLES, COMMAND_SUPPORT_ROLES, ENGINEERING_ROLES, SERVICE_ROLES, CIVILIAN_ROLES, NON_CREW_CIVILIAN_ROLES, OPERATIONS_ROLES, MEDICAL_ROLES, SCIENCE_ROLES, SECURITY_ROLES, EQUIPMENT_ROLES)

// Factions
// Used to know what what roles are allowed to play as which factions.
#define SCC_ROLES list(COMMAND_ROLES, COMMAND_SUPPORT_ROLES, EQUIPMENT_ROLES, OFF_DUTY_CREW_MEMBER_ROLE)
#define NT_ROLES list(SCIENCE_ROLES, MEDICAL_ROLES, SERVICE_ROLES, CIVILIAN_ROLES, REPRESENTATIVE_ROLE)
#define PMC_ROLES list(SECURITY_ROLES, MEDICAL_ROLES, CIVILIAN_ROLES, REPRESENTATIVE_ROLE)
#define IDRIS_ROLES list(SECURITY_ROLES, SERVICE_ROLES, CIVILIAN_ROLES, REPRESENTATIVE_ROLE)
#define ZAVOD_ROLES list(SECURITY_ROLES, SCIENCE_ROLES, ENGINEERING_ROLES, CIVILIAN_ROLES, REPRESENTATIVE_ROLE)
#define ZENG_ROLES list(SCIENCE_ROLES, MEDICAL_ROLES, CIVILIAN_ROLES, REPRESENTATIVE_ROLE)
#define HEPH_ROLES list(OPERATIONS_ROLES, ENGINEERING_ROLES, CIVILIAN_ROLES, REPRESENTATIVE_ROLE)
#define ORION_ROLES list(OPERATIONS_ROLES, CIVILIAN_ROLES, REPRESENTATIVE_ROLE, SERVICE_ROLES)
#define INDEP_ROLES list(NON_CREW_CIVILIAN_ROLES, CONSULAR_ROLE, JOURNALIST_ROLE, CHAPLAIN_ROLE, OFF_DUTY_CREW_MEMBER_ROLE)
