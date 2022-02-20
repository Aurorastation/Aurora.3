/datum/technomancer/spell/audible_deception
	name = "Audible Deception"
	desc = "Allows you to create a specific sound at a location of your choosing."
	enhancement_desc = "An extremely loud bike horn sound that costs  large amount of energy and instability becomes available, \
	which will deafen and stun all who are near the targeted tile, including yourself if unprotected."
	cost = 50
	ability_icon_state = "boo"
	obj_path = /obj/item/spell/audible_deception
	ability_icon_state = "tech_audibledeception"
	category = UTILITY_SPELLS

/obj/item/spell/audible_deception
	name = "audible deception"
	icon_state = "audible_deception"
	desc = "Make them all paranoid!"
	cast_methods = CAST_RANGED | CAST_USE
	aspect = ASPECT_AIR
	cooldown = 10
	var/list/available_sounds = list(
		"Blade Slice"			=	'sound/weapons/bladeslice.ogg',
		"Energy Blade Slice"	=	'sound/weapons/blade.ogg',
		"Explosions"			=	"explosion",
		"Distant Explosion"		=	'sound/effects/explosionfar.ogg',
		"Sparks"				=	"sparks",
		"Punches"				=	"punch",
		"Glass Shattering"		=	"shatter",
		"Grille Damage"			=	'sound/effects/grillehit.ogg',
		"Energy Pulse"			=	'sound/effects/EMPulse.ogg',
		"Airlock"				=	'sound/machines/airlock.ogg',
		"Airlock Creak"			=	'sound/machines/airlock_open_force.ogg',

		"Shotgun Pumping"		=	'sound/weapons/shotgun_pump.ogg',
		"Flash"					=	'sound/weapons/flash.ogg',
		"Bite"					=	'sound/weapons/bite.ogg',
		"Low-Caliber Gun Firing"=	'sound/weapons/gunshot/gunshot_light.ogg',
		"Mateba Firing"			=	'sound/weapons/gunshot/gunshot_mateba.ogg',
		"Rifle Firing"			=	'sound/weapons/gunshot/gunshot_rifle.ogg',
		"Sniper Rifle Firing"	=	'sound/weapons/gunshot/gunshot_svd.ogg',
		"Antitank Rifle Firing" =	'sound/weapons/gunshot/gunshot_dmr.ogg',
		"Shotgun Firing"		=	'sound/weapons/gunshot/gunshot_shotgun.ogg',
		"Pistol Firing"			=	'sound/weapons/gunshot/gunshot_pistol.ogg',
		"Machinegun Firing"		=	'sound/weapons/gunshot/gunshot_saw.ogg',
		"Rocket Launcher Firing"=	'sound/weapons/rocketlaunch.ogg',
		"Taser Firing"			=	'sound/weapons/Taser.ogg',
		"Laser Rifle Firing"	=	'sound/weapons/laser1.ogg',
		"Xray Gun Firing"		=	'sound/weapons/laser3.ogg',
		"Pulse Gun Firing"		=	'sound/weapons/pulse.ogg',
		"Energy Sniper Firing"	=	'sound/weapons/laserstrong.ogg',
		"Emitter Firing"		=	'sound/weapons/emitter.ogg',
		"Energy Blade On"		=	'sound/weapons/saberon.ogg',
		"Energy Blade Off"		=	'sound/weapons/saberoff.ogg',
		"Wire Restraints"		=	'sound/weapons/cablecuff.ogg',
		"Handcuffs"				=	'sound/weapons/handcuffs.ogg',

		"Crowbar"				=	'sound/items/crowbar1.ogg',
		"Screwdriver"			=	'sound/items/Screwdriver.ogg',
		"Welding"				=	'sound/items/Welder.ogg',
		"Wirecutting"			=	'sound/items/Wirecutter.ogg',

		"Nymph Chirping"		=	'sound/misc/nymphchirp.ogg',
		"Sad Trombone"			=	'sound/misc/sadtrombone.ogg',
		"Honk"					=	'sound/items/bikehorn.ogg',
		"Bone Fracture"			=	"fracture",
		)
	var/selected_sound = null

/obj/item/spell/audible_deception/on_use_cast(mob/user)
	var/list/sound_options = available_sounds
	if(check_for_scepter())
		sound_options["!!AIR HORN!!"] = 'sound/items/AirHorn.ogg'
	var/new_sound = input("Select the sound you want to make.","Sounds") as null|anything in sound_options
	if(new_sound)
		selected_sound = sound_options[new_sound]

/obj/item/spell/audible_deception/on_ranged_cast(atom/hit_atom, mob/living/user)
	var/turf/T = get_turf(hit_atom)
	if(selected_sound && pay_energy(200))
		playsound(src, selected_sound, 80, 1, -1)
		adjust_instability(1)
		// Air Horn time.
		if(selected_sound == 'sound/items/AirHorn.ogg' && pay_energy(3800))
			adjust_instability(49) // Pay for your sins.
			for(var/mob/living/carbon/M in ohearers(6, T))
				M.SetSleeping(0)
				M.stuttering += 20
				M.ear_deaf += 30
				M.Weaken(3)
				if(prob(30))
					M.Stun(10)
					M.Paralyse(4)
				else
					M.make_jittery(50)
				to_chat(M, "<font color='red' size='7'><b>HONK</b></font>")
