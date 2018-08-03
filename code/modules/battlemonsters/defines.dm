#define BATTLE_MONSTERS_CARD_RARITY_COMMON 1
#define BATTLE_MONSTERS_CARD_RARITY_UNCOMMON 2
#define BATTLE_MONSTERS_CARD_RARITY_RARE 3
#define BATTLE_MONSTERS_CARD_RARITY_LEGENDARY 4

#define BATTLE_MONSTERS_CARD_MODE_ATTACK 1
#define BATTLE_MONSTERS_CARD_MODE_VISIBLE 2

#define BATTLE_MONSTERS_CARD_NEUTRAL 1
#define BATTLE_MONSTERS_CARD_FIRE 2
#define BATTLE_MONSTERS_CARD_ENERGY 4
#define BATTLE_MONSTERS_CARD_WATER 8
#define BATTLE_MONSTERS_CARD_ICE 16
#define BATTLE_MONSTERS_CARD_EARTH 32
#define BATTLE_MONSTERS_CARD_STONE 64
#define BATTLE_MONSTERS_CARD_DARK 128
#define BATTLE_MONSTERS_CARD_LIGHT 256
#define BATTLE_MONSTERS_CARD_GOD 512


datum/battle_monsters/card
	var/monster_name = ""
	var/attack_points_mul = 1
	var/defense_points_mul = 1
	var/power = 0


	var/elements = BATTLE_MONSTERS_CARD_NEUTRAL
	var/rarity = BATTLE_MONSTERS_CARD_RARITY_COMMON
	var/prefix = ""
	var/description = ""
	var/special_effects = ""

	var/no_new_effects = FALSE



datum/battle_monsters/card/New()
	. = ..()
	Generate_Prefix()



