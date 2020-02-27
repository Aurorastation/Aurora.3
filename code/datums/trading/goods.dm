/datum/trader/toyshop
	name = "Toy Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Toy Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Toys R Ours", "LEGS GO", "Kay-Cee Toys", "Build-a-Cat", "Magic Box", "The Positronic's Dungeon and Baseball Card Shop")
	speech = list(
		"hail_generic"         = "Uhh... hello? Welcome to ORIGIN, I hope you have a, uhh.... good shopping trip.",
		"hail_deny"            = "Nah, you're not allowed here. At all",
		"trade_complete"       = "Thanks for shopping... here... at ORIGIN.",
		"trade_blacklist"      = "Uuuuuuuuuuuuuuuuuuuh.... no.",
		"trade_found_unwanted" = "Nah! That's not what I'm looking for. Something rarer.",
		"trade_not_enough"     = "Just 'cause they're made of cardboard doesn't mean they don't cost money...",
		"how_much"             = "Uuuuuuuh... I'm thinking like... VALUE. Right? Or something rare that complements my interest.",
		"what_want"            = "Uuuuum... I guess I want",
		"compliment_deny"      = "Ha! Very funny! You should write your own television show.",
		"compliment_accept"    = "Why yes, I do work out.",
		"insult_good"          = "Well, well, well. Guess we learned who was the troll here.",
		"insult_bad"           = "I've already written a nasty Spacebook post in my mind about you.",
		"bribe_refusal"        = "Nah. I need to get moving as soon as uh... possible.",
		"bribe_accept"         = "You know what, I wasn't doing anything for TIME minutes anyways."
	)

	possible_wanted_items = list(
		/obj/item/toy/figure     = TRADER_THIS_TYPE,
		/obj/item/toy/figure/ert = TRADER_THIS_TYPE,
		/obj/item/toy/prize/honk = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/obj/item/toy/prize                   = TRADER_SUBTYPES_ONLY,
		/obj/item/toy/prize/honk              = TRADER_BLACKLIST,
		/obj/item/toy/figure                  = TRADER_SUBTYPES_ONLY,
		/obj/item/toy/figure/ert              = TRADER_BLACKLIST,
		/obj/item/toy/plushie                 = TRADER_SUBTYPES_ONLY,
		/obj/item/toy/katana                  = TRADER_THIS_TYPE,
		/obj/item/toy/sword                   = TRADER_THIS_TYPE,
		/obj/item/toy/bosunwhistle            = TRADER_THIS_TYPE,
		/obj/item/board                = TRADER_THIS_TYPE,
		/obj/item/deck                 = TRADER_SUBTYPES_ONLY,
		/obj/item/deck/tarot/fluff     = TRADER_BLACKLIST_ALL,
		/obj/item/pack                 = TRADER_SUBTYPES_ONLY,
		/obj/item/dice                 = TRADER_ALL,
		/obj/item/eightball                   = TRADER_ALL,
		/obj/item/gun/energy/wand/toy  = TRADER_THIS_TYPE,
		/obj/item/spirit_board         = TRADER_ALL
	)

