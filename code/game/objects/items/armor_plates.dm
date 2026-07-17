ABSTRACT_TYPE(/obj/item/armor_plate)
	name = "armor plate"
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/armor_plates.dmi'
	should_use_health = TRUE
	maxhealth = 100
	armor_component_type = /datum/component/armor/plate
	/// Flags used to track various states, such as the plate being broken.
	var/plate_flags

/obj/item/armor_plate/on_death(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	return // The actual breaking is handled on the component; it's easier to track the user there.

/obj/item/armor_plate/standard
	name = "level II armor plate"
	desc = "A level II armor plate. This will stop pistol-caliber projectiles."
	icon_state = "plate_standard"
	armor = list(
		MELEE = ARMOR_MELEE_KEVLAR,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_KEVLAR,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED
	)

/obj/item/armor_plate/heavy
	name = "level III heavy armor plate"
	desc = "A heavy and menacing level III armor plate. Tan armor plates went out of style centuries ago!"
	icon_state = "plate_heavy"
	item_state = "plate_heavy"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.2

/obj/item/armor_plate/ballistic
	name = "level III ballistic armor plate"
	desc = "A level III heavy alloy ballistic armor plate in gunmetal grey. Shockingly stylish, but also shockingly tiring to wear!"
	icon_state = "plate_ballistic"
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_MINOR,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	slowdown = 0.2

/obj/item/armor_plate/riot
	name = "riot armor plate"
	desc = "A heavily padded riot armor plate. Many Biesellites wish they had these for Black Friday!"
	icon_state = "plate_ballistic" //todomatt
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	slowdown = 0.2

/obj/item/armor_plate/ablative
	name = "ablative armor plate"
	desc = "A heavy ablative armor plate. Shine like a diamond!"
	icon_state = "plate_ablative"
	armor = list(
		MELEE = ARMOR_MELEE_MINOR,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MAJOR,
		ENERGY = ARMOR_ENERGY_RESISTANT
	)
	slowdown = 0.2
	siemens_coefficient = 0
