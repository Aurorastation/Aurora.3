/obj/machinery/beehive
	name = "beehive"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beehive"
	density = TRUE
	anchored = TRUE

	var/closed = FALSE
	var/bee_count = 0 // Percent
	var/smoked = 0 // Timer
	var/honeycombs = 0 // Percent
	var/frames = 0
	var/maxFrames = 5

	var/list/owned_bee_swarms = list()

/obj/machinery/beehive/update_icon()
	cut_overlays()
	icon_state = "beehive"
	if(closed)
		add_overlay("lid")
	if(frames)
		add_overlay("empty[frames]")
	if(honeycombs >= 100)
		add_overlay("full[round(honeycombs / 100)]")
	if(!smoked)
		switch(bee_count)
			if(1 to 40)
				add_overlay("bees1")
			if(41 to 80)
				add_overlay("bees2")
			if(81 to 100)
				add_overlay("bees3")

/obj/machinery/beehive/examine(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("\The [src] is holding <b>[frames]/[maxFrames]</b> frames."))
	if(user.Adjacent(src))
		if(bee_count)
			if(closed)
				to_chat(user, FONT_SMALL(SPAN_NOTICE("You can hear buzzing from within \the [src].")))
			else
				to_chat(user, FONT_SMALL(SPAN_WARNING("The lid is <b>open</b>. The bees can't grow and produce honey until it's <b>closed!</b>")))
				to_chat(user, FONT_SMALL(SPAN_NOTICE("You can see bees buzzing around within \the [src].")))
		else
			if(closed)
				to_chat(user, FONT_SMALL(SPAN_NOTICE("\The [src] lies silent.")))
			else
				to_chat(user, FONT_SMALL(SPAN_NOTICE("You can see bees buzzing around within \the [src].")))
		if(honeycombs / 100 > 1)
			to_chat(user, SPAN_NOTICE("\The [src] has a frame full of honeycombs which you can harvest."))

