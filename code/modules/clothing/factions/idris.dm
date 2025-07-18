//iru coats
/obj/item/clothing/suit/storage/toggle/armor/vest/idris
	name = "black Idris Unit coat"
	desc = "A coat worn by the Idris units, notorious across space."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/idris_iru_coats.dmi'
	icon_state = "idris_coat"
	item_state = "idris_coat"
	allowed = list(/obj/item/gun,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight)
	body_parts_covered = UPPER_TORSO
	cold_protection = 0
	min_cold_protection_temperature = 0
	heat_protection = 0
	max_heat_protection_temperature = 0
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/white
	name = "white Idris Unit coat"
	desc = "A coat worn by the Idris units, notorious across space. This one is white."
	icon_state = "idris_coat_white"
	item_state = "idris_coat_white"

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/brown
	name = "brown Idris Unit coat"
	desc = "A coat worn by the Idris units, notorious across space. This one is white."
	icon_state = "idris_coat_brown"
	item_state = "idris_coat_brown"

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/longcoat
	name = "black Idris Unit long coat"
	desc = "A long coat worn by the Idris units, notorious across space. This one is black."
	icon_state = "idris_longcoat"
	item_state = "idris_longcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/longcoat/white
	name = "white Idris Unit long coat"
	desc = "A long coat worn by the Idris units, notorious across space. This one is white."
	icon_state = "idris_longcoat_white"
	item_state = "idris_longcoat_white"

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/longcoat/brown
	name = "brown Idris Unit long coat"
	desc = "A long coat worn by the Idris units, notorious across space. This one is brown."
	icon_state = "idris_longcoat_brown"
	item_state = "idris_longcoat_brown"

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/trenchcoat
	name = "black Idris Unit trench coat"
	desc = "A trench coat worn by the Idris units, notorious across space. This one is black."
	icon_state = "idris_trenchcoat"
	item_state = "idris_trenchcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/trenchcoat/white
	name = "white Idris Unit trench coat"
	desc = "A trench coat worn by the Idris units, notorious across space. This one is white."
	icon_state = "idris_trenchcoat_white"
	item_state = "idris_trenchcoat_white"

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/trenchcoat/brown
	name = "brown Idris Unit trench coat"
	desc = "A trench coat worn by the Idris units, notorious across space. This one is brown."
	icon_state = "idris_trenchcoat_brown"
	item_state = "idris_trenchcoat_brown"

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/duster
	name = "black Idris Unit duster coat"
	desc = "A duster coat worn by the Idris units, notorious across space. This one is black."
	icon_state = "idris_duster"
	item_state = "idris_duster"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/duster/white
	name = "white Idris Unit duster coat"
	desc = "A duster coat worn by the Idris units, notorious across space. This one is white."
	icon_state = "idris_duster_white"
	item_state = "idris_duster_white"

/obj/item/clothing/suit/storage/toggle/armor/vest/idris/duster/brown
	name = "brown Idris Unit duster coat"
	desc = "A duster coat worn by the Idris units, notorious across space. This one is brown."
	icon_state = "idris_duster_brown"
	item_state = "idris_duster_brown"

//windbreaker

/obj/item/clothing/suit/storage/toggle/idris
	name = "\improper Idris Incorporated jacket"
	desc = "A comfortable windbreaker for Idris Incorporated investigations staff styled after the coats of Idris reclamation units. Many of the Idris patches and badges on the coat are holographic."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	icon_state = "idris_windbreaker"
	item_state = "idris_windbreaker"
	contained_sprite = TRUE

// Fancy dress, for service staff and ICSUs.
/obj/item/clothing/under/dress/idris
	name = "idris incorporated hospitality dress"
	desc = "This is a stylish knee-length teal dress, installed with its own in-built undershirt and scarf that cannot be removed. It is branded prominently with the logo of Idris Incorporated. Commonly worn among Idris Customer Service units, alongside their organic peers."
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	icon_state = "idris_dress"
	item_state = "idris_dress"
	contained_sprite = TRUE
