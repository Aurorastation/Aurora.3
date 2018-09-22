/datum/bounty/item/assistant/stunprod
	name = "Stunprod"
	description = "%BOSSSHORT needs to pacify some rioting \"cows\". Craft one, then ship it."
	reward = 1300
	wanted_types = list(/obj/item/weapon/melee/baton/cattleprod)

/datum/bounty/item/assistant/soap
	name = "Soap"
	description = "Soap has gone missing from %BOSSSHORT's bathrooms and nobody knows who took it. Replace it and be the hero %BOSSSHORT needs."
	reward = 4000
	required_count = 12
	wanted_types = list(/obj/item/weapon/soap)

/datum/bounty/item/assistant/toolbox
	name = "Toolboxes"
	description = "There's an absence of \"engineering robustness\" at %BOSSNAME. Hurry up and ship some toolboxes as a solution."
	reward = 2000
	required_count = 6
	wanted_types = list(/obj/item/weapon/storage/toolbox)

/datum/bounty/item/assistant/statue
	name = "Statue"
	description = "%BOSSNAME would like to commision an artsy statue for the lobby. Ship one out, when possible. We'll send out some kinetic accelerators as compensation."
	reward = 0
	reward_id = "miner_ka"
	wanted_types = list(/obj/structure/sculpting_block)

/datum/bounty/item/assistant/statue/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/structure/sculpting_block/S = O
	if(S && S.sculpted)
		return TRUE
	return FALSE

/datum/bounty/item/assistant/cheesiehonkers
	name = "Cheesie Honkers"
	description = "Apparently the company that makes Cheesie Honkers is going out of business soon. %BOSSSHORT wants to stock up before it happens!"
	reward = 2400
	required_count = 30
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers)

/datum/bounty/item/assistant/baseball_bat
	name = "Baseball Bat"
	description = "Baseball fever is going on at %BOSSSHORT! Be a dear and ship them some baseball bats, so that management can live out their childhood dream."
	reward = 2000
	required_count = 5
	wanted_types = list(/obj/item/weapon/material/twohanded/baseballbat)

/datum/bounty/item/assistant/donut
	name = "Donuts"
	description = "%BOSSSHORT's security forces are demoralized. Ship donuts to raise morale."
	reward = 3000
	required_count = 12
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donut)

/datum/bounty/item/assistant/donkpocket
	name = "Donk-Pockets"
	description = "Consumer safety recall: Warning. Donk-Pockets manufactured in the past year contain hazardous lizard biomatter. Return units to %BOSSSHORT immediately."
	reward = 3000
	required_count = 12
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket)

/datum/bounty/item/assistant/sunglasses
	name = "Sunglasses"
	description = "A famous blues duo is passing through the sector, but they've lost their shades and they can't perform. Ship new sunglasses to %BOSSSHORT to rectify this."
	reward = 3000
	required_count = 2
	wanted_types = list(/obj/item/clothing/glasses/sunglasses)

/datum/bounty/item/assistant/heart
	name = "Heart"
	description = "%BOSSSHORT requres a heart for a special science project. Please ship one when you have the chance."
	reward = 3000
	wanted_types = list(/obj/item/organ/heart)

/datum/bounty/item/assistant/lung
	name = "Lungs"
	description = "Instead of wasting money on valuable chemicals, %BOSSNAME wishes to stock up on spare lungs in case of an accident."
	reward = 9000
	required_count = 2
	wanted_types = list(/obj/item/organ/lungs)

/datum/bounty/item/assistant/appendix
	name = "Appendix"
	description = "Chef Gibb of %BOSSNAME wants to prepare a traditional Unathi meal using a very special delicacy: an appendix. If you ship one, he'll pay."
	reward = 3000
	wanted_types = list(/obj/item/organ/appendix)

/datum/bounty/item/assistant/comfy_chair
	name = "Comfy Chairs"
	description = "Commander Pat is unhappy with his chair. He claims it hurts his back. Ship some alternatives out to humor him. "
	reward = 1500
	required_count = 5
	wanted_types = list(/obj/structure/bed/chair/comfy)

/datum/bounty/item/assistant/revolver
	name = "Revolver"
	description = "One of our Lead Investigators lost their revolver. He's asked for help securing an appropriate replacement."
	reward = 2000
	wanted_types = list(/obj/item/weapon/gun/projectile/revolver)

/datum/bounty/item/assistant/hand_tele
	name = "Hand Tele"
	description = "%BOSSNAME has come up with a genius idea: Why not teleport cargo rather than ship it? Send over a hand tele, receive payment, then wait 6-8 years while they deliberate."
	reward = 2000
	wanted_types = list(/obj/item/weapon/hand_tele)

/datum/bounty/item/assistant/potted_plants
	name = "Potted Plants"
	description = "%BOSSNAME is looking to decorate their civilian sector. You've been ordered to supply the potted plants."
	reward = 2000
	required_count = 8
	wanted_types = list(/obj/structure/flora/pottedplant)

/datum/bounty/item/assistant/earmuffs
	name = "Earmuffs"
	description = "The Head of Security of a sister station has trouble sleeping on the job. Please remedy this by sending them some earmuffs."
	reward = 1000
	wanted_types = list(/obj/item/clothing/ears/earmuffs)

/datum/bounty/item/assistant/handcuffs
	name = "Handcuffs"
	description = "A large influx of transfering convicts have arrived at %BOSSNAME. Please send us some of your spare handcuffs, as we may not have enough."
	reward = 3000
	required_count = 10
	wanted_types = list(/obj/item/weapon/handcuffs)

/datum/bounty/item/assistant/monkey_cubes
	name = "Monkey Cubes"
	description = "Due to a recent genetics accident, %BOSSNAME is in serious need of monkeys. Your mission is to ship monkey cubes."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)

/datum/bounty/item/assistant/chainsaw
	name = "Chainsaw"
	description = "The chef at %BOSSSHORT is having trouble butchering her animals. She requests one chainsaw, please."
	reward = 2500
	wanted_types = list(/obj/item/weapon/material/twohanded/chainsaw)

/datum/bounty/item/assistant/plasma_tank/
	name = "Full Tank of Plasma"
	description = "Station 12 has requested supplies to set up a singularity engine. In particular, they request 28 moles of plasma."
	reward = 2500
	wanted_types = list(/obj/item/weapon/tank)
	var/moles_required = 20 // A full tank is 28 moles, but %BOSSSHORT ignores that fact.

/datum/bounty/item/assistant/plasma_tank/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/weapon/tank/T = O
	if(T)
		if(!T.air_contents.gas["phoron"])
			return FALSE
		return T.air_contents.gas["phoron"] >= moles_required
	return FALSE

/datum/bounty/item/assistant/action_figures
	name = "Action Figures"
	description = "The vice president's son saw an ad for action figures on the telescreen and now he won't shut up about them. Ship some to ease his complaints."
	reward = 4000
	required_count = 5
	wanted_types = list(/obj/item/toy/figure)

