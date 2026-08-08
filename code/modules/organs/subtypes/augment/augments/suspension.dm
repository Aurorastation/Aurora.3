/obj/item/organ/internal/augment/suspension
	name = "calf suspension"
	icon_state = "suspension"
	desc = "An augment that allows the wearer to jump further and slightly reduces the damage from falling from heights."
	organ_tag = BP_AUG_SUSPENSION
	parent_organ = BP_GROIN
	min_broken_damage = 20
	max_damage = 20
	var/suspension_mod = 0.8
	var/jump_bonus = 1

/obj/item/organ/internal/augment/suspension/advanced
	name = "advanced calf suspension"
	icon_state = "suspension_adv"
	desc = "An advanced, stronger form of the calf suspension augment that can completely absorb and counteract damage from falling."
	min_broken_damage = 50
	max_damage = 50
	suspension_mod = 0

/obj/item/organ/internal/augment/absorber
	name = "calf absorber"
	icon_state = "absorber"
	desc = "The sturdy, high-compatible alternative to calf suspension focused on moderately absorbing fall damage."
	organ_tag = BP_AUG_SUSPENSION
	parent_organ = BP_GROIN
	min_broken_damage = 40
	max_damage = 40
	var/suspension_mod = 0.4
