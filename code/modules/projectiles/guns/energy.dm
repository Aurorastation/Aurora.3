/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/ecarbine.dmi'
	icon_state = "energykill100"
	item_state = "energykill100"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	update_icon_on_init = TRUE

	var/has_icon_ratio = TRUE // Does this gun use the ratio system to modify its icon_state?
	var/has_item_ratio = TRUE // Does this gun use the ratio system to paint its item_states?

	var/obj/item/cell/power_supply //What type of power cell this uses
	var/charge_cost = 200 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice //also passed to turrets
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0

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
	..()
	queue_icon_update()

/obj/item/gun/energy/get_cell()
	return power_supply

/obj/item/gun/energy/Initialize()
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell/device/variable(src, max_shots*charge_cost)

/obj/item/gun/energy/Destroy()
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

	power_supply.give(charge_cost) //... to recharge the shot
	update_icon()

	addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)

/obj/item/gun/energy/consume_next_projectile()
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	if(self_recharge)
		addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	return new projectile_type(src)

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
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

/obj/item/gun/energy/examine(mob/user)
	..(user)
	if(get_dist(src, user) > 1)
		return
	var/shots_remaining = round(power_supply.charge / charge_cost)
	to_chat(user, "Has [shots_remaining] shot\s remaining.")
	return

/obj/item/gun/energy/update_icon()
	..()
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
	update_held_icon()