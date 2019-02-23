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
		var/datum/callback/shoot_cb = CALLBACK(src, .proc/Fire, curloc, target, user, params)
		addtimer(shoot_cb, c + fire_cooldown)
		c += fire_cooldown
	if(equip_cooldown)
		reset_time = TRUE
		addtimer(CALLBACK(src, .proc/reset_fire), equip_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
	set_ready_state(0)
	return

/obj/item/mecha_parts/mecha_equipment/weapon/proc/Fire(var/turf/curloc, atom/target, mob/user, params)
	var/obj/item/projectile/P = new projectile(curloc)
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