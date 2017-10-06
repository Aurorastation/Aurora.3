#define ai_log(M,V)	if(debug_ai) ai_log_output(M,V)

//Talky things
#define try_say_list(L) if(L.len) say(pick(L))

/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|HUMAN
	mob_push_flags = MONKEY|SLIME|HUMAN

	//Settings for played mobs
	var/show_stat_health = 1		// Does the percentage health show in the stat panel for the mob
	var/ai_inactive = 0 			// Set to 1 to turn off most AI actions

	//Mob icon/appearance settings
	var/icon_living = ""			// The iconstate if we're alive, required
	var/icon_dead = ""				// The iconstate if we're dead, required
	var/icon_gib = null				// The iconstate for being gibbed, optional
	var/icon_rest = null			// The iconstate for resting, optional
	var/image/modifier_overlay = null // Holds overlays from modifiers.

	//Mob talking settings
	universal_speak = 0				// Can all mobs in the entire universe understand this one?
	var/has_langs = list(LANGUAGE_GALCOM)// Text name of their language if they speak something other than galcom. They speak the first one.
	var/speak_chance = 0			// Probability that I talk (this is 'X in 200' chance since even 1/100 is pretty noisy)
	var/reacts = 0					// Reacts to some things being said
	var/list/speak = list()			// Things I might say if I talk
	var/list/emote_hear = list()	// Hearable emotes I might perform
	var/list/emote_see = list()		// Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	var/list/say_understood = list()// List of things to say when accepting an order
	var/list/say_cannot = list()	// List of things to say when they cannot comply
	var/list/say_maybe_target = list()// List of things to say when they spot something barely
	var/list/say_got_target = list()// List of things to say when they engage a target
	var/list/reactions = list() 	// List of "string" = "reaction" and things they hear will be searched for string.

	//Mob movement settings
	var/wander = 1					// Does the mob wander around when idle?
	var/wander_distance = 3			// How far the mob will wander before going home (assuming they are allowed to do that)
	var/returns_home = 0			// Mob knows how to return to wherever it started
	var/turns_per_move = 1			// How many life() cycles to wait between each wander mov?
	var/stop_when_pulled = 1 		// When set to 1 this stops the animal from moving when someone is pulling it.
	var/follow_dist = 2				// Distance the mob tries to follow a friend
	var/obstacles = list()			// Things this mob refuses to move through
	var/speed = 0					// Higher speed is slower, negative speed is faster.
	var/obj/item/weapon/card/id/myid// An ID card if they have one to give them access to stuff.
	var/turf/home_turf				// Set when they spawned, they try to come back here sometimes.

	//Mob interaction
	var/response_help   = "tries to help"	// If clicked on help intent
	var/response_disarm = "tries to disarm" // If clicked on disarm intent
	var/response_harm   = "tries to hurt"	// If clicked on harm intent
	var/harm_intent_damage = 3		// How much an unarmed harm click does to this mob.
	var/meat_amount = 0				// How much meat to drop from this mob when butchered
	var/obj/meat_type				// The meat object to drop
	var/list/loot_list = list()		// The list of lootable objects to drop, with "/path = prob%" structure
	var/recruitable = 0				// Mob can be bossed around
	var/recruit_cmd_str = "Hey,"	// The thing you prefix commands with when bossing them around
	var/intelligence_level = SA_ANIMAL// How 'smart' the mob is ICly, used to deliniate between animal, robot, and humanoid SAs.

	//Mob environment settings
	var/minbodytemp = 250			// Minimum "okay" temperature in kelvin
	var/maxbodytemp = 350			// Maximum of above
	var/heat_damage_per_tick = 3	// Amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	// Same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0				// 0 = fine, 1 = hot, 2 = cold

	var/min_oxy = 5					// Oxygen in moles, minimum, 0 is 'no minimum
	var/max_oxy = 0					// Oxygen in moles, maximum, 0 is 'no maximum'
	var/min_tox = 0					// Phoron min
	var/max_tox = 1					// Phoron max
	var/min_co2 = 0					// CO2 min
	var/max_co2 = 5					// CO2 max
	var/min_n2 = 0					// N2 min
	var/max_n2 = 0					// N2 max
	var/unsuitable_atoms_damage = 2	// This damage is taken when atmos doesn't fit all the requirements above

	//Hostility settings
	var/hostile = 0					// Do I even attack?
	var/retaliate = 0				// I respond to damage against specific targets.
	var/view_range = 7				// Scan for targets in this range.
	var/specific_targets = 0		// Only use Found() targets, ignore others.
	var/investigates = 0			// Do I investigate if I saw someone briefly?
	var/attack_same = 0				// Do I attack members of my own faction?
	var/cooperative = 0				// Do I ask allies to help me?
	var/assist_distance = 25		// Radius in which I'll ask my comrades for help.
	var/supernatural = 0			// If the mob is supernatural (used in null-rod stuff for banishing?)
	var/grab_resist = 75			// Chance of me resisting a grab attempt.

	//Attack ranged settings
	var/ranged = 0					// Do I attack at range?
	var/shoot_range = 7				// How far away do I start shooting from?
	var/rapid = 0					// Three-round-burst fire mode
	var/firing_lines = 0			// Avoids shooting allies
	var/projectiletype				// The projectiles I shoot
	var/projectilesound				// The sound I make when I do it
	var/casingtype					// What to make the hugely laggy casings pile out of

	//Mob melee settings
	var/melee_damage_lower = 2		// Lower bound of randomized melee damage
	var/melee_damage_upper = 6		// Upper bound of randomized melee damage
	var/attacktext = "attacked"		// "You are [attacktext] by the mob!"
	var/friendly = "nuzzles"		// What mobs do to people when they aren't really hostile
	var/attack_sound = null			// Sound to play when I attack
	var/environment_smash = 0		// How much environment damage do I do when I hit stuff?
	var/melee_miss_chance = 25		// percent chance to miss a melee attack.

	//Special attacks
	var/spattack_prob = 0			// Chance of the mob doing a special attack (0 for never)
	var/spattack_min_range = 0		// Min range to perform the special attacks from
	var/spattack_max_range = 0		// Max range to perform special attacks from

	//Attack movement settings
	var/run_at_them = 1				// Don't use A* pathfinding, use walk_to
	var/move_to_delay = 4			// Delay for the automated movement (deciseconds)
	var/destroy_surroundings = 1	// Should I smash things to get to my target?
	var/astar_adjacent_proc = /turf/proc/CardinalTurfsWithAccess // Proc to use when A* pathfinding.  Default makes them bound to cardinals.

	//Damage resistances
	var/resistance = 0				// Damage reduction for all types
	var/list/resistances = list(
								HALLOSS = 0,
								BRUTE = 1,
								BURN = 1,
								TOX = 1,
								OXY = 0,
								CLONE = 0
								)

	//Scary debug things
	var/debug_ai = 0				// Logging level for this mob (1,2,3)
	var/path_display = 0			// Will display the path in green when pathing
	var/path_icon = 'icons/misc/debug_group.dmi' // What icon to use for the overlay
	var/path_icon_state = "red"		// What state to use for the overlay
	var/icon/path_overlay			// A reference to restart

	////// These are used for inter-proc communications so don't edit them manually //////
	var/stance = STANCE_IDLE		// Used to determine behavior
	var/stop_automated_movement = 0 // Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/lifes_since_move = 0 		// A counter for how many life() cycles since move
	var/shuttletarget = null		// Shuttle's here, time to get to it
	var/enroute = 0					// If the shuttle is en-route
	var/purge = 0					// A counter used for null-rod stuff
	var/mob/living/target_mob		// Who I'm trying to attack
	var/mob/living/follow_mob		// Who I'm recruited by
	var/mob/living/list/friends = list() // People who are immune to my wrath, for now
	var/mob/living/simple_animal/list/faction_friends = list() // Other simple mobs I am friends with
	var/turf/list/walk_list = list()// List of turfs to walk through to get somewhere
	var/astarpathing = 0			// Am I currently pathing to somewhere?
	var/stance_changed = 0			// When our stance last changed (world.time)
	var/last_target_time = 0		// When we last set our target, to prevent juggles
	var/last_follow_time = 0		// When did we last get asked to follow someone?
	var/last_helpask_time = 0		// When did we last call for help?
	var/follow_until_time = 0		// Give up following when we reach this time (0 = never)
	var/annoyed = 0					// Do people keep distract-kiting us?
	////// ////// //////

