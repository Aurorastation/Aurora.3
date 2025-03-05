/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Tall synthleather boots with an artificial shine."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "jackboots"
	item_state = "jackboots"
	force = 3
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_MINOR
	)
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi' //depreceated, only used for bulwarks due to their size
	)


/obj/item/clothing/shoes/jackboots/cavalry
	name = "cavalry jackboots"
	desc = "Calf-length cavalry synthleather boots with an artificial shine."
	icon_state = "cavalryboots"
	item_state = "cavalryboots"

/obj/item/clothing/shoes/jackboots/riding
	name = "riding jackboots"
	desc = "Knee-high riding synthleather boots with an artificial shine."
	icon_state = "ridingboots"
	item_state = "ridingboots"

/obj/item/clothing/shoes/jackboots/toeless
	name = "toe-less black boots"
	desc = "Modified pair of boots, particularly friendly to those species whose toes hold claws."
	icon_state = "jackboots_toeless"
	item_state = "jackboots_toeless"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/jackboots/toeless/cavalry
	name = "toe-less cavalry jackboots"
	desc = "Calf-length cavalry synthleather boots, particularly friendly to those species whose toes hold claws."
	icon_state = "cavalryboots_toeless"
	item_state = "cavalryboots_toeless"

/obj/item/clothing/shoes/jackboots/toeless/riding
	name = "toe-less riding jackboots"
	desc = "Knee-high riding synthleather boots, particularly friendly to those species whose toes hold claws."
	icon_state = "ridingboots_toeless"
	item_state = "ridingboots_toeless"

/obj/item/clothing/shoes/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "workboots"
	item_state = "workboots"
	force = 3
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_MINOR,
		RAD = ARMOR_RAD_MINOR
	)
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi' //depreceated, only used for bulwarks due to their size
	)

/obj/item/clothing/shoes/workboots/toeless
	name = "toe-less workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workboots_toeless"
	item_state = "workboots_toeless"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")

/obj/item/clothing/shoes/workboots/all_species
	species_restricted = null

/obj/item/clothing/shoes/workboots/brown
	name = "brown workboots"
	desc = "A pair of brown steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots_brown"
	item_state = "workboots_brown"

/obj/item/clothing/shoes/workboots/toeless/brown
	name = "toe-less brown workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workboots_brown_toeless"
	item_state = "workboots_brown_toeless"

/obj/item/clothing/shoes/workboots/grey
	name = "grey workboots"
	desc = "A pair of grey steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots_grey"
	item_state = "workboots_grey"

/obj/item/clothing/shoes/workboots/toeless/grey
	name = "toe-less grey workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workboots_grey_toeless"
	item_state = "workboots_grey_toeless"

/obj/item/clothing/shoes/workboots/dark
	name = "dark workboots"
	desc = "A pair of dark steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots_dark"
	item_state = "workboots_dark"

/obj/item/clothing/shoes/workboots/toeless/dark
	name = "toe-less dark workboots"
	desc = "A pair of toeless dark work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workboots_dark_toeless"
	item_state = "workboots_dark_toeless"

/obj/item/clothing/shoes/combat //basic syndicate combat boots for nuke ops and mob corpses
	name = "combat boots"
	desc = "High speed, low drag combat boots."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	icon_state = "combat"
	item_state = "combat"
	contained_sprite = TRUE
	force = 11
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_MINOR
	)
	item_flags = ITEM_FLAG_NO_SLIP
	siemens_coefficient = 0.35
	can_hold_knife = TRUE
	build_from_parts = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/winter
	name = "winter boots"
	desc = "A pair of heavy winter boots made out of animal furs, reaching up to the knee."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "winterboots"
	item_state = "winterboots"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
			MELEE = ARMOR_MELEE_MINOR,
			BIO = ARMOR_BIO_MINOR
			)
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi' //depreceated, only used for bulwarks due to their size
	)

	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/shoes/winter/toeless
	name = "toe-less winter boots"
	desc = "A pair of toe-less heavy winter boots made out of animal furs, reaching up to the knee.  Modified for species whose toes have claws."
	icon_state = "winterboots_toeless"
	item_state = "winterboots_toeless"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/aerostatic
	name = "aerostatic boots"
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	desc = "A crisp, clean set of boots for working long hours on the beat."
	icon_state = "aerostatic"
	item_state = "aerostatic"

