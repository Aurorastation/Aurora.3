/*

TRADING BEACON

Trading beacons are generic AI driven trading outposts.
They sell generic supplies and ask for generic supplies.
*/

/datum/trader/trading_beacon
	name = "AI"
	origin = "Trading Beacon"
	name_language = LANGUAGE_EAL
	trade_flags = TRADER_MONEY|TRADER_GOODS
	speech = list(
		"hail_generic"      = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN, tasked with trading goods in return for credits and supplies.",
		"hail_deny"         = "We are sorry, your connection has been blacklisted. Have a nice day.",
		"trade_complete"    = "Thank you for your patronage.",
		"trade_not_enough"  = "I'm sorry, your offer is not worth what you are asking for.",
		"trade_blacklisted" = "You have offered a blacklisted item. My laws do not allow me to trade for that.",
		"how_much"          = "ITEM will cost you roughly VALUE credits, or something of equal worth.",
		"what_want"         = "I have logged need for",
		"compliment_deny"   = "I'm sorry, I am not allowed to let compliments affect the trade.",
		"compliment_accept" = "Thank you, but that will not not change our business interactions.",
		"insult_good"       = "I do not understand, are we not on good terms?",
		"insult_bad"        = "I do not understand, are you insulting me?",
		"bribe_refusal"     = "You have given me money to stay, however, I am a station. I do not leave."
	)
	possible_wanted_items = list(
		/obj/item/device/                           = TRADER_SUBTYPES_ONLY,
		/obj/item/device/kit                        = TRADER_BLACKLIST_ALL, // They're impossible to make or get outside of mining, just annoys traders.
		/obj/item/device/assembly                   = TRADER_BLACKLIST_ALL,
		/obj/item/device/assembly_holder            = TRADER_BLACKLIST_ALL,
		/obj/item/device/encryptionkey              = TRADER_BLACKLIST_SUB, //Why should ai want NT encryption keys?
		/obj/item/device/radio                      = TRADER_BLACKLIST_ALL,
		/obj/item/device/pda                        = TRADER_BLACKLIST_SUB,
		/obj/item/device/chameleon                  = TRADER_BLACKLIST, // Why should it want a chameleon projector
		/obj/item/device/dociler                    = TRADER_BLACKLIST, //Item unobtaineable
		/obj/item/device/flashlight/drone           = TRADER_BLACKLIST, // No drone stuff
		/obj/item/device/camera_bug                 = TRADER_BLACKLIST, // Traitor stuff
		/obj/item/device/multitool                  = TRADER_BLACKLIST_SUB, // Hacktool, uplink and robo tool ban
		/obj/item/device/modkit                     = TRADER_BLACKLIST_ALL, // No to modkits
		/obj/item/device/pin_extractor              = TRADER_BLACKLIST, // RD's tech
		/obj/item/device/powersink                  = TRADER_BLACKLIST, // Traitor stuff
		/obj/item/device/slime_scanner              = TRADER_BLACKLIST, //If it was doing slime stuff, it already had this
		/obj/item/device/spy_bug                    = TRADER_BLACKLIST, // Traitor stuff
		/obj/item/device/spy_monitor                = TRADER_BLACKLIST, // Traitor stuff
		/obj/item/device/suit_cooling_unit          = TRADER_BLACKLIST, // Not on Aurora
		/obj/item/device/taperecorder/cciaa         = TRADER_BLACKLIST, // Admin item
		/obj/item/device/batterer                   = TRADER_BLACKLIST, // Item too rare
		/obj/item/device/contract_uplink            = TRADER_BLACKLIST, // Traitor stuff
		/obj/item/device/uplink                     = TRADER_BLACKLIST_ALL, // Traitor stuff
		/obj/item/device/announcer                  = TRADER_BLACKLIST, // Rev item
		/obj/item/device/special_uplink             = TRADER_BLACKLIST,
		/obj/item/device/onetankbomb                = TRADER_BLACKLIST, // Not weapons trader
		/obj/item/device/kinetic_analyzer           = TRADER_BLACKLIST, // Not KA trader
		/obj/item/device/camera                     = TRADER_BLACKLIST_SUB, // a lot of ai/drone/cyborg/fluff items
		/obj/item/device/uv_light                   = TRADER_BLACKLIST, // CSI item
		/obj/item/device/eftpos                     = TRADER_BLACKLIST,
		/obj/item/device/nanoquikpay                = TRADER_BLACKLIST,
		/obj/item/device/electronic_assembly        = TRADER_BLACKLIST_ALL, // Not a circuit trader
		/obj/item/device/integrated_circuit_printer = TRADER_BLACKLIST_ALL, //Not a circuit trader
		/obj/item/device/integrated_electronics     = TRADER_BLACKLIST_ALL, // Not a circuit trader
		/obj/item/device/mine_bot_upgrade           = TRADER_BLACKLIST_ALL, // Not a mining vendor + drone stuff
		/obj/item/device/mmi                        = TRADER_BLACKLIST_SUB, // removes MMI Subtypes to prevent trading confusion
		/obj/item/device/soulstone                  = TRADER_BLACKLIST, // Wiz item
		/obj/item/device/firing_pin                 = TRADER_BLACKLIST_ALL, // Not a weapons trader
		/obj/item/device/laser_assembly             = TRADER_BLACKLIST_ALL, // Not a weapons trader
		/obj/item/device/ano_scanner                = TRADER_BLACKLIST, // Xenoarch
		/obj/item/device/core_sampler               = TRADER_BLACKLIST, // Xenoarch
		/obj/item/device/depth_scanner              = TRADER_BLACKLIST, // Xenoarch
		/obj/item/device/beacon_locator             = TRADER_BLACKLIST, // Telescience
		/obj/item/device/telepad_beacon             = TRADER_BLACKLIST, // Telescience
		/obj/item/device/udp_debugger               = TRADER_BLACKLIST, // Circuits
		/obj/item/device/antibody_scanner           = TRADER_BLACKLIST // Virology
	)

	possible_trading_items = list(
		/obj/item/storage/bag                         = TRADER_SUBTYPES_ONLY,
		/obj/item/storage/bag/ore/drone               = TRADER_BLACKLIST, // don't want drone bags
		/obj/item/storage/bag/sheetsnatcher/borg      = TRADER_BLACKLIST, // don't want borg bags
		/obj/item/storage/bag/circuits                = TRADER_BLACKLIST_ALL, //can spawn glitchy circuit boxes, circuitry should belong to science
		/obj/item/storage/bag/money                   = TRADER_BLACKLIST, // spawns with money
		/obj/item/storage/backpack                    = TRADER_ALL,
		/obj/item/storage/backpack/cultpack           = TRADER_BLACKLIST, // cult stuff
		/obj/item/storage/backpack/holding            = TRADER_BLACKLIST_ALL, // research stuff
		/obj/item/storage/backpack/satchel/withwallet = TRADER_BLACKLIST, // money inside
		/obj/item/storage/backpack/chameleon          = TRADER_BLACKLIST, // traitor stuff
		/obj/item/storage/backpack/typec              = TRADER_BLACKLIST_ALL, // Vaurca-exclusive stuff
		/obj/item/storage/backpack/fluff              = TRADER_BLACKLIST_ALL, // Custom items, let's not
		/obj/item/storage/belt/champion               = TRADER_THIS_TYPE,
		/obj/item/storage/briefcase                   = TRADER_THIS_TYPE,
		/obj/item/storage/fancy                       = TRADER_SUBTYPES_ONLY,
		/obj/item/storage/laundry_basket              = TRADER_THIS_TYPE,
		/obj/item/storage/secure/briefcase            = TRADER_THIS_TYPE,
		/obj/item/storage/bag/plants                  = TRADER_THIS_TYPE,
		/obj/item/storage/bag/ore                     = TRADER_THIS_TYPE,
		/obj/item/storage/toolbox                     = TRADER_ALL,
		/obj/item/storage/toolbox/fluff               = TRADER_BLACKLIST_ALL, // Custom items
		/obj/item/storage/wallet                      = TRADER_THIS_TYPE,
		/obj/item/storage/wallet/fluff                = TRADER_BLACKLIST_ALL, // Custom items
		/obj/item/storage/photo_album                 = TRADER_THIS_TYPE,
		/obj/item/clothing/glasses                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/glasses/threedglasses/fluff       = TRADER_BLACKLIST_ALL, // Custom items
		/obj/item/clothing/glasses/hud                       = TRADER_BLACKLIST_ALL, //don't want mech/advanced stuff
		/obj/item/clothing/glasses/sunglasses/blindfold/tape = TRADER_BLACKLIST, // Literally just tape over someone's eyes
		/obj/item/clothing/glasses/chameleon                 = TRADER_BLACKLIST, // traitor stuff
		/obj/item/clothing/glasses/sunglasses/bst            = TRADER_BLACKLIST, // BlueSpaceTech glasses
		/obj/item/clothing/glasses/fluff                     = TRADER_BLACKLIST_ALL, // Custom items
		/obj/item/clothing/glasses/welding/fluff             = TRADER_BLACKLIST_ALL, // Custom items
		/obj/item/clothing/glasses/regular/fluff             = TRADER_BLACKLIST_ALL // Custom items
	)

	insult_drop = 0
	compliment_increase = 0

