///////////////////////////////
//CABLE STRUCTURE
///////////////////////////////


////////////////////////////////
// Definitions
////////////////////////////////

/* Cable directions (d1 and d2)


>  9   1   5
>    \ | /
>  8 - 0 - 4
>    / | \
>  10  2   6

If d1 = 0 and d2 = 0, there's no cable
If d1 = 0 and d2 = dir, it's a O-X cable, getting from the center of the tile to dir (knot cable)
If d1 = dir1 and d2 = dir2, it's a full X-X cable, getting from dir1 to dir2
By design, d1 is the smallest direction and d2 is the highest
*/

var/list/possible_cable_coil_colours = list(
		"Yellow" = COLOR_YELLOW,
		"Green" = COLOR_LIME,
		"Pink" = COLOR_PINK,
		"Blue" = COLOR_BLUE,
		"Orange" = COLOR_ORANGE,
		"Cyan" = COLOR_CYAN,
		"Red" = COLOR_RED
	)

/obj/structure/cable
	level = 1
	anchored =1
	var/datum/powernet/powernet
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer"
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	layer = 2.44 //Just below unary stuff, which is at 2.45 and above pipes, which are at 2.4
	color = COLOR_RED
	var/obj/machinery/power/breakerbox/breaker_box

/obj/structure/cable/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	var/datum/powernet/PN = powernet
	if(!PN) return 0

	return PN.draw_power(amount)

/obj/structure/cable/yellow
	color = COLOR_YELLOW

/obj/structure/cable/green
	color = COLOR_LIME

/obj/structure/cable/blue
	color = COLOR_BLUE

/obj/structure/cable/pink
	color = COLOR_PINK

/obj/structure/cable/orange
	color = COLOR_ORANGE

/obj/structure/cable/cyan
	color = COLOR_CYAN

/obj/structure/cable/white
	color = COLOR_WHITE

/obj/structure/cable/Initialize()
	. = ..()

	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact
	if(level == 1 && !T.is_hole)
		hide(!T.is_plating())

	SSpower.all_cables += src //add it to the global cable list

/obj/structure/cable/Destroy()					// called when a cable is deleted
	if(powernet)
		cut_cable_from_powernet()				// update the powernets
	SSpower.all_cables -= src							//remove it from global cable list
	return ..()										// then go ahead and delete the cable

///////////////////////////////////
// General procedures
///////////////////////////////////

//If underfloor, hide the cable
/obj/structure/cable/hide(var/i)
	if(istype(loc, /turf))
		invisibility = i ? 101 : 0
	updateicon()

/obj/structure/cable/hides_under_flooring()
	return 1

/obj/structure/cable/proc/updateicon()
	icon_state = "[d1]-[d2]"
	alpha = invisibility ? 127 : 255

//Telekinesis has no effect on a cable
/obj/structure/cable/do_simple_ranged_interaction(var/mob/user)
	return

// Items usable on a cable :
//   - Wirecutters : cut it duh !
//   - Cable coil : merge cables
//   - Multitool : get the power currently passing through the cable
//
/obj/structure/cable/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(!T.can_have_cabling())
		return

	if(W.iswirecutter() || (W.sharp || W.edge))

		if(!W.iswirecutter())
			if(user.a_intent != I_HELP)
				return

			if(W.flags & CONDUCT)
				shock(user, 50, 0.7)

		if(d1 == 12 || d2 == 12)
			to_chat(user, "<span class='warning'>You must cut this cable from above.</span>")
			return

		if(breaker_box)
			to_chat(user, "<span class='warning'>This cable is connected to nearby breaker box. Use breaker box to interact with it.</span>")
			return

		if (shock(user, 50))
			return

		if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
			new/obj/item/stack/cable_coil(T, 2, color)
		else
			new/obj/item/stack/cable_coil(T, 1, color)

		for(var/mob/O in viewers(src, null))
			O.show_message("<span class='warning'>[user] cuts the cable.</span>", 1)

		if(d1 == 11 || d2 == 11)
			var/turf/turf = GetBelow(src)
			if(turf)
				for(var/obj/structure/cable/c in turf)
					if(c.d1 == 12 || c.d2 == 12)
						qdel(c)

		investigate_log("was cut by [key_name(usr, usr.client)] in [user.loc.loc]","wires")

		qdel(src)
		return


	else if(W.iscoil())
		var/obj/item/stack/cable_coil/coil = W
		if (coil.get_amount() < 1)
			to_chat(user, "Not enough cable")
			return
		coil.cable_join(src, user)

	else if(W.ismultitool())

		if(powernet && (powernet.avail > 0))		// is it powered?
			to_chat(user, "<span class='warning'>[powernet.avail]W in power network.</span>")

		else
			to_chat(user, "<span class='warning'>The cable is not powered.</span>")

		shock(user, 5, 0.2)

	src.add_fingerprint(user)

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		spark(src, 5, alldirs)
		if(usr.stunned)
			return 1
	return 0

