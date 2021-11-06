/obj/item/clothing/shoes/galoshes
	desc = "A waterproof overshoe, made of rubber."
	name = "galoshes"
	icon_state = "galoshes"
	item_state = "galoshes"
	permeability_coefficient = 0.05
	item_flags = NOSLIP
	slowdown = 1
	species_restricted = null
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi'
	)
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
	sprite_sheets = list("Tajara" = 'icons/mob/species/tajaran/shoes.dmi')

/obj/item/clothing/shoes/jackboots
	name = "black boots"
	desc = "Tall synthleather boots with an artificial shine."
	icon_state = "jackboots"
	item_state = "jackboots"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_KNIVES
	)
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/shoes/jackboots/knee
	name = "knee-length black boots"
	desc = "Taller synthleather boots with an artificial shine."
	icon_state = "kneeboots"
	item_state = "kneeboots"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi'
	)

/obj/item/clothing/shoes/jackboots/thigh
	name = "thigh-length black boots"
	desc = "Even taller synthleather boots with an artificial shine."
	icon_state = "thighboots"
	item_state = "thighboots"

/obj/item/clothing/shoes/jackboots/toeless
	name = "toe-less black boots"
	desc = "Modified pair of boots, particularly friendly to those species whose toes hold claws."
	icon_state = "jackboots_toeless"
	species_restricted = null
	sprite_sheets = list(BODYTYPE_TAJARA = 'icons/mob/species/tajaran/shoes.dmi', BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi')

/obj/item/clothing/shoes/jackboots/toeless/knee
	name = "knee-high toeless black boots"
	desc = "Modified pair of taller boots, particularly friendly to those species whose toes hold claws."
	icon_state = "kneeboots_toeless"
	item_state = "kneeboots_toeless"

/obj/item/clothing/shoes/jackboots/toeless/thigh
	name = "thigh-high toeless black boots"
	desc = "Modified pair of even taller boots, particularly friendly to those species whose toes hold claws."
	icon_state = "thighboots_toeless"
	item_state = "thighboots_toeless"

/obj/item/clothing/shoes/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots"
	item_state = "workboots"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		rad = ARMOR_RAD_MINOR
	)
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi'
	)
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/shoes/workboots/toeless
	name = "toe-less workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workboots_toeless"
	species_restricted = null
	sprite_sheets = list(BODYTYPE_TAJARA = 'icons/mob/species/tajaran/shoes.dmi', BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi')

/obj/item/clothing/shoes/workboots/grey
	name = "grey workboots"
	desc = "A pair of grey steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots_grey"
	item_state = "workboots_grey"

/obj/item/clothing/shoes/workboots/toeless/grey
	name = "toe-less grey workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workboots_grey_toeless"
	item_state = "workboots_grey"

/obj/item/clothing/shoes/workboots/dark
	name = "dark workboots"
	desc = "A pair of dark steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots_dark"
	item_state = "workboots_dark"

/obj/item/clothing/shoes/workboots/toeless/dark
	name = "toe-less dark workboots"
	desc = "A pair of toeless dark work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workboots_dark_toeless"
	item_state = "workboots_dark"
