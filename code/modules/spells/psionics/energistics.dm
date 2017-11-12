//Energistics is the discipline of manipulating non-physical elements or physical elements in a non-physical way, such as generating electricity, damaging someone's
//brain. The opposite discipline to energistics is coercion.

//-----------------------------------------------------------//

//Initiate:
//Latent powers are granted immediately to anyone who selects this discipline as their focus. Cantrips consume no willpower, only having a cooldown.

/spell/hand/psyker/light
	name = "Light"
	desc = "By touching an object, illuminate it for five minutes."
	school = "ENE"
	message = "You feel illuminated!"
	sparks_spread = 1
	sparks_amt = 2
	duration = 30
	casts = 1
	touch = 1
	friendly = 1
	charge_max = 100

/spell/hand/psyker/light/cast_hand(var/atom/A,var/mob/user)
	A.set_light(2,1,"#800080")
	return 1

/spell/aoe_turf/overload
	name = "Shatter Lights"
	desc = "This spell overloads any nearby lights."
	school = ENE
	charge_max = 100
	invocation = "flashes a brief purple glow from their eyes."
	invocation_type = SpI_EMOTE
	range = 7

	hud_state = "wiz_psy"

/spell/aoe_turf/knock/cast(list/targets)
	for(var/i = 0 to 10)
		for(var/obj/machinery/light/P in view(7, src))
			if(prob(66))
				P.flicker(1)
			else
				P.broken()
	return

/spell/hand/psyker/jolt
	name = "Jolt"
	desc = "Launch a beam of electricity at the target."
	school = "ENE"
	message = "Weak electricity courses through your body!"
	sparks_spread = 1
	sparks_amt = 2
	duration = 30
	spell_delay = 5
	charge_max = 100

/spell/hand/psyker/jolt/cast_hand(var/atom/A,var/mob/user)
	..()
	var/obj/item/projectile/beam/cavern/pew = new(get_turf(user))
	pew.shock_damage_low = 1
	pew.shock_damage_high = 5
	pew.damage = 1
	pew.original = target
	pew.current = target
	pew.starting = get_turf(user)
	pew.shot_from = user
	pew.yo = target.y - user.y
	pew.xo = target.x - user.x
	pew.launch(target)
	return 1

//Adept:
//Adept powers are largely nonoffensive, with small willpower costs and low cooldowns.

//Operant:

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

//Grandmasterclass: