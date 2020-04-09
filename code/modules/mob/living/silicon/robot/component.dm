// TODO: remove the robot.mmi and robot.cell variables and completely rely on the robot component system

/datum/robot_component/var/name
/datum/robot_component/var/installed = 0
/datum/robot_component/var/powered = 0
/datum/robot_component/var/toggled = 1
/datum/robot_component/var/brute_damage = 0
/datum/robot_component/var/electronics_damage = 0
/datum/robot_component/var/idle_usage = 0   // Amount of power used every MC tick. In joules.
/datum/robot_component/var/active_usage = 0 // Amount of power used for every action. Actions are module-specific. Actuator for each tile moved, etc.
/datum/robot_component/var/max_damage = 30  // HP of this component.
/datum/robot_component/var/mob/living/silicon/robot/owner

// The actual device object that has to be installed for this.
/datum/robot_component/var/external_type = null

// The wrapped device(e.g. radio), only set if external_type isn't null
/datum/robot_component/var/obj/item/wrapped = null

/datum/robot_component/New(mob/living/silicon/robot/R)
	src.owner = R

/datum/robot_component/proc/install()
	installed = 1

/datum/robot_component/proc/uninstall()
	installed = 0

/datum/robot_component/proc/destroy()
	var/brokenstate = "broken" // Generic icon
	if (istype(wrapped, /obj/item/robot_parts/robot_component))
		var/obj/item/robot_parts/robot_component/comp = wrapped
		brokenstate = comp.icon_state_broken
	if(wrapped)
		qdel(wrapped)

	wrapped = new/obj/item/broken_device
	wrapped.icon_state = brokenstate // Module-specific broken icons! Yay!

	// The thing itself isn't there anymore, but some fried remains are.
	uninstall()
	installed = -1

/datum/robot_component/proc/get_damage(var/type)
	return Clamp(brute_damage + electronics_damage,0,max_damage)

/datum/robot_component/proc/take_damage(brute, electronics, sharp, edge)
	if(installed != 1) return

	brute_damage += brute
	electronics_damage += electronics

	if(brute_damage + electronics_damage >= max_damage) destroy()

/datum/robot_component/proc/heal_damage(brute, electronics)
	if(installed != 1)
		// If it's not installed, can't repair it.
		return 0

	brute_damage = max(0, brute_damage - brute)
	electronics_damage = max(0, electronics_damage - electronics)

/datum/robot_component/proc/is_powered()
	return (installed == 1) && (brute_damage + electronics_damage < max_damage) && (!idle_usage || powered)

/datum/robot_component/proc/update_power_state()
	if(toggled == 0)
		powered = 0
		return
	if(owner.cell && owner.cell.charge >= idle_usage)
		owner.cell_use_power(idle_usage)
		powered = 1
	else
		powered = 0


// ARMOUR
// Protects the cyborg from damage. Usually first module to be hit
// No power usage
/datum/robot_component/armor
	name = "armour plating"
	external_type = /obj/item/robot_parts/robot_component/armor
	max_damage = 60

// JETPACK
// Allows the cyborg to move in space
// Uses no power when idle. Uses 50J for each tile the cyborg moves.
/datum/robot_component/jetpack
	name = "jetpack"
	external_type = /obj/item/robot_parts/robot_component/jetpack
	active_usage = 50
	max_damage = 60
	installed = 0

	var/obj/item/tank/jetpack/carbondioxide/synthetic/tank = null

/datum/robot_component/surge
	name = "surge preventor"
	external_type = /obj/item/robot_parts/robot_component/surge
	max_damage = 60
	installed = 0
	var/surge_left = 0

/datum/robot_component/surge/install()
	..()
	if(!surge_left)
		surge_left = rand(2, 5)

/datum/robot_component/jetpack/install()
	..()
	tank = new/obj/item/tank/jetpack/carbondioxide/synthetic
	owner.internals = tank
	tank.forceMove(owner)
	owner.jetpack = tank

/datum/robot_component/jetpack/uninstall()
	..()
	qdel(tank)
	tank = null
	owner.jetpack = null

// ACTUATOR
// Enables movement.
// Uses no power when idle. Uses 200J for each tile the cyborg moves.
/datum/robot_component/actuator
	name = "actuator"
	idle_usage = 0
	active_usage = 200
	external_type = /obj/item/robot_parts/robot_component/actuator
	max_damage = 50


//A fixed and much cleaner implementation of /tg/'s special snowflake code.
/datum/robot_component/actuator/is_powered()
	return (installed == 1) && (brute_damage + electronics_damage < max_damage)


// POWER CELL
// Stores power (how unexpected..)
// No power usage
/datum/robot_component/cell
	name = "power cell"
	max_damage = 50

/datum/robot_component/cell/destroy()
	..()
	owner.cell = null


// RADIO
// Enables radio communications
// Uses no power when idle. Uses 10J for each received radio message, 50 for each transmitted message.
/datum/robot_component/radio
	name = "radio"
	external_type = /obj/item/robot_parts/robot_component/radio
	idle_usage = 15		//it's not actually possible to tell when we receive a message over our radio, so just use 10W every tick for passive listening
	active_usage = 75	//transmit power
	max_damage = 40


