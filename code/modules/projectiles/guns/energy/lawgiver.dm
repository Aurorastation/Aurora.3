/obj/item/weapon/gun/energy/lawgiver
	name = "Lawgiver Mk II"
	desc = "A highly advanced firearm for the modern police force. It has multiple voice-activated firing modes."
	icon_state = "lawgiver"
	item_state = "gun"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	fire_delay = 3
	recoil = 1


	projectile_type = /obj/item/projectile/bullet/pistol
	origin_tech = "combat=6;magnets=5"

	var/ammomode = 0
	var/dna	//dna-locking the firearm

	proc/hear(message, source as mob)
		return


	/obj/item/weapon/gun/energy/lawgiver/attack_self(mob/user)
		if(dna != null)
			return
		else
			src.dna = user.dna.unique_enzymes
			user << "\blue You feel your palm heat up as the gun reads your DNA profile."
			desc += "<br>Linked to: [user.real_name]"

	Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
		if(src.dna != user.dna.unique_enzymes)
			user << "\red You hear a soft beep from the gun and 'ID FAIL' flashes across the screen."
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			user << "<span class='danger'>[src] blows up in your face!</span>"
			explosion(get_turf(user), 0, 0, 1, rand(1,2))
			user.drop_item()
			del(src)
			return 0
		..()


	hear_talk(mob/living/M in range(0,src), msg)
		hear(msg)
		return

	hear(var/msg)
		var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = ""," " = "")
		msg = sanitize_old(msg, replacechars)
		if(findtext(msg,"singleshot") && (src.dna==usr.dna.unique_enzymes) && (src in usr.contents))
			ammomode = 0
			charge_cost = 50
			fire_sound = 'sound/weapons/Gunshot_smg.ogg'
			usr << "\red [src.name] is now set to single shot mode."
			projectile_type = /obj/item/projectile/bullet/pistol
			fire_delay = 3
			burst_delay = 0
			recoil = 1
		else if(findtext(msg,"rapidfire") && (src.dna==usr.dna.unique_enzymes) && (src in usr.contents))
			ammomode = 1
			charge_cost = 50
			fire_sound = 'sound/weapons/Gunshot_smg.ogg'
			usr << "\red [src.name] is now set to rapid fire mode."
			projectile_type = /obj/item/projectile/bullet/pistol
			fire_delay = 1
			burst_delay = 0
			recoil = 2
		else if(findtext(msg,"highex") && (src.dna==usr.dna.unique_enzymes) && (src in usr.contents))
			ammomode = 2
			charge_cost = 200
			fire_sound = 'sound/effects/Explosion1.ogg'
			usr << "\red [src.name] is now set to high explosive mode."
			projectile_type = /obj/item/projectile/bullet/gyro/law
			fire_delay = 6
			burst_delay = 0
			recoil = 3
		else if(findtext(msg,"stun") && (src.dna==usr.dna.unique_enzymes) && (src in usr.contents))
			ammomode = 3
			charge_cost = 50
			fire_sound = 'sound/weapons/Taser.ogg'
			usr << "\red [src.name] is now set to stun mode."
			projectile_type = /obj/item/projectile/energy/electrode
			fire_delay = 4
			burst_delay = 0
			recoil = 0
		else if(findtext(msg,"hotshot") && (src.dna==usr.dna.unique_enzymes) && (src in usr.contents))
			ammomode = 4
			charge_cost = 200
			fire_sound = 'sound/weapons/lasercannonfire.ogg'
			usr << "\red [src.name] is now set to incendiary mode."
			projectile_type = /obj/item/projectile/bullet/shotgun
			fire_delay = 6
			burst_delay = 0
			recoil = 1
		else
			return
