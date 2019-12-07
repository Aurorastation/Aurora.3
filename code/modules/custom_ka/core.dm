/obj/item/gun/custom_ka
	name = null // Abstract
	var/official_name
	var/custom_name
	desc = "A kinetic accelerator assembly."
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = ""
	item_state = "kineticgun"
	contained_sprite = 1
	flags =  CONDUCT
	slot_flags = SLOT_BELT
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 2,TECH_ENGINEERING = 2)

	burst = 1
	fire_delay = 0 	//delay after shooting before the gun can be used again
	burst_delay = 2	//delay between shots, if firing in bursts
	move_delay = 1
	fire_sound = 'sound/weapons/kinetic_accel.ogg'
	fire_sound_text = "blast"
	recoil = 0
	silenced = 0
	muzzle_flash = 3
	accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	scoped_accuracy = null
	burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	dispersion = list(0)
	reliability = 100

	var/obj/item/projectile/projectile_type = /obj/item/projectile/kinetic

	needspin = FALSE

	sel_mode = 1 //index of the currently selected mode
	firemodes = list()

	//wielding information
	fire_delay_wielded = 0
	recoil_wielded = 0
	accuracy_wielded = 0
	wielded = 0

	is_wieldable = TRUE

	var/require_wield = FALSE

	var/build_name = ""

	//Custom stuff
	var/obj/item/custom_ka_upgrade/cells/installed_cell
	var/obj/item/custom_ka_upgrade/barrels/installed_barrel
	var/obj/item/custom_ka_upgrade/upgrade_chips/installed_upgrade_chip

	var/damage_increase = 0 //The amount of damage this weapon does, in total.
	var/firedelay_increase = 0 //How long it takes for the weapon to fire, in deciseconds.
	var/range_increase = 0
	var/recoil_increase = 0 //The amount of recoil this weapon has, in total.
	var/cost_increase = 0 //How much energy to take per shot, in total.
	var/cell_increase = 0 //The total increase in battery. This actually doesn't do anything and is just a display variable. Power is handled in their own parts.
	var/capacity_increase = 0 //How much/big this frame can hold a mod.
	var/mod_limit_increase = 0 //Maximum size of a mod this frame can take.
	var/aoe_increase = 0

	var/current_highest_mod = 0

	var/is_emagged = 0
	var/is_emped = 0

	var/can_disassemble_cell = TRUE
	var/can_disassemble_barrel = TRUE

/obj/item/gun/custom_ka/can_wield()
	return 1

/obj/item/gun/custom_ka/toggle_wield()
	..()
	if(wielded)
		item_state = "[initial(item_state)]_w"
	else
		item_state = initial(item_state)
	update_held_icon()

/obj/item/gun/custom_ka/pickup(mob/user)
	..()
	if(can_wield())
		item_state = initial(item_state)
	update_held_icon()

/obj/item/gun/custom_ka/examine(var/mob/user)
	. = ..()
	if(installed_upgrade_chip)
		to_chat(user,"It is equipped with \the [installed_barrel], \the [installed_cell], and \the [installed_upgrade_chip].")
	else if(installed_barrel)
		to_chat(user,"It is equipped with \the [installed_barrel] and \the [installed_cell]. It has space for an upgrade chip.")
	else if(installed_cell)
		to_chat(user,"It is equipped with \the [installed_cell]. The assembly lacks a barrel installation.")

	if(installed_barrel)
		if(custom_name)
			to_chat(user,"[custom_name] is written crudely in pen across the side, covering up the offical designation.")
		else
			to_chat(user,"The offical designation \"[official_name]\" is etched neatly on the side.")

	if(installed_cell)
		to_chat(user,"It has [round(installed_cell.stored_charge / cost_increase)] shots remaining.")

/obj/item/gun/custom_ka/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	to_chat(user,"<span class='warning'>You override the safeties on the [src]...</span>")
	is_emagged = 1
	return 1

/obj/item/gun/custom_ka/emp_act(severity)
	is_emped = 1
	return 1

