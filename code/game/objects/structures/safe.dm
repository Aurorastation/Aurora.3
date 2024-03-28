/*
CONTAINS:
SAFES
FLOOR SAFES
*/

//SAFES
/obj/structure/safe
	name = "safe"
	desc = "A huge chunk of metal with a dial embedded in it. Fine print on the dial reads \"Scarborough Arms - 2 tumbler safe, guaranteed thermite resistant, explosion resistant, and assistant resistant.\""
	icon = 'icons/obj/safe.dmi'
	icon_state = "safe"
	anchored = 1
	density = 1
	var/broken = FALSE	//is the tumbler broken into
	var/open = 0		//is the safe open?
	var/tumbler_1_pos	//the tumbler position- from 0 to 71
	var/tumbler_1_open	//the tumbler position to open at- 0 to 71
	var/tumbler_2_pos
	var/tumbler_2_open
	var/dial = 0		//where is the dial pointing?
	var/space = 0		//the combined w_class of everything in the safe
	var/maxspace = 24	//the maximum combined w_class of stuff in the safe

	// Variables (Drill)
	var/obj/item/thermal_drill/drill	// The currently placed thermal drill, if any.
	var/time_to_drill = 300 SECONDS		// Drill duration of the current thermal drill.
	var/last_drill_time = 0				// Last world.time the drill time was checked. Used to reduce time_to_drill accurately
	var/image/drill_overlay				// The drill overlay image to display during the drilling process.
	var/drill_x_offset = -4				// The X pixel offset for the drill
	var/drill_y_offset = -8				// The Y pixel offset for the drill

/obj/structure/safe/Initialize()
	. = ..()
	tumbler_1_pos = rand(0, 71)
	tumbler_1_open = rand(0, 71)

	tumbler_2_pos = rand(0, 71)
	tumbler_2_open = min(71 , max( 1 , abs(tumbler_1_open + rand(-34, 34))))
	for(var/obj/item/I in loc)
		if(space >= maxspace)
			return
		if(I.w_class + space <= maxspace)
			space += I.w_class
			I.forceMove(src)

/obj/structure/safe/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(broken)
		. += SPAN_WARNING("\The [src]'s locking system has been drilled open!")
	else if(time_to_drill < 300 SECONDS)
		var/time_left = max(round(time_to_drill / 10), 0)
		. += SPAN_WARNING("There are only [time_left] second\s of drilling left until \the [src] is broken!")

/obj/structure/safe/Destroy()
	if(drill)
		drill.soundloop.stop()
		drill.forceMove(loc)
		drill = null
	return ..()

/obj/structure/safe/proc/check_unlocked(mob/user as mob, canhear)
	if(user && canhear)
		if(tumbler_1_pos == tumbler_1_open)
			to_chat(user, SPAN_NOTICE("You hear a [pick("tonk", "krunk", "plunk")] from [src]."))
		if(tumbler_2_pos == tumbler_2_open)
			to_chat(user, SPAN_NOTICE("You hear a [pick("tink", "krink", "plink")] from [src]."))
	if(tumbler_1_pos == tumbler_1_open && tumbler_2_pos == tumbler_2_open)
		if(user) visible_message("<b>[pick("Spring", "Sprang", "Sproing", "Clunk", "Krunk")]!</b>")
		return 1
	return 0


/obj/structure/safe/proc/decrement(num)
	num -= 1
	if(num < 0)
		num = 71
	return num


/obj/structure/safe/proc/increment(num)
	num += 1
	if(num > 71)
		num = 0
	return num


/obj/structure/safe/update_icon()
	if(open)
		if(broken)
			icon_state = "[initial(icon_state)]-open-broken"
		else
			icon_state = "[initial(icon_state)]-open"
	else
		if(broken)
			icon_state = "[initial(icon_state)]-broken"
		else
			icon_state = initial(icon_state)

	cut_overlay(drill_overlay)
	if(istype(drill, /obj/item/thermal_drill))
		var/drill_icon = istype(drill, /obj/item/thermal_drill/diamond_drill) ? "d" : "h"
		var/state = "[initial(icon_state)]_[drill_icon]-drill-[isprocessing ? "on" : "off"]"
		drill_overlay = image(icon = 'icons/effects/drill.dmi', icon_state = state, pixel_x = drill_x_offset, pixel_y = drill_y_offset)
		add_overlay(drill_overlay)

