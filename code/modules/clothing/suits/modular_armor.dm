/obj/item/clothing/suit/armor/carrier
	name = "plate carrier"
	desc = "A plate carrier that can be decked out with various armor plates and accessories."
	icon = 'icons/obj/clothing/kit/modular_armor.dmi'
	icon_state = "plate_carrier"

/obj/item/clothing/suit/armor/carrier/officer

/obj/item/clothing/suit/armor/carrier/generic

/obj/item/clothing/suit/armor/carrier/riot

/obj/item/clothing/suit/armor/carrier/ballistic

/obj/item/clothing/suit/armor/carrier/ablative

/obj/item/clothing/suit/armor/carrier/military

/obj/item/clothing/suit/armor/carrier/heavy

/obj/item/clothing/accessory/armor_plate
	name = "corporate armor plate"
	desc = "A particularly light-weight armor plate in corporate colors that hooks. Unfortunately, not very good if you hold it with your hands."
	desc_info = "These items must be hooked onto plate carriers for them to work!"
	icon = 'icons/obj/clothing/kit/modular_armor.dmi'
	icon_state = "plate_sec" //todo: figure out how to add blood overlay for armor
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/armor_plate/Initialize()
	. = ..()
	overlay_state = "[icon_state]_overlay"
	update_icon() //Not actually sure if this is necessary but better to be sure.

/obj/item/clothing/accessory/armor_plate/generic
	name = "kevlar armor plate"
	desc = "A light-weight kevlar armor plate in drab black colors. A galactic favourite of Zavodskoi fans."
	icon_state = "plate_generic"

/obj/item/clothing/accessory/armor_plate/ballistic
	name = "ballistic armor plate"
	desc = "A heavy alloy ballistic armor plate in gunmetal grey."
	icon_state = "plate_ballistic"

/obj/item/clothing/accessory/armor_plate/riot
	name = "riot armor plate"
	desc = "A heavy riot armor plate."
	icon_state = "plate_riot"

/obj/item/clothing/accessory/armor_plate/ablative
	name = "ablative armor plate"
	desc = "A heavy ablative armor plate."
	icon_state = "plate_ablative"

/obj/item/clothing/accessory/armor_plate/military
	name = "military armor plate"
	desc = "A heavy military armor plate."
	icon_state = "plate_military"

/obj/item/clothing/suit/armor/carrier/heavy
	name = "heavy armor plate"
	desc = "A heavy, yet menacing armor plate."
	icon_state = "plate_heavy"