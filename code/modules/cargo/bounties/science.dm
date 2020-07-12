/datum/bounty/item/science/boh
	name = "Bag of Holding"
	description = "%COMPNAME would make good use of a high-capacity backpack. If you have any, please ship them."
	reward_low = 60
	reward_high = 72
	wanted_types = list(/obj/item/storage/backpack/holding)

/datum/bounty/item/science/nightvision_goggles
	name = "Night Vision Goggles"
	description = "An electrical storm has busted all the lights at %BOSSSHORT. While management is waiting for replacements, perhaps some night vision goggles can be shipped?"
	reward_low = 52
	reward_high = 60
	wanted_types = list(/obj/item/clothing/glasses/night)

/datum/bounty/item/science/experimental_welding_tool
	name = "Experimental Welding Tool"
	description = "A recent accident has left most of %BOSSSHORT's welding tools exploded. Ship replacements to be rewarded."
	reward_low = 52
	reward_high = 60
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/weldingtool/experimental)

/datum/bounty/item/science/cryostasis_beaker
	name = "Cryostasis Beaker"
	description = "Chemists at %BOSSNAME have discovered a new chemical that can only be held in cryostasis beakers. The only problem is they don't have any! Rectify this to receive a station bonus."
	reward_low = 52
	reward_high = 60
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/glass/beaker/noreact)

/datum/bounty/item/science/advanced_egun
	name = "Advanced Energy Gun"
	description = "With the price of rechargers on the rise, upper management is interested in purchasing guns that are self-powered. If you ship one, they'll pay."
	reward_low = 60
	reward_high = 72
	wanted_types = list(/obj/item/gun/energy/gun/nuclear)

/datum/bounty/item/science/posibrain
	name = "Posibrain"
	description = "Due to a sudden spike in accidents management has decided to replace some of the staff with borgs. Ship us 2 posibrains."
	reward_low = 80
	reward_high = 85
	required_count = 2
	wanted_types = list(/obj/item/device/mmi/digital/posibrain)

/datum/bounty/item/science/borgbody
	name = "Robot Endoskeleton"
	description = "Due to a sudden spike accidents, management has decided to rely more on cyborgs. Ship us a fully assembled robot endoskeletons without a mmi/posibrain inside of it."
	reward_low = 65
	reward_high = 75
	required_count = 2
	wanted_types = list(/obj/item/robot_parts/robot_suit)

/datum/bounty/item/science/forcegloves
	name = "Force Gloves"
	description = "%PERSONNAME has been challenged to a sparring duel in the holodeck. Ship them a pair of forcegloves so there can be a fair fight."
	reward_low = 25
	reward_high = 35
	wanted_types = list(/obj/item/clothing/gloves/force)

/datum/bounty/item/science/circuitboard
	name = "Telecomms Monitor Circuitboard"
	description = "Due to a hardware failure, %COMPNAME requires a new circuit board to replace the spare that was used to fix the problem."
	reward_low = 35
	reward_high = 45
	required_count = 1
	wanted_types = list(/obj/item/circuitboard/comm_monitor)

/datum/bounty/item/science/circuitboard/commserver
	name = "Telecomms Server Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/comm_server)

/datum/bounty/item/science/circuitboard/commtraffic
	name = "Telecomms Traffic Control Circuitboard"
	wanted_types = list(/obj/item/circuitboard/comm_traffic)

/datum/bounty/item/science/circuitboard/messagemonitor
	name = "Message Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/message_monitor)

/datum/bounty/item/science/circuitboard/aiupload
	name = "AI Upload Circuitboard"
	wanted_types = list(/obj/item/circuitboard/aiupload)

/datum/bounty/item/science/circuitboard/borgupload
	name = "Borg Upload Circuitboard"
	wanted_types = list(/obj/item/circuitboard/borgupload)

/datum/bounty/item/science/circuitboard/robotics
	name = "Robotics Control Circuitboard"
	wanted_types = list(/obj/item/circuitboard/robotics)

/datum/bounty/item/science/circuitboard/dronecontrol
	name = "Drone Control Circuitboard"
	wanted_types = list(/obj/item/circuitboard/drone_control)

/datum/bounty/item/science/circuitboard/powermonitor
	name = "Power Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/powermonitor)

/datum/bounty/item/science/battery
	name = "Heavy-Duty Power Cell"
	description = "%COMPNAME has requested some power cells to fill their supply closet. Please charge them first."
	reward_low = 20
	reward_high = 25
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/cell/apc)

/datum/bounty/item/science/battery/applies_to(obj/O)
	if(!..())
		return FALSE
	if(!istype(O, /obj/item/cell))
		return FALSE
	var/obj/item/cell/C = O
	if(C.charge == C.maxcharge)
		return TRUE
	return FALSE

/datum/bounty/item/science/battery/high
	name = "High-Capacity power Cell"
	reward_low = 30
	reward_high = 35
	wanted_types = list(/obj/item/cell/high)

/datum/bounty/item/science/battery/super
	name = "Super-Capacity power Cell"
	reward_low = 40
	reward_high = 45
	required_count = 3
	wanted_types = list(/obj/item/cell/super)

/datum/bounty/item/science/battery/hyper
	name = "Hyper-Capacity power Cell"
	reward_low = 45
	reward_high = 50
	required_count = 3
	wanted_types = list(/obj/item/cell/hyper)
