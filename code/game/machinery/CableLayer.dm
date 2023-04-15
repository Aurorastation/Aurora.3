/obj/machinery/cablelayer
	name = "automatic cable layer"
	icon = 'icons/obj/cable_layer.dmi'
	icon_state = "cable_layer"
	density = TRUE
	var/obj/structure/cable/last_piece
	var/obj/item/stack/cable_coil/cable
	var/max_cable = 100
	var/on = FALSE

/obj/machinery/cablelayer/Initialize()
	. = ..()
	cable = new(src)
	cable.amount = max_cable

/obj/machinery/cablelayer/Move(new_turf,M_Dir)
	..()
	if(on)
		layCable(new_turf,M_Dir)

/obj/machinery/cablelayer/attack_hand(mob/user)
	if(!cable && !on)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any cable loaded."))
		return
	on = !on
	user.visible_message("\The [user] [!on ? "de" : ""]activates \the [src].", SPAN_NOTICE("You switch \the [src] [on ? "on" : "off"]."))
	return

/obj/machinery/cablelayer/attackby(var/obj/item/O, var/mob/user)
	if(O.iscoil())
		var/result = load_cable(O)
		if(!result)
			to_chat(user, SPAN_WARNING("\The [src]'s cable reel is full."))
		else
			to_chat(user, SPAN_NOTICE("You load [result] lengths of cable into \the [src]."))
		return TRUE

	if(O.iswirecutter())
		if(cable && cable.amount)
			var/m = round(input(usr,"Please specify the length of cable to cut.", "Cut Cable",min(cable.amount,30)) as num, 1)
			m = min(m, cable.amount)
			m = min(m, 30)
			if(m)
				playsound(loc, 'sound/items/wirecutter.ogg', 50, 1)
				var/cable_color = use_cable(m)
				var/obj/item/stack/cable_coil/CC = new(get_turf(src), m, cable_color)
				user.put_in_hands(CC)
		else
			to_chat(user, SPAN_WARNING("There's no more cable on the reel."))
		return TRUE

	if(O.ismultitool())
		if(!cable)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have any cable loaded!"))
			return TRUE
		return cable.attackby(O, user)

/obj/machinery/cablelayer/examine(mob/user)
	..()
	to_chat(user, "\The [src]'s cable reel has [cable.amount] length\s left.")

/obj/machinery/cablelayer/proc/load_cable(var/obj/item/stack/cable_coil/CC)
	if(istype(CC) && CC.amount)
		var/cur_amount = cable? cable.amount : 0
		var/to_load = max(max_cable - cur_amount,0)
		if(to_load)
			to_load = min(CC.amount, to_load)
			if(!cable)
				cable = new(src, 0, CC.color)
			cable.amount = to_load
			CC.use(to_load)
			return to_load
		else
			return FALSE

/obj/machinery/cablelayer/proc/use_cable(amount)
	if(!cable || cable.amount < 1)
		on = FALSE
		reset()
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
		visible_message(SPAN_WARNING("A red light flashes on \the [src]."))
		return
	var/cable_color = cable.color
	cable.use(amount)
	if(QDELETED(cable))
		cable = null
	return cable_color

/obj/machinery/cablelayer/proc/reset()
	last_piece = null

/obj/machinery/cablelayer/proc/layCable(var/turf/new_turf,var/M_Dir)
	if(!istype(new_turf))
		return reset()
	if(!new_turf.is_plating())
		return reset()
	var/fdirn = turn(M_Dir,180)
	for(var/obj/structure/cable/LC in new_turf)		// check to make sure there's not a cable there already
		if(LC.d1 == fdirn || LC.d2 == fdirn)
			return reset()
	var/cable_color = use_cable(1)
	if(!cable_color)
		return reset()
	var/obj/structure/cable/NC = new(new_turf)
	NC.cableColor(cable_color)
	NC.d1 = 0
	NC.d2 = fdirn
	NC.update_icon()

	var/datum/powernet/PN
	if(last_piece && last_piece.d2 != M_Dir)
		last_piece.d1 = min(last_piece.d2, M_Dir)
		last_piece.d2 = max(last_piece.d2, M_Dir)
		last_piece.update_icon()
		PN = last_piece.powernet

	if(!PN)
		PN = new()
	PN.add_cable(NC)
	NC.mergeConnectedNetworks(NC.d2)

	last_piece = NC
	return TRUE
