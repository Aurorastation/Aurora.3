//list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0),
/datum/dna2/record
	var/datum/dna/dna = null
	var/types=0
	var/name="Empty"

	// Stuff for cloners
	var/id=null
	var/implant=null
	var/ckey=null
	var/mind=null
	var/languages=null
	var/list/flavor=null
	var/cloning_species=null

/datum/dna2/record/proc/GetData()
	var/list/ser=list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0)
	if(dna)
		ser["ue"] = (types & DNA2_BUF_UE) == DNA2_BUF_UE
		if(types & DNA2_BUF_SE)
			ser["data"] = dna.SE
		else
			ser["data"] = dna.UI
		ser["owner"] = src.dna.real_name
		ser["label"] = name
		if(types & DNA2_BUF_UI)
			ser["type"] = "ui"
		else
			ser["type"] = "se"
	return ser

/////////////////////////// DNA MACHINES
/obj/machinery/dna_scannernew
	name = "\improper DNA modifier"
	desc = "It scans DNA structures."
	icon = 'icons/obj/machinery/sleeper.dmi'
	icon_state = "scanner_0"
	density = 1
	anchored = 1.0
	idle_power_usage = 50
	active_power_usage = 300
	interact_offline = 1
	var/locked = 0
	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_containers/glass/beaker = null
	var/opened = 0

	component_types = list(
		/obj/item/circuitboard/clonescanner,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/console_screen,
		/obj/item/stack/cable_coil = 2
	)

/obj/machinery/dna_scannernew/relaymove(mob/living/user, direction)
	. = ..()

	if(user.stat)
		return
	src.go_out()
	return