/datum/trader/electronics
	name = "Electronic Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Electronic Shop"
	possible_origins = list("Best Sale", "Overstore", "Oldegg", "Circuit Citadel")

	speech = list(
		"hail_generic"      = "Hello, sir! Welcome to ORIGIN, I hope you find what you are looking for.",
		"hail_deny"         = "Your call has been disconnected.",
		"trade_complete"    = "Thank you for shopping at ORIGIN, would you like to get the extended warranty as well?",
		"trade_blacklist"   = "Sir, this is a /electronics/ store.",
		"trade_no_goods"    = "As much as I'd love to buy that from you, I can't.",
		"what_want"         = "Well... we could use some",
		"trade_not_enough"  = "Your offer isn't adequate, sir.",
		"how_much"          = "Your total comes out to VALUE credits.",
		"compliment_deny"   = "Hahaha! Yeah... funny...",
		"compliment_accept" = "That's very nice of you!",
		"insult_good"       = "That was uncalled for, sir. Don't make me get my manager.",
		"insult_bad"        = "Sir, I am allowed to hang up the phone if you continue, sir.",
		"bribe_refusal"     = "Sorry, sir, but I can't really do that.",
		"bribe_accept"      = "Why not! Glad to be here for a few more minutes."
	)

	possible_wanted_items = list(
		/obj/item/stack/material/glass         = TRADER_THIS_TYPE,
		/obj/item/stack/material/gold          = TRADER_THIS_TYPE,
		/obj/item/stack/material/silver        = TRADER_THIS_TYPE,
		/obj/item/stack/material/steel         = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/obj/item/computer_hardware/battery_module        = TRADER_SUBTYPES_ONLY,
		/obj/item/computer_hardware/battery_module/lambda = TRADER_BLACKLIST,
		/obj/item/circuitboard                            = TRADER_SUBTYPES_ONLY,
		/obj/item/circuitboard/telecomms                  = TRADER_BLACKLIST,
		/obj/item/circuitboard/unary_atmos                = TRADER_BLACKLIST,
		/obj/item/circuitboard/arcade                     = TRADER_BLACKLIST,
		/obj/item/circuitboard/broken                     = TRADER_BLACKLIST,
		/obj/item/storage/box/lights/colored              = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/cable_coil                               = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/cable_coil/cyborg                        = TRADER_BLACKLIST,
		/obj/item/stack/cable_coil/random                        = TRADER_BLACKLIST,
		/obj/item/stack/cable_coil/cut                           = TRADER_BLACKLIST,
		/obj/item/airalarm_electronics                    = TRADER_THIS_TYPE,
		/obj/item/airlock_electronics                     = TRADER_ALL,
		/obj/item/cell/high                               = TRADER_THIS_TYPE,
		/obj/item/cell/super                              = TRADER_THIS_TYPE,
		/obj/item/cell/hyper                              = TRADER_THIS_TYPE,
		/obj/item/module                                  = TRADER_SUBTYPES_ONLY,
		/obj/item/tracker_electronics                     = TRADER_THIS_TYPE
	)


/* Clothing stores: each a different type. A hat/glove store, a shoe store, and a jumpsuit store. */

/datum/trader/clothingshop
	name = "Clothing Store Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Clothing Store"
	possible_origins = list("Space Eagle", "Banana Democracy", "Forever 22", "Textiles Factory Warehouse Outlet", "Blocks Brothers")
	speech = list(
		"hail_generic"      = "Hello, sir! Welcome to ORIGIN!",
		"hail_Vox"          = "Well hello sir! I don't believe we have any clothes that fit you... but you can still look!",
		"hail_deny"         = "We do not trade with rude customers. Consider yourself blacklisted.",
		"trade_complete"    = "Thank you for shopping at ORIGIN. Remember: We cannot accept returns without the original tags!",
		"trade_blacklist"   = "Hm, how about no?",
		"trade_no_goods"    = "We don't buy, sir. Only sell.",
		"trade_not_enough"  = "Sorry, ORIGIN policy to not accept trades below our marked prices.",
		"how_much"          = "Your total comes out to VALUE credits.",
		"compliment_deny"   = "Excuse me?",
		"compliment_accept" = "Aw, you're so nice!",
		"insult_good"       = "Sir.",
		"insult_bad"        = "Wow. I don't have to take this.",
		"bribe_refusal"     = "ORIGIN policy clearly states we cannot stay for more than the designated time.",
		"bribe_accept"      = "Hm.... sure! We'll have a few minutes of 'engine troubles'."
	)

	possible_trading_items = list(
		/obj/item/clothing/under                                 = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/under/acj                             = TRADER_BLACKLIST,
		/obj/item/clothing/under/chameleon                       = TRADER_BLACKLIST,
		/obj/item/clothing/under/color                           = TRADER_BLACKLIST,
		/obj/item/clothing/under/dress                           = TRADER_BLACKLIST,
		/obj/item/clothing/under/ert                             = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/under/gimmick                         = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/under/lawyer                          = TRADER_BLACKLIST,
		/obj/item/clothing/under/pj                              = TRADER_BLACKLIST,
		/obj/item/clothing/under/rank                            = TRADER_BLACKLIST,
		/obj/item/clothing/under/shorts                          = TRADER_BLACKLIST,
		/obj/item/clothing/under/stripper                        = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/under/swimsuit                        = TRADER_BLACKLIST,
		/obj/item/clothing/under/syndicate                       = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/under/tactical                        = TRADER_BLACKLIST,
		/obj/item/clothing/under/vox                             = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/under/wedding                         = TRADER_BLACKLIST,
		/obj/item/clothing/under/punpun                          = TRADER_BLACKLIST,
		/obj/item/clothing/under/fluff                           = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/under/dress/fluff                     = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/under/rank/centcom_officer/bst        = TRADER_BLACKLIST,
		/obj/item/clothing/suit/storage/hooded                   = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/suit/storage/hooded/wintercoat/fluff  = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/suit/storage/toggle/labcoat           = TRADER_ALL,
		/obj/item/clothing/suit/storage/toggle/labcoat/fluff     = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/suit/storage/toggle/varsity                          = TRADER_ALL,
		/obj/item/clothing/suit/storage/toggle/track             = TRADER_ALL,
		/obj/item/clothing/suit/jacket/puffer                    = TRADER_ALL,
		/obj/item/clothing/suit/storage/toggle/flannel           = TRADER_ALL
	)

