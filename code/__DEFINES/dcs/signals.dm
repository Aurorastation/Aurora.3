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

// /area signals
#define COMSIG_AREA_FIRE_ALARM "fire_alarm"

// /turf signals

// /atom/movable signals

#define COMSIG_MOVABLE_HEAR "movable_hear"
	#define HEARING_MESSAGE 	1
	#define HEARING_SPEAKER 	2
	#define HEARING_LANGUAGE 	3
	#define HEARING_RAW_MESSAGE 4

// /mob signals
#define COMSIG_MOB_EXAMINATE "mob_examinate"
#define COMSIG_MOB_FACEDIR "mob_facedir"
#define COMSIG_MOB_POINT "mob_point"
#define COMSIG_MOB_ZONE_SEL_CHANGE "mob_zone_sel_change"
///from base of /mob/Login(): ()
#define COMSIG_MOB_LOGIN "mob_login"
///from base of /mob/Logout(): ()
#define COMSIG_MOB_LOGOUT "mob_logout"
/// from mob/get_status_tab_items(): (list/items)
#define COMSIG_MOB_GET_STATUS_TAB_ITEMS "mob_get_status_tab_items"
///from /mob/living/carbon/human/proc/force_say(): ()
#define COMSIG_HUMAN_FORCESAY "human_forcesay"
///Mob is trying to open the wires of a target [/atom], from /datum/wires/interactable(): (atom/target)
#define COMSIG_TRY_WIRES_INTERACT "try_wires_interact"
	#define COMPONENT_CANT_INTERACT_WIRES (1<<0)


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

// tgui signals
#define COMSIG_TGUI_CLOSE "tgui_close"

// Psionics signals
/// Raised on the target of a "mind-affecting" psionic power.
#define COMSIG_PSI_MIND_POWER "psi_block_check"

/*******Component Specific Signals*******/
