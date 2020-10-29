/obj/item/clothing/head/helmet/space/void/sol
	name = "military voidsuit helmet"
	desc = "A sleek black space helmet designed for combat. Looks to be uniform with Sol Alliance colors."
	icon_state = "sol_helmet"
	item_state = "sol_helmet"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)

	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/sol
	name = "military voidsuit"
	desc = "A sleek black space suit designed for combat. Looks to have seamless composite plating. Painted in Sol Alliance colors."
	icon_state = "sol_suit"
	item_state = "sol_suit"
	slowdown = 1
	armor = list(melee = 70, bullet = 55, laser = 45, energy = 15, bomb = 40, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/coalition
	name = "coalition vulture voidsuit helmet"
	desc = "A helmet resembling an avian, built for the Human head. Heavy and plated with plasteel across its faces."
	icon_state = "vulture"
	item_state = "vulture"
	armor = list(melee = 80, bullet = 70, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 30)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)

	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/coalition
	name = "coalition vulture voidsuit"
	desc = "An iconic Coalition of Colonies standard-issue voidsuit, designed after the Interstellar War and seen in use to this day."
	icon_state = "vulture"
	item_state = "vulture"
	slowdown = 3
	armor = list(melee = 80, bullet = 70, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 30)
	allowed = list(/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE


/obj/item/clothing/head/helmet/space/void/cruiser
	name = "cruiser voidsuit helmet"
	desc = "A silvery chrome, single visor space helmet with built-in peripherals and very bright fore lighting. A favorite of bounty hunters."
	icon_state = "eridani_suit"
	item_state = "eridani_suit"
	armor = list(melee = 50, bullet = 50, laser = 40, energy = 50, bomb = 50, bio = 100, rad = 30)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	w_class = ITEMSIZE_NORMAL
	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/cruiser
	name = "cruiser voidsuit"
	desc = "A silvery chrome voidsuit with neon highlights. Utilized by Eridani private military and police."
	icon_state = "eridani_suit"
	item_state = "eridani_suit"
	armor = list(melee = 50, bullet = 50, laser = 40, energy = 40, bomb = 50, bio = 100, rad = 30)
	allowed = list(/obj/item/tank/oxygen, /obj/item/device/flashlight, /obj/item/gun, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword, /obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/valkyrie
	name = "valkyrie voidsuit helmet"
	desc = "A slot-eyed space helmet, sleek and designed for military purposes. Colored in Elyran military camouflage."
	icon_state = "valkyrie"
	item_state = "valkyrie"
	armor = list(melee = 60, bullet = 30, laser = 50, energy = 40, bomb = 60, bio = 100, rad = 100)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000
	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/valkyrie
	name = "valkyrie voidsuit"
	desc = "A pricey specialist voidsuit designed for atmospheric long jumping and combat. Colored in Elyran military camouflage."
	icon_state = "valkyrie"
	item_state = "valkyrie"
	armor = list(melee = 60, bullet = 30, laser = 50, energy = 40, bomb = 60, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/clothing/head/helmet/space/void/lancer
	name = "lancer voidsuit helmet"
	desc = "A sleek helmet with a bright yellow visor, expertly made in and colored in the iconic branding of Ceres' Lance."
	icon_state = "lancer_suit"
	item_state = "lancer_suit"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE

/obj/item/clothing/suit/space/void/lancer
	name = "lancer voidsuit"
	desc = "A bulky void suit with heavy plating. Looks to be colored in the branding of Ceres' Lance."
	icon_state = "lancer_suit"
	item_state = "lancer_suit"
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE

//Einstein Engines espionage voidsuit
/obj/item/clothing/head/helmet/space/void/einstein
	name = "banshee combat suit helmet"
	desc = "A sleek, menacing voidsuit helmet with the branding of Taipei Engineering Industrial's private military contractors."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "bansheehelm"
	item_state = "bansheehelm"
	contained_sprite = 1

	armor = list(melee = 35, bullet = 35, laser = 75,energy = 55, bomb = 25, bio = 100, rad = 10)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	light_overlay = "helmet_light_banshee"
	brightness_on = 6
	light_color = "#7ffbf7"
	desc_fluff = "An easily recognized Einstein Engines-made PMC voidsuit piece. It is a telltale mark of corporate espionage and more often than not ends up buried with its user."
	refittable = FALSE

/obj/item/clothing/suit/space/void/einstein
	name = "banshee combat suit"
	desc = "A tightly-fitting suit manufactured with shimmering, ablative plating. Looks almost weightless."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "banshee"
	item_state = "banshee"
	contained_sprite = 1

	slowdown = 1
	armor = list(melee = 35, bullet = 35, laser = 75,energy = 55, bomb = 25, bio = 100, rad = 10)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	desc_fluff = "An easily recognized Einstein Engines-made PMC voidsuit piece. It is a telltale mark of corporate espionage and more often than not ends up buried with its user."
	refittable = FALSE

//Zeng-Hu Pharmaceuticals espionage voidsuit
/obj/item/clothing/head/helmet/space/void/zenghu
	name = "dragon biohazard suit helmet"
	desc = "A lightweight form-fitting helmet with sparse plating and weird, bug-like goggles."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "dragonhelm"
	item_state = "dragonhelm"
	contained_sprite = 1

	armor = list(melee = 45, bullet = 15, laser = 35,energy = 25, bomb = 55, bio = 100, rad = 100)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	light_overlay = "helmet_light_dragon"
	brightness_on = 6
	light_color = "#7ffbf7"
	desc_fluff = "An easily recognized Zeng-Hu Pharmaceuticals biohazard control suit helmet. Its bug-eyed goggle visor design is unique among its class, alongside cutting-edge radiation protection."
	refittable = FALSE

/obj/item/clothing/suit/space/void/zenghu
	name = "dragon biohazard control suit"
	desc = "A remarkably lightweight Zeng-Hu Pharmaceuticals suit sporting excellent ambient radiation protection."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "dragon"
	item_state = "dragon"
	contained_sprite = 1

	slowdown = 1
	armor = list(melee = 60, bullet = 15, laser = 35,energy = 25, bomb = 55, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	desc_fluff = "An easily recognized Zeng-Hu Pharmaceuticals biohazard control suit. It is relatively fragile but has very apparent radiation shielding. Most often seen in the hands of post-disaster cleanup teams and private military contractors."
	refittable = FALSE

//Hephaestus Industries espionage voidsuit
/obj/item/clothing/head/helmet/space/void/hephaestus
	name = "caiman drop suit helmet"
	desc = "A massively heavy helmet, part of a larger terraforming suit assembly."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "caimanhelm"
	item_state = "caimanhelm"
	contained_sprite = 1

	armor = list(melee = 75, bullet = 45, laser = 15,energy = 25, bomb = 75, bio = 100, rad = 15)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	light_overlay = "helmet_light_caiman"
	brightness_on = 6
	light_color = "#ffce01"
	desc_fluff = "An easily recognized Hephaestus terraforming suit helmet. Its low, protruding brow and heavy plating is useful in the event you happen to be cutting down things. Mostly trees. Hopefully trees."
	refittable = FALSE

/obj/item/clothing/suit/space/void/hephaestus
	name = "caiman drop suit"
	desc = "A superheavy Hephaestus designed terraforming suit, iconic for its usage in orbital drops onto hostile jungle worlds."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "caiman"
	item_state = "caiman"
	contained_sprite = 1

	slowdown = 2
	armor = list(melee = 75, bullet = 45, laser = 15,energy = 25, bomb = 75, bio = 100, rad = 15)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	desc_fluff = "An easily recognized Hephaestus terraforming suit. Used often on jungle worlds to handle local wildlife and safely deforest areas in hostile environments. It found recent popularity due to its combat effectiveness that resulted in its proliferation in the hands of Hephaestus private military."
	refittable = FALSE

//Zavodskoi Interstellar espionage voidsuit
/obj/item/clothing/head/helmet/space/void/zavodskoi
	name = "revenant suit helmet"
	desc = "A scary-looking helmet with blood red optics."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "revenanthelm"
	item_state = "revenanthelm"
	contained_sprite = 1

	armor = list(melee = 25, bullet = 65, laser = 35,energy = 25, bomb = 15, bio = 100, rad = 15)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	light_overlay = "helmet_light_revenant"
	brightness_on = 6
	light_color = "#f65858"
	desc_fluff = "An ominous helmet of Zavodskoi Interstellar make with its past veiled in mystery, used for high-end corporate backstabbing and secret operations."

/obj/item/clothing/suit/space/void/zavodskoi
	name = "revenant combat suit"
	desc = "A robust skirmishing suit with lightweight plating. It is branded with Kumar Arms logos, a subsidiary of Zavodskoi Interstellar. It looks very portable."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "revenant"
	item_state = "revenant"
	contained_sprite = 1

	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 25, bullet = 65, laser = 35,energy = 25, bomb = 15, bio = 100, rad = 15)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	desc_fluff = "A portable, sleek combat suit utilized in excess by Zavodskoi Interstellar private military contractors. It is known to be utilized by the company's most secretive sectors explicitly for espionage."

//Freelancer voidsuit
/obj/item/clothing/head/helmet/space/void/freelancer
	name = "freelancer voidsuit helmet"
	desc = "An older design of special operations voidsuit helmet utilized by private military corporations."
	icon_state = "rig0-freelancer"

	armor = list(melee = 65, bullet = 55, laser = 20,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	light_overlay = "freelancer_light"
	brightness_on = 6
	light_color = "#7ffbf7"

/obj/item/clothing/suit/space/void/freelancer
	icon_state = "freelancer"
	name = "freelancer voidsuit"
	desc = "An advanced protective voidsuit used for special operations."
	item_state = "freelancer"

	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 65, bullet = 55, laser = 20, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)

/obj/item/clothing/head/helmet/space/void/kataphract
	name = "kataphract voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony."
	icon = 'icons/obj/clothing/species/unathi/hats.dmi'
	icon_override = 'icons/mob/species/unathi/helmet.dmi'
	icon_state = "rig0-kataphract"
	item_state = "rig0-kataphract"
	armor = list(melee = 75, bullet = 45, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 80)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE

/obj/item/clothing/suit/space/void/kataphract
	name = "kataphract voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony."
	icon = 'icons/obj/clothing/species/unathi/suits.dmi'
	icon_override = 'icons/mob/species/unathi/suit.dmi'
	icon_state = "rig-kataphract"
	item_state = "rig-kataphract"
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 75, bullet = 45, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 80)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/kataphract/spec
	name = "kataphract specialist voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Specialist."
	icon_state = "rig0-kataphract-spec"
	item_state = "rig0-kataphract-spec"

/obj/item/clothing/suit/space/void/kataphract/spec
	name = "kataphract specialist voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Specialist."
	icon_state = "rig-kataphract-spec"
	item_state = "rig-kataphract-spec"

/obj/item/clothing/head/helmet/space/void/kataphract/lead
	name = "kataphract knight voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Knight."
	icon_state = "rig0-kataphract-lead"
	item_state = "rig0-kataphract-lead"

/obj/item/clothing/suit/space/void/kataphract/lead
	name = "kataphract knight voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Knight."
	icon_state = "rig-kataphract-lead"
	item_state = "rig-kataphract-lead"

/obj/item/clothing/head/helmet/space/void/dominia
	name = "dominian prejoroub combat helmet"
	desc = "A glamorous, decorated helmet with thick plating across its faces. It holds the emblematic markings of the Empire of Dominia, if its design wasn't unmistakable enough."
	icon = 'icons/obj/clothing/voidsuit/dominia.dmi'
	icon_state = "prejoroubhelm"
	item_state = "prejoroubhelm"
	contained_sprite = 1

	armor = list(melee = 65, bullet = 55, laser = 25,energy = 25, bomb = 15, bio = 100, rad = 15)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	brightness_on = 6

/obj/item/clothing/suit/space/void/dominia
	name = "dominian prejoroub combat suit"
	desc = "An offshoot of the Coalition's vulture suit design, painted in Dominian colors with portability and maneuverability in mind over its bulkier counterpart."
	icon = 'icons/obj/clothing/voidsuit/dominia.dmi'
	icon_state = "prejoroub"
	item_state = "prejoroub"
	contained_sprite = 1

	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 65, bullet = 55, laser = 25,energy = 25, bomb = 15, bio = 100, rad = 15)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)

