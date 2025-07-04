//Religious items
/obj/item/clothing/accessory/rosary
	name = "rosary"
	desc = "A form of prayer psalter used in the Catholic Church, with a string of beads attached to it."
	icon = 'icons/obj/item/clothing/accessory/religious.dmi'
	icon_state = "rosary"
	overlay_state = "rosary"
	flippable = 1

	slot_flags = SLOT_BELT | SLOT_TIE

	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/accessory/crucifix
	name = "crucifix"
	desc = "A small cross on a piece of string. Commonly associated with the Christian faith, it is a main symbol of this religion."
	icon = 'icons/obj/item/clothing/accessory/religious.dmi'
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/accessory/crucifix/gold
	name = "gold crucifix"
	desc = "A small, gold cross on a piece of string. Commonly associated with the Christian faith, it is a main symbol of this religion."
	icon_state = "golden_crucifix"
	item_state = "golden_crucifix"

/obj/item/clothing/accessory/crucifix/gold/saint_peter
	name = "gold Saint Peter crucifix"
	desc = "A small, gold cross on a piece of string. Being inverted and thus upside down marks it as the cross of Saint Peter, a historic Christian symbol \
	which has been re-purposed as a satanic symbol since the 21st century as well."
	icon_state = "golden_crucifix_ud"
	item_state = "golden_crucifix_ud"

/obj/item/clothing/accessory/crucifix/silver
	name = "silver crucifix"
	desc = "A small, silver cross on a piece of string. Commonly associated with the Christian faith, it is a main symbol of this religion."
	icon_state = "silver_crucifix"
	item_state = "silver_crucifix"

/obj/item/clothing/accessory/crucifix/silver/saint_peter
	name = "silver Saint Peter crucifix"
	desc = "A small, silver cross on a piece of string. Being inverted and thus upside down marks it as the cross of Saint Peter, a historic Christian symbol \
	which has been re-purposed as a satanic symbol since the 21st century as well."
	icon_state = "silver_crucifix_ud"
	item_state = "silver_crucifix_ud"

/obj/item/clothing/accessory/scapular
	name = "scapular"
	desc = "A Christian garment suspended from the shoulders. As an object of popular piety, \
	it serves to remind the wearers of their commitment to live a Christian life."
	icon = 'icons/obj/item/clothing/accessory/religious.dmi'
	icon_state = "scapular"
	item_state = "scapular"

/obj/item/clothing/accessory/tallit
	name = "tallit"
	desc = "A tallit is a fringed garment worn as a prayer shawl by religious Jews. \
	The tallit has special twined and knotted fringes known as tzitzit attached to its four corners."
	icon = 'icons/obj/item/clothing/accessory/religious.dmi'
	item_state = "tallit"
	icon_state = "tallit"
	contained_sprite = TRUE

/obj/item/clothing/accessory/assunzione
	name = "luceian amulet"
	desc = "A common symbol of the Luceian faith abroad, this amulet featuring the religion's all-seeing eye and eight-pointed crest \
	seems to be made of real gold and gemstones. While not as critical to faithful abroad as a warding sphere, it is considered good form \
	to ensure one's amulet is well-maintained."
	desc_extended = "Plated in 18-karat gold and decorated with rubies, this amulet, as jewelry, is both ornate and extremely well-made. In addition to being a passive display of one's faith - not quite holding much religious value - \
	its wear is often promoted by Assunzione's government as a testament of the planet's superlative craftsmanship talent and material wealth. While it fetches for an extremely high price in the market, voluntarily selling this amulet is considered \
	sacrilegious, and a display of weak resolve."
	icon = 'icons/obj/item/clothing/accessory/religious.dmi'
	item_state = "assunzione_amulet"
	icon_state = "assunzione_amulet"
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
