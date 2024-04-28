/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	desc_info = "This is an energy weapon.  To fire this weapon, toggle the safety with ctrl-click (or enable HARM intent), \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To recharge this weapon, use a weapon recharger."
	icon = 'icons/obj/guns/ecarbine.dmi'
	icon_state = "energykill100"
	item_state = "energykill100"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	update_icon_on_init = TRUE

	safetyon_sound = 'sound/weapons/laser_safetyon.ogg'
	safetyoff_sound = 'sound/weapons/laser_safetyoff.ogg'

	var/has_icon_ratio = TRUE // Does this gun use the ratio system to modify its icon_state?
	var/has_item_ratio = TRUE // Does this gun use the ratio system to paint its item_states?

	var/obj/item/cell/power_supply //What type of power cell this uses
	var/charge_cost = 200 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice //also passed to turrets
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge
	var/list/required_firemode_auth //This list matches with firemode index, used to determine which firemodes get unlocked with what level of authorization.

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	/// Multiplies by charge cost to determine how much charge should be returned
	var/recharge_multiplier = 1
	var/charge_tick = 0

	/// External power source for the gun. Checked by get_external_power_supply()
	var/obj/item/recharger

	//vars passed to turrets
	var/can_turret = 0						//1 allows you to attach the gun on a turret
	var/secondary_projectile_type = null	//if null, turret defaults to projectile_type
	var/secondary_fire_sound = null			//if null, turret defaults to fire_sound
	var/can_switch_modes = 0				//1 allows switching lethal and stun modes
	var/turret_sprite_set = "carbine"		//set of sprites to use for the turret gun
	var/turret_is_lethal = 1				//is the gun in lethal (secondary) mode by default

/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/emp_act(severity)
	. = ..()

	disable_cell_temp(severity)
	queue_icon_update()

/obj/item/gun/energy/proc/disable_cell_temp(var/severity)
	set waitfor = FALSE
	if(!power_supply)
		return
	var/mob/M
	if(ismob(loc))
		M = loc
		to_chat(M, SPAN_DANGER("[src] locks up!"))
		playsound(M, 'sound/weapons/smg_empty_alarm.ogg', 30)
	var/initial_charge = power_supply.charge
	power_supply.charge = 0
	sleep(severity * 20)
	power_supply.give(initial_charge)
	update_maptext()
	update_icon()
	if(M && loc == M)
		playsound(M, 'sound/weapons/laser_safetyoff.ogg', 30)

/obj/item/gun/energy/get_cell()
	return power_supply

/obj/item/gun/energy/Initialize()
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell/device/variable(src, max_shots*charge_cost)
	update_maptext()

/obj/item/gun/energy/Destroy()
	if(recharger)
		disconnect()
	QDEL_NULL(power_supply)
	return ..()

/obj/item/gun/energy/proc/try_recharge()
	. = 1
	if (!power_supply || power_supply.charge >= power_supply.maxcharge || !self_recharge)
		return 0 // check if we actually need to recharge

	if (use_external_power)
		var/obj/item/cell/external = get_external_power_supply()
		if(!external || !external.use(charge_cost)) //Take power from the borg...
			return 0

	power_supply.give(charge_cost * recharge_multiplier) //... to recharge the shot
	update_maptext()
	update_icon()

	addtimer(CALLBACK(src, PROC_REF(try_recharge)), recharge_time * 2 SECONDS, TIMER_UNIQUE)