/obj/item/clothing/head/helmet/space/void/mining/himeo
	name = "himeo mining voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a ballistic glass and polycarbonate visor commonly used by astronauts from Himeo."
	desc_fluff = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life\
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors."
	icon_state = "rig0-himeo"
	item_state = "rig0-himeo"
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm"
		)

	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/mining/himeo
	name = "himeo mining voidsuit"
	item_state_slots = list(
		slot_l_hand_str = "mining_hardsuit",
		slot_r_hand_str = "mining_hardsuit"
	)
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch."
	desc_fluff = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet\
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster."
	item_state = "rig-himeo"
	icon_state = "rig-himeo"

/obj/item/clothing/head/helmet/space/void/engineering/himeo
	name = "himeo engineering voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a reinforced ballistic glass and polycarbonate goggle-type visor commonly used by astronauts from Himeo."
	desc_fluff = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life\
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors."
	icon_state = "rig0-himeo-engineering"
	item_state = "rig0-himeo-engineering"
	item_state_slots = list(
		slot_l_hand_str = "engineering_helm",
		slot_r_hand_str = "engineering_helm"
		)

	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/engineering/himeo
	name = "himeo engineering voidsuit"
	item_state_slots = list(
		slot_l_hand_str = "engineering_hardsuit",
		slot_r_hand_str = "engineering_hardsuit"
	)
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch. This particular model seems to have lead lining in it."
	desc_fluff = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet\
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster."
	item_state = "rig-himeo-engineering"
	icon_state = "rig-himeo-engineering"

/obj/item/clothing/head/helmet/space/void/atmos/himeo
	name = "himeo atmospherics voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a reinforced ballistic glass and polycarbonate goggle-type visor commonly used by astronauts from Himeo. This particular model appears to have a thicker layer of insulation on it."
	desc_fluff = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life\
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors."
	icon_state = "rig0-himeo-engineering"
	item_state = "rig0-himeo-engineering"
	item_state_slots = list(
		slot_l_hand_str = "atmos_helm",
		slot_r_hand_str = "atmos_helm"
		)

	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/atmos/himeo
	name = "himeo atmospherics voidsuit"
	item_state_slots = list(
		slot_l_hand_str = "atmos_hardsuit",
		slot_r_hand_str = "atmos_hardsuit"
	)
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch. This particular model seems to have better insulation in it."
	desc_fluff = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet\
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster."
	item_state = "rig-himeo-engineering"
	icon_state = "rig-himeo-engineering"
