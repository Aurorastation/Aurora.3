/obj/item/device/flash
	name = "incomplete flash assembly"
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

	var/self_recharge = FALSE
	var/use_external_power = FALSE
	var/charge_cost = 100 //How much charge to take away per use

	var/recharge_time = 4//No clue

	var/no_tamper = FALSE //Set to true if you're not supposed to take apart the flash. Used only for cyborg flashes, but whatever.

/obj/item/device/flash/Initialize() //Stolen from energy gun code.
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)

	if(bulb_type)
		bulb = new bulb_type(src)

	if(bulb)
		bulb.on = TRUE

	update_icon()

/obj/item/device/flash/examine(mob/user)
	if(..(user, 1))
		var/uses_remaining = round(power_supply.charge / charge_cost)
		to_chat(user,"Has [uses_remaining] use\s remaining.")

/obj/item/device/flash/emp_act(severity)

	if(bulb && prob(50))
		bulb.emp_act(severity)

	if(power_supply)
		power_supply.emp_act(severity)

/obj/item/device/flash/Destroy()
	QDEL_NULL(power_supply)
	return ..()

/obj/item/device/flash/update_icon()
	. = ..()
	cut_overlays()

	if(bulb)
		name = bulb.build_name
		bulb.update_icon()
		add_overlay(bulb.icon_state)
	else
		name = initial(name)

	if(power_supply)
		var/percent = power_supply.charge / power_supply.maxcharge
		if(percent > 0.75)
			add_overlay("battery_good")
		else if(percent > 0.50)
			add_overlay("battery_low")
		else if(percent > 0.25)
			add_overlay("very_low")
		else
			add_overlay("battery_none")
			if(bulb)
				bulb.on = FALSE
	else
		add_overlay("battery_hatch")
		if(bulb)
			bulb.on = FALSE


/obj/item/device/flash/proc/get_power_source()
	if(use_external_power)
		return get_external_power_supply()
	else
		return power_supply

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
	if (!power_supply || power_supply.charge >= power_supply.maxcharge || !self_recharge)
		return 0

	if (use_external_power)
		var/obj/item/weapon/cell/external = get_external_power_supply()
		if(!external || !external.use(charge_cost))
			return 0

	power_supply.give(charge_cost)
	update_icon()

	addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)

	return 1

/obj/item/device/flash/attack(mob/living/M as mob, mob/living/user as mob, var/target_zone)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	var/obj/item/weapon/cell/power_source = get_power_source()

	if(strength_mul <= 0 || !power_source || !power_source.checked_use(charge_cost) || !bulb || bulb.is_burnt)
		playsound(src.loc, 'sound/items/flashlight.ogg', 50, 1)
		to_chat(user,"<span class='notice'>You try to activate \the [src] but nothing happens!</span>")
		update_icon()
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 50, 1)

	if(M == user) //Radial flash
		user.visible_message("<span class='warning'>\The [user.name] activates \the [src]!</span>", \
			"<span class='warning'>You activate \the [src]!</span>", \
			"<span class='notice'>You hear a distinct mechanical shutter.</span>")
		for (var/mob/living/T in view(user))
			if(T == user)
				continue
			var/distance_mod = 1 - min(1,get_dist(user,T)/6)
			var/total_power = bulb.strength*strength_mul*0.75*distance_mod
			if(total_power > 0)
				to_chat(T,"<span class='warning'>A flash of light coming from [user] blinds you!</span>")
				T.on_flash(user,src,total_power)
	else
		user.visible_message("<span class='danger'>\The [user.name] blinds \the [M] using \the [src]!</span>", \
			"<span class='danger'>You blind \the [M] using \the [src]!</span>", \
			"<span class='notice'>You hear a distinct mechanical shutter.</span>")
		M.on_flash(user,src,bulb.strength*strength_mul)

	if (self_recharge)
		addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)

	bulb.add_heat(strength_mul)
	update_icon()

/obj/item/device/flash/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(isscrewdriver(W))
		if(power_supply)
			user.visible_message("<span class='notice'>\The [user] removes \the [power_supply] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You remove \the [power_supply] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You hear something screwing something open...</span>")
			playsound(src.loc, 'sound/items/screwdriver.ogg', 50, 1)
			power_supply.forceMove(get_turf(src))
			power_supply.update_icon()
			power_supply = null
			strength_mul = 0
			update_icon()
		else if(bulb)
			user.visible_message("<span class='notice'>\The [user] removes \the [bulb] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You remove \the [bulb] from \the [src] using \the [W].</span>", \
				"<span class='notice'>You hear something screwing something open...</span>")
			playsound(src.loc, 'sound/items/screwdriver.ogg', 50, 1)
			bulb.on = FALSE
			bulb.forceMove(get_turf(src))
			bulb.update_icon()
			bulb = null
			strength_mul = 0
			update_icon()
		else
			to_chat(user,"<span class='notice'>There is nothing to remove on \the [src]!</span>")

	if(istype(W,/obj/item/weapon/flash_bulb))
		var/obj/item/weapon/flash_bulb/the_bulb = W
		if(bulb)
			to_chat(user,"<span class='notice'>There is already a [bulb] installed in \the [src]!</span>")
		else
			user.visible_message("<span class='notice'>\The [user] inserts \the [the_bulb] in \the [src].</span>", \
				"<span class='notice'>You insert \the [the_bulb] in \the [src].</span>", \
				"<span class='notice'>You hear a click...</span>")
			playsound(src.loc, 'sound/items/zippo_off.ogg', 50, 1)
			the_bulb.on = FALSE
			user.drop_from_inventory(the_bulb,src)
			bulb = the_bulb
			strength_mul = 0
			update_icon()

	else if(istype(W,/obj/item/weapon/cell))
		var/obj/item/weapon/cell/the_cell = W
		if(power_supply)
			to_chat(user,"<span class='notice'>There is already a [power_supply] installed in \the [src]!</span>")
		else if(!bulb)
			to_chat(user,"<span class='notice'>You need to install a bulb first before you install \the [the_cell]!</span>")
		else
			user.visible_message("<span class='notice'>\The [user] inserts \the [the_cell] in \the [src].</span>", \
				"<span class='notice'>You insert \the [the_cell] in \the [src].</span>", \
				"<span class='notice'>You hear a click...</span>")
			playsound(src.loc, 'sound/items/zippo_off.ogg', 50, 1)
			user.drop_from_inventory(the_cell,src)
			power_supply = the_cell
			strength_mul = 0
			bulb.on = FALSE
			update_icon()

/obj/item/device/flash/attack_self(var/mob/user)
	if(get_power_source())
		strength_mul = !strength_mul
		if(strength_mul)
			to_chat(user, "<span class='notice'>You turn \the [src] on.</span>")
			if(bulb)
				bulb.on = TRUE
		else
			to_chat(user,"<span class='notice'>You turn \the [src] off.</span>")
			if(bulb)
				bulb.on = FALSE
	else
		to_chat(user,"<span class='notice'>Nothing seems to happen...</span>")

	update_icon()

/obj/item/device/flash/flash_bulb/ex_act(var/severity = 3)

	severity = max(severity,1)

	if(bulb && prob(100/severity))
		bulb.ex_act(severity)

	if(power_supply && prob(100/severity))
		power_supply.ex_act(severity)
		qdel(src)