/obj/machinery/beehive/attackby(obj/item/I, mob/user)
	if(I.iscrowbar())
		closed = !closed
		user.visible_message(SPAN_NOTICE("\The [user] [closed ? "closes" : "opens"] \the [src]."), SPAN_NOTICE("You [closed ? "close" : "open"] \the [src]."))
		update_icon()
		return
	else if(I.iswrench())
		anchored = !anchored
		user.visible_message(SPAN_NOTICE("\The [user] [anchored ? "wrenches" : "unwrenches"] \the [src]."), SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
		if(!smoked && !anchored && (bee_count > 10))
			visible_message(SPAN_WARNING("The bees don't like their home being moved!"))
			release_bees(0.1, 5)
		return
	else if(istype(I, /obj/item/honey_frame))
		if(closed)
			to_chat(user, SPAN_WARNING("You need to open \the [src] with a crowbar before inserting \the [I]."))
			return
		if(frames >= maxFrames)
			to_chat(user, SPAN_WARNING("\The [src] cannot fit more frames."))
			return
		var/obj/item/honey_frame/H = I
		if(H.honey)
			to_chat(user, SPAN_WARNING("\The [I] is full with beeswax and honey, empty it into the extractor first."))
			return
		frames++
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [I] into \the [src]."), SPAN_NOTICE("You load \the [I] into \the [src]."))
		update_icon()
		qdel(I)
		return
	else if(istype(I, /obj/item/bee_pack))
		var/obj/item/bee_pack/B = I
		if(B.full && bee_count)
			to_chat(user, SPAN_WARNING("\The [B] is already full of bees."))
			return
		if(!B.full && bee_count < 90)
			to_chat(user, SPAN_WARNING("The bees within \the [src] are not ready to split yet."))
			return
		if(!B.full && !smoked)
			to_chat(user, SPAN_WARNING("The bees won't enter \the [B] without being smoked!"))
			return
		if(closed)
			to_chat(user, SPAN_WARNING("You need to open \the [src] with a crowbar before moving the bees."))
			return
		if(B.full)
			user.visible_message(SPAN_NOTICE("\The [user] puts the queen and the bees from \the [B] into \the [src]."), SPAN_NOTICE("You put the queen and the bees from \the [B] into \the [src]."))
			bee_count = 20
			B.empty()
		else
			user.visible_message(SPAN_NOTICE("\The [user] puts bees and larvae from \the [src] into \the [B]."), SPAN_NOTICE("You put puts bees and larvae from \the [src] into \the [B]."))
			bee_count /= 2
			B.fill()
		update_icon()
		return
	else if(istype(I, /obj/item/device/analyzer/plant_analyzer))
		to_chat(user, SPAN_NOTICE("Scan result of \the [src]:"))
		to_chat(user, SPAN_NOTICE("Beehive is <b>[bee_count ? "[round(bee_count)]% full" : "empty"]</b>.[bee_count > 90 ? " Colony is ready to split." : ""]"))
		if(frames)
			to_chat(user, SPAN_NOTICE("<b>[frames]</b> frames installed, <b>[round(honeycombs / 100)]</b> filled."))
			if(honeycombs < frames * 100)
				to_chat(user, SPAN_NOTICE("In-progress frame is <b>[round(honeycombs % 100)]%</b> full."))
		else
			to_chat(user, SPAN_NOTICE("No frames installed."))
		if(smoked)
			to_chat(user, SPAN_NOTICE("The hive is <b>smoked</b>."))
		return
	else if(I.isscrewdriver())
		to_chat(user, SPAN_NOTICE("You start dismantling \the [src]. This will take a while..."))
		playsound(get_turf(src), I.usesound, 50, TRUE)
		if(do_after(user, 150 / I.toolspeed))
			user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
			if(bee_count)
				visible_message(SPAN_WARNING("The bees are furious over the destruction of their home!"))
				release_bees(1, 30)
			new /obj/item/beehive_assembly(get_turf(src))
			qdel(src)
		return

/obj/machinery/beehive/attack_hand(mob/user)
	if(!closed)
		if(honeycombs < 100)
			to_chat(user, SPAN_WARNING("There are no filled honeycombs."))
			return
		if(!smoked && bee_count > 5)
			visible_message(SPAN_WARNING("The bees don't like their honey being taken!"))
			release_bees(0.2, 5)
		user.visible_message(SPAN_NOTICE("\The [user] starts taking the honeycombs out of \the [src]."), SPAN_NOTICE("You start taking the honeycombs out of \the [src]..."))
		while(honeycombs >= 100 && do_after(user, 30))
			new /obj/item/honey_frame/filled(get_turf(src))
			honeycombs -= 100
			frames--
			update_icon()
		if(honeycombs < 100)
			to_chat(user, SPAN_NOTICE("You take all filled honeycombs out."))
		return

/obj/machinery/beehive/machinery_process()
	if(closed && !smoked && bee_count)
		pollinate_flowers()
		update_icon()
	else if (!closed && bee_count && prob(bee_count * 0.1))
	//If the hive is opened, periodically release docile bees
		visible_message(SPAN_WARNING("A few curious bees float out of the open beehive to buzz around."))
		release_bees(0.1, 0, 3)

	smoked = max(0, smoked - 1)
	if(!smoked && bee_count)
		bee_count = min(bee_count * 1.004, 100)
		update_icon()

/obj/machinery/beehive/proc/pollinate_flowers()
	var/coef = bee_count *0.01
	var/trays = 0
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
		if(H.seed && !H.dead)
			H.health += 0.05 * coef
			H.yield_mod = min(10, H.yield_mod + coef)
			trays++
	honeycombs = min(honeycombs + 0.12 * coef * min(trays, 5), frames * 100)

/obj/machinery/beehive/proc/release_bees(var/severity, var/angry, var/swarmsize = 6)
	if(bee_count < 1)
		return

	visible_message(SPAN_NOTICE("[pick("Buzzzz.","Hmmmmm.","Bzzz.")]"))
	playsound(get_turf(src), pick('sound/effects/Buzz1.ogg','sound/effects/Buzz2.ogg'), 45, TRUE)

	severity = Clamp(severity, 0, 1)
	var/bees_to_release = bee_count * severity
	bees_to_release = round(bees_to_release, 1)
	bee_count -= bees_to_release

	var/list/spawn_turfs = list(get_turf(src))
	for(var/T in orange(1, src))
		if(istype(T, /turf/simulated/floor))
			spawn_turfs += T

	while(bees_to_release > 0)
		while(bees_to_release > swarmsize)
			var/mob/living/simple_animal/bee/B = new(pick(spawn_turfs), src)
			B.feral = angry
			B.strength = swarmsize
			B.update_icons()
			bees_to_release -= swarmsize

		//what's left over
		var/mob/living/simple_animal/bee/B = new(pick(spawn_turfs), src)
		B.strength = bees_to_release
		B.icon_state = "bees[B.strength]"
		B.feral = angry
		B.update_icons()
		bees_to_release = 0

/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, SPAN_NOTICE("You start assembling \the [src]..."))
	if(do_after(user, 30))
		user.visible_message(SPAN_NOTICE("\The [user] constructs a beehive."), SPAN_NOTICE("You construct a beehive."))
		new /obj/machinery/beehive(get_turf(user))
		qdel(src)
	return