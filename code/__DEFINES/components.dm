#define COMSIG_BASENAME_RENAME "base_name_rename"
#define COMSIG_BASENAME_SETNAME "base_name_setname"
#define ARMED_COMBAT_SKILL_COMPONENT /datum/component/skill/armed_combat
#define FIREARMS_SKILL_COMPONENT /datum/component/skill/firearms
#define UNARMED_COMBAT_SKILL_COMPONENT /datum/component/skill/unarmed_combat
#define PILOT_MECHS_SKILL_COMPONENT /datum/component/skill/pilot_mechs
#define PILOT_SPACECRAFT_SKILL_COMPONENT /datum/component/skill/pilot_spacecraft
#define ROBOTICS_SKILL_COMPONENT /datum/component/skill/robotics
#define ARCHAOLOGY_SKILL_COMPONENT /datum/component/skill/archaology
#define RESEARCH_SKILL_COMPONENT /datum/component/skill/research
#define XENOBIOLOGY_SKILL_COMPONENT /datum/component/skill/xenobiology
#define XENOBOTANY_SKILL_COMPONENT /datum/component/skill/xenobotany
#define BARTENDING_SKILL_COMPONENT /datum/component/skill/bartending
#define COOKING_SKILL_COMPONENT /datum/component/skill/cooking
#define ENTERTAINING_SKILL_COMPONENT /datum/component/skill/entertaining
#define GARDENING_SKILL_COMPONENT /datum/component/skill/gardening
#define MEDICINE_SKILL_COMPONENT /datum/component/skill/medicine
#define SKILL_COMPONENT /datum/component/skill
#define MORALE_COMPONENT /datum/component/morale
#define ELECTRICAL_ENGINEERING_SKILL_COMPONENT /datum/component/skill/electrical_engineering
#define MECHANICAL_ENGINEERING_SKILL_COMPONENT /datum/component/skill/mechanical_engineering
#define ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT /datum/component/skill/atmospherics_systems
#define REACTOR_SYSTEMS_SKILL_COMPONENT /datum/component/skill/reactor_systems
#define LEADERSHIP_SKILL_COMPONENT /datum/component/skill/leadership
#define ANATOMY_SKILL_COMPONENT /datum/component/skill/anatomy
#define FORENSICS_SKILL_COMPONENT /datum/component/skill/forensics
#define PHARMACOLOGY_SKILL_COMPONENT /datum/component/skill/pharmacology
#define SURGERY_SKILL_COMPONENT /datum/component/skill/surgery
#define TOOL_COMPONENT /datum/component/tool_quality_container
#define CAROUSING_SKILL_COMPONENT /datum/component/skill/carousing
#define TENACITY_SKILL_COMPONENT /datum/component/skill/tenacity

/**
 * Trinary-Boolean helper that either returns null, or the skill level of a given skill component(which can be zero).
 * It will ALWAYS be null if you try to use this to check for something that isn't a skill component, so just don't. Refer to the list above this function to see what your options are.
 * Therefore, merely checking if (!this) is not sufficient to use this function, and instead you should be using isnull() on it to determine whether or not the skill exists.
 */
#define GET_SKILL_LEVEL(user, comp) astype(user.GetComponent(comp), SKILL_COMPONENT)?.skill_level
