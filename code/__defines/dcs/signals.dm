// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent

//////////////////////////////////////////////////////////////////

// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETING "parent_qdeleting"

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"

// /atom signals

// /area signals

// /turf signals

// /atom/movable signals

// /mob signals

// /obj signals
/// when a hood is unequipped
#define COMSIG_ITEM_REMOVE "item_remove"
/// checks an item's state
#define COMSIG_ITEM_STATE_CHECK "state_check"
/// updates an item between several states
#define COMSIG_ITEM_UPDATE_STATE "update_state"
/// updates sprites
#define COMSIG_ITEM_ICON_UPDATE "icon_update"

/*******Component Specific Signals*******/