/obj/item/gun/custom_ka/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)

	if(require_wield && !wielded)
		to_chat(user,"<span class='warning'>\The [src] is too heavy to fire with one hand!</span>")
		return

	if(!fire_checks(target,user,clickparams,pointblank,reflex))
		return

	//Custom fire checks
	var/warning_message
	var/disaster

	if( (is_emped && prob(10)) || prob(1))
		var/list/warning_messages = list(
			"ERROR CODE: ERROR CODE",
			"ERROR CODE: PLEASE REPORT THIS",
			"ERROR CODE: OH GOD HELP",
			"ERROR CODE: 404 NOT FOUND",
			"ERROR CODE: KEYBOARD NOT FOUND, PRESS F11 TO CONTINUE",
			"ERROR CODE: CLICK OKAY TO CONTINUE",
			"ERROR CODE: AN ERROR HAS OCCURED TRYING TO DISPLAY AN ERROR CODE",
			"ERROR CODE: NO ERROR CODE FOUND",
			"ERROR CODE: LOADING.."
		)
		if(is_emped)
			warning_message = pick(warning_messages)
			spark(src.loc, 3, alldirs)
	else if(!installed_cell || !installed_barrel)
		if(!is_emagged || (is_emped && prob(5)) )
			warning_message = "ERROR CODE: 0"
		else
			disaster = "spark"
	else if (damage_increase <= 0)
		if(!is_emagged || (is_emped && prob(5)) )
			warning_message = "ERROR CODE: 100"
		else
			disaster = "overheat"
	else if (range_increase < 2)
		if(!is_emagged || (is_emped && prob(5)) )
			warning_message = "ERROR CODE: 101"
		else
			disaster = "explode"
	else if (cost_increase > cell_increase)
		if(!is_emagged || (is_emped && prob(5)) )
			warning_message = "ERROR CODE: 102"
		else
			disaster = "overheat"
	else if (capacity_increase < 0)
		if(!is_emagged || (is_emped && prob(5)) )
			warning_message = "ERROR CODE: 201"
		else
			disaster = "overheat"
	else if (mod_limit_increase < current_highest_mod)
		if(is_emagged || (is_emped && prob(5)) )
			warning_message = "ERROR CODE: 202"
		else
			disaster = "overheat"

	if(warning_message)
		to_chat(user,"<b>\The [src]</b> flashes, \"[warning_message].\"")
		playsound(src,'sound/machines/buzz-two.ogg', 50, 0)
		handle_click_empty(user)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*4)
		return
	else
		switch(disaster)
			if("spark")
				to_chat(user,"<span class='danger'>\The [src] sparks!</span>")
				spark(src.loc, 3, alldirs)
			if("overheat")
				to_chat(user,"<span class='danger'>\The [src] turns red hot!</span>")
				user.IgniteMob()
			if("explode")
				to_chat(user,"<span class='danger'>\The [src] violently explodes!</span>")
				explosion(get_turf(src.loc), 0, 1, 2, 4)
				qdel(src)

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		var/acc = burst_accuracy[min(i, burst_accuracy.len)]
		var/disp = dispersion[min(i, dispersion.len)]
		process_accuracy(projectile, user, target, acc, disp)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.zone_sel.selecting, clickparams))
			handle_post_fire(user, target, pointblank, reflex, i == burst)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	update_held_icon()
	//update timing
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.setMoveCooldown(move_delay)
	next_fire_time = world.time + fire_delay

/obj/item/gun/custom_ka/consume_next_projectile()
	if(!installed_cell || installed_cell.stored_charge < cost_increase)
		return null

	installed_cell.stored_charge -= cost_increase

	var/obj/item/projectile/kinetic/shot_projectile
	//Send fire events
	if(installed_cell)
		installed_cell.on_fire(src)
	if(installed_barrel)
		installed_barrel.on_fire(src)
		shot_projectile = new installed_barrel.projectile_type(src.loc)
	if(installed_upgrade_chip)
		installed_upgrade_chip.on_fire(src)

	shot_projectile.damage = damage_increase
	shot_projectile.range = range_increase
	shot_projectile.aoe = aoe_increase
	shot_projectile.base_damage = damage_increase
	return shot_projectile

