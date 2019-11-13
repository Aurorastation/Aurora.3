/obj/machinery/beehive
	name = "beehive"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beehive"
	density = 1
	anchored = 1

	var/closed = 0
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

/obj/machinery/beehive/examine(var/mob/user)
	..()
	if(!closed)
		to_chat(user, "The lid is open. The bees can't grow and produce honey until it's closed!")

/obj/machinery/beehive/attackby(var/obj/item/I, var/mob/user)
	if(I.iscrowbar())
		closed = !closed
		user.visible_message("<span class='notice'>[user] [closed ? "closes" : "opens"] \the [src].</span>", "<span class='notice'>You [closed ? "close" : "open"] \the [src].</span>")
		update_icon()
		return
	else if(I.iswrench())
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [anchored ? "wrenches" : "unwrenches"] \the [src].</span>", "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
		if (!smoked && !anchored && (bee_count > 10))
			visible_message("<span class='danger'>The bees don't like their home being moved!.</span>")
			release_bees(0.1, 5)
		return
	else if(istype(I, /obj/item/honey_frame))
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before inserting \the [I].</span>")
			return
		if(frames >= maxFrames)
			to_chat(user, "<span class='notice'>There is no place for an another frame.</span>")
			return
		var/obj/item/honey_frame/H = I
		if(H.honey)
			to_chat(user, "<span class='notice'>\The [I] is full with beeswax and honey, empty it in the extractor first.</span>")
			return
		++frames
		user.visible_message("<span class='notice'>[user] loads \the [I] into \the [src].</span>", "<span class='notice'>You load \the [I] into \the [src].</span>")
		update_icon()
		qdel(I)
		return
	else if(istype(I, /obj/item/bee_pack))
		var/obj/item/bee_pack/B = I
		if(B.full && bee_count)
			to_chat(user, "<span class='notice'>\The [src] already has bees inside.</span>")
			return
		if(!B.full && bee_count < 90)
			to_chat(user, "<span class='notice'>\The [src] is not ready to split.</span>")
			return
		if(!B.full && !smoked)
			to_chat(user, "<span class='notice'>Smoke \the [src] first!</span>")
			return
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before moving the bees.</span>")
			return
		if(B.full)
			user.visible_message("<span class='notice'>[user] puts the queen and the bees from \the [I] into \the [src].</span>", "<span class='notice'>You put the queen and the bees from \the [I] into \the [src].</span>")
			bee_count = 20
			B.empty()
		else
			user.visible_message("<span class='notice'>[user] puts bees and larvae from \the [src] into \the [I].</span>", "<span class='notice'>You put puts bees and larvae from \the [src] into \the [I].</span>")
			bee_count /= 2
			B.fill()
		update_icon()
		return
	else if(istype(I, /obj/item/device/analyzer/plant_analyzer))
		to_chat(user, "<span class='notice'>Scan result of \the [src]...</span>")
		to_chat(user, "Beehive is [bee_count ? "[round(bee_count)]% full" : "empty"].[bee_count > 90 ? " Colony is ready to split." : ""]")
		if(frames)
			to_chat(user, "[frames] frames installed, [round(honeycombs / 100)] filled.")
			if(honeycombs < frames * 100)
				to_chat(user, "Next frame is [round(honeycombs % 100)]% full.")
		else
			to_chat(user, "No frames installed.")
		if(smoked)
			to_chat(user, "The hive is smoked.")
		return 1
	else if(I.isscrewdriver())
		if(bee_count)
			visible_message("<span class='danger'>The bees are furious you're trying to destroy their home!</span>")
			release_bees(1, 30)
		to_chat(user, "<span class='notice'>You start dismantling \the [src]. This will take a while...</span>")
		playsound(loc, I.usesound, 50, 1)
		if(do_after(user, 150/I.toolspeed))
			user.visible_message("<span class='notice'>[user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/beehive_assembly(loc)
			qdel(src)
		return

/obj/machinery/beehive/attack_hand(var/mob/user)
	if(!closed)
		if(honeycombs < 100)
			to_chat(user, "<span class='notice'>There are no filled honeycombs.</span>")
			return
		if(!smoked && (bee_count > 5))
			visible_message("<span class='danger'>The bees don't like you taking their honey!</span>")
			release_bees(0.2, 5)
		user.visible_message("<span class='notice'>[user] starts taking the honeycombs out of \the [src].</span>", "<span class='notice'>You start taking the honeycombs out of \the [src]...</span>")
		while(honeycombs >= 100 && do_after(user, 30))
			new /obj/item/honey_frame/filled(loc)
			honeycombs -= 100
			--frames
			update_icon()
		if(honeycombs < 100)
			to_chat(user, "<span class='notice'>You take all filled honeycombs out.</span>")
		return

/obj/machinery/beehive/machinery_process()
	if(closed && !smoked && bee_count)
		pollinate_flowers()
		update_icon()
	else if (!closed && bee_count && prob(bee_count*0.1))
	//If the hive is opened, periodically release docile bees
		visible_message("<span class='notice'>A few curious bees float out of the open hive to buzz around</span>")
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
			++trays
	honeycombs = min(honeycombs + 0.12 * coef * min(trays, 5), frames * 100)


/obj/machinery/beehive/proc/release_bees(var/severity, var/angry, var/swarmsize = 6)


	if (bee_count < 1)
		return

	src.visible_message(span("notice"," [pick("Buzzzz.","Hmmmmm.","Bzzz.")]"))
	playsound(src.loc, pick('sound/effects/Buzz1.ogg','sound/effects/Buzz2.ogg'), 45, 1,0)

	severity = Clamp(severity, 0, 1)
	var/beestorelease = bee_count * severity
	beestorelease = round(beestorelease,1)
	bee_count -= beestorelease

	var/list/spawn_turfs = list(get_turf(src))
	for (var/T in orange(1, src))
		if (istype(T, /turf/simulated/floor))
			spawn_turfs += T


	while(beestorelease > 0)
		while(beestorelease > swarmsize)
			var/mob/living/simple_animal/bee/B = new(pick(spawn_turfs), src)
			B.feral = angry
			B.strength = swarmsize
			B.update_icons()
			beestorelease -= swarmsize

		//what's left over
		var/mob/living/simple_animal/bee/B = new(pick(spawn_turfs), src)
		B.strength = beestorelease
		B.icon_state = "bees[B.strength]"
		B.feral = angry
		B.update_icons()
		beestorelease = 0



/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A machine used to turn honeycombs on the frame into honey and wax."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"

	var/processing = 0
	var/honey = 0
	anchored = 0

/obj/machinery/honey_extractor/examine(var/mob/user)
	..()
	to_chat(user, "It contains [honey] units of honey for collection.")

/obj/machinery/honey_extractor/attackby(var/obj/item/I, var/mob/user)
	if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently spinning, wait until it's finished.</span>")
		return
	else if(istype(I, /obj/item/honey_frame))
		var/obj/item/honey_frame/H = I
		if(!H.honey)
			to_chat(user, "<span class='notice'>\The [H] is empty, put it into a beehive.</span>")
			return
		user.visible_message("<span class='notice'>[user] loads \the [H] into \the [src] and turns it on.</span>", "<span class='notice'>You load \the [H] into \the [src] and turn it on.</span>")
		processing = H.honey
		icon_state = "centrifuge_moving"
		qdel(H)
		spawn(200)
			new /obj/item/honey_frame(loc)
			new /obj/item/stack/wax(loc)
			honey += processing
			processing = 0
			icon_state = "centrifuge"
	else if(istype(I, /obj/item/reagent_containers/glass))
		if(!honey)
			to_chat(user, "<span class='notice'>There is no honey in \the [src].</span>")
			return
		var/obj/item/reagent_containers/glass/G = I
		var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, honey)
		G.reagents.add_reagent("honey", transferred)
		honey -= transferred
		user.visible_message("<span class='notice'>[user] collects honey from \the [src] into \the [G].</span>", "<span class='notice'>You collect [transferred] units of honey from \the [src] into \the [G].</span>")
		return 1
	else
		..()