/obj/structure/cable/attack_generic(var/mob/user)
	//Let those rats (and other small things) nibble the cables
	if (issmall(user) && !isDrone(user))
		to_chat(user, span("danger","You bite into \the [src]."))
		if(powernet && powernet.avail > 100) //100W should be sufficient to grill a rat
			spark(src)
			user.dust()
	..()

/obj/structure/cable/shuttle_move(turf/loc)
	..()
	SSmachinery.powernet_update_queued = TRUE

//explosion handling
/obj/structure/cable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)

		if(3.0)
			if (prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)
	return

obj/structure/cable/proc/cableColor(var/colorC)
	var/color_n = "#DD0000"
	if(colorC)
		color_n = colorC
	color = color_n

/////////////////////////////////////////////////
// Cable laying helpers
////////////////////////////////////////////////

//handles merging diagonally matching cables
//for info : direction^3 is flipping horizontally, direction^12 is flipping vertically
/obj/structure/cable/proc/mergeDiagonalsNetworks(var/direction)

	//search for and merge diagonally matching cables from the first direction component (north/south)
	var/turf/T  = get_step(src, direction&3)//go north/south

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == (direction^3) || C.d2 == (direction^3)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

	//the same from the second direction component (east/west)
	T  = get_step(src, direction&12)//go east/west

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue
		if(C.d1 == (direction^12) || C.d2 == (direction^12)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the given direction
/obj/structure/cable/proc/mergeConnectedNetworks(var/direction)

	var/fdir = (!direction)? 0 : turn(direction, 180) //flip the direction, to match with the source position on its turf

	if(!(d1 == direction || d2 == direction)) //if the cable is not pointed in this direction, do nothing
		return

	var/turf/TB  = get_step(src, direction)

	for(var/obj/structure/cable/C in TB)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == fdir || C.d2 == fdir) //we've got a matching cable in the neighbor turf
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the source turf
/obj/structure/cable/proc/mergeConnectedNetworksOnTurf()
	var/list/to_connect = list()

	if(!powernet) //if we somehow have no powernet, make one (should not happen for cables)
		var/datum/powernet/newPN = new()
		newPN.add_cable(src)

	//first let's add turf cables to our powernet
	//then we'll connect machines on turf with a node cable is present
	for(var/AM in loc)
		if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM
			if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) //only connected if they have a common direction
				if(C.powernet == powernet)	continue
				if(C.powernet)
					merge_powernets(powernet, C.powernet)
				else
					powernet.add_cable(C) //the cable was powernetless, let's just add it to our powernet

		else if(istype(AM,/obj/machinery/power/apc))
			var/obj/machinery/power/apc/N = AM
			if(!N.terminal)	continue // APC are connected through their terminal

			if(N.terminal.powernet == powernet)
				continue

			to_connect += N.terminal //we'll connect the machines after all cables are merged

		else if(istype(AM,/obj/machinery/power)) //other power machines
			var/obj/machinery/power/M = AM

			if(M.powernet == powernet)
				continue

			to_connect += M //we'll connect the machines after all cables are merged

	//now that cables are done, let's connect found machines
	for(var/obj/machinery/power/PM in to_connect)
		if(!PM.connect_to_network())
			PM.disconnect_from_network() //if we somehow can't connect the machine to the new powernet, remove it from the old nonetheless

