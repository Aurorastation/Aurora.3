/obj/item/laser_components
	icon = 'icons/obj/guns/modular_laser.dmi'
	var/base_icon_state = "bfg"
	contained_sprite = TRUE
	var/reliability = 0
	var/damage = 1
	var/fire_delay = 0
	var/condition = 0 //inverse health of the component. subtracted from reliability.
	var/shots = 0
	var/burst = 0
	var/accuracy = 0
	var/obj/item/repair_item
	var/gun_overlay

/obj/item/laser_components/proc/degrade(var/increment = 1)
	if(increment)
		condition += increment
		if(condition > reliability)
			condition = reliability

/obj/item/laser_components/attackby(var/obj/item/D as obj, var/mob/user as mob)
	if(!istype(D,repair_item))
		return ..()
	to_chat(user, "<span class='warning'>You begin repairing \the [src].</span>")
	if(do_after(user,20) && repair_module(D))
		to_chat(user, "<span class='notice'>You repair \the [src].</span>")
	else
		to_chat(user, "<span class='warning'>You fail to repair \the [src].</span>")

/obj/item/laser_components/proc/repair_module(var/obj/item/D)
	return 1

/obj/item/laser_components/modifier
	name = "modifier"
	desc = "A basic laser weapon modifier."
	reliability = -5
	var/mod_type
	var/base_malus = 2 //when modifiers get damaged they do not break, but make other components break faster
	var/malus = 2 //subtracted from weapon's overall reliability everytime it's fired
	var/gun_force = 0 //melee damage of the gun
	var/chargetime = 0
	var/burst_delay = 0
	var/scope_name
	var/criticality
	repair_item = /obj/item/weldingtool

/obj/item/laser_components/modifier/examine(mob/user)
	. = ..(user, 1)
	if(.)
		if(malus > base_malus)
			to_chat(user, "<span class='warning'>\The [src] appears damaged.</span>")

/obj/item/laser_components/modifier/degrade(var/increment = 1)
	if(increment)
		malus += increment
		if(malus > abs(base_malus*2))
			malus = abs(base_malus*2)

/obj/item/laser_components/modifier/repair_module(var/obj/item/weldingtool/W)
	if(!istype(W))
		return
	if(malus == base_malus)
		return 0
	if(W.remove_fuel(5))
		malus = max(malus - 5, base_malus)
		return 1
	return 0

/obj/item/laser_components/capacitor
	name = "capacitor"
	desc = "A basic laser weapon capacitor."
	base_icon_state = "capacitor"
	shots = 5
	damage = 10
	reliability = 50
	repair_item = /obj/item/stack/cable_coil

/obj/item/laser_components/capacitor/repair_module(var/obj/item/stack/cable_coil/C)
	if(!istype(C))
		return
	if(!condition > 0)
		return 0
	if(C.use(5))
		condition = max(condition - 5, 0)
		return 1
	return 0

/obj/item/laser_components/capacitor/examine(mob/user)
	. = ..(user, 1)
	if(.)
		if(condition > 0)
			to_chat(user, "<span class='warning'>\The [src] appears damaged.</span>")

/obj/item/laser_components/capacitor/proc/small_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	return

/obj/item/laser_components/capacitor/proc/medium_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	return

/obj/item/laser_components/capacitor/proc/critical_fail(var/mob/user, var/obj/item/gun/energy/laser/prototype/prototype)
	qdel(src)
	return

/obj/item/laser_components/focusing_lens
	name = "focusing lens"
	desc = "A basic laser weapon focusing lens."
	base_icon_state = "lens"
	var/list/dispersion = list(0.6,1.0,1.0,1.0,1.2,0.6,1.0,1.0,1.0,1.2,0.6,1.0,1.0,1.0,1.2,0.6,1.0,1.0,1.0,1.2)
	reliability = 25
	repair_item = /obj/item/stack/nanopaste

/obj/item/laser_components/focusing_lens/repair_module(var/obj/item/stack/nanopaste/N)
	if(!istype(N))
		return
	if(!condition > 0)
		return 0
	if(N.use(5))
		condition = max(condition - 5, 0)
		return 1
	return 0

/obj/item/laser_components/focusing_lens/examine(mob/user)
	. = ..(user, 1)
	if(.)
		if(condition > 0)
			to_chat(user, "<span class='warning'>\The [src] appears damaged.</span>")

/obj/item/laser_components/modulator
	name = "laser modulator"
	desc = "A modification that modulates the beam into a standard laser beam."
	base_icon_state = "laser"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	var/obj/item/projectile/beam/projectile = /obj/item/projectile/beam
	var/firing_sound = 'sound/weapons/laser1.ogg'