/obj/item/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that the bees will fill with honeycombs."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "honeyframe"
	w_class = 2

	var/honey = 0

/obj/item/honey_frame/filled
	name = "filled beehive frame"
	desc = "A frame for the beehive that the bees have filled with honeycombs."
	honey = 20

/obj/item/honey_frame/filled/Initialize()
	. = ..()
	add_overlay("honeycomb")

/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, "<span class='notice'>You start assembling \the [src]...</span>")
	if(do_after(user, 30))
		user.visible_message("<span class='notice'>[user] constructs a beehive.</span>", "<span class='notice'>You construct a beehive.</span>")
		new /obj/machinery/beehive(get_turf(user))
		qdel(src)
	return

/obj/item/stack/wax
	name = "wax"
	singular_name = "wax piece"
	desc = "Soft substance produced by botany. Used to make candles."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "wax"

/obj/item/stack/wax/New()
	..()
	recipes = wax_recipes

var/global/list/datum/stack_recipe/wax_recipes = list( \
	new/datum/stack_recipe("candle", /obj/item/flame/candle) \
)

/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beepack"
	var/full = 1

/obj/item/bee_pack/Initialize()
	. = ..()
	add_overlay("beepack-full")

/obj/item/bee_pack/proc/empty()
	full = 0
	name = "empty bee pack"
	desc = "A stasis pack for moving bees. It's empty."
	cut_overlays()
	add_overlay("beepack-empty")

/obj/item/bee_pack/proc/fill()
	full = initial(full)
	name = initial(name)
	desc = initial(desc)
	cut_overlays()
	add_overlay("beepack-full")