/obj/machinery/dna_scannernew/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject DNA Scanner"

	if (usr.stat != 0)
		return

	eject_occupant()

	add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/proc/eject_occupant()
	src.go_out()
	for(var/obj/item/O in src)
		if((!istype(O,/obj/item/reagent_containers)) && (!istype(O,/obj/item/circuitboard/clonescanner)) && (!istype(O,/obj/item/stock_parts)) && (!O.tool_behaviour == TOOL_CABLECOIL))
			O.forceMove(get_turf(src))//Ejects items that manage to get in there (exluding the components)
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.forceMove(get_turf(src))

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter DNA Scanner"

	if (usr.stat != 0)
		return
	if (!ishuman(usr) && !issmall(usr)) //Make sure they're a mob that has dna
		to_chat(usr, SPAN_NOTICE("Try as you might, you can not climb up into the scanner."))
		return
	if (src.occupant)
		to_chat(usr, SPAN_WARNING("The scanner is already occupied!"))
		return
	if (usr.abiotic())
		to_chat(usr, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	usr.stop_pulling()
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	src.occupant = usr
	src.icon_state = "scanner_1"
	src.add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return TRUE
		beaker = attacking_item
		user.drop_from_inventory(attacking_item,src)
		user.visible_message("\The [user] adds \a [attacking_item] to \the [src]!", "You add \a [attacking_item] to \the [src]!")
		return TRUE

	var/obj/item/grab/G = attacking_item
	if (!istype(G, /obj/item/grab) || !isliving(G.affecting) )
		return
	if (occupant)
		to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
		return TRUE

	var/mob/living/M = G.affecting
	var/bucklestatus = M.bucklecheck(user)
	if (!bucklestatus)
		return TRUE

	user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [M] into \the [src]."), SPAN_NOTICE("You start putting \the [M] into \the [src]."), range = 3)
	if (do_mob(user, G.affecting, 30, needhand = 0))
		put_in(G.affecting)
	src.add_fingerprint(user)
	qdel(G)
	return TRUE

/obj/machinery/dna_scannernew/mouse_drop_receive(atom/dropped, mob/user, params)
	if(!istype(user))
		return

	if(!ismob(dropped))
		return

	if (occupant)
		to_chat(user, SPAN_NOTICE("<B>The scanner is already occupied!</B>"))
		return

	var/mob/living/L = dropped
	var/bucklestatus = L.bucklecheck(user)
	if (!bucklestatus)
		return

	if(L == user)
		user.visible_message("\The <b>[user]</b> starts climbing into \the [src].", SPAN_NOTICE("You start climbing into \the [src]."), range = 3)
	else
		user.visible_message("\The <b>[user]</b> starts putting \the [L] into \the [src].", SPAN_NOTICE("You start putting \the [L] into \the [src]."), range = 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled_to
			LB.user_unbuckle(user)
		put_in(L)
	add_fingerprint(user)
	return

/obj/machinery/dna_scannernew/proc/put_in(var/mob/M)
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.forceMove(src)
	src.occupant = M
	src.icon_state = "scanner_1"
	playsound(loc, 'sound/machines/cryopod/cryopod_enter.ogg', 25)

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(locate(/obj/machinery/computer/cloning, get_step(src, NORTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, SOUTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, EAST)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, WEST)))

		if(!M.client && M.mind)
			for(var/mob/abstract/ghost/observer/ghost in GLOB.player_list)
				if(ghost.mind == M.mind)
					to_chat(ghost, "<b><font color = #330033><font size = 3>Your corpse has been placed into a cloning scanner. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font></font>")
					break
	return

/obj/machinery/dna_scannernew/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.forceMove(src.loc)
	src.occupant = null
	src.icon_state = "scanner_0"
	playsound(loc, 'sound/machines/cryopod/cryopod_exit.ogg', 25)
	return

/obj/machinery/dna_scannernew/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/machinery/computer/scan_consolenew
	name = "DNA Modifier Access Console"
	desc = "Scan DNA."
	icon_screen = "dna"
	icon_keyboard = "teal_key"
	icon_keyboard_emis = "teal_key_mask"
	light_color = LIGHT_COLOR_BLUE
	density = 1
	circuit = /obj/item/circuitboard/scan_consolenew
	var/selected_ui_block = 1.0
	var/selected_ui_subblock = 1.0
	var/selected_se_block = 1.0
	var/selected_se_subblock = 1.0
	var/selected_ui_target = 1
	var/selected_ui_target_hex = 1
	var/radiation_duration = 2.0
	var/radiation_intensity = 1.0
	var/list/datum/dna2/record/buffers[3]
	var/irradiating = 0
	var/injector_ready = 0	//Quick fix for issue 286 (screwdriver the screen twice to restore injector)	-Pete
	var/obj/machinery/dna_scannernew/connected = null
	var/obj/item/disk/data/disk = null
	var/selected_menu_key = null
	anchored = 1
	idle_power_usage = 10
	active_power_usage = 400
	var/waiting_for_user_input=0 // Fix for #274 (Mash create block injector without answering dialog to make unlimited injectors) - N3X

/obj/machinery/computer/scan_consolenew/Initialize()
	..()
	for(var/i=0;i<3;i++)
		buffers[i+1]=new /datum/dna2/record
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/scan_consolenew/LateInitialize()
	. = ..()
	for(var/obj/machinery/dna_scannernew/C in orange(1,src))
		connected = C
		break

	src.injector_ready = 1

/obj/machinery/computer/scan_consolenew/Destroy()
	connected = null
	disk = null

	QDEL_LIST_ASSOC(buffers)

	. = ..()

/obj/machinery/computer/scan_consolenew/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/disk/data)) //INSERT SOME diskS
		if (!src.disk)
			user.drop_from_inventory(attacking_item, src)
			src.disk = attacking_item
			to_chat(user, "You insert [attacking_item].")
			SSnanoui.update_uis(src) // update all UIs attached to src
			return TRUE
	else
		return ..()

/obj/machinery/computer/scan_consolenew/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
	return

/obj/machinery/computer/scan_consolenew/proc/all_dna_blocks(var/list/buffer)
	var/list/arr = list()
	for(var/i = 1, i <= buffer.len, i++)
		arr += "[i]:[num2hex(buffer[i], 3)]"
	return arr

/obj/machinery/computer/scan_consolenew/proc/setInjectorBlock(var/obj/item/dnainjector/I, var/blk, var/datum/dna2/record/buffer)
	var/pos = findtext(blk,":")
	if(!pos) return 0
	var/id = text2num(copytext(blk,1,pos))
	if(!id) return 0
	I.block = id
	I.buf = buffer
	return 1

/*
/obj/machinery/computer/scan_consolenew/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	if (!( src.status )) //remove this
		return
	return
*/

/obj/machinery/computer/scan_consolenew/attack_ai(user as mob)
	if(!ai_can_interact(user))
		return
	src.add_hiddenprint(user)
	// DNA Modifier is currently deprecated (old NanoUI code)
	to_chat(user, SPAN_WARNING("The firmware on this thing is so hopelessly out of date as to render it unusable. Dang."))
	return
	// ui_interact(user)

/obj/machinery/computer/scan_consolenew/attack_hand(user as mob)
	if(!..())
		// DNA Modifier is currently deprecated (old NanoUI code)
		to_chat(user, SPAN_WARNING("The firmware on this thing is so hopelessly out of date as to render it unusable. Dang."))
		return
		// ui_interact(user)

/////////////////////////// DNA MACHINES