//////////////////////////////////////////////
// Powernets handling helpers
//////////////////////////////////////////////

//if powernetless_only = 1, will only get connections without powernet
/obj/structure/cable/proc/get_connections(var/powernetless_only = 0)
	. = list()	// this will be a list of all connected power objects
	var/turf/T

	// Handle up/down cables
	if(d1 == 11 || d2 == 11)
		T = GetBelow(src)
		if(T)
			. += power_list(T, src, 12, powernetless_only)

	if(d1 == 12 || d2 == 12)
		T = GetAbove(src)
		if(T)
			. += power_list(T, src, 11, powernetless_only)

	// Handle standard cables in adjacent turfs
	for(var/cable_dir in list(d1, d2))
		if(cable_dir == 11 || cable_dir == 12 || cable_dir == 0)
			continue
		var/reverse = reverse_dir[cable_dir]
		T = get_step(src, cable_dir)
		if(T)
			for(var/obj/structure/cable/C in T)
				if((C.d1 && C.d1 == reverse) || (C.d2 && C.d2 == reverse))
					. += C
		if(cable_dir & (cable_dir - 1)) // Diagonal, check for /\/\/\ style cables along cardinal directions
			for(var/pair in list(NORTH|SOUTH, EAST|WEST))
				T = get_step(src, cable_dir & pair)
				if(T)
					var/req_dir = cable_dir ^ pair
					for(var/obj/structure/cable/C in T)
						if((C.d1 && C.d1 == req_dir) || (C.d2 && C.d2 == req_dir))
							. += C

	// Handle cables on the same turf as us
	for(var/obj/structure/cable/C in loc)
		if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) // if either of C's d1 and d2 match either of ours
			. += C

	if(d1 == 0)
		for(var/obj/machinery/power/P in loc)
			if(P.powernet == 0) continue // exclude APCs with powernet=0
			if(!powernetless_only || !P.powernet)
				. += P

	// if the caller asked for powernetless cables only, dump the ones with powernets
	if(powernetless_only)
		for(var/obj/structure/cable/C in .)
			if(C.powernet)
				. -= C

//should be called after placing a cable which extends another cable, creating a "smooth" cable that no longer terminates in the centre of a turf.
//needed as this can, unlike other placements, disconnect cables
/obj/structure/cable/proc/denode()
	var/turf/T1 = loc
	if(!T1) return

	var/list/powerlist = power_list(T1,src,0,0) //find the other cables that ended in the centre of the turf, with or without a powernet
	if(powerlist.len>0)
		var/datum/powernet/PN = new()
		propagate_network(powerlist[1],PN) //propagates the new powernet beginning at the source cable

		if(PN.is_empty()) //can happen with machines made nodeless when smoothing cables
			qdel(PN)

// cut the cable's powernet at this cable and updates the powergrid
/obj/structure/cable/proc/cut_cable_from_powernet()
	var/turf/T1 = loc
	var/list/P_list
	if(!T1)	return
	if(d1)
		T1 = get_step(T1, d1)
		P_list = power_list(T1, src, turn(d1,180),0,cable_only = 1)	// what adjacently joins on to cut cable...

	P_list += power_list(loc, src, d1, 0, cable_only = 1)//... and on turf


	if(P_list.len == 0)//if nothing in both list, then the cable was a lone cable, just delete it and its powernet
		powernet.remove_cable(src)

		for(var/obj/machinery/power/P in T1)//check if it was powering a machine
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network (and delete powernet)
		return

	// remove the cut cable from its turf and powernet, so that it doesn't get count in propagate_network worklist
	loc = null
	powernet.remove_cable(src) //remove the cut cable from its powernet

	var/datum/powernet/newPN = new()// creates a new powernet...
	propagate_network(P_list[1], newPN)//... and propagates it to the other side of the cable

	// Disconnect machines connected to nodes
	if(d1 == 0) // if we cut a node (O-X) cable
		for(var/obj/machinery/power/P in T1)
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network

///////////////////////////////////////////////
// The cable coil object, used for laying cable
///////////////////////////////////////////////

////////////////////////////////
// Definitions
////////////////////////////////

#define MAXCOIL 30

