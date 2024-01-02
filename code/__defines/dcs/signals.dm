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

// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_QDELETING "parent_qdeleting"
/// from datum ui_act (usr, action)
#define COMSIG_UI_ACT "COMSIG_UI_ACT"
/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH_ON_HOST_DESTROY "ELEMENT_DETACH_ON_HOST_DESTROY"


// /atom signals

// /area signals
#define COMSIG_AREA_FIRE_ALARM "fire_alarm"

// /turf signals

// /atom/movable signals
#define COMSIG_MOVABLE_MOVED "movable_moved"

#define COMSIG_MOVABLE_HEAR "movable_hear"
	#define HEARING_MESSAGE 	1
	#define HEARING_SPEAKER 	2
	#define HEARING_LANGUAGE 	3
	#define HEARING_RAW_MESSAGE 4

//spatial grid signals

///Called from base of /datum/controller/subsystem/spatial_grid/proc/enter_cell: (/atom/movable)
#define SPATIAL_GRID_CELL_ENTERED(contents_type) "spatial_grid_cell_entered_[contents_type]"
///Called from base of /datum/controller/subsystem/spatial_grid/proc/exit_cell: (/atom/movable)
#define SPATIAL_GRID_CELL_EXITED(contents_type) "spatial_grid_cell_exited_[contents_type]"

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

/*******Component Specific Signals*******/
