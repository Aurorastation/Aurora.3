/obj/item/clothing/gloves/grenadier
	name = "armored gauntlets"
	desc = "A pair of armored gauntlets, commonly used by the forces of the Imperial Army."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "armored_arms"
	item_state = "armored_arms"
	armor = list(melee = 50, bullet = 50, laser = 15, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.5
	force = 5
	punch_force = 5
	species_restricted = list("Tajara")
	body_parts_covered = HANDS|ARMS
	contained_sprite = TRUE

/obj/item/clothing/gloves/grenadier/armored
	desc = "A pair of armored gauntlets, commonly used by the Royal Grenadiers."
	icon_state = "roygrenarms"
	item_state = "roygrenarms"
	punch_force = 10
	sharp = 1
	armor = list(melee = 70, bullet = 70, laser = 20, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/gloves/black/oven
	desc = "Fire-resistant oven mitts. Bone apple tits."
	name = "ovemitts"
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "ovenmitts"
	item_state = "omitts"
	species_restricted = null