/obj/item/clothing/gloves/arm_guard
	name = "arm guards"
	desc = "These arm guards will protect your hands and arms."
	icon_state = "arm_guards_riot"
	body_parts_covered = HANDS|ARMS
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	punch_force = 3
	w_class = 3
	siemens_coefficient = 0.35
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/clothing/gloves/arm_guard/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..()) //This will only run if no other problems occured when equiping.
		if(H.wear_suit)
			if(H.wear_suit.body_parts_covered & ARMS)
				to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit], it's in the way.</span>")
				return 0
		return 1

/obj/item/clothing/gloves/arm_guard/laserproof
	name = "ablative arm guards"
	desc = "These arm guards will protect your hands and arms from energy weapons."
	icon_state = "arm_guards_laser"
	siemens_coefficient = 0
	armor = list(melee = 25, bullet = 25, laser = 80, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/bulletproof
	name = "ballistic arm guards"
	desc = "These arm guards will protect your hands and arms from ballistic weapons."
	icon_state = "arm_guards_bullet"
	armor = list(melee = 25, bullet = 80, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/riot
	name = "riot arm guards"
	desc = "These arm guards will protect your hands and arms from close combat weapons."
	armor = list(melee = 80, bullet = 20, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/mercs
	name = "heavy arm guards"
	desc = "These arm guards will protect your hands and arms from harm."
	icon = 'icons/clothing/kit/heavy_armor.dmi'
	item_state = "armguards"
	icon_state = "armguards"
	contained_sprite = TRUE
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	species_restricted = null