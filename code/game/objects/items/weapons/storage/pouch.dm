/obj/item/storage/backpack/pouch
	name = "general pouch"
	desc = "A general purpose pouch that can store a few items. It goes in your pocket."
	desc_antag = null
	icon = 'icons/obj/storage/pouch.dmi'
	icon_state = "general"
	item_state = "general"
	contained_sprite = TRUE
	slot_flags = SLOT_POCKET
	max_storage_space = 4 // can hold 2 small items
	can_attach_sleeping_bag = FALSE

/obj/item/storage/backpack/pouch/cultify()
	return

/obj/item/storage/backpack/pouch/security
	name = "security pouch"
	icon_state = "security"
	item_state = "security"
	desc = "A pouch designed to store a few security supplies. It goes in your pocket."
	max_storage_space = 6 // can hold 3 small items

/obj/item/storage/backpack/pouch/security/Initialize()
	. = ..()
	// check that can_hold is null so this can be overridden by child types
	if(!can_hold)
		can_hold = GLOB.security_storage_items.Copy()

/obj/item/storage/backpack/pouch/medical
	name = "medical pouch"
	icon_state = "medical"
	item_state = "medical"
	desc = "A pouch designed to store a few medical supplies."
	max_storage_space = 6 // can hold 3 small items

/obj/item/storage/backpack/pouch/medical/Initialize()
	. = ..()
	// check that can_hold is null so this can be overridden by child types
	if(!can_hold)
		can_hold = GLOB.medical_storage_items.Copy()

/obj/item/storage/backpack/pouch/engineering
	name = "engineering pouch"
	icon_state = "engineering"
	item_state = "engineering"
	desc = "A pouch designed to store a few engineering supplies. It goes in your pocket."
	max_storage_space = 6 // can hold 3 small items

/obj/item/storage/backpack/pouch/engineering/Initialize()
	. = ..()
	// check that can_hold is null so this can be overridden by child types
	if(!can_hold)
		can_hold = GLOB.engineering_storage_items.Copy()
		can_hold += /obj/item/stack/material // added stacks, so they can hold steel in the pouch
