/obj/item/clothing/under/assunzione/priest
	name = "luceian cassock"
	desc = "A linen cassock worn by clergyfolk of the Luceian faith of Assunzione. Despite being of simple make, the violet dye used for the shoulders has an almost iridescent sparkle to them."
	icon = 'icons/clothing/under/uniforms/assunzione.dmi'
	icon_state = "assunzione_cassock"
	item_state = "assunzione_cassock"
	contained_sprite = TRUE
	slot_flags = SLOT_ICLOTHING

/obj/item/clothing/suit/storage/hooded/wintercoat/assunzione_robe
	name = "luceian clerical robe"
	desc = "A robe in usage by Keepers of the Luceian faith of Assunzione, commonly in use by the Pyramidical chapter. Ornate, stylish, and made of decadent velvet and silk, no expense was spared in making these robes."
	desc_extended = "The manufacture of the highly-ornate clergy garb, much like most other religious items of Luceism, is done by highly-skilled, highly-paid artisan tailors who master their craft over years. Tailor shops and businesses must \
	pass an examination and be granted a license to be able to make these robes, and once they do, the Church sends luxurious materials like silk and velvet, as well as inlays made of real gold. The result is a robe unlike any other, described by \
	the Keepers who wear them as like being wrapped in a thick, padded blanket."
	icon_state = "assunzione_keeper"
	hoodtype = /obj/item/clothing/head/winterhood/assunzione_robe

/obj/item/clothing/head/winterhood/assunzione_robe
	name = "luceian clerical robe hood"
	desc = "A hood for an Assunzioni clerical robe."

/obj/item/clothing/accessory/assunzione
	name = "luceian amulet"
	desc = "A common symbol of the Luceian faith abroad, this amulet featuring the religion's all-seeing eye and eight-pointed crest \
	seems to be made of real gold and gemstones. While not as critical to faithful abroad as a warding sphere, it is considered good form \
	to ensure one's amulet is well-maintained."
	icon = 'icons/obj/clothing/accessory/religious.dmi'
	item_state = "assunzione_amulet"
	icon_state = "assunzione_amulet"
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/assunzioneorb
	name = "warding sphere"
	desc = "A religious artefact commonly associated with Luceism, this transparent globe gives off a faint ghostly white light at all times."
	desc_extended = "Luceian warding spheres are made on the planet of Assunzione in the great domed city of Guelma, and are carried by followers of the faith heading abroad. \
	Constructed out of glass and a luce vine bulb these spheres can burn for years upon years, and it is said that the lights in the truly faithful's warding sphere will always \
	point towards Assunzione. It is considered extremely bad luck to have one's warding sphere break, to extinguish its flame, or to relinquish it (permanently) to an unbeliever."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "assunzioneorb"
	item_state = "assunzioneorb"
	throwforce = 5
	force = 11
	light_range = 1.4
	light_power = 1.4
	light_color = LIGHT_COLOR_BLUE
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/assunzioneorb/proc/shatter()
	visible_message(SPAN_WARNING("\The [src] shatters!"), SPAN_WARNING("You hear a small glass object shatter!"))
	playsound(get_turf(src), 'sound/effects/glass_hit.ogg', 75, TRUE)
	new /obj/item/material/shard(get_turf(src))
	qdel(src)

/obj/item/assunzioneorb/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/assunzioneorb/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/storage/assunzionesheath
	name = "warding sphere casing"
	desc = "A small metal shell designed to protect the warding sphere inside. The all-seeing eye of Ennoia, a common symbol of Luceism, is engraved upon the front of the casing."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "assunzionesheath_empty"
	can_hold = list(/obj/item/assunzioneorb)
	storage_slots = 1
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/storage/assunzionesheath/update_icon()
	if(contents.len)
		icon_state = "assunzionesheath"
	else
		icon_state = "assunzionesheath_empty"
