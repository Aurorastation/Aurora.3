/obj/item/clothing/shoes/leg_guard
	name = "leg guards"
	desc = "These will protect your legs and feet."
	icon_state = "leg_guards_riot"
	body_parts_covered = LEGS|FEET
	w_class = 3
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.5
	force = 3

/obj/item/clothing/shoes/leg_guard/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..()) //This will only run if no other problems occured when equiping.
		if(H.wear_suit)
			if(H.wear_suit.body_parts_covered & LEGS)
				to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit], it's in the way.</span>")
				return 0
		return 1

/obj/item/clothing/shoes/leg_guard/laserproof
	name = "ablative leg guards"
	desc = "These will protect your legs and feet from energy weapons."
	icon_state = "leg_guards_laser"
	siemens_coefficient = 0
	armor = list(melee = 25, bullet = 25, laser = 80, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/leg_guard/bulletproof
	name = "bulletproof leg guards"
	desc = "These will protect your legs and feet from ballistic weapons."
	icon_state = "leg_guards_bullet"
	armor = list(melee = 25, bullet = 80, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/leg_guard/riot
	name = "riot leg guards"
	desc = "These will protect your legs and feet from close combat weapons."
	armor = list(melee = 80, bullet = 20, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)