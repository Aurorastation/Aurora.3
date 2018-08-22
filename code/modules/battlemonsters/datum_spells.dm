datum/battle_monsters/spell
	name = "oh no" //The name of the spell
	id = "spell_error"
	icon_state = "magic"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL //Their general element.
	rarity = 0 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	description = "%THEYRE neutral." //Description to add.
	special_effects = "" //The special effects this element has, if any.
	rarity_score = 0 //Rarity score to add to this card.

datum/battle_monsters/spell/destroy_trap
	name = "Destroy Trap"
	id = "destroy_trap"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: The chosen trap card is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

datum/battle_monsters/spell/destroy_spell
	name = "Destroy Spell"
	id = "destroy_spell"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: The chosen spell card is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

datum/battle_monsters/spell/destroy_monster
	name = "Destroy Monster"
	id = "destroy_monster"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When activated. Single use.<br>EFFECT: The chosen monster is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

datum/battle_monsters/spell/destroy_monster
	name = "Destroy Facedown"
	id = "destroy_facedown"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: The chosen face down card is revealed and sent to the graveyard."
	tip = "Beware that any cards with a reveal acitvation will be triggered when this card is revealed."
	rarity_score = 1

datum/battle_monsters/spell/draw3
	name = "Draw 3"
	id = "draw3"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Draw 3 cards."
	rarity_score = 1

datum/battle_monsters/spell/draw6
	name = "Draw 6"
	id = "draw6"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 2
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Each player draws until they are holding 6 cards."
	rarity_score = 0.5

datum/battle_monsters/spell/restore1
	name = "Restore 1"
	id = "restore1"
	icon_state = "potion_red"
	elements = BATTLE_MONSTERS_ELEMENT_LIGHT
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Restore health by 1 point, if under 5."
	rarity_score = 0.5

datum/battle_monsters/spell/damage1
	name = "Damage 1"
	id = "damage1"
	icon_state = "potion_blue"
	elements = BATTLE_MONSTERS_ELEMENT_DARK
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Damage the opponent's health by one point, if over 1,."
	rarity_score = 0.5

datum/battle_monsters/spell/polymerization
	name = "Fuse"
	id = "fuse"
	icon_state = "swap"
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: Fuse the special effects of two monsters together, and reveal both cards. Fused monsters cannot attack on the turn they are fused."
	rarity_score = 1



