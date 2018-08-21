datum/battle_monsters/spell
	name = "oh no" //The name of the spell
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL //Their general element.
	rarity = 0 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	description = "%THEYRE neutral." //Description to add.
	special_effects = "" //The special effects this element has, if any.
	rarity_score = 0 //Rarity score to add to this card.

datum/battle_monsters/spell/destroy_spell
	name = "Destroy Trap"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When activated. Single use.<br>EFFECT: The chosen trap card is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

datum/battle_monsters/spell/destroy_spell
	name = "Destroy Spell"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When activated. Single use.<br>EFFECT: The chosen spell card is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

datum/battle_monsters/spell/destroy_monster
	name = "Destroy Monster"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When activated. Single use.<br>EFFECT: The chosen monster is sent to the graveyard."
	tip = "Can be used on facedown cards with an unknown card type. However, if you get the card type wrong, then the spell is wasted."
	rarity_score = 1

datum/battle_monsters/spell/destroy_monster
	name = "Destroy Facedown"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When activated. Single use.<br>EFFECT: The chosen face down card is revealed and sent to the graveyard."
	tip = "Beware that any cards with a reveal acitvation will be triggered when this card is revealed."
	rarity_score = 1