/obj/machinery/gumballmachine
	name = "Gumball Machine"
	desc = "A colorful candy machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "gumball_100"
	layer = 2.9
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 10
	var/typeofcandy = "gumball"
	var/initialicon = "gumball"
	var/amountleft = 20
	var/vendingtype = /obj/item/clothing/mask/chewable/candy/gum
	var/gumprice = 5
	var/on = 1
	var/broken = 0

/obj/machinery/gumballmachine/Initialize()
	. = ..()


/obj/machinery/gumballmachine/machinery_process()
	if(broken)
		return
	else

		update_power()

		update_icon()

/obj/machinery/gumballmachine/update_icon()
	if(on)
		add_overlay(image('icons/obj/vending.dmi', "[icon_state]_on", MOB_LAYER + 1))
	else
		cut_overlays()
	switch(amountleft)
		if(20)
			icon_state = "[initialicon]_100"
			desc = "A colorful [typeofcandy] machine. It is full!"
		if(15)
			icon_state = "[initialicon]_75"
			desc = "A colorful [typeofcandy] machine. Some are missing"
		if(10)
			icon_state = "[initialicon]_50"
			desc = "A colorful [typeofcandy] machine. Its half full!"
		if(5)
			icon_state = "[initialicon]_25"
			desc = "A colorful [typeofcandy] machine. There is a few left"
		if(0)
			icon_state = "[initialicon]_empty"
			desc = "A colorful [typeofcandy] machine. Its empty!"

/obj/machinery/gumballmachine/proc/update_power()

	if(stat & (BROKEN|NOPOWER|EMPED))
		on = 0
	else
		on = 1


/obj/machinery/gumballmachine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = W
		if(!on)
			to_chat(user, "<span class='warning'>There is no power!.</span>")
			return
		if(amountleft <= 0)
			to_chat(user, "<span class='warning'>There is no more [typeofcandy] left!.</span>")
			return
		if(C.worth < gumprice)
			to_chat(user, "<span class='warning'>You dont think this is enough to buy what you want from this.</span>")
			return
		else
			visible_message("<span class='info'>\The [usr] inserts a bill into \the [src].</span>")
			var/changeleftover = C.worth - gumprice
			usr.drop_from_inventory(C,get_turf(src))
			qdel(C)
			buygumball()

			if(changeleftover)
				spawn_money(changeleftover, src.loc, user)
	if(istype(W, /obj/item/weapon/material/twohanded/baseballbat))
		if(broken)
			return
		smashgumball()


/obj/machinery/gumballmachine/proc/buygumball()
	playsound(src.loc, 'sound/items/drumroll.ogg', 50, 0, -4)
	sleep(50)
	new vendingtype(src.loc, 1)
	amountleft -= 1

/obj/machinery/gumballmachine/proc/smashgumball()
	icon_state = "[initialicon]_broken"
	playsound(get_turf(src), 'sound/effects/Glassbr3.ogg', 75, 1)
	if(amountleft)
		var/amountleftinside = amountleft
		for(var/i = 0;i<=amountleftinside;i++)
			new vendingtype(src.loc)
		src.visible_message("\The [src] shatters! [typeofcandy]'s rains out.", "You hear glass shatter!.")
	stat |= BROKEN
	anchored = 0
	broken = 1
	amountleft = 0

/obj/machinery/gumballmachine/sucker
	name = "Sucker Machine"
	desc = "A colorful candy machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "sucker_100"
	layer = 2.9
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 10
	var/typeofcandy = "sucker"
	var/initialicon = "sucker"
	var/amountleft = 25
	var/vendingtype = /obj/item/clothing/mask/chewable/candy/lolli
	var/gumprice = 10
	var/on = 1
	var/broken = 0