/obj/structure/dispenser
	name = "gas tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 oxygen tanks and 10 phoron tanks."
	icon = 'icons/obj/tank_dispenser.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	w_class = WEIGHT_CLASS_HUGE
	var/max_tanks = 20
	var/tanks_oxygen = 10
	var/tanks_phoron = 10
	var/list/held_tanks_oxygen = list()
	var/list/held_tanks_phoron = list()

// Oxygen
/obj/structure/dispenser/oxygen
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 oxygen tanks."
	max_tanks = 10
	tanks_phoron = 0

// Phoron
/obj/structure/dispenser/phoron
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to 10 phoron tanks."
	max_tanks = 10
	tanks_oxygen = 0

/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()

/obj/structure/dispenser/update_icon()
	ClearOverlays()
	switch(tanks_oxygen)
		if(1 to 4)
			AddOverlays("oxygen-[tanks_oxygen]")
		if(5 to INFINITY)
			AddOverlays("oxygen-5")
	switch(tanks_phoron)
		if(1 to 4)
			AddOverlays("phoron-[tanks_phoron]")
		if(5 to INFINITY)
			AddOverlays("phoron-5")

/obj/structure/dispenser/attack_ai(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

// TGUI functions begin
/obj/structure/dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TankDispenser", src.name, 400, 150)
		ui.open()

/obj/structure/dispenser/ui_data(mob/user)
	var/list/data = list()

	data["tanks_oxygen"] = tanks_oxygen
	data["tanks_phoron"] = tanks_phoron

	return data

/obj/structure/dispenser/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch(action)
		if("dispense_oxygen")
			if(tanks_oxygen > 0)
				var/obj/item/tank/oxygen/O
				if(held_tanks_oxygen.len == tanks_oxygen)
					O = held_tanks_oxygen[1]
					held_tanks_oxygen.Remove(O)
				else
					O = new /obj/item/tank/oxygen(loc)
				usr.put_in_hands(O)
				to_chat(usr, SPAN_NOTICE("You take \the [O] out of \the [src]."))
				tanks_oxygen--
				update_icon()
		if ("dispense_phoron")
			if(tanks_phoron > 0)
				var/obj/item/tank/phoron/P
				if(held_tanks_phoron.len == tanks_phoron)
					P = held_tanks_phoron[1]
					held_tanks_phoron.Remove(P)
				else
					P = new /obj/item/tank/phoron(loc)
				usr.put_in_hands(P)
				to_chat(usr, SPAN_NOTICE("You take \the [P] out of \the [src]."))
				tanks_phoron--
				update_icon()
// TGUI functions end

/obj/structure/dispenser/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/tank/oxygen) || istype(attacking_item, /obj/item/tank/air) || istype(attacking_item, /obj/item/tank/anesthetic))
		if(tanks_oxygen < max_tanks)
			user.drop_from_inventory(attacking_item, src)
			held_tanks_oxygen.Add(attacking_item)
			tanks_oxygen++
			to_chat(user, SPAN_NOTICE("You put \the [attacking_item] into \the [src]."))
			if(tanks_oxygen < 5)
				update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] is full."))
		updateUsrDialog()
		return
	if(istype(attacking_item, /obj/item/tank/phoron))
		if(tanks_phoron < max_tanks)
			user.drop_from_inventory(attacking_item, src)
			held_tanks_oxygen.Add(attacking_item)
			tanks_phoron++
			to_chat(user, SPAN_NOTICE("You put \the [attacking_item] into \the [src]."))
			if(tanks_oxygen < 6)
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
