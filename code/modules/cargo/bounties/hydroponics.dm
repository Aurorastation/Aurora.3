//Hydro bounties. Things that can be biogenerated and stuff
/datum/bounty/item/hydroponicist/potato_cells
	name = "Potato Batteries"
	description = "%BOSSNAME is researching an environmentally-friendly power source on another station. Send us some potato batteries."
	reward_low = 200
	reward_high = 300
	required_count = 6
	random_count = 3
	wanted_types = list(/obj/item/cell/potato)

/datum/bounty/item/hydroponicist/ert
	name = "Rations"
	description = "%BOSSSHORT is sending ERT out on a long mission. We need some long-lasting rations for them to eat!"
	reward_low = 220
	reward_high = 280
	required_count = 6
	random_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/liquidfood, /obj/item/pen/crayon)

/datum/bounty/item/hydroponicist/towels
	name = "Towels"
	description = "%BOSSSHORT is having the sickest pool party ever. Send us some towels for a reward, and maybe an invitation!"
	reward_low = 300
	reward_high = 350
	required_count = 8
	random_count = 3
	wanted_types = list(/obj/item/towel, /obj/item/towel_flat)

/datum/bounty/item/hydroponicist/gloves
	name = "Botanical Gloves"
	description = "%BOSSNAME is participating in a massive tree-planting initiative on Biesel. Help us help the company's image by sending our volunteers some gardening gloves!"
	reward_low = 50
	reward_high = 80
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/clothing/gloves/botanic_leather)

/datum/bounty/item/hydroponicist/flower_crown
	name = "Flower Crowns"
	description = "It's time for the monthly %COMPNAME company dance. This month's theme is floral in nature, so send us some flower crowns to give to attendees."
	reward_low = 360
	reward_high = 440
	required_count = 6
	random_count = 2
	wanted_types = list(/obj/item/clothing/head/sunflower_crown, /obj/item/clothing/head/lavender_crown, /obj/item/clothing/head/poppy_crown)

/datum/bounty/item/assistant/animal_cubes
	name = "Xeno Cubes"
	description = "Monkeys are very limiting for xenostudies research. Please ship some alternative cubes (wrapped) to alleviate a shortage experienced by our other labs."
	reward_low = 200
	reward_high = 260
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube,
				/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube,
				/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube,
				/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube)

/datum/bounty/item/hydroponicist/produce
	name = "Produce - Any"
	description = "%BOSSNAME is in need of a bundle of fresh produce. Send your best!"
	reward_low = 250
	reward_high = 500
	required_count = 18
	random_count = 5
	wanted_types = list(/obj/item/reagent_containers/food/snacks/grown)
	var/list/produce_picks = list(/datum/seed)

/datum/bounty/item/hydroponicist/produce/applies_to(var/obj/item/reagent_containers/food/snacks/grown/O)
	if(!istype(O))
		return FALSE
	if(O.bitecount > 0) //still not accepting partially-eaten food
		return FALSE
	if(is_type_in_list(O.seed, produce_picks)) //check if it's a type we want.
		return TRUE
	return FALSE

/datum/bounty/item/hydroponicist/produce/fruit
	name = "Produce - Fruit"
	description = "%BOSSNAME is in need of a bundle of fresh fruit. Send your best!"
	required_count = 12
	random_count = 3
	produce_picks = list(/datum/seed/tomato,
				/datum/seed/berry,
				/datum/seed/apple,
				/datum/seed/grapes,
				/datum/seed/banana,
				/datum/seed/watermelon,
				/datum/seed/citrus,
				/datum/seed/cherries,
				/datum/seed/dirtberries,
				/datum/seed/dyn,
				/datum/seed/wulumunusha,
				/datum/seed/sugartree)

/datum/bounty/item/hydroponicist/produce/mushroom
	name = "Produce - Mushrooms"
	description = "%BOSSNAME is in need of some fresh mushrooms. Send your best!"
	required_count = 15
	random_count = 3
	produce_picks = list(/datum/seed/mushroom)

/datum/bounty/item/hydroponicist/produce/tobacco
	name = "Produce - Tobacco"
	description = "%BOSSNAME is in need of some fresh tobacco leaves. Send your best!"
	required_count = 10
	random_count = 2
	produce_picks = list(/datum/seed/tobacco)

/datum/bounty/item/hydroponicist/produce/rice
	name = "Produce - Rice"
	description = "They ran out of rice at %COMPNAME headquarters here in Mendell. Send them enough to hold them over until next quarter."
	required_count = 25
	random_count = 5
	produce_picks = list(/datum/seed/rice)

/datum/bounty/item/hydroponicist/goldstars
	name = "Stickers - Gold Stars"
	description = "We're getting ready for the quarterly %COMPNAME employee evaluation. Send us some gold stars so we can really let our employees know how valuable they are."
	reward_low = 55
	reward_high = 75
	required_count = 6
	random_count = 2
	wanted_types = list(/obj/item/storage/stickersheet/goldstar)

/datum/bounty/item/hydroponicist/stuffedanimals
	name = "Toys - Stuffed Animals"
	description = "We had to recall some products recently for being highly carcinogenic. To help with optics, we're hosting a toy drive for the handful of children's cancer hospitals in Mendell. Get us some stuffed animals for it."
	reward_low = 180
	reward_high = 280
	required_count = 8
	random_count = 2
	wanted_types = list(
		/obj/item/toy/plushie/ian,
		/obj/item/toy/plushie/drone,
		/obj/item/toy/plushie/carp,
		/obj/item/toy/plushie/beepsky,
		/obj/item/toy/plushie/ivancarp,
		/obj/item/toy/plushie/nymph,
		/obj/item/toy/plushie/mouse,
		/obj/item/toy/plushie/kitten,
		/obj/item/toy/plushie/lizard,
		/obj/item/toy/plushie/spider,
		/obj/item/toy/plushie/farwa,
		/obj/item/toy/plushie/bear,
		/obj/item/toy/plushie/bearfire,
		/obj/item/toy/plushie/schlorrgo,
		/obj/item/toy/plushie/coolschlorrgo,
		/obj/item/toy/plushie/slime,
		/obj/item/toy/plushie/bee,
		/obj/item/toy/plushie/shark,
		/obj/item/toy/plushie/greimorian,
		/obj/item/toy/plushie/herring_gull,
		/obj/item/toy/plushie/cockatoo,
		/obj/item/toy/plushie/norinori,
		/obj/item/toy/plushie/fox,
		/obj/item/toy/plushie/fox/black,
		/obj/item/toy/plushie/fox/marble,
		/obj/item/toy/plushie/fox/blue,
		/obj/item/toy/plushie/fox/orange,
		/obj/item/toy/plushie/fox/coffee,
		/obj/item/toy/plushie/fox/pink,
		/obj/item/toy/plushie/fox/purple,
		/obj/item/toy/plushie/fox/crimson,
		/obj/item/toy/plushie/axic,
		/obj/item/toy/plushie/qill,
		/obj/item/toy/plushie/xana,
		/obj/item/toy/plushie/ipc,
		/obj/item/toy/plushie/domadice,
		/obj/item/toy/plushie/squid
		)
