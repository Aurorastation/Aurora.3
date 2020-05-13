/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back."
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = TRUE
	unacidable = TRUE
	anchored = 1.0
	var/spawnable = null

/obj/effect/gateway/CollidedWith(mob/M)
	return

/obj/effect/gateway/Crossed(AM as mob|obj)
	return

/obj/effect/gateway/active
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/creature,
		/mob/living/simple_animal/hostile/faithless
	)

/obj/effect/gateway/active/cult
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/creature/cult,
		/mob/living/simple_animal/hostile/faithless/cult
	)
	appearance_flags = NO_CLIENT_COLOR

/obj/effect/gateway/active/cult/cultify()
	return

/obj/effect/gateway/active/New()
	addtimer(CALLBACK(src, .proc/do_spawn), rand(30, 60) SECONDS)

/obj/effect/gateway/active/proc/do_spawn()
	var/thing = pick(spawnable)
	new thing(src.loc)
	qdel(src)

/obj/effect/gateway/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/nullrod))
		to_chat(user, "<span class='notice'>You touch \the [src] with \the [I], closing the path to the otherworld.</span>")
		qdel(src)