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
	reward_low = 75
	reward_high = 100
	wanted_types = list(
		/obj/item/reagent_containers/food/snacks/variable/cake,
		/obj/item/reagent_containers/food/snacks/sliceable/cake)

/datum/bounty/item/chef/soup
	name = "Soup"
	description = "%COMPNAME will be serving soup to the homeless for a PR initiative. Ship any type of soup. And make sure it's soup- not just hot water."
	reward_low = 55
	reward_high = 125
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/soup)
	exclude_types = list(/obj/item/reagent_containers/food/snacks/soup/wish)

/datum/bounty/item/chef/popcorn
	name = "Popcorn Bags"
	description = "%PERSONNAME wants to host a movie night. Ship bags of popcorn for the occasion."
	reward_low = 45
	reward_high = 90
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/popcorn)

/datum/bounty/item/chef/icecream
	name = "Ice Cream"
	description = "The air conditioning system of some offices on %DOCKSHORT has failed. Ship some ice cream before we melt."
	reward_low = 40
	reward_high = 60
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/icecreamsandwich,
			/obj/item/reagent_containers/food/snacks/icecream,
			/obj/item/reagent_containers/food/snacks/creamice)

/datum/bounty/item/chef/icecream/applies_to(obj/O)
	if(!..())
		return FALSE
	if(istype(O, /obj/item/reagent_containers/food/snacks/icecreamsandwich))
		return TRUE
	if(istype(O, /obj/item/reagent_containers/food/snacks/creamice))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/icecream/I = O
	if(I?.ice_creamed)
		return TRUE
	return FALSE

/datum/bounty/item/chef/pie
	name = "Pie"
	description = "%BOSSSHORT management wants a pie! Ship one pie."
	reward = 75
	wanted_types = list(/obj/item/reagent_containers/food/snacks/pie,
			/obj/item/reagent_containers/food/snacks/meatpie,
			/obj/item/reagent_containers/food/snacks/tofupie,
			/obj/item/reagent_containers/food/snacks/amanita_pie,
			/obj/item/reagent_containers/food/snacks/plump_pie,
			/obj/item/reagent_containers/food/snacks/xemeatpie,
			/obj/item/reagent_containers/food/snacks/cherrypie,
			/obj/item/reagent_containers/food/snacks/applepie,
			/obj/item/reagent_containers/food/snacks/chocolate_rikazu,
			/obj/item/reagent_containers/food/snacks/fruit_rikazu,
			/obj/item/reagent_containers/food/snacks/meat_rikazu,
			/obj/item/reagent_containers/food/snacks/sliceable/keylimepie,
			/obj/item/reagent_containers/food/snacks/sliceable/giffypie,
			/obj/item/reagent_containers/food/snacks/vegetable_rikazu)

/datum/bounty/item/chef/salad
	name = "Salad"
	description = "%BOSSSHORT management is going on a health binge. Ship some tasty salads to help keep them on track."
	reward_low = 45
	reward_high = 55
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/salad)

/datum/bounty/item/chef/fries
	name = "Fries"
	description = "Sometimes the whole office just gets a craving for a certain food. Today, it's fries. Ship some!"
	reward_low = 35
	reward_high = 45
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/carrotfries,
				/obj/item/reagent_containers/food/snacks/fries,
				/obj/item/reagent_containers/food/snacks/chilicheesefries,
				/obj/item/reagent_containers/food/snacks/cheesyfries,
				/obj/item/reagent_containers/food/snacks/earthenroot_fries)

/datum/bounty/item/chef/superbite
	name = "Super Bite Burger"
	description = "%PERSONNAME thinks they can set a competitive eating world record. All they need is a super bite burger shipped to them."
	reward_low = 90
	reward_high = 120
	wanted_types = list(/obj/item/reagent_containers/food/snacks/burger/superbite)

/datum/bounty/item/chef/superbite/compatible_with(var/datum/other_bounty)
	if(istype(other_bounty, /datum/bounty/item/chef/burger))
		return FALSE
	return ..()

/datum/bounty/item/chef/poppypretzel
	name = "Poppy Pretzel"
	description = "%BOSSNAME needs a few poppy pretzels for the drug-training of their security department."
	reward_low = 45
	reward_high = 65
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/poppypretzel)

