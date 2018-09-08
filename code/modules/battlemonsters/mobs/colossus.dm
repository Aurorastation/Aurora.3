/mob/living/simple_animal/hostile/commanded/battlemonster/colossus
	name = "Colossus"
	short_name = "colossus"
	icon = 'icons/mob/96x96megafauna.dmi'
	icon_state = "eva"
	icon_living = "eva"
	icon_dead = ""
	icon_gib = ""

	attack_points = 1500
	defense_points = 2000
	health = 2000
	maxHealth = 2000

	speed = 48

	pixel_x = -16

	ranged = 1

/mob/living/simple_animal/hostile/commanded/battlemonster/colossus/OpenFire(target_mob)

	var/projectiles_to_shoot = rand(3,12)
	var/sleep_mod = rand(-10,3)
	if(sleep_mod > 0)
		projectiles_to_shoot *= 2
	var/i_mod = -projectiles_to_shoot*0.5
	var/spread_per_shot = min(rand(5,10),360/projectiles_to_shoot)

	if(sleep_mod <= 0)
		playsound(src, 'sound/magic/invoke_general.ogg', 100, 1)

	for(var/i=1,i < projectiles_to_shoot,i++)
		var/obj/item/projectile/energy/electrode/icebolt/spawned_projectile = new(src.loc)
		spawned_projectile.launch_projectile(target_mob, get_exposed_defense_zone(target_mob), src, 0, Get_Angle(src, target_mob) + (i_mod+i)*spread_per_shot)
		if(sleep_mod > 0)
			playsound(src, 'sound/magic/invoke_short.ogg', 100, 1)
			sleep(sleep_mod)

	return TRUE

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/MoveToTarget()
	if(prob(50))
		return

	. = ..()