// BINARY RADIO
// Enables binary communications with other cyborgs/AIs
// Uses no power when idle. Uses 10J for each received radio message, 50 for each transmitted message
/datum/robot_component/binary_communication
	name = "binary communication device"
	external_type = /obj/item/robot_parts/robot_component/binary_communication_device
	idle_usage = 5
	active_usage = 25
	max_damage = 30


// CAMERA
// Enables cyborg vision. Can also be remotely accessed via consoles.
// Uses 10J constantly
/datum/robot_component/camera
	name = "camera"
	external_type = /obj/item/robot_parts/robot_component/camera
	idle_usage = 10
	max_damage = 40
	var/obj/machinery/camera/camera

/datum/robot_component/camera/New(mob/living/silicon/robot/R)
	..()
	camera = R.camera

/datum/robot_component/camera/update_power_state()
	..()
	if (camera)
		//check if camera component was deactivated
		if (!powered && camera.status != powered)
			camera.kick_viewers()
		camera.status = powered

/datum/robot_component/camera/install()
	installed = 1
	if (camera)
		camera.status = 1

/datum/robot_component/camera/uninstall()
	installed = 0
	if (camera)
		camera.status = 0
		camera.kick_viewers()

/datum/robot_component/camera/destroy()
	if (camera)
		camera.status = 0
		camera.kick_viewers()

// SELF DIAGNOSIS MODULE
// Analyses cyborg's modules, providing damage readouts and basic information
// Uses 1kJ burst when analysis is done
/datum/robot_component/diagnosis_unit
	name = "self-diagnosis unit"
	active_usage = 1000
	external_type = /obj/item/robot_parts/robot_component/diagnosis_unit
	max_damage = 30




// HELPER STUFF



// Initializes cyborg's components. Technically, adds default set of components to new borgs
/mob/living/silicon/robot/proc/initialize_components()
	components["actuator"] = new /datum/robot_component/actuator(src)
	actuatorComponent = components["actuator"]
	components["radio"] = new /datum/robot_component/radio(src)
	components["power cell"] = new /datum/robot_component/cell(src)
	components["diagnosis unit"] = new /datum/robot_component/diagnosis_unit(src)
	components["camera"] = new /datum/robot_component/camera(src)
	components["comms"] = new /datum/robot_component/binary_communication(src)
	components["armour"] = new /datum/robot_component/armor(src)
	components["jetpack"] = new /datum/robot_component/jetpack(src)
	components["surge"] = new /datum/robot_component/surge(src)
	jetpackComponent = components["jetpack"]
	jetpackComponent.installed = FALSE //We start the jetpack as not installed, because its nondefault

// Checks if component is functioning
/mob/living/silicon/robot/proc/is_component_functioning(module_name)
	var/datum/robot_component/C = components[module_name]
	return C && C.installed == TRUE && C.toggled && C.is_powered()

// Returns component by it's string name
/mob/living/silicon/robot/proc/get_component(var/component_name)
	var/datum/robot_component/C = components[component_name]
	return C

// COMPONENT OBJECTS
// These objects are visual representation of modules

/obj/item/broken_device
	name = "broken component"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "broken"

/obj/item/robot_parts/robot_component/proc/take_damage(var/brute_amt, var/burn_amt)
	brute += brute_amt
	burn += burn_amt
	total_dam = brute + burn
	if(total_dam >= max_dam)
		var/obj/item/circuitboard/broken/broken_device = new(get_turf(src))
		if(icon_state_broken != "broken")
			broken_device.icon = src.icon
			broken_device.icon_state = icon_state_broken
		broken_device.name = "broken [name]"
		return broken_device
	return FALSE

/obj/item/robot_parts/robot_component/proc/is_functional()
	return ((brute + burn) < max_dam)

/obj/item/robot_parts/robot_component
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "working"
	var/brute = 0
	var/burn = 0
	var/icon_state_broken = "broken"
	var/total_dam = 0
	var/max_dam = 30

/obj/item/robot_parts/robot_component/binary_communication_device
	name = "binary communication device"
	icon_state = "binradio"
	icon_state_broken = "binradio_broken"

/obj/item/robot_parts/robot_component/actuator
	name = "actuator"
	icon_state = "motor"
	icon_state_broken = "motor_broken"

/obj/item/robot_parts/robot_component/armor
	name = "armor plating"
	icon_state = "armor"
	icon_state_broken = "armor_broken"

/obj/item/robot_parts/robot_component/surge
	name = "surge preventor"
	desc = "Cyborg component designed to save internal electronics from damage of EMP pulse."
	icon_state = "surge"
	icon_state_broken = "surge_broken"

/obj/item/robot_parts/robot_component/camera
	name = "camera"
	icon_state = "camera"
	icon_state_broken = "camera_broken"

/obj/item/robot_parts/robot_component/diagnosis_unit
	name = "diagnosis unit"
	icon_state = "analyser"
	icon_state_broken = "analyser_broken"

/obj/item/robot_parts/robot_component/jetpack
	name = "jetpack"
	icon = 'icons/obj/tank.dmi'
	icon_state = "jetpack-black"
	icon_state_broken = "jetpack-black"

/obj/item/robot_parts/robot_component/radio
	name = "radio"
	icon_state = "radio"
	icon_state_broken = "radio_broken"