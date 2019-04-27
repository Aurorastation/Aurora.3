/datum/bounty/item/assistant/stunprod
	name = "Stunprod"
	description = "%BOSSSHORT needs a custom-built stun prod. Craft one, then ship it."
	reward = 130
	wanted_types = list(/obj/item/weapon/melee/baton/cattleprod)

/datum/bounty/item/assistant/soap
	name = "Soap"
	description = "Soap has gone missing from %BOSSSHORT's bathrooms. Replace it %BOSSSHORT will reward you."
	reward = 200
	required_count = 3
	wanted_types = list(/obj/item/weapon/soap)

/datum/bounty/item/assistant/spear
	name = "Spears"
	description = "As part of our cultural appreciation programs, we require handcrafted spears to please a Unathi diplomat. Please send your best!"
	reward = 500
	required_count = 5
	wanted_types = list(/obj/item/weapon/material/twohanded/spear)

/datum/bounty/item/assistant/toolbox
	name = "Toolboxes"
	description = "There's an shortage of tools at %BOSSNAME. Hurry up and ship some toolboxes as a solution."
	reward = 600
	required_count = 6
	wanted_types = list(/obj/item/weapon/storage/toolbox)

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
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers)

/datum/bounty/item/assistant/baseball_bat

	name = "Baseball Bat"
	description = "Baseball fever is going on at %BOSSSHORT! Be a dear and ship them some baseball bats, so that management won't be without a centerpiece for their collections."
	reward = 500
	required_count = 5
	wanted_types = list(/obj/item/weapon/material/twohanded/baseballbat)

/datum/bounty/item/assistant/donut
	name = "Donuts"
	description = "%BOSSSHORT's security forces are demoralized. Ship donuts to raise morale."
	reward = 200
	required_count = 10
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donut)

/datum/bounty/item/assistant/donkpocket
	name = "Donk-Pockets"
	description = "Consumer safety recall: Warning. Donk-Pockets manufactured in the past year contain hazardous lizard biomatter. Return units to %BOSSSHORT immediately."
	reward = 250
	required_count = 10
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket)

/datum/bounty/item/assistant/briefcase
	name = "Briefcase"
	description = "%BOSSNAME will be holding a business convention this year. Ship a few briefcases in support."
	reward = 250
	required_count = 5
	wanted_types = list(/obj/item/weapon/storage/briefcase)

/datum/bounty/item/assistant/monkey_hide
	name = "Monkey Hide"
	description = "One of the scientists at %BOSSSHORT is interested in testing products on monkey skin. Your mission is to acquire monkey's hide and ship it."
	reward = 500
	wanted_types = list(/obj/item/stack/material/animalhide/monkey)

/datum/bounty/item/assistant/heart
	name = "Heart"
	description = "Commander Johnson is in critical condition after suffering a heart attack. Doctors say he needs a new heart fast. Ship one, pronto!"
	reward = 1500
	wanted_types = list(/obj/item/organ/heart)

/datum/bounty/item/assistant/lung
	name = "Lungs"
	description = "A recent explosion at %BOSSNAME has left multiple staff with punctured lungs. Ship spare lungs to be rewarded."
	reward = 1500
	required_count = 1
	wanted_types = list(/obj/item/organ/lungs)

/datum/bounty/item/assistant/comfy_chair
	name = "Comfy Chairs"
	description = "Commander Pat is unhappy with his chair. He claims it hurts his back. Ship some alternatives out, please. "
	reward = 200
	required_count = 5
	wanted_types = list(/obj/structure/bed/chair/comfy)

/datum/bounty/item/assistant/revolver
	name = "Revolver"
	description = "One of our Lead Investigators lost their revolver. He's asked for help securing an appropriate replacement."
	reward = 750
	wanted_types = list(/obj/item/weapon/gun/projectile/revolver)

/datum/bounty/item/assistant/potted_plants
	name = "Potted Plants"
	description = "%BOSSNAME is looking to decorate their civilian sector. You've been ordered to supply the potted plants."
	reward = 800
	required_count = 8
	wanted_types = list(/obj/structure/flora/pottedplant)

/datum/bounty/item/assistant/handcuffs
	name = "Handcuffs"
	description = "A large influx of escaped convicts have arrived at %BOSSNAME. Please ship out some spare handcuffs."
	reward = 500
	required_count = 5
	wanted_types = list(/obj/item/weapon/handcuffs)

/datum/bounty/item/assistant/chainsaw
	name = "Chainsaw"
	description = "The gardener at %BOSSSHORT is having trouble with bushes. She requests one chainsaw, please."
	reward = 750
	wanted_types = list(/obj/item/weapon/material/twohanded/chainsaw)

/datum/bounty/item/assistant/plasma_tank/
	name = "Full Tank of Plasma"
	description = "%BOSSNAME has requested phoron supplies. In particular, they require 28 moles of plasma."
	reward = 1500
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


