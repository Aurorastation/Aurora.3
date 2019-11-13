/datum/bounty/item/assistant/stunprod
	name = "Stunprod"
	description = "%BOSSSHORT needs to pacify some rioting \"cows\". Craft one, then ship it."
	reward = 1300
	wanted_types = list(/obj/item/melee/baton/cattleprod)

/datum/bounty/item/assistant/soap
	name = "Soap"
	description = "Soap has gone missing from %BOSSSHORT's bathrooms and nobody knows who took it. Replace it and be the hero %BOSSSHORT needs."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/soap)

/datum/bounty/item/assistant/spear
	name = "Spears"
	description = "As part of our cultural appreciation programs, we require a bunch of spears to please a Unathi diplomat. Please send your best!"
	reward = 2000
	required_count = 5
	wanted_types = list(/obj/item/material/twohanded/spear)

/datum/bounty/item/assistant/toolbox
	name = "Toolboxes"
	description = "There's an absence of \"engineering robustness\" at %BOSSNAME. Hurry up and ship some toolboxes as a solution."
	reward = 2000
	required_count = 6
	wanted_types = list(/obj/item/storage/toolbox)

/datum/bounty/item/assistant/statue
	name = "Statue"
	description = "%BOSSNAME would like to commision an artsy statue for the lobby. Ship one out, when possible."
	reward = 2000
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
	reward = 1200
	required_count = 30
	wanted_types = list(/obj/item/reagent_containers/food/snacks/cheesiehonkers)

/datum/bounty/item/assistant/baseball_bat

	name = "Baseball Bat"
	description = "Baseball fever is going on at %BOSSSHORT! Be a dear and ship them some baseball bats, so that management can live out their childhood dream."
	reward = 2000
	required_count = 5
	wanted_types = list(/obj/item/material/twohanded/baseballbat)

/datum/bounty/item/assistant/donut
	name = "Donuts"
	description = "%BOSSSHORT's security forces are demoralized. Ship donuts to raise morale."
	reward = 3000
	required_count = 10
	wanted_types = list(/obj/item/reagent_containers/food/snacks/donut)

/datum/bounty/item/assistant/donkpocket
	name = "Donk-Pockets"
	description = "Consumer safety recall: Warning. Donk-Pockets manufactured in the past year contain hazardous lizard biomatter. Return units to %BOSSSHORT immediately."
	reward = 3000
	required_count = 10
	wanted_types = list(/obj/item/reagent_containers/food/snacks/donkpocket)

/datum/bounty/item/assistant/briefcase
	name = "Briefcase"
	description = "%BOSSNAME will be holding a business convention this year. Ship a few briefcases in support."
	reward = 2500
	required_count = 5
	wanted_types = list(/obj/item/storage/briefcase)

/datum/bounty/item/assistant/sunglasses
	name = "Sunglasses"
	description = "A famous blues duo is passing through the sector, but they've lost their shades and they can't perform. Ship new sunglasses to %BOSSSHORT to rectify this."
	reward = 3000
	required_count = 2
	wanted_types = list(/obj/item/clothing/glasses/sunglasses)

/datum/bounty/item/assistant/monkey_hide
	name = "Monkey Hide"
	description = "One of the scientists at %BOSSSHORT is interested in testing products on monkey skin. Your mission is to acquire monkey's hide and ship it."
	reward = 1500
	wanted_types = list(/obj/item/stack/material/animalhide/monkey)

/datum/bounty/item/assistant/heart
	name = "Heart"
	description = "Commander Johnson is in critical condition after suffering a heart attack. Doctors say he needs a new heart fast. Ship one, pronto!"
	reward = 3000
	wanted_types = list(/obj/item/organ/heart)

/datum/bounty/item/assistant/lung
	name = "Lungs"
	description = "A recent explosion at %BOSSNAME has left multiple staff with punctured lungs. Ship spare lungs to be rewarded."
	reward = 3000
	required_count = 1
	wanted_types = list(/obj/item/organ/lungs)

/datum/bounty/item/assistant/appendix
	name = "Appendix"
	description = "Chef Gibb of %BOSSNAME wants to prepare a traditional Unathi meal using a very special delicacy: an appendix. If you ship one, he'll pay."
	reward = 3000
	wanted_types = list(/obj/item/organ/appendix)

/datum/bounty/item/assistant/shard
	name = "Shards"
	description = "A killer clown has been stalking %BOSSSHORT, and staff have been unable to catch her because she's not wearing shoes. Please ship some shards so that a booby trap can be constructed."
	reward = 1500
	required_count = 15
	wanted_types = list(/obj/item/material/shard)

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
	wanted_types = list(/obj/item/gun/projectile/revolver)

/datum/bounty/item/assistant/hand_tele
	name = "Hand Tele"
	description = "%BOSSNAME has come up with a genius idea: Why not teleport cargo rather than ship it? Send over a hand tele, receive payment, then wait 6-8 years while they deliberate."
	reward = 2000
	wanted_types = list(/obj/item/hand_tele)

/datum/bounty/item/assistant/potted_plants
	name = "Potted Plants"
	description = "%BOSSNAME is looking to decorate their civilian sector. You've been ordered to supply the potted plants."
	reward = 2000
	required_count = 8
	wanted_types = list(/obj/structure/flora/pottedplant)

/datum/bounty/item/assistant/earmuffs
	name = "Earmuffs"
	description = "%BOSSNAME is getting tired of your station's messages. They've ordered that you ship some earmuffs to lessen the annoyance."
	reward = 1000
	wanted_types = list(/obj/item/clothing/ears/earmuffs)

/datum/bounty/item/assistant/handcuffs
	name = "Handcuffs"
	description = "A large influx of escaped convicts have arrived at %BOSSNAME. Now is the perfect time to ship out spare handcuffs."
	reward = 1000
	required_count = 5
	wanted_types = list(/obj/item/handcuffs)

/datum/bounty/item/assistant/monkey_cubes
	name = "Monkey Cubes"
	description = "Due to a recent genetics accident, %BOSSNAME is in serious need of monkeys. Your mission is to ship monkey cubes."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/monkeycube)

/datum/bounty/item/assistant/chainsaw
	name = "Chainsaw"
	description = "The chef at %BOSSSHORT is having trouble butchering her animals. She requests one chainsaw, please."
	reward = 2500
	wanted_types = list(/obj/item/material/twohanded/chainsaw)

/datum/bounty/item/assistant/plasma_tank/
	name = "Full Tank of Plasma"
	description = "Station 12 has requested supplies to set up a singularity engine. In particular, they request 28 moles of plasma."
	reward = 2500
	wanted_types = list(/obj/item/tank)
	var/moles_required = 20 // A full tank is 28 moles, but %BOSSSHORT ignores that fact.

/datum/bounty/item/assistant/plasma_tank/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/tank/T = O
	if(T)
		if(!T.air_contents.gas["phoron"])
			return FALSE
		return T.air_contents.gas["phoron"] >= moles_required
	return FALSE

/datum/bounty/item/chef/action_figures
	name = "Action Figures"
	description = "The vice president's son saw an ad for action figures on the telescreen and now he won't shut up about them. Ship some to ease his complaints."
	reward = 4000
	required_count = 5
	wanted_types = list(/obj/item/toy/figure)

