// Tier 1

/mob/living/simple_animal/slime/purple
	desc = "This slime is rather toxic to handle, as it is poisonous."
	color = "#CC23FF"
	slime_color = "purple"
	coretype = /obj/item/slime_extract/purple
	reagent_injected = "toxin"

	description_info = "This slime spreads a toxin when it attacks.  A biosuit or other thick armor can protect from the toxic attack."

	slime_mutation = list(
			/mob/living/simple_animal/slime/dark_purple,
			/mob/living/simple_animal/slime/dark_blue,
			/mob/living/simple_animal/slime/green,
			/mob/living/simple_animal/slime
		)


/mob/living/simple_animal/slime/orange
	desc = "This slime is known to be flammable and can ignite enemies."
	color = "#FFA723"
	slime_color = "orange"
	coretype = /obj/item/slime_extract/orange

	description_info = "Attacks from this slime can ignite you.  A firesuit can protect from the burning attacks of this slime."

	slime_mutation = list(
			/mob/living/simple_animal/slime/dark_purple,
			/mob/living/simple_animal/slime/yellow,
			/mob/living/simple_animal/slime/red,
			/mob/living/simple_animal/slime
		)

/mob/living/simple_animal/slime/orange/post_attack(mob/living/L, intent)
	if(intent != I_HELP)
		L.adjust_fire_stacks(1)
		if(prob(25))
			L.IgniteMob()
	..()

/mob/living/simple_animal/slime/blue
	desc = "This slime produces 'cryotoxin' and uses it against their foes.  Very deadly to other slimes."
	color = "#19FFFF"
	slime_color = "blue"
	coretype = /obj/item/slime_extract/blue
	reagent_injected = "cryotoxin"

	description_info = "Attacks from this slime can chill you.  A biosuit or other thick armor can protect from the chilling attack."

	slime_mutation = list(
			/mob/living/simple_animal/slime/dark_blue,
			/mob/living/simple_animal/slime/silver,
			/mob/living/simple_animal/slime/pink,
			/mob/living/simple_animal/slime
		)


/mob/living/simple_animal/slime/metal
	desc = "This slime is a lot more resilient than the others, due to having a metamorphic metallic and sloped surface."
	color = "#5F5F5F"
	slime_color = "metal"
	shiny = 1
	coretype = /obj/item/slime_extract/metal

	description_info = "This slime is a lot more durable and tough to damage than the others."

	resistance = 10 // Sloped armor is strong.
	maxHealth = 250
	maxHealth_adult = 350

	slime_mutation = list(
			/mob/living/simple_animal/slime/silver,
			/mob/living/simple_animal/slime/yellow,
			/mob/living/simple_animal/slime/gold,
			/mob/living/simple_animal/slime
		)

// Tier 2

/mob/living/simple_animal/slime/yellow
	desc = "This slime is very conductive, and is known to use electricity as a means of defense moreso than usual for slimes."
	color = "#FFF423"
	slime_color = "yellow"
	coretype = /obj/item/slime_extract/yellow

	ranged = 1
	shoot_range = 3
	firing_lines = 1
	projectiletype = /obj/item/projectile/beam/lightning/slime
	projectilesound = 'sound/weapons/gauss_shoot.ogg' // Closest thing to a 'thunderstrike' sound we have.
	glows = TRUE

	description_info = "This slime will fire lightning attacks at enemies if they are at range, and generate electricity \
	for their stun attack faster than usual.  Insulative or reflective armor can protect from the lightning."

	slime_mutation = list(
			/mob/living/simple_animal/slime/bluespace,
			/mob/living/simple_animal/slime/bluespace,
			/mob/living/simple_animal/slime/metal,
			/mob/living/simple_animal/slime/orange
		)

/mob/living/simple_animal/slime/yellow/handle_regular_status_updates()
	if(stat == CONSCIOUS)
		if(prob(25))
			power_charge = between(0, power_charge + 1, 10)
	..()

/obj/item/projectile/beam/lightning/slime
	power = 15

