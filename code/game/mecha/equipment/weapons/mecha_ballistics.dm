/obj/item/mecha_parts/mecha_equipment/weapon/ballistic
	name = "general ballisic weapon"
	var/projectile_energy_cost

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/get_equip_info()
	return "[..()]\[[src.projectiles]\][(src.projectiles < initial(src.projectiles))?" - <a href='?src=\ref[src];rearm=1'>Rearm</a>":null]"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/proc/rearm()
	if(projectiles < initial(projectiles))
		var/projectiles_to_add = initial(projectiles) - projectiles
		while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
			projectiles++
			projectiles_to_add--
			chassis.use_power(projectile_energy_cost)
	send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
	log_message("Rearmed [src.name].")
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/Topic(href, href_list)
	..()
	if (href_list["rearm"])
		src.rearm()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	name = "\improper LBX AC 10 \"Scattershot\""
	desc = "A weapon for combat exosuits. Shoots a spread of pellets."
	icon_state = "mecha_scatter"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/pellet
	fire_sound = 'sound/weapons/Gunshot.ogg'
	fire_volume = 80
	projectiles = 40
	deviation = 0.7
	projectile_energy_cost = 25

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	name = "\improper Ultra AC 2"
	desc = "A weapon for combat exosuits. A mounted machine-gun that shoots a rapid, three shot burst."
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/rifle/a556
	fire_sound = 'sound/weapons/gunshot_saw.ogg'
	projectiles = 300
	projectiles_per_shot = 3
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 2

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary
	name = "\improper HP-13 incendiary carbine"
	desc = "A weapon for combat exosuits. Shoots incendiary shells."
	icon_state = "mecha_carbine"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/shotgun/incendiary
	fire_sound = 'sound/weapons/Gunshot.ogg'
	projectiles = 50
	projectile_energy_cost = 40
	deviation = 0.7

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/sniper
	name = "mk III Anti-material cannon"
	desc = "A weapon for combat exosuits. A large mounted cannon that shoots anti-material shells."
	icon_state = "mecha_mime"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/rifle/a145
	fire_sound = 'sound/weapons/Gunshot_DMR.ogg'
	projectiles = 5
	projectile_energy_cost = 250

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gyro
	name = "\improper mounted gyrojet autocannon"
	desc = "A weapon for combat exosuits. A large mounted cannon that shoots explosive shells."
	icon_state = "mecha_grenadelnchr"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/gyro/law
	fire_sound = 'sound/effects/Explosion1.ogg'
	projectiles = 10
	projectile_energy_cost = 150
