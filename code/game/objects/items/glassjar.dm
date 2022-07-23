#define JAR_NOTHING 	0
#define JAR_MONEY 		1
#define JAR_ANIMAL 		2
#define JAR_SPIDERLING 	3
#define JAR_GUMBALL 	4
#define JAR_HOLDER		5

// All of these defines below are to assist with gumball-related mechanics except for the contain define

#define GUMBALL_MAX 	15
#define GUMBALL_MEDIUM	10
#define GUMBALL_MIN		5

/obj/item/glass_jar
	name = "glass jar"
	desc = "A glass jar. Does not contain brain submerged in formaldehyde."
	desc_info = "Can be used to hold money, small animals, and gumballs. You can remove the lid and use it as a reagent container."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "jar_lid"
	w_class = ITEMSIZE_SMALL
	matter = list(MATERIAL_GLASS = 200)
	recyclable = TRUE
	flags = NOBLUDGEON
	var/contains = JAR_NOTHING // 0 = nothing, 1 = money, 2 = animal, 3 = spiderling, 4 = gumballs, 5 = holder
	var/list/contained = list()
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
		STOP_PROCESSING(SSprocessing, S)	// No growing inside jars
		contains = JAR_SPIDERLING
		scoop(S, user)
	if(ismob(A))
		var/mob/L = A
		if(L.mob_size <= MOB_TINY)
			contains = JAR_ANIMAL
			scoop(L, user)
		else
			scoop_fail(L, user)

/obj/item/glass_jar/proc/scoop(var/atom/movable/A, var/mob/user)
	user.visible_message(SPAN_NOTICE("<b>[user]</b> scoops \the [A] into \the [src]."), SPAN_NOTICE("You scoop \the [A] into \the [src]."))
	playsound(src, pickup_sound, PICKUP_SOUND_VOLUME)
	A.forceMove(src)
	update_icon()
	return

/obj/item/glass_jar/proc/scoop_fail(var/atom/A, var/mob/user)
	to_chat(user, SPAN_WARNING("\The [A] doesn't fit into \the [initial(name)]!"))
	playsound(src, drop_sound, DROP_SOUND_VOLUME)
	return

/obj/item/glass_jar/attack_self(var/mob/user)
	switch(contains)
		if(JAR_NOTHING)
			to_chat(user, SPAN_NOTICE("You remove the lid from \the [src]."))
			user.drop_from_inventory(src)
			user.put_in_hands(new /obj/item/reagent_containers/glass/beaker/jar) //found in jar.dm
			qdel(src)
			return
		if(JAR_MONEY)
			for(var/obj/O in src)
				user.put_in_hands(O)
				release(O, user)
		if(JAR_ANIMAL)
			for(var/mob/M in src)
				M.forceMove(user.loc)
				release(M, user)
		if(JAR_SPIDERLING)
			for(var/obj/effect/spider/spiderling/S in src)
				S.forceMove(user.loc)
				START_PROCESSING(SSprocessing, S) // They can grow after being let out though
				release(S, user)
		if(JAR_GUMBALL)
			if(length(contained))
				user.put_in_hands(contained[1])
				contained -= contained[1]
				release(contained[1], user)
		if(JAR_HOLDER)
			for(var/obj/item/holder/H in src)
				H.release_to_floor() // Snowflake code because holders are ass. Q.E.D.
				release(H, user)

/obj/item/glass_jar/proc/release(var/atom/movable/A, var/mob/user)
	if(istype(A, /obj/item/spacecash) || istype(A, /obj/item/clothing/mask/chewable/candy/gum/gumball))
		user.visible_message(SPAN_NOTICE("<b>[user]</b> takes \the [A] out from \the [src]."), SPAN_NOTICE("You take \the [A] out from \the [src]."))
	else
		user.visible_message(SPAN_NOTICE("<b>[user]</b> releases \the [A] from \the [src]."), SPAN_NOTICE("You release \the [A] from \the [src]."))
	if(length(contained) == 0)
		contains = JAR_NOTHING
	playsound(src, drop_sound, DROP_SOUND_VOLUME)
	update_icon()
	return

