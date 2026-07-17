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

/obj/item/clothing/under/dressshirt/asymmetric
	name = "asymmetric dress shirt"
	desc = "A casual dress shirt that opens diagonally down the front."
	icon_state = "dressshirt_asymmetric"
	item_state = "dressshirt_asymmetric"

/obj/item/clothing/under/dressshirt/plaid
	name = "plaid dress shirt"
	desc = "A dress shirt with a plaid pattern."
	icon_state = "plaidshirt"
	item_state = "plaidshirt"

// So people can see how these appear in the loadout
/obj/item/clothing/under/dressshirt/rolled
	rolled = TRUE

/obj/item/clothing/under/dressshirt/alt/rolled
	rolled = TRUE

/obj/item/clothing/under/dressshirt/alt/vneck/rolled
	rolled = TRUE

/obj/item/clothing/under/dressshirt/deepv/rolled
	rolled = TRUE

/obj/item/clothing/under/dressshirt/crop/rolled
	rolled = TRUE

/obj/item/clothing/under/dressshirt/plaid/rolled
	rolled = TRUE

/obj/item/clothing/under/dressshirt/asymmetric/rolled
	rolled = TRUE

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

/obj/item/clothing/under/dressshirt/tanktop/cropped
	name = "cropped tank top"
	desc = "A short, simple, cheap tank top."
	icon_state = "tanktop_crop"
	item_state = "tanktop_crop"

/obj/item/clothing/under/dressshirt/tanktop/cropped/feminine
	icon_state = "tanktop_crop_fem"
	item_state = "tanktop_crop_fem"

/obj/item/clothing/under/dressshirt/tanktop/midriff
	name = "midriff tank top"
	desc = "A very short tank top that only covers the chest."
	icon_state = "tanktop_midriff"
	item_state = "tanktop_midriff"


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


//pre-coloured shirts

/obj/item/clothing/under/dressshirt/corgi
	name = "corgi t-shirt"
	desc = "A t-shirt with a corgi on it, cute!"
	icon_state = "tshirt_corgi"
	item_state = "tshirt_corgi"

/obj/item/clothing/under/dressshirt/heart
	name = "heart t-shirt"
	desc = "A t-shirt with a cartoon heart on it."
	icon_state = "tshirt_heart"
	item_state = "tshirt_heart"

/obj/item/clothing/under/dressshirt/heart/alt
	icon_state = "tshirt_heart_alt"
	item_state = "tshirt_heart_alt"

/obj/item/clothing/under/dressshirt/lovent
	name = "\improper I love NT t-shirt"
	desc = "A white t-shirt with the text \"I ❤ NT\" on it. Another way to show your love of NanoTrasen!"
	icon_state = "tshirt_lovent"
	item_state = "tshirt_lovent"

/obj/item/clothing/under/dressshirt/band
	name = "band t-shirt"
	desc = "A t-shirt with the logo of a band on it."
	icon_state = "tshirt_band"
	item_state = "tshirt_band"

/obj/item/clothing/under/dressshirt/alien
	name = "alien t-shirt"
	desc = "A t-shirt with a cartoon alien head on it. Doesn't really look like any known species."
	icon_state = "tshirt_alien"
	item_state = "tshirt_alien"

/obj/item/clothing/under/dressshirt/tiedye
	name = "tie-dye t-shirt"
	desc = "A tie-dyed t-shirt with a rainbow swirl on it."
	icon_state = "tshirt_tiedye"
	item_state = "tshirt_tiedye"

/obj/item/clothing/under/dressshirt/skull
	name = "skull t-shirt"
	desc = "A red t-shirt featuring a human skull, badass?"
	icon_state = "tshirt_skull"
	item_state = "tshirt_skull"

/obj/item/clothing/under/dressshirt/sport
	name = "blue sports t-shirt"
	desc = "A t-shirt for sports. Takes you back to school PE days."
	icon_state = "tshirt_sportblue"
	item_state = "tshirt_sportblue"

/obj/item/clothing/under/dressshirt/sport/green
	name = "green sports t-shirt"
	icon_state = "tshirt_sportgreen"
	item_state = "tshirt_sportgreen"

/obj/item/clothing/under/dressshirt/sport/red
	name = "red sports t-shirt"
	icon_state = "tshirt_sportred"
	item_state = "tshirt_sportred"

/obj/item/clothing/under/dressshirt/wing
	name = "wing t-shirt"
	desc = "A t-shirt with a cartoon wing printed on it."
	icon_state = "tshirt_wing"
	item_state = "tshirt_wing"

/obj/item/clothing/under/dressshirt/peace
	name = "peace t-shirt"
	desc = "A white t-shirt with the symbol of peace on the front and back."
	icon_state = "tshirt_peace"
	item_state = "tshirt_peace"

/obj/item/clothing/under/dressshirt/meat
	name = "steak t-shirt"
	desc = "A t-shirt with a cartoon steak on it. Tasty."
	icon_state = "tshirt_meat"
	item_state = "tshirt_meat"

/obj/item/clothing/under/dressshirt/questionmark
	name = "question mark t-shirt"
	desc = "A t-shirt with a question mark on it? For some reason?"
	icon_state = "tshirt_question"
	item_state = "tshirt_question"

/obj/item/clothing/under/dressshirt/bowling
	name = "white bowling t-shirt"
	desc = "A t-shirt for bowling."
	icon_state = "tshirt_bowlingw"
	item_state = "tshirt_bowlingw"

/obj/item/clothing/under/dressshirt/bowling/aqua
	name = "aqua bowling t-shirt"
	icon_state = "tshirt_bowlinga"
	item_state = "tshirt_bowlinga"

/obj/item/clothing/under/dressshirt/bowling/purple
	name = "purple bowling t-shirt"
	icon_state = "tshirt_bowlingp"
	item_state = "tshirt_bowlingp"

/obj/item/clothing/under/dressshirt/bowling/red
	name = "red bowling t-shirt"
	icon_state = "tshirt_bowlingr"
	item_state = "tshirt_bowlingr"

/obj/item/clothing/under/dressshirt/jersey
	name = "blue jersey"
	desc = "A sports shirt with numbers on the back."
	icon_state = "shirt_jersey"
	item_state = "shirt_jersey"

/obj/item/clothing/under/dressshirt/jersey/red
	name = "red jersey"
	icon_state = "shirt_jersey_red"
	item_state = "shirt_jersey_red"

/obj/item/clothing/under/dressshirt/pinkblack
	name = "pink and black t-shirt"
	desc = "A pink t-shirt with black sleeves."
	icon_state = "tshirt_pinkblack"
	item_state = "tshirt_pinkblack"

/obj/item/clothing/under/dressshirt/nanotrasen
	name = "blue NanoTrasen t-shirt"
	desc = "A t-shirt with the letters \"NT\" printed on it."
	icon_state = "tshirt_nt_blue"
	item_state = "tshirt_nt_blue"

/obj/item/clothing/under/dressshirt/nanotrasen/red
	name = "red NanoTrasen t-shirt"
	icon_state = "tshirt_nt_red"
	item_state = "tshirt_nt_red"

/obj/item/clothing/under/dressshirt/tanktop/fire
	name = "fire tank top"
	desc = "A tank top with a flame decal on it."
	icon_state = "tanktop_fire"
	item_state = "tanktop_fire"

/obj/item/clothing/under/dressshirt/tanktop/sun
	name = "sun tank top"
	desc = "A tank top with a sun decal on it."
	icon_state = "tanktop_sun"
	item_state = "tanktop_sun"
