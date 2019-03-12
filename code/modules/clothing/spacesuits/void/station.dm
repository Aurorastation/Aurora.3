// Station voidsuits
//Engineering rig
/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "rig0-engineering"
	item_state_slots = list(
		slot_l_hand_str = "eng_helm",
		slot_r_hand_str = "eng_helm"
		)
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	brightness_on = 6

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "rig-engineering"
	item_state = "eng_voidsuit"
	slowdown = 1
	item_state_slots = list(
		slot_l_hand_str = "eng_hardsuit",
		slot_r_hand_str = "eng_hardsuit"
	)
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)

//Mining rig
/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon_state = "rig0-mining"
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm"
		)
	armor = list(melee = 50, bullet = 5, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 20)
	light_overlay = "helmet_light_dual"
	brightness_on = 6

/obj/item/clothing/suit/space/void/mining
	icon_state = "rig-mining"
	name = "mining voidsuit"
	item_state_slots = list(
		slot_l_hand_str = "mining_hardsuit",
		slot_r_hand_str = "mining_hardsuit"
	)
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	item_state = "mining_voidsuit"
	armor = list(melee = 50, bullet = 5, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 20)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/weapon/pickaxe, /obj/item/weapon/gun/custom_ka, /obj/item/weapon/gun/energy/vaurca/thermaldrill)

//Medical Rig
/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon_state = "rig0-medical"
	item_state_slots = list(
		slot_l_hand_str = "medical_helm",
		slot_r_hand_str = "medical_helm"
		)
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 50)

/obj/item/clothing/suit/space/void/medical
	icon_state = "rig-medical"
	name = "medical voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	item_state = "medical_voidsuit"
	item_state_slots = list(
		slot_l_hand_str = "medical_hardsuit",
		slot_r_hand_str = "medical_hardsuit"
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical, /obj/item/device/breath_analyzer )
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 50)

	//Security
/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-sec"
	item_state_slots = list(
		slot_l_hand_str = "sec_helm",
		slot_r_hand_str = "sec_helm"
		)
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/security
	icon_state = "rig-sec"
	name = "security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "sec_voidsuit"
	item_state_slots = list(
			slot_l_hand_str = "sec_hardsuit",
			slot_r_hand_str = "sec_hardsuit"
	)
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)

//Atmospherics Rig (BS12)
/obj/item/clothing/head/helmet/space/void/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	name = "atmospherics voidsuit helmet"
	icon_state = "rig0-atmos"
	item_state_slots = list(
		slot_l_hand_str = "atmos_helm",
		slot_r_hand_str = "atmos_helm"
		)
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = ATMOS_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE // It is a suit designed for fire, enclosed
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/atmos
	desc = "A special suit that protects against hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	icon_state = "rig-atmos"
	name = "atmos voidsuit"
	item_state = "atmos_voidsuit"
	item_state_slots = list(
		slot_l_hand_str = "atmos_hardsuit",
		slot_r_hand_str = "atmos_hardsuit"
	)
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = ATMOS_MAX_HEAT_PROTECTION_TEMPERATURE // It is a suit designed for fire, enclosed
	max_fire_stacks = FIRE_MAX_FIRESUIT_STACKS + 2

//Head of Security
/obj/item/clothing/head/helmet/space/void/hos
	name = "heavy security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor, and gold trim."
	icon_state = "rig0-hos"
	item_state_slots = list(
		slot_l_hand_str = "sec_helm",
		slot_r_hand_str = "sec_helm"
		)
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/hos
	icon_state = "rig-hos"
	name = "heavy security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor, and gold trim."
	item_state = "sec_voidsuit"
	item_state_slots = list(
			slot_l_hand_str = "sec_hardsuit",
			slot_r_hand_str = "sec_hardsuit"
	)
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)