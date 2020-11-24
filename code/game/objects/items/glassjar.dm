#define JAR_NOTHING 0
#define JAR_MONEY 1
#define JAR_ANIMAL 2
#define JAR_SPIDERLING 3

/obj/item/glass_jar
	name = "glass jar"
	desc = "A glass jar. You can remove the lid and use it as a reagent container."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "jar_lid"
	w_class = ITEMSIZE_SMALL
	matter = list(MATERIAL_GLASS = 200)
	recyclable = TRUE
	flags = NOBLUDGEON
	var/contains = JAR_NOTHING // 0 = nothing, 1 = money, 2 = animal, 3 = spiderling
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/glass_jar/New()
	..()
	update_icon()

/obj/item/glass_jar/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || contains)
		return
	if(istype(A, /obj/effect/spider/spiderling))
		var/obj/effect/spider/spiderling/S = A
		user.visible_message(SPAN_NOTICE("<b>\The [user]</b> scoops \the [S] into \the [initial(name)]."), SPAN_NOTICE("You scoop \the [S] into \the [initial(name)]."))
		S.forceMove(src)
		STOP_PROCESSING(SSprocessing, S)	// No growing inside jars
		contains = JAR_SPIDERLING
		update_icon()
		return
		if(istype(A, /mob/living/simple_animal))
	var/mob/living/simple_animal/S = A
		if(S.mob_size <= MOB_TINY)
			user.visible_message(SPAN_NOTICE("<b>\The [user]</b> scoops \the [S] into \the [initial(name)]."), SPAN_NOTICE("You scoop \the [S] into \the [initial(name)]."))
			playsound(src, pickup_sound, PICKUP_SOUND_VOLUME)
			S.forceMove(src)
			return
		else
			to_chat(user, SPAN_WARNING("\The [L] doesn't fit into \the [initial(name)]!"))
			return

/obj/item/glass_jar/attack_self(var/mob/user)
	switch(contains)
		if(JAR_MONEY)
			for(var/obj/O in src)
				O.forceMove(user.loc)
			to_chat(user, SPAN_NOTICE("You take the money out of \the [initial(name)]."))
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_ANIMAL)
			for(var/mob/M in src)
				M.forceMove(user.loc)
				user.visible_message(SPAN_NOTICE("\The [user] releases \the [M] from \the [initial(name)]."), SPAN_NOTICE("You release \the [M] from \the [initial(name)]."))
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_SPIDERLING)
			for(var/obj/effect/spider/spiderling/S in src)
				S.forceMove(user.loc)
				user.visible_message(SPAN_NOTICE("\The [user] releases \the [S] from \the [initial(name)]."), SPAN_NOTICE("You release \the [S] from \the [initial(name)]."))
				START_PROCESSING(SSprocessing, S) // They can grow after being let out though
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_NOTHING)
			to_chat(user, SPAN_NOTICE("You remove the lid from \the [initial(name)]."))
			user.drop_from_inventory(src)
			user.put_in_hands(new /obj/item/reagent_containers/glass/beaker/jar) //found in jar.dm
			qdel(src)
			return

/obj/item/glass_jar/attackby(var/atom/A, var/mob/user, var/proximity)
	if(istype(A, /obj/item/spacecash))
		if(contains == JAR_NOTHING)
			contains = JAR_MONEY
		if(contains != JAR_MONEY)
			return
		var/obj/item/spacecash/S = A
		user.visible_message(SPAN_NOTICE("\The [user] puts [S.worth] [S.worth > 1 ? "credits" : "credit"] into \the [initial(name)]."))
		user.drop_from_inventory(S,src)
		update_icon()

/obj/item/glass_jar/update_icon() // Also updates name and desc
	underlays.Cut()
	cut_overlays()
	switch(contains)
		if(JAR_NOTHING)
			name = initial(name)
			desc = initial(desc)
		if(JAR_MONEY)
			name = "tip jar"
			desc = "A small jar with money inside."
			for(var/obj/item/spacecash/S in src)
				var/image/money = image(S.icon, S.icon_state)
				money.pixel_x = rand(-2, 3)
				money.pixel_y = rand(-6, 6)
				money.transform *= 0.6
				underlays += money
				for (var/A in S.overlays)
					underlays += A
		if(JAR_ANIMAL)
			for(var/mob/M in src)
				var/image/victim = new()
				victim.appearance = M
				victim.layer = FLOAT_LAYER
				victim.plane = FLOAT_PLANE
				victim.pixel_x = 0
				victim.pixel_y = 6
				underlays += victim
				name = "glass jar with [M]"
				desc = "A small jar with [M] inside."
		if(JAR_SPIDERLING)
			for(var/obj/effect/spider/spiderling/S in src)
				var/image/victim = image(S.icon, S.icon_state)
				underlays += victim
				name = "glass jar with [S]"
				desc = "A small jar with [S] inside."
	return

/obj/item/glass_jar/peter/
	name = "Peter's Jar"

/obj/item/glass_jar/peter/Initialize()
	. = ..()
	var/obj/effect/spider/spiderling/S = new
	S.name = "Peter"
	S.desc = "The journalist's pet spider, Peter. It has a miniature camera around its neck and seems to glow faintly."
	S.forceMove(src)
	contains = JAR_SPIDERLING
	STOP_PROCESSING(SSprocessing, S)
	update_icon()

#undef JAR_NOTHING
#undef JAR_MONEY
#undef JAR_ANIMAL
#undef JAR_SPIDERLING