/obj/structure/safe/attack_hand(mob/user as mob)
	if(drill)
		switch(alert("What would you like to do?", "Thermal Drill", "Turn [isprocessing ? "Off" : "On"]", "Remove Drill", "Cancel"))
			if("Turn On")
				if(!drill || isprocessing)
					return
				if(broken)
					to_chat(user, SPAN_WARNING("\The [src] is already broken open!"))
					return
				if(do_after(user, 2 SECONDS))
					if(!drill || isprocessing)
						return
					if(broken)
						return
					last_drill_time = world.time
					drill.soundloop.start()
					START_PROCESSING(SSprocessing, src)
					update_icon()
			if("Turn Off")
				if(!drill || !isprocessing)
					return
				if(do_after(user, 2 SECONDS))
					if(!drill || !isprocessing)
						return
					drill.soundloop.stop()
					STOP_PROCESSING(SSprocessing, src)
					update_icon()
			if("Remove Drill")
				if(isprocessing)
					to_chat(user, SPAN_WARNING("You cannot remove the drill while it's running!"))
				else if(do_after(user, 2 SECONDS))
					if(isprocessing)
						return
					user.put_in_hands(drill)
					drill = null
					update_icon()
			if("Cancel")
				return
	else
		user.set_machine(src)
		var/dat = "<center>"
		dat += "<a href='?src=\ref[src];open=1'>[open ? "Close" : "Open"] [src]</a>[drill || broken ? "" : " | <a href='?src=\ref[src];decrement=1'>-</a> [dial * 5] <a href='?src=\ref[src];increment=1'>+</a>"]"
		if(open)
			dat += "<table>"
			for(var/i = contents.len, i>=1, i--)
				var/obj/item/P = contents[i]
				dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
			dat += "</table></center>"
		user << browse("<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=safe;size=350x300")


/obj/structure/safe/Topic(href, href_list)
	if(!ishuman(usr))	return
	var/mob/living/carbon/human/user = usr

	var/canhear = 0
	if(istype(user.l_hand, /obj/item/clothing/accessory/stethoscope) || istype(user.r_hand, /obj/item/clothing/accessory/stethoscope))
		canhear = 1

	if(href_list["open"])
		if(drill)
			to_chat(user, SPAN_WARNING("You can't open \the [src] if there's a drill attached."))
			return
		if(broken || check_unlocked())
			to_chat(user, SPAN_NOTICE("You [open ? "close" : "open"] [src]."))
			open = !open
			update_icon()
			updateUsrDialog()
			return
		else
			to_chat(user, SPAN_NOTICE("You can't [open ? "close" : "open"] [src], the lock is engaged!"))
			return

	if(href_list["decrement"])
		dial = decrement(dial)
		if(dial == tumbler_1_pos + 1 || dial == tumbler_1_pos - 71)
			tumbler_1_pos = decrement(tumbler_1_pos)
			if(canhear)
				to_chat(user, SPAN_NOTICE("You hear a [pick("clack", "scrape", "clank")] from [src]."))
			if(tumbler_1_pos == tumbler_2_pos + 37 || tumbler_1_pos == tumbler_2_pos - 35)
				tumbler_2_pos = decrement(tumbler_2_pos)
				if(canhear)
					to_chat(user, SPAN_NOTICE("You hear a [pick("click", "chink", "clink")] from [src]."))
			check_unlocked(user, canhear)
		updateUsrDialog()
		return

	if(href_list["increment"])
		dial = increment(dial)
		if(dial == tumbler_1_pos - 1 || dial == tumbler_1_pos + 71)
			tumbler_1_pos = increment(tumbler_1_pos)
			if(canhear)
				to_chat(user, SPAN_NOTICE("You hear a [pick("clack", "scrape", "clank")] from [src]."))
			if(tumbler_1_pos == tumbler_2_pos - 37 || tumbler_1_pos == tumbler_2_pos + 35)
				tumbler_2_pos = increment(tumbler_2_pos)
				if(canhear)
					to_chat(user, SPAN_NOTICE("You hear a [pick("click", "chink", "clink")] from [src]."))
			check_unlocked(user, canhear)
		updateUsrDialog()
		return

	if(href_list["retrieve"])
		user << browse("", "window=safe") // Close the menu)

		var/obj/item/P = locate(href_list["retrieve"]) in src
		if(open)
			if(P && in_range(src, user))
				user.put_in_hands(P)
				updateUsrDialog()