/obj/item/gun/custom_ka/Initialize()
	. = ..()

	START_PROCESSING(SSprocessing, src)

	if(installed_cell)
		installed_cell = new installed_cell(src)
	if(installed_barrel)
		installed_barrel = new installed_barrel(src)
	if(installed_upgrade_chip)
		installed_upgrade_chip = new installed_upgrade_chip(src)

	update_stats()
	queue_icon_update()

/obj/item/gun/custom_ka/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/gun/custom_ka/process()
	if(installed_cell)
		installed_cell.on_update(src)
	if(installed_barrel)
		installed_barrel.on_update(src)
	if(installed_upgrade_chip)
		installed_upgrade_chip.on_update(src)

/obj/item/gun/custom_ka/update_icon()
	. = ..()
	cut_overlays()
	var/name_list = list("","","","")

	name_list[3] = src.build_name

	if(installed_upgrade_chip)
		add_overlay(installed_upgrade_chip.icon_state)
		name_list[4] = installed_upgrade_chip.build_name

	if(installed_cell)
		add_overlay(installed_cell.icon_state)
		name_list[1] = installed_cell.build_name

	if(installed_barrel)
		add_overlay(installed_barrel.icon_state)
		name_list[2] = installed_barrel.build_name

	official_name = sanitize(jointext(name_list," "))

	if(installed_barrel)
		if(custom_name)
			name = custom_name
		else
			name = "custom kinetic accelerator"
	else
		name = initial(name)

	if(wielded)
		item_state = "[initial(item_state)]_w"
	else
		item_state = initial(item_state)
	update_held_icon()

/obj/item/gun/custom_ka/proc/update_stats()
	//pls don't bully me for this code
	damage_increase = initial(damage_increase)
	firedelay_increase = initial(firedelay_increase)
	range_increase = initial(range_increase)
	recoil_increase = initial(recoil_increase)
	cost_increase = initial(cost_increase)
	cell_increase = initial(cell_increase)
	capacity_increase = initial(capacity_increase)
	mod_limit_increase = initial(mod_limit_increase)
	aoe_increase = initial(aoe_increase)

	if(installed_cell)
		damage_increase += installed_cell.damage_increase
		firedelay_increase += installed_cell.firedelay_increase
		range_increase += installed_cell.range_increase
		recoil_increase += installed_cell.recoil_increase
		cost_increase += installed_cell.cost_increase
		cell_increase += installed_cell.cell_increase
		capacity_increase += installed_cell.capacity_increase
		mod_limit_increase += installed_cell.mod_limit_increase
		aoe_increase += installed_cell.aoe_increase
		current_highest_mod = max(-installed_cell.capacity_increase,current_highest_mod)

	if(installed_barrel)
		fire_sound = installed_barrel.fire_sound
		damage_increase += installed_barrel.damage_increase
		firedelay_increase += installed_barrel.firedelay_increase
		range_increase += installed_barrel.range_increase
		recoil_increase += installed_barrel.recoil_increase
		cost_increase += installed_barrel.cost_increase
		cell_increase += installed_barrel.cell_increase
		capacity_increase += installed_barrel.capacity_increase
		mod_limit_increase += installed_barrel.mod_limit_increase
		aoe_increase += installed_barrel.aoe_increase
		current_highest_mod = max(-installed_barrel.capacity_increase,current_highest_mod)

	if(installed_upgrade_chip)
		damage_increase += installed_upgrade_chip.damage_increase
		firedelay_increase += installed_upgrade_chip.firedelay_increase
		range_increase += installed_upgrade_chip.range_increase
		recoil_increase += installed_upgrade_chip.recoil_increase
		cost_increase += installed_upgrade_chip.cost_increase
		cell_increase += installed_upgrade_chip.cell_increase
		capacity_increase += installed_upgrade_chip.capacity_increase
		mod_limit_increase += installed_upgrade_chip.mod_limit_increase
		aoe_increase += installed_upgrade_chip.aoe_increase
		current_highest_mod = max(-installed_upgrade_chip.capacity_increase,current_highest_mod)

	//Explot fixing
	cell_increase = max(cell_increase,0)
	cost_increase = max(cost_increase,1)
	recoil_increase = max(recoil_increase,1)
	firedelay_increase = max(firedelay_increase,0.125 SECONDS)

	aoe_increase += round(damage_increase/30)
	aoe_increase = max(0,aoe_increase)

	//Gun stats
	recoil = recoil_increase*0.25
	recoil = recoil*0.5

	fire_delay = firedelay_increase
	fire_delay_wielded = accuracy * 0.9

	accuracy = round(recoil_increase*0.25)
	accuracy_wielded = accuracy * 0.5

