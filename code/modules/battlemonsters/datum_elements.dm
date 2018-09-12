//General Rules for special effects:
//Fire: Teamwork.
//Energy: Can attack on the first turn or do things during the opponent's turn.
//Water: After attack.
//Ice: Benifits when defending.
//Earth: Elements against the opponent.
//Stone: Alchemy Gimmick

/datum/battle_monsters/element
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

/datum/battle_monsters/element/fire
	name = "Firebrand"
	id = "fire"
	icon_state = "fire"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE
	attack_add = 0.25
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	description = "Great balls of %ELEMENT_AND circles around them and their %WEAPON_AND. Firebrands are vikings who hail from the North, who grew a dedication to mastering fire after countless harsh winters."
	rarity = BATTLE_MONSTERS_RARITY_COMMON

/datum/battle_monsters/element/fire/lava
	name = "Fireborn"
	id = "lava"
	icon_state = "fireborn"
	description = "They're covered head to toe in a firey blaze. These types of %SPECIESs are born from magic %ELEMENT_AND of dark wizards and witches. They make excellent spellcasters."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER
	special_effects = "Element Spell Immune: %NAME is immune to all %ELEMENT_OR based spell and trap cards if another revealed fire element monster is on the same side of the field."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/fire/molten
	name = "Molten"
	id = "molten"
	icon_state = "magma"
	description = "Liquid %ELEMENT_AND drips from their eyes and %WEAPON_AND. It is clear that %NAME came from the depths of below the earth."
	special_effects = "Element Monster Immune: %NAME is immune to all %ELEMENT_OR based monster attacks if another revealed fire element monster is on the same side of the field."
	tip = "%NAME can still be attacked, however the attacker's special effects will be nullified and the attack will be considered a draw if %NAME lost battle calculation."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	defense_add = 0.25
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/fire/candle
	name = "Candle Wax"
	id = "wax"
	icon_state = "candle"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_DARK
	description = "They are covered entirely with dark burning wax, a telltale sign of the unholy Candle Wax Cult."
	special_effects = "Waxing Power: %NAME passively gains <b>100</b> attack points for every other revealed %ELEMENT_OR type monster on your side of the field."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	defense_add = 0.25
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/fire/burned
	name = "Burned"
	id = "burned"
	icon_state = "burned"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_DARK
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SPELLCASTER
	description = "Visible scorch marks and bandages appear all over their body from centuries of using %ELEMENT_AND. This %SPECIES is clearly a veteran of using the magical arts."
	special_effects = "Battle Reminder: If a %ELEMENT_OR type monster is sent to a graveyard, the card's owner can choose to reveal and send one fire element monster from the owner's hand to the graveyard in it's place."
	tip = "The chosen monster card sent in the other person's place will have it's special effects triggered as if it was revealed on the field."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/fire/scorching_blade
	name = "Scorching Blade"
	id = "scorching_blade"
	icon_state = "scorching_blade"
	elements = BATTLE_MONSTERS_ELEMENT_FIRE | BATTLE_MONSTERS_ELEMENT_STONE
	description = "A giant, %ELEMENT_AND katana adorns their hip. The blade itself looks extremely unstable and pulsates with strange magic every now and then. Warriors of the east looking to improve their mastery of fire usually look to perform the Scorching Blade ritual."
	special_effects = "Revenge: If %NAME is sent to a graveyard, the card's owner can choose to send one non-%ELEMENT_OR based monster on the field to the graveyard as well."
	tip = "If you know what you're doing, you can also send one of your own monsters to the graveyard with it."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SWORDSMAN
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/fire/burning_sun_god
	name = "Burning Sun God"
	id = "burning_sun_god"
	icon_state = "burning_sun_god"
	description = "Upon closer examination, various %ELEMENT_AND symbols are etched across their body. A slightly visible shadow of The Burning Sun God Ra'Kan is cast behind them. It's clear that the god is using them as a vessel for it's bidding."
	special_effects = "Godly Protection: %ELEMENT_OR monsters cannot attack or be attacked by %NAME."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GOD
	tip = "%NAME can still be affected by traps or spells."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 5
	rarity = BATTLE_MONSTERS_RARITY_LEGENDARY
	rarity_score = 3

