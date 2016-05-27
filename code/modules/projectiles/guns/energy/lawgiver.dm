/obj/item/weapon/gun/energy/lawgiver
	name = "Lawgiver Mk II"
	icon_state = "lawgiver"
	item_state = "gun"
	origin_tech = "combat=6;magnets=5"
	projectile_type=/obj/item/projectile/bullet/pistol
	fire_sound='sound/weapons/Gunshot_smg.ogg'
	sel_mode = 1
	desc = "A highly advanced firearm for the modern police force. It has multiple voice-activated firing modes."
	var/dna	= null//dna-locking the firearm
	var/emagged = 0 //if the gun is emagged or not
	var/owner_name = null //Name of the (initial) owner
	var/message = null //Message that should be played to the user
	var/message_delay = 100 //Delay of the message_delay
	var/message_enabled = 0 //If playing the message should be enabled
	var/message_disable = 0 //If the loop should be stopped
	var/default_desc = "A highly advanced firearm for the modern police force. It has multiple voice-activated firing modes."

	firemodes = list(
		list(
			name="singleshot",
			charge_cost=50,
			fire_delay=3,
			recoil=1
		),
		list(
			name="rapidfire",
			charge_cost=150,
			fire_delay=3,
			recoil=1,
			burst=3,
			move_delay=4,
			accuracy = list(0,-1,-1,-2,-2),
			dispersion = list(0.0, 0.6, 1.0)
		),
		list(
			name="highex",
			charge_cost=300,
			fire_delay=6,
			recoil=3
		),
		list(
			name="stun",
			charge_cost=50,
			fire_delay=4,
			recoil=0
		),
		list(
			name="hotshot",
			charge_cost=200,
			fire_delay=4,
			recoil=3
		),
		list(
			name="armorpiercing",
			charge_cost=300,
			fire_delay=6,
			recoil=3
		),
		list(
			name="pellets",
			charge_cost=300,
			fire_delay=6,
			recoil=3
		),
	)

/obj/item/weapon/gun/energy/lawgiver/proc/play_message()
	while (message_enabled && !message_disable) //Shut down command issued. Inform user that boardcasting has been stopped
		usr.audible_message("<span class='warning'>[usr]'s [src.name] broadcasts: [message]</span>","")
		playsound(get_turf(src), 'sound/voice/halt.ogg', 100, 1, vary = 0)
		sleep(message_delay)
	usr << "\red Broadcasting Message disabled"
	message_enabled = 0
	message_disable = 0

/obj/item/weapon/gun/energy/lawgiver/attack_self(mob/living/carbon/user as mob)
	if(dna != null)
		return
	else
		src.dna = user.dna.unique_enzymes
		src.owner_name = user.real_name
		user << "\blue You feel your palm heat up as the gun reads your DNA profile."
		desc += "<br>Linked to: [user.real_name]"
		return

/obj/item/weapon/gun/energy/lawgiver/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(src.dna != user.dna.unique_enzymes && !emagged)
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ("l_arm")
			var/obj/item/organ/external/RA = H.get_organ("r_arm")
			var/active_hand = H.hand
			playsound(user, 'sound/weapons/lawgiver_idfail.ogg', 40, 1)
			user << "\red You hear a soft beep from the gun and 'ID FAIL' flashes across the screen."
			user << "<span class='danger'>You feel a tiny prick in your hand!</span>"
			user.drop_item()
			//Blow up Unauthorized Users Hand
			sleep(60)
			if(active_hand)
				LA.droplimb(0,DROPLIMB_BLUNT)
			else
				RA.droplimb(0,DROPLIMB_BLUNT)
		return 0
	..()

/obj/item/weapon/gun/energy/lawgiver/proc/Emag(mob/user as mob)
	usr << "<span class='warning'>You short out [src]'s id check</span>"
	emagged = 1
	return 1

/obj/item/weapon/gun/energy/lawgiver/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/emag) && !emagged)
		Emag(user)
	else
		..()

/obj/item/weapon/gun/energy/lawgiver/hear_talk(mob/living/M in range(0,src), msg)
	if( (src.dna==usr.dna.unique_enzymes || emagged) && (src in usr.contents))
		hear(msg)
	return

/obj/item/weapon/gun/energy/lawgiver/proc/hear(var/msg)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = ""," " = "")
	msg = sanitize_old(msg, replacechars)
	/* Firing Modes*/
	if(findtext(msg,"single"))
		sel_mode = 1
		projectile_type=/obj/item/projectile/bullet/pistol
		fire_sound='sound/weapons/Gunshot_smg.ogg'
		usr << "\red [src.name] is now set to single shot mode."
	else if(findtext(msg,"rapidfire"))
		sel_mode = 2
		projectile_type=/obj/item/projectile/bullet/pistol
		fire_sound='sound/weapons/Gunshot_smg.ogg'
		usr << "\red [src.name] is now set to rapid fire mode."
	else if(findtext(msg,"highex") || findtext(msg,"grenade"))
		sel_mode = 3
		projectile_type=/obj/item/projectile/bullet/gyro/law
		fire_sound='sound/effects/Explosion1.ogg'
		usr << "\red [src.name] is now set to high explosive mode."
	else if(findtext(msg,"stun"))
		sel_mode = 4
		projectile_type=/obj/item/projectile/beam/stun
		fire_sound='sound/weapons/Taser.ogg'
		usr << "\red [src.name] is now set to stun mode."
	else if(findtext(msg,"hotshot") || findtext(msg,"incendiary"))
		sel_mode = 5
		projectile_type=/obj/item/projectile/bullet/shotgun/incendiary
		fire_sound='sound/weapons/Gunshot.ogg'
		usr << "\red [src.name] is now set to incendiary mode."
	else if(findtext(msg,"armorpiercing") || findtext(msg,"execution"))
		sel_mode = 6
		projectile_type=/obj/item/projectile/bullet/rifle/a556
		fire_sound='sound/weapons/Gunshot.ogg'
		usr << "\red [src.name] is now set to armorpiercing mode."
	else if(findtext(msg,"pellets"))
		sel_mode = 7
		projectile_type=/obj/item/projectile/bullet/pellet/shotgun
		fire_sound='sound/weapons/Gunshot.ogg'
		usr << "\red [src.name] is now set to pellet mode."
	/* Other Stuff */
	else if(findtext(msg,"reset") && (findtext(msg,"user") || findtext(msg,"dna")))
		dna = null
		desc = default_desc
		usr << "\red [src.name]´s owner has been reset. Do not attempt to fire [src.name] without rebinding a new owner"
	else if((findtext(msg,"disable") || findtext(msg,"deactivate")) && findtext(msg,"crowdcontrol"))
		message_disable = 1
		usr << "\red [src.name]´s crowdcontrol deactivation sequence started"
	else if((findtext(msg,"enable") || findtext(msg,"activate")) && findtext(msg,"crowdcontrol"))
		if(message_enabled) //Check if a message is already broadcasting -> abort
			usr << "\red [src.name] is already broadcasting a message."
			return
		usr << "\red [src.name]´s crowdcontrol activation sequence started"
		message = "Citizens stay calm. Stand back from the crimescense. Interference with the crimescene carries an automatice brig sentence."
		message_enabled = 1
		message_disable = 0
		play_message()
	else
		return
