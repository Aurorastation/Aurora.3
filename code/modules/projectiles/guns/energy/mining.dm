/*******************PLASMA CUTTER*******************/

/obj/item/gun/energy/plasmacutter
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
	accuracy = 1
	force = 15
	sharp = 1
	edge = 1
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 4000)
	projectile_type = /obj/item/projectile/beam/plasmacutter
	max_shots = 15
	needspin = FALSE

/obj/item/gun/energy/plasmacutter/mounted
	name = "mounted plasma cutter"
	self_recharge = 1
	use_external_power = 1

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	icon_state = "omnilaser"
	damage = 15
	damage_type = BURN
	check_armour = "laser"
	range = 5
	pass_flags = PASSTABLE

	muzzle_type = /obj/effect/projectile/muzzle/plasma_cutter
	tracer_type = /obj/effect/projectile/tracer/plasma_cutter
	impact_type = /obj/effect/projectile/impact/plasma_cutter
	maiming = 1
	maim_rate = 1

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
