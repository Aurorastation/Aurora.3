//
// Pants and Shorts
//

/********** Pants Start **********/
// Jeans
/obj/item/clothing/under/pants
	name = "pants parent item"
	desc = DESC_PARENT_ITEM
	icon = 'icons/obj/pants.dmi'
	contained_sprite = TRUE
	body_parts_covered = LOWER_TORSO | LEGS

/obj/item/clothing/under/pants/track
	name = "track pants"
	desc = "Track pants, perfect for squatting."
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackpants"
	item_state = "trackpants"

/obj/item/clothing/under/pants/track/blue
	name = "blue track pants"
	icon_state = "trackpantsblue"
	item_state = "trackpantsblue"

/obj/item/clothing/under/pants/track/green
	name = "green track pants"
	icon_state = "trackpantsgreen"
	item_state = "trackpantsgreen"

/obj/item/clothing/under/pants/track/white
	name = "white track pants"
	icon_state = "trackpantswhite"
	item_state = "trackpantswhite"

/obj/item/clothing/under/pants/track/red
	name = "red track pants"
	icon_state = "trackpantsred"
	item_state = "trackpantsred"

/obj/item/clothing/under/pants/jeans
	name = "jeans"
	desc = "A nondescript pair of tough blue jeans."
	icon_state = "jeans"
	item_state = "jeans"

/obj/item/clothing/under/pants/classic
	name = "classic jeans"
	desc = "A pair of classic jeans."
	icon_state = "jeansclassic"
	item_state = "jeansclassic"

/obj/item/clothing/under/pants/musthang
	name = "must hang jeans"
	desc = "Made in the finest space jeans factory this side of Tau Ceti."
	icon_state = "jeansmustang"
	item_state = "jeansmustang"

/obj/item/clothing/under/pants/musthangcolour
	name = "must hang jeans"
	desc = "Made in the finest space jeans factory this side of Tau Ceti."
	icon_state = "mustangcolour"
	item_state = "mustangcolour"
	build_from_parts = TRUE
	worn_overlay = "belt"

/obj/item/clothing/under/pants/jeansblack
	name = "black jeans"
	desc = "A pair of black jeans."
	icon_state = "jeansblack"
	item_state = "jeansblack"

/obj/item/clothing/under/pants/youngfolksjeans
	name = "young folks jeans"
	desc = "For those tired of boring old jeans."
	icon_state = "jeansyoungfolks"
	item_state = "jeansyoungfolks"

/obj/item/clothing/under/pants/white
	name = "white pants"
	desc = "Plain boring white pants."
	icon_state = "whitepants"
	item_state = "whitepants"

/obj/item/clothing/under/pants/black
	name = "black pants"
	desc = "A pair of plain black pants."
	icon_state = "blackpants"
	item_state = "blackpants"

/obj/item/clothing/under/pants/red
	name = "red pants"
	desc = "Bright red pants."
	icon_state = "redpants"
	item_state = "redpants"

/obj/item/clothing/under/pants/tan
	name = "tan pants"
	desc = "Some tan pants. You look like a white collar worker with these on."
	icon_state = "tanpants"
	item_state = "tanpants"

/obj/item/clothing/under/pants/khaki
	name = "tan pants"
	desc = "A pair of dust beige khaki pants."
	icon_state = "khaki"
	item_state = "khaki"

/obj/item/clothing/under/pants/camo
	name = "camouflage pants"
	desc = "A pair of woodland camouflage pants. Probably not the best choice for a space station."
	icon_state = "camopants"
	item_state = "camopants"

/obj/item/clothing/under/pants/designer
	name = "designer jeans"
	desc = "Dark denim jeans carefully distressed to perfection. They're not as rugged as they look."
	icon_state = "designer_jeans"
	item_state = "designer_jeans"

/obj/item/clothing/under/pants/tailoredjeans
	name = "tailored jeans"
	desc = "Close fitting denim jeans carefully distressed to perfection. They're not as rugged as they look."
	icon_state = "tailored_jeans"
	item_state = "tailored_jeans"
	build_from_parts = TRUE
	worn_overlay = "belt"

/obj/item/clothing/under/pants/dress
	name = "dress pants"
	desc = "A pair of suit trousers. The rest of the outfit can't have gone far."
	icon_state = "dresspants"
	item_state = "dresspants"

/obj/item/clothing/under/pants/dress/belt
	name = "dress pants"
	desc = "A pair of suit trousers. Comes with a belt, to secure your burdens."
	icon_state = "dresspants_belt"
	item_state = "dresspants_belt"

/obj/item/clothing/under/pants/striped
	name = "striped pants"
	desc = "A pair of striped pants. Typically seen among privateers."
	icon_state = "stripedpants"
	item_state = "stripedpants"

/obj/item/clothing/under/pants/tacticool
	name = "tacticool pants"
	desc = "A pair of rugged camo pants. Pairs well with canned rations and an SKS."
	icon_state = "tacticoolpants"
	item_state = "tacticoolpants"

/obj/item/clothing/under/pants/ripped
	name = "ripped jeans"
	desc = "A  pair of ripped denim jeans. Probably sold for more than they're worth."
	icon_state = "jeansripped"
	item_state = "jeansripped"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/pants/blackripped
	name = "black ripped jeans"
	desc = "A pair of ripped black jeans. The brown belt is an interesting touch."
	icon_state = "jeansblackripped"
	item_state = "jeansblackripped"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/pants/flared
	name = "flared pants"
	desc = "The peak of Biesellite fashion, these pants are flared at the ankle."
	icon = 'icons/contained_items/clothing/bottomwear/flared_pants.dmi'
	icon_state = "flaredpants"
	item_state = "flaredpants"
	contained_sprite = TRUE
