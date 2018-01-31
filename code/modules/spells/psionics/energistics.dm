//Energistics is the discipline of manipulating non-physical elements or physical elements in a non-physical way, such as generating electricity, damaging someone's
//brain. The opposite discipline to energistics is coercion.

//-----------------------------------------------------------//

//Initiate:
//Latent powers are granted immediately to anyone who selects this discipline as their focus. Cantrips consume no willpower, only having a cooldown.

/spell/hand/psyker/light
	name = "Light"
	desc = "By touching an object, illuminate it for five minutes."
	school = ENE
	sparks_spread = 1
	sparks_amt = 2
	duration = 30
	casts = 1
	friendly = 1
	charge_max = 100
	min_range = 1

/spell/hand/psyker/light/cast_hand(var/atom/A,var/mob/user)
	user.visible_message("<span class='info'>\The [user] illuminates \the [A] with a mere touch of the hand!</span>")
	var/i_range = A.light_range
	var/i_power = A.light_power
	var/i_color = A.light_color
	A.set_light(5,1,"#800080")
	addtimer(CALLBACK(A, /atom/.proc/set_light, i_range, i_power, i_color), 5 MINUTES)
	return 1

/spell/aoe_turf/overload
	name = "Shatter Lights"
	desc = "This spell overloads any nearby lights."
	spell_flags = Z2NOCAST
	invocation_type = SpI_EMOTE
	message = "gestures to the sky as their eyes flash with energy!"
	school = ENE
	charge_max = 100
	range = 7

	hud_state = "wiz_psy"

/spell/aoe_turf/overload/cast(list/targets)
	for(var/obj/machinery/light/P in view(7, target))
		for(var/i = 0 to 3)
			P.flicker(1)
		P.broken()
		return

/spell/hand/psyker/soulfire
	name = "Soulfire"
	desc = "Burn away the target's willpower, adding it to your own."
	school = ENE
	power_level = 0
	spell_delay = 20
	duration = 10
	sparks_spread = 1
	sparks_amt = 2
	spell_delay = 15
	charge_max = 250
	casts = -1
	compatible_targets = list(/mob/living/carbon/human)

/spell/hand/psyker/soulfire/cast_hand(var/atom/A,var/mob/user)
	..()
	if(brain)
		if(brain.willpower > 0)
			var/soulfire = rand(3,9)
			brain.willpower -= soulfire
			if(psybrain.willpower < psybrain.max_willpower)
				psybrain.willpower += soulfire
				if(psybrain.willpower > psybrain.max_willpower)
					psybrain.willpower = psybrain.max_willpower
			anim(get_turf(A), A,'icons/effects/effects.dmi',,"soulfire",,A.dir)
			user.visible_message("<span class='danger'>\The [user] gestures violently towards \the [A]!</span>")
			A.visible_message("<span class='danger'>\The [A] is surrounded by a pulse of psionic energy!</span>")
			return 1
	return 0

//Adept:
//Adept powers are largely nonoffensive, with small willpower costs and low cooldowns.
/spell/aoe_turf/recharge
	name = "Recharge"
	desc = "This spell recharges all battery cells in a small area."
	spell_flags = Z2NOCAST
	invocation_type = SpI_EMOTE
	message = "gestures to the sky as their eyes flash with energy!"
	school = ENE
	power_level = 1
	power_cost = 20
	charge_max = 100

	hud_state = "wiz_psy"

/spell/aoe_turf/recharge/cast(list/targets)
	for(var/atom/movable/M in view(2, target))
		for(var/obj/item/weapon/cell/C in M.contents)
			if(C.charge != C.maxcharge)
				single_spark(C)
				if(C.maxcharge <= 0)
					C.maxcharge = 1
				C.charge += C.maxcharge/2
				if(C.charge >= C.maxcharge)
					C.charge = C.maxcharge

	for(var/obj/item/weapon/cell/C in view(2, target))
		if(C.charge != C.maxcharge)
			spark(C,3)
			if(C.maxcharge <= 0)
				C.maxcharge = 1
			C.charge += C.maxcharge/2
			if(C.charge >= C.maxcharge)
				C.charge = C.maxcharge

/spell/hand/psyker/emp_touch
	name = "Shutdown"
	desc = "By touching an object, emit a small EMP burst."
	school = ENE
	power_level = 1
	power_cost = 20
	spell_delay = 50
	duration = 15
	sparks_spread = 1
	sparks_amt = 2
	friendly = 1
	charge_max = 100
	min_range = 1

/spell/hand/psyker/emp_touch/cast_hand(var/atom/A,var/mob/user)
	user.visible_message("<span class='danger'>\The [A] emits an electromagnetic pulse at the touch of \the [user]!</span>")
	empulse(A, 1, 1)
	return 1

//Operant:

/spell/hand/psyker/jolt
	name = "Jolt"
	desc = "Launch a beam of electricity at the target."
	school = ENE
	power_level = 2
	power_cost = 40
	spell_delay = 20
	duration = 20
	sparks_spread = 1
	sparks_amt = 2
	spell_delay = 15
	charge_max = 100

/spell/hand/psyker/jolt/cast_hand(var/atom/A,var/mob/user)
	..()
	user.visible_message("<span class='danger'>\The [user] fires a bolt of electricity from their fingertips!</span>")
	var/obj/item/projectile/beam/cavern/pew = new(get_turf(user))
	playsound(user,'sound/magic/lightningbolt.ogg',40,1)
	pew.shock_damage_low = 10
	pew.shock_damage_high = 15
	pew.damage = 1
	pew.original = A
	pew.current = A
	pew.starting = get_turf(user)
	pew.shot_from = user
	pew.yo = A.y - user.y
	pew.xo = A.x - user.x
	pew.launch(A)
	return 1

/spell/hand/psyker/knock //open a door

//Masterclass:
//Masterclass powers and above are available only to those who have specialized in this particular discipline.

/spell/hand/psyker/insanity //inflict various, slightly randomized status effects

/spell/hand/psyker/greed //user absorbs all the willpower from mobs around them for a duration. at the end of the duration any unspent willpower over the casting
//psyker's max is dealt to the psyker in backblast, and divided evenly to any mobs remaining. any spent willpower under the psyker's max is backblasted evenly across
//any remaining mobs.
//(e.g 200+25 deals 25 backblast to the caster, and divvies out 5 willpower to the surrounding 5 mobs.)
//(200-25) deals 5 backblast to all those surrounding mobs.

//Grandmasterclass:
/spell/hand/psyker/null_lance //massive brain laser, pierces walls and targets