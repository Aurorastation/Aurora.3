/obj/item/clothing/head/helmet/space/void/sol
	name = "military voidsuit helmet"
	desc = "A sleek black space helmet designed for combat. Looks to be uniform with Sol Alliance colors."
	icon_state = "sol_helmet"
	item_state = "sol_helmet"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	species_restricted = list("Human")

	brightness_on = 6
	refittable = FALSE


/obj/item/clothing/suit/space/void/sol
	name = "military voidsuit"
	desc = "A sleek black space suit designed for combat. Looks to have seamless composite plating. Painted in Sol Alliance colors."
	icon_state = "sol_suit"
	item_state = "sol_suit"
	slowdown = 1
	armor = list(melee = 70, bullet = 55, laser = 45, energy = 15, bomb = 40, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/frontier
	name = "frontier vulture voidsuit helmet"
	desc = "A helmet resembling an avian, built for the Human head. Heavy and plated with plasteel across its faces."
	icon_state = "vulture"
	item_state = "vulture"
	armor = list(melee = 80, bullet = 70, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 30)
	siemens_coefficient = 0.35
	species_restricted = list("Human")

	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/frontier
	name = "frontier vulture voidsuit"
	desc = "An iconic Frontier Alliance standard-issue voidsuit, designed after the Interstellar War and seen in use to this day."
	icon_state = "vulture"
	item_state = "vulture"
	slowdown = 3
	armor = list(melee = 80, bullet = 70, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 30)
	allowed = list(/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	refittable = FALSE


/obj/item/clothing/head/helmet/space/void/cruiser
	name = "cruiser voidsuit helmet"
	desc = "A silvery chrome, single visor space helmet with built-in peripherals and very bright fore lighting. A favorite of bounty hunters."
	icon_state = "eridani_suit"
	item_state = "eridani_suit"
	armor = list(melee = 50, bullet = 50, laser = 40, energy = 50, bomb = 50, bio = 100, rad = 30)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	w_class = 3
	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/cruiser
	name = "cruiser voidsuit"
	desc = "A silvery chrome voidsuit with neon highlights. Utilized by Eridani private military and police."
	icon_state = "eridani_suit"
	item_state = "eridani_suit"
	armor = list(melee = 50, bullet = 50, laser = 40, energy = 40, bomb = 50, bio = 100, rad = 30)
	allowed = list(/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/valkyrie
	name = "valkyrie voidsuit helmet"
	desc = "A slot-eyed space helmet, sleek and designed for military purposes. Colored in Elyran military camouflage."
	icon_state = "valkyrie"
	item_state = "valkyrie"
	armor = list(melee = 60, bullet = 30, laser = 50, energy = 40, bomb = 60, bio = 100, rad = 100)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000
	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/valkyrie
	name = "valkyrie voidsuit"
	desc = "A pricey specialist voidsuit designed for atmospheric long jumping and combat. Colored in Elyran military camouflage."
	icon_state = "valkyrie"
	item_state = "valkyrie"
	armor = list(melee = 60, bullet = 30, laser = 50, energy = 40, bomb = 60, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	refittable = FALSE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/clothing/head/helmet/space/void/lancer
	name = "lancer voidsuit helmet"
	desc = "A sleek helmet with a bright yellow visor, expertly made in and colored in the iconic branding of Ceres' Lance."
	icon_state = "lancer_suit"
	item_state = "lancer_suit"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	refittable = FALSE

/obj/item/clothing/suit/space/void/lancer
	name = "lancer voidsuit"
	desc = "A bulky void suit with heavy plating. Looks to be colored in the branding of Ceres' Lance."
	icon_state = "lancer_suit"
	item_state = "lancer_suit"
	slowdown = 1
	w_class = 3
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/kataphract
	name = "kataphract voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint on the sides indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony."
	icon = 'icons/obj/clothing/species/unathi/hats.dmi'
	icon_override = 'icons/mob/species/unathi/helmet.dmi'
	icon_state = "rig0-kataphract"
	item_state = "rig0-kataphract"
	armor = list(melee = 75, bullet = 45, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 80)
	siemens_coefficient = 0.35
	species_restricted = list("Unathi")
	refittable = FALSE

/obj/item/clothing/suit/space/void/kataphract
	name = "kataphract voidsuit"
	desc = "A large suit of spaceproof armour, segmented and worked together expertly. Runic tabbard on the front and back indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony."
	icon = 'icons/obj/clothing/species/unathi/suits.dmi'
	icon_override = 'icons/mob/species/unathi/suit.dmi'
	icon_state = "rig-kataphract"
	item_state = "rig-kataphract"
	slowdown = 1
	w_class = 3
	armor = list(melee = 75, bullet = 45, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 80)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list("Unathi")
	refittable = FALSE