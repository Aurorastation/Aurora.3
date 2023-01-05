//	Observer Pattern Implementation: Equipped
//		Registration type: /mob
//
//		Raised when: A mob equips an item.
//
//		Arguments that the called proc should expect:
//			/mob/equipper:  The mob that equipped the item.
//			/obj/item/item: The equipped item.
//			slot:           The slot equipped to.

var/datum/observ/mob_equipped/mob_equipped_event = new()

/datum/observ/mob_equipped
	name = "Mob Equipped"
	expected_type = /mob

//	Observer Pattern Implementation: Equipped
//		Registration type: /obj/item
//
//		Raised when: A mob equips an item.
//
//		Arguments that the called proc should expect:
//			/obj/item/item: The equipped item.
//			/mob/equipper:  The mob that equipped the item.
//			slot:           The slot equipped to.

var/datum/observ/item_equipped/item_equipped_event = new()

/datum/observ/item_equipped
	name = "Item Equipped"
	expected_type = /obj/item

/********************
* Equipped Handling *
********************/

/obj/item/equipped(var/mob/user, var/slot, var/assisted_equip = FALSE)
	. = ..()
	mob_equipped_event.raise_event(user, src, slot)
	item_equipped_event.raise_event(src, user, slot)
	SEND_SIGNAL(src, COMSIG_ITEM_REMOVE, src)

/obj/item/proc/check_equipped(var/mob/user, var/slot, var/assisted_equip = FALSE)
	return TRUE