/mob/living/simple_animal/slime/yellow/ClosestDistance() // Needed or else they won't eat monkeys outside of melee range.
	if(target_mob && ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		if(istype(H.species, /datum/species/monkey))
			return 1
	return ..()


/mob/living/simple_animal/slime/dark_purple
	desc = "This slime produces ever-coveted phoron.  Risky to handle but very much worth it."
	color = "#CC23FF"
	slime_color = "dark purple"
	coretype = /obj/item/slime_extract/dark_purple
	reagent_injected = "phoron"

	description_info = "This slime applies phoron to enemies it attacks.  A biosuit or other thick armor can protect from the toxic attack.  \
	If hit with a burning attack, it will erupt in flames."

	slime_mutation = list(
			/mob/living/simple_animal/slime/purple,
			/mob/living/simple_animal/slime/orange,
			/mob/living/simple_animal/slime/ruby,
			/mob/living/simple_animal/slime/ruby
		)

/mob/living/simple_animal/slime/dark_purple/proc/ignite()
	visible_message("<span class='danger'>\The [src] erupts in an inferno!</span>")
	for(var/turf/simulated/target_turf in view(2, src))
		target_turf.assume_gas("phoron", 30, 1500+T0C)
		spawn(0)
			target_turf.hotspot_expose(1500+T0C, 400)
	qdel(src)

/mob/living/simple_animal/slime/dark_purple/ex_act(severity)
	log_and_message_admins("[src] ignited due to a chain reaction with an explosion.")
	ignite()

/mob/living/simple_animal/slime/dark_purple/fire_act(datum/gas_mixture/air, temperature, volume)
	log_and_message_admins("[src] ignited due to exposure to fire.")
	ignite()

/mob/living/simple_animal/slime/dark_purple/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(P.damage_type && P.damage_type == BURN && P.damage) // Most bullets won't trigger the explosion, as a mercy towards Security.
		log_and_message_admins("[src] ignited due to bring hit by a burning projectile[P.firer ? " by [key_name(P.firer)]" : ""].")
		ignite()
	else
		..()

/mob/living/simple_animal/slime/dark_purple/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W) && W.force && W.damtype == BURN)
		log_and_message_admins("[src] ignited due to being hit with a burning weapon ([W]) by [key_name(user)].")
		ignite()
	else
		..()




/mob/living/simple_animal/slime/dark_blue
	desc = "This slime makes other entities near it feel much colder, and is more resilient to the cold.  It tends to kill other slimes rather quickly."
	color = "#2398FF"
	glows = TRUE
	slime_color = "dark blue"
	coretype = /obj/item/slime_extract/dark_blue

	description_info = "This slime is immune to the cold, however water will still kill it.  A winter coat or other cold-resistant clothing can protect from the chilling aura."

	slime_mutation = list(
			/mob/living/simple_animal/slime/purple,
			/mob/living/simple_animal/slime/blue,
			/mob/living/simple_animal/slime/cerulean,
			/mob/living/simple_animal/slime/cerulean
		)

	minbodytemp = 0
	cold_damage_per_tick = 0

/mob/living/simple_animal/slime/dark_blue/Life()
	if(stat != DEAD)
		cold_aura()
	..()

/mob/living/simple_animal/slime/dark_blue/proc/cold_aura()
	for(var/mob/living/L in view(2, src))
		var/protection = L.get_cold_protection()

		if(protection < 1)
			var/cold_factor = abs(protection - 1)
			var/delta = -20
			delta *= cold_factor
			L.bodytemperature = max(50, delta)
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(-10 * 1000)


/mob/living/simple_animal/slime/silver
	desc = "This slime is shiny, and can deflect lasers or other energy weapons directed at it."
	color = "#AAAAAA"
	slime_color = "silver"
	coretype = /obj/item/slime_extract/silver
	shiny = TRUE

	description_info = "Tasers, including the slime version, are ineffective against this slime.  The slimebation still works."

	slime_mutation = list(
			/mob/living/simple_animal/slime/metal,
			/mob/living/simple_animal/slime/blue,
			/mob/living/simple_animal/slime/amber,
			/mob/living/simple_animal/slime/amber
		)

