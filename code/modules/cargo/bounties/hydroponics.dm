//Hydro bounties. Things that can be biogenerated and stuff
/datum/bounty/item/hydroponicist/potato_cells
	name = "Potato Batteries"
	description = "%BOSSNAME is researching an environmentally-friendly power source on another station. Send us some potato batteries."
	reward_low = 20
	reward_high = 30
	required_count = 6
	random_count = 3
	wanted_types = list(/obj/item/cell/potato)

/datum/bounty/item/hydroponicist/ert
	name = "Rations"
	description = "%BOSSSHORT is sending ERT out on a long mission. We need something for them to eat!"
	reward_low = 22
	reward_high = 28
	required_count = 6
	random_count = 2
	wanted_types = list(/obj/item/reagent_containers/food/snacks/liquidfood, /obj/item/pen/crayon, /obj/item/storage/field_ration)

/datum/bounty/item/hydroponicist/towels
	name = "Towels"
	description = "%BOSSSHORT is having the sickest pool party ever. Send us some towels for a reward, and maybe an invitation!"
	reward_low = 30
	reward_high = 35
	required_count = 8
	random_count = 3
	wanted_types = list(/obj/item/towel, /obj/item/towel_flat)

/datum/bounty/item/hydroponicist/gloves
	name = "Botanical Gloves"
	description = "%BOSSNAME is participating in a massive tree-planting initiative on Biesel. Help us help the company's image by sending our volunteers some gardening gloves!"
	reward_low = 22
	reward_high = 30
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/clothing/gloves/botanic_leather)

/datum/bounty/item/hydroponicist/flower_crown
	name = "Flower Crowns"
	description = "It's time for the monthly %COMPNAME company dance. This month's theme is floral in nature, so send us some flower crowns to give to attendees."
	reward_low = 36
	reward_high = 44
	required_count = 6
	random_count = 2
	wanted_types = list(/obj/item/clothing/head/sunflower_crown, /obj/item/clothing/head/lavender_crown, /obj/item/clothing/head/poppy_crown)

/datum/bounty/item/assistant/animal_cubes
	name = "Xeno Cubes"
	description = "Monkeys are very limiting for xenostudies research. Please ship some alternative cubes (wrapped) to alleviate a shortage experienced by our other labs."
	reward_low = 20
	reward_high = 26
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube,
				/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube,
				/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube,
				/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube)

/datum/bounty/item/hydroponicist/random_produce
	name = "Produce"
	description = "%BOSSNAME is in need of a bundle of fresh produce for an upcoming luncheon. Send your best!"
	reward_low = 30
	reward_high = 37
	required_count = 12 
	random_count = 5
	wanted_types = list(/obj/item/reagent_containers/food/snacks/grown)
	var/datum/seed/wanted_produce 

/datum/bounty/item/hydroponicist/random_produce/New()
	..()
	var/list/produce_picks = list()
	var/list/forbidden = list(/datum/seed/berry/poison, 
				/datum/seed/nettle, 
				/datum/seed/tomato, 
				/datum/seed/realeggplant, 
				/datum/seed/tomato, 
				/datum/seed/koisspore,
				/datum/seed/koisspore/black,
				/datum/seed/mushroom/mold,
				/datum/seed/mushroom/poison,
				/datum/seed/mushroom/ghost,
				/datum/seed/weeds,
				/datum/seed/kudzu,
				/datum/seed/diona,
				/datum/seed/tobacco,
				/datum/seed/flower)
	for(var/datum/seed/S in subtypesof(/datum/seed))
		if(locate(S) in forbidden)
			continue
		produce_picks += S
	var/chosen = pick(produce_picks)
	wanted_produce = new chosen
	name = wanted_produce.seed_name

/datum/bounty/item/hydroponicist/random_produce/applies_to(obj/O)
	if(!istype(O, /obj/item/reagent_containers/food/snacks/grown))
		return FALSE
	var/obj/item/reagent_containers/food/snacks/grown/G = O
	if(G.bitecount > 0)
		return FALSE
	if(G.seed == wanted_produce)
		return TRUE
	else
		world << "Unequal wants. produce seed is [G.seed] and wanted_produce is [wanted_produce]"
	return FALSE