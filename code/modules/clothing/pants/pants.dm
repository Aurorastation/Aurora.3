//
// Pants
//

// Pants Parent Item
ABSTRACT_TYPE(/obj/item/clothing/pants)
	name = "pants parent item"
	desc = DESC_PARENT
	icon = 'icons/obj/item/clothing/pants/pants.dmi'
	slot_flags = SLOT_PANTS
	contained_sprite = TRUE
	body_parts_covered = LOWER_TORSO | LEGS
	var/mob_wear_layer = ABOVE_UNIFORM_LAYER_PA
	gender = PLURAL // some pants vs. a skirt

/obj/item/clothing/pants/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wrists()

/obj/item/clothing/pants/verb/change_layer()
	set category = "Object"
	set name = "Change Pants Layer"
	set src in usr

	var/list/options = list("Under Uniform" = UNDER_UNIFORM_LAYER_PA, "Over Uniform" = ABOVE_UNIFORM_LAYER_PA, "Over Suit" = ABOVE_SUIT_LAYER_PA)
	var/new_layer = tgui_input_list(usr, "Position Pants", "Pants Layer", options)
	if(new_layer)
		mob_wear_layer = options[new_layer]
		to_chat(usr, SPAN_NOTICE("\The [src] will now layer [new_layer]."))
		update_clothing_icon()

/********** Pants Start **********/
// Pants
/obj/item/clothing/pants/white
	name = "white pants"
	desc = "Plain boring white pants."
	icon_state = "whitepants"
	item_state = "whitepants"

/obj/item/clothing/pants/black
	name = "black pants"
	desc = "A pair of plain black pants."
	icon_state = "blackpants"
	item_state = "blackpants"

/obj/item/clothing/pants/red
	name = "red pants"
	desc = "Bright red pants."
	icon_state = "redpants"
	item_state = "redpants"

/obj/item/clothing/pants/tan
	name = "tan pants"
	desc = "Some tan pants. You look like a white collar worker with these on."
	icon_state = "tanpants"
	item_state = "tanpants"

/obj/item/clothing/pants/khaki
	name = "tan pants"
	desc = "A pair of dust beige khaki pants."
	icon_state = "khaki"
	item_state = "khaki"

/obj/item/clothing/pants/highvis
	name = "high visibility pants"
	desc = "A pair of loose-fitting, high visibility pants to help the wearer be recognizable in high traffic areas with large industrial equipment."
	icon = 'icons/clothing/kit/highvis.dmi'
	icon_state = "pants_highvis"
	item_state = "pants_highvis"

/obj/item/clothing/pants/highvis/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_w_uniform_str)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "pants_highvis_un-emis", alpha = src.alpha)
		I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/pants/highvis_alt
	name = "high visibility pants"
	desc = "A pair of bright yellow pants with reflective stripes. For use in operations, engineering, and sometimes even law enforcement, in cold and poor weather or when visibility is low."
	icon = 'icons/clothing/kit/highvis.dmi'
	icon_state = "pants_highvis_alt"
	item_state = "pants_highvis_alt"

/obj/item/clothing/pants/highvis_alt/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_w_uniform_str)
		var/image/emissive_overlay = emissive_appearance(mob_icon, "pants_highvis_alt_un-emis", alpha = src.alpha)
		I.AddOverlays(emissive_overlay)
	return I

/obj/item/clothing/pants/camo
	name = "camouflage pants"
	desc = "A pair of woodland camouflage pants. Probably not the best choice for a space station."
	icon_state = "camopants"
	item_state = "camopants"

/obj/item/clothing/pants/dress
	name = "dress pants"
	desc = "A pair of suit trousers. The rest of the outfit can't have gone far."
	icon_state = "dresspants"
	item_state = "dresspants"

/obj/item/clothing/pants/dress/belt
	name = "dress pants"
	desc = "A pair of suit trousers. Comes with a belt, to secure your burdens."
	icon_state = "dresspants_belt"
	item_state = "dresspants_belt"

/obj/item/clothing/pants/striped
	name = "striped pants"
	desc = "A pair of striped pants. Typically seen among privateers."
	icon_state = "stripedpants"
	item_state = "stripedpants"

/obj/item/clothing/pants/tacticool
	name = "tacticool pants"
	desc = "A pair of rugged camo pants. Pairs well with canned rations and an SKS."
	icon_state = "tacticoolpants"
	item_state = "tacticoolpants"

/obj/item/clothing/pants/flared
	name = "flared pants"
	desc = "The peak of Biesellite fashion, these pants are flared at the ankle."
	icon_state = "flaredpants"
	item_state = "flaredpants"
	contained_sprite = TRUE
/********** Pants End **********/

/********** Jeans Start **********/
// Jeans
/obj/item/clothing/pants/jeans
	name = "jeans"
	desc = "A nondescript pair of tough blue jeans."
	icon_state = "jeans"
	item_state = "jeans"

/obj/item/clothing/pants/classic
	name = "classic jeans"
	desc = "A pair of classic jeans."
	icon_state = "jeansclassic"
	item_state = "jeansclassic"

/obj/item/clothing/pants/mustang
	name = "mustang jeans"
	desc = "Made in the finest space jeans factory this side of Tau Ceti."
	icon_state = "jeansmustang"
	item_state = "jeansmustang"

/obj/item/clothing/pants/mustang/colourable
	name = "mustang jeans"
	desc = "Made in the finest space jeans factory this side of Tau Ceti."
	icon_state = "mustangcolour"
	item_state = "mustangcolour"
	build_from_parts = TRUE
	worn_overlay = "belt"

/obj/item/clothing/pants/jeansblack
	name = "black jeans"
	desc = "A pair of black jeans."
	icon_state = "jeansblack"
	item_state = "jeansblack"

/obj/item/clothing/pants/designer
	name = "designer jeans"
	desc = "Dark denim jeans carefully distressed to perfection. They're not as rugged as they look."
	icon_state = "designer_jeans"
	item_state = "designer_jeans"

/obj/item/clothing/pants/tailoredjeans
	name = "tailored jeans"
	desc = "Close fitting denim jeans carefully distressed to perfection. They're not as rugged as they look."
	icon_state = "tailored_jeans"
	item_state = "tailored_jeans"
	build_from_parts = TRUE
	worn_overlay = "belt"

/obj/item/clothing/pants/ripped
	name = "ripped jeans"
	desc = "A  pair of ripped denim jeans. Probably sold for more than they're worth."
	icon_state = "jeansripped"
	item_state = "jeansripped"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/pants/blackripped
	name = "black ripped jeans"
	desc = "A pair of ripped black jeans. The brown belt is an interesting touch."
	icon_state = "jeansblackripped"
	item_state = "jeansblackripped"
	body_parts_covered = LOWER_TORSO
/********** Jeans End **********/

/********** Track Pants Start **********/
// Track Pants
/obj/item/clothing/pants/track
	name = "track pants"
	desc = "Track pants, perfect for squatting."
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackpants"
	item_state = "trackpants"

/obj/item/clothing/pants/track/blue
	name = "blue track pants"
	icon_state = "trackpantsblue"
	item_state = "trackpantsblue"

/obj/item/clothing/pants/track/green
	name = "green track pants"
	icon_state = "trackpantsgreen"
	item_state = "trackpantsgreen"

/obj/item/clothing/pants/track/white
	name = "white track pants"
	icon_state = "trackpantswhite"
	item_state = "trackpantswhite"

/obj/item/clothing/pants/track/red
	name = "red track pants"
	icon_state = "trackpantsred"
	item_state = "trackpantsred"
/********** Track Pants End **********/