/obj/item/gun/energy/consume_next_projectile()
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	if(self_recharge)
		addtimer(CALLBACK(src, PROC_REF(try_recharge)), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	return new projectile_type(src)

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(isrobot(src.loc.loc)) // for things inside a robot's module
		var/mob/living/silicon/robot/R = src.loc.loc
		return R.cell
	if(recharger)
		return recharger.get_cell()
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	if(istype(loc, /obj/item/mecha_equipment))
		return loc.get_cell()

	return null

/**
 * Connects the energy gun to an external power supply
 *
 * * powersource - the power supply in question. Can either be `/obj/item/rig_module/recharger` or `/obj/item/recharger_backpack`.
 *
 * Returns `TRUE` if the connection was successful, `FALSE` otherwise
 */
/obj/item/gun/energy/proc/connect(obj/item/powersource)
	SHOULD_NOT_SLEEP(TRUE)

	//Validate that the type is allowed first of all
	if(!is_type_in_list(powersource, list(/obj/item/rig_module/recharger, /obj/item/recharger_backpack)))
		stack_trace("Wrong type to connect the energy gun to!")
		return FALSE

	//If we're already connected with something, we can't connect with something else
	if(recharger)
		to_chat(usr, SPAN_WARNING("\The [src] is already connected to \the [recharger]!"))
		return FALSE

	if(istype(powersource, /obj/item/rig_module/recharger))
		var/obj/item/rig_module/recharger/rigcharge = powersource

		if(!rigcharge.holder || !rigcharge.holder.wearer)
			to_chat(usr, SPAN_WARNING("\The [rigcharge] must be installed in a rig and active!"))
			return FALSE

		to_chat(usr, SPAN_NOTICE("You neatly plug \the [src] into \the [powersource]."))
		playsound(get_turf(src), 'sound/machines/click.ogg', 30, 0)
		rigcharge.connected = src
		recharger = rigcharge.holder
		self_recharge = TRUE
		use_external_power = TRUE

	else if(istype(powersource, /obj/item/recharger_backpack))
		var/obj/item/recharger_backpack/back_charge = powersource

		if(!ismob(loc))
			to_chat(usr, SPAN_WARNING("\The [back_charge] must be worn on the back before a weapon can be connected!"))
			return FALSE

		to_chat(usr, SPAN_NOTICE("You neatly plug \the [src] into \the [powersource]."))
		playsound(get_turf(src), 'sound/machines/click.ogg', 30, 0)
		back_charge.connect(src)
		recharger = back_charge
		self_recharge = TRUE
		use_external_power = TRUE

	return TRUE


///Disconnects the energy gun from its external power source if one exists.
/obj/item/gun/energy/proc/disconnect()
	SHOULD_NOT_SLEEP(TRUE)
	if(!recharger)
		to_chat(usr, SPAN_WARNING("\The [src] lacks an external power source to disconnect!"))
		return

	if(istype(recharger, /obj/item/rig))
		var/obj/item/rig/rig = recharger
		var/obj/item/rig_module/recharger/rigcharger = locate() in rig.installed_modules
		to_chat(usr, SPAN_NOTICE("With a snap, \the [src] is disconnected from \the [recharger]."))
		playsound(get_turf(src), 'sound/machines/click.ogg', 30, 0)
		if(rigcharger.active)
			rigcharger.deactivate()

		rigcharger.connected = null

	else if(istype(recharger, /obj/item/recharger_backpack))
		var/obj/item/recharger_backpack/backcharger = recharger
		to_chat(usr, SPAN_NOTICE("With a snap, \the [src] is disconnected from \the [recharger]."))
		playsound(get_turf(src), 'sound/machines/click.ogg', 30, 0)
		backcharger.disconnect(src)

	recharger = null
	self_recharge = initial(self_recharge)
	use_external_power = initial(use_external_power)

/obj/item/gun/energy/MouseDrop(atom/over)
	. = ..()


	if(istype(over, /obj/item/rig))
		var/obj/item/rig/rig = over
		var/obj/item/rig_module/recharger/rigcharge = locate() in rig.installed_modules
		if(rigcharge)
			connect(rigcharge)

	else if(istype(over, /obj/item/recharger_backpack))
		var/obj/item/recharger_backpack/backcharge = over
		connect(backcharge)


/obj/item/gun/energy/dropped(mob/user)
	. = ..()

	if(recharger)
		disconnect()

/obj/item/gun/energy/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 1)
		return
	var/shots_remaining = round(power_supply.charge / charge_cost)
	. += "It has [shots_remaining] shot\s remaining."

/obj/item/gun/energy/update_icon()
	if(charge_meter && power_supply && power_supply.maxcharge)
		var/ratio = power_supply.charge / power_supply.maxcharge
		var/icon_state_ratio = ""
		var/item_state_ratio = ""

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		if(has_icon_ratio)
			icon_state_ratio = ratio
		if(has_item_ratio)
			item_state_ratio = ratio

		if(modifystate)
			icon_state = "[modifystate][icon_state_ratio]"
			item_state = "[modifystate][item_state_ratio]"
		else
			icon_state = "[initial(icon_state)][icon_state_ratio]"
			item_state = "[initial(item_state)][item_state_ratio]"

	..()

/obj/item/gun/energy/handle_post_fire()
	..()
	update_maptext()

/obj/item/gun/energy/get_ammo()
	if(!power_supply)
		return 0
	return round(power_supply.charge / charge_cost)

/obj/item/gun/energy/get_print_info()
	. = ""
	. += "Max Shots: [initial(max_shots)]<br>"
	. += "Recharge Type: [initial(self_recharge) ? "self recharging" : "not self recharging"]<br>"
	if(initial(self_recharge))
		. += "Recharge Time: [initial(recharge_time)]<br>"
	. += "<br><b>Primary Projectile</b><br>"
	var/obj/item/projectile/P = new projectile_type
	. += P.get_print_info()

	if(secondary_projectile_type)
		. += "<br><b>Secondary Projectile</b><br>"
		var/obj/item/projectile/P_second = new secondary_projectile_type
		. += P_second.get_print_info()
	. += "<br>"

	. += ..(FALSE)
