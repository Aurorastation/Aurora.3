/datum/battle_monsters/monster
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
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_NONE //The defense flags of the monster. This is basically a general indicator of what the monster is made out of. Not to be confused with their element.
	rarity_score = 0 //Rarity score to add to this card.
	//1 or lower means common, 2 means uncommon, 3 means rare, 4 or higher means legendary.
	//Uncommon or higher rarities should be used sparringly, and only to cards that are super noteable.

/datum/battle_monsters/monster/human
	name = "Human"
	id = "human_male"
	icon_state = "human"
	power_add = BATTLE_MONSTERS_POWER_PETTY
	defense_add = 1
	attack_add = 1
	description = "a typical male %SPECIES inhabitant of Great Kingdom of Garoosh. While not a trained fighter, all %SPECIESs are quick thinkers and know how to fight when it matters with their %WEAPON_AND."
	special_effects = ""
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_HUMAN
	rarity = BATTLE_MONSTERS_RARITY_COMMON
	rarity_score = -1

/datum/battle_monsters/monster/human/female
	name = "Human"
	id = "human_female"
	icon_state = "human"
	power_add = BATTLE_MONSTERS_POWER_PETTY
	defense_add = 1
	attack_add = 0.75
	description = "a typical female %SPECIES inhabitant of Great Kingdom of Garoosh. While not a trained fighter, all %SPECIESs are quick thinkers and know how to fight when it matters with their %WEAPON_AND."
	special_effects = ""
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_HUMAN
	rarity = BATTLE_MONSTERS_RARITY_COMMON
	rarity_score = -1
/datum/battle_monsters/monster/human/mage
	name = "Apprentice Mage"
	id = "mage"
	icon_state = "staff"
	power_add = BATTLE_MONSTERS_POWER_LESSER
	defense_add = 1
	attack_add = 3
	description = "a young and eager-looking male %SPECIES mage from the mysterious and secluded Gautem Islands. They appear to be reading from a book, while their %WEAPON_AND hovers around them."
	special_effects = "Tutor: %NAME temporarily gains <b>250</b> bonus attack points if a visible spellcaster with more attack points than %NAME is on your side of the field."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 0

/datum/battle_monsters/monster/human/sage
	name = "Wise Sage"
	id = "sage"
	icon_state = "staff"
	power_add = BATTLE_MONSTERS_POWER_LESSER
	defense_add = 1
	attack_add = 2
	description = "an mysterious looking male %SPECIES, dressed in %ELEMENT_AND robes. A %WEAPON_AND seems to be holstered on their back, with a magic crystal ball hovering above their hands."
	special_effects = "Elemental Defense: %NAME temporarily gains <b>500</b> bonus defense points when defending against another %ELEMENT_OR type monster."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 0

/datum/battle_monsters/monster/human/wizard
	name = "Wizard"
	id = "wizard"
	icon_state = "staff"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 1
	attack_add = 2
	description = "an elderly, long-bearded male %SPECIES, dressed in typical wizard garb. They hold a %WEAPON_AND proudly, and their beard humorously tangles around it."
	special_effects = "Elemental Spell Immune: %NAME is immune to %ELEMENT_AND based spell cards."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

datum/battle_monsters/monster/human/warrior
	name = "Barbarian"
	id = "warrior"
	icon_state = "human"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 2
	attack_add = 1
	description = "a seductively buff male %SPECIES barbarian wearing a simple fur loincloth and a chest full of hair. They seem to be in possession of a %WEAPON_AND."
	special_effects = "%SPECIES_C Kinship: %NAME gains <b>300</b> attack points if there is another visible %SPECIES on the same side of the field."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 0

/datum/battle_monsters/monster/human/amazon_warrior
	name = "Amazon Warrior"
	id = "amazon_warrior"
	icon_state = "human"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 2
	attack_add = 1
	description = "a scantily clad male %SPECIES %NAME dressed in leopard skin. They proudly wield a giant %WEAPON_AND."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLUB
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 0

