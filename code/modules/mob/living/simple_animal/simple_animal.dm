#define BLOOD_NONE "none"
#define BLOOD_LIGHT "light"
#define BLOOD_MEDIUM "medium"
#define BLOOD_HEAVY "heavy"


/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/npc/animal.dmi'
	health = 20
	maxHealth = 20

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	/// The type of damage this mob deals.
	var/damage_type = DAMAGE_BRUTE

	var/show_stat_health = 1	//does the percentage health show in the stat panel for the mob

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	appearance_flags = KEEP_TOGETHER
	var/blood_type = "#A10808" //Blood colour for impact visuals.
	var/blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	var/blood_state = BLOOD_NONE
	var/image/blood_overlay

	var/bleeding = FALSE
	var/blood_amount = 20			// set a limit to the amount of blood it can bleed, otherwise it will keep bleeding forever and crunk the server
	var/previous_bleed_timer = 0	// they only bleed for as many seconds as force damage was applied to them
	var/blood_timer_mod = 0.25		// tweak to change the amount of seconds a mob will bleed

	var/simple_default_language = LANGUAGE_TCB
	universal_speak = TRUE // since most mobs verbalize sounds, this is the better option, just set this to false on mobs that don't make noise

	var/list/speak = list()
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	///A list of sounds that this animal will randomly play, lazy list
	var/list/emote_sounds
	var/sound_time = TRUE

	var/turns_per_move = 1
	var/turns_since_move = 0
	universal_speak = 0		//No, just no.
	var/meat_amount = 0
	var/meat_type
	var/stop_thinking = FALSE // prevents them from doing any AI stuff whatsoever
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1	// Does the mob wander around when idle?
	var/wanders_diagonally = FALSE // does the mob move diagonally when wandering?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.
	var/atom/movement_target = null//Thing we're moving towards
	var/turns_since_scan = 0

	//Interaction
	var/list/organ_names = list("chest")
	var/response_help   = "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm   = "hurts"
	var/harm_intent_damage = 3 //The maximum amount of damage this mob can take from simple unarmed attacks that don't have damage values, like punches

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0

	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/min_oxy = 5
	var/max_oxy = 0					//Leaving something at 0 means it's off - has no maximum
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/min_h2 = 0
	var/max_h2 = 5
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	var/speed = 0 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster

	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/armor_penetration = 0
	var/attack_flags = 0
	var/attacktext = "attacked"
	var/attack_sound = /singleton/sound_category/swing_hit_sound
	var/friendly = "nuzzles"
	var/environment_smash = 0
	var/resistance		  = 0	// Damage reduction
	var/resist_mod = 1 // a multiplier for the chance the animal has to break out

	//Null rod stuff
	var/supernatural = 0
	var/purge = 0


	//Hunger/feeding vars
	var/hunger_enabled = 1//If set to 0, a creature ignores hunger
	max_nutrition = 50
	var/metabolic_factor = 1//A multiplier on how fast nutrition is lost. used to tweak the rates on a per-animal basis
	var/nutrition_step = 0.2 //nutrition lost per tick and per step, calculated from mob_size, 0.2 is a fallback
	var/bite_factor = 0.4
	var/digest_factor = 0.2 //A multiplier on how quickly reagents are digested
	var/stomach_size_mult = 5
	var/list/forbidden_foods = list()	//Foods this animal should never eat

	//Seeking/Moving behaviour vars
	var/min_scan_interval = 1//Minimum and maximum number of procs between a scan
	var/max_scan_interval = 15
	var/scan_interval = 5//current scan interval, clamped between min and max
	//It gradually increases up to max when its left alone, to save performance

	var/seek_speed = 2//How many tiles per second the animal will move towards something
	var/seek_move_delay
	var/scan_range = 6//How far around the animal will look for something

	var/kitchen_tag = "animal" //Used for cooking with animals

	//brushing
	var/canbrush = FALSE //can we brush this beautiful creature?
	var/brush = /obj/item/haircomb //What can we brush it with? Use a rag for things with scales/carapaces/etc

	//Napping
	var/can_nap = 0
	var/icon_rest = null

	var/tameable = TRUE //if you can tame it, used by the dociler for now

	var/flying = FALSE //if they can fly, which stops them from falling down and allows z-space travel

	var/has_udder = FALSE
	var/datum/reagents/udder = null
	var/milk_type = /singleton/reagent/drink/milk

	var/list/butchering_products	//if anything else is created when butchering this creature, like bones and leather

	var/psi_pingable = TRUE

	var/armor_type = /datum/component/armor
	var/list/natural_armor //what armor animal has

	//for simple animals that reflect damage when attacked in melee
	var/return_damage_min
	var/return_damage_max

	var/dead_on_map = FALSE //if true, kills the mob when it spawns (it is for mapping)
	var/vehicle_version = null