/obj/item/clothing/shoes/jackboots/kala
	name = "skrell boots"
	desc = "A sleek pair of boots. They seem to be retaining moisture."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "kala_boots"
	item_state = "kala_boots"
	contained_sprite = TRUE

/obj/item/clothing/shoes/heeledboots/toeless
	name = "toeless heeled boots"
	desc = "A pair of toeless boots with heels."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "heeledboots_toeless"
	item_state = "heeledboots_toeless"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/heeledboots
	name = "heeled boots"
	desc = "A pair of boots with heels."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "heeledboots"
	item_state = "heeledboots"

/obj/item/clothing/shoes/thighboots
	name = "thigh-high boots"
	desc = "A pair of casual boots that reach up to the thighs."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "thighboots"
	item_state = "thighboots"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/thighboots/toeless
	name = "thigh-high toeless boots"
	desc = "A pair of casual boots that reach up to the thighs, the toes have been cut off."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "thighboots_toeless"
	item_state = "thighboots_toeless"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/thighboots/heels
	name = "thigh-high heeled boots"
	desc = "A pair of casual heeled boots that reach up to the thigh."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "thighboots_heels"
	item_state = "thighboots_heels"

/obj/item/clothing/shoes/thighboots/heels/toeless
	name = "thigh-high toeless heeled boots"
	desc = "A pair of casual heeled boots that reach up to the thigh, the toes have been cut off."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "thighboots_heels_toeless"
	item_state = "thighboots_heels_toeless"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/fullboots
	name = "full-length boots"
	desc = "A pair of boots that cover the entire leg, probably uncomfortable to wear."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "fullboots"
	item_state = "fullboots"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/fullboots/toeless
	name = "full-length toeless boots"
	desc = "A pair of boots the cover the entire leg, except for the toes."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "fullboots_toeless"
	item_state = "fullboots_toeless"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/fullboots/heels
	name = "full-length heeled boots"
	desc = "A pair of heeled boots that cover the entire leg, probably uncomfortable to wear."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "fullboots_heels"
	item_state = "fullboots_heels"

/obj/item/clothing/shoes/fullboots/heels/toeless
	name = "full-length toeless heeled boots"
	desc = "A pair of heeled boots that cover the entire leg, except for the toes."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "fullboots_heels_toeless"
	item_state = "fullboots_heels_toeless"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/mudboots
	name = "mudboots"
	desc = "A nice pair of weatherproof mudboots to keep your feet dry."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "mudboots"
	item_state = "mudboots"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/mudboots/thigh
	name = "thigh-high mudboots"
	desc = "A nice pair of weatherproof mudboots to keep your legs dry."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "thighmudboots"
	item_state = "thighmudboots"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/colorcombat
	name = "combat boots"
	desc = "The sweatiest LARPer you know wears these."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "colorcombat"
	item_state = "colorcombat"

/obj/item/clothing/shoes/jackboots/color
	name = "jackboots"
	desc = "Synthleather boots with an artifical shine, in a variety of colors."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "colorjackboots"
	item_state = "colorjackboots"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/jackboots/toeless/color
	name = "toeless jackboots"
	desc = "Synthleather boots with the toes cut off, in a variety of colors"
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "colorjackboots_toeless"
	item_state = "colorjackboots_toeless"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)


/obj/item/clothing/shoes/workboots/color
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. In a variety of colors!"
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "colorworkboots"
	item_state = "colorworkboots"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/workboots/toeless/color
	name = "toeless workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. In a variety of colors!"
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "colorworkboots_toeless"
	item_state = "colorworkboots_toeless"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

/obj/item/clothing/shoes/ankleboots
	name = "ankle boots"
	desc = "A pair of low-heeled boots, if you need inclosed shoes."
	icon = 'icons/obj/item/clothing/shoes/boots.dmi'
	contained_sprite = TRUE
	icon_state = "ankleboots"
	item_state = "ankleboots"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