/datum/battle_monsters/element/energy
	name = "Energy"
	id = "energy"
	icon_state = "energy"
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY
	attack_add = 0.25
	description = "Magical lighting flickers in the background, each strike hitting their %WEAPON_AND with %ELEMENT_AND."
	rarity = BATTLE_MONSTERS_RARITY_COMMON

/datum/battle_monsters/element/energy/thunder
	name = "Thunderchild"
	id = "thunder"
	icon_state = "thunder"
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	attack_add = 1000
	description = "A symbol on their forehead indicates that they are a %SPECIES thunderchild, born of the incredibly horny god Bleus after coitus with a %SPECIES. Children born of Bleus tend to show a god-like control over energy elements, such as lightning."
	special_effects = "Charge: %NAME can attack as soon as it's revealed, regardless of other penalties. If Charge is used, %NAME is sent to the graveyard."
	tip = "Remember that 'played' is not the same as 'revealed', a card is considered 'played' when it's put into the field from the owner's hand."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GOD
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/energy/powered
	name = "Cybernetic"
	id = "powered"
	icon_state = "powered"
	description = "Upon closer examination, it seems that they have advanced cybernetics. It is unknown where these cybernetics came from, or when, for that matter."
	special_effects = "Null Field: When %NAME is visible, all the opponent's special effects are nullified during the opponent's turn."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	rarity = BATTLE_MONSTERS_RARITY_RARE
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_MACHINE
	rarity_score = 1

/datum/battle_monsters/element/energy/dragonslayer
	name = "Dragonslayer"
	id = "dragonslayer"
	icon_state = "dragonslayer"
	description = "They're wearing a dragonscale cape, and dragon skull shoulderpads. Dragonslayers can commonly be seen in the mountains hunting dragons for their prized bones and scales."
	special_effects = "Dragonslayer: When %NAME is summoned, the card's owner can choose to send a dragon to the graveyard as long as the dragon's attack points does not exceed %NAME's attack points."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/energy/dragoncult
	name = "Dragoncult"
	id = "dragoncult"
	icon_state = "dragoncult"
	description = "They're painted with various symbols belonging to the secretive Dragoncult, an ancient organization that serves the dragons."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	special_effects = "Dragon Protection: As long as %NAME is visible, all allied Dragons are immune to spells."
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY | BATTLE_MONSTERS_ELEMENT_FIRE
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/energy/dragongod
	name = "Dragon God"
	id = "dragon_god"
	icon_state = "dragon_god"
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GOD | BATTLE_MONSTERS_DEFENSETYPE_GIANT_DRAGON
	elements = BATTLE_MONSTERS_ELEMENT_ENERGY
	description = "Their %ELEMENT_AND wings are absolutely massive, and their massive snout exhales deadly %ELEMENT_AND. This being is a common god among dragons, and it is theorized that one of the many breeds of dragons came from %NAME."
	special_effects = "Godly Protection: %ELEMENT_OR monsters cannot attack or be attacked by %NAME.<br>Wingspan: When %NAME is summoned, all non-flying monsters on the field are sent to the graveyard."
	tip = "%NAME can still be affected by traps or spells.<br>%NAME can also send friendly units to the graveyard."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 5
	rarity = BATTLE_MONSTERS_RARITY_LEGENDARY
	rarity_score = 3

/datum/battle_monsters/element/water
	name = "Water"
	id = "water"
	icon_state = "water"
	description = "Their %WEAPON_AND is coated with magical shifting water."
	elements = BATTLE_MONSTERS_ELEMENT_WATER
	rarity = BATTLE_MONSTERS_RARITY_COMMON

