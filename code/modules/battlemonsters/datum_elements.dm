datum/battle_monsters/element
	name = "neutral" //The name of the element
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL //Their general element.
	//Note, values are normalized at the end of generation.
	rarity = 1 //Relative rarity multiplier. Use for whether or not this card is picked for generation.
	description = "%THEYRE neutral." //Description to add.
	special_effects = "" //The special effects this element has, if any.
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The attack flags of the monster. This is basically a general indicator of the weapon it uses.
	defense_type = BATTLE_MONSTERS_ATTACKTYPE_NONE //The defense flags of the monster. This is basically a general indicator of what the monster is made out of. Not to be confused with their element.
	rarity_score = 0 //Rarity score to add to this card.
	//1 or lower means common, 2 means uncommon, 3 means rare, 4 or higher means legendary.
	//Uncommon or higher rarities should be used sparringly, and only to cards that are super noteable.


datum/battle_monsters/element/fire
	name = "Fire"
	id = "fire"
	icon_state = "fire"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE
	attack_add = 0.25
	description = "Their %WEAPON_AND is covered in flames."
	rarity = 4

datum/battle_monsters/element/fire/lava
	name = "Lava"
	id = "lava"
	description = "They seem to be made entirely out of %ELEMENT_AND."
	special_effects = "Element Monster Immune: %NAME is immune to all %ELEMENT_OR based monster attacks."
	power_add = 100
	rarity = 0.25

datum/battle_monsters/element/fire/molten
	name = "Molten"
	id = "molten"
	description = "They seem to be made entirely out of molten material."
	special_effects = "Element Monster Immune: %NAME is immune to all %ELEMENT_OR based monster attacks."
	power_add = 250
	defense_add = 0.25
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/fire/candle
	name = "Candle Wax"
	id = "wax"
	icon_state = "candle"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_DARK
	description = "They are covered entirely with burning wax, a telltale sign of the unholy Candle Wax Cult."
	special_effects = "Waxing Power: %NAME gains <b>100</b> attack points for every other %ELEMENT_OR type monster on your side of the field."
	power_add = 250
	defense_add = 0.25
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/fire/burned
	name = "Burned"
	id = "burned"
	icon_state = "burned"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_DARK
	description = "Visible scorch marks and bandages appear all over their body from centuries of using fire. This monster is clearly a veteran of a firey, perhaps hellish war."
	power_add = 500
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/fire/scorching_blade
	name = "Scorching Blade"
	id = "scorching_blade"
	icon_state = "scorching_blade"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_STONE
	description = "A giant, firey steel katana adorns their hip. The blade itself looks extremely unstable and pulsates every now and then."
	special_effects = "If %NAME is sent to the graveyard, it can choose to send one non-%ELEMENTS_OR based monster to the graveyard."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/fire/burning_sun_god
	name = "Burning Sun God"
	id = "burning_sun_god"
	icon_state = "burning_sun_god"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_CARD_GOD | BATTLE_MONSTERS_CARD_LIGHT
	description = "They are of the many lesser Burning Sun Gods of the Burning Sun holy sect. It easily towers over lesser humans. Their burning %WEAPON_AND is a symbol of their power."
	special_effects += "Godly Protection: %ELEMENTS_OR monsters cannot attack or be attacked by %NAME."
	power_add = 2000
	rarity = 0.01
	rarity_score = 3

datum/battle_monsters/element/energy
	name = "Lightning"
	id = "energy"
	icon_state = "energy"
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY
	attack_add = 0.25
	description = "Their %WEAPON_AND is covered in magical lightning."
	rarity = 4

datum/battle_monsters/element/energy/thunder
	name = "Thunderchild"
	id = "thunder"
	icon_state = "energy"
	attack_add = 0.25
	description = "Their %WEAPON is embroidered with strange symbols and lettering that glow with electrical energy."
	special_effects = "Quick Attack: %NAME can attack on the turn it's created."
	power_mul = 0.75
	rarity = 0.5

datum/battle_monsters/element/energy/powered
	name = "Powered"
	id = "powered"
	icon_state = "powered"
	description = "They appear to be augmented with unnatural metals and electical energy."
	special_effects = "Energy Source: %NAME gains an additional <b>100</b> attack points for every energy-based monster on the same side of the field."
	rarity = 0.25

datum/battle_monsters/element/energy/dragonslayer
	name = "Dragonslayer"
	id = "dragonslayer"
	icon_state = "dragonslayer"
	description = "They're wearing a dragonscale cape, and dragon skull shoulderpads."
	special_effects = "Dragonslayer: Upon summoning, %NAME can choose to send a dragon to the graveyard as long as the dragon's attack points does not exceed <2000>."
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/energy/dragonslayer
	name = "Dragoncult"
	id = "dragoncult"
	icon_state = "dragoncult"
	description = "They're wearing a dragonscale cape, and dragon skull shoulderpads."
	special_effects = "Dragonslayer: Upon summoning, %NAME can choose to send a dragon to the graveyard as long as the dragon's attack points does not exceed <2000>."
	rarity = 0.1
	rarity_score = 1