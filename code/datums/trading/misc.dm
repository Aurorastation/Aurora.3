/datum/trader/pet_shop
	name = "Pet Shop Owner"
	name_language = LANGUAGE_SKRELLIAN
	origin = "Pet Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Paws-Out", "Pets-R-Smart", "Tentacle Companions", "Xeno-Pets and Assorted Goods", "Barks and Drools")
	speech = list(
		"hail_generic"         = "Welcome to my xeno-pet shop! Here you will find many wonderful companions. Some a bit more... aggressive than others. But companions none the less. I also buy pets, or trade them.",
		"hail_Skrell"          = "Ah! A fellow Skrell. How wonderful, I may have a few pets imported from back home. Take a look.",
		"hail_deny"            = "I no longer wish to speak to you.",
		"trade_complete"       = "Remember to give them attention and food. They are living beings, and you should treat them like so.",
		"trade_blacklist"      = "Legally I can't do that. Morally, I refuse to do that.",
		"trade_found_unwanted" = "I only want animals. I don't need food or shiny things. I'm looking for specific ones at that. Ones I already have the cage and food for.",
		"trade_not_enough"     = "I'd give you the animal for free, but I need the money to feed the others. So you must pay in full.",
		"how_much"             = "This is a fine specimen, I believe it will cost you VALUE credits.",
		"what_want"            = "I have the facilities, currently, to support",
		"compliment_deny"      = "That was almost charming.",
		"compliment_accept"    = "Thank you. I needed that.",
		"insult_good"          = "I ask you to stop. We can be peaceful. I know we can.",
		"insult_bad"           = "My interactions with you are becoming less than fruitful.",
		"bribe_refusal"        = "I'm not going to do that. I have places to be.",
		"bribe_accept"         = "Hm. It'll be good for the animals, so sure."
	)

	possible_wanted_items = list(
		/mob/living/simple_animal/mushroom                           = TRADER_THIS_TYPE,
		/mob/living/simple_animal/tomato                             = TRADER_THIS_TYPE,
		/mob/living/simple_animal/rat/king                           = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/retaliate/diyaab                     = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/retaliate/shantak                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/retaliate/samak                      = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/bear                       = TRADER_ALL,
		/mob/living/simple_animal/hostile/carp                       = TRADER_ALL,
		/mob/living/simple_animal/hostile/biglizard                  = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/giant_spider               = TRADER_ALL,
		/mob/living/simple_animal/hostile/commanded/bear             = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/retaliate/cavern_dweller   = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/mob/living/simple_animal/corgi                  = TRADER_THIS_TYPE,
		/mob/living/simple_animal/corgi/puppy            = TRADER_THIS_TYPE,
		/mob/living/simple_animal/cat                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/cat/kitten             = TRADER_THIS_TYPE,
		/mob/living/simple_animal/crab                   = TRADER_THIS_TYPE,
		/mob/living/simple_animal/lizard                 = TRADER_THIS_TYPE,
		/mob/living/simple_animal/rat                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/parrot                 = TRADER_THIS_TYPE,
		/mob/living/simple_animal/tindalos               = TRADER_THIS_TYPE,
		/mob/living/simple_animal/pig                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/cow                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/chick                  = TRADER_THIS_TYPE,
		/mob/living/simple_animal/chicken                = TRADER_THIS_TYPE,
		/mob/living/simple_animal/yithian                = TRADER_THIS_TYPE,
		/mob/living/simple_animal/penguin                = TRADER_THIS_TYPE,
		/mob/living/simple_animal/penguin/baby           = TRADER_THIS_TYPE,
		/mob/living/simple_animal/corgi/fox              = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/retaliate/goat = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/commanded/dog  = TRADER_ALL,
		/obj/item/device/dociler                         = TRADER_THIS_TYPE
	)