/datum/trader/clothingshop/shoes
	possible_origins = list("Foot Safe", "Paysmall", "Popular Footwear", "Grimbly's Shoes", "Right Steps")
	possible_trading_items = list(
		/obj/item/clothing/shoes                        = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/shoes/chameleon              = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/combat                 = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/clown_shoes            = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/cult                   = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/cyborg                 = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/lightrig               = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/shoes/magboots               = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/shoes/swat                   = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/syndigaloshes          = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/jackboots/toeless/fluff = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/shoes/black/bst              = TRADER_BLACKLIST
	)

/datum/trader/clothingshop/hatglovesaccessories
	possible_origins = list("Baldie's Hats and Accessories", "The Right Fit", "Like a Glove", "Space Fashion")
	possible_trading_items = list(
		/obj/item/clothing/accessory                    = TRADER_ALL,
		/obj/item/clothing/accessory/badge              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/accessory/holster            = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/accessory/medal              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/accessory/storage            = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/accessory/fluff              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/accessory/armband/fluff      = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves                       = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/gloves/lightrig              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/rig                   = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/chameleon             = TRADER_BLACKLIST,
		/obj/item/clothing/gloves/force                 = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/swat/fluff            = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/black/fluff           = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/swat/bst              = TRADER_BLACKLIST,
		/obj/item/clothing/gloves/watch/fluff           = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/fluff                 = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head                         = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/head/beret/centcom           = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/bio_hood                = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/bomb_hood               = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/caphat                  = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/centhat                 = TRADER_BLACKLIST,
		/obj/item/clothing/head/chameleon               = TRADER_BLACKLIST,
		/obj/item/clothing/head/collectable             = TRADER_BLACKLIST,
		/obj/item/clothing/head/culthood                = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/helmet                  = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/lightrig                = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/radiation               = TRADER_BLACKLIST,
		/obj/item/clothing/head/tajaran                 = TRADER_BLACKLIST,
		/obj/item/clothing/head/welding                 = TRADER_BLACKLIST,
		/obj/item/clothing/head/fluff                   = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/det/fluff               = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/winterhood              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/beret/engineering/fluff = TRADER_BLACKLIST_ALL
	)