/datum/bounty/item/chef/cubancarp
	name = "Cuban Carp"
	description = "A diplomat is visiting %BOSSSHORT. Ship one cuban carp for the business luncheon."
	reward_low = 100
	reward_high = 150
	wanted_types = list(/obj/item/reagent_containers/food/snacks/cubancarp)

/datum/bounty/item/chef/hotdog
	name = "Hot Dog"
	description = "%COMPNAME is conducting taste tests to determine the best hot dog recipe. Ship your station's version to participate."
	reward_low = 40
	reward_high = 60
	wanted_types = list(/obj/item/reagent_containers/food/snacks/hotdog)

/datum/bounty/item/chef/eggplantparm
	name = "Eggplant Parmigianas"
	description = "A famous singer will be arriving at %BOSSSHORT, and their contract demands that they only be served Eggplant Parmigiana. Ship some, please!"
	reward_low = 40
	reward_high = 60
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/eggplantparm)

/datum/bounty/item/chef/muffin
	name = "Muffins"
	description = "%BOSSSHORT needs muffins for a morning meeting! Your station will get a bonus if you ship some."
	reward_low = 35
	reward_high = 42
	required_count = 8
	random_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/muffin,
			/obj/item/reagent_containers/food/snacks/burger/nt_muffin,
			/obj/item/reagent_containers/food/snacks/muffin/berry)

/datum/bounty/item/chef/chawanmush
	name = "Chawanmushi"
	description = "Someone from middle-management mentioned Chawanmushi. We never tried them so we need you to ship some immediately."
	reward_low = 65
	reward_high = 75
	required_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/chawanmushi)

/datum/bounty/item/chef/kebab
	name = "Kebabs"
	description = "%BOSSNAME is requesting a special order; please ship some kebabs."
	reward_low = 40
	reward_high = 60
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/variable/kebab,
			/obj/item/reagent_containers/food/snacks/monkeykabob,
			/obj/item/reagent_containers/food/snacks/neaerakabob,
			/obj/item/reagent_containers/food/snacks/nomadskewer,
			/obj/item/reagent_containers/food/snacks/stokkebab,
			/obj/item/reagent_containers/food/snacks/tofukabob,
			/obj/item/reagent_containers/food/snacks/koiskebab3,
			/obj/item/reagent_containers/food/snacks/donerkebab)

/datum/bounty/item/chef/poppers
	name = "Jalapeno Poppers"
	description = "%PERSONNAME is trying to set a system record for most jalapeno poppers held in their mouth at once. Don't ask questions, just send them."
	reward_low = 45
	reward_high = 52
	required_count = 8
	random_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/jalapeno_poppers)

/datum/bounty/item/chef/burger
	name = "Burger"
	description = "%PERSONNAME is this month's food critic for a local newsletter and they're on a deadline. Give them some burgers to review."
	reward_low = 52
	reward_high = 70
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
	reward_low = 20
	reward_high = 30
	required_count = 7
	random_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/fortunecookie)

/datum/bounty/item/chef/spaghetti
	name = "Spaghetti"
	description = "We're hosting a luncheon for some %COMPSHORT Academy computer programming students. We heard that they really enjoy spaghetti, so ship some!"
	reward_low = 55
	reward_high = 80
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/boiledspaghetti,
				/obj/item/reagent_containers/food/snacks/pastatomato,
				/obj/item/reagent_containers/food/snacks/meatballspaghetti,
				/obj/item/reagent_containers/food/snacks/spaghettibolognese)

/datum/bounty/item/chef/dumplings
	name = "Meat Buns or Momo"
	description = "We're sick of eating vendor food; send us some meat buns or momo."
	reward_low = 40
	reward_high = 60
	required_count = 4
	random_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/meatbun,
			/obj/item/reagent_containers/food/snacks/chickenmomo,
			/obj/item/reagent_containers/food/snacks/veggiemomo)

