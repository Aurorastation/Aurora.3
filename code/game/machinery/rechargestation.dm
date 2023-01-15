/obj/machinery/recharge_station
	name = "cyborg recharging station"
	desc = "A heavy duty rapid charging system, designed to quickly recharge cyborg power reserves."
	icon = 'icons/obj/robot_charger.dmi'
	icon_state = "borgcharger0"
	density = 1
	anchored = 1
	idle_power_usage = 75
	var/mob/occupant = null
	var/obj/item/cell/cell = null
	var/icon_update_tick = 0	// Used to rebuild the overlay only once every 10 ticks
	var/charging = 0
	var/charging_efficiency = 1.3//Multiplier applied to all operations of giving power to cells, represents entropy. Efficiency increases with upgrades
	var/charging_power			// W. Power rating drawn from internal cell to recharge occupant's cell 60 kW unupgraded
	var/restore_power_active	// W. Power drawn from APC to recharge internal cell when an occupant is charging. 40 kW if un-upgraded
	var/restore_power_passive	// W. Power drawn from APC to recharge internal cell when idle. 7 kW if un-upgraded
	var/weld_rate = 0			// How much brute damage is repaired per tick
	var/wire_rate = 0			// How much burn damage is repaired per tick

	var/weld_power_use = 2300	// power used per point of brute damage repaired. 2.3 kW ~ about the same power usage of a handheld arc welder
	var/wire_power_use = 500	// power used per point of burn damage repaired.

	component_types = list(
		/obj/item/circuitboard/recharge_station,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/cell/high,
		/obj/item/stack/cable_coil{amount = 5}
	)

/obj/machinery/recharge_station/Initialize()
	. = ..()
	update_icon()

/obj/machinery/recharge_station/proc/has_cell_power()
	return cell && cell.percent() > 0

/obj/machinery/recharge_station/process()
	if(stat & (BROKEN))
		return
	if(!cell) // Shouldn't be possible, but sanity check
		return

	if((stat & NOPOWER) && !has_cell_power()) // No power and cell is dead.
		if(icon_update_tick)
			icon_update_tick = 0 //just rebuild the overlay once more only
			update_icon()
		return

	//First, draw from the internal power cell to recharge/repair/etc the occupant
	if(occupant)
		process_occupant()

	//Then, if external power is available, recharge the internal cell
	var/recharge_amount = 0
	if(!(stat & NOPOWER))
		// Calculating amount of power to draw
		recharge_amount = (occupant ? restore_power_active : restore_power_passive) * CELLRATE

		recharge_amount = cell.give(recharge_amount*charging_efficiency)
		use_power_oneoff(recharge_amount / CELLRATE)
	else
		cell.use(get_power_usage() * CELLRATE)

	if(icon_update_tick >= 10)
		icon_update_tick = 0
	else
		icon_update_tick++

	if(occupant || recharge_amount)
		update_icon()

//Processes the occupant, drawing from the internal power cell if needed.
/obj/machinery/recharge_station/proc/process_occupant()
	if(!isrobot(occupant) && !ishuman(occupant))
		return

	var/obj/item/cell/target
	if(isrobot(occupant))
		var/mob/living/silicon/robot/R = occupant

		if(R.module)
			R.module.respawn_consumable(R, charging_power * CELLRATE / 250) //consumables are magical, apparently
		target = R.cell

		//Lastly, attempt to repair the cyborg if enabled
		if(weld_rate && R.getBruteLoss() && cell.checked_use(weld_power_use * weld_rate * CELLRATE))
			R.adjustBruteLoss(-weld_rate)
		if(wire_rate && R.getFireLoss() && cell.checked_use(wire_power_use * wire_rate * CELLRATE))
			R.adjustFireLoss(-wire_rate)

	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		var/obj/item/organ/internal/cell/IC = H.internal_organs_by_name[BP_CELL]
		if(IC)
			target = IC.cell
		if((!target || target.percent() > 95) && istype(H.back, /obj/item/rig))
			var/obj/item/rig/R = H.back
			if(R.cell && !R.cell.fully_charged())
				target = R.cell

	if(target && !target.fully_charged())
		var/diff = min(target.maxcharge - target.charge, charging_power * CELLRATE) // Capped by charging_power / tick
		var/charge_used = cell.use(diff)
		target.give(charge_used*charging_efficiency)

	if(isDrone(occupant))
		var/mob/living/silicon/robot/drone/D = occupant
		if(D.master_matrix && D.upgrade_cooldown < world.time && D.cell.fully_charged())
			D.upgrade_cooldown = world.time + 1 MINUTE
			D.master_matrix.apply_upgrades(D)

/obj/machinery/recharge_station/examine(mob/user)
	..(user)
	to_chat(user, "The charge meter reads: [round(chargepercentage())]%.")

/obj/machinery/recharge_station/proc/chargepercentage()
	if(!cell)
		return 0
	return cell.percent()

/obj/machinery/recharge_station/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()

/obj/machinery/recharge_station/emp_act(severity)
	if(occupant)
		occupant.emp_act(severity)
		go_out()
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/recharge_station/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(!occupant)
		if(default_deconstruction_screwdriver(user, O))
			return TRUE
		else if(default_deconstruction_crowbar(user, O))
			return TRUE
		else if(default_part_replacement(user, O))
			return TRUE

	if(istype(O, /obj/item/grab))
		var/obj/item/grab/grab = O
		var/mob/living/L = grab.affecting
		if(!L.isSynthetic())
			return TRUE

		var/bucklestatus = L.bucklecheck(user)
		if(!bucklestatus)
			return TRUE

		move_ipc(grab.affecting)
		qdel(O)
	return ..()

