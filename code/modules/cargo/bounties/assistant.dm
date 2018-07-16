/*
/datum/bounty/item/assistant/strange_object
	name = "Strange Object"
	description = "[current_map.company_name] has taken an interest in strange objects. Find one in maint, and ship it off to [current_map.boss_short] right away."
	reward = 1200
	wanted_types = list(/obj/item/relic)

/datum/bounty/item/assistant/scooter
	name = "Scooter"
	description = "[current_map.company_name] has determined walking to be wasteful. Ship a scooter to [current_map.boss_short] to speed operations up."
	reward = 1080 // the mat hoffman
	wanted_types = list(/obj/vehicle/ridden/scooter)
	include_subtypes = FALSE

/datum/bounty/item/assistant/skateboard
	name = "Skateboard"
	description = "[current_map.company_name] has determined walking to be a wasteful. Ship a skateboard to [current_map.boss_short] to speed operations up."
	reward = 900 // the tony hawk
	wanted_types = list(/obj/vehicle/ridden/scooter/skateboard)
*/
/datum/bounty/item/assistant/stunprod/New()
	..()
	name = "Stunprod"
	description = "[current_map.boss_short] demands a stunprod to use against dissidents. Craft one, then ship it."
	reward = 1300
	wanted_types = list(/obj/item/weapon/melee/baton/cattleprod)

/datum/bounty/item/assistant/soap/New()
	..()
	name = "Soap"
	description = "Soap has gone missing from [current_map.boss_short]'s bathrooms and nobody knows who took it. Replace it and be the hero [current_map.boss_short] needs."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/weapon/soap)

/datum/bounty/item/assistant/spear/New()
	..()
	name = "Spears"
	description = "[current_map.boss_short]'s security forces are going through budget cuts. You will be paid if you ship a set of spears."
	reward = 2000
	required_count = 5
	wanted_types = list(/obj/item/weapon/material/twohanded/spear)

/datum/bounty/item/assistant/toolbox/New()
	..()
	name = "Toolboxes"
	description = "There's an absence of robustness at [current_map.boss_name]. Hurry up and ship some toolboxes as a solution."
	reward = 2000
	required_count = 6
	wanted_types = list(/obj/item/weapon/storage/toolbox)

/datum/bounty/item/assistant/statue/New()
	..()
	name = "Statue"
	description = "[current_map.boss_name] would like to commision an artsy statue for the lobby. Ship one out, when possible."
	reward = 2000
	wanted_types = list(/obj/structure/sculpting_block)

/datum/bounty/item/assistant/statue/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/structure/sculpting_block/S = O
	if(S && S.sculpted)
		return TRUE
	return FALSE

/datum/bounty/item/assistant/cheesiehonkers/New()
	..()
	name = "Cheesie Honkers"
	description = "Apparently the company that makes Cheesie Honkers is going out of business soon. [current_map.boss_short] wants to stock up before it happens!"
	reward = 1200
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers)

/datum/bounty/item/assistant/baseball_bat/New()
	..()
	name = "Baseball Bat"
	description = "Baseball fever is going on at [current_map.boss_short]! Be a dear and ship them some baseball bats, so that management can live out their childhood dream."
	reward = 2000
	required_count = 5
	wanted_types = list(/obj/item/weapon/material/twohanded/baseballbat)

/datum/bounty/item/assistant/donut/New()
	..()
	name = "Donuts"
	description = "[current_map.boss_short]'s security forces are demoralized. Ship donuts to raise morale."
	reward = 3000
	required_count = 10
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donut)

/datum/bounty/item/assistant/donkpocket/New()
	..()
	name = "Donk-Pockets"
	description = "Consumer safety recall: Warning. Donk-Pockets manufactured in the past year contain hazardous lizard biomatter. Return units to [current_map.boss_short] immediately."
	reward = 3000
	required_count = 10
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket)

/datum/bounty/item/assistant/briefcase/New()
	..()
	name = "Briefcase"
	description = "[current_map.boss_name] will be holding a business convention this year. Ship a few briefcases in support."
	reward = 2500
	required_count = 5
	wanted_types = list(/obj/item/weapon/storage/briefcase)

/datum/bounty/item/assistant/sunglasses/New()
	..()
	name = "Sunglasses"
	description = "A famous blues duo is passing through the sector, but they've lost their shades and they can't perform. Ship new sunglasses to [current_map.boss_short] to rectify this."
	reward = 3000
	required_count = 2
	wanted_types = list(/obj/item/clothing/glasses/sunglasses)

/datum/bounty/item/assistant/monkey_hide/New()
	..()
	name = "Monkey Hide"
	description = "One of the scientists at [current_map.boss_short] is interested in testing products on monkey skin. Your mission is to acquire monkey's hide and ship it."
	reward = 1500
	wanted_types = list(/obj/item/stack/material/animalhide/monkey)

/datum/bounty/item/assistant/heart/New()
	..()
	name = "Heart"
	description = "Commander Johnson is in critical condition after suffering a heart attack. Doctors say he needs a new heart fast. Ship one, pronto!"
	reward = 3000
	wanted_types = list(/obj/item/organ/heart)

