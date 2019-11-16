/obj/machinery/mech_recharger
	name = "mech recharger"
	desc = "A mech recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = 0
	layer = TURF_LAYER + 0.1
	anchored = 1

	var/obj/mecha/charging = null
	var/charge = 45
	var/repair = 0

	component_types = list(
		/obj/item/circuitboard/mech_recharger,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator = 2
	)

/obj/machinery/mech_recharger/Crossed(var/obj/mecha/M)
	. = ..()
	if(istype(M) && charging != M)
		start_charging(M)

/obj/machinery/mech_recharger/Uncrossed(var/obj/mecha/M)
	. = ..()
	if(M == charging)
		stop_charging()

/obj/machinery/mech_recharger/RefreshParts()
	..()
	charge = 0
	repair = -5

	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			charge += P.rating * 20
		else if(isscanner(P))
			charge += P.rating * 5
			repair += P.rating
		else if(ismanipulator(P))
			repair += P.rating * 2

/obj/machinery/mech_recharger/machinery_process()
	..()
	if(!charging)
		return
	if(charging.loc != loc) // Could be qdel or teleport or something
		stop_charging()
		return
	var/done = 1
	if(charging.cell)
		var/t = min(charge, charging.cell.maxcharge - charging.cell.charge)
		if(t > 0)
			charging.give_power(t)
			use_power(t * 150)
			done = 0
		else
			charging.occupant_message("<span class='notice'>Fully charged.</span>")
	if(repair && charging.health < initial(charging.health))
		charging.health = min(charging.health + repair, initial(charging.health))
		if(charging.health == initial(charging.health))
			charging.occupant_message("<span class='notice'>Fully repaired.</span>")

		else
			done = 0
	if(done)
		stop_charging()
	return

/obj/machinery/mech_recharger/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

/obj/machinery/mech_recharger/proc/start_charging(var/obj/mecha/M)
	if(stat & (NOPOWER | BROKEN))
		M.occupant_message("<span class='warning'>Power port not responding. Terminating.</span>")

		return
	if(M.cell)
		M.occupant_message("<span class='notice'>Now charging...</span>")
		playsound(M, 'sound/mecha/powerup.ogg', 50, 1)
		charging = M
	return

/obj/machinery/mech_recharger/proc/stop_charging()
	if(!charging)

		return
	charging = null