/*
Sells devices, odds and ends, and medical stuff
*/
/datum/trader/devices
	name = "Devices Store Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Wally's SmartMart"
	possible_origins = list("Buy 'n Save", "Drug Carnival", "C&B", "Fentles", "Dr. Goods", "Beevees")
	possible_trading_items = list(
		/obj/item/device/flashlight                = TRADER_ALL,
		/obj/item/aicard                    = TRADER_THIS_TYPE,
		/obj/item/device/binoculars                = TRADER_THIS_TYPE,
		/obj/item/device/flash                     = TRADER_THIS_TYPE,
		/obj/item/device/floor_painter             = TRADER_THIS_TYPE,
		/obj/item/device/multitool                 = TRADER_THIS_TYPE,
		/obj/item/device/lightreplacer             = TRADER_THIS_TYPE,
		/obj/item/device/megaphone                 = TRADER_THIS_TYPE,
		/obj/item/device/paicard                   = TRADER_THIS_TYPE,
		/obj/item/device/pipe_painter              = TRADER_THIS_TYPE,
		/obj/item/device/healthanalyzer            = TRADER_THIS_TYPE,
		/obj/item/device/breath_analyzer           = TRADER_THIS_TYPE,
		/obj/item/device/analyzer                  = TRADER_ALL,
		/obj/item/device/mass_spectrometer         = TRADER_ALL,
		/obj/item/device/reagent_scanner           = TRADER_ALL,
		/obj/item/device/slime_scanner             = TRADER_THIS_TYPE,
		/obj/item/device/suit_cooling_unit         = TRADER_THIS_TYPE,
		/obj/item/device/t_scanner                 = TRADER_THIS_TYPE,
		/obj/item/device/taperecorder              = TRADER_THIS_TYPE,
		/obj/item/device/batterer                  = TRADER_THIS_TYPE,
		/obj/item/device/violin                    = TRADER_THIS_TYPE,
		/obj/item/device/hailer                    = TRADER_THIS_TYPE,
		/obj/item/device/uv_light                  = TRADER_THIS_TYPE,
		/obj/item/device/mmi                       = TRADER_ALL,
		/obj/item/device/robotanalyzer             = TRADER_THIS_TYPE,
		/obj/item/device/toner                     = TRADER_THIS_TYPE,
		/obj/item/device/camera_film               = TRADER_THIS_TYPE,
		/obj/item/device/camera                    = TRADER_THIS_TYPE,
		/obj/item/device/destTagger                = TRADER_THIS_TYPE,
		/obj/item/device/gps                       = TRADER_THIS_TYPE,
		/obj/item/device/measuring_tape            = TRADER_THIS_TYPE,
		/obj/item/device/ano_scanner               = TRADER_THIS_TYPE,
		/obj/item/device/core_sampler              = TRADER_THIS_TYPE,
		/obj/item/device/depth_scanner             = TRADER_THIS_TYPE,
		/obj/item/device/beacon_locator            = TRADER_THIS_TYPE,
		/obj/item/device/antibody_scanner          = TRADER_THIS_TYPE,
		/obj/item/stack/medical/advanced           = TRADER_BLACKLIST
	)

	speech = list(
		"hail_generic"      = "Hello, hello! Bits and bobs and everything in between, I hope you find what you're looking for!",
		"hail_silicon"      = "Ah! Hello, robot. We only sell things that hm... people can hold in their hands, unfortunately. You are still allowed to buy, though!",
		"hail_deny"         = "Oh no. I don't want to deal with YOU.",
		"trade_complete"    = "Thank you! Now remember, there isn't any return policy here, so be careful with that!",
		"trade_blacklist"   = "Hm. Well that would be illegal, so no.",
		"trade_no_goods"    = "I'm sorry, I only sell goods.",
		"trade_not_enough"  = "Gotta pay more than that to get that!",
		"how_much"          = "Well... I bought it for a lot, but I'll give it to you for VALUE.",
		"compliment_deny"   = "Uh... did you say something?",
		"compliment_accept" = "Mhm! I can agree to that!",
		"insult_good"       = "Wow, where was that coming from?",
		"insult_bad"        = "Don't make me blacklist your connection.",
		"bribe_refusal"     = "Well, as much as I'd love to say 'yes', you realize I operate on a station, correct?"
	)

/datum/trader/ship/robots
	name = "Robot Seller"
	name_language = TRADER_DEFAULT_NAME
	origin = "Robot Store"
	possible_origins = list("AI for the Straight Guy", "Mechanical Buddies", "Bot Chop Shop", "Omni Consumer Projects")

	possible_wanted_items = list(
		/obj/item/bucket_sensor         = TRADER_THIS_TYPE,
		/obj/item/toolbox_tiles_sensor  = TRADER_THIS_TYPE,
		/obj/item/firstaid_arm_assembly = TRADER_THIS_TYPE,
		/obj/item/stack/material/steel         = TRADER_THIS_TYPE

	)

	possible_trading_items = list(
		/obj/item/device/paicard                        = TRADER_THIS_TYPE,
		/obj/item/aicard                         = TRADER_THIS_TYPE,
		/mob/living/bot                                 = TRADER_SUBTYPES_ONLY
	)

	speech = list(
		"hail_generic"      = "Welcome to ORIGIN! Let me walk you through our fine robotic selection!",
		"hail_silicon"      = "Welcome to ORIGIN! Let- oh, you're a synth! Well, your money is good anyway. Welcome, welcome!",
		"hail_deny"         = "ORIGIN no longer wants to speak to you.",
		"what_want"         = "I'd like",
		"trade_complete"    = "I hope you enjoy your new robot!",
		"trade_blacklist"   = "I work with robots, sir. Not that.",
		"trade_no_goods"    = "You gotta buy the robots, sir. I don't do trades.",
		"trade_not_enough"  = "You're coming up short on cash.",
		"how_much"          = "My fine selection of robots will cost you VALUE!",
		"compliment_deny"   = "Well, I almost believed that.",
		"compliment_accept" = "Thank you! My craftsmanship is my life.",
		"insult_good"       = "Uncalled for.... uncalled for.",
		"insult_bad"        = "I've programmed AIs better at insulting than you!",
		"bribe_refusal"     = "I've got too many customers waiting in other sectors, sorry.",
		"bribe_accept"      = "Hm. Don't keep me waiting too long, though."
	)