/obj/item/gun/custom_ka/attack_self(mob/user as mob)
	. = ..()

	if(!wielded)
		to_chat(user,"<span class='warning'>You must be holding \the [src] with two hands to do this!</span>")
		return

	if(installed_cell)
		installed_cell.attack_self(user)
	if(installed_barrel)
		installed_barrel.attack_self(user)
	if(installed_upgrade_chip)
		installed_upgrade_chip.attack_self(user)

/obj/item/gun/custom_ka/attackby(var/obj/item/I as obj, var/mob/user as mob)

	. = ..()

	if(istype(I,/obj/item/pen))
		custom_name = sanitize(input("Enter a custom name for your [name]", "Set Name") as text|null)
		to_chat(user,"You label \the [name] as \"[custom_name]\"")
		update_icon()
	else if(I.iswrench())
		if(installed_upgrade_chip)
			playsound(src,I.usesound, 50, 0)
			to_chat(user,"You remove \the [installed_upgrade_chip].")
			installed_upgrade_chip.forceMove(user.loc)
			installed_upgrade_chip.update_icon()
			installed_upgrade_chip = null
			update_stats()
			update_icon()
		else if(installed_barrel && can_disassemble_barrel)
			playsound(src,I.usesound, 50, 0)
			to_chat(user,"You remove \the [installed_barrel].")
			installed_barrel.forceMove(user.loc)
			installed_barrel.update_icon()
			installed_barrel = null
			update_stats()
			update_icon()
		else if(installed_cell && can_disassemble_cell)
			playsound(src,I.usesound, 50, 0)
			to_chat(user,"You remove \the [installed_cell].")
			installed_cell.forceMove(user.loc)
			installed_cell.update_icon()
			installed_cell = null
			update_stats()
			update_icon()
		else
			to_chat(user,"There is nothing to remove from \the [src].")
	else if(istype(I,/obj/item/custom_ka_upgrade/cells))
		if(installed_cell)
			to_chat(user,"There is already \an [installed_cell] installed.")
		else
			var/obj/item/custom_ka_upgrade/cells/tempvar = I
			installed_cell = tempvar
			user.remove_from_mob(installed_cell)
			installed_cell.forceMove(src)
			update_stats()
			update_icon()
			playsound(src,'sound/items/Wirecutter.ogg', 50, 0)
	else if(istype(I,/obj/item/custom_ka_upgrade/barrels))
		if(!installed_cell)
			to_chat(user,"You must install a power cell before installing \the [I].")
		else if(installed_barrel)
			to_chat(user,"There is already \an [installed_barrel] installed.")
		else
			var/obj/item/custom_ka_upgrade/barrels/tempvar = I
			installed_barrel = tempvar
			user.remove_from_mob(installed_barrel)
			installed_barrel.forceMove(src)
			update_stats()
			update_icon()
			playsound(src,'sound/items/Wirecutter.ogg', 50, 0)
	else if(istype(I,/obj/item/custom_ka_upgrade/upgrade_chips))
		if(!installed_cell || !installed_barrel)
			to_chat(user,"A barrel and a cell need to be installed before you install \the [I].")
		else if(installed_upgrade_chip)
			to_chat(user,"There is already \an [installed_upgrade_chip] installed.")
		else if(installed_cell.disallow_chip == TRUE)
			to_chat(user,"\The [installed_cell] prevents you from installing \the [I]!")
		else if(installed_barrel.disallow_chip == TRUE)
			to_chat(user,"\The [installed_barrel] prevents you from installing \the [I]!")
		else
			var/obj/item/custom_ka_upgrade/upgrade_chips/tempvar = I
			installed_upgrade_chip = tempvar
			user.remove_from_mob(installed_upgrade_chip)
			installed_upgrade_chip.forceMove(src)
			update_stats()
			update_icon()
			playsound(src,'sound/items/Wirecutter.ogg', 50, 0)

	if(installed_cell)
		installed_cell.attackby(I,user)
	if(installed_barrel)
		installed_barrel.attackby(I,user)
	if(installed_upgrade_chip)
		installed_upgrade_chip.attackby(I,user)