/obj/item/stack/cable_coil
	name = "cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_RED
	desc = "A coil of power cable."
	throwforce = 10
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stacktype = /obj/item/stack/cable_coil
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/stack/cable_coil/Initialize(mapload, amt, param_color = null)
	. = ..(mapload, amt)

	if (param_color) // It should be red by default, so only recolor it if parameter was specified.
		color = param_color

	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()
	update_wclass()

/obj/item/stack/cable_coil/attack(mob/living/carbon/M, mob/user)
	if(..())
		return TRUE
	
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open != 0)
			if(can_operate(H))
				if(do_surgery(H,user,src))
					return TRUE
		else 
			if(!BP_IS_ROBOTIC(affecting))
				if(affecting.is_bandaged())
					to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been closed.</span>")
					return ..()
				else
					if(amount <= 10)
						to_chat(user, "<span class='notice'>You don't have enough coils for this!</span>")
						return
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
					for(var/datum/wound/W in affecting.wounds)
						if(W.bandaged)
							continue
						if(W.current_stage <= W.max_bleeding_stage)
							user.visible_message("<span class='notice'>\The [user] starts carefully suturing the open wound on [M]'s [affecting.name]...</span>", \
												"<span class='notice'>You start carefully suturing the open wound on [M]'s [affecting.name]... This will take a while.</span>")
							if(!do_mob(user, M, 200))
								user.visible_message("<span class='danger'>[user]'s hand slips and tears open the wound on [M]'s [affecting.name]!</span>", \
														"<span class='danger'><font size=2>The wound on your [affecting.name] is torn open!</font></span>")
								M.apply_damage(rand(1,10), BRUTE)
								break
							user.visible_message("<span class='notice'>\The [user] barely manages to stitch \a [W.desc] on [M]'s [affecting.name].</span>", \
														"<span class='notice'>You barely manage to stitch \a [W.desc] on [M]'s [affecting.name].</span>" )
							W.bandage("cable-stitched")
							use(10)
							affecting.add_pain(25)
							if(prob(50))
								var/obj/item/organ/external/O = H.get_organ(user.zone_sel.selecting)
								to_chat(H, "<span class='danger'>Something burns in your [O.name]!</span>")
								O.germ_level += rand(400, 600)
						else
							to_chat(user, "<span class='notice'>This wound isn't large enough for a stitch!</span>")
					affecting.update_damages()
			else
				return ..()

/obj/item/stack/cable_coil/afterattack(var/mob/living/M, var/mob/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.organs_by_name[user.zone_sel.selecting]

		if(!S)
			return

		if(!(S.status & ORGAN_ASSISTED) || user.a_intent != I_HELP)
			return ..()

		if(M.isSynthetic() && M == user && !(M.get_species() == "Military Frame"))
			to_chat(user, span("warning", "You can't repair damage to your own body - it's against OH&S."))
			return

		if(S.burn_dam)
			if(S.burn_dam > ROBOLIMB_SELF_REPAIR_CAP)
				to_chat(user, span("warning", "The damage is far too severe to patch over externally!"))
				return
			else
				repair_organ(user, H, S)

		else if(S.open != 2)
			to_chat(user, span("notice", "You can't see any external damage to repair."))

	else
		return ..()

/obj/item/stack/cable_coil/proc/repair_organ(var/mob/living/user, var/mob/living/carbon/human/target, var/obj/item/organ/external/affecting)
	if(!affecting.burn_dam)
		user.visible_message(span("notice", "\The [user] finishes mending the burnt wiring in [target]'s [affecting]."))
		return

	if(do_mob(user, target, 30))
		if(use(2))
			var/static/list/repair_messages = list(
				"mends some cables",
				"adjusts some wiring",
				"splices some cables"
			)
			affecting.heal_damage(burn = 15, robo_repair = TRUE)
			user.visible_message(span("notice", "\The [user] [pick(repair_messages)] in [target]'s [affecting.name] with \the [src]."))
			playsound(target, 'sound/items/Wirecutter.ogg', 15)
			repair_organ(user, target, affecting)
		else
			to_chat(user, span("warning", "You don't have enough cable for this!"))

/obj/item/stack/cable_coil/update_icon()
	if (!color)
		color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_ORANGE, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
	if(amount == 1)
		icon_state = "coil1"
		name = "cable piece"
	else if(amount == 2)
		icon_state = "coil2"
		name = "cable piece"
	else
		icon_state = "coil"
		name = "cable coil"

/obj/item/stack/cable_coil/proc/set_cable_color(var/selected_color, var/user)
	if(!selected_color)
		return

	var/final_color = possible_cable_coil_colours[selected_color]
	if(!final_color)
		final_color = possible_cable_coil_colours["Red"]
		selected_color = "red"
	color = final_color
	to_chat(user, "<span class='notice'>You change \the [src]'s color to [lowertext(selected_color)].</span>")

/obj/item/stack/cable_coil/proc/update_wclass()
	if(amount == 1)
		w_class = 1.0
	else
		w_class = 2.0

/obj/item/stack/cable_coil/examine(mob/user)
	if(get_dist(src, user) > 1)
		return

	if(get_amount() == 1)
		to_chat(user, "A short piece of power cable.")
	else if(get_amount() == 2)
		to_chat(user, "A piece of power cable.")
	else
		to_chat(user, "A coil of power cable. There are <b>[get_amount()]</b> lengths of cable in the coil.")

/obj/item/stack/cable_coil/iscoil()
	return TRUE

/obj/item/stack/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.restrained() && !M.stat && !M.paralysis && ! M.stunned)
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			to_chat(usr, "<span class='warning'>You need at least 15 lengths to make restraints!</span>")
			return
		var/obj/item/handcuffs/cable/B = new /obj/item/handcuffs/cable(usr.loc)
		B.color = color
		to_chat(usr, "<span class='notice'>You wind some cable together to make some restraints.</span>")
		src.use(15)
	else
		to_chat(usr, "<span class='notice'>You cannot do that.</span>")

