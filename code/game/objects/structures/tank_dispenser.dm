/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten phoron tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = 1
	anchored = 1.0
	w_class = 5
	var/oxygentanks = 10
	var/phorontanks = 10
	var/list/oxytanks = list()	//sorry for the similar var names
	var/list/platanks = list()

/obj/structure/dispenser/oxygen
	phorontanks = 0

/obj/structure/dispenser/phoron
	oxygentanks = 0

/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()

/obj/structure/dispenser/update_icon()
	cut_overlays()
	switch(oxygentanks)
		if(1 to 3)
			add_overlay("oxygen-[oxygentanks]")
		if(4 to INFINITY)
			add_overlay("oxygen-4")
	switch(phorontanks)
		if(1 to 4)
			add_overlay("phoron-[phorontanks]")
		if(5 to INFINITY)
			add_overlay("phoron-5")

/obj/structure/dispenser/attack_ai(mob/user as mob)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Phoron tanks: [phorontanks] - [phorontanks ? "<A href='?src=\ref[src];phoron=1'>Dispense</A>" : "empty"]"
	user << browse(dat, "window=dispenser")
	onclose(user, "dispenser")
	return


/obj/structure/dispenser/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/tank/oxygen) || istype(I, /obj/item/weapon/tank/air) || istype(I, /obj/item/weapon/tank/anesthetic))
		if(oxygentanks < 10)
			user.drop_from_inventory(I,src)
			oxytanks.Add(I)
			oxygentanks++
			user << "<span class='notice'>You put [I] in [src].</span>"
			if(oxygentanks < 5)
				update_icon()
		else
			user << "<span class='notice'>[src] is full.</span>"
		updateUsrDialog()
		return
	if(istype(I, /obj/item/weapon/tank/phoron))
		if(phorontanks < 10)
			user.drop_from_inventory(I,src)
			platanks.Add(I)
			phorontanks++
			user << "<span class='notice'>You put [I] in [src].</span>"
			if(oxygentanks < 6)
				update_icon()
		else
			user << "<span class='notice'>[src] is full.</span>"
		updateUsrDialog()
		return
	if(iswrench(I))
		if(anchored)
			user << "<span class='notice'>You lean down and unwrench [src].</span>"
			anchored = 0
		else
			user << "<span class='notice'>You wrench [src] into place.</span>"
			anchored = 1
		return

/obj/structure/dispenser/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(Adjacent(usr))
		usr.set_machine(src)
		if(href_list["oxygen"])
			if(oxygentanks > 0)
				var/obj/item/weapon/tank/oxygen/O
				if(oxytanks.len == oxygentanks)
					O = oxytanks[1]
					oxytanks.Remove(O)
				else
					O = new /obj/item/weapon/tank/oxygen(loc)
				O.forceMove(loc)
				usr << "<span class='notice'>You take [O] out of [src].</span>"
				oxygentanks--
				update_icon()
		if(href_list["phoron"])
			if(phorontanks > 0)
				var/obj/item/weapon/tank/phoron/P
				if(platanks.len == phorontanks)
					P = platanks[1]
					platanks.Remove(P)
				else
					P = new /obj/item/weapon/tank/phoron(loc)
				P.forceMove(loc)
				usr << "<span class='notice'>You take [P] out of [src].</span>"
				phorontanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		usr << browse(null, "window=dispenser")
		return
	return