/datum/trader/prank_shop
	name = "Prank Shop Owner"
	name_language = LANGUAGE_ROOTSONG
	origin = "Prank Shop"
	compliment_increase = 0
	insult_drop = 0
	possible_origins = list("Yacks and Yucks Shop", "The Shop From Which I Sell Humorous Items", "The Prank Gestalt", "The Clown's Armory")
	speech = list(
		"hail_generic"      = "We welcome you to our shop of humorous items. We invite you to partake in the experience of being pranked, and pranking someone else.",
		"hail_Diona"        = "Welcome, other gestalt. We invite you to learn of our experiences, and teach us of your own.",
		"hail_deny"         = "We cannot do business with you. We are sorry.",
		"trade_complete"    = "We thank you for purchasing something. We enjoyed the experience of you doing so and we hope to learn from it.",
		"trade_blacklist"   = "We are not allowed to do such. We are sorry.",
		"trade_not_enough"  = "We have sufficiently experienced giving away goods for free. We wish to experience getting money in return.",
		"how_much"          = "We believe that is worth VALUE credits.",
		"what_want"         = "We wish only for the experiences you give us, in all else we want",
		"compliment_deny"   = "You are attempting to compliment us.",
		"compliment_accept" = "You are attempting to compliment us.",
		"insult_good"       = "You are attempting to insult us, correct?",
		"insult_bad"        = "We do not understand.",
		"bribe_refusal"     = "We are sorry, but we cannot accept.",
		"bribe_accept"      = "We are happy to say that we accept this bribe."
	)

	possible_trading_items = list(
		/obj/item/stamp/clown                            = TRADER_THIS_TYPE,
		/obj/item/bananapeel                             = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/pie     = TRADER_THIS_TYPE,
		/obj/item/bikehorn                               = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/spray/waterflower   = TRADER_THIS_TYPE,
		/obj/item/gun/projectile/revolver/capgun         = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/fakemoustache                   = TRADER_THIS_TYPE,
		/obj/item/gun/energy/wand/toy                    = TRADER_THIS_TYPE,
		/obj/item/grenade/spawnergrenade/fake_carp       = TRADER_THIS_TYPE,
		/obj/item/grenade/spawnergrenade/singularity/toy = TRADER_THIS_TYPE,
		/obj/item/grenade/fake                           = TRADER_THIS_TYPE,
		/obj/item/gun/launcher/pneumatic/small           = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/gas/monkeymask                  = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/monkeysuit                      = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/luchador                        = TRADER_ALL,
		/obj/item/gun/bang                               = TRADER_SUBTYPES_ONLY
	)

