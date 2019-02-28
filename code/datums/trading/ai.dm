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
		"hail_generic"    = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN, tasked with trading goods in return for credits and supplies.",
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
		/obj/item/device/                        = TRADER_SUBTYPES_ONLY,
		/obj/item/device/assembly                = TRADER_BLACKLIST_ALL,
		/obj/item/device/assembly_holder         = TRADER_BLACKLIST_ALL,
		/obj/item/device/encryptionkey/syndicate = TRADER_BLACKLIST,
		/obj/item/device/radio                   = TRADER_BLACKLIST_ALL,
		/obj/item/device/pda                     = TRADER_BLACKLIST_SUB,
		/obj/item/device/uplink                  = TRADER_BLACKLIST
	)

	possible_trading_items = list(
		/obj/item/weapon/storage/bag                         = TRADER_SUBTYPES_ONLY,
		/obj/item/weapon/storage/bag/cash                    = TRADER_BLACKLIST,
		/obj/item/weapon/storage/backpack                    = TRADER_ALL,
		/obj/item/weapon/storage/backpack/cultpack           = TRADER_BLACKLIST,
		/obj/item/weapon/storage/backpack/holding            = TRADER_BLACKLIST_ALL,
		/obj/item/weapon/storage/backpack/satchel/withwallet = TRADER_BLACKLIST,
		/obj/item/weapon/storage/backpack/chameleon          = TRADER_BLACKLIST,
		/obj/item/weapon/storage/backpack/chameleon          = TRADER_BLACKLIST,
		/obj/item/weapon/storage/backpack/typec              = TRADER_BLACKLIST_ALL,
		/obj/item/weapon/storage/belt/champion               = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/briefcase                   = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/fancy                       = TRADER_SUBTYPES_ONLY,
		/obj/item/weapon/storage/laundry_basket              = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/secure/briefcase            = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/bag/plants                  = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/bag/ore                     = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/toolbox                     = TRADER_ALL,
		/obj/item/weapon/storage/wallet                      = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/photo_album                 = TRADER_THIS_TYPE,
		/obj/item/clothing/glasses                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/glasses/hud                       = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/glasses/sunglasses/blindfold/tape = TRADER_BLACKLIST,
		/obj/item/clothing/glasses/chameleon                 = TRADER_BLACKLIST,
		/obj/item/clothing/glasses/sunglasses/bst            = TRADER_BLACKLIST,
		/obj/item/clothing/glasses/fluff                     = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/glasses/welding/fluff             = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/glasses/regular/fluff             = TRADER_BLACKLIST_ALL
	)

	insult_drop = 0
	compliment_increase = 0

/datum/trader/trading_beacon/New()
	..()
	origin = "[origin] #[rand(100,999)]"

/datum/trader/trading_beacon/mine
	origin = "Mining Beacon"

	possible_trading_items = list(
		/obj/item/weapon/ore                      = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/material/glass            = TRADER_ALL,
		/obj/item/stack/material/iron             = TRADER_THIS_TYPE,
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
		/obj/item/stack/material/tritium          = TRADER_THIS_TYPE,
		/obj/item/stack/material/osmium           = TRADER_THIS_TYPE,
		/obj/item/stack/material/steel            = TRADER_THIS_TYPE,
		/obj/item/stack/material/plasteel         = TRADER_THIS_TYPE,
		/obj/machinery/mining                     = TRADER_SUBTYPES_ONLY
	)

/datum/trader/trading_beacon/manufacturing
	origin = "Manufacturing Beacon"

	possible_trading_items = list(
		/obj/structure/AIcore               = TRADER_THIS_TYPE,
		/obj/structure/mopbucket            = TRADER_THIS_TYPE,
		/obj/structure/ore_box              = TRADER_THIS_TYPE,
		/obj/structure/coatrack             = TRADER_THIS_TYPE,
		/obj/item/bee_pack                  = TRADER_THIS_TYPE,
		/obj/item/weapon/bee_smoker         = TRADER_THIS_TYPE,
		/obj/item/beehive_assembly          = TRADER_THIS_TYPE,
		/obj/item/glass_jar                 = TRADER_THIS_TYPE,
		/obj/item/honey_frame               = TRADER_THIS_TYPE,
		/obj/item/target                    = TRADER_ALL,
		/obj/structure/dispenser            = TRADER_SUBTYPES_ONLY,
		/obj/structure/filingcabinet        = TRADER_THIS_TYPE,
		/obj/structure/plushie              = TRADER_SUBTYPES_ONLY,
		/obj/mecha/working/hoverpod         = TRADER_THIS_TYPE,
		/obj/vehicle/bike                   = TRADER_THIS_TYPE
	)

/datum/trader/trading_beacon/medical
	origin = "Medical Beacon"

	possible_trading_items = list(
		/obj/item/weapon/storage/firstaid                               = TRADER_SUBTYPES_ONLY,
		/obj/item/weapon/storage/pill_bottle                            = TRADER_SUBTYPES_ONLY,
		/obj/item/weapon/reagent_containers/hypospray                   = TRADER_ALL,
		/obj/item/device/healthanalyzer                                 = TRADER_THIS_TYPE,
		/obj/item/device/breath_analyzer                                = TRADER_THIS_TYPE,
		/obj/item/stack/medical/bruise_pack                             = TRADER_THIS_TYPE,
		/obj/item/stack/medical/ointment                                = TRADER_THIS_TYPE,
		/obj/item/stack/medical/advanced                                = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/medical/splint                                  = TRADER_THIS_TYPE,
		/obj/item/weapon/bonesetter                                     = TRADER_THIS_TYPE,
		/obj/item/weapon/retractor                                      = TRADER_THIS_TYPE,
		/obj/item/weapon/hemostat                                       = TRADER_THIS_TYPE,
		/obj/item/weapon/cautery                                        = TRADER_THIS_TYPE,
		/obj/item/weapon/surgicaldrill                                  = TRADER_THIS_TYPE,
		/obj/item/weapon/scalpel                                        = TRADER_ALL,
		/obj/item/weapon/circular_saw                                   = TRADER_THIS_TYPE,
		/obj/item/weapon/bonegel                                        = TRADER_THIS_TYPE,
		/obj/item/weapon/FixOVein                                       = TRADER_THIS_TYPE,
		/obj/item/weapon/bonesetter                                     = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/syringes                           = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/syringegun                         = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/masks                              = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/gloves                             = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/cdeathalarm_kit                    = TRADER_THIS_TYPE,
		/obj/item/weapon/storage/box/beakers                            = TRADER_THIS_TYPE,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline   = TRADER_THIS_TYPE,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin         = TRADER_THIS_TYPE,
		/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate = TRADER_THIS_TYPE,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin      = TRADER_THIS_TYPE,
		/obj/item/device/handheld_medical                               = TRADER_THIS_TYPE,
		/obj/item/stack/medical/advanced/bruise_pack/spaceklot          = TRADER_THIS_TYPE,
		/obj/mecha/medical/odysseus                                     = TRADER_THIS_TYPE
	)