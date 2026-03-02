/datum/bounty/item/science/experimental_welding_tool
	name = "Experimental Welding Tool"
	description = "A recent accident has left most of %BOSSSHORT's welding tools exploded. Ship replacements to be rewarded."
	reward_low = 520
	reward_high = 600
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/weldingtool/experimental)

/datum/bounty/item/science/cryostasis_beaker
	name = "Cryostasis Beaker"
	description = "Chemists at %BOSSNAME have discovered a new chemical that can only be held in cryostasis beakers. The only problem is they don't have any! Rectify this to receive a station bonus."
	reward_low = 520
	reward_high = 600
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/glass/beaker/noreact)

/datum/bounty/item/science/borgbody
	name = "Robot Endoskeleton"
	description = "The %DOCKSHORT has decided to rely more on cyborgs for dangerous tasks. Ship us a fully assembled robot endoskeletons without a mmi/posibrain inside of it."
	reward_low = 500
	reward_high = 650
	required_count = 1
	wanted_types = list(/obj/item/robot_parts/robot_suit)

/datum/bounty/item/science/borgbody/applies_to(var/obj/item/robot_parts/robot_suit/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(O.check_completion())
		return TRUE
	return FALSE

/datum/bounty/item/science/forcegloves
	name = "Force Gloves"
	description = "%PERSONNAME has been challenged to a sparring duel in the holodeck. Ship them a pair of forcegloves so there can be a fair fight."
	reward_low = 250
	reward_high = 350
	wanted_types = list(/obj/item/clothing/gloves/force)

/datum/bounty/item/science/fossil
	name = "Fossil"
	description = "We want to set up a display in one of the libraries on the %DOCKSHORT. Ship us a unique discovery when you are done displaying it on-station."
	reward_low = 750
	reward_high = 850
	required_count = 1
	random_count = 1 //wants one or two
	wanted_types = list(/obj/item/fossil, /obj/skeleton)

/datum/bounty/item/science/circuitboard
	name = "Telecomms Monitor Circuitboard"
	description = "Due to a hardware failure, %COMPNAME requires a new circuit board to replace the spare that was used to fix the problem."
	reward_low = 350
	reward_high = 450
	required_count = 1
	wanted_types = list(/obj/item/circuitboard/comm_monitor)

/datum/bounty/item/science/circuitboard/commserver
	name = "Telecomms Server Monitor Circuitboard"
	wanted_types = list(/obj/item/circuitboard/comm_server)

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

/datum/bounty/item/science/battery
	name = "Heavy-Duty Power Cell"
	description = "%COMPNAME has requested some power cells to fill their supply closet. Please fully charge them first."
	reward_low = 350
	reward_high = 450
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/cell/apc)

/datum/bounty/item/science/battery/applies_to(var/obj/item/cell/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(O.charge == O.maxcharge)
		return TRUE
	return FALSE

/datum/bounty/item/science/battery/high
	name = "High-Capacity power Cell"
	reward_low = 450
	reward_high = 500
	wanted_types = list(/obj/item/cell/high)

/datum/bounty/item/science/battery/super
	name = "Super-Capacity power Cell"
	reward_low = 450
	reward_high = 500
	required_count = 3
	wanted_types = list(/obj/item/cell/super)

/datum/bounty/item/science/battery/hyper
	name = "Hyper-Capacity power Cell"
	reward_low = 500
	reward_high = 600
	required_count = 3
	wanted_types = list(/obj/item/cell/hyper)
