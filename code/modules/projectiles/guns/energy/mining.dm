/obj/item/weapon/gun/energy/kinetic_accelerator/cyborg
	name = "mounted proto-kinetic accelerator"
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/kinetic_accelerator
	name = "proto-kinetic accelerator"
	desc = "A reloadable, ranged mining tool that does increased damage in low pressure. Capable of holding up to six slots worth of mod kits."
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "kineticgun"
	item_state = "kineticgun"
	contained_sprite = 1
	charge_meter = 0
	fire_delay = 16
	slot_flags = SLOT_BELT|SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/kinetic
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'

	var/max_mod_capacity = 100
	var/list/modkits = list()

/obj/item/weapon/gun/energy/kinetic_accelerator/attack_self(mob/living/user as mob)
	if(power_supply.charge < power_supply.maxcharge)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user << "<span class='notice'>You begin charging \the [src]...</span>"
		if(do_after(user,20))
			playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
			user.visible_message(
				"<span class='warning'>\The [user] pumps \the [src]!</span>",
				"<span class='warning'>You pump \the [src]!</span>"
				)
			power_supply.charge = power_supply.maxcharge

/obj/item/weapon/gun/energy/kinetic_accelerator/examine(mob/user)
	..()
	if(max_mod_capacity)
		user << "<b>[get_remaining_mod_capacity()]%</b> mod capacity remaining."
		for(var/A in get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			user << "<span class='notice'>There is a [M.name] mod installed, using <b>[M.cost]%</b> capacity.</span>"

/obj/item/weapon/gun/energy/kinetic_accelerator/attackby(obj/item/A, mob/user)
	if(iscrowbar(A))
		if(modkits.len)
			user << "<span class='notice'>You pry the modifications out.</span>"
			playsound(loc, 100, 1)
			for(var/obj/item/borg/upgrade/modkit/M in modkits)
				M.uninstall(src)
		else
			user << "<span class='notice'>There are no modifications currently installed.</span>"
	else if(istype(A, /obj/item/borg/upgrade/modkit))
		var/obj/item/borg/upgrade/modkit/MK = A
		MK.install(src, user)
	else
		..()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/get_remaining_mod_capacity()
	var/current_capacity_used = 0
	for(var/A in get_modkits())
		var/obj/item/borg/upgrade/modkit/M = A
		current_capacity_used += M.cost
	return max_mod_capacity - current_capacity_used

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/get_modkits()
	. = list()
	for(var/A in modkits)
		. += A

//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 15
	damage_type = BRUTE
	check_armour = "bomb"
	kill_count = 5

	var/pressure_decrease = 0.25
	var/turf_aoe = FALSE
	var/mob_aoe = 0
	var/list/hit_overlays = list()

/obj/item/projectile/kinetic/launch_from_gun(atom/target, mob/user, obj/item/weapon/gun/launcher, var/target_zone, var/x_offset=0, var/y_offset=0)
	if(istype(launcher, /obj/item/weapon/gun/energy/kinetic_accelerator))
		var/obj/item/weapon/gun/energy/kinetic_accelerator/KA = launcher
		for(var/A in KA.get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			M.modify_projectile(src)
	..()

/obj/item/projectile/kinetic/on_impact(var/atom/A)
	strike_thing(A)
	. = ..()

/obj/item/projectile/kinetic/proc/strike_thing(atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		target_turf = get_turf(src)
	var/datum/gas_mixture/environment = target_turf.return_air()
	var/pressure = environment.return_pressure()
	if(pressure > 50)
		name = "weakened [name]"
		damage *= pressure_decrease
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.GetDrilled(1)
	var/obj/effect/overlay/temp/kinetic_blast/K = new /obj/effect/overlay/temp/kinetic_blast(target_turf)
	K.color = color
	for(var/type in hit_overlays)
		new type(target_turf)
	if(turf_aoe)
		for(var/T in orange(1, target_turf))
			if(istype(T, /turf/simulated/mineral))
				var/turf/simulated/mineral/M = T
				M.GetDrilled(1)
	if(mob_aoe)
		for(var/mob/living/L in range(1, target_turf) - firer - target)
			L.apply_damage(damage*mob_aoe, damage_type, def_zone, armor)
			L << "<span class='danger'>You're struck by a [name]!</span>"


//Modkits
/obj/item/borg/upgrade/modkit
	name = "modification kit"
	desc = "An upgrade for kinetic accelerators."
	icon = 'icons/obj/mining.dmi'
	icon_state = "modkit"
	origin_tech = "programming=2;materials=2;magnets=4"
	var/denied_type = null
	var/maximum_of_type = 1
	var/cost = 30
	var/modifier = 1 //For use in any mod kit that has numerical modifiers

/obj/item/borg/upgrade/modkit/examine(mob/user)
	..()
	user << "<span class='notice'>Occupies <b>[cost]%</b> of mod capacity.</span>"

/obj/item/borg/upgrade/modkit/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/weapon/gun/energy/kinetic_accelerator) && !issilicon(user))
		install(A, user)
	else
		..()

/obj/item/borg/upgrade/modkit/action(mob/living/silicon/robot/R)
	if(..())
		return

	for(var/obj/item/weapon/gun/energy/kinetic_accelerator/cyborg/H in R.module.modules)
		return install(H, usr)

/obj/item/borg/upgrade/modkit/proc/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	. = TRUE
	if(denied_type)
		var/number_of_denied = 0
		for(var/A in KA.get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			if(istype(M, denied_type))
				number_of_denied++
			if(number_of_denied >= maximum_of_type)
				. = FALSE
				break
	if(KA.get_remaining_mod_capacity() >= cost)
		if(.)
			user << "<span class='notice'>You install the modkit.</span>"
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user.unEquip(src)
			forceMove(KA)
			KA.modkits += src
		else
			user << "<span class='notice'>The modkit you're trying to install would conflict with an already installed modkit. Use a crowbar to remove existing modkits.</span>"
	else
		user << "<span class='notice'>You don't have room(<b>[KA.get_remaining_mod_capacity()]%</b> remaining, [cost]% needed) to install this modkit. Use a crowbar to remove existing modkits.</span>"
		. = FALSE



/obj/item/borg/upgrade/modkit/proc/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	forceMove(get_turf(KA))
	KA.modkits -= src

/obj/item/borg/upgrade/modkit/proc/modify_projectile(obj/item/projectile/kinetic/K)


//Range
/obj/item/borg/upgrade/modkit/range
	name = "range increase"
	desc = "Increases the range of a kinetic accelerator when installed."
	modifier = 20
	cost = 24 //so you can fit four plus a tracer cosmetic

/obj/item/borg/upgrade/modkit/range/modify_projectile(obj/item/projectile/kinetic/K)
	K.kill_count += modifier


//Damage
/obj/item/borg/upgrade/modkit/damage
	name = "damage increase"
	desc = "Increases the damage of kinetic accelerator when installed."
	modifier = 10

/obj/item/borg/upgrade/modkit/damage/modify_projectile(obj/item/projectile/kinetic/K)
	K.damage += modifier


//Cooldown
/obj/item/borg/upgrade/modkit/cooldown
	name = "cooldown decrease"
	desc = "Decreases the cooldown of a kinetic accelerator and increases the recharge rate."
	modifier = 2

/obj/item/borg/upgrade/modkit/cooldown/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.fire_delay -= modifier
		KA.recharge_time -= modifier

/obj/item/borg/upgrade/modkit/cooldown/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	KA.fire_delay += modifier
	KA.recharge_time += modifier
	..()


//AoE blasts
/obj/item/borg/upgrade/modkit/aoe
	modifier = 0

/obj/item/borg/upgrade/modkit/aoe/modify_projectile(obj/item/projectile/kinetic/K)
	K.name = "kinetic explosion"
	if(!K.turf_aoe && !K.mob_aoe)
		K.hit_overlays += /obj/effect/overlay/temp/explosion/fast
	K.mob_aoe += modifier

/obj/item/borg/upgrade/modkit/aoe/turfs
	name = "mining explosion"
	desc = "Causes the kinetic accelerator to destroy rock in an AoE."
	denied_type = /obj/item/borg/upgrade/modkit/aoe/turfs

/obj/item/borg/upgrade/modkit/aoe/turfs/modify_projectile(obj/item/projectile/kinetic/K)
	..()
	K.turf_aoe = TRUE

/obj/item/borg/upgrade/modkit/aoe/turfs/andmobs
	name = "offensive mining explosion"
	desc = "Causes the kinetic accelerator to destroy rock and damage mobs in an AoE."
	maximum_of_type = 3
	modifier = 0.25

/obj/item/borg/upgrade/modkit/aoe/mobs
	name = "offensive explosion"
	desc = "Causes the kinetic accelerator to damage mobs in an AoE."
	modifier = 0.2


//Indoors
/obj/item/borg/upgrade/modkit/indoors
	name = "decrease pressure penalty"
	desc = "Increases the damage a kinetic accelerator does in a high pressure environment."
	modifier = 2
	denied_type = /obj/item/borg/upgrade/modkit/indoors
	maximum_of_type = 2
	cost = 40

/obj/item/borg/upgrade/modkit/indoors/modify_projectile(obj/item/projectile/kinetic/K)
	K.pressure_decrease *= modifier

/obj/item/borg/upgrade/modkit/tracer
	name = "white tracer bolts"
	desc = "Causes kinetic accelerator bolts to have a white tracer trail and explosion."
	cost = 4
	denied_type = /obj/item/borg/upgrade/modkit/tracer
	var/bolt_color = "#FFFFFF"

/obj/item/borg/upgrade/modkit/tracer/modify_projectile(obj/item/projectile/kinetic/K)
	K.icon_state = "ka_tracer"
	K.color = bolt_color

/obj/item/borg/upgrade/modkit/tracer/adjustable
	name = "adjustable tracer bolts"
	desc = "Causes kinetic accelerator bolts to have a adjustably-colored tracer trail and explosion. Use in-hand to change color."

/obj/item/borg/upgrade/modkit/tracer/adjustable/attack_self(mob/user)
	bolt_color = input(user,"Choose Color") as color

/*******************PLASMA CUTTER*******************/

/obj/item/weapon/gun/energy/plasmacutter/mounted
	name = "mounted plasma cutter"
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	contained_sprite = 1
	charge_meter = 0
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "plasma"
	item_state = "plasma"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 15
	sharp = 1
	edge = 1
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 4000)
	projectile_type = /obj/item/projectile/beam/plasmacutter
	max_shots = 15

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	icon_state = "omnilaser"
	damage = 15
	damage_type = BURN
	check_armour = "laser"
	kill_count = 5
	pass_flags = PASSTABLE

	muzzle_type = /obj/effect/projectile/trilaser/muzzle
	tracer_type = /obj/effect/projectile/trilaser/tracer
	impact_type = /obj/effect/projectile/trilaser/impact
	maiming = 1
	maim_rate = 3
/obj/item/projectile/beam/plasmacutter/on_impact(var/atom/A)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		if(prob(33))
			M.GetDrilled(1)
			return
		else if(prob(88))
			M.emitter_blasts_taken += 2
		M.emitter_blasts_taken += 1
	. = ..()