/mob/living/simple_animal/New()
	..()
	verbs -= /mob/verb/observe
	home_turf = get_turf(src)
	path_overlay = new(path_icon,path_icon_state)
	move_to_delay = max(2,move_to_delay) //Protection against people coding things incorrectly and A* pathing 100% of the time

	for(var/L in has_langs)
		languages |= all_languages[L]
	if(languages.len)
		default_language = languages[1]

	if(cooperative)
		var/mob/living/simple_animal/first_friend
		for(var/mob/living/simple_animal/M in living_mob_list)
			if(M.faction == src.faction)
				first_friend = M
				break
		if(first_friend)
			faction_friends = first_friend.faction_friends
			faction_friends |= src
		else
			faction_friends |= src

/mob/living/simple_animal/Destroy()
	home_turf = null
	path_overlay = null
	default_language = null
	target_mob = null
	follow_mob = null
	if(myid)
		qdel(myid)
		myid = null

	if(faction_friends.len) //This list is shared amongst the faction
		faction_friends -= src

	friends.Cut() //This one is not
	walk_list.Cut()
	languages.Cut()
	return ..()

//Client attached
/mob/living/simple_animal/Login()
	if(src && src.client)
		src.client.screen = list()
		src.client.screen += src.client.void
		ai_inactive = 1
		handle_stance(STANCE_IDLE)
		LoseTarget()
		src.client << "<span class='notice'>Mob AI disabled while you are controlling the mob.</span>"
	..()

//Client detatched
/mob/living/simple_animal/Logout()
	if(src && !src.client)
		spawn(15 SECONDS) //15 seconds to get back into the mob before it goes wild
			if(src && !src.client)
				ai_inactive = initial(ai_inactive) //So if they never have an AI, they stay that way.
	..()

//For debug purposes!
/mob/living/simple_animal/proc/ai_log_output(var/msg = "missing message", var/ver = 1)
	if(ver <= debug_ai)
		log_debug("SA-AI: ([src]:[x],[y],[z])(@[world.time]): [msg] ")

//Should we be dead?
/mob/living/simple_animal/updatehealth()
	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		death()

	//Dead, becoming alive
	else if((stat >= DEAD) && (health > 0))
		dead_mob_list -= src
		living_mob_list += src
		stat = CONSCIOUS
		density = 1

	//Overhealth
	else if(health > getMaxHealth())
		health = getMaxHealth()

/mob/living/simple_animal/update_icon()
	..()
	//Awake and normal
	if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED) ))
		icon_state = icon_living

	//Resting or KO'd
	else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest)
		icon_state = icon_rest

	//Dead
	else if(stat >= DEAD)
		icon_state = icon_dead

	//Backup
	else
		icon_state = initial(icon_state)