/mob/living/simple_animal/proc/update_nutrition_stats()
	nutrition_step = mob_size * 0.03 * metabolic_factor
	bite_factor = mob_size * 0.3
	max_nutrition *= 1 + (nutrition_step*4)//Max nutrition scales faster than costs, so bigger creatures eat less often

/mob/living/simple_animal/Initialize()
	. = ..()
	seek_move_delay = (1 / seek_speed) * 10	//number of ds between moves
	turns_since_scan = rand(min_scan_interval, max_scan_interval)//Randomise this at the start so animals don't sync up
	health = maxHealth
	remove_verb(src, /mob/verb/observe)
	health = maxHealth
	if (mob_size)
		update_nutrition_stats()
		reagents = new/datum/reagents(stomach_size_mult*mob_size, src)
	else
		reagents = new/datum/reagents(20, src)
	nutrition = max_nutrition

	if(has_udder)
		udder = new(50)
		udder.my_atom = src

	if(LAZYLEN(natural_armor))
		AddComponent(armor_type, natural_armor)

	if(simple_default_language)
		add_language(simple_default_language)
		default_language = GLOB.all_languages[simple_default_language]

	if(dead_on_map)
		death()

/mob/living/simple_animal/Destroy()
	cut_overlay(blood_overlay)
	movement_target = null
	QDEL_NULL(udder)

	. = ..()
	GC_TEMPORARY_HARDDEL

/mob/living/simple_animal/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != DEAD && hunger_enabled)
			src.adjustNutritionLoss(nutrition_step)

/mob/living/simple_animal/Released()
	//These will cause mobs to immediately do things when released.
	scan_interval = min_scan_interval
	turns_since_move = turns_per_move
	..()

/mob/living/simple_animal/revive(reset_to_roundstart)
	. = ..()
	blood_amount = initial(blood_amount)
	bleeding = FALSE

/mob/living/simple_animal/LateLogin()
	if(src && src.client)
		src.client.screen = null
	..()

/mob/living/simple_animal/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if (stat == DEAD)
		. += "<span class='danger'>It looks dead.</span>"
	if (health < maxHealth * 0.5)
		. += "<span class='danger'>It looks badly wounded.</span>"
	else if (health < maxHealth)
		. += "<span class='warning'>It looks wounded.</span>"

/mob/living/simple_animal/can_name(var/mob/living/M)
	if(named)
		to_chat(M, SPAN_NOTICE("\The [src] already has a name!"))
		return FALSE
	if(stat == DEAD)
		to_chat(M, SPAN_WARNING("You can't name a corpse."))
		return FALSE
	return TRUE

