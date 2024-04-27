
//changes: rad protection up to 100 from 20/50 respectively
/obj/item/clothing/suit/hazmat/anomaly
	name = "anomaly suit"
	desc = "A sealed bio suit capable of insulating against exotic alien energies."
	icon_state = "engspace_suit"
	item_state = "engspace_suit"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("skr", "taj", "una")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)
	anomaly_protection = 0.6

/obj/item/clothing/head/hazmat/anomaly
	name = "anomaly hood"
	desc = "A sealed bio hood capable of insulating against exotic alien energies."
	icon_state = "engspace_helmet"
	item_state = "engspace_helmet"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("skr", "taj", "una")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)
	anomaly_protection = 0.3

/obj/item/clothing/suit/space/anomaly
	name = "excavation suit"
	desc = "A pressure resistant excavation suit partially capable of insulating against exotic alien energies."
	icon_state = "cespace_suit"
	item_state = "cespace_suit"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit)
	contained_sprite = FALSE
	icon = 'icons/obj/clothing/suits.dmi'
	anomaly_protection = 0.5

/obj/item/clothing/head/helmet/space/anomaly
	name = "excavation hood"
	desc = "A pressure resistant excavation hood partially capable of insulating against exotic alien energies."
	icon_state = "cespace_helmet"
	item_state = "cespace_helmet"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)
	icon = 'icons/obj/clothing/hats.dmi'
	contained_sprite = FALSE
	anomaly_protection = 0.2
