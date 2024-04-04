//generic procs copied from obj/effect/alien
/obj/effect/spider
	name = "web"
	desc = "It's stringy and sticky, eugh. Probably came from one of those greimorians..."
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_ICON
	var/health = 15

//similar to weeds, but only barfed out by nurses manually
/obj/effect/spider/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
		if(3.0)
			if(prob(5))
				qdel(src)
	return

/obj/effect/spider/attackby(obj/item/attacking_item, mob/user)
	visible_message(SPAN_WARNING("\The [src] has been [LAZYPICK(attacking_item.attack_verb, "attacked")] with [attacking_item][(user ? " by [user]." : ".")]"))
	var/damage = attacking_item.force / 4.0
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.use(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)
		return TRUE
	else
		user.do_attack_animation(src)
		playsound(loc, attacking_item.hitsound, 50, 1, -1)

	health -= damage
	healthcheck()

/obj/effect/spider/bullet_act(var/obj/item/projectile/Proj)
	..()
	health -= Proj.get_structure_damage()
	healthcheck()

/obj/effect/spider/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/effect/spider/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

/obj/effect/spider/stickyweb
	icon_state = "stickyweb1"

/obj/effect/spider/stickyweb/Initialize()
	. = ..()

	if(prob(50))
		icon_state = "stickyweb2"

	if(prob(75))
		var/image/web_overlay = image(icon, icon_state = "[initial(icon_state)]-overlay[pick(1, 2, 3)]", layer = ABOVE_HUMAN_LAYER)
		add_overlay(web_overlay)

/obj/effect/spider/stickyweb/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || height == 0)
		return TRUE
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider))
		return TRUE
	else if(istype(mover, /mob/living))
		if(prob(50))
			to_chat(mover, SPAN_WARNING("You get stuck in \the [src] for a moment."))
			return FALSE
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return TRUE

/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life."
	icon_state = "eggs"
	health = 10
	var/amount_grown = 0
	var/last_itch = 0

/obj/effect/spider/eggcluster/Initialize(var/mapload, var/atom/parent)
	. = ..(mapload)

	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSprocessing, src)

	get_light_and_color(parent)

/obj/effect/spider/eggcluster/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/O = loc
		O.implants -= src

	return ..()

/obj/effect/spider/eggcluster/process()
	amount_grown += rand(0, 2)

	var/obj/item/organ/external/O = null
	if(isorgan(loc))
		O = loc

	if(amount_grown >= 100)
		var/num = rand(6,24)

		for(var/i = 0, i < num, i++)
			var/spiderling = new /obj/effect/spider/spiderling(src.loc, src, 0.75)
			if(O)
				O.implants += spiderling
		qdel(src)
	else if (O && O.owner && prob(1))
		if(world.time > last_itch + 30 SECONDS)
			last_itch = world.time
			to_chat(O.owner, "<span class='notice'>Your [O.name] itches.</span>")

/obj/effect/spider/eggcluster/proc/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		var/obj/item/organ/external/O = loc
		if(istype(O) && O.owner)
			to_chat(O.owner, SPAN_WARNING("You feel something dissolve in your [O.name]..."))
		qdel(src)

/obj/effect/spider/spiderling
	name = "greimorian larva"
	desc = "A small, agile alien creature. It oozes some disgusting slime."
	desc_extended = "Greimorians are a species of arthropods whose evolutionary traits have made them an extremely dangerous invasive species.  \
	They originate from the Badlands planet Greima, once covered in crystalized phoron. A decaying orbit led to its combustion from proximity to its sun, and its dominant inhabitants \
	managed to survive in orbit. Countless years later, they prove to be a menace across the galaxy, having carried themselves within the hulls of Human vessels to spread wildly."
	icon_state = "spiderling"
	anchored = 0
	layer = 2.7
	health = 3
	var/last_itch = 0
	var/amount_grown = -1
	var/growth_rate = 1
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent
	var/travelling_in_vent = 0
	var/list/possible_offspring

/obj/effect/spider/spiderling/Initialize(var/mapload, var/atom/parent, var/new_rate = 1, var/list/spawns = list(/mob/living/simple_animal/hostile/giant_spider, /mob/living/simple_animal/hostile/giant_spider/nurse, /mob/living/simple_animal/hostile/giant_spider/emp, /mob/living/simple_animal/hostile/giant_spider/hunter, /mob/living/simple_animal/hostile/giant_spider/bombardier))
	. = ..(mapload)

	pixel_x = rand(6,-6)
	pixel_y = rand(6,-6)
	START_PROCESSING(SSprocessing, src)
	//50% chance to grow up
	if(prob(50))
		amount_grown = 1

	growth_rate = new_rate

	possible_offspring = spawns

	get_light_and_color(parent)

/obj/effect/spider/spiderling/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	entry_vent = null
	return ..()

/obj/effect/spider/spiderling/Collide(atom/user)
	if(istype(user, /obj/structure/table))
		forceMove(user.loc)
	else
		..()

/obj/effect/spider/spiderling/proc/die()
	visible_message(SPAN_WARNING("\The [src] dies!"))
	new /obj/effect/decal/cleanable/spiderling_remains(loc)
	qdel(src)

/obj/effect/spider/spiderling/healthcheck()
	if(health <= 0)
		die()

