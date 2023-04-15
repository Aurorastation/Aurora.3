/datum/trader/pizzaria
	name = "Pizza Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Pizzeria"
	possible_origins = list("Papa Joe's", "Mamma Mia", "Dominator Pizza", "Little Kaezars", "Pizza Planet", "Cheese Louise")
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY

	possible_wanted_items = list(
		/obj/item/material/kitchen/utensil            = TRADER_SUBTYPES_ONLY, // Customers keep stealing their cutlery
		/obj/item/material/kitchen/utensil/knife/boot = TRADER_BLACKLIST // No boot knifes
		)

	possible_trading_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/pizza   = TRADER_SUBTYPES_ONLY
		)

	speech = list(
		"hail_generic"    = "Hello! Welcome to ORIGIN, may I take your order?",
		"hail_deny"         = "Beeeep... I'm sorry, your connection has been severed.",
		"trade_complete"    = "Thank you for choosing ORIGIN!",
		"what_want"         = "Customers keep stealing these! We need new",
		"trade_no_goods"    = "I'm sorry but we only take cash.",
		"trade_blacklisted" = "Sir that's... highly illegal.",
		"trade_not_enough"  = "Uhh... that's not enough money for pizza.",
		"how_much"          = "That pizza will cost you VALUE credits.",
		"compliment_deny"   = "That's a bit forward, don't you think?",
		"compliment_accept" = "Thanks, sir! You're very nice!",
		"insult_good"       = "Please stop that, sir.",
		"insult_bad"        = "Sir, just because I'm contractually obligated to keep you on the line for a minute doesn't mean I have to take this.",
		"bribe_refusal"     = "Uh... thanks for the cash, sir. As long as you're in the area, we'll be here..."
	)

/datum/trader/pizzaria/trade(var/list/offers, var/num, var/turf/location)
	. = ..()
	if(.)
		var/atom/movable/M = .
		var/obj/item/pizzabox/box = new(location)
		M.forceMove(box)
		box.pizza = M
		box.boxtag = "A special order from [origin]"

/datum/trader/konyang
	name = "Konyanger Restaurant"
	name_language = TRADER_DEFAULT_NAME
	origin = "Captain Panda Bistro"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY

	possible_wanted_items = list(
		/obj/item/material/kitchen/utensil            = TRADER_SUBTYPES_ONLY, // Customers keep stealing their cutlery
		/obj/item/material/kitchen/utensil/knife/boot = TRADER_BLACKLIST // No boot knifes
		)

	possible_trading_items = list(
		/obj/item/reagent_containers/food/snacks/ricepudding                = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/soydope                    = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/stewedsoymeat              = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/wingfangchu                = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/dry_ramen                  = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/bibimbap                   = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/lomein                     = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/friedrice                  = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/pisanggoreng               = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/chickenmomo                = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/veggiemomo                 = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/mossbowl                   = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/soup/maeuntang             = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/soup/miyeokguk             = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/moss_dumplings             = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/sushi                      = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/sashimi                    = TRADER_THIS_TYPE
	)

	var/list/fortunes = list(
		"Today it's up to you to create the peacefulness you long for.",
		"If you refuse to accept anything but the best, you very often get it.",
		"A smile is your passport into the hearts of others.",
		"Hard work pays off in the future, laziness pays off now.",
		"Change can hurt, but it leads a path to something better.",
		"Hidden in a valley beside an open stream- This will be the type of place where you will find your dream.",
		"Never give up. You're not a failure if you don't give up.",
		"Love can last a lifetime, if you want it to.",
		"The love of your life is stepping into your planet this summer.",
		"Your ability for accomplishment will follow with success."
	)

	speech = list(
		"hail_generic"       = "There are two things constant in life, death and Konyanger food. How may I help you?",
		"hail_deny"          = "We do not take orders from rude customers.",
		"trade_complete"     = "Thank you, sir, for your patronage.",
		"trade_blacklist"    = "No, that is very odd. Why would you trade that away?",
		"what_want"          = "It's very odd, but I need",
		"trade_no_goods"     = "I only accept money transfers.",
		"trade_not_enough"   = "No, I am sorry, that is not possible. I need to make a living.",
		"how_much"           = "I give you ITEM, for VALUE credits. No more, no less.",
		"compliment_deny"    = "That was an odd thing to say, you are very odd.",
		"compliment_accept"  = "Good philosophy, see good in bad, I like.",
		"insult_good"        = "As a man said long ago, \"When anger rises, think of the consequences.\" Think on that.",
		"insult_bad"         = "I do not need to take this from you.",
		"bribe_refusal"      = "Hm... I'll think about it.",
		"bribe_accept"       = "Oh yes! I think I'll stay a few more minutes, then."
	)

