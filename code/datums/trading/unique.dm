/datum/trader/ship/unique
	trade_flags = TRADER_WANTED_ONLY|TRADER_GOODS
	want_multiplier = 5
	typical_duration = 10

/datum/trader/ship/unique/New()
	..()
	wanted_items = list()
	for(var/type in possible_wanted_items)
		var/status = possible_wanted_items[type]
		if(status & TRADER_THIS_TYPE)
			wanted_items += type
		if(status & TRADER_SUBTYPES_ONLY)
			wanted_items += subtypesof(type)
		if(status & TRADER_BLACKLIST)
			wanted_items -= type
		if(status & TRADER_BLACKLIST_SUB)
			wanted_items -= subtypesof(type)

/datum/trader/ship/unique/tick()
	if(prob(-disposition) || refuse_comms)
		duration_of_stay--
	return --duration_of_stay > 0

/datum/trader/ship/unique/what_do_you_want()
	return get_response("what_want", "I don't want anything!")

/datum/trader/ship/unique/severance
	name = "Unknown"
	origin = "SGS Severance"

	possible_wanted_items = list(
		/obj/item/weapon/reagent_containers/food/snacks/human      = TRADER_SUBTYPES_ONLY,
		/obj/item/weapon/reagent_containers/food/snacks/meat/human = TRADER_THIS_TYPE,
		/mob/living/carbon/human                                   = TRADER_ALL
	)

	possible_trading_items = list(
		/obj/mecha/combat                               = TRADER_SUBTYPES_ONLY,
		/obj/mecha/combat/phazon                        = TRADER_BLACKLIST_ALL,
		/obj/item/weapon/gun/projectile/automatic/rifle = TRADER_SUBTYPES_ONLY,
		/obj/item/weapon/gun/energy/pulse               = TRADER_ALL,
		/obj/item/weapon/gun/energy/rifle/pulse         = TRADER_THIS_TYPE
	)

	blacklisted_trade_items = list(/datum/species/monkey, /datum/species/machine, /datum/species/bug, /datum/species/diona)

	speech = list(
		"hail_generic"         = "H-hello. Can you hear me? G-good... I have... specific needs... I have a lot to t-trade with you in return of course.",
		"hail_deny"            = "--CONNECTION SEVERED--",
		"trade_complete"       = "Hahahahahahaha! Thankyouthankyouthankyou!",
		"trade_no_money"       = "I d-don't NEED cash.",
		"trade_not_enough"     = "N-no, no no no. M-more than that... more...",
		"trade_found_unwanted" = "I d-don't think you GET what I want, from your offer.",
		"how_much"             = "Meat. I want meat. The kind they don't serve i-in the mess hall.",
		"what_want"            = "Long p-pork. Yes... that's what I want...",
		"compliment_deny"      = "Your lies won't c-change what I did.",
		"compliment_accept"    = "Yes... I suppose you're right.",
		"insult_good"          = "I... probably deserve that.",
		"insult_bad"           = "Maybe you should c-come here and say that. You'd be worth s-something then."
	)

	mob_transfer_message = "<span class='danger'>You are transported to ORIGIN, and with a sickening thud, you fall unconscious, never to wake again.</span>"


/datum/trader/ship/unique/rock
	name = "Bobo"
	origin = "Floating rock"

	possible_wanted_items = list(
		/obj/item/weapon/ore = TRADER_ALL
	)
	possible_trading_items = list(
		/obj/machinery/power/supermatter = TRADER_ALL,
		/obj/item/weapon/aiModule        = TRADER_SUBTYPES_ONLY
	)
	want_multiplier = 10

	speech = list(
		"hail_generic"         = "Blub am MERCHANT. Blub hunger for things. Boo bring them to blub, yes?",
		"hail_deny"            = "Blub does not want to speak to boo.",
		"trade_complete"       = "Blub likes to trade!",
		"trade_no_money"       = "Boo try to give Blub paper. Blub does not want paper.",
		"trade_not_enough"     = "Blub hungry for bore than that.",
		"trade_found_unwanted" = "Blub only wants bocks. Give bocks.",
		"trade_refuse"         = "No, Blub will not do that. Blub wants bocks, yes? Give bocks.",
		"how_much"             = "Blub wants bocks. Boo give bocks. Blub gives stuff blub found.",
		"what_want"            = "Blub wants bocks. Big bocks, small bocks. Shiny bocks!",
		"compliment_deny"      = "Blub is just MERCHANT. What do boo mean?",
		"compliment_accept"    = "Boo are a bood berson!",
		"insult_good"          = "Blub do not understand. Blub thought we were briends.",
		"insult_bad"           = "Blub feels bad now."
	)


