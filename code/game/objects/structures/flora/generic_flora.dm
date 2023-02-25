/obj/structure/flora
	name = "flora parent object"
	desc = DESC_PARENT
	anchored = TRUE
	density = TRUE
	var/cutting

/obj/structure/flora/proc/dig_up(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] begins digging up \the [src]..."))
	if(do_after(user, 150))
		if(Adjacent(user))
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [src]!"))
			qdel(src)

/obj/structure/flora/tree
	name = "tree"
	desc = "A tree."
	density = TRUE
	layer = 9
	pixel_x = -16
	var/max_chop_health = 180
	var/chop_health = 180 //15 hits with steel hatchet, 5 with wielded fireaxe
	var/fall_force = 60
	var/list/contained_objects = list()	//If it has anything except wood. Fruit, pinecones, animals, etc.
	var/stumptype = /obj/structure/flora/stump //stump to make when chopped
	var/static/list/fall_forbid = list(/obj/structure/flora, /obj/effect, /obj/structure/bonfire, /obj/structure/pit)

/obj/structure/flora/tree/proc/update_desc()
	desc = initial(desc)
	switch(chop_health / max_chop_health)
		if(0 to 0.25)
			desc = " It looks like it's about to fall!"
		if(0.26 to 0.5)
			desc += " Just a bit more work and it'll fall!"
		if(0.51 to 0.75)
			desc += " It's been chopped at a few times."
		if(0.76 to 0.95)
			desc += " Looks like someone just started cutting it down."

/obj/structure/flora/tree/attackby(obj/item/I, mob/user)
	if(I.can_woodcut())
		if(cutting)
			return
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		cutting = TRUE
		if(istype(I, /obj/item/material/twohanded/chainsaw))
			var/obj/item/material/twohanded/chainsaw/C = I
			if(C.powered)
				user.visible_message(SPAN_NOTICE("\The [user] begins cutting down \the [src]..."), SPAN_NOTICE("You start cutting down \the [src]..."))
				playsound(get_turf(user), 'sound/weapons/saw/chainsawhit.ogg', 60, 1)
				shake_animation()
				if(do_after(user, 50))
					timber(user)
			else
				to_chat(user, SPAN_WARNING("Try turning \the [C] on first!"))
				cutting = FALSE
				return
		else if(do_after(user, I.w_class * 5)) //Small windup
			user.do_attack_animation(src)
			shake_animation()
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
			chop_health -= I.force
			update_desc()
			if(prob(20))
				user.visible_message(SPAN_NOTICE("\The [user] chops at \the [src]."), SPAN_NOTICE("You chop at \the [src]."), SPAN_NOTICE("You hear someone chopping wood."))
			if(prob(I.force/3))
				var/list/valid_turfs = list()
				for(var/turf/T in circle_range(src, 1))
					if(T.contains_dense_objects())
						continue
					valid_turfs += T
				if(!valid_turfs.len)
					valid_turfs += get_turf(src)
				var/obj/item/stack/material/wood/branch/B = new(pick(valid_turfs))
				B.amount = 1
				visible_message(SPAN_NOTICE("\The [B] falls from \the [src]."))

			if(chop_health <= 0)
				timber(user)
		cutting = FALSE
		return
	..()

/obj/structure/flora/tree/proc/timber(mob/user)
	var/turf/fall_loc //Where we will fall

	//We prefer to fall directly away from the user if possible
	var/turf/pref_loc = get_cardinal_step_away(src, user)
	if(!pref_loc.contains_dense_objects(TRUE))
		fall_loc = pref_loc

	//Otherwise, we fall elsewhere
	else
		var/list/fall_spots = list()
		for(var/turf/T in orange(1, src))
			if(locate(user) in T.contents) //Won't fall on woodcutter
				continue
			if(T.contains_dense_objects(TRUE)) //Let's avoid dense objects but not mobs
				continue
			fall_spots += T

		if(!fall_spots.len)
			fall_loc = get_turf(src)
		else
			fall_loc = pick(fall_spots)
	playsound(get_turf(src), 'sound/species/diona/gestalt_grow.ogg', 50)
	for(var/atom/A in fall_loc.contents)
		if(is_type_in_list(A, fall_forbid))
			continue
		if(isliving(A))
			var/mob/living/L = A
			visible_message(SPAN_WARNING("\The [src] crushes \the [L] under its weight!"))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				var/obj/item/organ/external/affected = pick(H.organs)
				affected.take_damage(fall_force)
			else
				if(L.mob_size <= fall_force / 5)
					L.gib()
				else
					L.health -= fall_force
					if(L.health <= 0)
						L.gib()

		if(isobj(A) && !istype(A, /obj/item/stack) && A != src)
			var/obj/O = A
			if(prob(fall_force * 0.75))
				visible_message(SPAN_WARNING("\The [src] crushes \the [O] under its weight!"))
				qdel(A)
	new /obj/structure/flora/stump/log(fall_loc)
	var/obj/item/stack/material/wood/branch/B = new(fall_loc)
	B.amount = rand(5, 8)
	new stumptype(get_turf(src))
	qdel(src)