// If your simple mob's update_icon() call calls overlays.Cut(), this needs to be called after this, or manually apply modifier_overly to overlays.
/mob/living/simple_animal/update_modifier_visuals()
	var/image/effects = null
	if(modifier_overlay)
		overlays -= modifier_overlay
		modifier_overlay.overlays.Cut()
		effects = modifier_overlay
	else
		effects = new()

	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image("icon" = 'icons/mob/modifier_effects.dmi', "icon_state" = M.mob_overlay_state)
			I.appearance_flags = RESET_COLOR // So colored mobs don't affect the overlay.
			effects.overlays += I

	modifier_overlay = effects
	overlays += modifier_overlay


/mob/living/simple_animal/Life()
	..()

	//Health
	updatehealth()
	if(stat >= DEAD)
		return 0

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_supernatural()
	handle_atmos() //Atmos
	update_icon()

	ai_log("Life() - stance=[stance] ai_inactive=[ai_inactive]", 4)

	//AI Actions
	if(!ai_inactive)
		//Stanceyness
		handle_stance()

		//Movement
		if(!stop_automated_movement && wander && !anchored) //Allowed to move?
			handle_wander_movement()

		//Speaking
		if(speak_chance && stance == STANCE_IDLE) // Allowed to chatter?
			handle_idle_speaking()

		//Resisting out buckles
		if(stance != STANCE_IDLE && incapacitated(INCAPACITATION_BUCKLED_PARTIALLY))
			handle_resist()

		//Resisting out of closets
		if(istype(loc,/obj/structure/closet))
			var/obj/structure/closet/C = loc
			if(C.welded)
				resist()
			else
				C.open()

	return 1

// Resists out of things.
// Sometimes there are times you want SAs to be buckled to something, so override this for when that is needed.
/mob/living/simple_animal/proc/handle_resist()
	resist()

// Peforms the random walk wandering
/mob/living/simple_animal/proc/handle_wander_movement()
	if(isturf(src.loc) && !resting && !buckled && canmove) //Physically capable of moving?
		lifes_since_move++ //Increment turns since move (turns are life() cycles)
		if(lifes_since_move >= turns_per_move)
			if(!(stop_when_pulled && pulledby)) //Some animals don't move when pulled
				var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
				moving_to = pick(cardinal)
				dir = moving_to			//How about we turn them the direction they are moving, yay.
				Move(get_step(src,moving_to))
				lifes_since_move = 0

// Handles random chatter, called from Life() when stance = STANCE_IDLE
/mob/living/simple_animal/proc/handle_idle_speaking()
	if(rand(0,200) < speak_chance)
		if(speak && speak.len)
			if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
				var/length = speak.len
				if(emote_hear && emote_hear.len)
					length += emote_hear.len
				if(emote_see && emote_see.len)
					length += emote_see.len
				var/randomValue = rand(1,length)
				if(randomValue <= speak.len)
					try_say_list(speak)
				else
					randomValue -= speak.len
					if(emote_see && randomValue <= emote_see.len)
						visible_emote("[pick(emote_see)].")
					else
						audible_emote("[pick(emote_hear)].")
			else
				try_say_list(speak)
		else
			if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				visible_emote("[pick(emote_see)].")
			if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
				audible_emote("[pick(emote_hear)].")
			if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				var/length = emote_hear.len + emote_see.len
				var/pick = rand(1,length)
				if(pick <= emote_see.len)
					visible_emote("[pick(emote_see)].")
				else
					audible_emote("[pick(emote_hear)].")

// Handle interacting with and taking damage from atmos
// TODO - Refactor this to use handle_environment() like a good /mob/living
/mob/living/simple_animal/proc/handle_atmos()
	var/atmos_suitable = 1

	var/atom/A = src.loc

	if(istype(A,/turf))
		var/turf/T = A

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)

			if( abs(Environment.temperature - bodytemperature) > 40 )
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy)
				if(Environment.gas["oxygen"] < min_oxy)
					atmos_suitable = 0
			if(max_oxy)
				if(Environment.gas["oxygen"] > max_oxy)
					atmos_suitable = 0
			if(min_tox)
				if(Environment.gas["phoron"] < min_tox)
					atmos_suitable = 0
			if(max_tox)
				if(Environment.gas["phoron"] > max_tox)
					atmos_suitable = 0
			if(min_n2)
				if(Environment.gas["nitrogen"] < min_n2)
					atmos_suitable = 0
			if(max_n2)
				if(Environment.gas["nitrogen"] > max_n2)
					atmos_suitable = 0
			if(min_co2)
				if(Environment.gas["carbon_dioxide"] < min_co2)
					atmos_suitable = 0
			if(max_co2)
				if(Environment.gas["carbon_dioxide"] > max_co2)
					atmos_suitable = 0

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustBruteLoss(heat_damage_per_tick)
	else
		fire_alert = 0

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atoms_damage)

// For setting the stance WITHOUT processing it
/mob/living/simple_animal/proc/set_stance(var/new_stance)
	stance = new_stance
	stance_changed = world.time
	ai_log("set_stance() changing to [new_stance]",2)

// For proccessing the current stance, or setting and processing a new one
/mob/living/simple_animal/proc/handle_stance(var/new_stance)
	if(ai_inactive)
		stance = STANCE_IDLE
		return

	if(new_stance)
		set_stance(new_stance)

	switch(stance)
		if(STANCE_IDLE)
			target_mob = null
			a_intent = I_HELP
			annoyed = max(0,annoyed--)

			//Yes I'm breaking this into two if()'s for ease of reading
			//If we ARE ALLOWED TO
			if(returns_home && home_turf && !astarpathing && (world.time - stance_changed) > 10 SECONDS)
				if(get_dist(src,home_turf) > wander_distance)
					move_to_delay = initial(move_to_delay)*2 //Walk back.
					GoHome()
				else
					stop_automated_movement = 0

			//Search for targets while idle
			if(hostile)
				FindTarget()
		if(STANCE_FOLLOW)
			annoyed = 15
			FollowTarget()
			if(follow_until_time && world.time > follow_until_time)
				LoseFollow()
				return
			if(hostile)
				FindTarget()
		if(STANCE_ATTACK)
			annoyed = 50
			a_intent = I_HURT
			RequestHelp()
			MoveToTarget()
		if(STANCE_ATTACKING)
			annoyed = 50
			AttackTarget()

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return
	ai_log("bullet_act() I was shot by: [Proj.firer]",2)

	if(Proj.taser_effect)
		stun_effect_act(0, Proj.agony)

	if(!Proj.nodamage)
		adjustBruteLoss(Proj.damage)

	if(Proj.firer)
		react_to_attack(Proj.firer)

	Proj.on_hit(src)

	return 0

