/obj/machinery/gumballmachine
	name = "gumball machine"
	desc = "A lithe device with a glass globe on top, which can be operated to dispense various candies."
	icon = 'icons/obj/vending.dmi'
	icon_state = "gumball_100"
	anchored = 1
	density = 1
	idle_power_usage = 10
	var/typeofcandy = "gumballs"
	var/initialicon = "gumball"
	var/amountleft = 20
	var/vendingtype = /obj/item/clothing/mask/chewable/candy/gum
	var/gumprice = 5
	var/on = 1
	var/broken = 0

/obj/machinery/gumballmachine/Initialize()
	. = ..()


/obj/machinery/gumballmachine/process()
	if(broken)
		return
	else

		update_power()

		update_icon()


/obj/machinery/gumballmachine/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("\The [src] costs [gumprice] credits to use.")

/obj/machinery/gumballmachine/update_icon()
	switch(amountleft)
		if(20)
			icon_state = "[initialicon]_100"
			desc = "A colorful [typeofcandy] machine. It is full!"
		if(15)
			icon_state = "[initialicon]_75"
			desc = "A colorful [typeofcandy] machine. Some candy is missing."
		if(10)
			icon_state = "[initialicon]_50"
			desc = "A colorful [typeofcandy] machine. It's half full!"
		if(5)
			icon_state = "[initialicon]_25"
			desc = "A colorful [typeofcandy] machine. There are a few candies left."
		if(0)
			icon_state = "[initialicon]_empty"
			desc = "A colorful [typeofcandy] machine. It's empty!"

/obj/machinery/gumballmachine/proc/update_power()
	if(stat & (BROKEN|NOPOWER|EMPED))
		on = 0
	else
		on = 1


/obj/machinery/gumballmachine/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/spacecash))
		var/obj/item/spacecash/C = attacking_item
		if(!on)
			to_chat(user, SPAN_WARNING("\The [src] has no power!"))
			return TRUE
		if(amountleft <= 0)
			to_chat(user, SPAN_WARNING("There's no more [typeofcandy] left!"))
			return TRUE
		if(C.worth < gumprice)
			to_chat(user, SPAN_WARNING("You don't think this is enough to buy what you want from this."))
			return TRUE
		else
			visible_message(SPAN_INFO("\The [user] inserts a bill into \the [src]."))
			var/changeleftover = C.worth - gumprice
			user.drop_from_inventory(C,get_turf(src))
			qdel(C)
			buygumball()

			if(changeleftover)
				spawn_money(changeleftover, src.loc, user)
	if(istype(attacking_item, /obj/item) && user.a_intent == I_HURT && !istype(attacking_item, /obj/item/spacecash))
		if(broken)
			return
		if(prob(25))
			smashgumball()
		else
			visible_message(SPAN_WARNING("\The [user] bash's \the [src] with \the [attacking_item]."))
		return TRUE



/obj/machinery/gumballmachine/proc/buygumball()
	playsound(src.loc, 'sound/items/drumroll.ogg', 50, 0, -4)
	new vendingtype(src.loc, 1)
	amountleft -= 1

/obj/machinery/gumballmachine/proc/smashgumball()
	icon_state = "[initialicon]_broken"
	playsound(get_turf(src), /singleton/sound_category/glass_break_sound, 75, 1)
	if(amountleft)
		var/amountleftinside = amountleft
		for(var/i = 1;i<=amountleftinside,i++)
			new vendingtype(src.loc)
		src.visible_message("\The [src] shatters and [typeofcandy] fall out on the floor.", "You hear glass shatter!")
	stat |= BROKEN
	anchored = FALSE
	broken = TRUE
	amountleft = FALSE

/obj/machinery/gumballmachine/sucker
	name = "sucker machine"

	icon_state = "sucker_100"
	typeofcandy = "sucker"
	initialicon = "sucker"
	amountleft = 25
	vendingtype = /obj/item/clothing/mask/chewable/candy/lolli
	gumprice = 10
