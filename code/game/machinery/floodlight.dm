
/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/obj/item/weapon/cell/high/cell = null
	var/use = 200 // 200W light
	var/unlocked = 0
	var/open = 0
	var/brightness_on = 12		//can't remember what the maxed out value is
	light_color = LIGHT_COLOR_TUNGSTEN
	light_wedge = LIGHT_WIDE

/obj/machinery/floodlight/Initialize()
	. = ..()
	cell = new(src)
	cell.maxcharge = 1000
	cell.charge = 1000 // 41minutes @ 200W

/obj/machinery/floodlight/update_icon()
	overlays.Cut()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/machinery_process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light(brightness_on/2, 0.5)
		spawn(20)
			if(on)
				set_light(brightness_on, 1)

	cell.use(use*CELLRATE)


// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/proc/turn_on(var/loud = 0)
	if(!cell)
		return 0
	if(cell.charge < (use * CELLRATE))
		return 0

	on = 1
	set_light(brightness_on, 1)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
	return 1

/obj/machinery/floodlight/proc/turn_off(var/loud = 0)
	on = 0
	set_light(0)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")

/obj/machinery/floodlight/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			user << "You try to turn on \the [src] but it does not work."


/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = loc

		cell.add_fingerprint(user)
		cell.update_icon()

		src.cell = null
		on = 0
		set_light(0)
		user << "You remove the power cell"
		update_icon()
		return

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			user << "You try to turn on \the [src] but it does not work."

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (isscrewdriver(W))
		if (!open)
			if(unlocked)
				unlocked = 0
				user << "You screw the battery panel in place."
			else
				unlocked = 1
				user << "You unscrew the battery panel."

	if (iscrowbar(W))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				user << "You crowbar the battery panel in place."
			else
				if(unlocked)
					open = 1
					user << "You remove the battery panel."

	if (istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				user << "There is a power cell already installed."
			else
				user.drop_item()
				W.loc = src
				cell = W
				user << "You insert the power cell."
	update_icon()

/obj/item/weapon/floodlight_diy
	name = "Emergency Floodlight Kit"
	desc = "A do-it-yourself kit for constructing the finest of emergency floodlights."
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_box"
	item_state = "syringe_kit"

/obj/item/weapon/floodlight_diy/attack_self(mob/user)
	user << "<span class='notice'>You start piecing together the kit...</span>"
	if(do_after(user, 80))
		var/obj/machinery/floodlight/R = new /obj/machinery/floodlight(user.loc)
		user.visible_message("<span class='notice'>[user] assembles \a [R].\
			</span>", "<span class='notice'>You assemble \a [R].</span>")
		R.add_fingerprint(user)
		qdel(src)