/obj/item/laser_components/modulator/degrade()
	return

/obj/item/device/laser_assembly
	name = "laser assembly (small)"
	desc = "A case for shoving things into. Hopefully they work."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/guns/modular_laser.dmi'
	var/base_icon_state = "small"
	contained_sprite = TRUE
	var/stage = 1
	var/size = CHASSIS_SMALL
	var/modifier_cap = 3

	var/list/gun_mods = list()
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens
	var/obj/item/laser_components/modulator/modulator

	var/ready_to_craft = FALSE // Use by weapons analyzer.
	var/datum/weakref/analyzer

/obj/item/device/laser_assembly/Initialize()
	. = ..()
	update_icon()

/obj/item/device/laser_assembly/attackby(var/obj/item/D as obj, var/mob/user as mob)
	var/obj/item/laser_components/A = D
	var/success = FALSE
	if(!istype(A))
		return ..()
	if(!ready_to_craft)
		to_chat(user, SPAN_WARNING("You cannot modify \the [src] by hand, you need to use a weapons analyzer."))
		return

	if(ismodifier(A) && gun_mods.len < modifier_cap)
		var/obj/item/laser_components/modifier/m = A
		for(var/v in gun_mods)
			var/obj/item/laser_components/modifier/M = v
			if(M.type == m.type)
				to_chat(user, SPAN_WARNING("\The [name] already has [m]."))
				return FALSE
		gun_mods += A
		user.drop_from_inventory(A,src)
		success = TRUE

	else if(islasercapacitor(A) && stage == 1)
		capacitor = A
		user.drop_from_inventory(A,src)
		stage = 2
		success = TRUE

	else if(isfocusinglens(A) && stage == 2)
		focusing_lens = A
		user.drop_from_inventory(A,src)
		stage = 3
		success = TRUE

	else if(ismodulator(A) && stage == 3)
		modulator = A
		user.drop_from_inventory(A,src)
		success = TRUE

	else
		return ..()
	to_chat(user, "<span class='notice'>You insert \the [A] into the assembly.</span>")
	update_icon()
	if(check_completion())
		success = 2 // meaning complete

	return success

/obj/item/device/laser_assembly/update_icon()
	..()
	underlays.Cut()
	icon_state = "[base_icon_state]_[stage]"
	if(gun_mods.len)
		for(var/obj/item/laser_components/mod in gun_mods)
			if(mod.gun_overlay)
				underlays += mod.gun_overlay


/obj/item/device/laser_assembly/proc/check_completion()
	if(capacitor && focusing_lens && modulator)
		return finish()

/obj/item/device/laser_assembly/proc/finish()

	var/obj/machinery/weapons_analyzer/an = analyzer.resolve()
	if(!an)
		return FALSE

	var/obj/item/gun/energy/laser/prototype/A = new /obj/item/gun/energy/laser/prototype
	A.icon_state = icon_state
	A.modifystate = icon_state
	A.origin_chassis = size
	A.capacitor = capacitor
	capacitor.forceMove(A)
	A.focusing_lens = focusing_lens
	focusing_lens.forceMove(A)
	A.modulator = modulator
	modulator.forceMove(A)
	if(gun_mods.len)
		for(var/v in gun_mods)
			var/obj/item/laser_components/modifier/mod = v
			A.gun_mods += mod
			mod.forceMove(A)
			if(mod.gun_overlay)
				A.underlays += mod.gun_overlay
	A.forceMove(an)
	an.item = A
	A.updatetype()
	A.pin = null
	gun_mods = null
	focusing_lens = null
	capacitor = null
	qdel(src)
	return TRUE

/obj/item/device/laser_assembly/get_print_info()
	. = ""
	for(var/i in list(capacitor, focusing_lens, modulator) + gun_mods)
		var/obj/item/laser_components/l_component = i
		if(!l_component)
			continue

		. += "<br>Component Name: [initial(l_component.name)]</br><br>"
		var/l_repair_name = initial(l_component.repair_item.name) ? initial(l_component.repair_item.name) : "nothing"
		. += "Reliability: [initial(l_component.reliability)]<br>"
		. += "Damage Modifier: [initial(l_component.damage)]<br>"
		. += "Fire Delay Modifier: [initial(l_component.fire_delay)]<br>"
		. += "Shots Modifier: [initial(l_component.fire_delay)]<br>"
		. += "Burst Modifier: [initial(l_component.burst)]<br>"
		. += "Accuracy Modifier: [initial(l_component.accuracy)]<br>"
		. += "Repair Tool: [l_repair_name]<br>"