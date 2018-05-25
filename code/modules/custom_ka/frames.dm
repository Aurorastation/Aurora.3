/obj/item/weapon/gun/custom_ka
	name = "kinetic accelerator assembly"
	var/official_name
	var/custom_name
	desc = "A kinetic accelerator assembly."
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = ""
	item_state = "kineticgun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 2,TECH_ENGINEERING = 2)

	burst = 1
	fire_delay = 0 	//delay after shooting before the gun can be used again
	burst_delay = 2	//delay between shots, if firing in bursts
	move_delay = 1
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'
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

	pin = /obj/item/device/firing_pin

	sel_mode = 1 //index of the currently selected mode
	firemodes = list()

	//wielding information
	fire_delay_wielded = 0
	recoil_wielded = 0
	accuracy_wielded = 0
	wielded = 0
	needspin = TRUE

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

	var/current_highest_mod = 0


/obj/item/weapon/gun/custom_ka/examine(var/mob/user)
	. = ..()
	if(installed_upgrade_chip)
		user << "It is equipped with \the [installed_barrel], \the [installed_cell], and \the [installed_upgrade_chip]."
	else if(installed_barrel)
		user << "It is equipped with \the [installed_barrel] and \the [installed_cell]. It has space for an upgrade chip."
	else if(installed_cell)
		user << "It is equipped with \the [installed_cell]. The assembly lacks a barrel installation."

	if(installed_barrel)
		if(custom_name)
			user << "[custom_name] is written crudely in pen across the side, with the offical designation \"[official_name]\" is etched neatly on the side."
		else
			user << "The offical designation \"[official_name]\" is etched neatly on the side."

	if(installed_cell)
		user << "It has [round(installed_cell.stored_charge / cost_increase)] shots remaining."

/obj/item/weapon/gun/custom_ka/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)

	if(!fire_checks(target,user,clickparams,pointblank,reflex))
		return

	//Custom fire checks
	var/warning_message
	if(!installed_cell || !installed_barrel)
		warning_message = "ERROR CODE: 0"
	else if (damage_increase < 0)
		warning_message = "ERROR CODE: 100"
	else if (range_increase < 0)
		warning_message = "ERROR CODE: 200"
	else if (cost_increase > cell_increase)
		warning_message = "ERROR CODE: 300"
	else if (capacity_increase < 0)
		warning_message = "ERROR CODE: 400"
	else if (mod_limit_increase < current_highest_mod)
		warning_message = "ERROR CODE: 500"

	if(warning_message)
		user << "\The [src]'s screen flashes, \"[warning_message]\""
		playsound(src,'sound/machines/buzz-two.ogg', 50, 0)
		handle_click_empty(user)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		return

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

/obj/item/weapon/gun/custom_ka/consume_next_projectile()
	if(!installed_cell || installed_cell.stored_charge < cost_increase)
		return null

	installed_cell.stored_charge -= cost_increase

	var/obj/item/projectile/shot_projectile
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
	return shot_projectile

/obj/item/weapon/gun/custom_ka/Initialize()
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

/obj/item/weapon/gun/custom_ka/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/weapon/gun/custom_ka/process()
	if(installed_cell)
		installed_cell.on_update(src)
	if(installed_barrel)
		installed_barrel.on_update(src)
	if(installed_upgrade_chip)
		installed_upgrade_chip.on_update(src)
	. = ..()

/obj/item/weapon/gun/custom_ka/update_icon()
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
			name = official_name
	else
		name = initial(name)

/obj/item/weapon/gun/custom_ka/proc/update_stats()
	//pls don't bully me for this code
	damage_increase = initial(damage_increase)
	firedelay_increase = initial(firedelay_increase)
	range_increase = initial(range_increase)
	recoil_increase = initial(recoil_increase)
	cost_increase = initial(cost_increase)
	cell_increase = initial(cell_increase)
	capacity_increase = initial(capacity_increase)
	mod_limit_increase = initial(mod_limit_increase)

	if(installed_cell)
		damage_increase += installed_cell.damage_increase
		firedelay_increase += installed_cell.firedelay_increase
		range_increase += installed_cell.range_increase
		recoil_increase += installed_cell.recoil_increase
		cost_increase += installed_cell.cost_increase
		cell_increase += installed_cell.cell_increase
		capacity_increase += installed_cell.capacity_increase
		mod_limit_increase += installed_cell.mod_limit_increase
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
		current_highest_mod = max(-installed_upgrade_chip.capacity_increase,current_highest_mod)

	//Gun stats
	recoil = recoil_increase*0.25
	fire_delay = firedelay_increase
	accuracy = round(recoil_increase*0.25)

/obj/item/weapon/gun/custom_ka/attack_self(mob/user as mob)
	. = ..()
	if(installed_cell)
		installed_cell.attack_self(user)
	if(installed_barrel)
		installed_barrel.attack_self(user)
	if(installed_upgrade_chip)
		installed_upgrade_chip.attack_self(user)

