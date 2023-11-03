/datum/bounty/item/chef/applies_to(obj/O)
	if(!..())
		return FALSE
	if(!istype(O, /obj/item/reagent_containers/food/snacks))
		return FALSE
	var/obj/item/reagent_containers/food/snacks/S = O
	if(!S.bitecount) //They're not gonna take bitten food.
		return TRUE
	return FALSE

/datum/bounty/item/chef/birthday_cake
	name = "Birthday Cake"
	description = "A birthday party for %PERSONNAME is coming up! Ship a complete birthday cake to celebrate!"
	reward_low = 3000
	reward_high = 4000
	wanted_types = list(
		/obj/item/reagent_containers/food/snacks/variable/cake,
		/obj/item/reagent_containers/food/snacks/sliceable/cake)

/datum/bounty/item/chef/soup
	name = "Soup"
	description = "%COMPNAME will be serving soup to the homeless for a PR initiative. Ship any type of soup. And make sure it's soup- not just hot water."
	reward_low = 2700
	reward_high = 3500
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/soup)
	exclude_types = list(/obj/item/reagent_containers/food/snacks/soup/wish)

/datum/bounty/item/chef/popcorn
	name = "Popcorn Bags"
	description = "%PERSONNAME wants to host a movie night. Ship bags of popcorn for the occasion."
	reward_low = 2300
	reward_high = 3000
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/popcorn)

/datum/bounty/item/chef/icecream
	name = "Ice Cream"
	description = "The air conditioning system of some offices on %DOCKSHORT has failed. Ship some ice cream before we melt."
	reward_low = 4000
	reward_high = 4500
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/icecreamsandwich, /obj/item/reagent_containers/food/snacks/icecream)

/datum/bounty/item/chef/icecream/applies_to(obj/O)
	if(!..())
		return FALSE
	if(istype(O, /obj/item/reagent_containers/food/snacks/icecreamsandwich))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/icecream/I = O
	if(I?.ice_creamed)
		return TRUE
	return FALSE

/datum/bounty/item/chef/pie
	name = "Pie"
	description = "%BOSSSHORT management wants a pie! Ship one pie."
	reward = 3142
	wanted_types = list(/obj/item/reagent_containers/food/snacks/pie,
			/obj/item/reagent_containers/food/snacks/meatpie,
			/obj/item/reagent_containers/food/snacks/tofupie,
			/obj/item/reagent_containers/food/snacks/amanita_pie,
			/obj/item/reagent_containers/food/snacks/plump_pie,
			/obj/item/reagent_containers/food/snacks/xemeatpie,
			/obj/item/reagent_containers/food/snacks/cherrypie)

/datum/bounty/item/chef/salad
	name = "Salad"
	description = "%BOSSSHORT management is going on a health binge. Ship some tasty salads to help keep them on track."
	reward_low = 2800
	reward_high = 3800
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/salad)

/datum/bounty/item/chef/fries
	name = "Fries"
	description = "Sometimes the whole office just gets a craving for a certain food. Today, it's fries. Ship some!"
	reward_low = 2800
	reward_high = 3800
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/carrotfries,
				/obj/item/reagent_containers/food/snacks/fries,
				/obj/item/reagent_containers/food/snacks/chilicheesefries,
				/obj/item/reagent_containers/food/snacks/cheesyfries)

/datum/bounty/item/chef/superbite
	name = "Super Bite Burger"
	description = "%PERSONNAME thinks they can set a competitive eating world record. All they need is a super bite burger shipped to them."
	reward_low = 11500
	reward_high = 13500
	wanted_types = list(/obj/item/reagent_containers/food/snacks/burger/superbite)

/datum/bounty/item/chef/superbite/compatible_with(var/datum/other_bounty)
	if(istype(other_bounty, /datum/bounty/item/chef/burger))
		return FALSE
	return ..()

/datum/bounty/item/chef/poppypretzel
	name = "Poppy Pretzel"
	description = "%BOSSNAME needs a few poppy pretzels for the drug-training of their security department."
	reward_low = 2600
	reward_high = 3200
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/poppypretzel)

/datum/bounty/item/chef/cubancarp
	name = "Cuban Carp"
	description = "A diplomat is visiting %BOSSSHORT. Ship one cuban carp for the business luncheon."
	reward_low = 8200
	reward_high = 9200
	wanted_types = list(/obj/item/reagent_containers/food/snacks/cubancarp)

/datum/bounty/item/chef/hotdog
	name = "Hot Dog"
	description = "%COMPNAME is conducting taste tests to determine the best hot dog recipe. Ship your station's version to participate."
	reward_low = 4000
	reward_high = 4800
	wanted_types = list(/obj/item/reagent_containers/food/snacks/hotdog)

/datum/bounty/item/chef/eggplantparm
	name = "Eggplant Parmigianas"
	description = "A famous singer will be arriving at %BOSSSHORT, and their contract demands that they only be served Eggplant Parmigiana. Ship some, please!"
	reward_low = 4000
	reward_high = 4800
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/eggplantparm)

/datum/bounty/item/chef/muffin
	name = "Muffins"
	description = "%BOSSSHORT needs muffins for a morning meeting! Your station will get a bonus if you ship some."
	reward_low = 3500
	reward_high = 4200
	required_count = 8
	random_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/muffin,
			/obj/item/reagent_containers/food/snacks/nt_muffin,
			/obj/item/reagent_containers/food/snacks/berrymuffin)

/datum/bounty/item/chef/chawanmush
	name = "Chawanmushi"
	description = "Someone from middle-management mentioned Chawanmushi. We never tried them so we need you to ship some immediately."
	reward_low = 6500
	reward_high = 7500
	required_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/chawanmushi)

