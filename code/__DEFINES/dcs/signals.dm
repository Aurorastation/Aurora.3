// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent

// when we expand maxz
#define COMSIG_GLOB_NEW_Z "!new_z"
// when we expand maxx and maxy (do we ever do this)
#define COMSIG_GLOB_EXPANDED_WORLD_BOUNDS "!expanded_world_bounds"

//////////////////////////////////////////////////////////////////


// /atom signals

/// Called from atom/Initialize() of target: (atom/target)
#define COMSIG_ATOM_INITIALIZED_ON "atom_initialized_on"

// /area signals
#define COMSIG_AREA_FIRE_ALARM "fire_alarm"

// /turf signals
/// Sent from what entered the turf
#define COMSIG_TURF_ENTERED "turf_entered"
/// From base of turf/ChangeTurf(): (path)
#define COMSIG_TURF_CHANGE "turf_change"

// /atom/movable signals

/// From /atom/movable/Hear(): (datum/say_message/message).
#define COMSIG_MOVABLE_HEAR "movable_hear"

/// From /obj/item/radio/on_receive_message(): (list/data).
#define COMSIG_RADIO_RECEIVE_MESSAGE "radio_receive_message"

// /mob signals
#define COMSIG_MOB_EXAMINATE "mob_examinate"
#define COMSIG_MOB_FACEDIR "mob_facedir"
#define COMSIG_MOB_POINT "mob_point"
#define COMSIG_MOB_ZONE_SEL_CHANGE "mob_zone_sel_change"
///from base of /mob/Login(): ()
#define COMSIG_MOB_LOGIN "mob_login"
/// Sent at the end of /mob/LateLogin() after the client is fully initialized.
#define COMSIG_MOB_AFTER_LOGIN "mob_after_login"
///from base of /mob/Logout(): ()
#define COMSIG_MOB_LOGOUT "mob_logout"
/// from mob/get_status_tab_items(): (list/items)
#define COMSIG_MOB_GET_STATUS_TAB_ITEMS "mob_get_status_tab_items"
///from /mob/living/carbon/human/proc/force_say(): ()
#define COMSIG_HUMAN_FORCESAY "human_forcesay"
///Mob is trying to open the wires of a target [/atom], from /datum/wires/interactable(): (atom/target)
#define COMSIG_TRY_WIRES_INTERACT "try_wires_interact"
	#define COMPONENT_CANT_INTERACT_WIRES (1<<0)
#define COMSIG_GET_EFFECTIVE_MASS "get_effective_mass"

/// Sent from /proc/do_after if someone starts a do_after action bar.
#define COMSIG_DO_AFTER_BEGAN "mob_do_after_began"
/// Sent from /proc/do_after once a do_after action completes, whether via the bar filling or via interruption.
#define COMSIG_DO_AFTER_ENDED "mob_do_after_ended"

// /obj signals
/// when a hood is unequipped
#define COMSIG_ITEM_REMOVE "item_remove"
/// checks an item's state
#define COMSIG_ITEM_STATE_CHECK "state_check"
/// updates an item between several states
#define COMSIG_ITEM_UPDATE_STATE "update_state"
/// updates sprites
#define COMSIG_ITEM_ICON_UPDATE "icon_update"
/// when a gun mag is emptied
#define COMSIG_EMPTIED_MAGAZINE "emptied_magazine"

// tgui signals
#define COMSIG_TGUI_CLOSE "tgui_close"

// Psionics signals
/// Raised on the target of a "mind-affecting" psionic power.
#define COMSIG_PSI_MIND_POWER "psi_block_check"

/// Raised on a mob to check it's psi-sensitivity rating. This is not the same thing as checking if someone is psionic, but psionic people have an innate bonus to the check.
#define COMSIG_PSI_CHECK_SENSITIVITY "psi_check_sensitivity"

// directional input signals.
// TODO: Please rework these if you are porting actual keybindings.
/// Raised on a mob when receiving a "Northeast" input key, typically the 'e' key.
#define COMSIG_INPUT_KEY_QUICK_EQUIP "quick-equip_key_pressed"

/// Raised on a mob when receiving a "Northwest" input key, typically the 'q' key.
#define COMSIG_INPUT_KEY_DROP "drop_key_pressed"

/*******Component Specific Signals*******/

// /obj/item/gun signals

#define COMSIG_GUN_TOGGLE_FIRING_MODE "gun_toggle_firing_mode"

#define COMSIG_GUN_TOGGLE_SAFETY "gun_toggle_safety"

#define COMSIG_BEFORE_GUN_FIRE "before_gun_fire"
/// Signal raised when a shot is successfully fired
#define COMSIG_GUN_FIRED "gun_fired"

#define COMSIG_GUN_SCOPE "gun_scope"

#define COMSIG_GUN_UNJAM_ATTEMPT "gun_unjam_attempt"

#define COMSIG_GUN_JAM_CHECK "gun_jam_check"

#define COMSIG_GUN_LOAD "gun_load"

#define COMSIG_GUN_UNLOAD "gun_unload"

#define COMSIG_GUN_TACTICAL_RELOAD "gun_tactical_reload"

#define COMSIG_GUN_OFFHAND_ACCURACY "gun_offhand_accuracy"

// Mech signals