/mob/living/simple_animal/Life()
	..()
	life_tick++
	if (stat == DEAD)
		return 0
	//Health
	updatehealth()

	if(health > maxHealth)
		health = maxHealth

	handle_blood()
	handle_stunned()
	handle_weakened()
	handle_paralysed()
	update_canmove()
	handle_supernatural()
	process_food()

	//Movement
	turns_since_move++

	//Atmos
	var/atmos_suitable = TRUE

	if(isturf(loc))
		var/turf/T = loc

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)
			if (abs(Environment.temperature - bodytemperature) > 40)
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy && Environment.gas[GAS_OXYGEN] < min_oxy)
				atmos_suitable = FALSE
			else if(max_oxy && Environment.gas[GAS_OXYGEN] > max_oxy)
				atmos_suitable = FALSE
			else if(min_tox && Environment.gas[GAS_PHORON] < min_tox)
				atmos_suitable = FALSE
			else if(max_tox && Environment.gas[GAS_PHORON] > max_tox)
				atmos_suitable = FALSE
			else if(min_n2 && Environment.gas[GAS_NITROGEN] < min_n2)
				atmos_suitable = FALSE
			else if(max_n2 && Environment.gas[GAS_NITROGEN] > max_n2)
				atmos_suitable = FALSE
			else if(min_co2 && Environment.gas[GAS_CO2] < min_co2)
				atmos_suitable = FALSE
			else if(max_co2 && Environment.gas[GAS_CO2] > max_co2)
				atmos_suitable = FALSE
			else if(min_h2 && Environment.gas[GAS_HYDROGEN] < min_h2)
				atmos_suitable = FALSE
			else if(max_h2 && Environment.gas[GAS_HYDROGEN] > max_h2)
				atmos_suitable = FALSE

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		apply_damage(cold_damage_per_tick, DAMAGE_BURN, used_weapon = "Cold Temperature")
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		apply_damage(heat_damage_per_tick, DAMAGE_BURN, used_weapon = "High Temperature")
	else
		fire_alert = 0

	if(!atmos_suitable)
		apply_damage(unsuitable_atoms_damage, DAMAGE_OXY, used_weapon = "Atmosphere")

	if(has_udder)
		if(stat == CONSCIOUS)
			if(udder && prob(5))
				udder.add_reagent(milk_type, rand(5, 10))

	return 1

/mob/living/simple_animal/think()
	..()

	if(stop_thinking)
		return

	if(wander && !anchored && !stop_automated_movement)
		if(isturf(loc) && !resting && !buckled_to && canmove)
			if(!(pulledby && stop_automated_movement_when_pulled))
				step_rand(src)

	//Speaking
	if(speak_chance && rand(0,200) < speak_chance)
		if(LAZYLEN(speak))
			if(LAZYLEN(emote_hear) || LAZYLEN(emote_see))
				var/length = speak.len
				if(emote_hear && emote_hear.len)
					length += emote_hear.len
				if(emote_see && emote_see.len)
					length += emote_see.len
				var/randomValue = rand(1,length)
				if(randomValue <= speak.len)
					say(pick(speak))
				else
					randomValue -= speak.len
					if(emote_see && randomValue <= emote_see.len)
						visible_emote("[pick(emote_see)].",0)
					else
						audible_emote("[pick(emote_hear)].",0)
			else
				say(pick(speak))
		else
			if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				visible_emote("[pick(emote_see)].",0)
			if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
				audible_emote("[pick(emote_hear)].",0)
			if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				var/length = emote_hear.len + emote_see.len
				var/pick = rand(1,length)
				if(pick <= emote_see.len)
					visible_emote("[pick(emote_see)].",0)
				else
					audible_emote("[pick(emote_hear)].",0)
		speak_audio()

	if (can_nap)
		if (resting)
			if (prob(1))
				fall_asleep()
		else
			if (!stat || prob(0.5))
				wake_up()

	if(nutrition < max_nutrition / 3 && isturf(loc))	//If we're hungry enough (and not being held/in a bag), we'll check our tile for food.
		handle_eating()

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/proc/handle_blood(var/force_reset = FALSE)
	if(!blood_overlay_icon)
		return

	if(blood_amount <= 0 && stat != DEAD)
		death()

	var/current_blood_state = blood_state
	var/blood_mod = health / maxHealth
	if(blood_mod > 0.9)
		blood_state = BLOOD_NONE
	else if(blood_mod >= 0.7)
		blood_state = BLOOD_LIGHT
	else if(blood_mod >= 0.4)
		blood_state = BLOOD_MEDIUM
	else
		blood_state = BLOOD_HEAVY

	if(bleeding)
		switch(blood_state)
			if(BLOOD_LIGHT)
				blood_splatter(src, null, FALSE, sourceless_color = blood_type)
				blood_amount--
			if(BLOOD_MEDIUM)
				blood_splatter(src, null, TRUE, sourceless_color = blood_type)
				blood_amount -= 2
			if(BLOOD_HEAVY)
				blood_splatter(src, null, TRUE, sourceless_color = blood_type)
				blood_amount -= 3

	if(force_reset || current_blood_state != blood_state)
		if(blood_overlay)
			cut_overlay(blood_overlay)
		if(blood_state == BLOOD_NONE)
			return
		var/blood_overlay_name = get_blood_overlay_name()
		var/image/I = image(blood_overlay_icon, src, "[blood_overlay_name]-[blood_state]")
		I.color = blood_type
		I.blend_mode = BLEND_INSET_OVERLAY
		blood_overlay = I
		add_overlay(blood_overlay)

