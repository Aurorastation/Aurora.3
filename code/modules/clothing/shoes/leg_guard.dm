/obj/item/clothing/accessory/leg_guard
	name = "leg guards"
	desc = "These will protect your legs and feet."
	icon_state = "leg_guards_riot"
	item_state = "jackboots"
	body_parts_covered = LEGS|FEET
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35
	force = 3
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/accessory/leg_guard/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..()) //This will only run if no other problems occured when equiping.
		if(H.wear_suit)
			if(H.wear_suit.body_parts_covered & LEGS)
				to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit], it's in the way.</span>")
				return 0
		return 1

/obj/item/clothing/accessory/leg_guard/ablative
	name = "ablative leg guards"
	desc = "These will protect your legs and feet from energy weapons."
	icon_state = "leg_guards_laser"
	siemens_coefficient = 0
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/ballistic
	name = "ballistic leg guards"
	desc = "These will protect your legs and feet from ballistic weapons."
	icon_state = "leg_guards_bullet"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/riot
	name = "riot leg guards"
	desc = "These will protect your legs and feet from close combat weapons."
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/heavy
	name = "heavy leg guards"
	desc = "These leg guards will protect your legs and feet from harm."
	icon = 'icons/clothing/kit/heavy_armor.dmi'
	item_state = "legguards"
	icon_state = "legguards"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	species_restricted = null