// When someone clicks us with an empty hand
/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")

		if(I_DISARM)
			M.visible_message("<span class='notice'>[M] [response_disarm] \the [src].</span>")
			M.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(I_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return
			if(!incapacitated(INCAPACITATION_ALL) && (stance != STANCE_IDLE) && prob(grab_resist))
				M.visible_message("<span class='warning'>[M] tries to grab [src] but fails!</span>")
				return

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = M

			M.visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			M.do_attack_animation(src)
			ai_log("attack_hand() I was grabbed by: [M]",2)
			react_to_attack(M)

		if(I_HURT)
			adjustBruteLoss(harm_intent_damage)
			M.visible_message("<span class='warning'>[M] [response_harm] \the [src]!</span>")
			M.do_attack_animation(src)
			ai_log("attack_hand() I was hit by: [M]",2)
			react_to_attack(M)

	return

// When somoene clicks us with an item in hand
/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(health < getMaxHealth())
				if(MED.amount >= 1)
					adjustBruteLoss(-MED.heal_brute)
					MED.amount -= 1
					if(MED.amount <= 0)
						qdel(MED)
					for(var/mob/M in viewers(src, null))
						if ((M.client && !( M.blinded )))
							M.show_message("<span class='notice'>[user] applies the [MED] on [src].</span>")
		else
			user << "<span class='notice'>\The [src] is dead, medical items won't bring \him back to life.</span>"
	if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/weapon/material/knife) || istype(O, /obj/item/weapon/material/knife/butch))
			harvest(user)
	else
		O.attack(src, user, user.zone_sel.selecting)
		ai_log("attackby() I was weapon'd by: [user]",2)
		if(O.force)
			react_to_attack(user)

/mob/living/simple_animal/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	visible_message("<span class='danger'>\The [src] has been attacked with \the [O] by [user].</span>")

	if(O.force <= resistance)
		user << "<span class='danger'>This weapon is ineffective, it does no damage.</span>"
		return 2

	var/damage = O.force
	if (O.damtype == HALLOSS)
		damage = 0
	if(supernatural && istype(O,/obj/item/weapon/nullrod))
		damage *= 2
		purge = 3
	adjustBruteLoss(damage)
	ai_log("hit_with_weapon() I was h_w_weapon'd by: [user]",2)
	react_to_attack(user)

	return 0

// When someone throws something at us
/mob/living/simple_animal/hitby(atom/movable/AM)
	..()
	if(AM.thrower)
		react_to_attack(AM.thrower)

//SA vs SA basically
/mob/living/simple_animal/attack_generic(var/mob/attacker)
	..()
	if(attacker)
		react_to_attack(attacker)

/mob/living/simple_animal/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	return tally+config.animal_delay

/mob/living/simple_animal/Stat()
	..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / getMaxHealth()) * 100)]%")

/mob/living/simple_animal/lay_down()
	..()
	if(resting && icon_rest)
		icon_state = icon_rest
	else
		icon_state = icon_living

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!")
	density = 0 //We don't block even if we did before
	walk(src, 0) //We stop any background-processing walks

	if(faction_friends.len)
		faction_friends -= src

	if(loot_list.len) //Drop any loot
		for(var/path in loot_list)
			if(prob(loot_list[path]))
				new path(get_turf(src))

	spawn(3) //We'll update our icon in a sec
		update_icon()

	return ..(gibbed,deathmessage)

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		flash_eyes()
	switch (severity)
		if (1.0)
			adjustBruteLoss(500)
			gib()
			return

		if (2.0)
			adjustBruteLoss(60)


		if(3.0)
			adjustBruteLoss(30)

