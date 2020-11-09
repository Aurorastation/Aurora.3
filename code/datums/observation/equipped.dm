//	Observer Pattern Implementation: Equipped
//		Registration type: /mob
//
//		Raised when: A mob equips an item.
//
//		Arguments that the called proc should expect:
//			/mob/equipper:  The mob that equipped the item.
//			/obj/item/item: The equipped item.
//			slot:           The slot equipped to.

/decl/observ/mob_equipped
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

/decl/observ/item_equipped
	name = "Item Equipped"
	expected_type = /obj/item

/********************
* Equipped Handling *
********************/

/obj/item/equipped(var/mob/user, var/slot)
	. = ..()
	RAISE_EVENT(mob_equipped, user, src, slot)
	RAISE_EVENT(item_equipped, src, user, slot)
