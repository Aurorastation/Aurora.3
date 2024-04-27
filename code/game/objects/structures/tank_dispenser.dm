/obj/structure/dispenser
	name = "gas tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 oxygen tanks and 10 phoron tanks."
	icon = 'icons/obj/tank_dispenser.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	w_class = ITEMSIZE_HUGE
	var/max_tanks = 20
	var/oxygen_tanks = 10
	var/phoron_tanks = 10
	var/list/held_oxygen_tanks = list()
	var/list/held_phoron_tanks = list()

// Oxygen
/obj/structure/dispenser/oxygen
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 oxygen tanks."
	max_tanks = 10
	phoron_tanks = 0

// Phoron
/obj/structure/dispenser/phoron
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 phoron tanks."
	oxygen_tanks = 0

/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()

/obj/structure/dispenser/update_icon()
	cut_overlays()
	switch(oxygen_tanks)
		if(1 to 4)
			add_overlay("oxygen-[oxygen_tanks]")
		if(5 to INFINITY)
			add_overlay("oxygen-5")
	switch(phoron_tanks)
		if(1 to 4)
			add_overlay("phoron-[phoron_tanks]")
		if(5 to INFINITY)
			add_overlay("phoron-5")

/obj/structure/dispenser/attack_ai(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "<br>"
	dat += "Oxygen Tanks: [oxygen_tanks] - [oxygen_tanks ? "<a href='?src=\ref[src];oxygen=1'>Dispense</a>" : "empty"]<br>"
	dat += "Phoron Tanks: [phoron_tanks] - [phoron_tanks ? "<a href='?src=\ref[src];phoron=1'>Dispense</a>" : "empty"]"

	var/datum/browser/dispenser_win = new(user, "dispenser", capitalize_first_letters(name), 300, 250)
	dispenser_win.set_content(dat)
	dispenser_win.open()

/obj/structure/dispenser/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/tank/oxygen) || istype(attacking_item, /obj/item/tank/air) || istype(attacking_item, /obj/item/tank/anesthetic))
		if(oxygen_tanks < max_tanks)
			user.drop_from_inventory(attacking_item, src)
			held_oxygen_tanks.Add(attacking_item)
			oxygen_tanks++
			to_chat(user, SPAN_NOTICE("You put \the [attacking_item] into \the [src]."))
			if(oxygen_tanks < 5)
				update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] is full."))
		updateUsrDialog()
		return
	if(istype(attacking_item, /obj/item/tank/phoron))
		if(phoron_tanks < max_tanks)
			user.drop_from_inventory(attacking_item, src)
			held_oxygen_tanks.Add(attacking_item)
			phoron_tanks++
			to_chat(user, SPAN_NOTICE("You put \the [attacking_item] into \the [src]."))
			if(oxygen_tanks < 6)
				update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] is full."))
		updateUsrDialog()
		return
	if(attacking_item.iswrench())
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
			if(oxygen_tanks > 0)
				var/obj/item/tank/oxygen/O
				if(held_oxygen_tanks.len == oxygen_tanks)
					O = held_oxygen_tanks[1]
					held_oxygen_tanks.Remove(O)
				else
					O = new /obj/item/tank/oxygen(loc)
				usr.put_in_hands(O)
				to_chat(usr, SPAN_NOTICE("You take \the [O] out of \the [src]."))
				oxygen_tanks--
				update_icon()
		if(href_list[GAS_PHORON])
			if(phoron_tanks > 0)
				var/obj/item/tank/phoron/P
				if(held_phoron_tanks.len == phoron_tanks)
					P = held_phoron_tanks[1]
					held_phoron_tanks.Remove(P)
				else
					P = new /obj/item/tank/phoron(loc)
				usr.put_in_hands(P)
				to_chat(usr, SPAN_NOTICE("You take \the [P] out of \the [src]."))
				phoron_tanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		usr << browse(null, "window=dispenser")