// Don't understand why simple animals don't use the regular /mob/living health system.
/mob/living/simple_animal/adjustBruteLoss(damage)
	if(damage > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				damage *= M.incoming_damage_percent
			if(!isnull(M.incoming_brute_damage_percent))
				damage *= M.incoming_brute_damage_percent
	else if(damage < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				damage *= M.incoming_healing_percent

	health = Clamp(health - damage, 0, getMaxHealth())
	updatehealth()

/mob/living/simple_animal/adjustFireLoss(damage)
	if(damage > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				damage *= M.incoming_damage_percent
			if(!isnull(M.incoming_fire_damage_percent))
				damage *= M.incoming_brute_damage_percent
	else if(damage < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				damage *= M.incoming_healing_percent

	health = Clamp(health - damage, 0, getMaxHealth())
	updatehealth()

/mob/living/simple_animal/adjustToxLoss(damage)
	if(damage > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				damage *= M.incoming_damage_percent
			if(!isnull(M.incoming_tox_damage_percent))
				damage *= M.incoming_brute_damage_percent
	else if(damage < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				damage *= M.incoming_healing_percent

	health = Clamp(health - damage, 0, getMaxHealth())
	updatehealth()

// Check target_mob if worthy of attack (i.e. check if they are dead or empty mecha)
/mob/living/simple_animal/proc/SA_attackable(target_mob)
	ai_log("SA_attackable([target_mob])",3)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(L.stat != DEAD)
			return 1
	if (istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		if (M.occupant)
			return 1
	ai_log("SA_attackable([target_mob]): no",3)
	return 0

/mob/living/simple_animal/say(var/message,var/datum/language/language)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_animal/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
			gib()

/mob/living/simple_animal/handle_fire()
	return

/mob/living/simple_animal/update_fire()
	return
/mob/living/simple_animal/IgniteMob()
	return
/mob/living/simple_animal/ExtinguishMob()
	return

//We got hit! Consider hitting them back!
/mob/living/simple_animal/proc/react_to_attack(var/mob/living/M)
	if(stat || M == target_mob) return //Not if we're dead or already hitting them
	if(M in friends || M.faction == faction) return //I'll overlook it THIS time...
	ai_log("react_to_attack([M])",1)
	if(retaliate && set_target(M))
		handle_stance(STANCE_ATTACK)
		return M

	return 0

/mob/living/simple_animal/proc/set_target(var/mob/M)
	ai_log("SetTarget([M])",2)
	if(!M || (world.time - last_target_time < 5 SECONDS) && target_mob)
		ai_log("SetTarget() can't set it again so soon",3)
		return 0

	var/turf/seen = get_turf(M)

	if(investigates && (annoyed < 10))
		try_say_list(say_maybe_target)
		face_atom(seen)
		annoyed += 14
		sleep(1 SECOND) //For realism

	if(M in ListTargets(view_range))
		try_say_list(say_got_target)
		target_mob = M
		last_target_time = world.time
		return M
	else if(investigates)
		spawn(1)
			WanderTowards(seen)

	return 0

// Set a follow target, with optional time for how long to follow them.
/mob/living/simple_animal/proc/set_follow(var/mob/M, var/follow_for = 0)
	ai_log("SetFollow([M]) for=[follow_for]",2)
	if(!M || (world.time - last_target_time < 4 SECONDS) && follow_mob)
		ai_log("SetFollow() can't set it again so soon",3)
		return 0

	follow_mob = M
	last_follow_time = world.time
	follow_until_time = !follow_for ? 0 : world.time + follow_for
	return 1

//Scan surroundings for a valid target
/mob/living/simple_animal/proc/FindTarget()
	var/atom/T = null
	for(var/atom/A in ListTargets(view_range))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break
		else if(specific_targets)
			return 0

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if(!SA_attackable(L))
				continue
			else if(!special_target_check(L))
				continue
			else
				T = L
				break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if(!SA_attackable(M))
				continue
			else if(!special_target_check(M))
				continue
			if((M.occupant.faction != src.faction) || attack_same)
				T = M
				break

	//You found one!
	if(T)
		ai_log("FindTarget() found [T]!",1)
		if(set_target(T))
			handle_stance(STANCE_ATTACK)

	return T

//Used for special targeting or reactions
/mob/living/simple_animal/proc/Found(var/atom/A)
	return

// Used for somewhat special targeting, but not to the extent of using Found()
/mob/living/simple_animal/proc/special_target_check(var/atom/A)
	return TRUE

//Requesting help from like-minded individuals
/mob/living/simple_animal/proc/RequestHelp()
	if(!cooperative || ((world.time - last_helpask_time) < 10 SECONDS))
		return

	ai_log("RequestHelp() to [faction_friends.len] friends",2)
	last_helpask_time = world.time
	for(var/mob/living/simple_animal/F in faction_friends)
		if(F == src) continue
		if(get_dist(src,F) <= F.assist_distance)
			spawn(0)
				if(F) //They could have died by now and some mobs delete themselves on death
					ai_log("RequestHelp() to [F]",3)
					F.HelpRequested(src)

//Someone wants help?
/mob/living/simple_animal/proc/HelpRequested(var/mob/living/simple_animal/F)
	if(target_mob || stat)
		ai_log("HelpRequested() by [F] but we're busy/dead",2)
		return
	if(get_dist(src,F) <= follow_dist)
		ai_log("HelpRequested() by [F] but we're already here",2)
		return
	if(get_dist(src,F) <= view_range)
		ai_log("HelpRequested() by [F] and within targetshare range",2)
		if(F.target_mob && set_target(F.target_mob))
			handle_stance(STANCE_ATTACK)
			return

	if(set_follow(F, 10 SECONDS))
		handle_stance(STANCE_FOLLOW)

// Can be used to conditionally do a ranged or melee attack.
// Note that the SA must be able to do an attack at the specified range or else it may get trapped in a loop of switching
// between STANCE_ATTACK and STANCE_ATTACKING, due to being told by MoveToTarget() that they're in range but being told by AttackTarget() that they're not.
/mob/living/simple_animal/proc/ClosestDistance()
	return ranged ? shoot_range - 1 : 1 // Shoot range -1 just because we don't want to constantly get kited

//Move to a target (or near if we're ranged)
/mob/living/simple_animal/proc/MoveToTarget()
	if(incapacitated(INCAPACITATION_DISABLED))
		ai_log("MoveToTarget() Bailing because we're disabled",2)
		return

	//If we were chasing someone and we can't anymore, give up.
	if(!target_mob || !SA_attackable(target_mob))
		ai_log("MoveToTarget() Losing target at top",2)
		LoseTarget()
		return

	//Don't wander
	stop_automated_movement = 1
	move_to_delay = initial(move_to_delay)

	//We recompute our path every time we're called if we can still see them
	if(target_mob in ListTargets(view_range))

		//Recompute the path if we were using one since we can still see them.
		if(astarpathing)
			ForgetPath()

		//Find out where we're getting to
		var/get_to = ClosestDistance()
		var/distance = get_dist(src,target_mob)
		ai_log("MoveToTarget() [src] get_to: [get_to] distance: [distance]",2)

		//We're here!
		if(distance <= get_to)
			ai_log("MoveToTarget() [src] attack range",2)
			handle_stance(STANCE_ATTACKING)
			return

		//We're just setting out, making a new path, or we can't path with A*
		if(!walk_list.len)
			ai_log("SA: MoveToTarget() pathing to [target_mob]",2)

			//GetPath failed for whatever reason, just smash into things towards them
			if(run_at_them || !GetPath(get_turf(target_mob),get_to))

				//We try the built-in way to stay close
				walk_to(src, target_mob, get_to, move_to_delay)
				ai_log("MoveToTarget() walk_to([src],[target_mob],[get_to],[move_to_delay])",3)

				//Break shit in their direction! LEME SMAHSH
				var/dir_to_mob = get_dir(src,target_mob)
				face_atom(target_mob)
				DestroySurroundings(dir_to_mob)
				ai_log("MoveToTarget() DestroySurroundings([get_dir(src,target_mob)])",3)

		//We have a path! We aren't already pathing it!
		if(!astarpathing && walk_list.len)
			ai_log("MoveToTarget() going to start a path",2)
			spawn(1)

				//Do the path!
				var/result = WalkPath(target_thing = target_mob, target_dist = get_to)
				ai_log("MoveToTarget() WalkPath r:[result]",2)

				//WalkPath failed, either interrupted for recalc, or something else
				if(!result)
					return

				//WalkPath either got close enough or we ran out of path
				else
					spawn(1)
						ai_log("MoveToTarget() resetting",2)
						MoveToTarget()

	//We can't see them, and we don't have a path we're trying to follow to find them
	else if(!astarpathing)
		ai_log("MoveToTarget() Losing target at bottom",2)
		LoseTarget() //Just forget it.

//Follow a target (and don't attempt to murder it horribly)
/mob/living/simple_animal/proc/FollowTarget()
	ai_log("FollowTarget() [follow_mob]",1)
	//If we were chasing someone and we can't anymore, give up.
	if(!follow_mob || follow_mob.stat)
		ai_log("FollowTarget() Losing follow at top",2)
		LoseFollow()
		return

	if(incapacitated(INCAPACITATION_DISABLED))
		ai_log("FollowTarget() Bailing because we're disabled",2)
		LoseFollow()
		return

	if((get_dist(src,follow_mob) <= follow_dist))
		ai_log("FollowTarget() Already at target",2)
		return

	move_to_delay = initial(move_to_delay)
	var/start_distance = get_dist(src,follow_mob)

	//Bad pathing
	if(run_at_them)
		walk_to(src, follow_mob, follow_dist, move_to_delay)
		ai_log("FollowTarget() walk_to([src],[target_mob],2,[move_to_delay])",3)
		spawn(3 SECONDS)
			if(src && follow_mob && (stance == STANCE_FOLLOW) && (get_dist(src,follow_mob) >= start_distance))
				ai_log("FollowTarget() walk_to not making headway, giving up",3)
				LoseFollow()

	//Good pathing
	else
		GetPath(get_turf(follow_mob),follow_dist)
		if(!astarpathing && walk_list.len)
			spawn(1)
				ai_log("FollowTarget() A* path getting underway",2)
				//Do the path!
				var/result = WalkPath(target_thing = follow_mob, target_dist = follow_dist)
				ai_log("FollowTarget() WalkPath r:[result]",3)

		else
			ai_log("FollowTarget() GetPath can't path, giving up",3)
			LoseFollow()

//Just try one time to go look at something. Don't really focus much on it.
/mob/living/simple_animal/proc/WanderTowards(var/turf/T)
	if(!T) return
	ai_log("WanderTowards() [T.x],[T.y]",1)

	stop_automated_movement = 1
	GetPath(T,1)

	if(run_at_them || !walk_list.len)
		ai_log("WanderTowards() walk_to getting underway",2)
		walk_to(src, T, 1, move_to_delay)
	else
		if(!astarpathing)
			spawn(1)
				ai_log("WanderTowards() A* path getting underway",2)
				WalkPath(target_thing = T, target_dist = 1)

//A* now, try to a path to a target
/mob/living/simple_animal/proc/GetPath(var/turf/target,var/get_to = 1,var/max_distance = world.view*6)
	ai_log("GetPath([target],[get_to],[max_distance])",2)
	ForgetPath()
	var/list/new_path = AStar(get_turf(loc), target, astar_adjacent_proc, /turf/proc/Distance, min_target_dist = get_to, max_node_depth = max_distance, id = myid, exclude = obstacles)

	if(new_path && new_path.len)
		walk_list = new_path
		if(path_display)
			for(var/turf/T in walk_list)
				T.overlays |= path_overlay
	else
		return 0

	return walk_list.len

//Walk along our A* path, target_thing allows us to stop early if we're nearby
/mob/living/simple_animal/proc/WalkPath(var/atom/target_thing, var/target_dist = 1, var/proc/steps_callback = null, var/every_steps = 4)
	ai_log("WalkPath() (steps:[walk_list.len])",2)
	if(!walk_list || !walk_list.len)
		return

	astarpathing = 1
	var/step_count = 0
	var/failed_steps = 0
	while(1)
		//We're supposed to stop
		if(!astarpathing || incapacitated(INCAPACITATION_DISABLED))
			astarpathing = 0
			ai_log("WalkPath() was interrupted",2)
			return 0
		//Finished the path
		if(!walk_list.len)
			astarpathing = 0
			ai_log("WalkPath() exited naturally",2)
			return 1
		if(failed_steps >= 3)
			astarpathing = 0
			ai_log("WalkPath() failed too many steps",2)
			return 0

		//Take a step
		if(!MoveOnce())
			ai_log("WalkPath() failed a step",3)
			failed_steps++
		else
			ai_log("WalkPath() took a step",3)
			failed_steps = 0
			step_count++

		//If we have a particular target we care about, look for them
		if(target_thing && (get_dist(src,target_thing) <= target_dist))
			ai_log("WalkPath() returning due to proximity",2)
			return target_thing

		//If we have a callback
		if(steps_callback && (step_count >= every_steps))
			ai_log("WalkPath() doing callback",3)
			call(steps_callback)()

		//And wait for the time to our next step
		sleep(move_to_delay)

//Take one step along a path
/mob/living/simple_animal/proc/MoveOnce()
	if(!walk_list.len)
		return

	if(path_display)
		var/turf/T = src.walk_list[1]
		T.overlays -= path_overlay

	step_towards(src, src.walk_list[1])
	if(src.loc != src.walk_list[1])
		ai_log("MoveOnce() step_towards returning 0",3)
		return 0
	else
		walk_list -= src.walk_list[1]
		ai_log("MoveOnce() step_towards returning 1",3)
		return 1

//Forget the path entirely
/mob/living/simple_animal/proc/ForgetPath()
	ai_log("ForgetPath()",2)
	if(path_display)
		for(var/turf/T in walk_list)
			T.overlays -= path_overlay
	astarpathing = 0
	walk_list.Cut()

//Giving up on moving
/mob/living/simple_animal/proc/GiveUpMoving()
	ai_log("GiveUpMoving()",1)
	ForgetPath()
	walk(src, 0)
	stop_automated_movement = 0

//Return home, all-in-one proc (though does target scan and drop out if they see one)
/mob/living/simple_animal/proc/GoHome()
	if(!home_turf) return
	if(astarpathing) ForgetPath()
	ai_log("GoHome()",1)
	var/close_enough = 2
	var/look_in = 250
	if(GetPath(home_turf,close_enough,look_in))
		stop_automated_movement = 1
		spawn(1)
			if(WalkPath()) //If we made it without interruption
				ai_log("GoHome() got home",2)
				GiveUpMoving() //Go back to wandering

//Get into attack mode on a target
/mob/living/simple_animal/proc/AttackTarget()
	stop_automated_movement = 1
	if(incapacitated(INCAPACITATION_DISABLED))
		ai_log("AttackTarget() Bailing because we're disabled",2)
		LoseTarget()
		return 0
	if(!target_mob || !SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(view_range)))
		LostTarget()
		return 0

	ai_log("AttackTarget() vs. [target_mob]",1)
	var/distance = get_dist(src, target_mob)
	face_atom(target_mob)

	//Hadoooooken!
	if(prob(spattack_prob) && (distance >= spattack_min_range) && (distance <= spattack_max_range))
		ai_log("AttackTarget() special",3)
		if(SpecialAtkTarget()) //Might not succeed/be allowed, do something else.
			return 1
	//AAAAH!
	if(distance <= 1)
		ai_log("AttackTarget() melee",3)
		PunchTarget()
		return 1
	//Open fire!
	else if(ranged && (distance <= shoot_range))
		ai_log("AttackTarget() ranged",3)
		ShootTarget(target_mob)
		return 1
	//They ran away!
	else
		ai_log("AttackTarget() out of range!",3)
		sleep(1) // Unfortunately this is needed to protect from ClosestDistance() sometimes not updating fast enough to prevent an infinite loop.
		handle_stance(STANCE_ATTACK)
		return 0

//Attack the target in melee
/mob/living/simple_animal/proc/PunchTarget()
	if(!Adjacent(target_mob))
		return
	if(!client)
		sleep(rand(8) + 8)
	if(isliving(target_mob))
		var/mob/living/L = target_mob

		if(prob(melee_miss_chance))
			src.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [L.name] ([L.ckey])</font>")
			L.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [src.name] ([src.ckey])</font>")
			src.visible_message("<span class='danger'>[src] misses [L]!</span>")
			src.do_attack_animation(src)
			return L
		else
			DoPunch(L)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		DoPunch(M)
		return M

// This is the actual act of 'punching'.  Override for special behaviour.
/mob/living/simple_animal/proc/DoPunch(var/atom/A)
	if(!Adjacent(target_mob)) // They could've moved in the meantime.
		return
	var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			damage_to_do *= M.outgoing_melee_damage_percent

	A.attack_generic(src, damage_to_do, attacktext)

//The actual top-level ranged attack proc
/mob/living/simple_animal/proc/ShootTarget()
	var/target = target_mob
	var/tturf = get_turf(target)

	if((firing_lines && !client) && !CheckFiringLine(tturf))
		step_rand(src)
		face_atom(tturf)
		return 0

	visible_message("<span class='danger'><b>[src]</b> fires at [target]!</span>")
	if(rapid)
		spawn(1)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(4)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(6)
			Shoot(target, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
	else
		Shoot(target, src.loc, src)
		if(casingtype)
			new casingtype

	return 1

//Check firing lines for faction_friends (if we're not cooperative, we don't care)
/mob/living/simple_animal/proc/CheckFiringLine(var/turf/tturf)
	if(!tturf) return

	var/turf/list/crosses = list()
	var/this_turf = get_turf(src)

	while(this_turf != tturf)
		this_turf = get_step(this_turf,get_dir(this_turf,tturf))
		crosses += this_turf

	for(var/mob/living/FF in faction_friends)
		if(FF.loc in crosses)
			return 0

	for(var/mob/living/F in friends)
		if(F.loc in crosses)
			return 0

	return 1

//Special attacks, like grenades or blinding spit or whatever
/mob/living/simple_animal/proc/SpecialAtkTarget()
	return 0

//Shoot a bullet at someone
/mob/living/simple_animal/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(user:loc)
	playsound(user, projectilesound, 100, 1)
	if(!A)	return

//	if (!istype(target, /turf))
//		qdel(A)
//		return
	A.launch(target)
	return

//We can't see the target
/mob/living/simple_animal/proc/LoseTarget()
	ai_log("LoseTarget() [target_mob]",2)
	target_mob = null
	handle_stance(STANCE_IDLE)
	GiveUpMoving()

//Target is no longer valid (?)
/mob/living/simple_animal/proc/LostTarget()
	handle_stance(STANCE_IDLE)
	GiveUpMoving()

//Forget a follow mode
/mob/living/simple_animal/proc/LoseFollow()
	ai_log("LoseFollow() [target_mob]",2)
	follow_mob = null
	handle_stance(STANCE_IDLE)
	GiveUpMoving()

// Makes the simple mob stop everything.  Useful for when it get stunned.
/mob/living/simple_animal/proc/Disable()
	ai_log("Disable() [target_mob]",2)
	spawn(0)
		LoseTarget()
		LoseFollow()

/mob/living/simple_animal/Stun(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_animal/AdjustStunned(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_animal/Weaken(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_animal/AdjustWeakened(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_animal/Paralyse(amount)
	if(amount > 0)
		Disable()
	..(amount)

/mob/living/simple_animal/AdjustParalysis(amount)
	if(amount > 0)
		Disable()
	..(amount)

//Find me some targets
/mob/living/simple_animal/proc/ListTargets(var/dist = view_range)
	var/list/L = hearers(src, dist)

	for(var/obj/mecha/M in mechas_list)
		if ((M.z == src.z) && (get_dist(src, M) <= dist) && (isInSight(src,M)))
			L += M

	return L

//Break through windows/other things
/mob/living/simple_animal/proc/DestroySurroundings(var/direction)
	if(!direction)
		direction = pick(cardinal) //FLAIL WILDLY

	var/turf/problem_turf = get_step(src, direction)

	ai_log("DestroySurroundings([direction])",3)
	var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			damage_to_do *= M.outgoing_melee_damage_percent

	for(var/obj/structure/window/obstacle in problem_turf)
		if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
			ai_log("DestroySurroundings() directional window hit",3)
			obstacle.attack_generic(src, damage_to_do, attacktext)
			return
		else if(obstacle.is_fulltile())
			ai_log("DestroySurroundings() full tile window hit",3)
			obstacle.attack_generic(src, damage_to_do, attacktext)
			return

	var/obj/structure/obstacle = locate(/obj/structure, problem_turf)
	if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
		ai_log("DestroySurroundings() generic structure hit [obstacle]",3)
		obstacle.attack_generic(src, damage_to_do ,attacktext)
		return

	for(var/obj/machinery/door/baddoor in problem_turf) //Required since firelocks take up the same turf
		if(baddoor.density)
			ai_log("DestroySurroundings() door hit [baddoor]",3)
			baddoor.attack_generic(src, damage_to_do ,attacktext)
			return

//Check for shuttle bumrush
/mob/living/simple_animal/proc/check_horde()
	return 0
	if(emergency_shuttle.shuttle.location)
		if(!enroute && !target_mob)	//The shuttle docked, all monsters rush for the escape hallway
			if(!shuttletarget && escape_list.len) //Make sure we didn't already assign it a target, and that there are targets to pick
				shuttletarget = pick(escape_list) //Pick a shuttle target
			enroute = 1
			stop_automated_movement = 1
			spawn()
				if(!src.stat)
					horde()

		if(get_dist(src, shuttletarget) <= 2)		//The monster reached the escape hallway
			enroute = 0
			stop_automated_movement = 0

//Shuttle bumrush
/mob/living/simple_animal/proc/horde()
	var/turf/T = get_step_to(src, shuttletarget)
	for(var/atom/A in T)
		if(istype(A,/obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/D = A
			D.open(1)
		else if(istype(A,/obj/structure/simple_door))
			var/obj/structure/simple_door/D = A
			if(D.density)
				D.Open()
		else if(istype(A,/obj/structure/cult/pylon))
			A.attack_generic(src, rand(melee_damage_lower, melee_damage_upper))
		else if(istype(A, /obj/structure/window) || istype(A, /obj/structure/closet) || istype(A, /obj/structure/table) || istype(A, /obj/structure/grille))
			A.attack_generic(src, rand(melee_damage_lower, melee_damage_upper))
	Move(T)
	FindTarget()
	if(!target_mob || enroute)
		spawn(10)
			if(!src.stat)
				horde()

//Touches a wire, etc
/mob/living/simple_animal/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	shock_damage *= siemens_coeff
	if (shock_damage < 1)
		return 0

	adjustFireLoss(shock_damage)
	playsound(loc, "sparks", 50, 1, -1)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

//Shot with taser/stunvolver
/mob/living/simple_animal/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon=null)
	var/stunDam = 0
	var/agonyDam = 0

	if(stun_amount)
		stunDam += stun_amount * 0.5
		adjustFireLoss(stunDam)

	if(agony_amount)
		agonyDam += agony_amount * 0.5
		adjustFireLoss(agonyDam)

//Commands, reactions, etc
/mob/living/simple_animal/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	..()
	if(reacts && speaker && (message in reactions) && (!hostile || isliving(speaker)) && say_understands(speaker,language))
		var/mob/living/L = speaker
		if(L.faction == faction)
			spawn(10)
				face_atom(speaker)
				say(reactions[message])

//Just some subpaths for easy searching
/mob/living/simple_animal/hostile
	faction = "not yours"
	hostile = 1
	retaliate = 1
	stop_when_pulled = 0
	destroy_surroundings = 1

/mob/living/simple_animal/retaliate
	retaliate = 1
	destroy_surroundings = 1