/mob/living/simple_animal/slime/silver/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(istype(P,/obj/item/projectile/beam) || istype(P, /obj/item/projectile/energy))
		visible_message("<span class='danger'>\The [src] reflects \the [P]!</span>")

		// Find a turf near or on the original location to bounce to
		var/new_x = P.starting.x + pick(0, 0, 0, -1, 1, -2, 2)
		var/new_y = P.starting.y + pick(0, 0, 0, -1, 1, -2, 2)
		var/turf/curloc = get_turf(src)

		// redirect the projectile
		P.redirect(new_x, new_y, curloc, src)
		return PROJECTILE_CONTINUE // complete projectile permutation
	else
		..()


// Tier 3

/mob/living/simple_animal/slime/bluespace
	desc = "Trapping this slime in a cell is generally futile, as it can teleport at will."
	color = null
	slime_color = "bluespace"
	icon_state_override = "bluespace"
	coretype = /obj/item/slime_extract/bluespace

	description_info = "This slime will teleport to attack something if it is within a range of seven tiles.  The teleport has a cooldown of five seconds."

	slime_mutation = list(
			/mob/living/simple_animal/slime/bluespace,
			/mob/living/simple_animal/slime/bluespace,
			/mob/living/simple_animal/slime/yellow,
			/mob/living/simple_animal/slime/yellow
		)

	spattack_prob = 100
	spattack_min_range = 3
	spattack_max_range = 7
	var/last_tele = null // Uses world.time
	var/tele_cooldown = 5 SECONDS

/mob/living/simple_animal/slime/bluespace/ClosestDistance() // Needed or the SA AI won't ever try to teleport.
	if(world.time > last_tele + tele_cooldown)
		return spattack_max_range - 1
	return ..()

/mob/living/simple_animal/slime/bluespace/SpecialAtkTarget()
	// Teleport attack.
	if(!target_mob)
		to_chat(src, "<span class='warning'>There's nothing to teleport to.</span>")
		return FALSE

	if(world.time < last_tele + tele_cooldown)
		to_chat(src, "<span class='warning'>You can't teleport right now, wait a few seconds.</span>")
		return FALSE

	var/list/nearby_things = range(1, target_mob)
	var/list/valid_turfs = list()

	// All this work to just go to a non-dense tile.
	for(var/turf/potential_turf in nearby_things)
		var/valid_turf = TRUE
		if(potential_turf.density)
			continue
		for(var/atom/movable/AM in potential_turf)
			if(AM.density)
				valid_turf = FALSE
		if(valid_turf)
			valid_turfs.Add(potential_turf)



	var/turf/T = get_turf(src)
	var/turf/target_turf = pick(valid_turfs)

	if(!target_turf)
		to_chat(src, "<span class='warning'>There wasn't an unoccupied spot to teleport to.</span>")
		return FALSE

	var/datum/effect/effect/system/spark_spread/s1 = new /datum/effect/effect/system/spark_spread
	s1.set_up(5, 1, T)
	var/datum/effect/effect/system/spark_spread/s2 = new /datum/effect/effect/system/spark_spread
	s2.set_up(5, 1, target_turf)


	T.visible_message("<span class='notice'>\The [src] vanishes!</span>")
	s1.start()

	forceMove(target_turf)
	playsound(target_turf, 'sound/effects/phasein.ogg', 50, 1)
	to_chat(src, "<span class='notice'>You teleport to \the [target_turf].</span>")

	target_turf.visible_message("<span class='warning'>\The [src] appears!</span>")
	s2.start()

	last_tele = world.time

	if(Adjacent(target_mob))
		PunchTarget()
	return TRUE

/mob/living/simple_animal/slime/ruby
	desc = "This slime has great physical strength."
	color = "#FF3333"
	slime_color = "ruby"
	shiny = TRUE
	glows = TRUE
	coretype = /obj/item/slime_extract/ruby

	description_info = "This slime is unnaturally stronger, allowing it to hit much harder, take less damage, and be stunned for less time."

	slime_mutation = list(
		/mob/living/simple_animal/slime/dark_purple,
		/mob/living/simple_animal/slime/dark_purple,
		/mob/living/simple_animal/slime/ruby,
		/mob/living/simple_animal/slime/ruby
	)

/mob/living/simple_animal/slime/ruby/New()
	..()
	add_modifier(/datum/modifier/slime_strength, null, src) // Slime is always swole.