/datum/bounty/item/chef/kebab
	name = "Kebabs"
	description = "%BOSSNAME is requesting a special order; please ship some kebabs."
	reward_low = 3500
	reward_high = 4200
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/variable/kebab,
			/obj/item/reagent_containers/food/snacks/monkeykabob,
			/obj/item/reagent_containers/food/snacks/tofukabob,
			/obj/item/reagent_containers/food/snacks/koiskebab3,
			/obj/item/reagent_containers/food/snacks/donerkebab)

/datum/bounty/item/chef/poppers
	name = "Jalapeno Poppers"
	description = "%PERSONNAME is trying to set a system record for most jalapeno poppers held in their mouth at once. Don't ask questions, just send them."
	reward_low = 4500
	reward_high = 5200
	required_count = 8
	random_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/jalapeno_poppers)

/datum/bounty/item/chef/burger
	name = "Burger"
	description = "%PERSONNAME is this month's food critic for a local newsletter and they're on a deadline. Give them some burgers to review."
	reward_low = 1200
	reward_high = 2000
	required_count = 2
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/burger)

/datum/bounty/item/chef/burger/compatible_with(var/datum/other_bounty)
	if(istype(other_bounty, /datum/bounty/item/chef/superbite))
		return FALSE
	return ..()

/datum/bounty/item/chef/fortune
	name = "Fortune Cookies"
	description = "%PERSONNAME claims they can do divination based on fortune cookies. Send a batch so we can find out if it's true."
	reward_low = 2000
	reward_high = 3000
	required_count = 7
	random_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/fortunecookie)

/datum/bounty/item/chef/spaghetti
	name = "Spaghetti"
	description = "We're hosting a luncheon for some %COMPSHORT Academy computer programming students. We heard that they really enjoy spaghetti, so ship some!"
	reward_low = 2200
	reward_high = 3200
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/boiledspaghetti,
				/obj/item/reagent_containers/food/snacks/pastatomato,
				/obj/item/reagent_containers/food/snacks/meatballspaghetti)

/datum/bounty/item/chef/dumplings
	name = "Meat Buns or Momo"
	description = "We're sick of eating vendor food; send us some meat buns or momo."
	reward_low = 3200
	reward_high = 4100
	required_count = 4
	random_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/meatbun,
			/obj/item/reagent_containers/food/snacks/chickenmomo,
			/obj/item/reagent_containers/food/snacks/veggiemomo)

/datum/bounty/item/chef/unathi
	name = "Unathi Delicacies"
	description = "We're holding a luncheon with some Hegemony representatives; send some traditional Unathi dishes!"
	reward_low = 3300
	reward_high = 5300
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/bacon_stick,
			/obj/item/reagent_containers/food/snacks/egg_pancake,
			/obj/item/reagent_containers/food/snacks/hatchling_suprise,
			/obj/item/reagent_containers/food/snacks/red_sun_special,
			/obj/item/reagent_containers/food/snacks/riztizkzi_sea,
			/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp,
			/obj/item/reagent_containers/food/snacks/sliceable/sushi_roll,
			/obj/item/reagent_containers/food/snacks/stuffed_meatball,
			/obj/item/reagent_containers/food/snacks/chilied_eggs)

/datum/bounty/item/chef/tajara
	name = "Adhomai Delicacies"
	description = "We're holding a luncheon with some representatives from Adhomai; send some traditional Tajaran dishes!"
	reward_low = 3500
	reward_high = 5500
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/adhomian_sausage,
			/obj/item/reagent_containers/food/snacks/fermented_worm,
			/obj/item/reagent_containers/food/snacks/hardbread,
			/obj/item/reagent_containers/food/snacks/lardwich,
			/obj/item/reagent_containers/food/snacks/nomadskewer,
			/obj/item/reagent_containers/food/snacks/soup/earthenroot,
			/obj/item/reagent_containers/food/snacks/spicy_clams,
			/obj/item/reagent_containers/food/snacks/stew/tajaran,
			/obj/item/reagent_containers/food/snacks/tajaran_bread,
			/obj/item/reagent_containers/food/snacks/tajcandy)

/datum/bounty/item/chef/skrell
	name = "Federation Delicacies"
	description = "We're holding a luncheon with some Nralakk Federation representatives; send some Skrellian dishes!"
	reward_low = 3700
	reward_high = 5700
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/lortl,
			/obj/item/reagent_containers/food/snacks/soup/qilvo,
			/obj/item/reagent_containers/food/snacks/soup/zantiri,
			/obj/item/reagent_containers/food/snacks/xuqqil)

/datum/bounty/item/chef/curry
	name = "Curry"
	description = "I forgot that I was supposed to host lunch for an upcoming meeting. Ship me some curry and I'll make sure your station gets a bonus. - %PERSONNAME"
	reward_low = 3000
	reward_high = 3900
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/redcurry,
			/obj/item/reagent_containers/food/snacks/greencurry,
			/obj/item/reagent_containers/food/snacks/yellowcurry)

/datum/bounty/item/chef/dip
	name = "Dip"
	description = "It's time for an office party, but %PERSONNAME forgot the dip! Send us some and we'll transfer part of their upcoming bonus to your station's account."
	reward_low = 2500
	reward_high = 3000
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/dip)

/datum/bounty/item/chef/reuben
	name = "Reuben Sandwich"
	description = "%PERSONNAME had their lunch stolen from the company fridge. Send us a replacement reuben!"
	reward_low = 3700
	reward_high = 4600
	wanted_types = list(/obj/item/reagent_containers/food/snacks/reubensandwich)