/mob/living/simple_animal/proc/get_blood_overlay_name()
	return "blood_overlay"

/mob/living/simple_animal/proc/handle_eating()
	var/list/food_choices = list()
	for(var/obj/item/reagent_containers/food/snacks/S in get_turf(src))
		if(locate(S) in forbidden_foods)
			continue
		food_choices += S
	if(food_choices.len) //Only when sufficiently hungry
		UnarmedAttack(pick(food_choices))

//Simple reagent processing for simple animals
//This allows animals to digest food, and only food
//Most drugs, poisons etc, are designed to work on carbons and affect many values a simple animal doesnt have
/mob/living/simple_animal/proc/process_food()
	if (hunger_enabled)
		if (nutrition)
			adjustNutritionLoss(nutrition_step)//Bigger animals get hungry faster
		else
			if (prob(3))
				to_chat(src, "You feel hungry...")


		if (!reagents || !reagents.total_volume)
			return

		for(var/_current in reagents.reagent_volumes)
			var/singleton/reagent/current = GET_SINGLETON(_current)
			var/removed = min(current.metabolism*digest_factor, REAGENT_VOLUME(reagents, _current))
			if (_current == /singleton/reagent/nutriment)//If its food, it feeds us
				var/singleton/reagent/nutriment/N = current
				adjustNutritionLoss(-removed*N.nutriment_factor)
				var/heal_amount = removed*N.regen_factor
				if (getBruteLoss() > 0)
					var/n = min(heal_amount, getBruteLoss())
					adjustBruteLoss(-n)
					heal_amount -= n
				if (getFireLoss() && heal_amount)
					var/n = min(heal_amount, getFireLoss())
					adjustFireLoss(-n)
					heal_amount -= n
				updatehealth()
			current.remove_self(removed, reagents)//If its not food, it just does nothing. no fancy effects

/mob/living/simple_animal/can_eat()
	if (!hunger_enabled || nutrition > max_nutrition * 0.9)
		return 0//full

	else if ((nutrition > max_nutrition * 0.8) || health < maxHealth)
		return 1//content

	else return 2//hungry

/mob/living/simple_animal/gib()
	..(icon_gib, 1)

/mob/living/simple_animal/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)

//This is called when an animal 'speaks'. It does nothing here, but descendants should override it to add audio
/mob/living/simple_animal/proc/speak_audio()
	if(LAZYLEN(emote_sounds))
		make_noise(TRUE)
	return

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	var/can_ghosts_hear = client ? GHOSTS_ALL_HEAR : ONLY_GHOSTS_IN_VIEW
	custom_emote(VISIBLE_MESSAGE, act_desc, can_ghosts_hear)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	var/can_ghosts_hear = client ? GHOSTS_ALL_HEAR : ONLY_GHOSTS_IN_VIEW
	custom_emote(AUDIBLE_MESSAGE, act_desc, can_ghosts_hear)

