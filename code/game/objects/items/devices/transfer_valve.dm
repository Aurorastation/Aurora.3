/obj/item/device/transfer_valve
	name = "tank transfer valve"
	desc = "Regulates the transfer of air between two tanks"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "valve_1"
	var/obj/item/tank/tank_one
	var/obj/item/tank/tank_two
	var/obj/item/device/assembly/attached_device
	var/mob/attacher = null
	var/valve_open = 0
	var/toggle = 1
	movable_flags = MOVABLE_FLAG_PROXMOVE

/obj/item/device/transfer_valve/IsAssemblyHolder()
	return 1

/obj/item/device/transfer_valve/attackby(obj/item/attacking_item, mob/user)
	var/turf/location = get_turf(src) // For admin logs
	if(istype(attacking_item, /obj/item/tank))
		if(tank_one && tank_two)
			to_chat(user, SPAN_WARNING("There are already two tanks attached, remove one first."))
			return

		if(!tank_one)
			tank_one = attacking_item
			user.drop_from_inventory(attacking_item,src)
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer valve."))
		else if(!tank_two)
			tank_two = attacking_item
			user.drop_from_inventory(attacking_item,src)
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer valve."))
			message_admins("[key_name_admin(user)] attached both tanks to a transfer valve. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
			log_game("[key_name_admin(user)] attached both tanks to a transfer valve.")

		update_icon()
		update_static_data_for_all_viewers()
//TODO: Have this take an assemblyholder
	else if(isassembly(attacking_item))
		var/obj/item/device/assembly/A = attacking_item
		if(A.secured)
			to_chat(user, SPAN_NOTICE("The device is secured."))
			return
		if(attached_device)
			to_chat(user, SPAN_WARNING("There is already an device attached to the valve, remove it first."))
			return
		user.remove_from_mob(attacking_item)
		attached_device = A
		A.forceMove(src)
		to_chat(user, SPAN_NOTICE("You attach the [attacking_item] to the valve controls and secure it."))
		A.holder = src
		A.toggle_secure()	//this calls update_icon(), which calls update_icon() on the holder (i.e. the bomb).

		GLOB.bombers += "[key_name(user)] attached a [attacking_item] to a transfer valve."
		message_admins("[key_name_admin(user)] attached a [attacking_item] to a transfer valve. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
		log_game("[key_name_admin(user)] attached a [attacking_item] to a transfer valve.")
		attacher = user
		update_static_data_for_all_viewers()
	return


/obj/item/device/transfer_valve/HasProximity(atom/movable/AM as mob|obj)
	if(!attached_device)
		return
	attached_device.HasProximity(AM)
	return


/obj/item/device/transfer_valve/attack_self(mob/user as mob)
	ui_interact(user)

/obj/item/device/transfer_valve/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TransferValve", ui_x=540, ui_y=165)
		ui.open()

/obj/item/device/transfer_valve/ui_data(mob/user)
	var/list/data = list()
	data["tankOne"] = tank_one ? tank_one.name : null
	data["tankTwo"] = tank_two ? tank_two.name : null
	data["valveAttachment"] = attached_device ? attached_device.name : null
	data["valveOpen"] = valve_open ? 1 : 0
	return data

/obj/item/device/transfer_valve/ui_act(action,params)
	. = ..()
	if(.)
		return
	src.add_fingerprint(usr)
	if(action=="remove")
		if(params["object"]=="tankOne")
			remove_tank(tank_one,usr)
		if(params["object"]=="tankTwo")
			remove_tank(tank_two,usr)
		if(params["object"]=="device")
			attached_device.forceMove(get_turf(src))
			usr.put_in_hands(attached_device)
			attached_device.holder = null
			attached_device = null
		. = TRUE
		update_icon()
	if(action=="interact")
		if(params["object"]=="tankOne")
			tank_one.ui_interact(usr)
		if(params["object"]=="tankTwo")
			tank_two.ui_interact(usr)
		if(params["object"]=="device")
			attached_device.ui_interact(usr)
	if(action=="open")
		toggle_valve()

/obj/item/device/transfer_valve/proc/process_activation(var/obj/item/device/D)
	if(toggle)
		toggle = 0
		toggle_valve()
		spawn(50) // To stop a signal being spammed from a proxy sensor constantly going off or whatever
			toggle = 1

/obj/item/device/transfer_valve/update_icon()
	ClearOverlays()
	underlays = null

	if(!tank_one && !tank_two && !attached_device)
		icon_state = "valve_1"
		return
	icon_state = "valve"

	if(tank_one)
		AddOverlays("[tank_one.icon_state]")
	if(tank_two)
		var/icon/J = new(icon, icon_state = "[tank_two.icon_state]")
		J.Shift(WEST, 13)
		underlays += J
	if(attached_device)
		AddOverlays("device")

/obj/item/device/transfer_valve/proc/remove_tank(obj/item/tank/T, mob/user)
	if(tank_one == T)
		split_gases()
		tank_one = null
	else if(tank_two == T)
		split_gases()
		tank_two = null
	else
		return

	T.forceMove(get_turf(src))
	if(user)
		user.put_in_hands(T)
	update_icon()

/obj/item/device/transfer_valve/proc/merge_gases()
	if(valve_open)
		return
	tank_two.air_contents.volume += tank_one.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_one.air_contents.remove_ratio(1)
	tank_two.air_contents.merge(temp)
	valve_open = 1

/obj/item/device/transfer_valve/proc/split_gases()
	if(!valve_open)
		return

	valve_open = 0

	if(QDELETED(tank_one) || QDELETED(tank_two) || !tank_one.air_contents || !tank_two.air_contents)
		return

	var/ratio1 = tank_one.air_contents.volume/tank_two.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_two.air_contents.remove_ratio(ratio1)
	tank_one.air_contents.merge(temp)
	tank_two.air_contents.volume -=  tank_one.air_contents.volume


	/*
	Exadv1: I know this isn't how it's going to work, but this was just to check
	it explodes properly when it gets a signal (and it does).
	*/

/obj/item/device/transfer_valve/proc/toggle_valve()
	if(!valve_open && (tank_one && tank_two))
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)

		var/attacher_name = ""
		if(!attacher)
			attacher_name = "Unknown"
		else
			attacher_name = "[attacher.name]([attacher.ckey])"

		var/log_str = "Bomb valve opened in <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name]</a> "
		log_str += "with [attached_device ? attached_device : "no device"] attacher: [attacher_name]"

		if(attacher)
			log_str += "(<A href='byond://?_src_=holder;adminmoreinfo=[REF(attacher)]'>?</A>)"

		var/mob/mob = get_mob_by_key(src.fingerprintslast)
		var/last_touch_info = ""
		if(mob)
			last_touch_info = "(<A href='byond://?_src_=holder;adminmoreinfo=[REF(mob)]'>?</A>)"

		log_str += " Last touched by: [src.fingerprintslast][last_touch_info]"
		GLOB.bombers += log_str
		message_admins(log_str, 0, 1)
		log_game(log_str)
		merge_gases()

	else if(valve_open==1 && (tank_one && tank_two))
		split_gases()

	src.update_icon()

// this doesn't do anything but the timer etc. expects it to be here
// eventually maybe have it update icon to show state (timer, prox etc.) like old bombs
/obj/item/device/transfer_valve/proc/c_state()
	return
