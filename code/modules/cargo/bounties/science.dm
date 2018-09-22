/datum/bounty/item/science/boh
	name = "Bag of Holding"
	description = "%COMPNAME would make good use of high-capacity backpacks. If you have any, please ship them."
	reward = 10000
	wanted_types = list(/obj/item/weapon/storage/backpack/holding)

/datum/bounty/item/science/experimental_welding_tool
	name = "Experimental Welding Tool"
	description = "A recent accident has left most of %BOSSSHORT's welding tools exploded. Ship replacements to be rewarded."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/weapon/weldingtool/experimental)

/datum/bounty/item/science/cryostasis_beaker
	name = "Cryostasis Beaker"
	description = "Chemists at %BOSSNAME have discovered a new chemical that can only be held in cryostasis beakers. The only problem is they don't have any! Rectify this to receive payment."
	reward = 10000
	wanted_types = list(/obj/item/weapon/reagent_containers/glass/beaker/noreact)

/datum/bounty/item/science/mech_diamond_drill
	name = "Mech Diamond Mining Drill"
	description = "%BOSSNAME is willing to pay three months salary in exchange for one mech diamond mining drill."
	reward = 15000
	wanted_types = list(/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill)

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