/mob/living/carbon/slime
	name = "baby slime"
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "grey baby slime"
	pass_flags = PASSTABLE
	var/is_adult = 0
	speak_emote = list("chirps")
	mob_size = 4
	composition_reagent = "slimejelly"
	layer = 5
	maxHealth = 150
	health = 150
	gender = NEUTER

	update_icon = 0
	nutrition = 700
	max_nutrition = 1200

	see_in_dark = 8
	update_slimes = 0

	// canstun and canweaken don't affect slimes because they ignore stun and weakened variables
	// for the sake of cleanliness, though, here they are.
	status_flags = CANPARALYSE|CANPUSH

	var/cores = 1 			 // the number of /obj/item/slime_extract's the slime has left inside
	var/mutation_chance = 30 // Chance of mutating, should be between 25 and 35

	var/powerlevel = 0	 // 0-10 controls how much electricity they are generating
	var/amount_grown = 0 // controls how long the slime has been overfed, if 5, grows or reproduces

	var/number = 0 // Used to understand when someone is talking to it

	var/mob/living/victim = null // the person the slime is currently feeding on
	var/mob/living/target = null // AI variable - tells the slime to hunt this down
	var/mob/living/leader = null // AI variable - tells the slime to follow this person

	var/content = FALSE		// Don't attack humanoids while content, this gives xenobiologists the time to move slimes post-splitting
	var/attacked = 0		// Determines if it's been attacked recently. Can be any number, is a cooloff-ish variable
	var/rabid = 0			// If set to 1, the slime will attack and eat anything it comes in contact with
	var/holding_still = 0	// AI variable, cooloff-ish for how long it's going to stay in one place
	var/target_patience = 0 // AI variable, cooloff-ish for how long it's going to follow its target

	var/list/friends = list() // A list of friends; they are not considered targets for feeding; passed down after splitting

	var/list/speech_buffer = list() // Last phrase said near it and person who said it

	var/mood = "" // To show its face

	var/last_AI						// The last time the AI did something, to ensure we aren't stuck in AIless limbo
	var/AIproc = 0					// If it's 0, we need to launch an AI proc
	var/Atkcool = 0					// Attack cooldown
	var/SStun = 0					// NPC stun variable. Used to calm them down when they are attacked while feeding, or they will immediately re-attach
	var/discipline = 0				// If a slime has been hit with a freeze gun, or wrestled/attacked off a human, they become disciplined and don't attack anymore for a while. The part about freeze gun is a lie
	var/hurt_temperature = T0C-50	// Slime keeps taking damage when its bodytemperature is below this
	var/die_temperature = 50		// Slime dies instantly when its bodytemperature is below this

	var/co2overloadtime = null
	var/temperature_resistance = T0C+75

	///////////TIME FOR SUBSPECIES

	var/colour = "grey"
	var/coretype = /obj/item/slime_extract/grey
	var/list/slime_mutation[4]

	var/core_removal_stage = 0 //For removing cores.
	var/toxloss = 0
	var/datum/reagents/metabolism/ingested

/mob/living/carbon/slime/get_ingested_reagents()
	return ingested

/mob/living/carbon/slime/Initialize(mapload, colour = "grey")
	. = ..()

	verbs += /mob/living/proc/ventcrawl

	src.colour = colour
	number = rand(1, 1000)
	name = "[colour] [is_adult ? "adult" : "baby"] slime ([number])"
	real_name = name
	if(is_adult)
		mob_size = 6
	slime_mutation = mutation_table(colour)
	mutation_chance = rand(25, 35)
	var/sanitizedcolour = replacetext(colour, " ", "")
	coretype = text2path("/obj/item/slime_extract/[sanitizedcolour]")
	last_AI = world.time
	regenerate_icons()

/mob/living/carbon/slime/purple/Initialize(mapload, colour = "purple")
	..()

/mob/living/carbon/slime/metal/Initialize(mapload, colour = "metal")
	..()

/mob/living/carbon/slime/orange/Initialize(mapload, colour = "orange")
	..()

/mob/living/carbon/slime/blue/Initialize(mapload, colour = "blue")
	..()

/mob/living/carbon/slime/dark_blue/Initialize(mapload, colour = "dark blue")
	..()