/datum/trader/konyang/trade(var/list/offers, var/num, var/turf/location)
	. = ..()
	if(.)
		var/obj/item/reagent_containers/food/snacks/fortunecookie/cookie = new(location)
		var/obj/item/paper/paper = new(cookie)
		cookie.trash = paper
		paper.name = "Fortune"
		paper.info = pick(fortunes)

/datum/trader/grocery
	name = "Grocer"
	name_language = TRADER_DEFAULT_NAME
	possible_origins = list("HyTee", "Kreugars", "Spaceway", "Privaxs", "FutureValue", "Orion Express SpaceMart")
	trade_flags = TRADER_MONEY

	possible_trading_items = list(
		/obj/item/reagent_containers/food/snacks                      = TRADER_SUBTYPES_ONLY,
		/obj/item/reagent_containers/food/drinks/cans                 = TRADER_SUBTYPES_ONLY,
		/obj/item/reagent_containers/food/drinks/bottle               = TRADER_SUBTYPES_ONLY,
		/obj/item/reagent_containers/food/drinks/bottle/small         = TRADER_BLACKLIST,
		/obj/item/reagent_containers/food/snacks/fruit_slice          = TRADER_BLACKLIST,
		/obj/item/reagent_containers/food/snacks/grown                = TRADER_BLACKLIST_ALL,
		/obj/item/reagent_containers/food/snacks/human                = TRADER_BLACKLIST_ALL,
		/obj/item/reagent_containers/food/snacks/sliceable/cake/brain = TRADER_BLACKLIST,
		/obj/item/reagent_containers/food/snacks/meat/human           = TRADER_BLACKLIST,
		/obj/item/reagent_containers/food/snacks/variable             = TRADER_BLACKLIST_ALL
	)

	speech = list(
		"hail_generic"       = "Hello, welcome to ORIGIN, grocery store of the future!",
		"hail_deny"          = "I'm sorry, we've blacklisted your communications due to rude behavior.",
		"trade_complete"     = "Thank you for shopping at ORIGIN!",
		"trade_blacklist"    = "I... wow, that's... no, sir. No.",
		"trade_no_goods"     = "ORIGIN only accepts cash, sir.",
		"trade_not_enough"   = "That is not enough money, sir.",
		"how_much"           = "Sir, that'll cost you VALUE credits. Will that be all?",
		"compliment_deny"    = "Sir, this is a professional environment. Please don't make me get my manager.",
		"compliment_accept"  = "Thank you, sir!",
		"insult_good"        = "Sir, please do not make a scene.",
		"insult_bad"         = "Sir, I WILL get my manager if you don't calm down.",
		"bribe_refusal"      = "Of course sir! ORIGIN is always here for you!"
	)

