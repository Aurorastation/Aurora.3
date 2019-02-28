//Super secret trap porn file
//Don't kinkshame

/datum/battle_monsters/trap
	name = "oh no" //The name of the trap
	id = "trap_error"
	icon_state = "stop"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL //Their general element.
	rarity = 0 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	description = "%THEYRE neutral." //Description to add.
	special_effects = "" //The special effects this element has, if any.
	rarity_score = 1 //Rarity score to add to this card.

/datum/battle_monsters/trap/block_spell
	name = "Spellblock"
	id = "block_spell"
	icon_state = "block_spell"
	elements = BATTLE_MONSTERS_ELEMENT_ICE
	rarity = 1
	description = "a magical ice shield deflecting a red death beam."
	special_effects = "TRIGGER: When the opponent plays a spell card. Single use.<br>EFFECT: The spell card played has its effect nullified and sent to the graveyard."
	rarity_score = 1

/datum/battle_monsters/trap/block_trap
	name = "Reverse Trap"
	id = "block_trap"
	icon_state = "trap"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = "a feminine looking male tinkering with a bear trap. A sly expression rests on their face."
	special_effects = "TRIGGER: When the opponent reveals a trap card. Single use.<br>EFFECT: The trap card revealed has its effect nullified and sent to the graveyard."
	rarity_score = 1

/datum/battle_monsters/trap/block_attack
	name = "Stop Attack"
	id = "block_attack"
	elements = BATTLE_MONSTERS_ELEMENT_STONE
	icon_state = "stop"
	rarity = 1
	description = "a basic 'Do not enter' sign."
	special_effects = "TRIGGER: When the opponent attacks a monster. Single use.<br>EFFECT: The attack is nullified and the monster that attacked cannot attack for the rest of the turn."
	rarity_score = 1

/datum/battle_monsters/trap/reflect_spell
	name = "Reflect Spell"
	id = "reflect_spell"
	icon_state = "reflect_spell"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = "a red laser beam being reflected by a blue shield."
	special_effects = "TRIGGER: When the opponent plays a spell card. Single use.<br>EFFECT: The spell card's effect is instead applied to the chosen target, and sent to the graveyard."
	rarity_score = 1

/datum/battle_monsters/trap/slip
	name = "Banana Slip"
	id = "slip"
	icon_state = "banana"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	rarity = 1
	description = "a banana peel, and an unsuspecting foot about to step on it."
	special_effects = "TRIGGER: When revealed. Single use.<br>EFFECT: If the opponent draws a card, it is sent to the graveyard."
	rarity_score = 1