/mob/living/carbon/slime/dark_purple/Initialize(mapload, colour = "dark purple")
	..()

/mob/living/carbon/slime/yellow/Initialize(mapload, colour = "yellow")
	..()

/mob/living/carbon/slime/silver/Initialize(mapload, colour = "silver")
	..()

/mob/living/carbon/slime/pink/Initialize(mapload, colour = "pink")
	..()

/mob/living/carbon/slime/red/Initialize(mapload, colour = "red")
	..()

/mob/living/carbon/slime/gold/Initialize(mapload, colour = "gold")
	..()

/mob/living/carbon/slime/green/Initialize(mapload, colour = "green")
	..()

/mob/living/carbon/slime/oil/Initialize(mapload, colour = "oil")
	..()

/mob/living/carbon/slime/adamantine/Initialize(mapload, colour = "adamantine")
	..()

/mob/living/carbon/slime/black/Initialize(mapload, colour = "black")
	..()

/mob/living/carbon/slime/getToxLoss()
	return toxloss

/mob/living/carbon/slime/adjustToxLoss(var/amount)
	toxloss = Clamp(toxloss + amount, 0, maxHealth)

/mob/living/carbon/slime/setToxLoss(var/amount)
	adjustToxLoss(amount-getToxLoss())

/mob/living/carbon/slime/movement_delay()
	if(bodytemperature >= 330.23) // 135 F
		return -1	// slimes become supercharged at high temperatures

	var/tally = 0

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 30)
		tally += (health_deficiency / 25)

	if(bodytemperature < 183.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	if(reagents)
		if(reagents.has_reagent("hyperzine")) // Hyperzine slows slimes down
			tally *= 2
		if(reagents.has_reagent("frostoil")) // Frostoil also makes them move VEEERRYYYYY slow
			tally *= 5

	if(health <= 0) // if damaged, the slime moves twice as slow
		tally *= 2

	return tally + config.slime_delay

/mob/living/carbon/slime/proc/reset_atkcooldown()
	Atkcool = FALSE

/mob/living/carbon/slime/Collide(atom/movable/AM as mob|obj, yes)
	if(now_pushing)
		return

	now_pushing = TRUE

	if(isobj(AM) && !client && powerlevel > 0)
		var/probab = 10
		switch(powerlevel)
			if(1 to 2)
				probab = 20
			if(3 to 4)
				probab = 30
			if(5 to 6)
				probab = 40
			if(7 to 8)
				probab = 60
			if(9)
				probab = 70
			if(10)
				probab = 95
		if(prob(probab))
			if(istype(AM, /obj/structure/window) || istype(AM, /obj/structure/grille))
				if(nutrition <= get_hunger_nutrition() && !Atkcool)
					if(is_adult || prob(5))
						UnarmedAttack(AM)
						Atkcool = TRUE
						addtimer(CALLBACK(src, .proc/reset_atkcooldown), 45)

	if(ismob(AM))
		var/mob/tmob = AM

		if(is_adult)
			if(istype(tmob, /mob/living/carbon/human))
				if(prob(90))
					now_pushing = FALSE
					return
		else
			if(istype(tmob, /mob/living/carbon/human))
				now_pushing = FALSE
				return

	now_pushing = FALSE

	. = ..()

/mob/living/carbon/slime/Allow_Spacemove()
	return TRUE

/mob/living/carbon/slime/Stat()
	..()

	statpanel("Status")
	stat(null, "Health: [round((health / maxHealth) * 100)]%")
	stat(null, "Intent: [a_intent]")

	if(client.statpanel == "Status")
		stat(null, "Nutrition: [nutrition]/[get_max_nutrition()]")
		if(amount_grown >= 5)
			if(is_adult)
				stat(null, "You can reproduce!")
			else
				stat(null, "You can evolve!")

		stat(null,"Power Level: [powerlevel]")

/mob/living/carbon/slime/adjustFireLoss(amount)
	..(-abs(amount)) // Heals them
	return

/mob/living/carbon/slime/bullet_act(var/obj/item/projectile/Proj)
	attacked += 10
	..(Proj)
	return FALSE

/mob/living/carbon/slime/emp_act(severity)
	powerlevel = 0 // oh no, the power!
	..()

/mob/living/carbon/slime/ex_act(severity)
	..()

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if(1.0)
			qdel(src)
			return

		if(2.0)
			b_loss += 60
			f_loss += 60

		if(3.0)
			b_loss += 30

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()

/mob/living/carbon/slime/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/slime/attack_ui(slot)
	return

/mob/living/carbon/slime/attack_hand(mob/living/carbon/human/M as mob)
	..()

	if(victim)
		if(victim == M)
			if(prob(60))
				visible_message(span("warning", "[M] attempts to wrestle \the [name] off!"))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			else
				visible_message(span("warning", "[M] manages to wrestle \the [name] off!"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

				if(prob(90) && !client)
					discipline++

				SStun = TRUE
				spawn(rand(45,60))
					SStun = FALSE

				victim = null
				anchored = FALSE
				step_away(src,M)

			return

		else
			if(prob(30))
				visible_message(span("warning", "[M] attempts to wrestle \the [name] off of [victim]!"))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			else
				visible_message(span("warning", "[M] manages to wrestle \the [name] off of [victim]!"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

				if(prob(80) && !client)
					discipline++

					if(!is_adult)
						if(discipline)
							attacked = FALSE

				SStun = TRUE
				spawn(rand(55,65))
					SStun = FALSE

				victim = null
				anchored = FALSE
				step_away(src,M)

			return

	switch(M.a_intent)
		if(I_HELP)
			help_shake_act(M)

		if(I_GRAB)
			if(M == src || anchored)
				return
			var/obj/item/grab/G = new /obj/item/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()

			LAssailant = WEAKREF(M)

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(span("warning", "[M] has grabbed [src] passively!"))

		else

			var/damage = rand(1, 9)

			attacked += 10
			if(prob(90))
				if(HULK in M.mutations)
					damage += 5
					if(victim || target)
						victim = null
						target = null
						anchored = 0
						if(prob(80) && !client)
							discipline++
					spawn(0)
						step_away(src,M,15)
						sleep(3)
						step_away(src,M,15)

				playsound(loc, "punch", 25, 1, -1)
				visible_message(span("danger", "[M] has punched [src]!"), \
						span("danger", "[M] has punched [src]!"))

				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(span("danger", "[M] has attempted to punch [src]!"))
	return

/mob/living/carbon/slime/attackby(obj/item/W, mob/user)
	if(W.force > 0)
		attacked += 10
		if(prob(25))
			to_chat(user, span("danger", "[W] passes right through [src]!"))
			return
		if(discipline && prob(50)) // wow, buddy, why am I getting attacked??
			discipline = FALSE
	if(W.force >= 3)
		if(is_adult)
			if(prob(5 + round(W.force/2)))
				if(victim || target)
					if(prob(80) && !client)
						discipline++

					victim = null
					target = null
					anchored = FALSE

					SStun = TRUE
					spawn(rand(5,20))
						SStun = FALSE

					spawn(0)
						if(user)
							canmove = FALSE
							step_away(src, user)
							if(prob(25 + W.force))
								sleep(2)
								if(user)
									step_away(src, user)
								canmove = TRUE

		else
			if(prob(10 + W.force*2))
				if(victim || target)
					if(prob(80) && !client)
						discipline++
					if(discipline)
						attacked = FALSE
					SStun = TRUE
					spawn(rand(5,20))
						SStun = FALSE

					victim = null
					target = null
					anchored = FALSE

					spawn(0)
						if(user)
							canmove = FALSE
							step_away(src, user)
							if(prob(25 + W.force*4))
								sleep(2)
								if(user)
									step_away(src, user)
							canmove = TRUE
	..()

/mob/living/carbon/slime/restrained()
	return FALSE

/mob/living/carbon/slime/toggle_throw_mode()
	return

/mob/living/carbon/slime/proc/gain_nutrition(var/amount)
	if(prob(amount * 2)) // Gain around one level per 50 nutrition
		powerlevel++
		if(powerlevel > 10)
			powerlevel = 10
			adjustToxLoss(-10)
	nutrition += amount
	nutrition = min(nutrition, get_max_nutrition())

/mob/living/carbon/slime/proc/set_content(var/do_content)
	if(do_content)
		content = TRUE
		mood = HAPPY
	else
		content = FALSE