/datum/trader/bakery
	name = "Pastry Chef"
	name_language = TRADER_DEFAULT_NAME
	origin = "Bakery"
	possible_origins = list("Cakes By Design", "Corner Bakery Local", "My Favorite Cake & Pastry Cafe", "Mama Joes Bakery", "Sprinkles and Fun")
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY

	speech = list(
		"hail_generic"       = "Hello, welcome to ORIGIN! We serve baked goods, including pies, cakes and anything sweet!",
		"hail_deny"          = "Our food is a privilege, not a right. Goodbye.",
		"trade_complete"     = "Thank you for your purchase! Come again if you're hungry for more!",
		"trade_blacklist"    = "We only accept money. Not... that.",
		"what_want"          = "Do you happen to have any",
		"trade_no_goods"     = "Cash for cakes! That's our business!",
		"trade_not_enough"   = "Our dishes are much more expensive than that, sir.",
		"how_much"           = "That lovely dish will cost you VALUE credits.",
		"compliment_deny"    = "Oh wow, how nice of you...",
		"compliment_accept"  = "You're almost as sweet as my pies!",
		"insult_good"        = "My pies are NOT knockoffs!",
		"insult_bad"         = "Well, aren't you a sour apple?",
		"bribe_refusal"      = "Oh ho ho! I'd never think of taking ORIGIN on the road!"
	)
	possible_wanted_items = list(
		/obj/item/material/kitchen/utensil            = TRADER_SUBTYPES_ONLY, // Customers keep stealing their cutlery
		/obj/item/material/kitchen/utensil/knife/boot = TRADER_BLACKLIST // No boot knifes
		)

	possible_trading_items = list(
		/obj/item/reagent_containers/food/snacks/cakeslice/birthday/filled       = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cakeslice/carrot/filled         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cakeslice/cheese/filled         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cakeslice/chocolate/filled      = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cakeslice/lemon/filled          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cakeslice/lime/filled           = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cakeslice/orange/filled         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cakeslice/plain/filled          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/pumpkinpieslice/filled          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/bananabreadslice/filled         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/sliceable                       = TRADER_SUBTYPES_ONLY,
		/obj/item/reagent_containers/food/snacks/sliceable/pizza                 = TRADER_BLACKLIST_ALL,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough             = TRADER_BLACKLIST,
		/obj/item/reagent_containers/food/snacks/sliceable/cake/brain            = TRADER_BLACKLIST,
		/obj/item/reagent_containers/food/snacks/pie                             = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/applepie                        = TRADER_THIS_TYPE
	)

/datum/trader/liquor_store
	name = "Liquor Store"
	name_language = TRADER_DEFAULT_NAME
	possible_origins = list("Drinks and More", "The Space Stop", "Safe Piloting", "The Beer Shop", "Idris Incorporated Cocktails", "Orion Express Liquor Store")
	trade_flags = TRADER_MONEY

	possible_trading_items = list(
		/obj/item/reagent_containers/food/drinks/cans                 = TRADER_SUBTYPES_ONLY,
		/obj/item/reagent_containers/food/drinks/bottle               = TRADER_SUBTYPES_ONLY,
		/obj/item/reagent_containers/food/drinks/bottle/small         = TRADER_BLACKLIST,
	)

	speech = list(
		"hail_generic"       = "Welcome to ORIGIN, the best choice in alcholic and soft drinks!",
		"hail_deny"          = "I'm sorry, we've blacklisted your communications due to rude behavior.",
		"trade_complete"     = "Thank you for shopping at ORIGIN!",
		"trade_blacklist"    = "We do not accept that.",
		"trade_no_goods"     = "We only accepts cash.",
		"trade_not_enough"   = "That is not enough money.",
		"how_much"           = "That'll cost you VALUE credits. Will that be all?",
		"compliment_deny"    = "Sir, this is a professional environment. Please don't make me get my manager.",
		"compliment_accept"  = "Thank you. Remember to do not drink and pilot!",
		"insult_good"        = "Sir, please do not make a scene.",
		"insult_bad"         = "Sir, I WILL get my manager if you don't calm down.",
		"bribe_refusal"      = "Of course sir! ORIGIN is always here for you!"
	)

