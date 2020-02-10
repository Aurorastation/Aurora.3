/mob/living/heavy_vehicle/handle_disabilities()
	return

/mob/living/heavy_vehicle/handle_status_effects()
	return

/mob/living/heavy_vehicle/Life()

	// Size offsets for large mechs.
	if(offset_x && pixel_x != offset_x)
		pixel_x = offset_x
	if(offset_y && pixel_y != offset_y)
		pixel_y = offset_y

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot.loc != src) // Admin jump or teleport/grab.
			if(pilot.client)
				pilot.client.screen -= hud_elements
				LAZYREMOVE(pilots, pilot)
				UNSETEMPTY(pilots)
		update_pilot_overlay()

	if(radio)
		radio.on = (head?.radio && head.radio.is_functional())

	if(camera)
		camera.status = (head?.camera && head.camera.is_functional())

	body.update_air(hatch_closed && use_air)

	if((client || LAZYLEN(pilots)) && get_cell())
		get_cell()?.drain_power(0, 0, calc_power_draw())

	updatehealth()
	if(health <= 0 && stat != DEAD)
		death()

	..()

	lying = 0 // Fuck off, carp.
	handle_vision()
	handle_hud_icons()

/mob/living/heavy_vehicle/get_cell()
	RETURN_TYPE(/obj/item/cell)
	return body.cell

/mob/living/heavy_vehicle/proc/calc_power_draw()
	var/total_draw = 0
	for(var/hardpoint in hardpoints)
		var/obj/item/mecha_equipment/I = hardpoints[hardpoint]
		if(!istype(I))
			continue
		total_draw += I.passive_power_use

	if(head && head.active_sensors)
		total_draw += head.power_use

	if(body)
		total_draw += body.power_use

	return total_draw

/mob/living/heavy_vehicle/handle_environment(var/datum/gas_mixture/environment)
	if(!environment) return
	//Mechs and vehicles in general can be assumed to just tend to whatever ambient temperature
	if(abs(environment.temperature - bodytemperature) > 10 )
		bodytemperature += ((environment.temperature - bodytemperature) / 3)

	if(environment.temperature >= T0C+1400) //A bit higher because I like to assume there's a difference between a mech and a wall
		apply_damage(damage = environment.temperature /5 , damagetype = BURN)
	//A possibility is to hook up interface icons here. But this works pretty well in my experience
		if(prob(5))
			visible_message("<span class='danger'>\The [src]'s hull bends and buckles under the intense heat!</span>")

/mob/living/heavy_vehicle/death(var/gibbed)

	// Salvage moves into the wreck unless we're exploding violently.
	var/obj/wreck = new wreckage_path(get_turf(src), src, gibbed)
	wreck.name = "wreckage of \the [name]"
	if(!gibbed)
		if(arms.loc != src)
			arms = null
		if(legs.loc != src)
			legs = null
		if(head.loc != src)
			head = null
		if(body.loc != src)
			body = null

	explosion(get_turf(loc), 0, 0, 1, 3)

	// Eject the pilot.
	if(LAZYLEN(pilots))
		hatch_locked = 0 // So they can get out.
		for(var/pilot in pilots)
			eject(pilot, silent=1)

	// Handle the rest of things.
	..(gibbed, (gibbed ? "explodes!" : "grinds to a halt before collapsing!"))
	if(!gibbed) qdel(src)

/mob/living/heavy_vehicle/gib()
	death(1)

	// Get a turf to play with.
	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	// Hurl our component pieces about.
	var/list/stuff_to_throw = list()
	for(var/obj/item/thing in list(arms, legs, head, body))
		if(thing) stuff_to_throw += thing
	for(var/hardpoint in hardpoints)
		if(hardpoints[hardpoint])
			var/obj/item/thing = hardpoints[hardpoint]
			thing.screen_loc = null
			stuff_to_throw += thing
	for(var/obj/item/thing in stuff_to_throw)
		thing.forceMove(T)
		thing.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(3,6),40)
	explosion(T, -1, 0, 2)
	qdel(src)
	return

/mob/living/heavy_vehicle/handle_status_effects()
	..()
	if(hallucination > 0)
		hallucination--
	else if(hallucination < 0)
		hallucination = 0

/mob/living/heavy_vehicle/handle_vision()
	if(head)
		sight = head.get_sight()
		see_invisible = head.get_invisible()
	if(body && (body.pilot_coverage < 100 || body.transparent_cabin))
		sight &= ~BLIND

/mob/living/heavy_vehicle/additional_sight_flags()
	return sight

/mob/living/heavy_vehicle/additional_see_invisible()
	return see_invisible