datum/battle_monsters/card/proc/Generate_Prefix()

	var/list/prefixes_fire = list(
		"Fire" = 1,
		"Lava" = 0.5,
		"Molten" = 0.5,
		"Candle" = 0.5,
		"Burned" = 0.5,
		"Burning Sun" = 0.25,
		"Scorching Blade" = 0.25,
		"Burning Sun God" = 0.01
	)
	var/list/prefixes_energy = list(
		"Energy" = 1,
		"Electric" = 0.5,
		"Powered" = 0.5,
		"Conductive" = 0.25
		"Electronic" = 0.25,
		"Dragonslayer" = 0.25,
		"Dragoncult" = 0.25,
		"Dragoncult God" = 0.01
	)
	var/list/prefixes_water = list(
		"Water" = 1,
		"Rain" = 0.5,
		"Tidal" = 0.25,
		"Rainstorm" = 0.25,
		"Water Temple Protector" = 0.25,
		"Water Temple God" = 0.01
	)
	var/list/prefixes_ice = list(
		"Ice" = 1,
		"Cold" = 2,
		"Snow" = 2,
		"Crystal" = 0.5,
		"Frost Servant" = 0.25,
		"Frost Lord" = 0.01
	)
	var/list/prefixes_earth = list(
		"Earth" = 1,
		"Dirt" = 2,
		"Mud" = 0.5,
		"Swamp" = 0.5
	)

	var/list/prefixes_stone = list(
		"Stone" = 1,
		"Rock" = 1,
		"Granite" = 1,
		"Gold" = 0.5,
		"Platinum" = 0.5,
		"Silver" = 0.5,
		"Bronze" = 1,
		"Steel" = 1,
		"Iron" = 1
	)
	var/list/prefixes_dark = list(
		"Undead" = 2,
		"Dark" = 1,
		"Unholy" = 1,
		"Evil" = 1,
		"Blood" = 0.5,
		"Demonic" = 0.25,
		"Corrupt" = 0.25,
		"Cultist" = 0.25,
		"Dreadlord" = 0.1,
		"Godless" = 0.1,
		"Cult Leader" = 0.1,
	)

	var/list/prefixes_light = list(
		"Holy" = 2,
		"Light" = 1,
		"Chosen One" = 0.01,
		"Demigod" = 0.01,
		"Prophet" = 0.01
	)

	//Move this to a seperate datum after
	var/list/card_weights = list(
		BATTLE_MONSTERS_CARD_FIRE = 0.4,
		BATTLE_MONSTERS_CARD_ENERGY = 0.2,
		BATTLE_MONSTERS_CARD_WATER = 0.2,
		BATTLE_MONSTERS_CARD_ICE = 0.2,
		BATTLE_MONSTERS_CARD_EARTH = 0.8,
		BATTLE_MONSTERS_CARD_STONE = 0.4,
		BATTLE_MONSTERS_CARD_DARK = 0.1,
		BATTLE_MONSTERS_CARD_LIGHT = 0.1
	)

	var/chosen_type = pickweight(card_weights)

	elements = chosen_type

	switch(chosen_type)
		if(BATTLE_MONSTERS_CARD_FIRE)
			prefix = pickweight(prefixes_fire)
			attack_points_mul += 0.1
		if(BATTLE_MONSTERS_CARD_ENERGY)
			prefix = pickweight(prefixes_energy)
			attack_points_mul += 0.2
		if(BATTLE_MONSTERS_CARD_WATER)
			prefix = pickweight(prefixes_water)
			defense_points_mul += 0.1
		if(BATTLE_MONSTERS_CARD_ICE)
			prefix = pickweight(prefixes_ice)
			defense_points_mul += 0.2
		if(BATTLE_MONSTERS_CARD_EARTH)
			prefix = pickweight(prefixes_earth)
			defense_points_mul += 0.1
		if(BATTLE_MONSTERS_CARD_STONE)
			prefix = pickweight(prefixes_stone)
			defense_points_mul += 0.2
		if(BATTLE_MONSTERS_CARD_DARK)
			prefix = pickweight(prefixes_dark)
		if(BATTLE_MONSTERS_CARD_LIGHT)
			prefix = pickweight(prefixes_light)


	switch(prefix)
		if("Fire")
			description += "They're covered in flames.<br>"
		if("Lava")
			description += "They seem to be made entirely out of lava.<br>"
			no_new_effects = TRUE
		if("Molten")
			description += "Molten steel covers their entire being.<br>"
			elements |=  BATTLE_MONSTERS_CARD_STONE
		if("Candle")
			description += "They are covered entirely with burning wax, a telltale sign of the unholy 'Candle' cult.<br>"
			elements |= BATTLE_MONSTERS_CARD_DARK
			special_effects += "For every other Candle Monster on the field, %NAME gains 200 attack points.<br>"
			power -= 200
			rarity += 1
		if("Burned")
			description += "Visible scorch marks and bandages appear all over their body from centuries of using fire. This monster is clearly a veteran of war.<br>"
			power += 500
			rarity += 1
		if("Burning Sun")
			description += "They seem to be covered in holy garb depicting the 'Burning Sun' holy sect.<br>"
			special_effects += "Upon summoning %NAME, send 1 Dark card on each side of the player's field to the graveyard.<br>"
			elements |= BATTLE_MONSTERS_CARD_LIGHT
			rarity += 1
		if("Scorching Blade")
			description += "A giant, firey katana adorns their hip. The blade itself looks extremely unstable and pulsates every now and then.<br>"
			special_effects += "If %NAME is sent to the graveyard, it can choose to bring one non-fire based monster to the graveyard with them.<br>"
			power -= 200
			rarity += 1
		if("Burning Sun God")
			elements |= BATTLE_MONSTERS_CARD_LIGHT
			elements |= BATTLE_MONSTERS_CARD_GOD
			description += "They are of the many lesser Burning Sun Gods of the Burning Sun holy sect. It easily towers over lesser humans.<br>"
			special_effects += "Holy and/or Fire monsters cannot attack or be attacked by %NAME.<br>"
			power += 1000
			rarity += 2
			attack_points_mul += 0.25
		if("Energy")
			description += "They have an intense aurora of electrical energy around them.<br>"
			attack_points_mul += 0.25
		if("Electric")
			description += "They seem to be made entirely out of electrical energy.<br>"
			no_new_effects = TRUE
		if("Powered")
			description += "They are made up of a vast array of mechanical parts.<br>"
			defense_points_mul += 0.25
			power += 200
			elements |= BATTLE_MONSTERS_CARD_STONE
			rarity += 1
		if("Conductive")
			description += "They have several rods protruding out of its back.<br>"
			defense_points_mul += 0.5
			power -= 200
			elements |= BATTLE_MONSTERS_CARD_STONE
			rarity += 1
			special_effects += "Electric monsters cannot attack or be attacked by %NAME.<br>"
		if("Electronic")
			description += "They seem to be made out of complex circuits and futuristic electornics.<br>"
			attack_points_mul += 0.5
			power -= 100
			elements |= BATTLE_MONSTERS_CARD_STONE
			rarity += 1
			special_effects += "%NAME gains 100 attack points for every other energy creature on the field.<br>"
		if("Dragonslayer")
			description += "They're wearing a dragonscale cape, and dragon skull shoulderpads; telltale signs of a member of the Dragonslayer Society.<br>"
			attack_points_mul += 0.5
			power += 200
			elements |= BATTLE_MONSTERS_CARD_STONE
			rarity += 1
			special_effects += "%NAME gains 200 bonus attack points for every dragon on the opposing side of the field.<br>"
		if("Dragoncult")
			description += "They're painted with various symbols belonging to the secretive Dragoncult, an ancient organization that serves the dragons.<br>"
			defense_points_mul += 0.25
			power += 200
			rarity += 1
			special_effects += "%NAME cannot attack dragons.<br>"
			special_effects += "%NAME gains 200 bonus attack points for every dragon on the same side of the field.<br>"
		if("Dragoncult God")
			elements |= BATTLE_MONSTERS_CARD_LIGHT
			elements |= BATTLE_MONSTERS_CARD_GOD
			power += 1000
			rarity += 2
			attack_points_mul += 0.25
			description += "They're one of the many gods with transformative dragon powers. In order to hide from dragon poachers and dragon slayers, they hide among lesser species.<br>"
			special_effects += "%NAME gains 1000 bonus defense points and spell immunity when there is another Dragoncult member on the field.<br>"
			special_effects += "%NAME cannot attack or be attacked by other Dragoncult Gods or Dragoncult monsters.<br>"
		if("Water")
			description += "A constant stream of water flows around them like magic."
		if("Rain")
			description += "They seem to have strong control over rain."
			power -= 400
			rarity += 1
			special_effects += "When %NAME is summoned, all face down cards are revealed. If the face down card is a trap or a fire card, it is sent to the graveyard.<br>"
		if("Tidal")
			description += "They seem to be made entirely out of water, and use the force of tidal waves to move around and attack."
			power += 100
			attack_points_mul += 1
			rarity += 1
			special_effects += "%NAME can attack on the turn it is created.<br>"
			special_effects += "If %NAME does not attack during its owner's turn, it is sent to the graveyard.<br>"
		if("Rainstorm")
			description += "They seem to have strong control over storms. Their power rivals the gods, but they are still mortal."
			power -= 200
			rarity += 2
			attack_points_mul += 0.5
			elements |= BATTLE_MONSTERS_CARD_ENERGY
			special_effects += "When %NAME is summoned, all face down cards are revealed. If the face down card is a trap or a fire card, it is sent to the graveyard.<br>"
			special_effects += "When %NAME is summoned, all visible fire creatures in the field go back to the owner's hand.<br>"
		if("Water Temple Protector")
			description += "They wear a dense liquid cloak, and a trail of water appears behind them. They're obviously a Water Temple Protector."
			power -= 200
			defense_points_mul += 2
			rarity += 1
			special_effects += "%NAME gains 200 extra defense points for every water monster in defense mode on the same side of the field.<br>"
		if("Water Temple God")
			description += "They are made out of pure liquid. Massive stormclouds circle them."
			power += 1200
			defense_points_mul += 0.5
			elements |= BATTLE_MONSTERS_CARD_GOD
			no_new_effects = TRUE
			rarity += 2
			special_effects += "%NAME cannot be attacked by water creatures.<br>"
			special_effects += "For every water creature on the field, %NAME gains 100 attack points.<br>"
			special_effects += "For every fire creature on the field, %NAME loses 100 attack points.<br>"

datum/battle_monsters/card/proc/Generate_Base()