/datum/bounty/item/chef/unathi
	name = "Unathi Delicacies"
	description = "We're holding a luncheon with some Hegemony representatives; send some traditional Unathi dishes!"
	reward_low = 150
	reward_high = 250
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/aghrasshcake,
			/obj/item/reagent_containers/food/snacks/bacon_stick,
			/obj/item/reagent_containers/food/snacks/batwings,
			/obj/item/reagent_containers/food/snacks/chilied_eggs,
			/obj/item/reagent_containers/food/snacks/egg_pancake,
			/obj/item/reagent_containers/food/snacks/father_breakfast,
			/obj/item/reagent_containers/food/snacks/gukhefish,
			/obj/item/reagent_containers/food/snacks/hatchbowl,
			/obj/item/reagent_containers/food/snacks/hatchling_suprise,
			/obj/item/reagent_containers/food/snacks/jellystew,
			/obj/item/reagent_containers/food/snacks/razirnoodles,
			/obj/item/reagent_containers/food/snacks/red_sun_special,
			/obj/item/reagent_containers/food/snacks/riztizkzi_sea,
			/obj/item/reagent_containers/food/snacks/sintapudding,
			/obj/item/reagent_containers/food/snacks/sliceable/eyebowl,
			/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp,
			/obj/item/reagent_containers/food/snacks/sliceable/sushi_roll,
			/obj/item/reagent_containers/food/snacks/stokkebab,
			/obj/item/reagent_containers/food/snacks/stuffed_meatball,
			/obj/item/reagent_containers/food/snacks/stuffedcarp,
			/obj/item/reagent_containers/food/snacks/stuffedfish)

/datum/bounty/item/chef/tajara
	name = "Adhomai Delicacies"
	description = "We're holding a luncheon with some representatives from Adhomai; send some traditional Tajaran dishes!"
	reward_low = 150
	reward_high = 250
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/adhomian_porridge,
			/obj/item/reagent_containers/food/snacks/adhomian_sausage,
			/obj/item/reagent_containers/food/snacks/avah,
			/obj/item/reagent_containers/food/snacks/chipplate/crownfurter,
			/obj/item/reagent_containers/food/snacks/chipplate/miniavah_basket,
			/obj/item/reagent_containers/food/snacks/chocolate_rikazu,
			/obj/item/reagent_containers/food/snacks/clam_pasta,
			/obj/item/reagent_containers/food/snacks/cone_cake,
			/obj/item/reagent_containers/food/snacks/creamice,
			/obj/item/reagent_containers/food/snacks/dip/sarmikhir,
			/obj/item/reagent_containers/food/snacks/dip/tajhummus,
			/obj/item/reagent_containers/food/snacks/dirt_roast,
			/obj/item/reagent_containers/food/snacks/earthenroot_fries,
			/obj/item/reagent_containers/food/snacks/earthenroot_mash,
			/obj/item/reagent_containers/food/snacks/earthenroot_wedges,
			/obj/item/reagent_containers/food/snacks/fermented_worm,
			/obj/item/reagent_containers/food/snacks/fermented_worm_sandwich,
			/obj/item/reagent_containers/food/snacks/fruit_rikazu,
			/obj/item/reagent_containers/food/snacks/fruitgello,
			/obj/item/reagent_containers/food/snacks/hardbread,
			/obj/item/reagent_containers/food/snacks/hardbread_pudding,
			/obj/item/reagent_containers/food/snacks/lardwich,
			/obj/item/reagent_containers/food/snacks/meat_rikazu,
			/obj/item/reagent_containers/food/snacks/nomadskewer,
			/obj/item/reagent_containers/food/snacks/salad/earthenroot,
			/obj/item/reagent_containers/food/snacks/sarmikhir_sandwich,
			/obj/item/reagent_containers/food/snacks/seafoodmousse,
			/obj/item/reagent_containers/food/snacks/sliceable/aspicfatshouter,
			/obj/item/reagent_containers/food/snacks/sliceable/fatshouter_fillet,
			/obj/item/reagent_containers/food/snacks/sliceable/fatshouterbake,
			/obj/item/reagent_containers/food/snacks/sliceable/vegello,
			/obj/item/reagent_containers/food/snacks/sliceable/zkahnkowafull,
			/obj/item/reagent_containers/food/snacks/soup/earthenroot,
			/obj/item/reagent_containers/food/snacks/soup/tajfish,
			/obj/item/reagent_containers/food/snacks/spicy_clams,
			/obj/item/reagent_containers/food/snacks/stew/tajaran,
			/obj/item/reagent_containers/food/snacks/stuffed_earthenroot,
			/obj/item/reagent_containers/food/snacks/tajaran_bread,
			/obj/item/reagent_containers/food/snacks/tajcandy,
			/obj/item/reagent_containers/food/snacks/tunneler_meategg,
			/obj/item/reagent_containers/food/snacks/tunneler_souffle,
			/obj/item/reagent_containers/food/snacks/vegetable_rikazu)