/obj/machinery/recharge_station/RefreshParts()
	..()
	var/man_rating = 0
	var/cap_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			cap_rating += P.rating
		else if(ismanipulator(P))
			man_rating += P.rating
	cell = locate(/obj/item/cell) in component_parts

	charging_efficiency = 1.3 + 0.030 * cap_rating
	charging_power = 30000 + 12000 * cap_rating
	restore_power_active = 10000 + 10000 * cap_rating
	restore_power_passive = 5000 + 1000 * cap_rating
	weld_rate = max(0, man_rating - 3)
	wire_rate = max(0, man_rating - 5)

	desc = initial(desc)
	desc += " Uses a dedicated internal power cell to deliver [charging_power]W when in use."
	if(weld_rate)
		desc += "<br>It is capable of repairing structural damage."
	if(wire_rate)
		desc += "<br>It is capable of repairing burn damage."

/obj/machinery/recharge_station/proc/build_overlays()
	cut_overlays()
	switch(round(chargepercentage()))
		if(1 to 20)
			add_overlay("statn_c0")
		if(21 to 40)
			add_overlay("statn_c20")
		if(41 to 60)
			add_overlay("statn_c40")
		if(61 to 80)
			add_overlay("statn_c60")
		if(81 to 98)
			add_overlay("statn_c80")
		if(99 to 110)
			add_overlay("statn_c100")

/obj/machinery/recharge_station/update_icon()
	..()
	if(stat & BROKEN)
		icon_state = "borgcharger0"
		return

	if(occupant)
		if((stat & NOPOWER) && !has_cell_power())
			icon_state = "borgcharger2"
		else
			icon_state = "borgcharger1"
	else
		icon_state = "borgcharger0"

	if(icon_update_tick == 0)
		build_overlays()

/obj/machinery/recharge_station/CollidedWith(var/mob/living/silicon/robot/R)
	go_in(R)

/obj/machinery/recharge_station/proc/go_in(var/mob/M)
	if(occupant)
		return
	if(!hascell(M))
		return

	if(!M.Move(src))
		return
	add_fingerprint(M)
	M.reset_view(src)
	occupant = M
	update_icon()
	return 1

/obj/machinery/recharge_station/proc/hascell(var/mob/M)
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.cell)
			return TRUE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!isnull(H.internal_organs_by_name[BP_CELL]))
			return TRUE
		if(istype(H.back, /obj/item/rig))
			var/obj/item/rig/R = H.back
			if(R.get_cell())
				return TRUE
	return FALSE

/obj/machinery/recharge_station/proc/go_out()
	if(!occupant)
		return

	occupant.forceMove(loc)
	occupant.reset_view()
	occupant = null
	update_icon()

/obj/machinery/recharge_station/proc/move_ipc(var/mob/M) // For the grab/drag and drop
	var/mob/living/R = M
	usr.visible_message(SPAN_NOTICE("[usr] starts putting [R] into [src]."), SPAN_NOTICE("You start putting [R] into [src]."), range = 3)
	if(do_mob(usr, R, 5 SECONDS))
		if(go_in(R))
			usr.visible_message(SPAN_NOTICE("After some effort, [usr] manages to get [R] into the recharging unit!"))
			return 1
		else
			to_chat(usr, SPAN_DANGER("Failed loading [R] into charger. Please ensure that [R]'s limbs are safely within the charger and has a power cell, and that the charger is functioning."))
	else
		to_chat(usr, SPAN_DANGER("Cancelled loading [R] into the charger. You and [R] must stay still!"))
	return

/obj/machinery/recharge_station/verb/move_eject()
	set category = "Object"
	set name = "Eject Recharger"
	set src in oview(1)

	if(usr.incapacitated())
		return

	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/recharge_station/verb/move_inside()
	set category = "Object"
	set name = "Enter Recharger"
	set src in oview(1)

	if(!usr.incapacitated())
		return
	go_in(usr)

/obj/machinery/recharge_station/MouseDrop_T(var/atom/movable/C, mob/user)
	if (istype(C, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = C
		if (!user.Adjacent(R) || !Adjacent(user))
			to_chat(user, SPAN_DANGER("You need to get closer if you want to put [C] into that charger!"))
			return
		user.face_atom(src)
		user.visible_message(SPAN_DANGER("[user] starts hauling [C] into the recharging unit!"), SPAN_DANGER("You start hauling and pushing [C] into the recharger. This might take a while..."), "You hear heaving and straining")
		if (do_mob(user, R, R.mob_size*10, needhand = 1))
			if (go_in(R))
				user.visible_message(SPAN_NOTICE("After a great effort, [user] manages to get [C] into the recharging unit!"))
				return 1
			else
				to_chat(user, SPAN_DANGER("Failed loading [C] into the charger. Please ensure that [C] has a power cell and is not buckled down, and that the charger is functioning."))
		else
			to_chat(user, SPAN_DANGER("Cancelled loading [C] into the charger. You and [C] must stay still!"))
		return

	else if(isipc(C)) // IPCs don't take as long
		var/mob/living/carbon/human/machine/R = C
		if(!user.Adjacent(R) || !Adjacent(user))
			to_chat(user, SPAN_DANGER("You need to get closer if you want to put [C] into that charger!"))
			return

		var/bucklestatus = R.bucklecheck(user)
		if(!bucklestatus)
			return
		if(bucklestatus == 2)
			var/obj/structure/LB = R.buckled_to
			LB.user_unbuckle(user)

		user.face_atom(src)
		move_ipc(R)
	return ..()
