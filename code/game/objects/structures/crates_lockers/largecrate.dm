/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon_state = "densecrate"
	density = TRUE

/obj/structure/largecrate/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You need a crowbar to pry this open!"))
	return

/obj/structure/largecrate/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iscrowbar())
		new /obj/item/stack/material/wood(src)
		var/turf/T = get_turf(src)
		for(var/atom/movable/AM in contents)
			if(AM.simulated) AM.forceMove(T)
		user.visible_message(SPAN_NOTICE("[user] pries \the [src] open."), \
								SPAN_NOTICE("You pry open \the [src]."), \
								SPAN_NOTICE("You hear splitting wood."))
		for(var/obj/vehicle/V in T.contents)
			if(V)
				V.unload(user)
		qdel(src)
	else
		return attack_hand(user)

/obj/structure/largecrate/mule
	name = "MULE crate"
	icon_state = "mulecrate"

/obj/structure/largecrate/hoverpod
	name = "\improper Hoverpod assembly crate"
	desc = "It comes in a box for the fabricator's sake. Where does the wood come from? ... And why is it lighter?"
	icon_state = "mulecrate"

/obj/structure/largecrate/animal
	icon_state = "mulecrate"
	var/held_count = 1
	var/held_type

/obj/structure/largecrate/animal/Initialize()
	. = ..()
	for(var/i = 1;i<=held_count;i++)
		new held_type(src)

/obj/structure/largecrate/animal/corgi
	name = "corgi carrier"
	held_type = /mob/living/simple_animal/corgi

/obj/structure/largecrate/animal/cow
	name = "cow crate"
	held_type = /mob/living/simple_animal/cow

/obj/structure/largecrate/animal/pig
	name = "pig crate"
	held_type = /mob/living/simple_animal/pig

/obj/structure/largecrate/animal/goat
	name = "goat crate"
	held_type = /mob/living/simple_animal/hostile/retaliate/goat

/obj/structure/largecrate/animal/cat
	name = "cat carrier"
	held_type = /mob/living/simple_animal/cat

/obj/structure/largecrate/animal/cat/bones
	held_type = /mob/living/simple_animal/cat/fluff/bones

/obj/structure/largecrate/animal/chick
	name = "chicken crate"
	held_count = 5
	held_type = /mob/living/simple_animal/chick

/obj/structure/largecrate/animal/dog
	name = "dog carrier"
	held_type = /mob/living/simple_animal/hostile/commanded/dog

/obj/structure/largecrate/animal/dog/amaskan
	held_type = /mob/living/simple_animal/hostile/commanded/dog/amaskan

/obj/structure/largecrate/animal/dog/pug
	held_type = /mob/living/simple_animal/hostile/commanded/dog/pug

/obj/structure/largecrate/animal/dog/bullterrier
	name = "bull terrier carrier"
	held_type = /mob/living/simple_animal/hostile/commanded/dog/bullterrier

/obj/structure/largecrate/animal/adhomai
	name = "adhomian animal crate"
	held_type = /mob/living/simple_animal/ice_tunneler

/obj/structure/largecrate/animal/adhomai/fatshouter
	held_type = /mob/living/simple_animal/fatshouter

/obj/structure/largecrate/animal/adhomai/rafama
	held_type = /mob/living/simple_animal/hostile/retaliate/rafama

/obj/structure/largecrate/animal/adhomai/schlorrgo
	held_type = /mob/living/simple_animal/schlorrgo

/obj/structure/largecrate/animal/adhomai/harron
	held_type = /mob/living/simple_animal/hostile/commanded/dog/harron

/obj/structure/largecrate/animal/hakhma
	name = "hakhma crate"
	held_type = /mob/living/simple_animal/hakhma

/obj/structure/largecrate/animal/moghes
	name = "moghresian animal crate"
	held_type = /mob/living/simple_animal/threshbeast

/obj/structure/largecrate/animal/moghes/warmount
	held_type = /mob/living/simple_animal/hostile/retaliate/hegeranzi

/obj/structure/largecrate/animal/moghes/miervesh
	held_type = /mob/living/simple_animal/miervesh

/obj/structure/largecrate/animal/moghes/otzek
	held_type = /mob/living/simple_animal/otzek