/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)

/obj/item/stack/cable_coil/cyborg/verb/set_colour()
	set name = "Change Colour"
	set category = "Object"

	var/selected_type = input("Pick new colour.", "Cable Colour", null, null) as null|anything in possible_cable_coil_colours
	set_cable_color(selected_type, usr)

// Items usable on a cable coil :
//   - Wirecutters : cut them duh !
//   - Cable coil : merge cables
/obj/item/stack/cable_coil/proc/can_merge(var/obj/item/stack/cable_coil/C)
	return color == C.color

/obj/item/stack/cable_coil/cyborg/can_merge()
	return 1

/obj/item/stack/cable_coil/transfer_to(obj/item/stack/cable_coil/S)
	if(!istype(S))
		return
	if(!can_merge(S))
		return

	..()

/obj/item/stack/cable_coil/use()
	. = ..()
	update_icon()
	return

/obj/item/stack/cable_coil/add()
	. = ..()
	update_icon()
	return

///////////////////////////////////////////////
// Cable laying procedures
//////////////////////////////////////////////

// called when cable_coil is clicked on a turf/simulated/floor
/obj/item/stack/cable_coil/proc/turf_place(turf/F, mob/user)
	if(!isturf(user.loc))
		return

	if(get_amount() < 1) // Out of cable
		to_chat(user, "There is no cable left.")
		return

	if(get_dist(F,user) > 1) // Too far
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if (!F.can_lay_cable())
		if (istype(F, /turf/simulated/floor))
			to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
		else
			to_chat(user, "You can't lay cable there unless there is plating or a catwalk.")
		return

	else
		var/dirn

		if(user.loc == F)
			dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, user)

		for(var/obj/structure/cable/LC in F)
			if((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
				to_chat(user, "<span class='warning'>There's already a cable at that position.</span>")
				return
///// Z-Level Stuff
		// check if the target is open space
		if(isopenturf(F))
			for(var/obj/structure/cable/LC in F)
				if((LC.d1 == dirn && LC.d2 == 11 ) || ( LC.d2 == dirn && LC.d1 == 11))
					to_chat(user, "<span class='warning'>There's already a cable at that position.</span>")
					return

			var/obj/structure/cable/C = new(F)
			var/obj/structure/cable/D = new(GetBelow(F))

			C.cableColor(color)

			C.d1 = 11
			C.d2 = dirn
			C.add_fingerprint(user)
			C.updateicon()

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			D.cableColor(color)

			D.d1 = 12
			D.d2 = 0
			D.add_fingerprint(user)
			D.updateicon()

			PN.add_cable(D)
			D.mergeConnectedNetworksOnTurf()

		// do the normal stuff
		else
///// Z-Level Stuff
			for(var/obj/structure/cable/LC in F)
				if((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
					to_chat(user, "There's already a cable at that position.")
					return

			var/obj/structure/cable/C = new(F)

			C.cableColor(color)

			//set up the new cable
			C.d1 = 0 //it's a O-X node cable
			C.d2 = dirn
			C.add_fingerprint(user)
			C.updateicon()

			//create a new powernet with the cable, if needed it will be merged later
			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2) //merge the powernet with adjacents powernets
			C.mergeConnectedNetworksOnTurf() //merge the powernet with on turf powernets

			if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)


			use(1)
			if (C.shock(user, 50))
				if (prob(50)) //fail
					new/obj/item/stack/cable_coil(C.loc, 1, C.color)
					qdel(C)

// called when cable_coil is click on an installed obj/cable
// or click on a turf that already contains a "node" cable
/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)
	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || !T.can_have_cabling())		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		to_chat(user, "You can't lay cable at a place that far away.")
		return


	if(U == T) //if clicked on the turf we're standing on, try to put a cable in the direction we're facing
		turf_place(T,user)
		return

	var/dirn = get_dir(C, user)

	// one end of the clicked cable is pointing towards us
	if(C.d1 == dirn || C.d2 == dirn)
		if(!T.can_have_cabling())						// can't place a cable if the floor is complete
			to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					to_chat(user, "There's already a cable at that position.")
					return

			var/obj/structure/cable/NC = new(U)
			NC.cableColor(color)

			NC.d1 = 0
			NC.d2 = fdirn
			NC.add_fingerprint()
			NC.updateicon()

			//create a new powernet with the cable, if needed it will be merged later
			var/datum/powernet/newPN = new()
			newPN.add_cable(NC)

			NC.mergeConnectedNetworks(NC.d2) //merge the powernet with adjacents powernets
			NC.mergeConnectedNetworksOnTurf() //merge the powernet with on turf powernets

			if(NC.d2 & (NC.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				NC.mergeDiagonalsNetworks(NC.d2)

			use(1)

			if (NC.shock(user, 50))
				if (prob(50)) //fail
					new/obj/item/stack/cable_coil(NC.loc, 1, NC.color)
					qdel(NC)

			return

	// exisiting cable doesn't point at our position, so see if it's a stub
	else if(C.d1 == 0)
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T)		// check to make sure there's no matching cable
			if(LC == C)			// skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				to_chat(user, "There's already a cable at that position.")
				return


		C.cableColor(color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.updateicon()


		C.mergeConnectedNetworks(C.d1) //merge the powernets...
		C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
		C.mergeConnectedNetworksOnTurf()

		if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d1)

		if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d2)

		use(1)

		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				qdel(C)
				return

		C.denode()// this call may have disconnected some cables that terminated on the centre of the turf, if so split the powernets.
		return