/datum/trader/ship/unique/wizard
	name = "The Grand Master"
	origin = "Interdimensional Prison Cell"

	possible_wanted_items = list(
		/mob/living/simple_animal/construct              = TRADER_SUBTYPES_ONLY,
		/obj/item/weapon/melee/cultblade                 = TRADER_THIS_TYPE,
		/obj/item/clothing/head/culthood                 = TRADER_ALL,
		/obj/item/clothing/suit/space/cult               = TRADER_ALL,
		/obj/item/clothing/suit/cultrobes                = TRADER_ALL,
		/obj/item/clothing/head/helmet/space/cult        = TRADER_ALL,
		/obj/structure/cult                              = TRADER_SUBTYPES_ONLY,
		/obj/structure/constructshell                    = TRADER_ALL,
		/mob/living/simple_animal/familiar               = TRADER_SUBTYPES_ONLY,
		/mob/living/simple_animal/familiar/pet           = TRADER_BLACKLIST,
		/mob/living/simple_animal/hostile/mimic          = TRADER_ALL,
		/obj/item/clothing/head/helmet/space/void/wizard = TRADER_THIS_TYPE,
		/obj/item/clothing/head/wizard                   = TRADER_ALL,
		/obj/item/clothing/suit/space/void/wizard        = TRADER_THIS_TYPE,
		/obj/item/weapon/scrying                         = TRADER_THIS_TYPE,
		/obj/item/weapon/melee/energy/wizard             = TRADER_THIS_TYPE,
		/obj/item/phylactery                             = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/staff                = TRADER_ALL,
		/obj/item/weapon/gun/energy/wand                 = TRADER_ALL,
		/obj/item/weapon/gun/energy/wand/toy             = TRADER_BLACKLIST,
		/obj/item/device/soulstone                       = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/obj/item/weapon/contract/wizard/tk              = TRADER_THIS_TYPE,
		/obj/item/weapon/contract/boon/wizard/smoke      = TRADER_THIS_TYPE,
		/obj/item/weapon/contract/boon/wizard/horsemask  = TRADER_THIS_TYPE,
		/obj/item/weapon/contract/boon/wizard/gestalt    = TRADER_THIS_TYPE,
		/obj/item/weapon/contract/boon/wizard/fireball   = TRADER_THIS_TYPE,
		/obj/item/weapon/contract/boon/wizard/forcewall  = TRADER_THIS_TYPE,
		/obj/item/weapon/contract/boon/wizard/charge     = TRADER_THIS_TYPE,
		/obj/item/toy/figure/wizard                      = TRADER_THIS_TYPE,
		/obj/item/weapon/staff                           = TRADER_ALL,
		/obj/machinery/from_beyond                       = TRADER_ALL
	)

	speech = list(
		"hail_generic"         = "Hello! Are you here on pleasure or business?",
		"hail_Golem"           = "Interesting... how incredibly interesting... come! Let us do business!",
		"hail_deny"            = "I'm sorry, but I REALLY don't want to speak to you.",
		"trade_complete"       = "Pleasure doing business with you! Just don't feed it after midnight!",
		"trade_no_money"       = "Cash? Ha! What's cash to a man like me?",
		"trade_not_enough"     = "Hm, well I do enjoy what you're offering, I prefer a fair trade.",
		"trade_found_unwanted" = "What? I want oddities! Don't you understand?",
		"how_much"             = "I want dark things, brooding things... things that go bump in the night. Things that bleed wrong, live wrong, are wrong.",
		"what_want"            = "Have anything from a broodish cult?",
		"compliment_deny"      = "Like I haven't heard that one before!",
		"compliment_accept"    = "Haha! Aren't you nice.",
		"insult_good"          = "Naughty naughty.",
		"insult_bad"           = "Now where do you get off talking to me like that?"
	)