/mob/living/simple_animal/slime/amber
	desc = "This slime seems to be an expert in the culinary arts, as they create their own food to share with others.  \
	They would probably be very important to other slimes, if the other colors didn't try to kill them."
	color = "#FFBB00"
	slime_color = "amber"
	shiny = TRUE
	glows = TRUE
	coretype = /obj/item/slime_extract/amber

	description_info = "This slime feeds nearby entities passively while it is alive.  This can cause uncontrollable \
	slime growth and reproduction if not kept in check."

	slime_mutation = list(
		/mob/living/simple_animal/slime/silver,
		/mob/living/simple_animal/slime/silver,
		/mob/living/simple_animal/slime/amber,
		/mob/living/simple_animal/slime/amber
	)

/mob/living/simple_animal/slime/amber/Life()
	if(stat != DEAD)
		feed_aura()
	..()

/mob/living/simple_animal/slime/amber/proc/feed_aura()
	for(var/mob/living/L in view(2, src))
		if(L == src) // Don't feed themselves, or it is impossible to stop infinite slimes without killing all of the ambers.
			continue
		if(isslime(L))
			var/mob/living/simple_animal/slime/S = L
			S.adjust_nutrition(rand(15, 25))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.isSynthetic())
				continue
			H.nutrition = between(0, H.nutrition + rand(15, 25), 600)



/mob/living/simple_animal/slime/cerulean
	desc = "This slime is generally superior in a wide range of attributes, compared to the common slime.  The jack of all trades, but master of none."
	color = "#4F7EAA"
	slime_color = "cerulean"
	coretype = /obj/item/slime_extract/cerulean

	// Less than the specialized slimes, but higher than the rest.
	maxHealth = 200
	maxHealth_adult = 250

	melee_damage_lower = 10
	melee_damage_upper = 30

	move_to_delay = 3



	slime_mutation = list(
		/mob/living/simple_animal/slime/dark_blue,
		/mob/living/simple_animal/slime/dark_blue,
		/mob/living/simple_animal/slime/cerulean,
		/mob/living/simple_animal/slime/cerulean
	)

// Tier 4

/mob/living/simple_animal/slime/red
	desc = "This slime is full of energy, and very aggressive.  'The red ones go faster.' seems to apply here."
	color = "#FF3333"
	slime_color = "red"
	coretype = /obj/item/slime_extract/red
	move_to_delay = 3 // The red ones go faster.

	description_info = "This slime is faster than the others.  Attempting to discipline this slime will always cause it to go berserk."

	slime_mutation = list(
			/mob/living/simple_animal/slime/red,
			/mob/living/simple_animal/slime/oil,
			/mob/living/simple_animal/slime/oil,
			/mob/living/simple_animal/slime/orange
		)


/mob/living/simple_animal/slime/red/adjust_discipline(amount)
	if(amount > 0)
		if(!rabid)
			enrage() // How dare you try to control the red slime.
			say("Grrr...!")


/mob/living/simple_animal/slime/green
	desc = "This slime is radioactive."
	color = "#14FF20"
	slime_color = "green"
	coretype = /obj/item/slime_extract/green
	glows = TRUE
	reagent_injected = "radium"
	var/rads = 25

	description_info = "This slime will irradiate anything nearby passively, and will inject radium on attack.  \
	A radsuit or other thick and radiation-hardened armor can protect from this.  It will only radiate while alive."

	slime_mutation = list(
			/mob/living/simple_animal/slime/purple,
			/mob/living/simple_animal/slime/green,
			/mob/living/simple_animal/slime/emerald,
			/mob/living/simple_animal/slime/emerald
		)

/mob/living/simple_animal/slime/green/Life()
	if(stat != DEAD)
		irradiate()
	..()

/mob/living/simple_animal/slime/green/proc/irradiate()
	radiation_repository.radiate(src, rads)


/mob/living/simple_animal/slime/pink
	desc = "This slime has regenerative properties."
	color = "#FF0080"
	slime_color = "pink"
	coretype = /obj/item/slime_extract/pink
	glows = TRUE

	description_info = "This slime will passively heal nearby entities within two tiles, including itself.  It will only do this while alive."

	slime_mutation = list(
			/mob/living/simple_animal/slime/blue,
			/mob/living/simple_animal/slime/light_pink,
			/mob/living/simple_animal/slime/light_pink,
			/mob/living/simple_animal/slime/pink
		)