/********** Pants End **********/

/********** Shorts Start **********/
// Shorts Parent Item
/obj/item/clothing/under/shorts
	name = "shorts parent item"
	desc = DESC_PARENT_ITEM
	body_parts_covered = LOWER_TORSO
	icon = 'icons/contained_items/clothing/bottomwear/shorts.dmi'
	contained_sprite = TRUE

// Athletic Shorts
/obj/item/clothing/under/shorts/athletic
	name = "athletic shorts parent item"

/obj/item/clothing/under/shorts/athletic/colourable
	name = "athletic shorts"
	icon_state = "shorts_athletic_colourable"
	item_state = "shorts_athletic_colourable"

/obj/item/clothing/under/shorts/athletic/black
	name = "black athletic shorts"
	icon_state = "shorts_athletic_black"
	item_state = "shorts_athletic_black"

/obj/item/clothing/under/shorts/athletic/red
	name = "red athletic shorts"
	icon_state = "shorts_athletic_red"
	item_state = "shorts_athletic_red"

/obj/item/clothing/under/shorts/athletic/green
	name = "green athletic shorts"
	icon_state = "shorts_athletic_green"
	item_state = "shorts_athletic_green"

/obj/item/clothing/under/shorts/athletic/blue
	name = "blue athletic shorts"
	icon_state = "shorts_athletic_blue"
	item_state = "shorts_athletic_blue"

/obj/item/clothing/under/shorts/athletic/grey
	name = "grey athletic shorts"
	icon_state = "shorts_athletic_grey"
	item_state = "shorts_athletic_grey"

/obj/item/clothing/under/shorts/athletic/scc
	name = "\improper Stellar Corporate Conglomerate athletic shorts"
	desc = "Shorts displaying the wearer's pride in their assigned corporate entity."
	desc_fluff = "The Stellar Corporate Conglomerate, also known as the Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals, and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon_state = "shorts_athletic_scc"
	item_state = "shorts_athletic_scc"

// Shorts
/obj/item/clothing/under/shorts/black
	name = "black shorts"
	desc = "For that island getaway. It's five o'clock somewhere, right?"
	icon_state = "shorts_black"
	item_state = "shorts_black"

/obj/item/clothing/under/shorts/black/short
	name = "black short shorts"
	icon_state = "shorts_s_black"
	item_state = "shorts_s_black"

/obj/item/clothing/under/shorts/khaki
	name = "khaki shorts"
	desc = "For that island getaway. It's five o'clock somewhere, right?"
	icon_state = "shorts_khaki"
	item_state = "shorts_khaki"

/obj/item/clothing/under/shorts/khaki/short
	name = "khaki short shorts"
	icon_state = "shorts_s_khaki"
	item_state = "shorts_s_khaki"

// Jeans Shorts
/obj/item/clothing/under/shorts/jeans
	name = "jeans shorts"
	desc = "Some jeans! Just in short form!"
	icon_state = "shorts_jeans"
	item_state = "shorts_jeans"

/obj/item/clothing/under/shorts/jeans/short
	name = "jeans short shorts"
	icon_state = "shorts_s_jeans"
	item_state = "shorts_s_jeans"

/obj/item/clothing/under/shorts/jeans/classic
	name = "classic jeans shorts"
	icon_state = "shorts_jeans_classic"
	item_state = "shorts_jeans_classic"

/obj/item/clothing/under/shorts/jeans/classic/short
	name = "classic jeans short shorts"
	icon_state = "shorts_s_jeans_classic"
	item_state = "shorts_s_jeans_classic"

/obj/item/clothing/under/shorts/jeans/mustang
	name = "mustang jeans shorts"
	icon_state = "shorts_jeans_mustang"
	item_state = "shorts_jeans_mustang"

/obj/item/clothing/under/shorts/jeans/mustang/short
	name = "mustang jeans short shorts"
	icon_state = "shorts_s_jeans_mustang"
	item_state = "shorts_s_jeans_mustang"

/obj/item/clothing/under/shorts/jeans/youngfolks
	name = "young folks jeans shorts"
	icon_state = "shorts_jeans_youngfolk"
	item_state = "shorts_jeans_youngfolk"

/obj/item/clothing/under/shorts/jeans/youngfolks/short
	name = "young folks jeans short shorts"
	icon_state = "shorts_s_jeans_youngfolk"
	item_state = "shorts_s_jeans_youngfolk"

/obj/item/clothing/under/shorts/jeans/black
	name = "black jeans shorts"
	icon_state = "shorts_jeans_black"
	item_state = "shorts_jeans_black"

/obj/item/clothing/under/shorts/jeans/black/short
	name = "black jeans short shorts"
	icon_state = "shorts_s_jeans_black"
	item_state = "shorts_s_jeans_black"

/obj/item/clothing/under/shorts/jeans/grey
	name = "grey jeans shorts"
	icon_state = "shorts_jeans_grey"
	item_state = "shorts_jeans_grey"

/obj/item/clothing/under/shorts/jeans/grey/short
	name = "grey jeans short shorts"
	icon_state = "shorts_s_jeans_grey"
	item_state = "shorts_s_jeans_grey"
/********** Shorts End **********/