/obj/item/device/flash
	name = "flash"
	desc = "Used mainly by civilian sector security forces for a (mostly) harmless way of disorienting organic and synthetic beings via intense directional light."
	icon = 'icons/obj/flash.dmi'
	icon_state = "base"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	var/cell_type = null //The type of cell it uses.
	var/bulb_type = null //The type of bulb it uses.

	//Do not change these values
	var/strength_mul = 1 //Strength multiplier of the strength multiplier. Internal value.
	var/obj/item/weapon/cell/power_supply //The stored power cell. Internal value.
	var/obj/item/weapon/flash_bulb/bulb //The installed bulb. Internal value.
	var/hatch_open = FALSE //Whether or not the hatch is open

	var/use_external_power = FALSE
	var/charge_cost = 200 //How much charge to take away per use

	var/recharge_time = 4//No clue

/obj/item/device/flash/Initialize() //Stolen from energy gun code.
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)

	if(bulb_type)
		bulb = new bulb_type(src)

	update_icon()

/obj/item/device/flash/emp_act(severity)

	if(bulb && prob(50))
		bulb.emp_act(severity)

	if(power_supply)
		power_supply.emp_act(severity)

/obj/item/device/flash/get_cell()
	return power_supply

/obj/item/device/flash/Destroy()
	QDEL_NULL(power_supply)
	return ..()

/obj/item/device/flash/update_icon()
	. = ..()
	cut_overlays()
	if(bulb)
		bulb.update_icon()
		add_overlay(bulb.icon_state)

/obj/item/device/flash/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/device/flash/proc/try_recharge()
	. = 1
	if (!power_supply || power_supply.charge >= power_supply.maxcharge)
		return 0

	if (use_external_power)
		var/obj/item/weapon/cell/external = get_external_power_supply()
		if(!external || !external.use(charge_cost))
			return 0

	power_supply.give(charge_cost)
	update_icon()

	addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)

/obj/item/device/flash/attack(mob/living/M as mob, mob/living/user as mob, var/target_zone)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	if(!power_supply || !power_supply.checked_use(charge_cost) || !bulb || bulb.is_burnt)
		user.visible_message("<span class='warning'>\The [user] sticks \the [src] in \the [src]'s direction, but nothing happens.</span>", \
			"<span class='warning'>You stick \the [src] in \the [M]'s direction, but nothing happens.</span>", \
			"<span class='notice'>You hear a click.</span>")
		playsound(src.loc, 'sound/items/flashlight.ogg', 50, 1)
		return

	user.visible_message("<span class='danger'>\The [user.name] flashes \the [M] using \the [src]!</span>", \
		"<span class='danger'>You flash \the [M] using \the [src]!</span>", \
		"<span class='notice'>You hear a distinct mechanical shutter...</span>")

	playsound(src.loc, 'sound/weapons/flash.ogg', 50, 1)

	update_icon()
	add_overlay("flash_animation")
	M.on_flash(user,src,bulb.strength*strength_mul)
	bulb.add_heat(strength_mul)

/obj/item/device/flash/attackby(obj/item/weapon/W as obj, mob/user as mob)

	var/obj/item/weapon/cell/the_cell = W
	var/obj/item/weapon/flash_bulb/the_bulb = W

	if(isscrewdriver(W))
		if(power_supply)
			user.visible_message("<span class='notice'>\The [user] removes \the [power_supply] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You remove \the [power_supply] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You hear something screwing something open...</span>")
			playsound(src.loc, 'sound/items/screwdriver.ogg', 50, 1)
			power_supply.forceMove(get_turf(src))
			power_supply = null
			strength_mul = 0
			update_icon()
		else if(bulb)
			user.visible_message("<span class='notice'>\The [user] removes \the [the_bulb] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You remove \the [the_bulb] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You hear something screwing something open...</span>")
			playsound(src.loc, 'sound/items/screwdriver.ogg', 50, 1)
			the_bulb.forceMove(get_turf(src))
			the_bulb = null
			strength_mul = 0
			update_icon()
		else
			to_chat(user,"<span class='notice'>There is nothing to remove on \the [src]!")

	if(istype(the_bulb))
		if(bulb)
			to_chat(user,"<span class='notice'>There is already a [bulb] installed in \the [src]!")
		else
			user.visible_message("<span class='notice'>\The [user] inserts \the [the_bulb] in \the [src].</span>", \
				"<span class='notice'>You insert \the [the_bulb] in \the [src].</span>", \
				"<span class='notice'>You hear a click...</span>")
			playsound(src.loc, 'sound/items/zippo_off.ogg', 50, 1)
			the_bulb.forceMove(src)
			the_bulb = the_cell
			strength_mul = 0
			update_icon()

	else if(istype(the_cell))
		if(the_cell)
			to_chat(user,"<span class='notice'>There is already a [the_cell] installed in \the [src]!")
		else if(!bulb)
			to_chat(user,"<span class='notice'>You need to install a bulb first before you install \the [the_cell]!")
		else
			user.visible_message("<span class='notice'>\The [user] inserts \the [the_cell] in \the [src].</span>", \
				"<span class='notice'>You insert \the [the_cell] in \the [src].</span>", \
				"<span class='notice'>You hear a click...</span>")
			playsound(src.loc, 'sound/items/zippo_off.ogg', 50, 1)
			the_cell.forceMove(src)
			the_cell = the_cell
			strength_mul = 0
			update_icon()

/obj/item/device/flash/attack_self(var/mob/user as mob)

	if(get_cell())
		switch(strength_mul)
			if(1)
				strength_mul = 0.75
			if(0.75)
				strength_mul = 0.50
			if(0.50)
				strength_mul = 0.25
			if(0.25)
				strength_mul = 0
			if(0)
				strength_mul = 1
		if(strength_mul == 0)
			to_chat(user,"<span class='notice'>You turn \the [src] off.</span>")
			if(bulb)
				bulb.on = FALSE
		else if(strength_mul == 1)
			to_chat(user, "<span class='notice'>You turn \the [src] on.</span>")
			if(bulb)
				bulb.on = TRUE
		else
			to_chat(user,"<span class='notice'>You adjust the dial on \the [src] to [strength_mul * 100]%.</span>")
	else
		to_chat(user,"<span class='notice'>\The [src]'s dial refuses to budge!</span>")

	update_icon()