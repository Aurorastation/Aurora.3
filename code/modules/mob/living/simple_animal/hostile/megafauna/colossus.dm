/mob/living/simple_animal/hostile/megafauna/colossus
	name = "Colossus"
	icon = 'icons/mob/96x96megafauna.dmi'
	icon_state = "eva"
	icon_living = "eva"
	icon_dead = ""
	icon_gib = ""

	health = 1500
	maxHealth = 1500

	speed = 5 SECONDS
	move_to_delay = 5 SECONDS
	attack_delay = 3 SECONDS

	projectilesound = 'sound/magic/invoke_short.ogg'
	projectiletype = /obj/item/projectile/energy/icebolt

	melee_damage_lower = 0
	melee_damage_upper = 0

	pixel_x = -16

	ranged = 1

	var/ability_cooldown = 0

	var/attacking = FALSE

/mob/living/simple_animal/hostile/megafauna/colossus/holographic
	holographic = TRUE
	projectiletype = /obj/item/projectile/energy/electrode/icebolt

/mob/living/simple_animal/hostile/megafauna/colossus/boss
	health = 3000
	maxHealth = 3000

/mob/living/simple_animal/hostile/megafauna/colossus/AltClickOn(atom/movable/A)
	if(!istype(A))
		return
	else
		if(ability_cooldown >= world.time)
			to_chat(src, "<span class='warning'>You need to wait 10 seconds between special attacks!</span>")
			return
		INVOKE_ASYNC(src,.proc/SpamAttack,A,6,1)
		ability_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/megafauna/colossus/CtrlClickOn(atom/movable/A)
	if(!istype(A))
		return
	else
		if(ability_cooldown >= world.time)
			to_chat(src, "<span class='warning'>You need to wait 10 seconds between special attacks!</span>")
			return
		INVOKE_ASYNC(src,.proc/SpamAttack,A,24,3,360)
		ability_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/megafauna/colossus/OpenFire(target_mob)
	if(attacking)
		return ..()

	if(ckey)
		SpamAttack(target_mob,5,0)
	else
		if(ability_cooldown <= world.time)
			if(prob(50))
				INVOKE_ASYNC(src,.proc/SpamAttack, target_mob, 6, 1)
			else if(prob(50))
				INVOKE_ASYNC(src, .proc/SpamAttack, target_mob)
			else
				INVOKE_ASYNC(src,.proc/SpamAttack, target_mob, 24, rand(1,2), 180)
	return TRUE

/mob/living/simple_animal/hostile/megafauna/colossus/proc/SpamAttack(var/target_mob,var/projectiles = -1, var/delay = -1, var/spread = -1)
	if(attacking)
		return

	attacking = TRUE
	var/projectiles_to_shoot = projectiles >= 0 ? projectiles : rand(3,12)
	var/sleep_mod = delay >= 0 ? delay : rand(-10,3)
	if(sleep_mod > 0 && projectiles < 0)
		projectiles_to_shoot *= 2
	var/i_mod = -projectiles_to_shoot*0.5
	var/spread_per_shot = spread >= 0 ? spread/projectiles_to_shoot : min(rand(5,10),360/projectiles_to_shoot)

	ability_cooldown = 5 + (projectiles_to_shoot * sleep_mod)

	if(sleep_mod <= 0)
		playsound(src, 'sound/magic/invoke_general.ogg', 100, 1)

	for(var/i=1,i < projectiles_to_shoot,i++)
		if(sleep_mod == 0 && i % 2 == 0)
			continue
		var/obj/item/projectile/spawned_projectile = new projectiletype(src.loc)
		spawned_projectile.launch_projectile(target_mob, get_exposed_defense_zone(target_mob), src, 0, Get_Angle(src, target_mob) + (i_mod+i)*spread_per_shot)
		if(sleep_mod > 0 && projectiles >= 0)
			playsound(src, 'sound/magic/invoke_short.ogg', 100, 1)
			sleep(sleep_mod)

	attacking = FALSE

/mob/living/simple_animal/hostile/megafauna/bubblegum/death()
	..(null,death_message)
	qdel(src)

/mob/living/simple_animal/hostile/megafauna/colossus/DestroySurroundings()
	if(attacking)
		return
	..()

/mob/living/simple_animal/hostile/megafauna/colossus/MoveToTarget()
	if(attacking)
		return
	. = ..()