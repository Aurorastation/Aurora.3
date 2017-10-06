/mob/living/simple_animal/slime
	name = "baby slime"
	desc = "The most basic of slimes.  The grey slime has no remarkable qualities, however it remains one of the most useful colors for scientists."
	icon = 'icons/mob/slime2.dmi'
	icon_state = "grey baby slime"
	intelligence_level = SA_ANIMAL
	pass_flags = PASSTABLE
	var/shiny = FALSE // If true, will add a 'shiny' overlay.
	var/glows = FALSE // If true, will glow in the same color as the color var.
	var/icon_state_override = null // Used for special slime appearances like the rainbow slime.
	pass_flags = PASSTABLE

	speak_emote = list("chirps")

	maxHealth = 150
	var/maxHealth_adult = 200
	melee_damage_lower = 5
	melee_damage_upper = 25
	melee_miss_chance = 0
	gender = NEUTER

	// Atmos stuff.
	minbodytemp = T0C-30
	heat_damage_per_tick = 0
	cold_damage_per_tick = 40

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 0


	speak = list(
		"Blorp...",
		"Blop..."

		)
	emote_hear = list(

		)
	emote_see = list(
		"bounces",
		"jiggles",
		"sways"
		)

	hostile = 1
	retaliate = 1
	attack_same = 1
	cooperative = 1
	faction = "slime" // Slimes will help other slimes, provided they share the same color.

	color = "#CACACA"
	var/is_adult = FALSE
	var/cores = 1 // How many cores you get when placed in a Processor.
	var/power_charge = 0 // 0-10 controls how much electricity they are generating.  High numbers encourage the slime to stun someone with electricity.
	var/amount_grown = 0 // controls how long the slime has been overfed, if 10, grows or reproduces
	var/number = 0 // This is used to make the slime semi-unique for indentification.

	var/mob/living/victim = null // the person the slime is currently feeding on
	var/rabid = FALSE	// If true, will attack anyone and everyone.
	var/docile = FALSE	// Basically the opposite of above.  If true, will never harm anything and won't get hungry.
	var/discipline = 0	// Beating slimes makes them less likely to lash out.  In theory.
	var/resentment = 0	// 'Unjustified' beatings make this go up, and makes it more likely for abused slimes to go berserk.
	var/obedience = 0	// Conversely, 'justified' beatings make this go up, and makes discipline decay slowly, potentially making it not decay at all.
	var/unity = FALSE	// If true, slimes will consider other colors as their own.  Other slimes will see this slime as the same color as well.  A rainbow slime is required to get this.
	var/optimal_combat = FALSE // Used to dumb down the combat AI somewhat.  If true, the slime tends to be really dangerous to fight alone due to stunlocking.
	var/mood = ":3" // Icon to use to display 'mood'.
	var/obj/item/clothing/head/hat = null // The hat the slime may be wearing.

	var/slime_color = "grey"
	var/mutation_chance = 25 // Odds of spawning as a new color when reproducing.  Can be modified by certain xenobio products.  Carried across generations of slimes.
	var/coretype = /obj/item/slime_extract/grey
	// List of potential slime color mutations. This must have exactly four types.
	var/list/slime_mutation = list(
		/mob/living/simple_animal/slime/orange,
		/mob/living/simple_animal/slime/metal,
		/mob/living/simple_animal/slime/blue,
		/mob/living/simple_animal/slime/purple
	)

	var/reagent_injected = null // Some slimes inject reagents on attack.  This tells the game what reagent to use.
	var/injection_amount = 5 // This determines how much.

/mob/living/simple_animal/slime/New(var/location, var/start_as_adult = FALSE)
	verbs += /mob/living/proc/ventcrawl
	if(start_as_adult)
		make_adult()
	health = maxHealth
//	slime_mutation = mutation_table(slime_color)
	update_icon()
	number = rand(1, 1000)
	update_name()
	..(location)

/mob/living/simple_animal/slime/Destroy()
	if(hat)
		drop_hat()
	return ..()

/mob/living/simple_animal/slime/proc/make_adult()
	if(is_adult)
		return

	is_adult = TRUE
	melee_damage_lower = 20
	melee_damage_upper = 40
	maxHealth = maxHealth_adult
	amount_grown = 0
	update_icon()
	update_name()

/mob/living/simple_animal/slime/proc/update_name()
	if(docile) // Docile slimes are generally named, so we shouldn't mess with it.
		return
	name = "[slime_color] [is_adult ? "adult" : "baby"] slime ([number])"
	real_name = name

