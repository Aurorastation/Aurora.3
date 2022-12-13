/obj/structure/dispenser
	name = "gas tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 oxygen and phoron tanks."
	icon = 'icons/obj/tank_dispenser.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	w_class = ITEMSIZE_HUGE
	var/oxygentanks = 10
	var/phorontanks = 10
	var/max_tanks = 10
	var/list/oxytanks = list()	//sorry for the similar var names
	var/list/platanks = list()

/obj/structure/dispenser/oxygen
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 oxygen tanks."
	phorontanks = 0

/obj/structure/dispenser/oxygen/large
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 20 oxygen tanks."
	oxygentanks = 20
	max_tanks = 20

/obj/structure/dispenser/phoron
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 phoron tanks."
	oxygentanks = 0

/obj/structure/dispenser/oxygen/large
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 20 phoron tanks."
	phorontanks = 20
	max_tanks = 20

/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()

/obj/structure/dispenser/update_icon()
	cut_overlays()
	switch(oxygentanks)
		if(1 to 4)
			add_overlay("oxygen-[oxygentanks]")
		if(5 to INFINITY)
			add_overlay("oxygen-5")
	switch(phorontanks)
		if(1 to 4)
			add_overlay("phoron-[phorontanks]")
		if(5 to INFINITY)
			add_overlay("phoron-5")

/obj/structure/dispenser/attack_ai(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "<br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Phoron tanks: [phorontanks] - [phorontanks ? "<A href='?src=\ref[src];phoron=1'>Dispense</A>" : "empty"]"
	
	var/datum/browser/dispenser_win = new(user, "dispenser", capitalize_first_letters(name), 300, 250)
	dispenser_win.set_content(dat)
	dispenser_win.open()

/obj/structure/dispenser/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tank/oxygen))
		if(oxygentanks < max_tanks)
			user.drop_from_inventory(I, src)
			oxytanks.Add(I)
			oxygentanks++
			to_chat(user, SPAN_NOTICE("You put \the [I] into \the [src]."))
			if(oxygentanks <= 5)
				update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] is full."))
		updateUsrDialog()
		return
	if(istype(I, /obj/item/tank/phoron))
		if(phorontanks < max_tanks)
			user.drop_from_inventory(I, src)
			platanks.Add(I)
			phorontanks++
			to_chat(user, SPAN_NOTICE("You put \the [I] into \the [src]."))
			if(oxygentanks <= 5)
				update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] is full."))
		updateUsrDialog()
		return
	if(I.iswrench())
		if(anchored)
			to_chat(user, SPAN_NOTICE("You lean down and unwrench \the [src]."))
			anchored = FALSE
		else
			to_chat(user, SPAN_NOTICE("You wrench \the [src] into place."))
			anchored = TRUE
		return

/obj/structure/dispenser/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(Adjacent(usr))
		usr.set_machine(src)
		if(href_list[GAS_OXYGEN])
			if(oxygentanks > 0)
				var/obj/item/tank/oxygen/O
				if(oxytanks.len == oxygentanks)
					O = oxytanks[1]
					oxytanks.Remove(O)
				else
					O = new /obj/item/tank/oxygen(loc)
				usr.put_in_hands(O)
				to_chat(usr, SPAN_NOTICE("You take \the [O] out of \the [src]."))
				oxygentanks--
				update_icon()
		if(href_list[GAS_PHORON])
			if(phorontanks > 0)
				var/obj/item/tank/phoron/P
				if(platanks.len == phorontanks)
					P = platanks[1]
					platanks.Remove(P)
				else
					P = new /obj/item/tank/phoron(loc)
				usr.put_in_hands(P)
				to_chat(usr, SPAN_NOTICE("You take \the [P] out of \the [src]."))
				phorontanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		usr << browse(null, "window=dispenser")