#define COMSIG_MECH_MOVE_WASD "mech_move_wasd"

#define COMSIG_MECH_MOVE_STRAFE "mech_move_strafe"

#define COMSIG_MECH_TOGGLE_POWER "mech_toggle_power"

// Unarmed Combat Signals

#define COMSIG_UNARMED_HARM_ATTACKER "unarmed_harm_attacker"
#define COMSIG_UNARMED_HARM_DEFENDER "unarmed_harm_defender"
#define COMSIG_UNARMED_DISARM_ATTACKER "unarmed_disarm_attacker"
#define COMSIG_UNARMED_DISARM_DEFENDER "unarmed_disarm_defender"

// Bartending Skill Signals

#define COMSIG_CONTAINER_DRANK "container_drank"

// Cooking Skill Signals

/// Raised against a food item when someone takes a bite out of it: (mob/eater, mob/feeder)
#define COMSIG_FOOD_EATEN "food_eaten"

// Hydroponics Signals
/// Signal raised against the harvester of a plant during the Harvest() proc.
#define COMSIG_PLANT_HARVESTER "plant_harvester"
/// Signal raised against the plant being harvested during the Harvest() proc.
#define COMSIG_PLANT_HARVESTED "plant_harvested"
/// Signal raised against the harvester of a plant for each product spawned by the Harvest() proc: (atom/movable/product, datum/seed/plant)
#define COMSIG_PLANT_PRODUCT_HARVESTED "plant_product_harvested"

// Melee Combat Signals
#define COMSIG_APPLY_HIT_EFFECT "apply_hit_effect"
/// Signal raised against a mob attempting to attack a structure, used to query components for structure damage modifiers.
#define COMSIG_ATTACK_STRUCTURE "attack_structure"
/// Signal raised against a human defender during resolve_item_attack to check for weapon parries: (obj/item/weapon, mob/living/attacker, &parried)
#define COMSIG_HUMAN_MELEE_PARRY_CHECK "human_melee_parry_check"
/// Signal raised against a mob when practicing melee strikes (e.g. on a punching bag).
#define COMSIG_MELEE_PRACTICE "melee_practice"

// Various computer signals for interrupting via skill or other effects.
#define COMSIG_USE_REACTOR_COMPUTER "use_reactor_computer"

// Tenacity / Fault-Tolerant Architecture Signals
/// Raised during human shock processing: (&shock_stage, &recovery)
#define COMSIG_HUMAN_SHOCK_CHECK "human_shock_check"
/// Raised when an IPC internal organ checks if it can trigger an integrity failure event: (&cancelled)
#define COMSIG_IPC_INTEGRITY_EVENT_CHECK "ipc_integrity_event_check"
#define COMSIG_USE_MECH_FAB "use_mech_fab"

// Surgery Signals
/// Signal raised against the surgeon attempting to perform a surgery to query their components for any rate mods.
#define COMSIG_GET_SURGERY_SUCCESS_MODIFIERS "get_surgery_success_modifiers"

/// Signal raised against a character attempting to give a ministry moodlet to someone.
#define COMSIG_GET_MINISTRY_MODIFIERS "get_ministry_modifiers"
/// Signal raised against the recipient of the Ministry skill action, allowing effects to interrupt the received moodlet.
#define COMSIG_RECEIVE_MINISTRY_MODIFIERS "receive_ministry_modifiers"

/// Signal raised against a character attempting to deliver a speech.
#define COMSIG_GET_LEADERSHIP_MODIFIERS "get_leadership_modifiers"

/// Signal raised against a character attempting to butcher a mob, to check for butchering bonuses from skills.
#define COMSIG_GET_BUTCHERING_MODIFIERS "get_butchering_modifiers"

// Crafting Signals
#define COMSIG_GET_CRAFTING_MODIFIERS "get_crafting_modifiers"

/// Signal raised on a person attempting to repair a mech.
#define COMSIG_GET_MECH_WELD_MODIFIERS "mech_weld_modifiers"

// Forensics Skill Signals
/// Signal raised on a mob attempting to collect a forensic sample (fibers, prints, swabs): (atom/target, &delay, &preserve_evidence, &reconstruct_prints, &botch_sample)
#define COMSIG_FORENSICS_COLLECT_SAMPLE "forensics_collect_sample"
/// Signal raised on a mob attempting to examine a sample in a microscope: (obj/structure/machinery/microscope/microscope, &cancelled, &delay)
#define COMSIG_FORENSICS_USE_MICROSCOPE "forensics_use_microscope"
/// Signal raised on a mob initiating a DNA analyzer scan: (obj/structure/machinery/dnaforensics/scanner, &rate_multiplier)
#define COMSIG_FORENSICS_USE_DNASCANNER "forensics_use_dnascanner"
/// Signal raised on a mob attempting to scan a body part with an autopsy scanner: (mob/living/carbon/human/target, obj/item/organ/external/limb, &cancelled, &require_open_limb)
#define COMSIG_FORENSICS_USE_AUTOPSY "forensics_use_autopsy"
/// Signal raised on a mob using a mass spectrometer: (obj/item/mass_spectrometer/scanner, &show_details)
#define COMSIG_FORENSICS_USE_SPECTROMETER "forensics_use_spectrometer"