/obj/item/weapon/gun/custom_ka/attackby(var/obj/item/I as obj, var/mob/user as mob)

	. = ..()

	if(istype(I,/obj/item/weapon/pen))
		custom_name = sanitize(input("Enter a custom name for your [name]", "Set Name") as text|null)
		user << "You label \the [name] as [custom_name]."
		update_icon()
	else if(istype(I,/obj/item/weapon/wrench))
		if(installed_upgrade_chip)
			playsound(src,'sound/items/Screwdriver.ogg', 50, 0)
			user << "You remove \the [installed_upgrade_chip]."
			installed_upgrade_chip.forceMove(user.loc)
			installed_upgrade_chip.update_icon()
			installed_upgrade_chip = null
			update_stats()
			update_icon()
		else if(installed_barrel)
			playsound(src,'sound/items/Ratchet.ogg', 50, 0)
			user << "You remove \the [installed_barrel]."
			installed_barrel.forceMove(user.loc)
			installed_barrel.update_icon()
			installed_barrel = null
			update_stats()
			update_icon()
		else if(installed_cell)
			playsound(src,'sound/items/Ratchet.ogg', 50, 0)
			user << "You remove \the [installed_cell]."
			installed_cell.forceMove(user.loc)
			installed_cell.update_icon()
			installed_cell = null
			update_stats()
			update_icon()
		else
			user << "There is nothing to remove from \the [src]."
	else if(istype(I,/obj/item/custom_ka_upgrade/cells))
		if(installed_cell)
			user << "There is already \an [installed_cell] installed."
		else
			var/obj/item/custom_ka_upgrade/cells/tempvar = I
			installed_cell = tempvar
			user.remove_from_mob(installed_cell)
			installed_cell.loc = src
			update_stats()
			update_icon()
			playsound(src,'sound/items/Wirecutter.ogg', 50, 0)
	else if(istype(I,/obj/item/custom_ka_upgrade/barrels))
		if(!installed_cell)
			user << "You must install a power cell before installing \the [I]."
		else if(installed_barrel)
			user << "There is already \an [installed_barrel] installed."
		else
			var/obj/item/custom_ka_upgrade/barrels/tempvar = I
			installed_barrel = tempvar
			user.remove_from_mob(installed_barrel)
			installed_barrel.loc = src
			update_stats()
			update_icon()
			playsound(src,'sound/items/Wirecutter.ogg', 50, 0)
	else if(istype(I,/obj/item/custom_ka_upgrade/upgrade_chips))
		if(!installed_cell || !installed_barrel)
			user << "A barrel and a cell need to be installed before you install \the [I]."
		else if(installed_upgrade_chip)
			user << "There is already \an [installed_upgrade_chip] installed."
		else
			var/obj/item/custom_ka_upgrade/upgrade_chips/tempvar = I
			installed_upgrade_chip = tempvar
			user.remove_from_mob(installed_upgrade_chip)
			installed_upgrade_chip.loc = src
			update_stats()
			update_icon()
			playsound(src,'sound/items/Wirecutter.ogg', 50, 0)

/obj/item/weapon/gun/custom_ka/frame01
	build_name = "Chickenlegs"
	icon_state = "frame01"
	w_class = 3
	damage_increase = 0
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 3
	mod_limit_increase = 2
	origin_tech = list(TECH_MATERIAL = 2,TECH_ENGINEERING = 2)

/obj/item/weapon/gun/custom_ka/frame02
	build_name = "Boomstick"
	icon_state = "frame02"
	w_class = 3
	damage_increase = 0
	recoil_increase = -1
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 5
	mod_limit_increase = 3
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3)

/obj/item/weapon/gun/custom_ka/frame03
	build_name = "Black Club"
	icon_state = "frame03"
	w_class = 4
	damage_increase = 0
	recoil_increase = -2
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 7
	mod_limit_increase = 4
	origin_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 4)

/obj/item/weapon/gun/custom_ka/frame04
	build_name = "Loopclaw"
	icon_state = "frame04"
	w_class = 5
	damage_increase = 0
	recoil_increase = -5
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 9
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 5)

/obj/item/weapon/gun/custom_ka/frame05
	build_name = "Laserback"
	icon_state = "frame05"
	w_class = 5
	damage_increase = 0
	recoil_increase = -6
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 10
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)

/obj/item/custom_ka_upgrade //base item
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

/obj/item/custom_ka_upgrade/proc/on_update(var/obj/item/weapon/gun/custom_ka)
	//Do update related things here
	return

/obj/item/custom_ka_upgrade/proc/on_fire(var/obj/item/weapon/gun/custom_ka)
	//Do fire related things here
	return


/obj/item/weapon/gun/custom_ka/frame01/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell01
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel01

/obj/item/weapon/gun/custom_ka/frame02/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell02
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel02
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/firerate

/obj/item/weapon/gun/custom_ka/frame03/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell03
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel03
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/effeciency

/obj/item/weapon/gun/custom_ka/frame04/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell04
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel04
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/obj/item/weapon/gun/custom_ka/frame05/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell05
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel05
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/damage

/obj/item/weapon/gun/custom_ka/frame01/illegal
	installed_cell = /obj/item/custom_ka_upgrade/cells/illegal
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/illegal
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/illegal