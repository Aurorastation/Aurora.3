/obj/item/clothing/under/assunzione/priest
	name = "luceian cassock"
	desc = "A linen cassock worn by clergyfolk of the Luceian faith of Assunzione. Despite being of simple make, the violet dye used for the shoulders has an almost iridescent sparkle to them."
	icon = 'icons/obj/item/clothing/under/human/coc/assunzione.dmi'
	icon_state = "assunzione_cassock"
	item_state = "assunzione_cassock"
	contained_sprite = TRUE
	slot_flags = SLOT_ICLOTHING

/obj/item/clothing/suit/storage/hooded/wintercoat/assunzione_robe
	name = "\improper luceian pyramidical keeper robe"
	desc = "A robe in usage by Keepers of the Luceian faith of Assunzione, commonly in use by the Pyramidical Church. Ornate, stylish, and made of decadent velvet and silk, no expense was spared in making these robes - though they are a bit heavy."
	desc_extended = "The manufacture of the highly-ornate clergy garb, much like most other religious items of Luceism, is done by highly-skilled, highly-paid artisan tailors who master their craft over years. Tailor shops and businesses must \
	pass an examination and be granted a license to be able to make these robes, and once they do, the Church sends luxurious materials like silk and velvet, as well as inlays made of real gold. The result is a robe unlike any other, described by \
	the Keepers who wear them as like being wrapped in a thick, padded blanket."
	icon = 'icons/obj/item/clothing/suit/storage/assunzione_robes.dmi'
	var/initial_icon_state = "keeper"
	icon_state = "keeper"
	hoodtype = /obj/item/clothing/head/winterhood/assunzione_robe
	allowed = list(/obj/item/nullrod/luceiansceptre, /obj/item/storage/assunzionesheath, /obj/item/assunzioneorb)

/obj/item/clothing/suit/storage/hooded/wintercoat/assunzione_robe/alt
	name = "\improper luceian astructural keeper robe"
	desc = "A simple linen robe used by ministers of the Astructural chapter of Assunzione. While still decorated with the Eye of Ennoia, it is of far simpler make than its Pyramidical counterpart, owing to the chapter's relative \
	asceticism and non-desire to decorating its clergy."
	desc_extended = "Though simple in design, this robe is far from cheap in construction. Astructural robes are designed by tailors with impeccable eyes to detail. The end result is comfortable and flexible while remaining \
	light and breezy. This lets Astructural Keepers wear their robes in everyday occasions rather than just for ceremony."
	initial_icon_state = "keeperalt"
	icon_state = "keeperalt"

/obj/item/clothing/suit/storage/hooded/wintercoat/assunzione_robe/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/robe_backing = image(mob_icon, null, "[initial_icon_state]_backing", H ? H.layer - 0.01 : MOB_LAYER - 0.01)
		I.AddOverlays(robe_backing)
	return I

/obj/item/clothing/head/winterhood/assunzione_robe
	name = "luceian clerical robe hood"
	desc = "A hood for an Assunzioni clerical robe."
	icon = 'icons/obj/item/clothing/suit/storage/assunzione_robes.dmi'