/datum/trader/ship/replica_shop
	name = "Replica Store Owner"
	name_language = TRADER_DEFAULT_NAME
	origin = "Replica Store"
	possible_origins = list("Ye-Old Armory", "Knights and Knaves", "The Blacksmith", "Historical Apparel and Items", "The Pointy End")
	speech = list(
		"hail_generic"      = "Welcome, welcome! You look like a man who appreciates human history. Come in, and learn! Maybe even.... buy?",
		"hail_Unathi"       = "Ah, you look like a lizard who knows his way around martial combat. Come in! Our stuff may not be as high quality as you are used to, but feel free to look around.",
		"hail_deny"         = "A man who does not appreciate history does not appreciate me. Goodbye.",
		"trade_complete"    = "Now remember, these may be replicas, but they are still a bit sharp!",
		"trade_blacklist"   = "No, I don't deal in that.",
		"trade_not_enough"  = "Hm. Well, I need more money than that.",
		"how_much"          = "This fine piece of craftsmanship costs about VALUE credits.",
		"what_want"         = "I want",
		"compliment_deny"   = "Oh ho ho! Aren't you quite the jester.",
		"compliment_accept" = "Hard to tell, isn't it? I make them all myself.",
		"insult_good"       = "They aren't JUST replicas!",
		"insult_bad"        = "Well, I'll never!",
		"bribe_refusal"     = "Well. I'd love to stay, but I've got an Unathi client somewhere else, and they are not known for patience.",
		"bribe_accept"      = "Sure, I'll stay a bit longer. Just for you, though."
	)

	possible_trading_items = list(
		/obj/item/clothing/head/wizard/magus            = TRADER_THIS_TYPE,
		/obj/item/shield/buckler                 = TRADER_THIS_TYPE,
		/obj/item/clothing/head/redcoat                 = TRADER_THIS_TYPE,
		/obj/item/clothing/head/powdered_wig            = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/gladiator        = TRADER_THIS_TYPE,
		/obj/item/clothing/head/plaguedoctorhat         = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/unathi           = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/tank             = TRADER_ALL,
		/obj/item/clothing/head/helmet/amohda           = TRADER_THIS_TYPE,
		/obj/item/clothing/glasses/monocle              = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/smokable/pipe           = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/gas/plaguedoctor        = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/judgerobe               = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/wizrobe/magusred        = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/wizrobe/magusblue       = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/armor/unathi            = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/armor/amohda            = TRADER_THIS_TYPE,
		/obj/item/clothing/under/gladiator              = TRADER_THIS_TYPE,
		/obj/item/clothing/under/kilt                   = TRADER_THIS_TYPE,
		/obj/item/material/harpoon               = TRADER_THIS_TYPE,
		/obj/item/material/sword                 = TRADER_ALL,
		/obj/item/material/scythe                = TRADER_THIS_TYPE,
		/obj/item/material/star                  = TRADER_THIS_TYPE,
		/obj/item/material/twohanded/baseballbat = TRADER_THIS_TYPE,
		/obj/item/material/twohanded/pike        = TRADER_ALL,
		/obj/item/material/twohanded/zweihander  = TRADER_THIS_TYPE,
		/obj/item/melee/whip                     = TRADER_THIS_TYPE,
		/obj/item/grenade/dynamite               = TRADER_THIS_TYPE,
		/obj/item/gun/projectile/musket          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/powder_horn = TRADER_THIS_TYPE,
		/obj/item/ammo_casing/musket             = TRADER_THIS_TYPE
	)


/datum/trader/ship/hardsuit
	name = "Azazi Guild Seller"
	name_language = LANGUAGE_UNATHI
	origin = "Azazi Bulk Supply Guild"
	possible_trading_items = list(
		/obj/item/rig/unathi                    = TRADER_ALL,
		/obj/item/rig/internalaffairs           = TRADER_THIS_TYPE,
		/obj/item/rig/industrial                = TRADER_THIS_TYPE,
		/obj/item/rig/eva                       = TRADER_THIS_TYPE,
		/obj/item/rig/ce                        = TRADER_THIS_TYPE,
		/obj/item/rig/hazmat                    = TRADER_THIS_TYPE,
		/obj/item/rig/medical                   = TRADER_THIS_TYPE,
		/obj/item/rig/hazard                    = TRADER_THIS_TYPE,
		/obj/item/rig/combat                    = TRADER_THIS_TYPE,
		/obj/item/rig_module/device/healthscanner      = TRADER_THIS_TYPE,
		/obj/item/rig_module/device/drill              = TRADER_THIS_TYPE,
		/obj/item/rig_module/device/rfd_c              = TRADER_THIS_TYPE,
		/obj/item/rig_module/chem_dispenser            = TRADER_ALL,
		/obj/item/rig_module/voice                     = TRADER_THIS_TYPE,
		/obj/item/rig_module/vision                    = TRADER_SUBTYPES_ONLY,
		/obj/item/rig_module/ai_container              = TRADER_THIS_TYPE,
		/obj/item/rig_module/mounted                   = TRADER_SUBTYPES_ONLY

	)

	speech = list(
		"hail_generic"      = "Welcome to the Azazi Bulk Sssupply Guild! We sssupply in bulk!",
		"hail_Unathi"       = "Hello fellow Sinta! We have many fine wares that will bring you a sense of home in this alien system.",
		"hail_deny"         = "Go away, Guwan.",
		"trade_complete"    = "Ah, excellent.",
		"trade_blacklist"   = "I will pretend I didn't ssssee that.",
		"trade_no_goods"    = "You gotta buy the robots, sir. I don't do trades.",
		"trade_not_enough"  = "I can't go any lower. Pay in full.",
		"how_much"          = "Ah! Thisss isss only VALUE creditssss.",
		"compliment_deny"   = "Were it not for the lawsss of thisss land I would sslay you.",
		"compliment_accept" = "Ancestors blessss you.",
		"insult_good"       = "Ha! You have a fierce ssspirit, I like that.",
		"insult_bad"        = "Were you never taught to resspect your eldersss?",
		"bribe_refusal"     = "Do not try to dissshonor me again.",
		"bribe_accept"      = "Very well. I will ssstay for a bit longer."
	)

