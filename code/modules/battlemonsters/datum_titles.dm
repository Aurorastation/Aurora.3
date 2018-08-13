datum/battle_monsters/title
	name = "the Monster"
	elements = 0 //Elements to add, if any.
	rarity = 1 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	defense_mul = 1 //The added multipler for the monster's defense points.
	attack_mul = 1 //The added multiplier for the monsters' attack points.
	description = "" //Basically, why do they have this title?
	special_effects = ""// The special effects of this title
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The attack type flags added.
	defense_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The defense type flags added.

datum/battle_monsters/title/none
	name = ""
	id = "no_title"
	description = ""
	rarity = 0

datum/battle_monsters/title/great
	name = "the Great"
	id = "great"
	power_add = 200
	defense_mul = 1.1
	power_mul = 1.1
	description = "%NAME is known for their extensive adventuring exploits in the Great Kingdom of Al'Karbaro."
	rarity = 0.5
	rarity_score = 1

datum/battle_monsters/title/powerful
	name = "the Powerful"
	id = "powerful"
	attack_mul = 1.25
	power_add = 200
	power_mul = 1.1
	description = "%NAME is feared upon by most lesser beings, and with good reason."
	special_effects = "Absolute Power: %NAME cannot be attacked by monsters with a base attack rating less than <b>2000</b>."
	rarity = 1
	rarity_score = 1

datum/battle_monsters/title/wise
	name = "the Wise"
	id = "wise"
	power_add = 200
	power_mul = 1.1
	description = "Kings and philopshers all around the Kingdom send their servants to seek out %NAME for their sagely advice."
	special_effects = "Elemental Defense: %NAME temporarily gains <b>800</b> bonus defense points when defending against another %ELEMENT_OR type monster."
	rarity = 0.5
	rarity_score = 1

datum/battle_monsters/title/elemental
	name = "Master of $ELEMENT_AND"
	id = "master"
	power_add = 200
	power_mul = 1.1
	attack_mul = 0.25
	description = "It is rumored that %NAME is powerful enough to alter the very fabric of time with their mastery of $ELEMENT_AND."
	special_effects = "Elemental Offense: %NAME gains <b>500</b> attack points when attacking against another %ELEMENT_OR type monster."
	rarity = 0.5
	rarity_score = 1

