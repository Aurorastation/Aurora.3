/obj/item/clothing/ears/bulwark
    name = "bulwark horn wear"
    desc = "Some stuff worn by Bulwarks to adorn their horns."
    icon = 'icons/obj/vaurca_items.dmi'
    sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/horns.dmi'
	)
    w_class = ITEMSIZE_TINY
    slot_flags = SLOT_HEAD | SLOT_EARS
    species_restricted = list(BODYTYPE_VAURCA_BULWARK)

/obj/item/clothing/ears/bulwark/get_ear_examine_text(var/mob/user, var/ear_text = "left")
    return "around [user.get_pronoun("his")] horns"

/obj/item/clothing/ears/bulwark/get_head_examine_text(var/mob/user)
    return "around [user.get_pronoun("his")] horns"

/obj/item/clothing/ears/bulwark/rings
    name = "bulwark horn rings"
    desc = "Rings worn by Bulwarks to decorate their horns."
    icon_state = "horn_rings"
    item_state = "horn_rings"
    drop_sound = 'sound/items/drop/accessory.ogg'
    pickup_sound = 'sound/items/pickup/accessory.ogg'