/obj/effect/spider/spiderling/process()
	if(travelling_in_vent)
		if(istype(src.loc, /turf))
			travelling_in_vent = 0
			entry_vent = null
	else if(entry_vent)
		if(get_dist(src, entry_vent) <= 1)
			if(entry_vent.network && entry_vent.network.normal_members.len)
				var/list/vents = list()
				for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in entry_vent.network.normal_members)
					vents.Add(temp_vent)
				if(!vents.len)
					entry_vent = null
					return
				var/obj/machinery/atmospherics/unary/vent_pump/exit_vent = pick(vents)

				spawn(rand(20,60))
					loc = exit_vent
					var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
					spawn(travel_time)

						if(!exit_vent || exit_vent.welded)
							loc = entry_vent
							entry_vent = null
							return

						if(prob(50))
							visible_message(SPAN_NOTICE("You hear something squeezing through the ventilation ducts."), range = 2)
						sleep(travel_time)

						if(!exit_vent || exit_vent.welded)
							loc = entry_vent
							entry_vent = null
							return
						loc = exit_vent.loc
						entry_vent = null
						var/area/new_area = get_area(loc)
						if(new_area)
							new_area.Entered(src)
			else
				entry_vent = null
	else if(prob(25) && isturf(loc))
		var/list/nearby = oview(5, src)
		if(nearby.len)
			var/target_atom = pick(nearby)
			SSmove_manager.move_to(src, target_atom, 0, 5)
			if(prob(25))
				src.visible_message(SPAN_NOTICE("\The [src] skitters[pick(" away"," around","")]."))
	else if(prob(5))
		//vent crawl!
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
			if(!v.welded)
				entry_vent = v
				SSmove_manager.move_to(src, entry_vent, 0, 5)
				break

	if(isturf(loc) && amount_grown >= 100)
		var/spawn_type = pick(possible_offspring)
		new spawn_type(src.loc, src)
		qdel(src)
	else if(isorgan(loc))
		var/obj/item/organ/external/O = loc
		if(amount_grown > 70)
			burst_out(O)
		if (O.owner)
			if(amount_grown > 40 && prob(1))
				O.owner.apply_damage(1, DAMAGE_TOXIN, O.limb_name)
				if(world.time > last_itch + 30 SECONDS)
					last_itch = world.time
					O.owner.visible_message(
						SPAN_WARNING("You think you see something moving around in \the [O.owner]'s [O.name]."),
						SPAN_WARNING("You [prob(25) ? "see" : "feel"] something large move around in your [O.name]!"))
			else if (prob(1))
				if(world.time > last_itch + 30 SECONDS)
					last_itch = world.time
					to_chat(O.owner, SPAN_WARNING("You feel something large move around in your [O.name]!"))

	else if(prob(1))
		src.visible_message(SPAN_NOTICE("\The [src] skitters."))

	if (amount_grown > -1)
		amount_grown += (rand(0, 1) * growth_rate)

/obj/effect/spider/spiderling/attack_hand(mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	if(prob(20))
		visible_message(SPAN_WARNING("\The [user] tries to stomp on \the [src], but misses!"))
		var/list/nearby = oview(2, src)
		if(length(nearby))
			SSmove_manager.move_to(src, pick(nearby), 0, 2)
			return
	visible_message(SPAN_WARNING("\The [user] stomps \the [src] dead!"))
	die()

/obj/effect/spider/spiderling/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(istype(attacking_item, /obj/item/newspaper))
		var/obj/item/newspaper/N = attacking_item
		if(N.rolled)
			die()
			return TRUE

/**
 * Makes the organ spew out all of the spiderlings it has. It's triggered at the point
 * of the first spiderling reaching 80% of more amount grown. This stops them from growing
 * to full size inside a human.
 *
 * The proc also drops the limb if it's on a human, or gibs it if it's on the floor. For
 * maximum drama, of course!
 *
 * @param	O The organ/external limb the src is located inside of.
 */
/obj/effect/spider/spiderling/proc/burst_out(obj/item/organ/external/O = src.loc)
	if (!istype(O))
		return

	if (O.owner)
		O.owner.visible_message(
			SPAN_DANGER("A group of [src] burst out of [O.owner]'s [O]!"),
			SPAN_DANGER("A group of [src] burst out of your [O]!"))
		O.owner.emote("scream")
	else
		O.visible_message(SPAN_DANGER("A group of [src] burst out of \the [O]!"))

	var/target_loc = O.owner ? O.owner.loc : O.loc

	// Swarm all of the spiders out so we can gib the limb.
	for (var/obj/effect/spider/spiderling/S in O.implants)
		O.implants -= S
		S.forceMove(target_loc)

	// if owner, dismember the shit out of it.
	if (O.owner)
		O.droplimb(0, DROPLIMB_BLUNT)
	else
		O.visible_message(SPAN_DANGER("\The [O] explodes into a pile of gore!"))
		gibs(target_loc)
		qdel(O)

/obj/effect/decal/cleanable/spiderling_remains
	name = "greimorian larva remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"

/obj/effect/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky greimorian web"
	icon_state = "cocoon1"
	health = 60

/obj/effect/spider/cocoon/Initialize()
	. = ..()

	icon_state = pick("cocoon1","cocoon2","cocoon3")

/obj/effect/spider/cocoon/Destroy()
	src.visible_message(SPAN_WARNING("\The [src] splits open."))
	for(var/atom/movable/A in contents)
		A.forceMove(src.loc)
	return ..()
