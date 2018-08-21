//General Rules for special effects:
//Fire: Teamwork.
//Energy: Can attack on the first turn or do things during the opponent's turn.
//Water: After attack.
//Defense: Benifits when defending.

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

datum/battle_monsters/element/trap //Indicator for trap cards.
	name = ""
	id = "trap"
	icon_state = "trap"
	elements = BATTLE_MONSTERS_ELEMENT_NONE
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
	special_effects = "Element Spell Immune: %NAME is immune to all %ELEMENT_OR based spell and trap cards if another fire element monster is in play."
	power_add = 100
	rarity = 0.25

datum/battle_monsters/element/fire/molten
	name = "Molten"
	id = "molten"
	description = "Liquid %ELEMENT_AND drips from their eyes and %WEAPON_AND."
	special_effects = "Element Monster Immune: %NAME is immune to all %ELEMENT_OR based monster attacks if another fire element monster is in play."
	tip = "%NAME can still be attacked, however the attacker's special effects will be nullified and the attack will be considered a draw if %NAME lost battle calculation."
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
	description = "Visible scorch marks and bandages appear all over their body from centuries of using %ELEMENT_AND. This %SPECIES is clearly a veteran of using the magical arts."
	special_effects = "Battle Reminder: If a %ELEMENT_OR type monster is sent to a graveyard, the card's owner can choose to reveal and send one fire based monster from the owner's hand to the graveyard in it's place."
	power_add = 500
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/fire/scorching_blade
	name = "Scorching Blade"
	id = "scorching_blade"
	icon_state = "scorching_blade"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_STONE
	description = "A giant, %ELEMENT_AND katana adorns their hip. The blade itself looks extremely unstable and pulsates with strange magic every now and then."
	special_effects = "Revenge: If %NAME is sent to a graveyard, the card's owner can choose to send one non-%ELEMENTS_OR based monster on the field to the graveyard as well."
	tip = "If you know what you're doing, you can also send one of your own monsters to the graveyard with it."
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
	tip = "%NAME can still be affected by traps or spells."
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
	special_effects = "Charge: %NAME can attack as soon as it's played."
	tip = "Remember that 'played' is not the same as 'revealed', a card is considered 'played' when it's put into the field from the owner's hand."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GOD
	power_mul = 0.75
	rarity = 0.1

datum/battle_monsters/element/energy/powered
	name = "Cybernetic"
	id = "powered"
	icon_state = "powered"
	description = "Upon closer examination, it seems that they have advanced cybernetics."
	special_effects = "Null Field: When %NAME is in play, all the opponent's special effects, besides 'Null Field', are nullified during the opponent's turn."
	rarity = 0.1
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_MACHINE

datum/battle_monsters/element/energy/dragonslayer
	name = "Dragonslayer"
	id = "dragonslayer"
	icon_state = "dragonslayer"
	description = "They're wearing a dragonscale cape, and dragon skull shoulderpads."
	special_effects = "Dragonslayer: When %NAME is summoned, the card's owner can choose to send a dragon to the graveyard as long as the dragon's attack points does not exceed <2000>."
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/energy/dragoncult
	name = "Dragoncult"
	id = "dragoncult"
	icon_state = "dragoncult"
	description = "They're painted with various symbols belonging to the secretive Dragoncult, an ancient organization that serves the dragons."
	special_effects = "Dragon Protection: As long as %NAME is on the field, all allied Dragons are immune to spells."
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY | BATTLE_MONSTERS_ELEMENT_FIRE
	rarity = 0.5
	rarity_score = 1

datum/battle_monsters/element/water
	name = "Water"
	id = "water"
	icon_state = "water"
	description = "Their %WEAPON_AND is coated with magical water."
	elements = BATTLE_MONSTERS_ELEMENT_WATER
	rarity = 4

datum/battle_monsters/element/water/morphing
	name = "Morphling"
	id = "morphling"
	description = "Upon closer examination, it appears that they can morph into various shapes using the magic of %ELEMENT_AND."
	special_effects = "Morph: %NAME is switched to defense mode if they attack, and switched to attack mode if they succesfully defend from an attack."
	rarity = 0.25

datum/battle_monsters/element/water/raincloud
	name = "Rain"
	id = "rain"
	description = "Depressing rainclouds hover above them."
	special_effects = "Dark Rainclouds: %NAME is immune to all non %ELEMENT_OR based trap and spell cards as long as %NAME attacked on the owner's previous turn."
	power_mul = 0.75
	attack_add = 0.5
	rarity = 0.25
	rarity_score = 1

datum/battle_monsters/element/water/lakeside
	name = "Trench Pirate"
	id = "trench_pirate"
	description = "They're covered entirely with seaweed and barnacles."
	special_effects = "Cheating Tides: %NAME cannot be attack or be attacked by non %ELEMENT based monster cards as long as %NAME attacked on the owner's previous turn."
	elements = BATTLE_MONSTERS_ELEMENT_WATER | BATTLE_MONSTERS_ELEMENT_DARK
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/ice
	name = "Ice"
	id = "ice"
	icon_state = "ice"
	description = "They seem well equipped to deal with the harsh, icy weather on the Plains of Narbask."
	elements = BATTLE_MONSTERS_ELEMENT_ICE
	defense_add = 1
	rarity = 4

