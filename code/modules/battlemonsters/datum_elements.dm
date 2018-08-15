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

datum/battle_monsters/element/none
	name = ""
	id = "no_element"
	icon_state = "no_element"
	elements = BATTLE_MONSTERS_ELEMENT_NEUTRAL
	description = ""
	rarity = 5
	rarity_score = -1

datum/battle_monsters/element/fire
	name = "Firebrand"
	id = "fire"
	icon_state = "fire"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE
	attack_add = 0.25
	description = "Great balls of %ELEMENT_AND circles around them and their %WEAPON_AND."
	rarity = 4

datum/battle_monsters/element/fire/lava
	name = "Fireborn"
	id = "lava"
	description = "These types of %SPECIES are born from of the magic %ELEMENT_AND of dark wizards and witches."
	special_effects = "Element Monster Immune: %NAME is immune to all %ELEMENT_OR based monster attacks."
	power_add = 100
	rarity = 0.25

datum/battle_monsters/element/fire/molten
	name = "Molten"
	id = "molten"
	description = "Liquid %ELEMENT_AND drips from their eyes and %WEAPON_AND."
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
	description = "They are covered entirely with dark burning wax, a telltale sign of the unholy Candle Wax Cult."
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
	description = "Visible scorch marks and bandages appear all over their body from centuries of using %ELEMENT_AND. This %SPECIES is clearly a veteran of using the magical arts.."
	power_add = 500
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/fire/scorching_blade
	name = "Scorching Blade"
	id = "scorching_blade"
	icon_state = "scorching_blade"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_STONE
	description = "A giant, %ELEMENT_AND katana adorns their hip. The blade itself looks extremely unstable and pulsates with strange magic every now and then."
	special_effects = "If %NAME is sent to the graveyard, it can choose to send one non-%ELEMENTS_OR based monster to the graveyard."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/fire/burning_sun_god
	name = "Burning Sun God"
	id = "burning_sun_god"
	icon_state = "burning_sun_god"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_LIGHT
	description = "Upon closer examination, various %ELEMENT_AND symbols are etched across their body, and a slightly visible shadow of The Burning Sun God Ra'Kan is cast behind them. It's clear that the god is using this %SPECIES as a vessel for it's bidding."
	special_effects = "Godly Protection: %ELEMENT_OR monsters cannot attack or be attacked by %NAME."
	power_add = 2000
	rarity = 0.01
	rarity_score = 3

datum/battle_monsters/element/energy
	name = "Lighting Controller"
	id = "energy"
	icon_state = "energy"
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY
	attack_add = 0.25
	description = "Magical lighting flickers in the background, each strike hitting their %WEAPON_AND with %ELEMENT_AND."
	rarity = 4

datum/battle_monsters/element/energy/thunder
	name = "Thunderchild"
	id = "thunder"
	icon_state = "energy"
	power_add = 500
	attack_add = 0.25
	description = "A symbol on their forehead indicates that they are a %SPECIES thunderchild, born of the incredibly horny god Bleus after coitus with a %SPECIES."
	special_effects = "Overprotective Father: %NAME is immune to spells, traps, and attacks by gods as long as there is another God on the field."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GOD
	power_mul = 0.75
	rarity = 0.1

datum/battle_monsters/element/energy/powered
	name = "Cybernetic"
	id = "powered"
	icon_state = "powered"
	description = "Upon closer examination, it seems that they have advanced cybernetics."
	special_effects = "Energy Source: %NAME gains an additional <b>100</b> attack points for every energy-based monster on the same side of the field."
	rarity = 0.25
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_MACHINE

datum/battle_monsters/element/energy/dragonslayer
	name = "Dragonslayer"
	id = "dragonslayer"
	icon_state = "dragonslayer"
	description = "They're wearing a dragonscale cape, and dragon skull shoulderpads."
	special_effects = "Dragonslayer: Upon summoning, %NAME can choose to send a dragon to the graveyard as long as the dragon's attack points does not exceed <2000>."
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/energy/dragoncult
	name = "Dragoncult"
	id = "dragoncult"
	icon_state = "dragoncult"
	description = "They're painted with various symbols belonging to the secretive Dragoncult, an ancient organization that serves the dragons."
	special_effects = "Dragon Protection: As long as %NAME is on the field, all allied Dragons are immune to spells."
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY | BATTLE_MONSTERS_ELEMENT_DARK
	rarity = 0.5
	rarity_score = 1

datum/battle_monsters/element/water
	name = "Morphing"
	id = "water"
	icon_state = "water"
	description = "Upon closer examination, it appears that they can morph into various shapes using the magic of %ELEMENT_AND."
	special_effects = "Morph: %NAME is allowed to switch to defense mode after they attack."
	elements = BATTLE_MONSTERS_ELEMENT_WATER
	rarity = 2

datum/battle_monsters/element/ice
	name = "Ice"
	id = "ice"
	icon_state = "ice"
	description = "They seem well equipped to deal with the harsh, icy weather on the Plains of Narbask."
	elements = BATTLE_MONSTERS_ELEMENT_ICE
	rarity = 2

datum/battle_monsters/element/earth
	name = "Earth"
	id = "earth"
	icon_state = "earth"
	description = "Earthen roots shift around them with small flowers budding from it's branches, signifying a oneness with nature."
	elements = BATTLE_MONSTERS_ELEMENT_EARTH
	rarity = 2

datum/battle_monsters/element/stone
	name = "Stone"
	id = "stone"
	icon_state = "stone"
	description = "They're rock hard. Made out of rock, that is."
	elements = BATTLE_MONSTERS_ELEMENT_STONE
	rarity = 2

datum/battle_monsters/element/dark
	name = "Dark"
	id = "dark"
	icon_state = "dark"
	description = "A strange evil, shadowy aura embraces them and all those around it."
	elements = BATTLE_MONSTERS_ELEMENT_DARK
	rarity = 0.5
	rarity_score = 1

datum/battle_monsters/element/light
	name = "Light"
	id = "light"
	icon_state = "light"
	description = "A holy aura shapes around their beauty."
	elements = BATTLE_MONSTERS_ELEMENT_LIGHT
	rarity = 0.5
	rarity_score = 1