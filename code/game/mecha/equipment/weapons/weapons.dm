/obj/item/mecha_parts/mecha_equipment/weapon
	name = "mecha weapon"
	range = RANGED
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/deviation = 0 //Inaccuracy of shots.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?
	var/fire_time = 5 //used to stop mechas from hitting themselves with their own bullets
	var/reset_time = FALSE // indicates if we need to wait before fire. Cause sleep sucks
	required_type = list(/obj/mecha/combat, /obj/mecha/working/hoverpod/combatpod)

/obj/item/mecha_parts/mecha_equipment/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return 0
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/action(atom/target, mob/user, params)
	if(!action_checks(target))
		return
	if(reset_time)
		occupant_message("<span class='warning'>\The [src] is not ready yet!</span>")
		return
	var/turf/curloc = chassis.loc
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='warning'>[chassis] fires [src]!</span>")
	occupant_message("<span class='warning'>You fire [src]!</span>")
	log_message("Fired from [src], targeting [target].")
	var/c = 0
	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		var/turf/aimloc = targloc
		if(deviation)
			aimloc = locate(targloc.x+GaussRandRound(deviation,1),targloc.y+GaussRandRound(deviation,1),targloc.z)
		if(!aimloc || aimloc == curloc)
			break
		projectiles--
		var/datum/callback/shoot_cb = CALLBACK(src, .proc/Fire_wrapper, curloc, target, user, params)
		addtimer(shoot_cb, c + fire_cooldown)
		c += fire_cooldown
	if(equip_cooldown)
		reset_time = TRUE
		addtimer(CALLBACK(src, .proc/reset_fire), equip_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
	set_ready_state(0)
	return

/obj/item/mecha_parts/mecha_equipment/weapon/proc/Fire_wrapper(var/turf/curloc, atom/target, mob/user, params)
	var/obj/item/projectile/P = new projectile(curloc)
	Fire(P, target, user, params)
	return

/obj/item/mecha_parts/mecha_equipment/weapon/proc/Fire(var/obj/item/projectile/P, atom/target, mob/user, params)
	var/def_zone
	if(chassis && istype(chassis.occupant,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = chassis.occupant
		def_zone = H.zone_sel.selecting
		H.setMoveCooldown(fire_time)
	P.launch_projectile(target, def_zone, user, params)
	playsound(chassis, fire_sound, fire_volume, 1)

/obj/item/mecha_parts/mecha_equipment/weapon/proc/reset_fire()
	set_ready_state(1)
	reset_time = FALSE

//////////////////////////
////// FLAMETHROWER //////
//////////////////////////

/obj/item/mecha_parts/mecha_equipment/weapon/flamethrower
	name = "mounted flamethrower"
	desc = "Mounted flamethrower for engineering firefighting exosuits. Used to deal with infestations."
	icon_state = "mecha_flamethrower"
	equip_cooldown = 10
	fire_sound = 'sound/weapons/flamethrower.ogg'
	fire_volume = 100
	required_type = list(/obj/mecha/working/ripley, /obj/mecha/combat)
	var/turf/previousturf = null
	var/obj/item/weapon/tank/phoron/ptank = null

/obj/item/mecha_parts/mecha_equipment/weapon/flamethrower/examine(mob/user)
	..()
	if(ptank)
		to_chat(user, "<span class='notice'>\The [src] has [ptank] attached, that displays [round(ptank.air_contents.return_pressure() ? ptank.air_contents.return_pressure() : 0)] KPa.</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] has no tank attached.</span>")

/obj/item/mecha_parts/mecha_equipment/weapon/flamethrower/attackby(obj/item/W as obj, mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	if(istype(W, /obj/item/weapon/tank/phoron))
		if(ptank)
			to_chat(user, "<span class='notice'>There appears to already be a phoron tank loaded in [src]!</span>")
			return
		to_chat(user, "<span class='notice'>You attach [W] to the [src].</span>")
		user.drop_from_inventory(W, src)
		ptank = W
		update_icon()
		return

// Change valve on internal tank
/obj/item/mecha_parts/mecha_equipment/weapon/flamethrower/verb/remove_tank()
	set src in oview(1)
	set category = "Object"
	set name = "Remove tank"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(!ishuman(usr))
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")
		return

	if(ptank)
		usr.visible_message(
		"<span class='warning'>[usr] is removing [src]'s [ptank].</span>",
		"<span class='notice'>You are removing [src]'s [ptank].</span>"
		)
		if (!do_after(usr, 2 SECONDS, act_target = src))
			return
		usr.visible_message(
		"<span class='warning'>[usr] has removed [src]'s [ptank].</span>" ,
		"<span class='notice'>You removed [src]'s [ptank].</span>"
		)
		update_icon()
	else
		to_chat(usr, "<span class='notice'>[src] has no tank.</span>")

/obj/item/mecha_parts/mecha_equipment/weapon/flamethrower/action(atom/target)
	if(!action_checks(target)) return
	if(!ptank)
		occupant_message("<span class='warning'>[src] has no tank attached!</span>")
		return
	var/turf/target_turf = get_turf(target)
	if(target_turf)
		var/turflist = getline(chassis, target_turf)
		playsound(chassis, fire_sound, fire_volume, 1)
		flame_turf(turflist)
		chassis.use_power(energy_drain)
		chassis.visible_message("<span class='warning'>[chassis] fires wall of fire from [src]!</span>")
		occupant_message("<span class='warning'>You fire wall of fire from [src]!</span>")
		log_message("Fired from [src], targeting [target].")
		if(equip_cooldown)
			reset_time = TRUE
			addtimer(CALLBACK(src, .proc/reset_fire), equip_cooldown)

//Called from turf.dm turf/dblclick
/obj/item/mecha_parts/mecha_equipment/weapon/flamethrower/proc/flame_turf(turflist)
	for(var/turf/T in turflist)
		if(T.density || istype(T, /turf/space))
			break
		if(!previousturf && length(turflist)>1)
			previousturf = get_turf(src)
			continue	//so we don't burn the tile we be standin on
		if(previousturf && LinkBlocked(previousturf, T))
			break
		ignite_turf(T)
		sleep(1)
	previousturf = null
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)
	return


/obj/item/mecha_parts/mecha_equipment/weapon/flamethrower/proc/ignite_turf(turf/target)
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(0.02)
	new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(target, air_transfer.gas["phoron"]*15,get_dir(loc,target))
	air_transfer.gas["phoron"] = 0
	target.assume_air(air_transfer)
	target.hotspot_expose((ptank.air_contents.temperature*2) + 380,500)
	return