/mob/living/simple_animal/proc/handle_attack_by(var/mob/M)
	return

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()
	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("<b>\The [M]</b> [response_help] \the [src].")
				poke()

		if(I_DISARM)
			M.visible_message("<b>\The [M]</b> [response_disarm] \the [src]")
			M.do_attack_animation(src)
			poke(1)
			handle_attack_by(M)
			//TODO: Push the mob away or something

		if(I_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return

			if (!attempt_grab(M))
				return

			var/obj/item/grab/G = new /obj/item/grab(M, M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = WEAKREF(M)

			M.visible_message(SPAN_WARNING("\The [M] has grabbed \the [src] passively!"))
			M.do_attack_animation(src)
			poke(1)
			handle_attack_by(M)

		if(I_HURT)
			unarmed_harm_attack(M)
			handle_attack_by(M)

	return

/mob/living/simple_animal/proc/unarmed_harm_attack(var/mob/living/carbon/human/user)
	if(istype(user))
		var/datum/unarmed_attack/attack = user.get_unarmed_attack(src)
		if(!attack)
			simple_harm_attack(user)
			return
		attack.show_attack_simple(user, src, pick(organ_names))
		var/actual_damage = attack.get_unarmed_damage(src, user) //Punch and kick no longer have get_unarmed_damage due to how humanmob combat works. If we have none, we'll apply a small random amount.
		if(!actual_damage)
			actual_damage = harm_intent_damage ? rand(1, harm_intent_damage) : 0
		apply_damage(actual_damage, attack.damage_type)
		user.do_attack_animation(src, FIST_ATTACK_ANIMATION)
		return
	simple_harm_attack(user)

/mob/living/simple_animal/proc/simple_harm_attack(var/mob/living/user)
	apply_damage(harm_intent_damage, damage_type, used_weapon = "Attack by [user.name]")
	user.visible_message(SPAN_WARNING("<b>\The [user]</b> [response_harm] \the [src]!"), SPAN_WARNING("You [response_harm] \the [src]!"))
	user.do_attack_animation(src, FIST_ATTACK_ANIMATION)
	poke(TRUE)

/mob/living/simple_animal/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/saddle) && vehicle_version && (stat != DEAD))
		var/obj/vehicle/V = new vehicle_version (get_turf(src))
		V.health = health
		V.maxhealth = maxHealth
		to_chat(user, SPAN_WARNING("You place \the [attacking_item] on the \the [src]."))
		user.drop_from_inventory(attacking_item)
		attacking_item.forceMove(get_turf(src))
		qdel(attacking_item)
		qdel(src)

	if(istype(attacking_item, /obj/item/reagent_containers/glass/rag)) //You can't milk an udder with a rag.
		attacked_with_item(attacking_item, user)
		return
	if(has_udder)
		var/obj/item/reagent_containers/glass/G = attacking_item
		if(stat == CONSCIOUS && istype(G) && G.is_open_container())
			if(udder.total_volume <= 0)
				to_chat(user, SPAN_WARNING("The udder is dry."))
				return
			if(G.reagents.total_volume >= G.volume)
				to_chat(user, SPAN_WARNING("The [attacking_item] is full."))
				return
			user.visible_message("<b>\The [user]</b> milks \the [src] using \the [attacking_item].")
			udder.trans_type_to(G, milk_type, rand(5, 10))
			return

	if(istype(attacking_item, /obj/item/reagent_containers) || istype(attacking_item, /obj/item/stack/medical) || istype(attacking_item,/obj/item/gripper/))
		..()
		poke()

	else if(istype(attacking_item, brush) && canbrush) //Brushing animals
		visible_message("<b>\The [user]</b> gently brushes \the [src] with \the [attacking_item].")
		if(prob(15) && !istype(src, /mob/living/simple_animal/hostile)) //Aggressive animals don't purr before biting your face off.
			visible_message("<b>[capitalize_first_letters(src.name)]</b> [speak_emote.len ? pick(speak_emote) : "rumbles"].") //purring
		return

	else if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(attacking_item, /obj/item/material/knife) || istype(attacking_item, /obj/item/material/kitchen/utensil/knife)|| istype(attacking_item, /obj/item/material/hatchet))
			harvest(user)
	else
		attacked_with_item(attacking_item, user)