datum/battle_monsters/element/ice/defender
	name = "Igloo Defending"
	id = "igloo"
	description = "Behind them is a giant igloo."
	special_effects = "Master Defender: As long as %NAME is on the field, it's owner cannot be attacked by monsters. "
	rarity = 0.5

datum/battle_monsters/element/ice/yeti
	name = "Yeti"
	id = "yeti"
	description = "They're covered head to toe in white, absorbant magical fur."
	special_effects = "Spell Absorbtion: As long as %NAME is on the field, it's owner cannot be affected by traps or spells."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_CREATURE
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	power_add = 200
	rarity = 0.1
	rarity_score = 1

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

datum/battle_monsters/element/stone/uranium
	name = "Uranium"
	id = "uranium"
	description = "They're made out of pure uranium."
	special_effects = "EMP: If an Iron prefixed monster exists on the field when this card is played, send this card and all energy-based monsters on the field to the graveyard."
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/stone/iron
	name = "Iron"
	id = "iron"
	description = "They're made out of dense iron."
	special_effects = "EMP: If an Uranium prefixed monster exists on the field when this card is played, send this card and all energy-based monsters on the field to the graveyard."
	rarity = 0.1
	rarity_score = 1

datum/battle_monsters/element/stone/potassium
	name = "Potassium"
	id = "potassium"
	description = "They're made entirely out of bananas, for some reason."
	special_effects = "Explosion: If an water element monster exists on the field when this card is played, send this card and all monsters with under <1000> defense points on the field to the graveyard."
	rarity = 0.05
	rarity_score = 2

datum/battle_monsters/element/dark
	name = "Dark"
	id = "dark"
	icon_state = "dark"
	description = "A strange evil, shadowy aura embraces them and all those around it."
	elements = BATTLE_MONSTERS_ELEMENT_DARK
	power_add = 500
	rarity = 0.25
	rarity_score = 1

datum/battle_monsters/element/dark/vampire
	name = "Vampire"
	id = "vampire"
	description = "They're incredibly pale and have two large snake-like fangs."
	special_effects = "Leech: If %NAME attacks the opponent, the owner of the card gains 1 lifepoint as long as the owner's lifepoints are less than 5."
	rarity = 0.1
	rarity_score = 2

datum/battle_monsters/element/dark/cultist
	name = "Cultist"
	id = "cultist"
	description = "They're wearing dark, mysterious robes."
	special_effects = "Summoning: If 6 monsters with a cultist prefix exist on your side of the field at once when %NAME is played or revealed, you win the game."
	rarity = 0.1
	rarity_score = 2

datum/battle_monsters/element/dark/demon
	name = "Demon"
	id = "demon"
	description = "They have the head of a goat and hooved feet, with a menacing reptilian tail growing above their behind."
	special_effects = "Sacrifice: %NAME can sacrifice a non-light element type monster on the same side of the field to attack again."
	rarity = 0.1
	rarity_score = 2

datum/battle_monsters/element/dark/devil
	name = "Devil"
	id = "devil"
	description = "Two boned horns sprout out of their forehead."
	special_effects = "Bargain: When %NAME is played, the card's owner can choose to sacrifice 2 of their lifepoints to remove 1 lifepoint from their opponent."
	rarity = 0.1
	rarity_score = 2

datum/battle_monsters/element/dark/unholy
	name = "Unholy"
	id = "unholy"
	description = "A dark, unholy aura shrouds their true shape and figure."
	special_effects = "Unholy Barrier: As long as %NAME is in play, all monsters and players are immune to light element spells, traps, and special effects."
	rarity = 0.1
	rarity_score = 2

datum/battle_monsters/element/light
	name = "Light"
	id = "light"
	icon_state = "light"
	description = "A holy aura shapes around their beauty."
	elements = BATTLE_MONSTERS_ELEMENT_LIGHT
	power_add = 500
	rarity = 0.25
	rarity_score = 1

datum/battle_monsters/element/light/angel
	name = "Guardian Angel"
	id = "angel"
	description = "A halo floats above them, and feathery white wings sprout from their back."
	special_effects = "Sacrifice: If a friendly monster loses a battle, %NAME can be sent to the graveyard instead."
	rarity = 0.1
	rarity_score = 2

datum/battle_monsters/element/light/undying
	name = "Undying"
	id = "undying"
	description = "Various scars are scattered across their body. Each scar seems to glow distinctly with holy energy."
	special_effects = "Reborn: If %NAME is defeated in battle, go to the original owner's hand instead of the graveyard."
	rarity = 0.1
	rarity_score = 2

datum/battle_monsters/element/light/holy
	name = "Holy"
	id = "holy"
	description = "Their body seems to have an angelic glow."
	special_effects = "Holy Barrier: As long as %NAME is in play, all monsters and players are immune to dark element spells, traps, and special effects."
	rarity = 0.1
	rarity_score = 2