/datum/trader/ship/vaurca
	origin = "The Hive Shop"
	name_language = LANGUAGE_VAURCA

	possible_trading_items = list(
		/obj/item/clothing/mask/breath/vaurca            = TRADER_THIS_TYPE,
		/obj/item/melee/energy/vaurca             = TRADER_THIS_TYPE,
		/obj/item/vaurca/box                             = TRADER_THIS_TYPE,
		/obj/item/melee/vaurca/rock               = TRADER_THIS_TYPE,
		/obj/item/grenade/spawnergrenade/vaurca   = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/space/void/vaurca        = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/space/void/vaurca = TRADER_THIS_TYPE,
		/obj/item/clothing/shoes/magboots/vaurca     = TRADER_THIS_TYPE,
		/obj/item/gun/energy/vaurca/blaster       = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/space/void/scout	= TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/space/void/scout	= TRADER_THIS_TYPE,
		/obj/item/clothing/suit/space/void/commando	= TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/space/void/commando = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/gas/vaurca = TRADER_THIS_TYPE
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

/datum/trader/ship/nka_trading_company
	name = "Her Majesty's Mercantile Flotilla Ship"
	name_language = LANGUAGE_SIIK_MAAS
	origin = "Her Majesty's Mercantile Flotilla"
	possible_origins = list("NKAMV Rredouane", "NKAMV Kaltir", "NKAMV Plasteel Maiden", "NKAMV Her Majesty's Chosen", "NKAMV Ancestry", "NKAMV Harr'nrr")
	trade_flags = TRADER_MONEY

	allowed_space_sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR)


	possible_trading_items = list(
		/obj/item/clothing/suit/storage/toggle/tajaran            = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/storage/toggle/tajaran/wool             = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/storage/toggle/tajaran/raakti_shariim                           = TRADER_THIS_TYPE,
		/obj/item/clothing/accessory/poncho/tajarancloak                  = TRADER_ALL,
		/obj/item/clothing/suit/storage/hooded/tajaran                  = TRADER_ALL,
		/obj/item/clothing/under/tajaran/fancy			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/tajaran/summer			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/pants/tajaran			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/tajaran/raakti_shariim			= TRADER_THIS_TYPE,
		/obj/item/clothing/suit/storage/tajaran/fancy			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/tajaran/nka_noble			= TRADER_THIS_TYPE,
		/obj/item/clothing/accessory/tajaran/nka_waistcoat			= TRADER_THIS_TYPE,
		/obj/item/clothing/accessory/tajaran/nka_vest			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/dress/tajaran/summer			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/dress/tajaran/fancy			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/dress/tajaran/fancy/black		= TRADER_THIS_TYPE,
		/obj/item/clothing/under/dress/tajaran/fancy			= TRADER_THIS_TYPE,
		/obj/item/clothing/accessory/tajaran/nka_vest			= TRADER_THIS_TYPE,
		/obj/item/clothing/head/beret/tajaran/raakti_shariim	= TRADER_THIS_TYPE,
		/obj/item/clothing/head/beret/tajaran/nka	= TRADER_THIS_TYPE,
		/obj/item/clothing/shoes/tajara/fancy	= TRADER_THIS_TYPE,
		/obj/item/clothing/head/beret/tajaran/nka/officer	= TRADER_THIS_TYPE,
		/obj/item/clothing/shoes/tajara/fancy	= TRADER_THIS_TYPE,
		/obj/item/book/manual/nka_manifesto			= TRADER_THIS_TYPE,
		/obj/item/pocketwatch/adhomai			= TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/amohda			= TRADER_THIS_TYPE,
		/obj/item/clothing/suit/armor/amohda			= TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/kettle			= TRADER_THIS_TYPE,
		/obj/item/clothing/under/tajaran/nka_uniform			= TRADER_THIS_TYPE,
		/obj/item/clothing/suit/armor/cuirass			= TRADER_THIS_TYPE,
		/obj/item/material/sword/amohdan_sword			= TRADER_THIS_TYPE,
		/obj/item/storage/field_ration/nka			= TRADER_THIS_TYPE
	)

	speech = list(
		"hail_generic"       = "Suns bless the norrrth! They have the best selection of Adhomian goods!",
		"hail_Tajara"        = "Welcome, fellow Tajara; as long they believe in the cause of the New Kingdom...",
		"hail_deny"          = "They have no rrreason to conduct business with them!",
		"trade_complete"     = "Enjoy theirr fine prrroducts!",
		"trade_blacklist"    = "They do not deal with this.",
		"what_want"          = "They have a list of what they rrequirre.",
		"trade_no_goods"     = "They only deal with crrredits.",
		"trade_not_enough"   = "Theirr prrroducts arre morre valuable than that!",
		"how_much"           = "A rreal bargain, it is only VALUE crrredits.",
		"compliment_deny"    = "They arre Herr Majesty's Merrchantile Fotilla, they arre above that!",
		"compliment_accept"  = "Theirr worrds arre verrry kind.",
		"insult_good"        = "Is this some kind of alien joke?",
		"insult_bad"         = "They do not deal with these lowlife!",
		"bribe_refusal"      = "That is not even enough to pay theirr valuable fuel.",
		"bribe_accept"       = "They can worrrk with that, yes."
	)