/datum/bounty/item/chef/skrell
	name = "Federation Delicacies"
	description = "We're holding a luncheon with some Nralakk Federation representatives; send some Skrellian dishes!"
	reward_low = 150
	reward_high = 250
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/chipplate/neaeracandy,
			/obj/item/reagent_containers/food/snacks/fjylozynboiled,
			/obj/item/reagent_containers/food/snacks/gnaqmi,
			/obj/item/reagent_containers/food/snacks/jyalrafresh,
			/obj/item/reagent_containers/food/snacks/konaqu,
			/obj/item/reagent_containers/food/snacks/lortl,
			/obj/item/reagent_containers/food/snacks/neaerakabob,
			/obj/item/reagent_containers/food/snacks/neaeraloaf,
			/obj/item/reagent_containers/food/snacks/qlguabi,
			/obj/item/reagent_containers/food/snacks/soup/qilvo,
			/obj/item/reagent_containers/food/snacks/soup/zantiri,
			/obj/item/reagent_containers/food/snacks/stew/neaera,
			/obj/item/reagent_containers/food/snacks/xuqqil)

/datum/bounty/item/chef/curry
	name = "Curry"
	description = "I forgot that I was supposed to host lunch for an upcoming meeting. Ship me some curry and I'll make sure your station gets a bonus. - %PERSONNAME"
	reward_low = 40
	reward_high = 60
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/redcurry,
			/obj/item/reagent_containers/food/snacks/greencurry,
			/obj/item/reagent_containers/food/snacks/xanu_curry,
			/obj/item/reagent_containers/food/snacks/yellowcurry)

/datum/bounty/item/chef/dip
	name = "Dip"
	description = "It's time for an office party, but %PERSONNAME forgot the dip! Send us some and we'll transfer part of their upcoming bonus to your station's account."
	reward_low = 50
	reward_high = 80
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/dip)

/datum/bounty/item/chef/reuben
	name = "Reuben Sandwich"
	description = "%PERSONNAME had their lunch stolen from the company fridge. Send us a replacement reuben!"
	reward_low = 45
	reward_high = 60
	wanted_types = list(/obj/item/reagent_containers/food/snacks/reubensandwich)

/datum/bounty/item/chef/ravioli
	name = "Ravioli"
	description = "Somehow, %PERSONNAME has never had Ravioli before, so we've decided to do a themed office lunch. Send us some, please."
	reward_low = 80
	reward_high = 120
	required_count = 4
	random_count = 1
	wanted_types = list(
	/obj/item/reagent_containers/food/snacks/ravioli
	)

/datum/bounty/item/chef/ramen
	name = "Ramen Bowl"
	description = "%PERSONNAME thinks that Ramen is the instant, pre-packaged kind you get from machines and has never had the 'real' kind. We've allocated some morale funds to educate them, please send some good examples."
	reward_low = 80
	reward_high = 120
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/ramenbowl, /obj/item/reagent_containers/food/snacks/aoyama_ramen)

/datum/bounty/item/chef/matsuul
	name = "Matsuul"
	description = "After some incidents, we're running a workshop on collaborating in a multi-species workplace. We need a meal that represents collaboration between different species and cultures."
	reward_low = 80
	reward_high = 120
	required_count = 3
	random_count = 1
	wanted_types = list(
	/obj/item/reagent_containers/food/snacks/matsuul
	)
/datum/bounty/item/chef/roulades
	name = "Roulades"
	description = "%PERSONNAME is retiring after many beloved years in the company and we need some tasty treats for the retirement party we're throwing them."
	reward_low = 90
	reward_high = 150
	required_count = 2
	random_count = 1
	wanted_types = list(
	/obj/item/reagent_containers/food/snacks/sliceable/chocolateroulade,
	/obj/item/reagent_containers/food/snacks/sliceable/ylpharoulade,
	/obj/item/reagent_containers/food/snacks/sliceable/koisroulade
	)
