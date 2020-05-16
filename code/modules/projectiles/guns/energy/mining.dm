/*******************PLASMA CUTTER*******************/

/obj/item/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	charge_meter = FALSE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "plasma"
	item_state = "plasma"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	accuracy = 1
	force = 15
	sharp = TRUE
	edge = TRUE
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_GLASS = 2000)
	projectile_type = /obj/item/projectile/beam/plasmacutter
	cell_type = /obj/item/cell/high
	charge_cost = 666.66 // 15 shots on a high cap cell
	needspin = FALSE

/obj/item/gun/energy/plasmacutter/examine(mob/user)
	..()
	if(user.Adjacent(src))
		if(power_supply)
			to_chat(user, FONT_SMALL(SPAN_NOTICE("It has a <b>[capitalize_first_letters(power_supply.name)]</b> installed as its power supply.")))
		else
			to_chat(user, FONT_SMALL(SPAN_WARNING("It has no power supply installed.")))

/obj/item/gun/energy/plasmacutter/attackby(obj/item/I, mob/user)
	if(I.isscrewdriver())
		if(power_supply)
			to_chat(user, SPAN_NOTICE("You uninstall \the [power_supply]."))
			power_supply.forceMove(get_turf(src))
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.put_in_hands(power_supply)
			power_supply = null
		else
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a power supply!"))
	else if(istype(I, /obj/item/cell))
		if(power_supply)
			to_chat(user, SPAN_WARNING("\The [src] already has a power supply installed!"))
		else
			to_chat(user, SPAN_NOTICE("You install \the [I] into \the [src]."))
			user.drop_from_inventory(I, src)
			power_supply = I
	else
		..()

/obj/item/gun/energy/plasmacutter/mounted
	name = "mounted plasma cutter"
	self_recharge = TRUE
	use_external_power = TRUE
	cell_type = null
	max_shots = 15

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	icon_state = "omnilaser"
	damage = 20
	damage_type = BURN
	check_armour = "laser"
	range = 5
	pass_flags = PASSTABLE

	muzzle_type = /obj/effect/projectile/muzzle/plasma_cutter
	tracer_type = /obj/effect/projectile/tracer/plasma_cutter
	impact_type = /obj/effect/projectile/impact/plasma_cutter
	maiming = TRUE
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
