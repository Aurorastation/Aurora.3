/datum/bounty/item/science/boh
	name = "Bag of Holding"
	description = "%COMPNAME would make good use of high-capacity backpacks. If you have any, please ship them."
	reward = 10000
	wanted_types = list(/obj/item/storage/backpack/holding)

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

/datum/bounty/item/science/advanced_egun
	name = "Advanced Energy Gun"
	description = "With the price of rechargers on the rise, upper management is interested in purchasing guns that are self-powered. If you ship one, they'll pay."
	reward = 10000
	wanted_types = list(/obj/item/gun/energy/gun/nuclear)

/datum/bounty/item/science/posibrain
	name = "Posibrain"
	description = "Due to a sudden spike in accidents management has decided to replace some of the staff with borgs. Ship us 2 posibrains."
	reward = 10000
	required_count = 2
	wanted_types = list(/obj/item/device/mmi/digital/posibrain)

/datum/bounty/item/science/borgbody
	name = "Robot Endoskeleton"
	description = "Due to a sudden spike in assistants-related accidents management has decided to replace some of them with borgs. Ship us fully assembled robot endoskeletons without a mmi/posibrain inside of it."
	reward = 10000
	required_count = 2
	wanted_types = list(/obj/item/robot_parts/robot_suit)

/datum/bounty/item/science/circuitboard
	name = "Telecomms Monitor Circuitboard"
	description = "Due to a hardware failure, %COMPNAME requires a new circuit board to replace the spare that was used to fix the problem."
	reward = 4000
	required_count = 1
	wanted_types = list(/obj/item/circuitboard/comm_monitor)

/datum/bounty/item/science/circuitboard/commserver
	name = "Telecomms Server Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/comm_server)

/datum/bounty/item/science/circuitboard/commtraffic
	name = "Telecomms Traffic Control Circuitboard"
	wanted_types = list(/obj/item/circuitboard/comm_traffic)

/datum/bounty/item/science/circuitboard/seccamera
	name = "Security Camera Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/security)

/datum/bounty/item/science/circuitboard/engcamera
	name = "Engineering Camera Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/security/engineering)

/datum/bounty/item/science/circuitboard/messagemonitor
	name = "Message Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/message_monitor)

/datum/bounty/item/science/circuitboard/aiupload
	name = "AI Upload Circuitboard"
	wanted_types = list(/obj/item/circuitboard/aiupload)

/datum/bounty/item/science/circuitboard/borgupload
	name = "Borg Upload Circuitboard"
	wanted_types = list(/obj/item/circuitboard/borgupload)

/datum/bounty/item/science/circuitboard/airalert
	name = "Atmos Alert Circuitboard"
	wanted_types = list(/obj/item/circuitboard/atmos_alert)

/datum/bounty/item/science/circuitboard/robotics
	name = "Robotics Control Circuitboard"
	wanted_types = list(/obj/item/circuitboard/robotics)

/datum/bounty/item/science/circuitboard/dronecontrol
	name = "Drone Control Circuitboard"
	wanted_types = list(/obj/item/circuitboard/drone_control)

/datum/bounty/item/science/circuitboard/cloning
	name = "Cloning Control Circuitboard"
	wanted_types = list(/obj/item/circuitboard/cloning)

/datum/bounty/item/science/circuitboard/powermonitor
	name = "Power Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/powermonitor)

/datum/bounty/item/science/battery
	name = "Heavy-Duty Power Cell"
	description = "%COMPNAME has requested some power cells to fill their supply closet. Please charge them first."
	reward = 3000
	required_count = 5
	wanted_types = list(/obj/item/cell/apc)

/datum/bounty/item/science/battery/high
	name = "High-Capacity power Cell"
	reward = 3500
	required_count = 4
	wanted_types = list(/obj/item/cell/high)

/datum/bounty/item/science/battery/super
	name = "Super-Capacity power Cell"
	reward = 4000
	required_count = 3
	wanted_types = list(/obj/item/cell/super)

/datum/bounty/item/science/battery/hyper
	name = "Hyper-Capacity power Cell"
	reward = 5000
	required_count = 2
	wanted_types = list(/obj/item/cell/hyper)

/datum/bounty/item/science/borgbody/halstre
	description = "We require you to ship us one fully assembled cyborg endoskeleton without a mmi/posibrain inside of it"
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
	if(other_bounty && (/obj/item/robot_parts/robot_suit in other_item_bounty.wanted_types))
		return FALSE
	return TRUE