/mob/living/simple_animal/slime/update_icon()
	if(stat == DEAD)
		icon_state = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_adult ? "adult" : "baby"] dead"
		set_light(0)
	else
		if(incapacitated(INCAPACITATION_DISABLED))
			icon_state = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_adult ? "adult" : "baby"] dead"
		else
			icon_state = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_adult ? "adult" : "baby"][victim ? " eating":""]"

	overlays.Cut()
	if(stat != DEAD)
		var/image/I = image(icon, src, "slime light")
		I.appearance_flags = RESET_COLOR
		overlays += I

		if(shiny)
			I = image(icon, src, "slime shiny")
			I.appearance_flags = RESET_COLOR
			overlays += I

		I = image(icon, src, "aslime-[mood]")
		I.appearance_flags = RESET_COLOR
		overlays += I

		if(glows)
			set_light(3, 2, color)

	if(hat)
		var/hat_state = hat.item_state ? hat.item_state : hat.icon_state
		var/image/I = image('icons/mob/head.dmi', src, hat_state)
		I.pixel_y = -7 // Slimes are small.
		I.appearance_flags = RESET_COLOR
		overlays += I

	if(modifier_overlay) // Restore our modifier overlay.
		overlays += modifier_overlay

/mob/living/simple_animal/slime/proc/update_mood()
	var/old_mood = mood
	if(incapacitated(INCAPACITATION_DISABLED))
		mood = "sad"
	else if(rabid)
		mood = "angry"
	else if(target_mob)
		mood = "mischevous"
	else if(discipline)
		mood = "pout"
	else if(docile)
		mood = ":33"
	else
		mood = ":3"
	if(old_mood != mood)
		update_icon()

// Makes the slime very angry and dangerous.
/mob/living/simple_animal/slime/proc/enrage()
	if(docile)
		return
	rabid = TRUE
	update_mood()
	visible_message("<span class='danger'>\The [src] enrages!</span>")

// Makes the slime safe and harmless.
/mob/living/simple_animal/slime/proc/pacify()
	rabid = FALSE
	docile = TRUE
	hostile = FALSE
	retaliate = FALSE
	cooperative = FALSE

	// If for whatever reason the mob AI decides to try to attack something anyways.
	melee_damage_upper = 0
	melee_damage_lower = 0

	update_mood()

/mob/living/simple_animal/slime/proc/unify()
	unity = TRUE
	attack_same = FALSE

/mob/living/simple_animal/slime/examine(mob/user)
	..()
	if(hat)
		to_chat(user, "It is wearing \a [hat].")

	if(stat == DEAD)
		to_chat(user, "It appears to be dead.")
	else if(incapacitated(INCAPACITATION_DISABLED))
		to_chat(user, "It appears to be incapacitated.")
	else if(rabid)
		to_chat(user, "It seems very, very angry and upset.")
	else if(obedience >= 5)
		to_chat(user, "It looks rather obedient.")
	else if(discipline)
		to_chat(user, "It has been subjugated by force, at least for now.")
	else if(docile)
		to_chat(user, "It appears to have been pacified.")

/mob/living/simple_animal/slime/water_act(amount) // This is called if a slime enters a water tile.
	adjustBruteLoss(40 * amount)

/mob/living/simple_animal/slime/proc/adjust_discipline(amount, silent)
	if(amount > 0)
		if(!rabid)
			var/justified = is_justified_to_discipline()
			spawn(0)
				stop_consumption()
				LoseTarget()
			if(!silent)
				if(justified)
					say(pick("Fine...", "Okay...", "Sorry...", "I yield...", "Mercy..."))
				else
					say(pick("Why...?", "I don't understand...?", "Cruel...", "Stop...", "Nooo..."))
			if(justified)
				obedience++
			else
				if(prob(resentment * 20))
					enrage() // Pushed the slime too far.
					say(pick("Evil...", "Kill...", "Tyrant..."))
				resentment++ // Done after check so first time will never enrage.

	discipline = between(0, discipline + amount, 10)

/mob/living/simple_animal/slime/movement_delay()
	if(bodytemperature >= 330.23) // 135 F or 57.08 C
		return -1	// slimes become supercharged at high temperatures

	. = ..()

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 45)
		. += (health_deficiency / 25)

	if(bodytemperature < 183.222)
		. += (283.222 - bodytemperature) / 10 * 1.75

	. += config.slime_delay

/mob/living/simple_animal/slime/Process_Spacemove()
	return 2

/mob/living/simple_animal/slime/verb/evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		to_chat(src, "<span class='notice'>I must be conscious to do this...</span>")
		return

	if(docile)
		to_chat(src, "<span class='notice'>I have been pacified.  I cannot evolve...</span>")
		return

	if(!is_adult)
		if(amount_grown >= 10)
			make_adult()
		else
			to_chat(src, "<span class='notice'>I am not ready to evolve yet...</span>")
	else
		to_chat(src, "<span class='notice'>I have already evolved...</span>")