/datum/battle_monsters/element/water/morphing
	name = "Morphling"
	id = "morphling"
	icon_state = "water2"
	description = "Upon closer examination, it appears that they can morph into various shapes using the magic of %ELEMENT_AND. Morphlings can common be seen near rivers, lakes, or streams harrassing travelers who dare to take a drink from the protected waters."
	special_effects = "Morph: %NAME is automatically switched to defense mode if they attack, and automatically switched to attack mode if they succesfully defend from an attack. %NAME cannot be switched to attack mode or defense mode manually."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/water/raincloud
	name = "Rain"
	id = "rain"
	icon_state = "raincloud"
	description = "Depressing rainclouds hover above them. Such rainclouds are usually caused by a curse given by witches for the penalty of being too sad."
	special_effects = "Dark Rainclouds: %NAME is immune to all non %ELEMENT_OR based trap and spell cards as long as %NAME attacked on the owner's previous turn."
	power_mul = 0.75
	attack_add = 0.5
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/water/trench_pirate
	name = "Trench"
	id = "trench_pirate"
	description = "They're covered entirely with seaweed and barnacles, with an eyepatch and a bandana complimenting their monsterous shape. Rumor has it that Trench beings were shipwrecked sailors whose bodies sunk into marine trenches into the hells below."
	special_effects = "Changing Tides: %NAME cannot be attack or be attacked by non %ELEMENT_OR based monster cards as long as %NAME attacked on the owner's previous turn."
	elements = BATTLE_MONSTERS_ELEMENT_WATER | BATTLE_MONSTERS_ELEMENT_DARK
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/water/typhoon_god
	name = "Typhoon Lord"
	id = "typhoon_lord"
	description = "Their lower body resembles much of a fish, with massive tidal waves surging from under them. %NAME commonly sends typoons to villages near the waters that threaten the local sealife in the area."
	special_effects = "Tidal Wave: When %NAME is summoned, all non water element monsters, traps, and spells on the field are sent to the graveyard."
	elements = BATTLE_MONSTERS_ELEMENT_WATER
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 4
	rarity = BATTLE_MONSTERS_RARITY_MYTHICAL
	rarity_score = 2

/datum/battle_monsters/element/ice
	name = "Ice"
	id = "ice"
	icon_state = "ice"
	description = "They seem well equipped to deal with the harsh, icy weather on the Plains of Narbask."
	elements = BATTLE_MONSTERS_ELEMENT_ICE
	defense_add = 1
	rarity = BATTLE_MONSTERS_RARITY_COMMON

/datum/battle_monsters/element/ice/defender
	name = "Igloo Defender"
	id = "igloo"
	icon_state = "igloo"
	description = "They stand silently outside an igloo in a freezing blizzard with a sturdy grip on their %WEAPON_AND. They seem unbothered by the cold."
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_SHIELD
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	special_effects = "Master Defender: As long as %NAME is visible, its owner cannot be attacked by monsters. "
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/ice/yeti
	name = "Yeti"
	id = "yeti"
	icon_state = "white"
	description = "They're covered head to toe in white, absorbant magical fur. Their %WEAPON_AND is ferocious, especially for a %SPECIES."
	special_effects = "Spell Absorbtion: As long as %NAME is visible, it's owner cannot be affected by traps or spells."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_CREATURE
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/ice/frostlord
	name = "Frostlord"
	id = "frostlord"
	icon_state = "ice"
	description = "They're wearing a large crown made entirely out of ice and diamonds, and a royal cape made out magical yeti fur. Frostlords gain their title by defeating a yeti in combat by wrestling it to death."
	special_effects = "Royal Decree: As long as there are 2 other frost element monsters on the same side of the field, %NAME cannot be sent to the graveyard.<br>Spell Immunity: %NAME cannot be affected by traps or spells."
	elements = BATTLE_MONSTERS_ELEMENT_ICE
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	rarity = BATTLE_MONSTERS_RARITY_RARE

/datum/battle_monsters/element/ice/frost_guardian
	name = "Frost Guardian"
	id = "frostguardian"
	icon_state = "ice"
	description = "They're wearing incredibly bulky armor, made entirely out of ice. Their still posture compliments the age-long growing of the icicles forming on their %WEAPON_AND."
	special_effects = "Best Defense: As long as %NAME is on the field, its owner cannot lose life points from monster battles."
	attack_mul = 0
	elements = BATTLE_MONSTERS_ELEMENT_ICE
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 3
	rarity = BATTLE_MONSTERS_RARITY_RARE

/datum/battle_monsters/element/ice/blizzard_god
	name = "Blizzard God"
	id = "blizzard_god"
	icon_state = "frost_god"
	description = "Their general %SPECIES-like figure is clouded in a massive %ELEMENT_AND storm. All that come close to seeing it's true form usually perish from frostbite."
	special_effects = "Godly Protection: As long as a frost element monster other than %NAME is on the field, %NAME cannot be attacked by monsters or spells."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GOD
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 5
	rarity = BATTLE_MONSTERS_RARITY_LEGENDARY
	rarity_score = 3

