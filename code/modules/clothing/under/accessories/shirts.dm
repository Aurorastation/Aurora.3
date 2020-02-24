/obj/item/clothing/accessory/sweater
	name = "sweater"
	desc = "A warm knit sweater."
	icon_state = "sweater"
	item_state = "sweater"

/obj/item/clothing/accessory/dressshirt
	name = "dress shirt"
	desc = "A casual dress shirt."
	icon_state = "dressshirt"
	item_state = "dressshirt"

/obj/item/clothing/accessory/dressshirt_r
	name = "dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirt_r"
	item_state = "dressshirt_r"

//Legacy
/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "wcoat"
	item_state = "wcoat"

//New one that will actually be in the loadout
/obj/item/clothing/accessory/wcoat_rec
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "wcoat_rec"
	item_state = "wcoat_rec"

/obj/item/clothing/accessory/longsleeve
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric."
	icon_state = "longshirt"
	item_state = "longshirt"

/obj/item/clothing/accessory/longsleeve_s
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric. This one is striped."
	icon_state = "longshirt_s"
	item_state = "longshirt_s"

/obj/item/clothing/accessory/longsleeve_sb
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric. This one is striped."
	icon_state = "longshirt_sb"
	item_state = "longshirt_sb"

/obj/item/clothing/accessory/tshirt
	name = "t-shirt"
	desc = "A simple, cheap t-shirt."
	icon_state = "tshirt"
	item_state = "tshirt"

/obj/item/clothing/accessory/silversun
	name = "silversun floral shirt"
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is cyan."
	icon = 'icons/clothing/under/shirts/hawaiian.dmi'
	icon_state = "hawaii"
	item_state = "hawaii"
	contained_sprite = TRUE
	var/open = FALSE

/obj/item/clothing/accessory/silversun/verb/unbutton()
	set name = "Unbutton Shirt"
	set category = "Object"
	set src in usr

	if(!istype(usr, /mob/living))
		return
	if(use_check_and_message(usr))
		return

	var/mob/user = usr
	attack_self(user)

/obj/item/clothing/accessory/silversun/attack_self(mob/user)
	open = !open
	icon_state = "[initial(icon_state)][open ? "_open" : ""]"
	item_state = icon_state
	to_chat(user, span("notice", "You [open ? "open" : "close"] \the [src]."))
	// the below forces the shirt to hard reset its image so it resets later its fucking weird ok
	inv_overlay = null
	mob_overlay = null

/obj/item/clothing/accessory/silversun/red
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is crimson."
	icon_state = "hawaii_red"
	item_state = "hawaii_red"

/obj/item/clothing/accessory/silversun/random
	name = "silversun floral shirt"

/obj/item/clothing/accessory/silversun/random/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "hawaii_red"
	color = color_rotation(rand(-11,12)*15)