/mob/living/simple_animal/slime/pink/Life()
	if(stat != DEAD)
		heal_aura()
	..()

/mob/living/simple_animal/slime/pink/proc/heal_aura()
	for(var/mob/living/L in view(src, 2))
		if(L.stat == DEAD || L == target_mob)
			continue
		L.add_modifier(/datum/modifier/slime_heal, 5 SECONDS, src)

/datum/modifier/slime_heal
	name = "slime mending"
	desc = "You feel somewhat gooy."
	mob_overlay_state = "pink_sparkles"

	on_created_text = "<span class='warning'>Twinkling spores of goo surround you.  It makes you feel healthier.</span>"
	on_expired_text = "<span class='notice'>The spores of goo have faded, although you feel much healthier than before.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/slime_heal/tick()
	if(holder.stat == DEAD) // Required or else simple animals become immortal.
		expire()
	holder.adjustBruteLoss(-2)
	holder.adjustFireLoss(-2)
	holder.adjustToxLoss(-2)
	holder.adjustOxyLoss(-2)
	holder.adjustCloneLoss(-1)



/mob/living/simple_animal/slime/gold
	desc = "This slime absorbs energy, and cannot be stunned by normal means."
	color = "#EEAA00"
	shiny = TRUE
	slime_color = "gold"
	coretype = /obj/item/slime_extract/gold
	description_info = "This slime is immune to the slimebaton and taser, and will actually charge the slime, however it will still discipline the slime."

	slime_mutation = list(
			/mob/living/simple_animal/slime/metal,
			/mob/living/simple_animal/slime/gold,
			/mob/living/simple_animal/slime/sapphire,
			/mob/living/simple_animal/slime/sapphire
		)

/mob/living/simple_animal/slime/gold/Weaken(amount)
	power_charge = between(0, power_charge + amount, 10)
	return

/mob/living/simple_animal/slime/gold/Stun(amount)
	power_charge = between(0, power_charge + amount, 10)
	return

/mob/living/simple_animal/slime/gold/get_description_interaction() // So it doesn't say to use a baton on them.
	return list()


// Tier 5

/mob/living/simple_animal/slime/oil
	desc = "This slime is explosive and volatile.  Smoking near it is probably a bad idea."
	color = "#333333"
	slime_color = "oil"
	shiny = TRUE
	coretype = /obj/item/slime_extract/oil

	description_info = "If this slime suffers damage from a fire or heat based source, or if it is caught inside \
	an explosion, it will explode.  Rabid oil slimes will charge at enemies, then suicide-bomb themselves.  \
	Bomb suits can protect from the explosion."

	slime_mutation = list(
		/mob/living/simple_animal/slime/oil,
		/mob/living/simple_animal/slime/oil,
		/mob/living/simple_animal/slime/red,
		/mob/living/simple_animal/slime/red
	)

/mob/living/simple_animal/slime/oil/proc/explode()
	if(stat != DEAD)
	//	explosion(src.loc, 1, 2, 4)
		explosion(src.loc, 0, 2, 4) // A bit weaker since the suicide charger tended to gib the poor sod being targeted.
		if(src) // Delete ourselves if the explosion didn't do it.
			qdel(src)

/mob/living/simple_animal/slime/oil/post_attack(var/mob/living/L, var/intent = I_HURT)
	if(!rabid)
		return ..()
	if(intent == I_HURT || intent == I_GRAB)
		say(pick("Sacrifice...!", "Sssss...", "Boom...!"))
		sleep(2 SECOND)
		log_and_message_admins("[src] has suicide-bombed themselves while trying to kill \the [L].")
		explode()

/mob/living/simple_animal/slime/oil/ex_act(severity)
	log_and_message_admins("[src] exploded due to a chain reaction with another explosion.")
	explode()

/mob/living/simple_animal/slime/oil/fire_act(datum/gas_mixture/air, temperature, volume)
	log_and_message_admins("[src] exploded due to exposure to fire.")
	explode()

/mob/living/simple_animal/slime/oil/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(P.damage_type && P.damage_type == BURN && P.damage) // Most bullets won't trigger the explosion, as a mercy towards Security.
		log_and_message_admins("[src] exploded due to bring hit by a burning projectile[P.firer ? " by [key_name(P.firer)]" : ""].")
		explode()
	else
		..()

