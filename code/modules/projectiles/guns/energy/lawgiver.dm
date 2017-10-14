/obj/item/weapon/gun/energy/lawgiver
	name = "\improper Lawgiver Mk II"
	icon_state = "lawgiver"
	item_state = "gun"
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5)
	sel_mode = 1
	var/mode_check = 1
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
			mode_name = "singleshot",
			charge_cost = 50,
			fire_delay = 3,
			recoil = 1,
			burst = null,
			move_delay = null,
			accuracy = null,
			dispersion = null,
			projectile_type = /obj/item/projectile/bullet/pistol,
			fire_sound = 'sound/weapons/Gunshot_smg.ogg'
		),
		list(
			mode_name = "rapidfire",
			charge_cost = 150,
			fire_delay = 3,
			recoil = 1,
			burst = 3,
			move_delay = 4,
			accuracy = list(0,-1,-1,-2,-2),
			dispersion = list(0.0, 0.6, 1.0),
			projectile_type = /obj/item/projectile/bullet/pistol,
			fire_sound = 'sound/weapons/Gunshot_smg.ogg'
		),
		list(
			mode_name = "highex",
			charge_cost = 400,
			fire_delay = 6,
			recoil = 3,
			burst = null,
			move_delay = null,
			accuracy = null,
			dispersion = null,
			projectile_type = /obj/item/projectile/bullet/gyro/law,
			fire_sound = 'sound/effects/Explosion1.ogg'
		),
		list(
			mode_name = "stun",
			charge_cost = 50,
			fire_delay = 4,
			recoil = 0,
			burst = null,
			move_delay = null,
			accuracy = null,
			dispersion = null,
			projectile_type = /obj/item/projectile/beam/stun,
			fire_sound = 'sound/weapons/Taser.ogg'
		),
		list(
			mode_name = "hotshot",
			charge_cost = 250,
			fire_delay = 4,
			recoil = 3,
			burst = null,
			move_delay = null,
			accuracy = null,
			dispersion = null,
			projectile_type = /obj/item/projectile/bullet/shotgun/incendiary,
			fire_sound = 'sound/weapons/Gunshot.ogg'
		),
		list(
			mode_name = "armorpiercing",
			charge_cost = 130,
			fire_delay = 6,
			recoil = 3,
			burst = null,
			move_delay = null,
			accuracy = null,
			dispersion = null,
			projectile_type = /obj/item/projectile/bullet/rifle/a556,
			fire_sound = 'sound/weapons/Gunshot.ogg'
		),
		list(
			mode_name = "pellets",
			charge_cost = 250,
			fire_delay = 6,
			recoil = 3,
			burst = null,
			move_delay = null,
			accuracy = null,
			dispersion = null,
			projectile_type = /obj/item/projectile/bullet/pellet/shotgun,
			fire_sound = 'sound/weapons/Gunshot.ogg'
		)
	)

/obj/item/weapon/gun/energy/lawgiver/Initialize()
	. = ..()
	listening_objects += src
	power_supply = new /obj/item/weapon/cell/device/variable(src, 2000)
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)

/obj/item/weapon/gun/energy/lawgiver/Destroy()
	listening_objects -= src
	return ..()

/obj/item/weapon/gun/energy/lawgiver/proc/play_message()
	while (message_enabled && !message_disable) //Shut down command issued. Inform user that boardcasting has been stopped
		usr.audible_message("<span class='warning'>[usr]'s [src.name] broadcasts: [message]</span>","")
		playsound(get_turf(src), 'sound/voice/halt.ogg', 100, 1, vary = 0)
		sleep(message_delay)
	usr << "<span class='warning'>Broadcasting Message disabled</span>"
	message_enabled = 0
	message_disable = 0

/obj/item/weapon/gun/energy/lawgiver/attack_self(mob/living/carbon/user as mob)
	if(dna != null)
		return
	else
		src.dna = user.dna.unique_enzymes
		src.owner_name = user.real_name
		user << "<span class='notice'>You feel your palm heat up as the gun reads your DNA profile.</span>"
		desc += "<br>Linked to: [user.real_name]"
		return

/obj/item/weapon/gun/energy/lawgiver/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, pointblank=0, reflex = 0)
	if(src.dna != user.dna.unique_enzymes && !emagged)
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ("l_arm")
			var/obj/item/organ/external/RA = H.get_organ("r_arm")
			var/active_hand = H.hand
			playsound(user, 'sound/weapons/lawgiver_idfail.ogg', 40, 1)
			user << "<span class='danger'>You hear a soft beep from the gun and 'ID FAIL' flashes across the screen.</span>"
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
	var/mob/living/carbon/human/H = M
	if (!H || !istype(H))
		return
	if( (src.dna==H.dna.unique_enzymes || emagged) && (src in H.contents))
		hear(msg)
	return

/obj/item/weapon/gun/energy/lawgiver/proc/hear(var/msg)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = ""," " = "")
	msg = sanitize_old(msg, replacechars)
	/* Firing Modes*/
	if(findtext(msg,"single"))
		sel_mode = 1
		usr << "<span class='warning'>[src.name] is now set to single shot mode.</span>"
	else if(findtext(msg,"rapidfire"))
		sel_mode = 2
		usr << "<span class='warning'>[src.name] is now set to rapid fire mode.</span>"
	else if(findtext(msg,"highex") || findtext(msg,"grenade"))
		sel_mode = 3
		usr << "<span class='warning'>[src.name] is now set to high explosive mode.</span>"
	else if(findtext(msg,"stun"))
		sel_mode = 4
		usr << "<span class='warning'>[src.name] is now set to stun mode.</span>"
	else if(findtext(msg,"hotshot") || findtext(msg,"incendiary"))
		sel_mode = 5
		usr << "<span class='warning'>[src.name] is now set to incendiary mode.</span>"
	else if(findtext(msg,"armorpiercing") || findtext(msg,"execution"))
		sel_mode = 6
		usr << "<span class='warning'>[src.name] is now set to armorpiercing mode.</span>"
	else if(findtext(msg,"pellets"))
		sel_mode = 7
		usr << "<span class='warning'>[src.name] is now set to pellet mode.</span>"
	/* Other Stuff */
	else if(findtext(msg,"reset") && (findtext(msg,"user") || findtext(msg,"dna")))
		dna = null
		desc = default_desc
		usr << "<span class='warning'>[src.name]´s owner has been reset. Do not attempt to fire [src.name] without rebinding a new owner.</span>"
	else if((findtext(msg,"disable") || findtext(msg,"deactivate")) && findtext(msg,"crowdcontrol"))
		message_disable = 1
		usr << "<span class='warning'>[src.name]´s crowdcontrol deactivation sequence started.</span>"
	else if((findtext(msg,"enable") || findtext(msg,"activate")) && findtext(msg,"crowdcontrol"))
		if(message_enabled) //Check if a message is already broadcasting -> abort
			usr << "<span class='warning'>[src.name] is already broadcasting a message.</span>"
			return
		usr << "<span class='warning'>[src.name]´s crowdcontrol activation sequence started.</span>"
		message = "Citizens stay calm. Stand back from the crime scene. Interference with the crime scene carries an automatic brig sentence."
		message_enabled = 1
		message_disable = 0
		play_message()

	if(mode_check != sel_mode)
		var/datum/firemode/new_mode = firemodes[sel_mode]
		new_mode.apply_to(src)
		mode_check = sel_mode
