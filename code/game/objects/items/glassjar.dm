#define JAR_NOTHING 	0
#define JAR_MONEY 		1
#define JAR_ANIMAL 		2
#define JAR_SPIDERLING 	3
#define JAR_GUMBALL 	4

// All of these defines below are to assist with gumball-related mechanics except for the contain define

#define GUMBALL_MAX 	15
#define GUMBALL_MEDIUM	10
#define GUMBALL_MIN		5

/obj/item/glass_jar
	name = "glass jar"
	desc = "A glass jar. You can remove the lid and use it as a reagent container."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "jar_lid"
	w_class = ITEMSIZE_SMALL
	matter = list(MATERIAL_GLASS = 200)
	recyclable = TRUE
	flags = NOBLUDGEON
	var/contains = JAR_NOTHING // 0 = nothing, 1 = money, 2 = animal, 3 = spiderling, 4 = gumballs
	var/list/gumballs_contained = list()
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/glass_jar/New()
	..()
	update_icon()

/obj/item/glass_jar/MouseDrop(atom/target)
	if(ishuman(target) || issmall(target) && target == usr)
		if(contains == JAR_GUMBALL)
			handle_gumball_removal(usr)

/obj/item/glass_jar/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || contains)
		return
	if(istype(A, /obj/effect/spider/spiderling))
		var/obj/effect/spider/spiderling/S = A
		user.visible_message(SPAN_NOTICE("<b>\The [user]</b> scoops \the [S] into \the [src]."), SPAN_NOTICE("You scoop \the [S] into \the [src]."))
		S.forceMove(src)
		STOP_PROCESSING(SSprocessing, S)	// No growing inside jars
		contains = JAR_SPIDERLING
		update_icon()
		return
	if(ismob(A))
		var/mob/L = A
		if(L.mob_size <= MOB_SMALL)
			user.visible_message(SPAN_NOTICE("<b>\The [user]</b> scoops \the [L] into \the [src]."), SPAN_NOTICE("You scoop \the [L] into \the [src]."))
			L.forceMove(src)
			contains = JAR_ANIMAL
			update_icon()
			return
		else
			to_chat(user, SPAN_WARNING("\The [L] doesn't fit into \the [src]!"))
			return

/obj/item/glass_jar/attack_self(var/mob/user)
	switch(contains)
		if(JAR_MONEY)
			for(var/obj/O in src)
				O.forceMove(user.loc)
			to_chat(user, SPAN_NOTICE("You take money out of \the [src]."))
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_ANIMAL)
			for(var/mob/M in src)
				M.forceMove(user.loc)
				user.visible_message(SPAN_NOTICE("\The [user] releases \the [M] from \the [src]."), SPAN_NOTICE("You release \the [M] from \the [src]."))
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_SPIDERLING)
			for(var/obj/effect/spider/spiderling/S in src)
				S.forceMove(user.loc)
				user.visible_message(SPAN_NOTICE("\The [user] releases \the [S] from \the [src]."), SPAN_NOTICE("You release \the [S] from \the [src]."))
				START_PROCESSING(SSprocessing, S) // They can grow after being let out though
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_NOTHING)
			to_chat(user, SPAN_NOTICE("You remove the lid from \the [src]."))
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
		user.visible_message(SPAN_NOTICE("\The [user] puts [S.worth] [S.worth > 1 ? "credits" : "credit"] into \the [src]."))
		user.drop_from_inventory(S,src)
		update_icon()
	
	if(istype(A, /obj/item/clothing/mask/chewable/candy/gum/gumball))
		handle_gumball_addition(user, A)

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
		if(JAR_GUMBALL)
			name = "gumball jar"
			desc = "A jar containing gumballs with varying colours."
			var/image/gumballs_overlay = image(icon)
			switch(length(gumballs_contained))
				if(1 to GUMBALL_MIN)
					gumballs_overlay.icon_state = "gumball_min"
				if(6 to GUMBALL_MEDIUM)
					gumballs_overlay.icon_state = "gumball_min"
				if(11 to GUMBALL_MAX)
					gumballs_overlay.icon_state = "gumball_max"
			underlays += gumballs_overlay

	return

/obj/item/glass_jar/proc/handle_gumball_addition(mob/user, var/obj/item/clothing/mask/chewable/candy/gum/gumball/G) // handles the entire gumbball addition process
	if(length(gumballs_contained) < GUMBALL_MAX)
		gumballs_contained += G
		user.drop_from_inventory(G)
		G.forceMove(src)
		if(!contains)
			contains = JAR_GUMBALL
		user.visible_message("<b>[user]</b> puts a gumball in \the [src].", SPAN_NOTICE("You put a gumball in \the [src]."))
		handle_gumball_underlays()
	else
		to_chat(user, SPAN_WARNING("\The [name] is full!"))

/obj/item/glass_jar/proc/handle_gumball_removal(mob/user) // same as the addition proc but we're removing gum instead
	if(length(gumballs_contained))
		user.put_in_hands(gumballs_contained[1])
		gumballs_contained -= gumballs_contained[1]
		user.visible_message("[user] takes a gumball from \the [name].", SPAN_NOTICE("You take a gumball from \the [name]."))
		if(length(gumballs_contained) == 0)
			contains = JAR_NOTHING
		handle_gumball_underlays()

/obj/item/glass_jar/proc/handle_gumball_underlays() // gumball overlays
	underlays.Cut()
	if(length(gumballs_contained))
		var/image/gumballs_overlay = image(icon)
		switch(length(gumballs_contained))
			if(1 to GUMBALL_MIN)
				gumballs_overlay.icon_state = "gumball_min"
			if(6 to GUMBALL_MEDIUM)
				gumballs_overlay.icon_state = "gumball_medium"
			if(11 to GUMBALL_MAX)
				gumballs_overlay.icon_state = "gumball_max"
		underlays += gumballs_overlay


/obj/item/glass_jar/peter/
	name = "Peter's Jar"

/obj/item/glass_jar/peter/Initialize()
	..()
	var/obj/effect/spider/spiderling/S = new
	S.name = "Peter"
	S.desc = "The journalist's pet spider, Peter. It has a miniature camera around its neck and seems to glow faintly."
	S.forceMove(src)
	contains = JAR_SPIDERLING
	STOP_PROCESSING(SSprocessing, S)
	update_icon()

/obj/item/glass_jar/gumball
	contains = JAR_GUMBALL

/obj/item/glass_jar/gumball/Initialize()
	..()
	for(var/i = 1 to GUMBALL_MAX)
		var/obj/item/clothing/mask/chewable/candy/gum/gumball/G = new(src)
		gumballs_contained += G

	return INITIALIZE_HINT_LATELOAD

/obj/item/glass_jar/gumball/LateInitialize()
	update_icon()

/obj/item/glass_jar/gumball/medical

/obj/item/glass_jar/gumball/medical/Initialize()
	for(var/i = 1 to GUMBALL_MAX)
		var/obj/item/clothing/mask/chewable/candy/gum/gumball/medical/G = new
		G.forceMove(src)
		gumballs_contained += G

#undef JAR_NOTHING
#undef JAR_MONEY
#undef JAR_ANIMAL
#undef JAR_SPIDERLING
#undef JAR_GUMBALL

#undef GUMBALL_MAX
#undef GUMBALL_MEDIUM
#undef GUMBALL_MIN
