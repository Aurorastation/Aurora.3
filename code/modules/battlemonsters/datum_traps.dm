//Super secret trap porn file
//Don't kinkshame

datum/battle_monsters/trap
	name = "oh no" //The name of the trap
	id = "trap_error"
	icon_state = "stop"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL //Their general element.
	rarity = 0 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	description = "%THEYRE neutral." //Description to add.
	special_effects = "" //The special effects this element has, if any.
	rarity_score = 0 //Rarity score to add to this card.

datum/battle_monsters/trap/block_spell
	name = "Block Spell"
	id = "block_spell"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 5
	description = ""
	special_effects = "TRIGGER: When the opponent plays a spell card. Single use.<br>EFFECT: The spell card played has its effect nullified and sent to the graveyard."
	rarity_score = 0

datum/battle_monsters/trap/block_trap
	name = "Block Trap"
	id = "block_trap"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 5
	description = ""
	special_effects = "TRIGGER: When the opponent reveals a trap card. Single use.<br>EFFECT: The trap card revealed has its effect nullified and sent to the graveyard."
	rarity_score = 0

datum/battle_monsters/trap/block_attack
	name = "Block Attack"
	id = "block_attack"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 5
	description = ""
	special_effects = "TRIGGER: When the opponent attacks a monster. Single use.<br>EFFECT: The attack is nullified and the monster that attacked cannot attack for the rest of the turn."
	rarity_score = 0

datum/battle_monsters/trap/reflect_spell
	name = "Reflect Spell"
	id = "reflect_spell"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When the opponent plays a spell card. Single use.<br>EFFECT: The spell card's effect is instead applied to the chosen target, and sent to the graveyard."
	rarity_score = 0

datum/battle_monsters/trap/reflect_spell
	name = "Reflect Trap"
	id = "reflect_trap"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When the opponent reveals a trap card. Single use.<br>EFFECT: The trap card's effect is instead applied to the chosen target, and sent to the graveyard."
	rarity_score = 0

datum/battle_monsters/trap/reflect_attack
	name = "Reflect Attack"
	id = "reflect_attack"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = ""
	special_effects = "TRIGGER: When the opponent attacks a monster. Single use.<br>EFFECT: The attack is nullified and the monster that attacked is sent to the graveyard."
	rarity_score = 0