/datum/bounty/item/assistant/lung/New()
	..()
	name = "Lungs"
	description = "A recent explosion at [current_map.boss_name] has left multiple staff with punctured lungs. Ship spare lungs to be rewarded."
	reward = 3000
	required_count = 1
	wanted_types = list(/obj/item/organ/lungs)

/datum/bounty/item/assistant/appendix/New()
	..()
	name = "Appendix"
	description = "Chef Gibb of [current_map.boss_name] wants to prepare a traditional Unathi meal using a very special delicacy: an appendix. If you ship one, he'll pay."
	reward = 3000
	wanted_types = list(/obj/item/organ/appendix)

/datum/bounty/item/assistant/shard/New()
	..()
	name = "Shards"
	description = "A killer clown has been stalking [current_map.boss_short], and staff have been unable to catch her because she's not wearing shoes. Please ship some shards so that a booby trap can be constructed."
	reward = 1500
	required_count = 15
	wanted_types = list(/obj/item/weapon/material/shard)

/datum/bounty/item/assistant/comfy_chair/New()
	..()
	name = "Comfy Chairs"
	description = "Commander Pat is unhappy with his chair. He claims it hurts his back. Ship some alternatives out to humor him. "
	reward = 1500
	required_count = 5
	wanted_types = list(/obj/structure/bed/chair/comfy)

/datum/bounty/item/assistant/revolver/New()
	..()
	name = "Revolver"
	description = "Captain Johann of station 12 has challenged Captain Vic of station 11 to a duel. He's asked for help securing an appropriate revolver to use."
	reward = 2000
	wanted_types = list(/obj/item/weapon/gun/projectile/revolver)

/datum/bounty/item/assistant/hand_tele/New()
	..()
	name = "Hand Tele"
	description = "[current_map.boss_name] has come up with a genius idea: Why not teleport cargo rather than ship it? Send over a hand tele, receive payment, then wait 6-8 years while they deliberate."
	reward = 2000
	wanted_types = list(/obj/item/weapon/hand_tele)

/datum/bounty/item/assistant/potted_plants/New()
	..()
	name = "Potted Plants"
	description = "[current_map.boss_name] is looking to decorate their civilian sector. You've been ordered to supply the potted plants."
	reward = 2000
	required_count = 8
	wanted_types = list(/obj/structure/flora/pottedplant)

/datum/bounty/item/assistant/earmuffs/New()
	..()
	name = "Earmuffs"
	description = "[current_map.boss_name] is getting tired of your station's messages. They've ordered that you ship some earmuffs to lessen the annoyance."
	reward = 1000
	wanted_types = list(/obj/item/clothing/ears/earmuffs)

/datum/bounty/item/assistant/handcuffs/New()
	..()
	name = "Handcuffs"
	description = "A large influx of escaped convicts have arrived at [current_map.boss_name]. Now is the perfect time to ship out spare handcuffs."
	reward = 1000
	required_count = 5
	wanted_types = list(/obj/item/weapon/handcuffs)

/datum/bounty/item/assistant/monkey_cubes/New()
	..()
	name = "Monkey Cubes"
	description = "Due to a recent genetics accident, [current_map.boss_name] is in serious need of monkeys. Your mission is to ship monkey cubes."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)

/datum/bounty/item/assistant/chainsaw/New()
	..()
	name = "Chainsaw"
	description = "The chef at [current_map.boss_short] is having trouble butchering her animals. She requests one chainsaw, please."
	reward = 2500
	wanted_types = list(/obj/item/weapon/material/twohanded/chainsaw)

/*
/datum/bounty/item/assistant/ied/New()
	..()
	name = "IED"
	description = "[current_map.company_name]'s maximum security prison at [current_map.boss_short] is undergoing personnel training. Ship a handful of IEDs to serve as a training tools."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/grenade/iedcasing)
*/

/datum/bounty/item/assistant/plasma_tank/
	..()
	name = "Full Tank of Plasma"
	description = "Station 12 has requested supplies to set up a singularity engine. In particular, they request 28 moles of plasma."
	reward = 2500
	wanted_types = list(/obj/item/weapon/tank)
	var/moles_required = 20 // A full tank is 28 moles, but [current_map.boss_short] ignores that fact.

/datum/bounty/item/assistant/plasma_tank/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/weapon/tank/T = O
	if(T)
		if(!T.air_contents.gas["phoron"])
			return FALSE
		return T.air_contents.gas["phoron"] >= moles_required
	return FALSE

/datum/bounty/item/assistant/corgimeat/New()
	..()
	name = "Raw Corgi Meat"
	description = "The Syndicate recently stole all of [current_map.boss_short]'s corgi meat. Ship out a replacement immediately."
	reward = 3000
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/meat/corgi)

/datum/bounty/item/chef/action_figures/New()
	..()
	name = "Action Figures"
	description = "The vice president's son saw an ad for action figures on the telescreen and now he won't shut up about them. Ship some to ease his complaints."
	reward = 4000
	required_count = 5
	wanted_types = list(/obj/item/toy/figure)