//TODO: refactor mob attackby(), attacked_by(), and friends.
/mob/living/simple_animal/proc/attacked_with_item(obj/item/O, mob/user, var/proximity)
	if(istype(O, /obj/item/trap/animal) || istype(O, /obj/item/gun))
		O.attack(src, user)
		return TRUE
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(O, /obj/item/glass_jar))
		return FALSE
	if(!O.force)
		visible_message(SPAN_NOTICE("<b>\The [user]</b> gently taps \the [src] with \the [O]."))
		poke()
		return FALSE

	if(O.force > resistance)
		var/damage = O.force
		if (O.damtype == DAMAGE_PAIN)
			damage = 0
		if(supernatural && istype(O,/obj/item/nullrod))
			damage *= 2
			purge = 3

		apply_damage(damage, O.damtype, used_weapon = "[O.name]")
		poke(1)
	else
		to_chat(user, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		poke()

	visible_message(SPAN_DANGER("\The [src] has been attacked with \the [O] by \the [user]."))
	if(O.hitsound)
		playsound(loc, O.hitsound, O.get_clamped_volume(), 1, -1)
	user.do_attack_animation(src, O)
	handle_attack_by(user)
	return TRUE

/mob/living/simple_animal/hitby(atom/movable/AM, speed)
	. = ..()
	if(ismob(AM.thrower))
		handle_attack_by(AM.thrower)

/mob/living/simple_animal/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(ismob(P.firer))
		handle_attack_by(P.firer)

/mob/living/simple_animal/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, blocked, used_weapon, damage_flags = 0, armor_pen, silent = FALSE)
	. = ..()
	handle_bleeding_timer(damage)
	handle_blood()