/datum/trader/trading_beacon/New()
	..()
	origin = "[origin] #[rand(100,999)]"

/datum/trader/trading_beacon/mine
	origin = "Mining Beacon"

	possible_trading_items = list(
		/obj/item/stack/material/glass            = TRADER_ALL,
		/obj/item/stack/material/sandstone        = TRADER_THIS_TYPE,
		/obj/item/stack/material/marble           = TRADER_THIS_TYPE,
		/obj/item/stack/material/diamond          = TRADER_THIS_TYPE,
		/obj/item/stack/material/uranium          = TRADER_THIS_TYPE,
		/obj/item/stack/material/phoron           = TRADER_THIS_TYPE,
		/obj/item/stack/material/plastic          = TRADER_THIS_TYPE,
		/obj/item/stack/material/gold             = TRADER_THIS_TYPE,
		/obj/item/stack/material/silver           = TRADER_THIS_TYPE,
		/obj/item/stack/material/platinum         = TRADER_THIS_TYPE,
		/obj/item/stack/material/mhydrogen        = TRADER_THIS_TYPE,
		/obj/item/stack/material/steel            = TRADER_THIS_TYPE,
		/obj/item/stack/material/plasteel         = TRADER_THIS_TYPE,
		/obj/machinery/mining                     = TRADER_SUBTYPES_ONLY
	)