/datum/battle_monsters/element/earth
	name = "Earth"
	id = "earth"
	icon_state = "earth"
	description = "Earthen roots shift around them with small flowers budding from it's branches, signifying a oneness with nature."
	elements = BATTLE_MONSTERS_ELEMENT_EARTH
	rarity = BATTLE_MONSTERS_RARITY_COMMON

/datum/battle_monsters/element/earth/treant
	name = "Treant"
	id = "treant"
	icon_state = "treant"
	description = "They seem to be made out of living mystical wood."
	special_effects = "Exploit Water: If there is a water monster on the opposing side of the field, %NAME gains <b>500</b> defense points."
	defense_mul = 1.25
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/earth/bonfire
	name = "Bonfire"
	id = "bonfire"
	icon_state = "bonfire"
	elements = BATTLE_MONSTERS_ELEMENT_EARTH | BATTLE_MONSTERS_ELEMENT_FIRE
	description = "They seem to be made out of burning driftwood."
	special_effects = "Exploit Fire: If there is a fire monster on the opposing side of the field, %NAME gains <b>500</b> attack points."
	defense_mul = 1.25
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON

/datum/battle_monsters/element/earth/fairy
	name = "Fairy"
	id = "fairy"
	icon_state = "fairy"
	elements = BATTLE_MONSTERS_ELEMENT_EARTH | BATTLE_MONSTERS_ELEMENT_LIGHT
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_FLYING
	description = "They are quite tiny, and have little pixie wings growing out of their back and extra long claws."
	special_effects = "Exploit Dark: If there is a dark monster on the opposing side of the field, all %ELEMENT_AND monsters gain <b>500</b> defense points for as long as %NAME is visible."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	power_mul = 0.5
	defense_mul = 0.5
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/earth/forest_god
	name = "Forest God"
	id = "frost_god"
	icon_state = "earth_god"
	elements = BATTLE_MONSTERS_ELEMENT_EARTH | BATTLE_MONSTERS_ELEMENT_WATER | BATTLE_MONSTERS_ELEMENT_STONE
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_GOD | BATTLE_MONSTERS_DEFENSETYPE_COLOSSUS
	description = "They have roots for feet and massive tree trunks for arms. Their overall size rivals those of the greatest manmade structures on earth, and as such, their %WEAPON_AND must match their size."
	special_effects = "Revenge of the Earth: When a %ELEMENT_OR element is sent to the graveyard, the card responsible will also be sent to the graveyard."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 5
	defense_mul = 2
	rarity = BATTLE_MONSTERS_RARITY_LEGENDARY
	rarity_score = 3

/datum/battle_monsters/element/stone
	name = "Stone"
	id = "stone"
	icon_state = "stone"
	description = "They're rock hard. Made out of rock, that is."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	elements = BATTLE_MONSTERS_ELEMENT_STONE
	rarity = BATTLE_MONSTERS_RARITY_COMMON

/datum/battle_monsters/element/stone/uranium
	name = "Uranium"
	id = "uranium"
	icon_state = "uranium"
	description = "They're made out of pure uranium."
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2
	special_effects = "EMP: If an Iron prefixed monster exists on the field when this card is played, send this card and all energy element monsters on the field to the graveyard."
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1

/datum/battle_monsters/element/stone/iron
	name = "Iron"
	id = "iron"
	icon_state = "iron"
	description = "They're made out of dense iron. A perfect protector of mankind."
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	defense_mul = 1.5
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/stone/steel
	name = "Steel"
	id = "steel"
	icon_state = "steel"
	description = "They're made out of sturdy steel."
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 3

/datum/battle_monsters/element/stone/aluminium
	name = "Aluminium"
	id = "aluminium"
	icon_state = "alum"
	description = "They're made out of incredibly lightweight metal."
	defense_mul = 0.25
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/stone/potassium
	name = "Potassium"
	id = "potassium"
	icon_state = "potas"
	description = "They're made entirely out of bananas, for some reason. Even their %WEAPON_AND is a banana. Everything is bananas."
	special_effects = "Explosion: If a visble water element monster exists on the field when this card is revealed, send this card and all monsters with under <1000> defense points on the field to the graveyard.<br>Flash: If a visible Potassium prefixed monster is on the field when this card is revealed, the opponent's turn is skipped and %NAME is sent to the graveyard."
	rarity = BATTLE_MONSTERS_RARITY_MYTHICAL
	rarity_score = 2