//////////////////////////////
// Misc.
/////////////////////////////

/obj/item/stack/cable_coil/cut
	item_state = "coil2"

/obj/item/stack/cable_coil/cut/Initialize(mapload)
	. = ..()
	src.amount = rand(1,2)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()
	update_wclass()

/obj/item/stack/cable_coil/yellow
	color = COLOR_YELLOW

/obj/item/stack/cable_coil/blue
	color = COLOR_BLUE

/obj/item/stack/cable_coil/green
	color = COLOR_LIME

/obj/item/stack/cable_coil/pink
	color = COLOR_PINK

/obj/item/stack/cable_coil/orange
	color = COLOR_ORANGE

/obj/item/stack/cable_coil/cyan
	color = COLOR_CYAN

/obj/item/stack/cable_coil/white
	color = COLOR_WHITE

/obj/item/stack/cable_coil/random/Initialize()
	color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
	. = ..()

//nooses - all catbeast/ligger/squiggers/synths must hang

/obj/item/stack/cable_coil/verb/make_noose()
	set name = "Make Noose"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.restrained() && !M.stat && !M.paralysis && ! M.stunned)
		if(!istype(usr.loc,/turf)) return
		if(!(locate(/obj/item/stool) in usr.loc) && !(locate(/obj/structure/bed) in usr.loc) && !(locate(/obj/structure/table) in usr.loc) && !(locate(/obj/structure/toilet) in usr.loc))
			to_chat(usr, "<span class='warning'>You have to be standing on top of a chair/table/bed to make a noose!</span>")
			return 0
		if(src.amount <= 24)
			to_chat(usr, "<span class='warning'>You need at least 25 lengths to make a noose!</span>")
			return
		new /obj/structure/noose(usr.loc)
		to_chat(usr, "<span class='notice'>You wind some cable together to make a noose, tying it to the ceiling.</span>")
		src.use(25)
	else
		to_chat(usr, "<span class='notice'>You cannot do that.</span>")

