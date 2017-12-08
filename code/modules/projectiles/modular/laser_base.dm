/obj/item/laser_components
	var/reliability = 0
	var/damage = 1
	var/fire_delay = 0
	var/condition = 0 //inverse health of the component. subtracted from reliability.
	var/shots = 0
	var/burst = 0
	var/accuracy = 0

/obj/item/laser_components/modifier
	name = "modifier"
	desc = "A basic laser weapon modifier."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	reliability = -5
	var/mod_type
	var/base_malus = 2 //when modifiers get damaged they do not break, but make other components break faster
	var/malus = 2 //subtracted from weapon's overall reliability everytime it's fired
	var/obj/item/projectile/beam/projectile
	var/gun_force = 0 //melee damage of the gun
	var/chargetime = 0
	var/burst_delay = 0
	var/scope_name
	var/criticality

/obj/item/laser_components/capacitor
	name = "capacitor"
	desc = "A basic laser weapon capacitor."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	shots = 5
	damage = 10
	reliability = 50

/obj/item/laser_components/capacitor/proc/small_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	return

/obj/item/laser_components/capacitor/proc/medium_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	return

/obj/item/laser_components/capacitor/proc/critical_fail(var/obj/item/weapon/gun/energy/laser/prototype/prototype)
	return

/obj/item/laser_components/focusing_lens
	name = "focusing lens"
	desc = "A basic laser weapon focusing lens."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	var/dispersion = 0
	reliability = 25

/obj/item/device/laser_assembly
	name = "laser assembly (small)"
	desc = "A case for shoving things into. Hopefully they work."
	w_class = 2
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_small"
	var/size = CHASSIS_SMALL
	var/modifier_cap = 1

	var/list/gun_mods
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens

/obj/item/device/laser_assembly/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	var/obj/item/laser_components/A = D
	if(!istype(A))
		return ..()
	if(ismodifier(A) && modifiers.len < modifier_cap)
		modifiers += A
	else if(islasercapacitor(A))
		capacitor = A
	else if(isfocusinglens(A))
		focusing_lens = A
	else
		return ..()
	user << "<span class='notice'>You insert the [A] into the assembly.</span>"
	A.loc = src
	check_completion()

/obj/item/device/laser_assembly/proc/check_completion()
	if(capacitor && focusing_lens)
		finish()

/obj/item/device/laser_assembly/proc/finish()
	var/obj/item/weapon/gun/energy/laser/prototype/A = new /obj/item/weapon/gun/energy/laser/prototype
	A.origin_chassis = size
	A.capacitor = capacitor
	capacitor.loc = A
	A.focusing_lens = focusing_lens
	focusing_lens.loc = A
	if(modifiers.len)
		for(var/obj/item/laser_components/modifier in modifiers)
			A.modifiers += A
			modifier.loc = A
	A.loc = src.loc
	A.updatetype()
	modifiers = null
	focusing_lens = null
	capacitor = null
	qdel(src)