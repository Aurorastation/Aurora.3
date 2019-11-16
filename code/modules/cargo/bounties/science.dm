/datum/bounty/item/science/boh
	name = "Bag of Holding"
	description = "%COMPNAME would make good use of high-capacity backpacks. If you have any, please ship them."
	reward = 10000
	wanted_types = list(/obj/item/storage/backpack/holding)
/*
/datum/bounty/item/science/tboh
	name = "Trash Bag of Holding"
	description = "%COMPNAME would make good use of high-capacity trash bags. If you have any, please ship them."
	reward = 10000
	wanted_types = list(/obj/item/storage/backpack/holding)

/datum/bounty/item/science/bluespace_syringe
	name = "Bluespace Syringe"
	description = "%COMPNAME would make good use of high-capacity syringes. If you have any, please ship them."
	reward = 10000
	wanted_types = list(/obj/item/reagent_containers/syringe/bluespace)

/datum/bounty/item/science/bluespace_body_bag
	name = "Bluespace Body Bag"
	description = "%COMPNAME would make good use of high-capacity body bags. If you have any, please ship them."
	reward = 10000
	wanted_types = list(/obj/item/bodybag/bluespace)
*/
/datum/bounty/item/science/nightvision_goggles
	name = "Night Vision Goggles"
	description = "An electrical storm has busted all the lights at %BOSSSHORT. While management is waiting for replacements, perhaps some night vision goggles can be shipped?"
	reward = 10000
	wanted_types = list(/obj/item/clothing/glasses/night)

/datum/bounty/item/science/experimental_welding_tool
	name = "Experimental Welding Tool"
	description = "A recent accident has left most of %BOSSSHORT's welding tools exploded. Ship replacements to be rewarded."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/weldingtool/experimental)

/datum/bounty/item/science/cryostasis_beaker
	name = "Cryostasis Beaker"
	description = "Chemists at %BOSSNAME have discovered a new chemical that can only be held in cryostasis beakers. The only problem is they don't have any! Rectify this to receive payment."
	reward = 10000
	wanted_types = list(/obj/item/reagent_containers/glass/beaker/noreact)

/datum/bounty/item/science/mech_diamond_drill
	name = "Mech Diamond Mining Drill"
	description = "%BOSSNAME is willing to pay three months salary in exchange for one mech diamond mining drill."
	reward = 15000
	wanted_types = list(/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill)

/datum/bounty/item/science/advanced_egun
	name = "Advanced Energy Gun"
	description = "With the price of rechargers on the rise, upper management is interested in purchasing guns that are self-powered. If you ship one, they'll pay."
	reward = 10000
	wanted_types = list(/obj/item/gun/energy/gun/nuclear)

/datum/bounty/item/science/posibrain
	name = "Posibrain"
	description = "Due to a sudden spike in assistants-related accidents management has decided to replace some of them with borgs. Ship us 2 posibrains."
	reward = 10000
	required_count = 2
	wanted_types = list(/obj/item/device/mmi/digital/posibrain)

/datum/bounty/item/science/borgbody
	name = "Robot Endoskeleton"
	description = "Due to a sudden spike in assistants-related accidents management has decided to replace some of them with borgs. Ship us fully assembled robot endoskeletons without a mmi/posibrain inside of it."
	reward = 10000
	required_count = 2
	wanted_types = list(/obj/item/robot_parts/robot_suit)

/datum/bounty/item/science/borgbody/halstre
	description = "Due to the borging of Kalren Halstre, we require you to ship us one fully assembled cyborg endoskeleton without a mmi/posibrain inside of it"
	required_count = 1

/datum/bounty/item/science/borgbody/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/robot_parts/robot_suit/S = O
	if(S && S.l_leg && S.r_leg && S.l_arm && S.r_arm && S.chest && S.head)
		return TRUE
	return FALSE

/datum/bounty/item/science/borgbody/compatible_with(datum/other_bounty)
	if(!..())
		return FALSE
	var/datum/bounty/item/other_item_bounty = other_bounty
	if(other_bounty && /obj/item/robot_parts/robot_suit in other_item_bounty.wanted_types)
		return FALSE
	return TRUE