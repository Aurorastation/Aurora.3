	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"
	fire_sound_text = "laser blast"
	update_icon_on_init = TRUE

	var/charge_cost = 200 //How much energy is needed to fire.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice //also passed to turrets
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/recharge_time = 4
	var/charge_tick = 0

	//vars passed to turrets
	var/can_turret = 0						//1 allows you to attach the gun on a turret
	var/secondary_projectile_type = null	//if null, turret defaults to projectile_type
	var/secondary_fire_sound = null			//if null, turret defaults to fire_sound
	var/can_switch_modes = 0				//1 allows switching lethal and stun modes
	var/turret_sprite_set = "carbine"		//set of sprites to use for the turret gun
	var/turret_is_lethal = 1				//is the gun in lethal (secondary) mode by default

	. = ..()
	if(.)
		update_icon()

	..()
	queue_icon_update()

	return power_supply

	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)
	else

	QDEL_NULL(power_supply)
	return ..()

	. = 1
	if (!power_supply || power_supply.charge >= power_supply.maxcharge || !self_recharge)
		return 0 // check if we actually need to recharge
		
	if (use_external_power)
		if(!external || !external.use(charge_cost)) //Take power from the borg...
			return 0

	power_supply.give(charge_cost) //... to recharge the shot
	update_icon()

	addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)

	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	if (self_recharge) addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	return new projectile_type(src)

	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				if(istype(suit))
					return suit.cell
	return null

	..(user)
	var/shots_remaining = round(power_supply.charge / charge_cost)
	user << "Has [shots_remaining] shot\s remaining."
	return

	if(charge_meter && power_supply)
		var/ratio = power_supply.charge / power_supply.maxcharge

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"
	update_held_icon()