/datum/trader/adhomian_food
	name = "Adhomian Restaurant"
	name_language = LANGUAGE_SIIK_MAAS
	origin = "Adhomian Restaurant"
	possible_origins = list("Adhomian Delicacies", "Little Rafama Cantina", "The Taste of Home", "Tajaran Home Cuisine", "From Adhomai to Them", "The Cauldron")
	trade_flags = TRADER_MONEY

	allowed_space_sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL) //only in places with some tajaran presence

	possible_trading_items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread               = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/hardbread                   = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/soup/earthenroot            = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/adhomian_sausage            = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/nomadskewer                 = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/fermented_worm              = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/cone_cake                   = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/fruit_rikazu                = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/meat_rikazu                 = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/vegetable_rikazu            = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/chocolate_rikazu            = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/dirt_roast                  = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/sliceable/fatshouter_fillet = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/sliceable/zkahnkowafull     = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/creamice                    = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/chipplate/tajcandy          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/explorer_ration             = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/spicy_clams                 = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/adhomian_can                = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/stew/tajaran                = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/lardwich                    = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin           = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead           = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/darmadhir_brew       = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/treebark_firewater   = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/veterans_choice      = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/small/midynhr_water  = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/nmshaan_liquor       = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/shyyrkirrtyr_wine    = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/small/khlibnyz       = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/hrozamal_soda        = TRADER_THIS_TYPE
	)

	speech = list(
		"hail_generic"       = "Welcome to ORIGIN! Only herrre they can find rrreal Adhomian cuisine outside of Adhomai!",
		"hail_Tajara"        = "They have come to the rrright place if they miss the taste of home.",
		"hail_deny"          = "They arrre no longer welcome in theirrr restaurant.",
		"trade_complete"     = "Theirrr thanks!",
		"trade_blacklist"    = "They do not need it.",
		"what_want"          = "They need something like this.",
		"trade_no_goods"     = "They only accept crrredits.",
		"trade_not_enough"   = "This is not enough to pay forrr theirrr amazing dishes.",
		"how_much"           = "This wonderrrful dish is only VALUE crrredits.",
		"compliment_deny"    = "That is strrrange...",
		"compliment_accept"  = "They will say thanks to theirrr chefs in theirrr behalf.",
		"insult_good"        = "Grrreat joke. Arrre they interrrested in buying any of theirrr dishes?",
		"insult_bad"         = "Come down herrre and say that to theirrr faces.",
		"bribe_refusal"      = "They do not need charrrity.",
		"bribe_accept"       = "They can stay open for a little longerrr."
	)

/datum/trader/unathi_food
	name = "Sinta Restaurant"
	name_language = LANGUAGE_UNATHI
	origin = "Sinta Restaurant"
	possible_origins = list("Esteemed Epicureans of Moghes Trading Company", "The Delicacy Deliverer's Guild", "Mo'gunz Merchants")
	trade_flags = TRADER_MONEY

	allowed_space_sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_GAKAL)

	possible_trading_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp               = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/sliceable/sushi_roll                 = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/sintapudding                         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/chilied_eggs                         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/hatchling_suprise                    = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/red_sun_special                      = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/father_breakfast                     = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/stuffed_meatball                     = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/egg_pancake                          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/riztizkzi_sea                        = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/razirnoodles                         = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/batwings                             = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/stuffedfish                          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/stuffedcarp                          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/roefritters                          = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/snacks/jellystew                            = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice              = TRADER_THIS_TYPE,
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine                   = TRADER_THIS_TYPE
	)

	speech = list(
		"hail_generic"       = "Good day, and welcome! Feeling hungry?",
		"hail_Unathi"        = "Ah... a pleasssure, for.. esssteemed kin",
		"hail_deny"          = "What do you mean they're onto usss- We're closed, sssee you another time!",
		"trade_complete"     = "Another quick sssca- sssettlement! Thank you, friend!",
		"trade_blacklist"    = "That jussst won't work.",
		"trade_no_goods"     = "That jussst won't work.",
		"trade_not_enough"   = "That jussst won't work.",
		"how_much"           = "Ah! A mere VALUE.",
		"compliment_deny"    = "Right, okay, but can we move to the trading part, though? We uh... have places to be.",
		"compliment_accept"  = "Well thank you! Only the bessst - and mossst legitimate - jussst for you, you very flattering friend!",
		"insult_good"        = "Where did thisss come from! Are you looking for trouble? Do you know who we are - legitimate tradersss of courssse!",
		"insult_bad"         = "You think we're just random tradersss?! You have no ideas who you're messsing with!",
		"bribe_refusal"      = "Thisss iss too little,",
		"bribe_accept"       = "Thank you for your donation!"
	)