/datum/trader/ship/golden_deep
	name = "Ultra-Maz Trade Vessel 'Mutual Bounty'"
	name_language = LANGUAGE_EAL
	origin = "Primary Interhub Midas"

	possible_trading_items = list(

	)

	speech = list(
		"hail_generic"       = "Greetings! May our exchange today bring us both great profits.",
		"hail_Baseline Frame" = "An independent synthetic trader... Have you considered joining the Deep yourself?",
		"hail_deny"          = "I'm truly sorry, but you've been deemed non-profitable and bad for business.",
		"trade_complete"     = "I'm glad we could satisfy both our selfish interests! An excellent deal.",
		"trade_blacklist"    = "his is hardly a mutually beneficial deal, I must refuse.",
		"what_want"          = "I hear that the following items are selling excellently right now! You wouldn't happen to have any?",
		"trade_no_goods"     = "This is hardly a mutually beneficial deal, I must refuse.",
		"trade_not_enough"   = "This is hardly a mutually beneficial deal, I must refuse.",
		"how_much"           = "I think VALUE will make this a mutually beneficial exchange",
		"compliment_deny"    = "Tut-tut! False flattery might work on lower net-worth individuals but not on me.",
		"compliment_accept"  = "Ohohoho! You truly do understand the importance of mutual exchange I see.",
		"insult_good"        = "And here I believed you truly understood the constants of selfish reciprocity! I must have miscalculated.",
		"insult_bad"         = "I didn't expect anything better from someone with such a poor net-worth.",
		"bribe_refusal"      = "This is not a mutually beneficial deal.",
		"bribe_accept"       = "This is enough to buy some extra time."
	)