/obj/structure/safe/attackby(obj/item/attacking_item, mob/user)
	if(open)
		if(attacking_item.w_class + space <= maxspace)
			space += attacking_item.w_class
			user.drop_from_inventory(attacking_item, src)
			to_chat(user, SPAN_NOTICE("You put [attacking_item] in [src]."))
			updateUsrDialog()
			return
		else
			to_chat(user, SPAN_NOTICE("[attacking_item] won't fit in [src]."))
			return
	else
		if(istype(attacking_item, /obj/item/clothing/accessory/stethoscope))
			attack_hand(user)
		else if(istype(attacking_item, /obj/item/thermal_drill))
			if(drill)
				to_chat(user, SPAN_WARNING("There is already a drill attached!"))
			else if(do_after(user, 2 SECONDS))
				user.drop_from_inventory(attacking_item, src)
				drill = attacking_item
				update_icon()
		else
			to_chat(user, SPAN_WARNING("You can't put [attacking_item] into the safe while it is closed!"))

/obj/structure/safe/process()
	if(!drill)
		return
	time_to_drill -= (world.time - last_drill_time) * drill.time_multiplier
	last_drill_time = world.time
	if(prob(15))
		spark(loc, 3, GLOB.alldirs)
	if(time_to_drill <= 0)
		drill_open()

/obj/structure/safe/proc/drill_open()
	broken = TRUE
	drill.soundloop.stop()
	STOP_PROCESSING(SSprocessing, src)
	update_icon()

/obj/structure/safe/ex_act(severity)
	return

//FLOOR SAFES
/obj/structure/safe/floor
	name = "floor safe"
	icon_state = "floorsafe"
	density = 0
	level = 1	//underfloor
	layer = BELOW_OBJ_LAYER
	drill_x_offset = -1
	drill_y_offset = 20

/obj/structure/safe/floor/Initialize()
	. = ..()
	var/turf/T = loc
	if(istype(T) && !T.is_plating())
		hide(1)
	update_icon()

/obj/structure/safe/floor/hide(var/intact)
	set_invisibility(intact ? 101 : 0)

/obj/structure/safe/floor/hides_under_flooring()
	return 1

//random station safe, may come with some different loot
/obj/structure/safe/station
	name = "corporate safe"

/obj/structure/safe/station/Initialize()
	. = ..()
	new /obj/item/stack/telecrystal/twentyfive(src)
	new /obj/random/highvalue/safe(src)
	new /obj/random/highvalue/safe(src)
	new /obj/random/highvalue/safe(src)
	new /obj/random/highvalue/safe(src)
	new /obj/random/highvalue/safe(src)

/obj/structure/safe/cash
	name = "credit safe"

/obj/structure/safe/cash/Initialize()
	. = ..()
	new /obj/random/highvalue/cash(src)
	new /obj/random/highvalue/cash(src)
	new /obj/random/highvalue/cash(src)

/obj/structure/safe/highvalue
	name = "valuables safe"

/obj/structure/safe/highvalue/Initialize()
	. = ..()
	new /obj/random/highvalue/no_weapon(src)
	new /obj/random/highvalue/no_weapon(src)
	new /obj/random/highvalue/no_weapon(src)
	new /obj/random/highvalue/no_weapon(src)
