/obj/machinery/turbolift_controller
	name = "turbolift controller"
	desc = "A controller used to control a turbolift"
	icon = 'icons/obj/machines/turbolift_controller.dmi'
	icon_state = "lift_control"
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall

	req_access = list(access_ce) //what access it needs to use the admin functions in the gui

	idle_power_usage = 500
	active_power_usage = 500

	var/controller_link_id //Id of the turbolift to link to
	var/datum/wires/turoblift/wires
	var/datum/turbolift/lift


//TODO: UI
//TODO:   Command Mode
//TODO:   Remote Control
//TODO:   Floor Lockout
//TODO:   Function Lockout
//TODO:   Floor Access Update?
//TODO: Anti-Destruction
//TODO: Interactions


/obj/machinery/turbolift_controller/Initialize()
	..()
	wires = new(src)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/turbolift_controller/LateInitialize()
	for(var/datum/turbolift/tlift in elevators)
		if(tlift.controller_link_id == controller_link_id)
			lift = tlift
			lift.controller = src
			break
	if(!lift)
		qdel(src)
		return

/obj/machinery/turbolift_controller/Destroy()
	. = ..()
	qdel(wires)
	lift.controller = null
	lift = null

/obj/machinery/turbolift_controller/attack_hand(var/mob/user)
	if(panel_open)
		wires.Interact(user)
	. = ..()

/obj/machinery/turbolift_controller/attackby(var/obj/item/O, var/mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return
	//if(default_deconstruction_crowbar(user, O))
	//	return
	if(default_part_replacement(user, O))
		return
	if(panel_open && (O.ismultitool() || O.iswirecutter()))
		return attack_hand(user)
	. = ..()

/obj/machinery/turbolift_controller/update_icon()
	if(panel_open)
		icon_state = "lift_control-o"
	else
		icon_state = "lift_control"

//These are the can_ / shoud_ procs which are called by the turbolift datum to determine if a certain action is possible / should be performed
/obj/machinery/turbolift_controller/proc/can_hallcall(var/mob/user, var/obj/structure/lift/button/B)
	return wires.hacking_hallcall == FALSE

/obj/machinery/turbolift_controller/proc/can_cabincall(var/mob/user, var/obj/structure/lift/panel/P, var/area/turbolift/destination)
	if(wires.hacking_cabincall)
		return FALSE
	if(user && istype(user) && !wires.hacking_idscan)
		var/obj/item/card/id = user.GetIdCard()
		if(!istype(id))
			P.buzz("Insufficient Access")
			return FALSE
		if(!has_access(destination.turbolift_req_access, destination.turbolift_req_one_access, id.GetAccess()))
			P.buzz("Insufficient Access")
			return FALSE
	return TRUE

/obj/machinery/turbolift_controller/proc/can_estop(var/mob/user, var/obj/structure/lift/panel/P)
	return wires.hacking_safety == 0

/obj/machinery/turbolift_controller/proc/should_closedoors()
	return wires.hacking_safety != 2

/obj/machinery/turbolift_controller/proc/shoud_opendoors()
	return TRUE

/obj/machinery/turbolift_controller/proc/can_cabin_dooropen(var/mob/user, var/obj/structure/lift/panel/P)
	return wires.hacking_doorcontrol == 0

/obj/machinery/turbolift_controller/proc/can_cabin_doorclose(var/mob/user, var/obj/structure/lift/panel/P)
	return wires.hacking_doorcontrol == 0