/mob/living/simple_animal/slime/verb/reproduce()
	set category = "Slime"
	set desc = "This will make you split into four Slimes."

	if(stat)
		to_chat(src, "<span class='notice'>I must be conscious to do this...</span>")
		return

	if(docile)
		to_chat(src, "<span class='notice'>I have been pacified.  I cannot reproduce...</span>")
		return

	if(is_adult)
		if(amount_grown >= 10)

			var/list/babies = list()
			for(var/i = 1 to 4)
				babies.Add(make_new_slime())

			var/mob/living/simple_animal/slime/new_slime = pick(babies)
			new_slime.universal_speak = universal_speak
			if(src.mind)
				src.mind.transfer_to(new_slime)
			else
				new_slime.key = src.key
			qdel(src)
		else
			to_chat(src, "<span class='notice'>I am not ready to reproduce yet...</span>")
	else
		to_chat(src, "<span class='notice'>I am not old enough to reproduce yet...</span>")

// Used for reproducing and dying.
/mob/living/simple_animal/slime/proc/make_new_slime()
	var/t = src.type
	if(prob(mutation_chance) && slime_mutation.len)
		t = slime_mutation[rand(1, slime_mutation.len)]
	var/mob/living/simple_animal/slime/baby = new t(loc)

	// Handle 'inheriting' from parent slime.
	baby.mutation_chance = mutation_chance
	baby.power_charge = round(power_charge / 4)
	baby.resentment = max(resentment - 1, 0)
	baby.discipline = max(discipline - 1, 0)
	baby.obedience = max(obedience - 1, 0)
	baby.unity = unity
	baby.faction = faction
	baby.friends = friends.Copy()
	if(rabid)
		baby.enrage()

	step_away(baby, src)
	return baby

/mob/living/simple_animal/slime/speech_bubble_appearance()
	return "slime"

// Called after they finish eatting someone.
/mob/living/simple_animal/slime/proc/befriend(var/mob/living/friend)
	if(!(friend in friends))
		friends |= friend
		say("[friend]... friend...")

/mob/living/simple_animal/slime/proc/can_command(var/mob/living/commander)
	if(rabid)
		return FALSE
	if(docile)
		return TRUE
	if(commander in friends)
		return TRUE
	if(faction == commander.faction)
		return TRUE
	if(discipline > resentment && obedience >= 5)
		return TRUE
	return FALSE

/mob/living/simple_animal/slime/proc/give_hat(var/obj/item/clothing/head/new_hat, var/mob/living/user)
	if(!istype(new_hat))
		to_chat(user, "<span class='warning'>\The [new_hat] isn't a hat.</span>")
		return
	if(hat)
		to_chat(user, "<span class='warning'>\The [src] is already wearing \a [hat].</span>")
		return
	else
		user.drop_item(new_hat)
		hat = new_hat
		new_hat.forceMove(src)
		to_chat(user, "<span class='notice'>You place \a [new_hat] on \the [src].  How adorable!</span>")
		update_icon()
		return

/mob/living/simple_animal/slime/proc/remove_hat(var/mob/living/user)
	if(!hat)
		to_chat(user, "<span class='warning'>\The [src] doesn't have a hat to remove.</span>")
	else
		hat.forceMove(get_turf(src))
		user.put_in_hands(hat)
		to_chat(user, "<span class='warning'>You take away \the [src]'s [hat.name].  How mean.</span>")
		hat = null
		update_icon()

/mob/living/simple_animal/slime/proc/drop_hat()
	if(!hat)
		return
	hat.forceMove(get_turf(src))
	hat = null
	update_icon()

// Checks if disciplining the slime would be 'justified' right now.
/mob/living/simple_animal/slime/proc/is_justified_to_discipline()
	if(rabid)
		return TRUE
	if(target_mob)
		if(ishuman(target_mob))
			var/mob/living/carbon/human/H = target_mob
			if(istype(H.species, /datum/species/monkey))
				return FALSE
		return TRUE
	return FALSE


/mob/living/simple_animal/slime/get_description_interaction()
	var/list/results = list()

	if(!stat)
		results += "[desc_panel_image("slimebaton")]to stun the slime, if it's being bad."

	results += ..()

	return results

/mob/living/simple_animal/slime/get_description_info()
	var/list/lines = list()
	var/intro_line = "Slimes are generally the test subjects of Xenobiology, with different colors having different properties.  \
	They can be extremely dangerous if not handled properly."
	lines.Add(intro_line)
	lines.Add(null) // To pad the line breaks.

	var/list/rewards = list()
	for(var/potential_color in slime_mutation)
		var/mob/living/simple_animal/slime/S = potential_color
		rewards.Add(initial(S.slime_color))
	var/reward_line = "This color of slime can mutate into [english_list(rewards)] colors, when it reproduces.  It will do so when it has eatten enough."
	lines.Add(reward_line)
	lines.Add(null)

	lines.Add(description_info)
	return lines.Join("\n")

