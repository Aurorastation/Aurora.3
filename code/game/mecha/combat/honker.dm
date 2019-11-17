/obj/mecha/combat/honker
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. Used to spread the fun and joy of life. HONK!"
	name = "H.O.N.K"
	icon_state = "honker"
	initial_icon = "honker"
	step_in = 2
	health = 140
	deflect_chance = 60
	internal_damage_threshold = 60
	damage_absorption = list("brute"=1.2,"fire"=1.5,"bullet"=1,"laser"=1,"energy"=1,"bomb"=1)
	max_temperature = 25000
	infra_luminosity = 5
//	operation_req_access = list(access_clown)
	wreckage = /obj/effect/decal/mecha_wreckage/honker
	add_req_access = 0
	max_equip = 3
	var/squeak = 0


/obj/mecha/combat/honker/Initialize()
	.= ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/honker
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar
	ME.attach(src)
	return


/obj/mecha/combat/honker/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		if(!squeak)
			playsound(src, "clownstep", 70, 1)
			squeak = 1
		else
			squeak = 0
	return result

//wreckage
/obj/effect/decal/mecha_wreckage/honker
	name = "Honker wreckage"
	icon_state = "honker-broken"

//honk weapons

/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "\improper HoNkER BlAsT 5000"
	desc = "Equipment for clown exosuits. Spreads fun and joy to everyone around. Honk!"
	icon_state = "mecha_honker"
	energy_drain = 200
	equip_cooldown = 150
	range = MELEE|RANGED
	required_type = list(/obj/mecha/combat/honker)

/obj/item/mecha_parts/mecha_equipment/weapon/honker/action(target)
	if(!chassis)
		return 0
	if(energy_drain && chassis.get_charge() < energy_drain)
		return 0
	if(!equip_ready)
		return 0
	playsound(chassis, 'sound/items/AirHorn.ogg', 100, 1)
	chassis.occupant_message("<font color='red' size='5'>HONK</font>")
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
				continue
		to_chat(M, "<font color='red' size='7'>HONK</font>")
		M.sleeping = 0
		M.stuttering += 20
		M.ear_deaf += 30
		M.Weaken(3)
		if(prob(30))
			M.Stun(10)
			M.Paralyse(4)
		else
			M.make_jittery(500)
	chassis.use_power(energy_drain)
	log_message("Honked from [src.name]. HONK!")
	do_after_cooldown()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar
	name = "banana mortar"
	desc = "Equipment for clown exosuits. Launches banana peels."
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/bananapeel
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectile_energy_cost = 100
	equip_cooldown = 20
	required_type = list(/obj/mecha/combat/honker)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar
	name = "mousetrap mortar"
	desc = "Equipment for clown exosuits. Launches armed mousetraps."
	icon_state = "mecha_mousetrapmrtr"
	projectile = /obj/item/device/assembly/mousetrap
	equip_cooldown = 10
	required_type = list(/obj/mecha/combat/honker)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/device/assembly/mousetrap/M = AM
	M.secured = 1
	..()