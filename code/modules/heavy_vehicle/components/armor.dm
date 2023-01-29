/obj/item/robot_parts/robot_component/armor/mech
	name = "exosuit armor plating"
	desc = "A pair of flexible armor plates, used to protect the internals of exosuits and its pilot."
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	origin_tech = list(TECH_MATERIAL = 1)

/obj/item/robot_parts/robot_component/armor/mech/Initialize()
	. = ..()
	AddComponent(/datum/component/armor, armor, ARMOR_TYPE_STANDARD|ARMOR_TYPE_EXOSUIT)

/obj/item/robot_parts/robot_component/armor/mech/radproof
	name = "radiation-proof armor plating"
	desc = "A fully enclosed radiation hardened shell designed to protect the pilot from radiation."
	icon_state = "armor_r"
	icon_state_broken = "armor_r_broken"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/robot_parts/robot_component/armor/mech/em
	name = "EM-shielded armor plating"
	desc = "A shielded plating that sorrounds the eletronics and protects them from electromagnetic radiation."
	icon_state = "armor_e"
	icon_state_broken = "armor_e_broken"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT ,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/robot_parts/robot_component/armor/mech/combat
	name = "heavy combat plating"
	desc = "Plating designed to deflect incoming attacks and explosions."
	icon_state = "armor_c"
	icon_state_broken = "armor_c_broken"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED
	)
	origin_tech = list(TECH_MATERIAL = 5)