/datum/battle_monsters/element/dark
	name = "Dark"
	id = "dark"
	icon_state = "dark"
	description = "A strange evil, shadowy aura embraces them and all those around it."
	elements = BATTLE_MONSTERS_ELEMENT_DARK
	power_add = BATTLE_MONSTERS_POWER_UPGRADE
	attack_mul = 1.25
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 1

/datum/battle_monsters/element/dark/vampire
	name = "Vampire"
	id = "vampire"
	icon_state = "vampire"
	description = "They're incredibly pale and have two large snake-like fangs."
	special_effects = "Leech: If %NAME attacks the opponent, the owner of the card gains 1 lifepoint as long as the owner's lifepoints are less than 5."
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/dark/cultist
	name = "Cultist"
	id = "cultist"
	icon_state = "cultist"
	description = "They're wearing dark, mysterious robes."
	special_effects = "Summoning: If 6 monsters with a cultist prefix exist on your side of the field at once when %NAME is played or revealed, you win the game."
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/dark/demon
	name = "Demon"
	id = "demon"
	icon_state = "demon"
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_FLYING | BATTLE_MONSTERS_DEFENSETYPE_REPTILE | BATTLE_MONSTERS_DEFENSETYPE_DEMON
	description = "They have the head of a goat and hooved feet, with a menacing reptilian tail growing above their behind and dark wings for flight."
	special_effects = "Sacrifice: %NAME can sacrifice a non-light element type monster on the same side of the field to attack again."
	rarity = BATTLE_MONSTERS_RARITY_MYTHICAL
	rarity_score = 2
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/dark/devil //SPRITE NEEDED
	name = "Devil"
	id = "devil"
	icon_state = "demon"
	attack_type = BATTLE_MONSTERS_ATTACKTYPE_CLAWS
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_FLYING | BATTLE_MONSTERS_DEFENSETYPE_REPTILE | BATTLE_MONSTERS_DEFENSETYPE_DEMON | BATTLE_MONSTERS_DEFENSETYPE_GIANT
	description = "Two boned horns sprout out of their forehead, and two dark demon wings sprout from their back."
	special_effects = "Bargain: When %NAME is played, the card's owner can choose to sacrifice 2 of their lifepoints to remove 1 lifepoint from their opponent."
	rarity = BATTLE_MONSTERS_RARITY_MYTHICAL
	rarity_score = 2
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/dark/unholy //SPRITE NEEDED
	name = "Unholy"
	id = "unholy"
	description = "A dark, unholy aura shrouds their true shape and figure."
	special_effects = "Unholy Barrier: As long as %NAME is in play, all monsters and players are immune to light element spells, traps, and special effects."
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/light
	name = "Light"
	id = "light"
	icon_state = "light"
	description = "A holy aura shapes around their beauty."
	elements = BATTLE_MONSTERS_ELEMENT_LIGHT
	defense_mul = 1.25
	rarity = BATTLE_MONSTERS_RARITY_UNCOMMON
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/light/angel //SPRITE NEEDED
	name = "Guardian Angel"
	id = "angel"
	description = "A halo floats above them, and feathery white wings sprout from their back."
	special_effects = "Sacrifice: If a friendly monster loses a battle, %NAME can be sent to the graveyard instead."
	defense_type = BATTLE_MONSTERS_DEFENSETYPE_FLYING
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/light/undying //SPRITE NEEDED
	name = "Undying"
	id = "undying"
	description = "Various scars are scattered across their body. Each scar seems to glow distinctly with holy energy."
	special_effects = "Reborn: If %NAME is defeated in battle, go to the original owner's hand instead of the graveyard."
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2

/datum/battle_monsters/element/light/holy //SPRITE NEEDED
	name = "Holy"
	id = "holy"
	description = "Their body seems to have an angelic glow."
	special_effects = "Holy Barrier: As long as %NAME is in play, all monsters and players are immune to dark element spells, traps, and special effects."
	rarity = BATTLE_MONSTERS_RARITY_RARE
	rarity_score = 1
	power_add = BATTLE_MONSTERS_POWER_UPGRADE * 2