/obj/item/custom_ka_upgrade //base item
	name = null //abstract
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = ""
	var/build_name = ""
	var/damage_increase = 0
	var/firedelay_increase = 0
	var/range_increase = 0
	var/recoil_increase = 0
	var/cost_increase = 0
	var/cell_increase = 0
	var/capacity_increase = 0
	var/mod_limit_increase = 0
	var/aoe_increase = 0

	var/is_emagged = 0
	var/is_emped = 0

	var/disallow_chip = FALSE //Prevent installation of an upgrade chip.

/obj/item/custom_ka_upgrade/proc/on_update(var/obj/item/gun/custom_ka)
	//Do update related things here

/obj/item/custom_ka_upgrade/proc/on_fire(var/obj/item/gun/custom_ka)
	//Do fire related things here

/obj/item/custom_ka_upgrade/cells
	name = null //Abstract
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = ""
	damage_increase = 0
	firedelay_increase = 0
	range_increase = 0
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 0
	mod_limit_increase = 0
	var/stored_charge = 0
	var/pump_restore = 0
	var/pump_delay = 0
	var/is_pumping = FALSE //Prevents from pumping stupidly fast do to a do_after exploit
	origin_tech = list(TECH_MATERIAL = 2,TECH_ENGINEERING = 2,TECH_MAGNET = 2,TECH_POWER=2)

/obj/item/custom_ka_upgrade/barrels
	name = null //Abstract
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = ""
	damage_increase = 0
	firedelay_increase = 0
	range_increase = 0
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 0
	mod_limit_increase = 0
	var/fire_sound = 'sound/weapons/kinetic_accel.ogg'
	var/projectile_type = /obj/item/projectile/kinetic
	origin_tech = list(TECH_MATERIAL = 2,TECH_ENGINEERING = 2,TECH_MAGNET = 2)

/obj/item/custom_ka_upgrade/upgrade_chips
	name = null //Abstract
	icon = 'icons/obj/kinetic_accelerators.dmi'
	damage_increase = 0
	firedelay_increase = 0
	range_increase = 0
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 0
	mod_limit_increase = 0

	origin_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)


/obj/item/device/kinetic_analyzer
	name = "kinetic analyzer"
	desc = "Analyzes the kinetic accelerator and prints useful information on it's statistics."
	icon = 'icons/obj/device.dmi'
	icon_state = "kinetic_anal"


/obj/item/device/kinetic_analyzer/afterattack(var/atom/target, var/mob/living/user, proximity, params)

	user.visible_message(
		"<span class='warning'>\The [user] scans \the [target] with \the [src].</span>",
		"<span class='alert'>You scan \the [target] with \the [src].</span>")

	if(istype(target,/obj/item/gun/custom_ka))
		playsound(src, 'sound/machines/ping.ogg', 10, 1)

		var/obj/item/gun/custom_ka/ka = target

		var/total_message = "<b>Kinetic Accelerator Stats:</b><br>\
		Damage Rating: [ka.damage_increase*0.1]MJ<br>\
		Energy Rating: [ka.cost_increase]MJ<br>\
		Cell Rating: [ka.cell_increase]MJ<br>\
		Fire Delay: [ka.firedelay_increase]<br>\
		Range: [ka.range_increase]<br>\
		Recoil Rating: [ka.recoil_increase]kJ<br>\
		<b>Software Stats:</b><br>\
		Software Version: [ka.mod_limit_increase].[ka.mod_limit_increase*32 % 10].[ka.mod_limit_increase*64 % 324]<br>\
		Available Power Flow: [ka.capacity_increase*10]kW<br>"

		to_chat(user,"<span class='notice'>[total_message]</span>")
	else
		to_chat(user,"<span class='notice'>Nothing happens.</span>")

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