/mob/living/simple_animal/proc/handle_bleeding_timer(var/damage_inflicted)
	if(QDELETED(src)) // robotic mobs explode before this runs
		return
	if(!blood_overlay_icon) // no blood, don't bother
		return
	if(damage_inflicted <= 0) // just to be safe
		return
	if(!bleeding || previous_bleed_timer <= damage_inflicted)
		bleeding = TRUE
		previous_bleed_timer = damage_inflicted
		addtimer(CALLBACK(src, PROC_REF(stop_bleeding)), (damage_inflicted SECONDS) * blood_timer_mod, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/simple_animal/proc/stop_bleeding()
	bleeding = FALSE

/mob/living/simple_animal/heal_organ_damage(var/brute, var/burn)
	. = ..()
	handle_blood()

/mob/living/simple_animal/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	if (!nutrition)
		tally += 4

	return tally + GLOB.config.animal_delay

/mob/living/simple_animal/cat/proc/handle_movement_target()
	//if our target is neither inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target = null
		stop_automated_movement = 0
	//if we have no target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target = null
		stop_automated_movement = 0

	if(movement_target)
		stop_automated_movement = 1
		SSmove_manager.move_to(src, movement_target, 0, seek_move_delay)

/mob/living/simple_animal/get_status_tab_items()
	. = ..()

	if(show_stat_health)
		. += "Health: [round((health / maxHealth) * 100)]%"
		. += "Nutrition: [nutrition]/[max_nutrition]"

/mob/living/simple_animal/updatehealth()
	..()
	if (health <= 0 && (stat != DEAD))
		death()

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!")
	SSmove_manager.stop_looping(src)
	movement_target = null
	density = FALSE
	if (isopenturf(loc))
		ADD_FALLING_ATOM(src)
	. = ..(gibbed, deathmessage)
	update_icon()

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		flash_act()

	var/damage
	switch (severity)
		if (1.0)
			damage = 500

		if (2.0)
			damage = 120

		if(3.0)
			damage = 30

	apply_damage(damage, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_EXPLODE)

/mob/living/simple_animal/proc/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat)
			return (0)
	if (istype(target_mob, /obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	if(istype(target_mob, /obj/machinery/porta_turret/))
		var/obj/machinery/porta_turret/T = target_mob
		if(T.health > 0)
			return (0)
	if(istype(target_mob, /obj/effect/energy_field))
		return (0)
	return 1

/mob/living/simple_animal/proc/make_noise(var/make_sound = TRUE)
	set name = "Make Sound"
	set category = "Abilities"

	if(stat || !make_sound) //Can't make noise if there's no noise or if you're unconscious/dead
		return

	if(usr && !sound_time)
		to_chat(usr, SPAN_WARNING("Ability on cooldown 2 seconds."))
		return

	var/sound_to_play = LAZYPICK(emote_sounds, FALSE)
	if(sound_to_play)
		playsound(src, sound_to_play, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

	if(client)
		sound_time = FALSE
		addtimer(CALLBACK(src, PROC_REF(reset_sound_time)), 2 SECONDS)

/mob/living/simple_animal/verb/change_name()
	set name = "Name Animal"
	set desc = "Rename an animal."
	set category = "IC"
	set src in view(1)

	var/mob/living/carbon/M = usr
	if(!istype(M))
		to_chat(usr, SPAN_WARNING("You aren't allowed to rename \the [src]."))
		return

	if(can_name(M))
		var/input = sanitizeSafe(input("What do you want to name \the [src]?","Choose a name") as null|text, MAX_NAME_LEN)
		if(!input)
			return

		//check for adjacent and dead in case something happened while naming.
		if(in_range(M,src) && (stat != DEAD))
			to_chat(M, SPAN_NOTICE("You rename \the [src] to [input]."))
			name = "\proper [input]"
			real_name = input
			named = TRUE
			do_nickname(M) //This is for commanded mobs who can have a short name, like guard dogs

//This is for commanded mobs who can have a short name, like guard dogs. Does nothing for other mobs for now
/mob/living/simple_animal/proc/do_nickname(var/mob/living/M)


/mob/living/simple_animal/proc/reset_sound_time()
	sound_time = TRUE

/mob/living/simple_animal/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	if(speak_emote.len)
		verb = pick(speak_emote)

	if(LAZYLEN(emote_sounds))
		var/sound_chance = TRUE
		if(client) // we do not want people who assume direct control to spam
			sound_chance = prob(50)
		make_noise(sound_chance)

	var/can_ghosts_hear = client ? GHOSTS_ALL_HEAR : ONLY_GHOSTS_IN_VIEW
	..(message, speaking, verb, ghost_hearing = can_ghosts_hear)

/mob/living/simple_animal/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount*0.75))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			new meat_type(get_turf(src))

		if(butchering_products)
			for(var/path in butchering_products)
				var/number = butchering_products[path]
				for(var/i in 1 to number)
					new path(get_turf(src))

		if(issmall(src))
			user.visible_message("<b>\The [user]</b> chops up \the [src]!")
			var/obj/effect/decal/cleanable/blood/splatter/S = new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			S.basecolor = blood_type
			S.update_icon()
			qdel(src)
		else
			user.visible_message("<b>\The [user]</b> butchers \the [src] messily!")
			gib()

//For picking up small animals
/mob/living/simple_animal/MouseDrop(atom/over_object)
	if (holder_type)//we need a defined holder type in order for picking up to work
		var/mob/living/carbon/H = over_object
		if(!istype(H) || !Adjacent(H))
			return ..()

		get_scooped(H, usr)
		return
	return ..()


//I wanted to call this proc alert but it already exists.
//Basically makes the mob pay attention to the world, resets sleep timers, awakens it from a sleeping state sometimes
/mob/living/simple_animal/proc/poke(var/force_wake = 0)
	if (stat != DEAD)
		scan_interval = min_scan_interval
		if (force_wake || (!client && prob(30)))
			wake_up()

//Puts the mob to sleep
/mob/living/simple_animal/proc/fall_asleep()
	if (stat != DEAD)
		resting = 1
		set_stat(UNCONSCIOUS)
		canmove = 0
		wander = 0
		SSmove_manager.stop_looping(src)
		movement_target = null
		update_icon()

//Wakes the mob up from sleeping
/mob/living/simple_animal/proc/wake_up()
	if (stat != DEAD)
		set_stat(CONSCIOUS)
		resting = 0
		canmove = 1
		wander = 1
		update_icon()

/mob/living/simple_animal/update_icon()
	if (stat == DEAD)
		icon_state = icon_dead
	else if ((stat == UNCONSCIOUS || resting) && icon_rest)
		icon_state = icon_rest
	else if (icon_living)
		icon_state = icon_living

/mob/living/simple_animal/lay_down()
	set name = "Rest"
	set category = "Abilities"

	if (resting)
		wake_up()
	else
		fall_asleep()

	to_chat(src, SPAN_NOTICE("You are now [resting ? "resting" : "getting up"]."))

	update_icon()

//Todo: add snowflakey shit to it.
/mob/living/simple_animal/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null, var/tesla_shock = 0, var/ground_zero)
	apply_damage(shock_damage, DAMAGE_BURN)
	playsound(loc, /singleton/sound_category/spark_sound, 50, 1, -1)
	spark(loc, 5, GLOB.alldirs)
	visible_message(SPAN_WARNING("\The [src] was shocked by \the [source]!"), SPAN_WARNING("You are shocked by \the [source]!"), SPAN_WARNING("You hear an electrical crack!"))


