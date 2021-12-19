/obj/item/clothing/suit/armor/carrier
	name = "plate carrier"
	desc = "A plate carrier that can be decked out with various armor plates and accessories."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "plate_carrier"
	item_state = "plate_carrier"
	blood_overlay_type = "armor"
	w_class = ITEMSIZE_NORMAL
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_PLATE, ACCESSORY_SLOT_ARM_GUARDS, ACCESSORY_SLOT_LEG_GUARDS, ACCESSORY_SLOT_ARMOR_POCKETS)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_PLATE, ACCESSORY_SLOT_ARM_GUARDS, ACCESSORY_SLOT_LEG_GUARDS, ACCESSORY_SLOT_ARMOR_POCKETS, ACCESSORY_SLOT_GENERIC, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_CAPE)
	pockets = null

/obj/item/clothing/suit/armor/carrier/officer
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate,
		/obj/item/clothing/accessory/storage/modular_pouch
	)

/obj/item/clothing/suit/armor/carrier/hos
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/hos,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/generic
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/generic,
		/obj/item/clothing/accessory/storage/modular_pouch
	)

/obj/item/clothing/suit/armor/carrier/riot
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/riot,
		/obj/item/clothing/accessory/leg_guard/riot,
		/obj/item/clothing/accessory/arm_guard/riot,
		/obj/item/clothing/accessory/storage/modular_pouch
	)

/obj/item/clothing/suit/armor/carrier/ballistic
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/ballistic,
		/obj/item/clothing/accessory/leg_guard/ballistic,
		/obj/item/clothing/accessory/arm_guard/ballistic,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/ablative
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/ablative,
		/obj/item/clothing/accessory/leg_guard/ablative,
		/obj/item/clothing/accessory/arm_guard/ablative,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/military
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/military,
		/obj/item/clothing/accessory/leg_guard/military,
		/obj/item/clothing/accessory/arm_guard/military,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/heavy
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/heavy,
		/obj/item/clothing/accessory/leg_guard/heavy,
		/obj/item/clothing/accessory/arm_guard/heavy,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/suit/armor/carrier/heavy/scc
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/heavy/scc,
		/obj/item/clothing/accessory/leg_guard/heavy/scc,
		/obj/item/clothing/accessory/arm_guard/heavy/scc,
		/obj/item/clothing/accessory/storage/modular_pouch/large,
		/obj/item/clothing/accessory/sleevepatch/scc
	)

/obj/item/clothing/suit/armor/carrier/heavy/sec
	starting_accessories = list(
		/obj/item/clothing/accessory/armor_plate/heavy/sec,
		/obj/item/clothing/accessory/leg_guard/heavy/sec,
		/obj/item/clothing/accessory/arm_guard/heavy/sec,
		/obj/item/clothing/accessory/storage/modular_pouch/large
	)

/obj/item/clothing/accessory/armor_plate
	name = "corporate armor plate"
	desc = "A particularly light-weight armor plate in stylish corporate black. Unfortunately, not very good if you hold it with your hands."
	desc_info = "These items must be hooked onto plate carriers for them to work!"
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "plate_sec"
	item_state = "plate_sec"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_PLATE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_KEVLAR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/armor_plate/generic
	name = "kevlar armor plate"
	desc = "A light-weight kevlar armor plate in drab black colors. A galactic favourite of Zavodskoi fans."
	icon_state = "plate_generic"
	item_state = "plate_generic"

/obj/item/clothing/accessory/armor_plate/hos
	name = "commander armor plate"
	desc = "A particularly light-weight armor plate with really cool gold bands. Even more stylish when the gold bands are covered in the blood of your goons!"
	icon_state = "plate_sec_commander"
	item_state = "plate_sec_commander"

/obj/item/clothing/accessory/armor_plate/ballistic
	name = "ballistic armor plate"
	desc = "A heavy alloy ballistic armor plate in gunmetal grey. Shockingly stylish, but also shockingly tiring to wear!"
	icon_state = "plate_ballistic"
	item_state = "plate_ballistic"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/riot
	name = "riot armor plate"
	desc = "A heavily padded riot armor plate. Many Biesellites wish they had these for Black Friday!"
	icon_state = "plate_riot"
	item_state = "plate_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/ablative
	name = "ablative armor plate"
	desc = "A heavy ablative armor plate. Shine like a diamond!"
	icon_state = "plate_ablative"
	item_state = "plate_ablative"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_AP,
		energy = ARMOR_ENERGY_RESISTANT
	)
	slowdown = 1
	siemens_coefficient = 0

/obj/item/clothing/accessory/armor_plate/military
	name = "military armor plate"
	desc = "A heavy military armor plate. Worn by Solarian fanatics everywhere since the 2100s."
	icon_state = "plate_military"
	item_state = "plate_military"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/heavy
	name = "heavy armor plate"
	desc = "A heavy and menacing armor plate. Tan armor plates went out of style centuries ago!"
	icon_state = "plate_heavy"
	item_state = "plate_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)
	slowdown = 1

/obj/item/clothing/accessory/armor_plate/heavy/scc
	name = "heavy SCC armor plate"
	desc = "A heavy and nondescript armor plate. You really get the idea they wanted these mooks to be unfeeling."
	icon_state = "plate_blue"
	item_state = "plate_blue"
	slowdown = 0 // the SCC is hacking

/obj/item/clothing/accessory/storage/modular_pouch
	name = "plate carrier pouches"
	desc = "A comfortable set of pouches that can be attached to a plate carrier, allowing the wearer to store some small items."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "modular_pouch"
	item_state = "modular_pouch"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_POCKETS
	slots = 2

/obj/item/clothing/accessory/storage/modular_pouch/large
	name = "large plate carrier pouches"
	desc = "A comfortable set of pouches that can be attached to a plate carrier, allowing the wearer to store some small items. This one uses advanced sewing techniques for additional storage capacity."
	slots = 3

/obj/item/clothing/accessory/holster/modular
	name = "plate carrier holster"
	desc = "A special holster with rigging able to attach to modern modular plate carriers."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "modular_holster"
	item_state = "modular_holster"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARMOR_POCKETS
	flippable = FALSE

/obj/item/clothing/accessory/armor_plate/heavy/sec
	name = "heavy corporate armor plate"
	desc = "A heavy and stylish armor plate with blue highlights. That prevents teamkills, right?"
	icon_state = "plate_sec_heavy"
	item_state = "plate_sec_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/head/helmet/security
	name = "corporate helmet"
	desc = "A shiny helmet in corporate black! Goes well with the respective plate carrier."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_sec"
	item_state = "helm_sec"

/obj/item/clothing/head/helmet/security/skrell
	name = "skrellmet"
	desc = "A helmet built for use by a Skrell. This one appears to be fairly standard and reliable."
	icon_state = "helm_skrell"
	item_state = "helm_skrell"
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/security/heavy
	name = "corporate heavy helmet"
	desc = "A shiny and heavy helmet in corporate black! Goes well with the respective plate carrier."
	icon_state = "helm_sec_heavy"
	item_state = "helm_sec_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/head/helmet/military
	name = "military helmet"
	desc = "A helmet in drab olive. Used by Solarian fanatics since the 2100s. You really had to pick the least original kit, didn't you?"
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_military"
	item_state = "helm_military"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)
