//Leg guards.
/obj/item/clothing/accessory/leg_guard
	name = "corporate leg guards"
	desc = "These will protect your legs and feet."
	desc_info = "These items must be hooked onto plate carriers for them to work!"
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "legguards_sec"
	item_state = "legguards_sec"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_LEG_GUARDS
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_KEVLAR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	body_parts_covered = LEGS|FEET
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/accessory/leg_guard/ablative
	name = "ablative leg guards"
	desc = "These will protect your legs and feet from energy weapons."
	icon_state = "legguards_ablative"
	item_state = "legguards_ablative"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_AP,
		energy = ARMOR_ENERGY_RESISTANT
	)
	siemens_coefficient = 0

/obj/item/clothing/accessory/leg_guard/ballistic
	name = "ballistic leg guards"
	desc = "These will protect your legs and feet from ballistic weapons."
	icon_state = "legguards_ballistic"
	item_state = "legguards_ballistic"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/riot
	name = "riot leg guards"
	desc = "These will protect your legs and feet from close combat weapons."
	icon_state = "legguards_riot"
	item_state = "legguards_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/military
	name = "military leg guards"
	desc = "These will protect your legs and feet from most things."
	icon_state = "legguards_military"
	item_state = "legguards_military"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/heavy
	name = "heavy leg guards"
	desc = "These leg guards will protect your legs and feet from most things."
	icon_state = "legguards_heavy"
	item_state = "legguards_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/accessory/leg_guard/heavy/scc
	name = "heavy SCC leg guards"
	icon_state = "legguards_blue"
	item_state = "legguards_blue"

/obj/item/clothing/accessory/leg_guard/heavy/sec
	name = "heavy corporate leg guards"
	icon_state = "legguards_sec_heavy"
	item_state = "legguards_sec_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

//Arm guards.
/obj/item/clothing/accessory/arm_guard
	name = "corporate arm guards"
	desc = "These arm guards will protect your hands and arms."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "armguards_sec"
	item_state = "armguards_sec"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARM_GUARDS
	body_parts_covered = HANDS|ARMS
	armor = list(
		melee = ARMOR_MELEE_KEVLAR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	w_class = ITEMSIZE_NORMAL
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/clothing/accessory/arm_guard/ablative
	name = "ablative arm guards"
	desc = "These arm guards will protect your hands and arms from energy weapons."
	icon_state = "armguards_ablative"
	item_state = "armguards_ablative"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_AP,
		energy = ARMOR_ENERGY_RESISTANT
	)
	siemens_coefficient = 0

/obj/item/clothing/accessory/arm_guard/ballistic
	name = "ballistic arm guards"
	desc = "These arm guards will protect your hands and arms from ballistic weapons."
	icon_state = "armguards_ballistic"
	item_state = "armguards_ballistic"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/arm_guard/riot
	name = "riot arm guards"
	desc = "These arm guards will protect your hands and arms from close combat weapons."
	icon_state = "armguards_riot"
	item_state = "armguards_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/arm_guard/military
	name = "military arm guards"
	desc = "These arm guards will protect your hands and arms from most things."
	icon_state = "armguards_military"
	item_state = "armguards_military"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/accessory/arm_guard/heavy
	name = "heavy arm guards"
	desc = "These arm guards will protect your hands and arms from most things."
	icon_state = "armguards_heavy"
	item_state = "armguards_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/accessory/arm_guard/heavy/scc
	name = "heavy SCC arm guards"
	icon_state = "armguards_blue"
	item_state = "armguards_blue"

/obj/item/clothing/accessory/arm_guard/heavy/sec
	name = "heavy corporate arm guards"
	icon_state = "armguards_sec_heavy"
	item_state = "armguards_sec_heavy"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_REVOLVER,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
	)