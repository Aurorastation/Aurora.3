datum/battle_monsters/
	var/name = "ERROR"
	var/icon_state
	var/id
	var/description = ""
	var/special_effects = ""
	var/tip = "" //A tip for the card.
	var/elements = BATTLE_MONSTERS_ELEMENT_NONE
	var/attack_type = BATTLE_MONSTERS_ATTACKTYPE_NONE
	var/defense_type = BATTLE_MONSTERS_DEFENSETYPE_NONE
	var/rarity = 1 //Relative chance of choosing this attribute
	var/rarity_score = 0

	var/power_add = 0
	var/power_mul = 1

	var/attack_add = 0
	var/attack_mul = 1

	var/defense_add = 0
	var/defense_mul = 1