/mob/living/simple_animal/slime/oil/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W) && W.force && W.damtype == BURN)
		log_and_message_admins("[src] exploded due to being hit with a burning weapon ([W]) by [key_name(user)].")
		explode()
	else
		..()


/mob/living/simple_animal/slime/sapphire
	desc = "This slime seems a bit brighter than the rest, both figuratively and literally."
	color = "#2398FF"
	slime_color = "sapphire"
	shiny = TRUE
	glows = TRUE
	coretype = /obj/item/slime_extract/sapphire

	optimal_combat = TRUE	// Lift combat AI restrictions to look smarter.
	run_at_them = FALSE		// Use fancy A* pathing.
	astar_adjacent_proc = /turf/proc/TurfsWithAccess // Normal slimes don't care about cardinals (because BYOND) so smart slimes shouldn't as well.
	move_to_delay = 3		// A* chasing is slightly slower in terms of movement speed than regular pathing so reducing this hopefully makes up for that.

	description_info = "This slime uses more robust tactics when fighting and won't hold back, so it is dangerous to be alone \
	with one if hostile, and especially dangerous if they outnumber you."

	slime_mutation = list(
		/mob/living/simple_animal/slime/sapphire,
		/mob/living/simple_animal/slime/sapphire,
		/mob/living/simple_animal/slime/gold,
		/mob/living/simple_animal/slime/gold
	)

/mob/living/simple_animal/slime/emerald
	desc = "This slime is faster than usual, even more so than the red slimes."
	color = "#22FF22"
	shiny = TRUE
	glows = TRUE
	slime_color = "emerald"
	coretype = /obj/item/slime_extract/emerald

	description_info = "This slime will make everything around it, and itself, faster for a few seconds, if close by."
	move_to_delay = 2

	slime_mutation = list(
		/mob/living/simple_animal/slime/green,
		/mob/living/simple_animal/slime/green,
		/mob/living/simple_animal/slime/emerald,
		/mob/living/simple_animal/slime/emerald
	)

/mob/living/simple_animal/slime/emerald/Life()
	if(stat != DEAD)
		zoom_aura()
	..()

/mob/living/simple_animal/slime/emerald/proc/zoom_aura()
	for(var/mob/living/L in view(src, 2))
		if(L.stat == DEAD || L == target_mob)
			continue
		L.add_modifier(/datum/modifier/technomancer/haste, 5 SECONDS, src)

/mob/living/simple_animal/slime/light_pink
	desc = "This slime seems a lot more peaceful than the others."
	color = "#FF8888"
	slime_color = "light_pink"
	coretype = /obj/item/slime_extract/light_pink

	description_info = "This slime is effectively always disciplined initially."
	obedience = 5
	discipline = 5

	slime_mutation = list(
		/mob/living/simple_animal/slime/green,
		/mob/living/simple_animal/slime/green,
		/mob/living/simple_animal/slime/emerald,
		/mob/living/simple_animal/slime/emerald
	)

// Special
/mob/living/simple_animal/slime/rainbow
	desc = "This slime changes colors constantly."
	color = null // Only slime subtype that uses a different icon_state.
	slime_color = "rainbow"
	coretype = /obj/item/slime_extract/rainbow
	icon_state_override = "rainbow"

	description_info = "This slime is considered to be the same color as all other slime colors at the same time for the purposes of \
	other slimes being friendly to them, and therefore will never be harmed by another slime.  \
	Attacking this slime will provoke the wrath of all slimes within range."

	slime_mutation = list(
		/mob/living/simple_animal/slime/rainbow,
		/mob/living/simple_animal/slime/rainbow,
		/mob/living/simple_animal/slime/rainbow,
		/mob/living/simple_animal/slime/rainbow
	)

/mob/living/simple_animal/slime/rainbow/New()
	unify()
	..()

// The RD's pet slime.
/mob/living/simple_animal/slime/rainbow/kendrick
	name = "Kendrick"
	desc = "The Research Director's pet slime.  It shifts colors constantly."

/mob/living/simple_animal/slime/rainbow/kendrick/New()
	pacify()
	..()