/datum/trader/ship/unique/vaurca
	origin = "The Hive Shop"
	name_language = LANGUAGE_VAURCA

	possible_wanted_items = list(
		/obj/item/weapon/reagent_containers/food/snacks/koisbar          = TRADER_THIS_TYPE,
		/obj/item/weapon/reagent_containers/food/snacks/koisbar_clean    = TRADER_THIS_TYPE,
		/obj/item/weapon/reagent_containers/food/snacks/grown/kois       = TRADER_THIS_TYPE,
		/obj/item/stack/material/phoron                                  = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/obj/item/clothing/mask/breath/vaurca            = TRADER_THIS_TYPE,
		/obj/item/weapon/melee/energy/vaurca             = TRADER_THIS_TYPE,
		/obj/item/vaurca/box                             = TRADER_THIS_TYPE,
		/obj/item/weapon/melee/vaurca/rock               = TRADER_THIS_TYPE,
		/obj/item/weapon/grenade/spawnergrenade/vaurca   = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/space/void/vaurca        = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/space/void/vaurca = TRADER_THIS_TYPE,
		/obj/item/clothing/shoes/magboots/vox/vaurca     = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/vaurca/blaster       = TRADER_THIS_TYPE,
		/obj/item/weapon/gun/energy/vaurca/gatlinglaser  = TRADER_THIS_TYPE
	)

	speech = list(
		"hail_generic"         = "Greetingzz.",
		"hail_deny"            = "I'm zzorry, we do not want to zzzpeak to you.",
		"trade_complete"       = "Enjoy it, zzzir!",
		"trade_no_money"       = "I have no uzzze vhor creditzzz.",
		"trade_not_enough"     = "I want more, zzzzir.",
		"trade_found_unwanted" = "That izzz not what I want.",
		"how_much"             = "We need k'oizz or vhoron, zzzir.",
		"what_want"            = "K'oizzz or vhoron.",
		"compliment_deny"      = "No kind wordzzzz...",
		"compliment_accept"    = "I appreciate kind wordzzz.",
		"insult_good"          = "Your humor izzz odd.",
		"insult_bad"           = "I do not take inzzultzz kindly."
	)


/datum/trader/ship/unique/bluespace
	name = "Maximus Crane"
	origin = "Bluespace Emporium"

	possible_wanted_items = list(
		/obj/item/bluespace_crystal                   = TRADER_ALL,
		/obj/machinery/bluespacerelay                 = TRADER_ALL,
		/obj/item/stack/telecrystal                   = TRADER_THIS_TYPE,
		/obj/item/organ/brain/golem                   = TRADER_THIS_TYPE,
		/obj/item/device/soulstone                    = TRADER_THIS_TYPE,
		/obj/item/weapon/circuitboard/telesci_console = TRADER_THIS_TYPE,
		/obj/item/weapon/circuitboard/telesci_pad     = TRADER_THIS_TYPE,
		/obj/item/phylactery                          = TRADER_THIS_TYPE,
		/obj/item/blueprints                          = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/backpack/holding     = TRADER_THIS_TYPE,
		/obj/item/weapon/teleportation_scroll         = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/obj/item/mecha_parts/chassis/phazon                 = TRADER_THIS_TYPE,
		/obj/item/mecha_parts/part/phazon_torso              = TRADER_THIS_TYPE,
		/obj/item/mecha_parts/part/phazon_head               = TRADER_THIS_TYPE,
		/obj/item/mecha_parts/part/phazon_left_arm           = TRADER_THIS_TYPE,
		/obj/item/mecha_parts/part/phazon_right_arm          = TRADER_THIS_TYPE,
		/obj/item/mecha_parts/part/phazon_left_leg           = TRADER_THIS_TYPE,
		/obj/item/mecha_parts/part/phazon_right_leg          = TRADER_THIS_TYPE
	)

	speech = list(
		"hail_generic"         = "I trade bluespace and bluespace accessories.",
		"hail_deny"            = "I have nothing to deal with you.",
		"trade_complete"       = "I am sure it is not going to malfuction!",
		"trade_no_money"       = "I don't need credits.",
		"trade_not_enough"     = "I will need far more than this.",
		"trade_found_unwanted" = "This is useless for me.",
		"trade_refuse"         = "Nope, bluespace is not so cheap.",
		"how_much"             = "Maybe for VALUE, bluespace is not cheap!",
		"what_want"            = "I want bluespace related items.",
		"compliment_deny"      = "Well, well.",
		"compliment_accept"    = "I know, the squirrel is great.",
		"insult_good"          = "Witty.",
		"insult_bad"           = "And you still want to do business?"
	)