/datum/trader/ship/mining
	name = "Mining Supply Seller"
	name_language = TRADER_DEFAULT_NAME
	origin = "Mining Supply Store"
	possible_origins = list("Astrodia", "Slag. Co.", "Explosive Drills S.A.", "The Shaft Shop")
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY

	possible_wanted_items  = list(
		/obj/item/stack/material/glass                          = TRADER_ALL,
		/obj/item/stack/material/iron                           = TRADER_THIS_TYPE,
		/obj/item/stack/material/sandstone                      = TRADER_THIS_TYPE,
		/obj/item/stack/material/marble                         = TRADER_THIS_TYPE,
		/obj/item/stack/material/diamond                        = TRADER_THIS_TYPE,
		/obj/item/stack/material/uranium                        = TRADER_THIS_TYPE,
		/obj/item/stack/material/phoron                         = TRADER_THIS_TYPE,
		/obj/item/stack/material/plastic                        = TRADER_THIS_TYPE,
		/obj/item/stack/material/gold                           = TRADER_THIS_TYPE,
		/obj/item/stack/material/silver                         = TRADER_THIS_TYPE,
		/obj/item/stack/material/platinum                       = TRADER_THIS_TYPE,
		/obj/item/stack/material/mhydrogen                      = TRADER_THIS_TYPE,
		/obj/item/stack/material/steel                          = TRADER_THIS_TYPE,
		/obj/item/stack/material/plasteel                       = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/retaliate/minedrone   = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/obj/item/pickaxe                         = TRADER_ALL,
		/obj/item/pickaxe/offhand                 = TRADER_BLACKLIST,
		/obj/item/pickaxe/borgdrill               = TRADER_BLACKLIST,
		/obj/item/shovel                          = TRADER_THIS_TYPE,
		/obj/item/stack/flag                             = TRADER_SUBTYPES_ONLY,
		/obj/item/rfd_ammo                        = TRADER_THIS_TYPE,
		/obj/item/rfd/mining                      = TRADER_THIS_TYPE,
		/obj/item/ore_radar                       = TRADER_THIS_TYPE,
		/obj/item/device/wormhole_jaunter                = TRADER_THIS_TYPE,
		/obj/item/resonator                       = TRADER_ALL,
		/obj/item/autochisel                      = TRADER_ALL,
		/obj/structure/sculpting_block                   = TRADER_ALL,
		/obj/item/plastique/seismic               = TRADER_THIS_TYPE,
		/obj/item/gun/custom_ka/frame01/prebuilt  = TRADER_THIS_TYPE,
		/obj/item/gun/custom_ka/frame02/prebuilt  = TRADER_THIS_TYPE,
		/obj/item/gun/custom_ka/frame03/prebuilt  = TRADER_THIS_TYPE,
		/obj/item/gun/custom_ka/frame04/prebuilt  = TRADER_THIS_TYPE,
		/obj/item/gun/custom_ka/frame05/prebuilt  = TRADER_THIS_TYPE,
		/obj/item/gun/energy/plasmacutter         = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/space/void/mining = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/space/void/mining        = TRADER_THIS_TYPE,
		/obj/machinery/mining/drill                      = TRADER_THIS_TYPE,
		/obj/machinery/mining/brace                      = TRADER_THIS_TYPE,
		/mob/living/heavy_vehicle/premade/ripley                      = TRADER_THIS_TYPE,
		/obj/item/custom_ka_upgrade/upgrade_chips        = TRADER_SUBTYPES_ONLY,
		/obj/item/custom_ka_upgrade/barrels              = TRADER_SUBTYPES_ONLY,
		/obj/item/custom_ka_upgrade/cells                = TRADER_SUBTYPES_ONLY
	)

	speech = list(
		"hail_generic"      = "Welcome to ORIGIN! Let me walk you through our finest mining tools!",
		"hail_deny"         = "ORIGIN no longer wants to speak to you.",
		"trade_complete"    = "Good mining and avoid the holes!",
		"trade_blacklist"   = "I don't want this thing.",
		"what_want"         = "You got any leftover materials? Specifically",
		"trade_no_goods"    = "Only cash here!",
		"trade_not_enough"  = "I need more than that, son.",
		"how_much"          = "This damn good tool will be VALUE!",
		"compliment_deny"   = "Are you here to buy or chat?",
		"compliment_accept" = "You are right, you won't find better tools anywhere else!",
		"insult_good"       = "What did you just damn say to me?",
		"insult_bad"        = "If you are not going to buy anything, get out!",
		"bribe_refusal"     = "No way, I have more people waiting to buy my tools!",
		"bribe_accept"      = "Alright, alright, they can wait then."
	)
