/datum/battle_monsters/title
	name = "the Monster"
	elements = 0 //Elements to add, if any.
	rarity = 1 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	defense_mul = 1 //The added multipler for the monster's defense points.
	attack_mul = 1 //The added multiplier for the monsters' attack points.
	description = "" //Basically, why do they have this title?
	special_effects = ""// The special effects of this title
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The attack type flags added.
	defense_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The defense type flags added.

/datum/battle_monsters/title/none
	name = ""
	id = "no_title"
	description = ""
	rarity = 0

/datum/battle_monsters/title/great
	name = "the Great"
	id = "great"
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	defense_mul = 1.1
	power_mul = 1.1
	description = "%NAME is known for their extensive adventuring exploits in the Great Kingdom of Al'Karbaro. Rumor has it that their trusty %WEAPON_AND was discovered in a secret underground cave that held the secrets to %ELEMENT_AND."
	rarity = 0.5
	rarity_score = 1

/datum/battle_monsters/title/powerful
	name = "the Powerful"
	id = "powerful"
	attack_mul = 1.25
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	power_mul = 1.25
	description = "%NAME is feared upon by most lesser beings, and with good reason. A single stroke of their %WEAPON_AND is known to destroy the very souls of those unlucky enough to even witness it's power over %ELEMENT_AND."
	special_effects = "Absolute Power: %NAME cannot be attacked by monsters with 4 or lower stars."
	rarity = 0.5
	rarity_score = 1

/datum/battle_monsters/title/wise
	name = "the Wise"
	id = "wise"
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	power_mul = 1.1
	description = "Kings and philopshers all around the Kingdom send their servants to seek out %NAME for their sagely advice on %ELEMENT_AND. Their knowledge of such magic rivals even the greatest of the Old Wizards."
	special_effects = "Elemental Defense: %NAME temporarily gains <b>800</b> bonus defense points when defending against another %ELEMENT_OR type monster."
	rarity = 0.5
	rarity_score = 1

/datum/battle_monsters/title/elemental
	name = "Master of Elements"
	id = "master"
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	power_mul = 1.1
	attack_mul = 0.25
	description = "To master one element takes decades of work, to master all 8 takes several lifetimes of constant dedication. It is no doubt that %NAME is old enough to have the time to study all elements, or is powerful enough to manipulate time itself."
	special_effects = "Neutral Restriction: %NAME can only be attacked by monsters with a neutral element."
	elements = BATTLE_MONSTERS_ELEMENT_ALL
	rarity = 0.5
	rarity_score = 1

