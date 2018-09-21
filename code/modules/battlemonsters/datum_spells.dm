/datum/battle_monsters/spell
	name = "oh no" //The name of the spell
	id = "spell_error"
	icon_state = "magic"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL //Their general element.
	rarity = 0 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	description = "%THEYRE neutral." //Description to add.
	special_effects = "" //The special effects this element has, if any.
	rarity_score = 0 //Rarity score to add to this card.

/datum/battle_monsters/spell/destroy_trap
	name = "Creature's Revenge"
	id = "destroy_trap"
	icon_state = "pit"
	elements = BATTLE_MONSTERS_ELEMENT_EARTH
	rarity = 1
	description = "a wolf grinning slying as a hunter falls head first into a pit of spikes. Gruesome."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: The chosen trap card is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

/datum/battle_monsters/spell/destroy_spell
	name = "Fireball Accident"
	id = "destroy_spell"
	icon_state = "wood_fire"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE
	rarity = 1
	description = "an apprentice casting a fireball, and accidentally hitting a bunch of important spell tomes, as the dismay of the nearby wizard."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: The chosen spell card is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

/datum/battle_monsters/spell/destroy_monster
	name = "Smite"
	id = "destroy_monster"
	icon_state = "from_above"
	elements = BATTLE_MONSTERS_ELEMENT_LIGHT | BATTLE_MONSTERS_ELEMENT_DARK
	rarity = 1
	description = "an incredibly angry bearded god pointing savagely at a very confused human villager."
	special_effects = "TRIGGER: When activated. Single use.<br>EFFECT: The chosen monster is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

/datum/battle_monsters/spell/destroy_facedown
	name = "Guard's Stone Bludgeon"
	id = "destroy_facedown"
	icon_state = "stick"
	elements = BATTLE_MONSTERS_ELEMENT_STONE
	rarity = 1
	description = "a violet king's guard blugenoning an unknown assassin-like figure in the shadow."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: The chosen face down card is revealed and sent to the graveyard."
	tip = "Beware that any cards with a reveal acitvation will be triggered when this card is revealed."
	rarity_score = 1

/datum/battle_monsters/spell/draw3
	name = "Aces in the Boot"
	id = "draw3"
	icon_state = "boot"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = "a guard playing some card game with his fellow men in the barracks. You can see them reaching down to their boot, where three aces hide."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Draw 3 cards."
	rarity_score = 1

/datum/battle_monsters/spell/draw6
	name = "Card of Sharing"
	id = "draw6"
	icon_state = "gay"
	elements = BATTLE_MONSTERS_ELEMENT_LIGHT
	rarity = 1
	description = "rainbows, ponies, flowers, and cudly teddy bears. In other words, a world of filthy communism."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Each player draws until they are holding 6 cards."
	rarity_score = 1

/datum/battle_monsters/spell/restore1
	name = "Potion of Restore Health"
	id = "restore1"
	icon_state = "potion_red"
	elements = BATTLE_MONSTERS_ELEMENT_LIGHT
	rarity = 1
	description = "a shiny glass potion, filled to the brim with glowing red liquid."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Restore health by 1 point, if under 5."
	rarity_score = 1

/datum/battle_monsters/spell/damage1
	name = "Potion of Damage Health"
	id = "damage1"
	icon_state = "potion_blue"
	elements = BATTLE_MONSTERS_ELEMENT_DARK
	rarity = 1
	description = "a shiny glass potion, filled to the brim with glowing blue liquid."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Damage the opponent's health by one point, if over 1,."
	rarity_score = 1

/datum/battle_monsters/spell/polymerization
	name = "Fuse"
	id = "fuse"
	icon_state = "swap"
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY
	rarity = 1
	description = "two monsters chasing eachother, eventually becoming one giant blur."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Fuse the special effects of two monsters together, and reveal both cards. Fused monsters cannot attack on the turn they are fused."
	rarity_score = 1

/datum/battle_monsters/spell/darkness
	name = "Summon Darkness"
	id = "narsie"
	icon_state = "narsie"
	elements = BATTLE_MONSTERS_ELEMENT_DARK
	rarity = 1
	description = "some strange and otherwordly being."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: The summoner draws 1 chosen dark element monster to the field from their graveyard or supply deck, and then shuffles the chosen deck."
	rarity_score = 1

/datum/battle_monsters/spell/prank
	name = "Clown Prank"
	id = "prank"
	icon_state = "clown"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = "an incredibly overjoyed clown. Honk."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: If the opponent has more cards on the field than in their hand, the opponent must discard their entire hand."
	rarity_score = 1