/datum/trader/trading_beacon/manufacturing
	origin = "Manufacturing Beacon"

	possible_trading_items = list(
		/obj/structure/AIcore                           = TRADER_THIS_TYPE,
		/obj/structure/ore_box                          = TRADER_THIS_TYPE,
		/obj/structure/dispenser                        = TRADER_THIS_TYPE,
		/obj/item/ladder_mobile                  = TRADER_THIS_TYPE,
		/obj/item/inflatable_dispenser           = TRADER_THIS_TYPE,
		/obj/machinery/pipedispenser/orderable          = TRADER_THIS_TYPE,
		/obj/machinery/pipedispenser/disposal/orderable = TRADER_THIS_TYPE,
		/obj/structure/reagent_dispensers/water_cooler  = TRADER_THIS_TYPE,
		/obj/machinery/media/jukebox                    = TRADER_THIS_TYPE,
		/obj/machinery/reagentgrinder                   = TRADER_THIS_TYPE,
		/obj/vehicle/bike                               = TRADER_THIS_TYPE
	)

/datum/trader/trading_beacon/medical
	origin = "Medical Beacon"

	possible_trading_items = list(
		/obj/item/storage/firstaid                               = TRADER_SUBTYPES_ONLY,
		/obj/item/storage/pill_bottle                            = TRADER_SUBTYPES_ONLY,
		/obj/item/reagent_containers/hypospray                   = TRADER_ALL,
		/obj/item/device/healthanalyzer                          = TRADER_THIS_TYPE,
		/obj/item/device/breath_analyzer                         = TRADER_THIS_TYPE,
		/obj/item/stack/medical/bruise_pack                      = TRADER_THIS_TYPE,
		/obj/item/stack/medical/ointment                         = TRADER_THIS_TYPE,
		/obj/item/stack/medical/advanced                         = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/medical/splint                           = TRADER_THIS_TYPE,
		/obj/item/surgery/bonesetter                                     = TRADER_THIS_TYPE,
		/obj/item/surgery/retractor                                      = TRADER_THIS_TYPE,
		/obj/item/surgery/hemostat                                       = TRADER_THIS_TYPE,
		/obj/item/surgery/cautery                                        = TRADER_THIS_TYPE,
		/obj/item/surgery/surgicaldrill                                  = TRADER_THIS_TYPE,
		/obj/item/surgery/scalpel                                        = TRADER_ALL,
		/obj/item/surgery/circular_saw                                   = TRADER_THIS_TYPE,
		/obj/item/surgery/bonegel                                        = TRADER_THIS_TYPE,
		/obj/item/surgery/FixOVein                                       = TRADER_THIS_TYPE,
		/obj/item/surgery/bonesetter                                     = TRADER_THIS_TYPE,
		/obj/item/storage/box/syringes                           = TRADER_THIS_TYPE,
		/obj/item/storage/box/syringegun                         = TRADER_THIS_TYPE,
		/obj/item/storage/box/masks                              = TRADER_THIS_TYPE,
		/obj/item/storage/box/gloves                             = TRADER_THIS_TYPE,
		/obj/item/storage/box/cdeathalarm_kit                    = TRADER_THIS_TYPE,
		/obj/item/storage/box/beakers                            = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/glass/bottle/norepinephrine = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/glass/bottle/stoxin         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/glass/bottle/chloralhydrate = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/glass/bottle/antitoxin      = TRADER_THIS_TYPE,
		/obj/item/device/handheld_medical                        = TRADER_THIS_TYPE,
		/obj/item/stack/medical/advanced/bruise_pack/spaceklot   = TRADER_THIS_TYPE
	)