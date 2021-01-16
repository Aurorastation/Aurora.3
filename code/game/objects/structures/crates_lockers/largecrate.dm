/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "densecrate"
	density = 1

/obj/structure/largecrate/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>You need a crowbar to pry this open!</span>")
	return

/obj/structure/largecrate/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iscrowbar())
		new /obj/item/stack/material/wood(src)
		var/turf/T = get_turf(src)
		for(var/atom/movable/AM in contents)
			if(AM.simulated) AM.forceMove(T)
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		for(var/obj/vehicle/V in T.contents)
			if(V)
				V.unload(user)
		qdel(src)
	else
		return attack_hand(user)

/obj/structure/largecrate/mule
	name = "MULE crate"

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

/obj/structure/largecrate/animal/adhomai
	name = "adhomian animal crate"
	held_type = /mob/living/simple_animal/ice_tunneler

/obj/structure/largecrate/animal/adhomai/fatshouter
	held_type = /mob/living/simple_animal/fatshouter

/obj/structure/largecrate/animal/adhomai/rafama
	held_type = /mob/living/simple_animal/hostile/retaliate/rafama

/obj/structure/largecrate/animal/adhomai/schlorrgo
	held_type = /mob/living/simple_animal/schlorrgo

/obj/structure/largecrate/animal/hakhma
	name = "hakhma crate"
	held_type = /mob/living/simple_animal/hakhma