/obj/structure/flora/stump
	name = "stump"
	desc = "Nature's chair."
	icon = 'icons/obj/wood.dmi'
	icon_state = "tree_stump"
	density = FALSE
	anchored = TRUE

/obj/structure/flora/stump/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/shovel))
		dig_up(user)
		return
	..()

/obj/structure/flora/stump/log
	name = "big log"
	desc = "A sideways tree, but dead. Chop this into useable logs!"
	anchored = FALSE
	icon_state = "timber"

/obj/structure/flora/stump/log/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/shovel)) //can't dig this up
		return
	if(I.can_woodcut())
		if(cutting)
			return
		cutting = TRUE
		var/chopsound = istype(I, /obj/item/material/twohanded/chainsaw) ? 'sound/weapons/saw/chainsawhit.ogg' : 'sound/effects/woodcutting.ogg'
		playsound(get_turf(user), chopsound, 50, 1)
		user.visible_message(SPAN_NOTICE("\The [user] begins chopping \the [src] into log sections."), SPAN_NOTICE("You begin chopping \the [src] into log sections."))
		var/chopspeed = 1
		if(istype(I, /obj/item/material/twohanded))
			var/obj/item/material/twohanded/W = I
			chopspeed = W.wielded ? 2 : 1
		if(do_after(user, 100 / chopspeed))
			user.visible_message(SPAN_NOTICE("\The [user] chops \the [src] into log sections."), SPAN_NOTICE("You chop \the [src] into log sections."))
			var/obj/item/stack/material/wood/log/L = new(get_turf(src))
			L.amount = rand(5, 8)
			qdel(src)
		cutting = FALSE
	else
		..()

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/jungle/small/patience
	name = "Patience"
	desc = "A lush and healthy tree. A small golden plaque at its base reads its name, in plain text, Patience."
	icon_state = "patiencebottom"
	density = FALSE
	layer = 3

/obj/structure/flora/tree/jungle/small/patience_top
	name = "Patience"
	desc = "A lush and healthy tree. A small golden plaque at its base reads its name, in plain text, Patience."
	icon_state = "patiencetop"
	density = TRUE
	pixel_y = -32

/obj/structure/flora/tree/jungle/small/patience/Initialize()
	. = ..()
	var/turf/T = get_step(src, NORTH)
	if(T)
		new /obj/structure/flora/tree/jungle/small/patience_top(T)

// Rocks
/obj/structure/flora/rock
	name = "rock"
	desc = "A rock."
	icon = 'icons/obj/flora/rocks_grey.dmi'
	icon_state = "basalt"

/obj/structure/flora/rock/pile
	name = "rocks"
	desc = "A pile of rocks."
	icon_state = "lavarocks"

/obj/structure/flora/rock/ice
	name = "ice"
	desc = "A large formation made of ice."
	icon = 'icons/obj/flora/ice_rocks.dmi'
	icon_state = "rock_1"

/obj/structure/flora/rock/ice/Initialize(mapload)
	. = ..()
	icon_state = "rock_[rand(1,2)]"

// Bushes, Flowers, and Grass
/obj/structure/flora/ausbushes
	name = "bush"
	desc = "A bush."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	density = FALSE

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/material/scythe))
		if(prob(50))
			new /obj/item/stack/material/wood(get_turf(src), 2)
		if(prob(40))
			new /obj/item/stack/material/wood(get_turf(src), 4)
		if(prob(10))
			var/pickberry = pick(list(/obj/item/seeds/berryseed, /obj/item/seeds/blueberryseed))
			new /obj/item/stack/material/wood(get_turf(src), 4)
			new pickberry(get_turf(src), 4)
			to_chat(user, SPAN_NOTICE("You find some seeds as you hack the bush away."))
		to_chat(user, SPAN_NOTICE("You slice at the bush!"))
		qdel(src)
		playsound(src, 'sound/effects/woodcutting.ogg', 50, TRUE)
	if(istype(W, /obj/item/material/hatchet)) // No items.
		to_chat(user, SPAN_NOTICE("You chop at the bush!"))
		qdel(src)
		playsound(src, 'sound/effects/woodcutting.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/New()
	..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/New()
	..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/New()
	..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/New()
	..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/New()
	..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/New()
	..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/New()
	..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/New()
	..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/New()
	..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/New()
	..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/New()
	..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/New()
	..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/New()
	..()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/New()
	..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/New()
	..()
	icon_state = "fullgrass_[rand(1, 3)]"