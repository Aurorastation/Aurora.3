//generic procs copied from obj/effect/alien
/obj/effect/spider
	name = "web"
	desc = "it's stringy and sticky"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	density = 0
	var/health = 15

//similar to weeds, but only barfed out by nurses manually
/obj/effect/spider/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(5))
				qdel(src)
	return

/obj/effect/spider/attackby(var/obj/item/W, var/mob/user)
	visible_message("<span class='warning'>[src] has been [LAZYPICK(W.attack_verb, "attacked")] with [W][(user ? " by [user]." : ".")]</span>")

	var/damage = W.force / 4.0

	if(W.iswelder())
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

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

/obj/effect/spider/stickyweb/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider) || istype(mover,/mob/living/simple_animal/hostile/spider_queen))
		return 1
	else if(istype(mover, /mob/living))
		if(prob(50))
			to_chat(mover, "<span class='warning'>You get stuck in \the [src] for a moment.</span>")
			return 0
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return 1

/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life"
	icon_state = "eggs"
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
	amount_grown += rand(0,2)

	var/obj/item/organ/external/O = null
	if(isorgan(loc))
		O = loc

	if(amount_grown >= 100)
		var/num = rand(6,24)

		for(var/i=0, i<num, i++)
			var/spiderling = new /obj/effect/spider/spiderling(src.loc, src, 0.75)
			if(O)
				O.implants += spiderling
		qdel(src)
	else if (O && O.owner && prob(1))
		if(world.time > last_itch + 30 SECONDS)
			last_itch = world.time
			to_chat(O.owner, "<span class='notice'>Your [O.name] itches.</span>")

/obj/effect/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
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

/obj/effect/spider/spiderling/Initialize(var/mapload, var/atom/parent, var/new_rate = 1, var/list/spawns = typesof(/mob/living/simple_animal/hostile/giant_spider))
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
	return ..()

/obj/effect/spider/spiderling/Collide(atom/user)
	if(istype(user, /obj/structure/table))
		forceMove(user.loc)
	else
		..()

/obj/effect/spider/spiderling/proc/die()
	visible_message("<span class='alert'>\The [src] dies!</span>")
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
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
				/*if(prob(50))
					src.visible_message("<B>[src] scrambles into the ventillation ducts!</B>")*/

				spawn(rand(20,60))
					loc = exit_vent
					var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
					spawn(travel_time)

						if(!exit_vent || exit_vent.welded)
							loc = entry_vent
							entry_vent = null
							return

						if(prob(50))
							visible_message("<span class='notice'>You hear something squeezing through the ventilation ducts.</span>", range = 2)
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
			walk_to(src, target_atom, 5)
			if(prob(25))
				src.visible_message(span("notice", "\the [src] skitters[pick(" away"," around","")]."))
	else if(prob(5))
		//vent crawl!
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
			if(!v.welded)
				entry_vent = v
				walk_to(src, entry_vent, 5)
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
				O.owner.apply_damage(1, TOX, O.limb_name)
				if(world.time > last_itch + 30 SECONDS)
					last_itch = world.time
					O.owner.visible_message(
						"<span class='warning'>You think you see something moving around in \the [O.owner]'s [O.name].</span>",
						"<span class='warning'>You [prob(25) ? "see" : "feel"] something large move around in your [O.name]!</span>")
			else if (prob(1))
				if(world.time > last_itch + 30 SECONDS)
					last_itch = world.time
					to_chat(O.owner, "<span class='notice'>You feel something large move around in your [O.name]!</span>")

	else if(prob(1))
		src.visible_message("<span class='notice'>\The [src] skitters.</span>")

	if (amount_grown > -1)
		amount_grown += (rand(0, 1) * growth_rate)

/obj/effect/spider/spiderling/attack_hand(mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	if(prob(20))
		visible_message(SPAN_WARNING("\The [user] tries to stomp on \the [src], but misses!"))
		var/list/nearby = oview(2, src)
		if(length(nearby))
			walk_to(src, pick(nearby), 2)
			return
	visible_message(SPAN_WARNING("\The [user] stomps \the [src] dead!"))
	die()

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
			"<span class='danger'>A group of [src] burst out of [O.owner]'s [O]!</span>",
			"<span class='danger'>A group of [src] burst out of your [O]!</span>")
		O.owner.emote("scream")
	else
		O.visible_message("<span class='danger'>A group of [src] burst out of \the [O]!</span>")

	var/target_loc = O.owner ? O.owner.loc : O.loc

	// Swarm all of the spiders out so we can gib the limb.
	for (var/obj/effect/spider/spiderling/S in O.implants)
		O.implants -= S
		S.forceMove(target_loc)

	// if owner, dismember the shit out of it.
	if (O.owner)
		O.droplimb(0, DROPLIMB_BLUNT)
	else
		O.visible_message("<span class='danger'>\The [O] explodes into a pile of gore!</span>")
		gibs(target_loc)
		qdel(O)

/obj/effect/decal/cleanable/spiderling_remains
	name = "spiderling remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"

/obj/effect/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky spider web"
	icon_state = "cocoon1"
	health = 60

/obj/effect/spider/cocoon/Initialize()
	. = ..()

	icon_state = pick("cocoon1","cocoon2","cocoon3")

/obj/effect/spider/cocoon/Destroy()
	src.visible_message("<span class='warning'>\The [src] splits open.</span>")
	for(var/atom/movable/A in contents)
		A.forceMove(src.loc)
	return ..()