/datum/battle_monsters/monster/human/amazon_prime
	name = "Amazon Prime"
	id = "amazon_prime"
	icon_state = "human"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 2
	attack_add = 1
	description = "a scantily clad female %SPECIES %NAME dressed in leopard skin. They're one of the many queen guards of the Amazonian Kingdom."
	special_effects = "Free Shipping: A trap or spell card can be played from the card owner's hand during their opponent's turn, as long as %NAME is visible."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLUB
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/monster/human/knight
	name = "Knight"
	id = "knight"
	icon_state = "human_knight"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 4
	attack_add = 1
	rarity = 0.25
	description = "a proud male %SPECIES %NAME dorned in heavy %ELEMENT_AND armor and wielding a decorative %WEAPON_AND. They're sworn to protect the Great Kingdom of Garoosh from Barbarians."
	special_effects = "%SPECIES_C Protection: As long as %NAME is visible, all other %SPECIES monsters are attack immune."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 0

/datum/battle_monsters/monster/human/king
	name = "King"
	id = "king"
	icon_state = "king"
	power_add = BATTLE_MONSTERS_POWER_GREATER
	defense_add = 1
	attack_add = 10
	description = "a fat %SPECIES King sitting atop a %ELEMENT_AND throne, with a %WEAPON_AND spread out across a gold chessboard. Their equally golden crown is quite large for their small head."
	special_effects = "Selfish Protection: %NAME cannot be attacked if other monsters exist on the same side of the field."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_ARMY
	rarity = BATTLE_MONSTERS_RARITY_MYTHICAL
	rarity_score = 1

/datum/battle_monsters/monster/human/queen
	name = "Queen"
	id = "queen"
	icon_state = "king"
	power_add = BATTLE_MONSTERS_POWER_GREATER
	defense_add = 1
	attack_add = 5
	description = "an incredibly voluptuous %SPECIES female adorned in a %ELEMENT_AND robe. An equally tight-fitting crown sits atop her head."
	special_effects = "Lustful Aurora: %NAME cannot be attacked by %SPECIES monsters."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_ARMY
	rarity = BATTLE_MONSTERS_RARITY_MYTHICAL
	rarity_score = 1

/datum/battle_monsters/monster/dragon
	name = "Dragon"
	id = "dragon"
	icon_state = "dragon"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 2
	attack_add = 1
	description = "an adult male %SPECIES wielding %WEAPON_AND in each hand. %NAME such as these commonly inhabit the snowy mountains of the North."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_FERALDRAGON
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/monster/dragon_giant
	name = "Giant Dragon"
	id = "dragon_giant"
	icon_state = "dragon"
	power_add = BATTLE_MONSTERS_POWER_GREATER
	defense_add = 4
	attack_add = 1
	description = "an incredibly rare female %SPECIES of the %ELEMENT_AND vairety. Female %NAME are exceptionally rare among %SPECIESs, as they usually only show themselves every 1000 years."
	special_effects = "Sweeping Strike: %NAME can attack up to two targets per turn as long as the combined defense points of both targets does not exceed <b>1000</b>."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GIANT_DRAGON
	rarity = BATTLE_MONSTERS_RARITY_MYTHICAL
	rarity_score = 2

