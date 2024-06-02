// Object signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument


// /obj/item signals

///from base of obj/item/equipped(): (mob/equipper, slot)
#define COMSIG_ITEM_EQUIPPED "item_equip"
///From base of obj/item/on_equipped() (mob/equipped, slot)
#define COMSIG_ITEM_POST_EQUIPPED "item_post_equipped"
	/// This will make the on_equipped proc return FALSE.
	#define COMPONENT_EQUIPPED_FAILED (1<<0)
/// A mob has just equipped an item. Called on [/mob] from base of [/obj/item/equipped()]: (/obj/item/equipped_item, slot)
#define COMSIG_MOB_EQUIPPED_ITEM "mob_equipped_item"
///from base of obj/item/dropped(): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
///from base of obj/item/pickup(): (mob/user)
#define COMSIG_ITEM_PICKUP "item_pickup"