/obj/item/glass_jar/MouseDrop(atom/over)
	if(usr != over || use_check_and_message(usr))
		return
	if(length(contained))
		switch(contains)
			if(JAR_GUMBALL)
				release(contained[1], usr)
				usr.put_in_hands(contained[1])
				contained -= contained[1]

/obj/item/glass_jar/attackby(var/atom/A, var/mob/user, var/proximity)
	if(istype(A, /obj/item/spacecash))
		var/obj/item/spacecash/S = A
		if(contains == JAR_NOTHING)
			contains = JAR_MONEY
		if(contains != JAR_MONEY)
			return TRUE
		user.visible_message(SPAN_NOTICE("<b>[user]</b> puts [S.worth] credit\s into \the [src]."))
		user.drop_from_inventory(S,src)
		update_icon()
	if(istype(A, /obj/item/clothing/mask/chewable/candy/gum/gumball))
		var/obj/item/clothing/mask/chewable/candy/gum/gumball/G = A
		if(length(contained) < GUMBALL_MAX)
			contained += G
			user.drop_from_inventory(G)
			G.forceMove(src)
			if(!contains)
				contains = JAR_GUMBALL
			user.visible_message("<b>[user]</b> puts a gumball in \the [src].", SPAN_NOTICE("You put a gumball in \the [src]."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [name] is full!"))
		return TRUE
	if(istype(A, /obj/item/holder))
		var/obj/item/holder/H = A
		if(H.w_class <= ITEMSIZE_SMALL)
			contains = JAR_HOLDER
			user.drop_from_inventory(H)
			scoop(H, user)
		else
			scoop_fail(H, user)
		return TRUE

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
				name = "specimen jar"
				desc = "A small jar with [M] inside."
		if(JAR_SPIDERLING)
			for(var/obj/effect/spider/spiderling/S in src)
				var/image/victim = image(S.icon, S.icon_state)
				underlays += victim
				name = "glass jar with [S]"
				desc = "A small jar with [S] inside."
		if(JAR_GUMBALL)
			name = "gumball jar"
			desc = "A jar containing gumballs with varying colours."
			var/image/gumballs_overlay = image(icon)
			switch(length(contained))
				if(1 to GUMBALL_MIN)
					gumballs_overlay.icon_state = "gumball_min"
				if(6 to GUMBALL_MEDIUM)
					gumballs_overlay.icon_state = "gumball_med"
				if(11 to GUMBALL_MAX)
					gumballs_overlay.icon_state = "gumball_max"
			underlays += gumballs_overlay
		if(JAR_HOLDER)
			for(var/obj/item/holder/H in src)
				var/image/holder = image(H.icon, H.icon_state)
				holder.pixel_x = 0
				holder.pixel_y = 6
				underlays += holder
				name = "specimen jar"
				desc = "A small jar with [H] inside."
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

/obj/item/glass_jar/gumball
	contains = JAR_GUMBALL
	var/gumball_path = /obj/item/clothing/mask/chewable/candy/gum/gumball

/obj/item/glass_jar/gumball/medical
	gumball_path = /obj/item/clothing/mask/chewable/candy/gum/gumball/medical

/obj/item/glass_jar/gumball/Initialize()
	..()
	for(var/i = 1 to GUMBALL_MAX)
		var/obj/item/clothing/mask/chewable/candy/gum/gumball/G = new gumball_path(src)
		contained += G

	return INITIALIZE_HINT_LATELOAD

/obj/item/glass_jar/gumball/LateInitialize()
	update_icon()

#undef JAR_NOTHING
#undef JAR_MONEY
#undef JAR_ANIMAL
#undef JAR_SPIDERLING
#undef JAR_GUMBALL
#undef JAR_HOLDER

#undef GUMBALL_MAX
#undef GUMBALL_MEDIUM
#undef GUMBALL_MIN