/datum/battle_monsters/monster/dragon/hybrid
	name = "Dragoness"
	id = "dragon_hybrid"
	icon_state = "dragon"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 2
	attack_add = 1
	description = "an unrealsticly busty feminine shaped %SPECIES. When not using their mammaries to confuse scientists, %NAME usually stalks careless human climbers for a quick and easy meal using their deadly %WEAPON_AND."
	special_effects = "Lustful Aurora: %NAME cannot be attacked by %SPECIES monsters."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_DRAGONHYBRID
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/monster/dragon/drake
	name = "Drake"
	id = "drake"
	icon_state = "dragon"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 4
	attack_mul = 0.25
	elements = BATTLE_MONSTERS_ELEMENT_FIRE
	description = "a skinny dark-scaled male %SPECIES bard warrior that prefers to rhyme than to attack with their %WEAPON_AND."
	special_effects = "Hotline Bling: All %ELEMENT_OR element monsters receive an additional <b>200</b> attack points."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_DRAGONHYBRID
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/monster/giant
	name = "Giant"
	id = "giant"
	icon_state = "giant"
	power_add = BATTLE_MONSTERS_POWER_COMMON
	defense_add = 1
	attack_add = 1
	description = "a hulking, unintellgent bipedal %SPECIES that can commonly be seen roaming the hillside searching for horses to herd and eat. It is theorized that %NAME are failed biological experiments of wizards from an older age."
	special_effects = "Crush: %NAME can send 1 creature type to the graveyard when summoned."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GIANT
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLUB
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/monster/lizard
	name = "Lizardman"
	id = "lizardman"
	icon_state = "lizard"
	power_add = BATTLE_MONSTERS_POWER_PETTY
	defense_add = 1
	attack_add = 1.5
	description = "a well-built muscled bipedal male %SPECIES citizen of the marshes of Ka'best. %NAME enjoy hunting for sport, and do so proudly with their %WEAPON_AND."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_LIZARDMAN
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS | BATTLE_MONSTERS_ATTACKTYPE_CLUB
	rarity = BATTLE_MONSTERS_RARITY_COMMON
	rarity_score = 0

/datum/battle_monsters/monster/lizard/female
	name = "Lizardwoman"
	id = "lizardwoman"
	attack_add = 1.75
	description = "a well-built muscled bipedal female %SPECIES citizen of the marshes of Ka'best. %NAME enjoy hunting for sport, and do so proudly with their %WEAPON_AND."

/datum/battle_monsters/monster/catbeast
	name = "Catbeast"
	id = "catman"
	icon_state = "cat"
	power_add = BATTLE_MONSTERS_POWER_PETTY
	defense_add = 1
	attack_add = 1.5
	description = "a furred bipedal male %SPECIES citizen of the plains of Old Jargo. %NAME ocassionally hunt small creatures with their %WEAPON_AND."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_CATMAN
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS | BATTLE_MONSTERS_ATTACKTYPE_TEETH
	rarity = BATTLE_MONSTERS_RARITY_COMMON
	rarity_score = 0

/datum/battle_monsters/monster/catbeast/female
	name = "Catbeastess"
	id = "catwoman"
	description = "a furred bipedal female %SPECIES citizen of the plains of Old Jargo. %NAME ocassionally hunt small creatures with their %WEAPON_AND."

/datum/battle_monsters/monster/antman
	name = "Ant Patron"
	id = "antman"
	icon_state = "ant"
	power_add = BATTLE_MONSTERS_POWER_LESSER
	defense_add = 1
	attack_add = 1.50
	description = "a quadruped chitin male %SPECIES citizen of the hills of Kalakest. Despite being a peaceful race, %NAME can be seen wielding %WEAPON_AND to defend their nests from foolish raiders looking to steal from their valuable eggs."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_ANTMAN
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS | BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity = BATTLE_MONSTERS_RARITY_COMMON
	rarity_score = 0

/datum/battle_monsters/monster/antman/female
	name = "Ant Matron"
	id = "antwoman"
	icon_state = "ant"
	power_add = BATTLE_MONSTERS_POWER_LESSER
	defense_add = 1.50
	attack_add = 1
	description = "a quadruped chitin female %SPECIES citizen of the hills of Kalakest. Despite being a peaceful race, %NAME can be seen wielding %WEAPON_AND to defend their nests from foolish raiders looking to steal from their valuable eggs. The females make excellent defenders because of this."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS | BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN | BATTLE_MONSTERS_ATTACKTYPE_SHIELD
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 1