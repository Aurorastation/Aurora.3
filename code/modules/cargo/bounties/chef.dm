/datum/bounty/item/chef/birthday_cake
	name = "Birthday Cake"
	description = "Miranda Trasen's birthday is coming up! Ship a complete birthday cake to celebrate!"
	reward = 4000
	wanted_types = list(
		/obj/item/weapon/reagent_containers/food/snacks/variable/cake,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cake)

/datum/bounty/item/chef/soup
	name = "Soup"
	description = "To quell the homeless uprising, Nanotrasen will be serving soup to all underpaid workers. Ship any type of soup."
	reward = 3000
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/soup)

/datum/bounty/item/chef/popcorn
	name = "Popcorn Bags"
	description = "Upper management wants to host a movie night. Ship bags of popcorn for the occasion."
	reward = 3000
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/popcorn)

/datum/bounty/item/chef/icecreamsandwich
	name = "Ice Cream Sandwiches"
	description = "The Air Conditioning System in the CCIA Offices has failed. Ship some icecream."
	reward = 4000
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich)
/*
/datum/bounty/item/chef/bread
	name = "Bread"
	description = "Problems with central planning have led to bread prices skyrocketing. Ship some bread to ease tensions."
	reward = 1000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/store/bread, /obj/item/weapon/reagent_containers/food/snacks/breadslice, /obj/item/weapon/reagent_containers/food/snacks/bun, /obj/item/weapon/reagent_containers/food/snacks/pizzabread, /obj/item/weapon/reagent_containers/food/snacks/rawpastrybase) 
*/
/datum/bounty/item/chef/pie
	name = "Pie"
	description = "3.14159? No! CentCom management wants edible pie! Ship a whole one."
	reward = 3142
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/pie)

/datum/bounty/item/chef/salad
	name = "Salad or Rice Bowls"
	description = "CentCom management is going on a health binge. Your order is to ship salad or rice bowls."
	reward = 3000
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/salad)

/datum/bounty/item/chef/carrotfries
	name = "Carrot Fries"
	description = "Night sight can mean life or death! A shipment of carrot fries is the order."
	reward = 3500
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/carrotfries)

/datum/bounty/item/chef/superbite
	name = "Super Bite Burger"
	description = "Commander Tubbs thinks he can set a competitive eating world record. All he needs is a super bite burger shipped to him."
	reward = 12000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/burger/superbite)

/datum/bounty/item/chef/poppypretzel
	name = "Poppy Pretzel"
	description = "Central Command needs a reason to fire their HR head. Send over a poppy pretzel to force a failed drug test."
	reward = 3000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/poppypretzel)

/datum/bounty/item/chef/cubancarp
	name = "Cuban Carp"
	description = "A Adhomai Representative is visiting CentCom. Ship one cuban carp."
	reward = 8000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/cubancarp)

/datum/bounty/item/chef/hotdog
	name = "Hot Dog"
	description = "Nanotrasen is conducting taste tests to determine the best hot dog recipe. Ship your station's version to participate."
	reward = 8000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/hotdog)

/datum/bounty/item/chef/lemon
	name = "Lemons"
	description = "A commander claims he can turn lemons into money. Ship him a few and he'll deposit the money into the station's account."
	reward = 4444
	required_count = 10
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/grown)

/datum/bounty/item/chef/lemon/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/weapon/reagent_containers/food/snacks/grown/L = O
	if(L && L.plantname == "lemon")
		return TRUE
	return FALSE	

/datum/bounty/item/chef/eggplantparm
	name = "Eggplant Parmigianas"
	description = "A famous singer will be arriving at CentCom, and their contract demands that they only be served Eggplant Parmigiana. Ship some, please!"
	reward = 3500
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/eggplantparm)

/datum/bounty/item/chef/muffin
	name = "Muffins"
	description = "The Muffin Man is visiting CentCom, but he's forgotten his muffins! Your order is to rectify this."
	reward = 3000
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/muffin)

/datum/bounty/item/chef/chawanmushi
	name = "Chawanmushi"
	description = "Someone from middle-management mentioned Chawanmushi. We never tried them so we need you to ship Chawanmushi immediately."
	reward = 8000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/chawanmushi)

/datum/bounty/item/chef/kebab
	name = "Kebabs"
	description = "Remove all kebab from station you are best food. Ship to CentCom to remove from the premises."
	reward = 3500
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/variable/kebab)

/datum/bounty/item/chef/soylentgreen
	name = "Soylent Green"
	description = "CentCom has heard wonderful things about the product 'Soylent Green', and would love to try some. If you endulge them, expect a pleasant bonus."
	reward = 5000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/soylentgreen)

/datum/bounty/item/chef/pancakes
	name = "Pancakes"
	description = "Here at Nanotrasen we consider employees to be family. And you know what families love? Pancakes. Ship a baker's dozen."
	reward = 5000
	required_count = 13
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/pancakes)

/datum/bounty/item/chef/nuggies
	name = "Chicken Nuggets"
	description = "The vice president's son won't shut up about chicken nuggies. Would you mind shipping some?"
	reward = 4000
	required_count = 6
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/nugget)

