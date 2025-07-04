/obj/item/bluespace_neutralizer
	name = "bluespace neutralizer"
	desc = "A strange device, supposedly capable of pre-emptively shutting down bluespace portals."
	desc_info = "Click on it, or use it in-hand to activate it. Click on any portal-like structure to instantly close it. Stand near a bluespace rift while it's active to start the closing process."
	icon = 'icons/obj/item/neutralizer.dmi'
	icon_state = "neutralizer"
	contained_sprite = TRUE

	var/tethered = FALSE // it needs to tether with the portal before it can start zapping
	var/last_zap = 0
	var/active = FALSE

/obj/item/bluespace_neutralizer/update_icon()
	icon_state = "neutralizer[active ? "-a" : ""]"

/obj/item/bluespace_neutralizer/attack_self(mob/user)
	if(GLOB.vamp.current_antagonists.len || GLOB.revenants.revenant_rift || active)
		toggle(user)
	else
		to_chat(user, SPAN_WARNING("\The [src] doesn't detect any large bluespace rifts in the region."))
		return

/obj/item/bluespace_neutralizer/proc/toggle(var/mob/user)
	active = !active
	if(active)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	if(user)
		to_chat(user, SPAN_NOTICE("You turn \the [src] [active ? "on" : "off"]."))
	update_icon()

/obj/item/bluespace_neutralizer/process()
	if(active && GLOB.revenants.revenant_rift)
		var/turf/our_turf = get_turf(src)
		if(!(our_turf.z == GLOB.revenants.revenant_rift.z && get_dist(src, GLOB.revenants.revenant_rift) < 5 && is_in_sight(src, GLOB.revenants.revenant_rift)))
			tethered = FALSE
			return
		if(!tethered)
			visible_message(SPAN_DANGER("\The [src] tethers with \the [GLOB.revenants.revenant_rift]!"))
			last_zap = world.time
			tethered = TRUE
			Beam(GLOB.revenants.revenant_rift, icon_state="n_beam", icon = 'icons/effects/beam.dmi', time=2, maxdistance=5, beam_datum_type=/datum/beam/held)
			playsound(get_turf(src), 'sound/magic/Charge.ogg', 70, TRUE, extrarange = 30)
			return
		GLOB.revenants.revenant_rift.reduce_health(world.time - last_zap)
		last_zap = world.time
		Beam(GLOB.revenants.revenant_rift, icon_state="lightning[rand(1,12)]", icon = 'icons/effects/effects.dmi', time=2, maxdistance=5, beam_datum_type=/datum/beam/held)
		playsound(get_turf(src), 'sound/magic/LightningShock.ogg', 50, TRUE, extrarange = 30)
	if(active && GLOB.vamp.current_antagonists.len)
		for(var/obj/effect/dummy/veil_walk/veilwalk in range(src, 8))
			Beam(veilwalk, icon_state="lightning[rand(1,12)]", icon = 'icons/effects/effects.dmi', time=2, maxdistance=5, beam_datum_type=/datum/beam/held)
			playsound(get_turf(src), 'sound/magic/LightningShock.ogg', 50, TRUE, extrarange = 30)
			veilwalk.deactivate()
			to_chat(veilwalk.owner_mob, SPAN_DANGER("You are forcibly pulled from the Veil by an unknown power!"))
	else if(active)
		toggle()

/obj/item/bluespace_neutralizer/Destroy()
	if(active)
		STOP_PROCESSING(SSprocessing, src)
	return ..()
