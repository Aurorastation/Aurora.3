/obj/item/card/tech_support
	name = "tech support card"
	desc = "A card with a soft metallic sheen. Embedded within is a registered RFID chip."
	icon_state = "data"
	item_state = "card-id"
	overlay_state = "data"

/obj/item/card/tech_support/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Using this on a modular computer will reset it to its original state."
	. += "Using this on a hard drive will wipe it."
	. += "Use this on a laptop vendor during the payment phase to vend the device."
