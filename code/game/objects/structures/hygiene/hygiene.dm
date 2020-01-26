/obj/structure/hygiene
	var/next_gurgle = 0
	var/clogged // -1 = never clog

/obj/structure/hygiene/New()
	..()
	SSfluids.hygiene_props[src] = TRUE

/obj/structure/hygiene/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	SSfluids.hygiene_props -= src
	. = ..()

/obj/structure/hygiene/proc/clog(var/severity)
	if(!isnull(clogged))
		return FALSE
	clogged = severity
	START_PROCESSING(SSprocessing, src)
	return TRUE

/obj/structure/hygiene/proc/unclog()
	clogged = null
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/hygiene/attackby(obj/item/thing, mob/user)
	if(!isnull(clogged) && clogged > 0 && istype(thing, /obj/item/clothing/mask/plunger))
		user.visible_message("<span class='notice'>\The [user] strives valiantly to unclog \the [src] with \the [thing]!</span>")
		spawn
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
		if(do_after(user, 45, src) && clogged)
			visible_message("<span class='notice'>With a loud gurgle, \the [src] begins flowing more freely.</span>")
			playsound(loc, pick(SSfluids.gurgles), 100, 1)
			clogged--
			if(clogged <= 0)
				unclog()
		return
	. = ..()

/obj/structure/hygiene/examine(mob/user)
	. = ..()
	if(clogged)
		to_chat(user, "<span class='warning'>It seems to be badly clogged.</span>")

/obj/structure/hygiene/process()
	if(isnull(clogged))
		return
	var/flood_amt
	switch(clogged)
		if(1)
			flood_amt = FLUID_SHALLOW
		if(2)
			flood_amt = FLUID_OVER_MOB_HEAD
		if(3)
			flood_amt = FLUID_DEEP
	if(flood_amt)
		var/turf/T = loc
		if(istype(T))
			var/obj/effect/fluid/F = locate() in T
			if(!F)
				F = new(loc)
			T.show_bubbles()
			if(world.time > next_gurgle)
				visible_message(span("warning", "\The [src] gurgles and overflows!"))
				next_gurgle = world.time + 80
				playsound(T, pick(SSfluids.gurgles), 50, 1)
			SET_FLUID_DEPTH(F, min(F.fluid_amount + (rand(30,50)*clogged), flood_amt))