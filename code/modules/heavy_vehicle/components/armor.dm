/obj/item/robot_parts/robot_component/armor/mech
	name = "exosuit armor plating"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
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
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/robot_parts/robot_component/armor/mech/em
	name = "EM-shielded armor plating"
	desc = "A shielded plating that sorrounds the eletronics and protects them from electromagnetic radiation."
	armor = list(
		melee = ARMOR_MELEE_RESISTANT ,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/robot_parts/robot_component/armor/mech/combat
	name = "heavy combat plating"
	desc = "Plating designed to deflect incoming attacks and explosions."
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED
	)
	origin_tech = list(TECH_MATERIAL = 5)