/mob/living/simple_animal/can_fall()
	if (stat != DEAD && flying)
		return FALSE

	return ..()

/mob/living/simple_animal/can_ztravel()
	if (stat != DEAD && flying)
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/CanAvoidGravity()
	if (stat != DEAD && flying)
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/emp_act(severity)
	. = ..()

	if(!isSynthetic())
		return

	switch(severity)
		if(EMP_HEAVY)
			adjustFireLoss(rand(20, 25))
		if(EMP_LIGHT)
			adjustFireLoss(rand(10, 15))

/mob/living/simple_animal/get_digestion_product()
	return /singleton/reagent/nutriment

/mob/living/simple_animal/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone, var/damage)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if(P.damage_type == DAMAGE_BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/effect/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				B.icon_state = pick("dir_splatter_1","dir_splatter_2")
				B.basecolor = blood_type
				var/scale = min(1, round(mob_size / MOB_TINY, 0.1))
				var/matrix/M = new()
				B.transform = M.Scale(scale)
				B.update_icon()

/mob/living/simple_animal/get_resist_power()
	return resist_mod


/mob/living/simple_animal/get_gibs_type()
	if(isSynthetic())
		return /obj/effect/gibspawner/robot
	else
		return /obj/effect/gibspawner/generic

/mob/living/simple_animal/set_respawn_time()
	set_death_time(ANIMAL, world.time)

/mob/living/simple_animal/get_organ_name_from_zone(var/def_zone)
	return pick(organ_names)

/mob/living/simple_animal/is_anti_materiel_vulnerable()
	if(isSynthetic())
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/proc/reflect_unarmed_damage(var/mob/living/carbon/human/attacker, var/damage_type, var/description)
	if(attacker.a_intent == I_HURT)
		var/hand_hurtie
		if(attacker.hand)
			hand_hurtie = BP_L_HAND
		else
			hand_hurtie = BP_R_HAND
		attacker.apply_damage(rand(return_damage_min, return_damage_max), damage_type, hand_hurtie, used_weapon = description)
		if(rand(25))
			to_chat(attacker, SPAN_WARNING("Your attack has no obvious effect on \the [src]'s [description]!"))

/mob/living/simple_animal/get_speech_bubble_state_modifier()
	return isSynthetic() ? "machine" : "rough"


#undef BLOOD_NONE
#undef BLOOD_LIGHT
#undef BLOOD_MEDIUM
#undef BLOOD_HEAVY
