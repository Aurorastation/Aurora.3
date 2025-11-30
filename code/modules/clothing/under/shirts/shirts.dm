//
// Shirts
//

// Dress Shirt
/obj/item/clothing/under/dressshirt
	name = "dress shirt"
	desc = "A casual dress shirt."
	icon = 'icons/obj/item/clothing/under/shirt/shirts.dmi'
	icon_state = "dressshirt"
	item_state = "dressshirt"
	contained_sprite = TRUE
	var/rolled = FALSE

/obj/item/clothing/under/dressshirt/update_clothing_icon()
	var/mob/M = loc
	if(ismob(loc))
		M.update_inv_wear_suit()

/obj/item/clothing/under/dressshirt/verb/roll_up_shirt_sleeves()
	set name = "Roll Up Sleeves"
	set desc = "Roll up your shirt sleeves. Doesn't work with some shirts."
	set category = "Object.Equipped"
	set src in usr

	if(use_check_and_message(usr))
		return FALSE

	var/list/icon_states = icon_states(icon)
	var/initial_state = initial(icon_state)
	var/new_state = "[initial_state]_r"
	if(!(new_state in icon_states))
		to_chat(usr, SPAN_WARNING("Your shirt doesn't allow this!"))
		return

	rolled = !rolled
	to_chat(usr, SPAN_NOTICE("You roll your shirt sleeves [rolled ? "up" : "down"]."))
	icon_state = rolled ? new_state : initial_state
	item_state = rolled ? new_state : initial_state
	overlay_state = rolled ? new_state : initial_state
	update_icon()
	update_clothing_icon()

/obj/item/clothing/under/dressshirt/alt
	name = "dress shirt"
	desc = "A casual dress shirt."
	icon_state = "dressshirt_alt"
	item_state = "dressshirt_alt"

/obj/item/clothing/under/dressshirt/alt/vneck
	name = "v-neck dress shirt"
	desc = "A casual dress shirt."
	icon_state = "dressshirtvneck_alt"
	item_state = "dressshirtvneck_alt"

/obj/item/clothing/under/dressshirt/deepv
	name = "deep v-neck dress shirt"
	desc = "A casual dress shirt with a deep neckline."
	icon_state = "dressshirt_deepv"
	item_state = "dressshirt_deepv"

/obj/item/clothing/under/dressshirt/crop
	name = "cropped dress shirt"
	desc = "A casual cropped dress shirt."
	icon_state = "dressshirt_crop"
	item_state = "dressshirt_crop"

// So people can see how these appear in the loadout
/obj/item/clothing/under/dressshirt/rolled
	name = "dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirt_r"
	item_state = "dressshirt_r"

/obj/item/clothing/under/dressshirt/alt/rolled
	name = "dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirt_alt_r"
	item_state = "dressshirt_alt_r"

/obj/item/clothing/under/dressshirt/alt/vneck/rolled
	name = "v-neck dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirtvneck_alt_r"
	item_state = "dressshirtvneck_alt_r"

/obj/item/clothing/under/dressshirt/deepv/rolled
	name = "deep v-neck dress shirt"
	desc = "A casual dress shirt with a deep neckline. This one has its sleeves rolled up."
	icon_state = "dressshirt_deepv_r"
	item_state = "dressshirt_deepv_r"

/obj/item/clothing/under/dressshirt/crop/rolled
	name = "cropped dress shirt"
	desc = "A casual cropped dress shirt. This one has its sleeves rolled up"
	icon_state = "dressshirt_crop_r"
	item_state = "dressshirt_crop_r"


/obj/item/clothing/under/dressshirt/asymmetric
	name = "asymmetric dress shirt"
	desc = "A casual dress shirt that opens diagonally down the front."
	icon_state = "dressshirt_asymmetric"
	item_state = "dressshirt_asymmetric"

// Long Sleeve

/obj/item/clothing/under/dressshirt/longsleeve
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric."
	icon_state = "longshirt"
	item_state = "longshirt"

/obj/item/clothing/under/dressshirt/longsleeve_s
	name = "striped long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric. This one has some stripes."
	icon_state = "longshirt_s"
	item_state = "longshirt_s"
	has_accents = TRUE

/obj/item/clothing/under/dressshirt/tshirt_s
	name = "striped t-shirt"
	desc = "A t-shirt made of light fabric. This one has some stripes."
	icon_state = "tshirt_s"
	item_state = "tshirt_s"
	has_accents = TRUE

// T-shirt

/obj/item/clothing/under/dressshirt/tshirt
	name = "t-shirt"
	desc = "A simple, cheap t-shirt."
	icon_state = "tshirt"
	item_state = "tshirt"

/obj/item/clothing/under/dressshirt/tshirt_crop
	name = "cropped t-shirt"
	desc = "A simple, cheap cropped t-shirt."
	icon_state = "tshirt_crop"
	item_state = "tshirt_crop"

// Blouses and Tops

/obj/item/clothing/under/dressshirt/blouse
	name = "blouse"
	desc = "A loose fitting garment."
	icon_state = "blouse"
	item_state = "blouse"

/obj/item/clothing/under/dressshirt/longblouse
	name = "long-sleeved blouse"
	desc = "A long-sleeved, loose fitting garment."
	icon_state = "longblouse"
	item_state = "longblouse"

/obj/item/clothing/under/dressshirt/puffyblouse
	name = "puffy blouse"
	desc = "A loose fitting garment with plenty of material around the arms."
	icon_state = "puffyblouse"
	item_state = "puffyblouse"

/obj/item/clothing/under/dressshirt/haltertop
	name = "halter top"
	desc = "A sleeveless tank with straps tied behind the neck, commonly seen worn in Biesel."
	icon_state = "haltertop"
	item_state = "haltertop"

/obj/item/clothing/under/dressshirt/tanktop
	name = "tank top"
	desc = "A simple, cheap tank top."
	icon_state = "tanktop"
	item_state = "tanktop"

/obj/item/clothing/under/dressshirt/tanktop/feminine
	icon_state = "tanktop_fem"
	item_state = "tanktop_fem"


// Polo Shirts
/obj/item/clothing/under/dressshirt/polo
	name = "polo shirt"
	desc = "A stylish polo shirt."
	icon_state = "polo"
	item_state = "polo"
	has_accents = TRUE

/obj/item/clothing/under/dressshirt/polo/polo_fem
	desc = "A stylish polo shirt with a waist fit."
	icon_state = "polo_fem"
	item_state = "polo_fem"
	has_accents = TRUE

// Silversun

/obj/item/clothing/under/dressshirt/silversun
	name = "silversun floral shirt"
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is cyan."
	icon_state = "hawaii"
	item_state = "hawaii"
	contained_sprite = TRUE
	var/open = FALSE

/obj/item/clothing/under/dressshirt/silversun/verb/unbutton()
	set name = "Toggle Shirt Buttons"
	set category = "Object.Equipped"
	set src in usr

	if(!istype(usr, /mob/living))
		return
	if(use_check_and_message(usr))
		return

	var/mob/user = usr
	attack_self(user)

/obj/item/clothing/under/dressshirt/silversun/attack_self(mob/user)
	open = !open
	icon_state = "[initial(icon_state)][open ? "_open" : ""]"
	item_state = icon_state
	to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))


/obj/item/clothing/under/dressshirt/silversun/red
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is crimson."
	icon_state = "hawaii_red"
	item_state = "hawaii_red"

/obj/item/clothing/under/dressshirt/silversun/random
	name = "silversun floral shirt"

/obj/item/clothing/under/dressshirt/silversun/random/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "hawaii_red"
	color = color_rotation(rand(-11,12)*15)