/obj/structure/noose
	name = "noose"
	desc = "A morbid apparatus."
	icon_state = "noose"
	buckle_lying = 0
	icon = 'icons/obj/noose.dmi'
	anchored = 1
	can_buckle = 1
	layer = 5
	var/image/over = null
	var/ticks = 0

/obj/structure/noose/attackby(obj/item/W, mob/user, params)
	if(W.iswirecutter())
		user.visible_message("[user] cuts the noose.", "<span class='notice'>You cut the noose.</span>")
		if(buckled_mob)
			buckled_mob.visible_message("<span class='danger'>[buckled_mob] falls over and hits the ground!</span>",\
										"<span class='danger'>You fall over and hit the ground!</span>")
			buckled_mob.adjustBruteLoss(10)
		var/obj/item/stack/cable_coil/C = new(get_turf(src))
		C.amount = 25
		qdel(src)
		return
	..()

/obj/structure/noose/Initialize()
	. = ..()
	pixel_y += 16 //Noose looks like it's "hanging" in the air
	over = image(icon, "noose_overlay")
	over.layer = MOB_LAYER + 0.1

/obj/structure/noose/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/noose/post_buckle_mob(mob/living/M)
	if(M == buckled_mob)
		layer = MOB_LAYER
		add_overlay(over)
		START_PROCESSING(SSprocessing, src)
		M.pixel_y = initial(M.pixel_y) + 8 //rise them up a bit
		M.dir = SOUTH
	else
		layer = initial(layer)
		cut_overlay(over)
		STOP_PROCESSING(SSprocessing, src)
		pixel_x = initial(pixel_x)
		M.pixel_x = initial(M.pixel_x)
		M.pixel_y = initial(M.pixel_y)

/obj/structure/noose/user_unbuckle_mob(mob/living/user)

	if(!user.IsAdvancedToolUser())
		return

	if(buckled_mob && buckled_mob.buckled == src)
		var/mob/living/M = buckled_mob
		if(M != user)
			user.visible_message("<span class='notice'>[user] begins to untie the noose over [M]'s neck...</span>",\
								"<span class='notice'>You begin to untie the noose over [M]'s neck...</span>")
			if(do_mob(user, M, 100))
				user.visible_message("<span class='notice'>[user] unties the noose over [M]'s neck!</span>",\
									"<span class='notice'>You untie the noose over [M]'s neck!</span>")
			else
				return
		else
			M.visible_message(\
				"<span class='warning'>[M] struggles to untie the noose over their neck!</span>",\
				"<span class='notice'>You struggle to untie the noose over your neck.</span>")
			if(!do_after(M, 150))
				if(M && M.buckled)
					to_chat(M, "<span class='warning'>You fail to untie yourself!</span>")
				return
			if(!M.buckled)
				return
			M.visible_message(\
				"<span class='warning'>[M] unties the noose over their neck!</span>",\
				"<span class='notice'>You untie the noose over your neck!</span>")
			M.Weaken(3)
		unbuckle_mob()
		add_fingerprint(user)

