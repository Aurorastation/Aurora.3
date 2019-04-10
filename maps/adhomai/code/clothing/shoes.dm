/obj/item/clothing/shoes/armored_boots
	name = "armored boots"
	desc = "Armored boots used commonly by the force of the Imperial Army."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "armored_legs"
	item_state = "armored_legs"
	contained_sprite = TRUE
	armor = list(melee = 50, bullet = 50, laser = 15, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.5
	force = 5
	body_parts_covered = LEGS|FEET
	species_restricted = list("Tajara")
	can_hold_knife = TRUE

/obj/item/clothing/shoes/armored_boots/grenadier
	desc = "Armored boots used commonly by the Royal Grenadiers."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "gren_legs"
	item_state = "gren_legs"
	armor = list(melee = 70, bullet = 70, laser = 20, energy = 10, bomb = 25, bio = 0, rad = 0)