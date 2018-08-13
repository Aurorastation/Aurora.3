datum/battle_monsters/monster
	name = "monster" //The base name of the card. In the end it will look something like "dark monster, the great"
	power_add = 500 //Their base power. Power is basically how strong the card in respect to it's defense and attack points.
	defense_mul = 1 //Their defense point multiplier, or BDM
	attack_mul = 1 //Their attack point multiplier, or BAM.
	//Note: Values are normalized based on the highest multiplier. A BDM of 2 and a BAM of 1 is equal to a BDM of 1 and a BAM of 0.5.
	//BDM of 0.75 and a BDA of 0.25 with a monster of 1000 BP means the monster will have 750 defense points and 250 attack points.
	rarity = 1 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	//For reference, 1 is common, 0.5 is uncommon, 0.25 is rare, and anything below it is ultra rare.
	description = "a fat beast" //The description of this monster. It should make sense when put before "The card depicts"
	special_effects = "" //The special effects a monster has, if any.
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The attack flags of the monster. This is basically a general indicator of the weapon it uses.
	defense_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The defense flags of the monster. This is basically a general indicator of what the monster is made out of. Not to be confused with their element.
	rarity_score = 0 //Rarity score to add to this card.
	//1 or lower means common, 2 means uncommon, 3 means rare, 4 or higher means legendary.
	//Uncommon or higher rarities should be used sparringly, and only to cards that are super noteable.

datum/battle_monsters/monster/human
	name = "Human"
	id = "human"
	icon_state = "human"
	power_add = 500
	defense_add = 1
	attack_add = 1
	rarity = 2
	description = "a typical human citizen of the Great Kingdom. While not a trained fighter, all humans are quick thinkers and know how to punch when it matters."
	special_effects = ""
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_HUMAN
	rarity_score = -2

datum/battle_monsters/monster/human/mage
	name = "Apprentice Mage"
	id = "mage"
	icon_state = "staff"
	power_add = 500
	defense_add = 1
	attack_add = 3
	rarity = 1
	description = "a young and eager-looking %SPECIES mage."
	special_effects = "Tutor: %NAME temporarily gains <b>250</b> bonus attack points if a spellcaster with more attack points than %NAME is on your side of the field."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER

datum/battle_monsters/monster/human/sage
	name = "Wise Sage"
	id = "sage"
	icon_state = "staff"
	power_add = 1000
	defense_add = 1
	attack_add = 2
	rarity = 0.5
	description = "an elderly %SPECIES, dressed in typical wizard garb."
	special_effects = "Elemental Defense: %NAME temporarily gains <b>500</b> bonus defense points when defending against another %ELEMENT_OR type monster."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER

datum/battle_monsters/monster/human/wizard
	name = "Master Wizard"
	id = "wizard"
	icon_state = "staff"
	power_add = 2000
	defense_add = 1
	attack_add = 2
	rarity = 0.25
	description = "an elderly %SPECIES, dressed in typical wizard garb."
	special_effects = "Elemental Spell Immune: %NAME is immune to %ELEMENT_AND based spell cards."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER
	rarity_score = 1

datum/battle_monsters/monster/human/warrior
	name = "Warrior"
	id = "warrior"
	icon_state = "human"
	power_add = 1000
	defense_add = 2
	attack_add = 1
	rarity = 0.25
	description = "a strong and hardy %SPECIES wearing heavy armor and wielding a %WEAPON_AND."
	special_effects = "%SPECIES Bond: %NAME gains <b>300</b> attack points if there is another %SPECIES on the same side of the field."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity_score = 1

datum/battle_monsters/monster/human/knight
	name = "Knight"
	id = "knight"
	icon_state = "human_knight"
	power_add = 1500
	defense_add = 4
	attack_add = 1
	rarity = 0.1
	description = "a loyal %SPECIES knight dorned in heavy %ELEMENT_AND armor."
	special_effects = "%SPECIES Protection: As long as %NAME is on the field, all other %SPECIES are attack immune."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity_score = 1

datum/battle_monsters/monster/human/king
	name = "King"
	id = "king"
	icon_state = "king"
	power_add = 2000
	defense_add = 1
	attack_add = 10
	rarity = 0.05
	description = "a fat %SPECIES king sitting atop a golden throne, with a small army on a gold chessboard. Their golden crown is quite large for their small head."
	special_effects = "Selfish Protection: %NAME cannot be attacked if other monsters exist on the same side of the field."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_ARMY
	rarity_score = 2

datum/battle_monsters/monster/human/queen
	name = "Queen"
	id = "queen"
	icon_state = "king"
	power_add = 2000
	defense_add = 1
	attack_add = 5
	rarity = 0.05
	description = "an incredibly voluptuous %SPECIES female adorned in a %ELEMENTS_AND robe. A tight-fitting crown sits atop her head."
	special_effects = "Lustful Aurora: %NAME cannot be attacked by %SPECIES."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_ARMY
	rarity_score = 2