/obj/structure/noose/user_buckle_mob(mob/living/carbon/human/M, mob/user)
	if(!in_range(user, src) || user.stat || user.restrained() || !istype(M))
		return 0

	if(!user.IsAdvancedToolUser())
		return

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		if(!affecting)
			to_chat(user, "<span class='danger'>They don't have a head.</span>")
			return

	if(M.loc != src.loc) return 0 //Can only noose someone if they're on the same tile as noose

	add_fingerprint(user)

	if(M == user && buckle_mob(M))
		M.visible_message(\
			"<span class='warning'>[M] ties \the [src] over their neck!</span>",\
			"<span class='warning'>You tie \the [src] over your neck!</span>")
		playsound(user.loc, 'sound/effects/noosed.ogg', 50, 1, -1)
		SSfeedback.IncrementSimpleStat("hangings")
		return 1
	else
		M.visible_message(\
			"<span class='danger'>[user] attempts to tie \the [src] over [M]'s neck!</span>",\
			"<span class='danger'>[user] ties \the [src] over your neck!</span>")
		to_chat(user, "<span class='notice'>It will take 20 seconds and you have to stand still.</span>")
		if(do_after(user, 200))
			if(buckle_mob(M))
				M.visible_message(\
					"<span class='danger'>[user] ties \the [src] over [M]'s neck!</span>",\
					"<span class='danger'>[user] ties \the [src] over your neck!</span>")
				playsound(user.loc, 'sound/effects/noosed.ogg', 50, 1, -1)
				SSfeedback.IncrementSimpleStat("hangings")
				return 1
			else
				user.visible_message(\
					"<span class='warning'>[user] fails to tie \the [src] over [M]'s neck!</span>",\
					"<span class='warning'>You fail to tie \the [src] over [M]'s neck!</span>")
				return 0
		else
			user.visible_message(\
				"<span class='warning'>[user] fails to tie \the [src] over [M]'s neck!</span>",\
				"<span class='warning'>You fail to tie \the [src] over [M]'s neck!</span>")
			return 0

/obj/structure/noose/process(mob/living/carbon/human/M, mob/user)
	if(!buckled_mob)
		STOP_PROCESSING(SSprocessing, src)
		buckled_mob.pixel_x = initial(buckled_mob.pixel_x)
		pixel_x = initial(pixel_x)
		return

	ticks++
	switch(ticks)
		if(1)
			pixel_x -= 1
			buckled_mob.pixel_x -= 1
		if(2)
			pixel_x = initial(pixel_x)
			buckled_mob.pixel_x = initial(buckled_mob.pixel_x)
		if(3) //Every third tick it plays a sound and RNG's a flavor text
			pixel_x += 1
			buckled_mob.pixel_x += 1
			if(buckled_mob)
				if (ishuman(buckled_mob))
					var/mob/living/carbon/human/H = buckled_mob
					if (H.species && (H.species.flags & NO_BREATHE))
						return
				if(prob(15))
					var/flavor_text = list("<span class='warning'>[buckled_mob]'s legs flail for anything to stand on.</span>",\
											"<span class='warning'>[buckled_mob]'s hands are desperately clutching the noose.</span>",\
											"<span class='warning'>[buckled_mob]'s limbs sway back and forth with diminishing strength.</span>")
					if(buckled_mob.stat == DEAD)
						flavor_text = list("<span class='warning'>[buckled_mob]'s limbs lifelessly sway back and forth.</span>",\
											"<span class='warning'>[buckled_mob]'s eyes stare straight ahead.</span>")
					buckled_mob.visible_message(pick(flavor_text))
				playsound(buckled_mob.loc, 'sound/effects/noose_idle.ogg', 50, 1, -3)
		if(4)
			pixel_x = initial(pixel_x)
			buckled_mob.pixel_x = initial(buckled_mob.pixel_x)
			ticks = 0

	if(buckled_mob)
		if (ishuman(buckled_mob))
			var/mob/living/carbon/human/H = buckled_mob
			if (H.species && (H.species.flags & NO_BREATHE))
				return
		buckled_mob.adjustOxyLoss(5)
		buckled_mob.adjustBrainLoss(1)
		buckled_mob.silent = max(buckled_mob.silent, 10)
		if(prob(25)) //to reduce gasp spam
			buckled_mob.emote("gasp")
