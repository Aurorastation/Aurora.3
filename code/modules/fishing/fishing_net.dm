/obj/item/material/fishing_net
	name = "fishing net"
	desc = "A crude fishing net."
	icon = 'icons/obj/items.dmi'
	icon_state = "net"
	item_state = "net"
	desc_extended = "This object can be used to capture certain creatures easily, most commonly fish. \
	It has a reach of two tiles, and can be emptied by activating it in-hand."

	var/empty_state = "net"
	var/contain_state = "net_full"

	w_class = ITEMSIZE_SMALL
	item_flags = NOBLUDGEON

	slowdown = 0.5

	reach = 2

	default_material = "cloth"

	var/list/accepted_mobs = list(/mob/living/simple_animal/fish)

/obj/item/material/fishing_net/Initialize()
	. = ..()
	update_icon()

/obj/item/material/fishing_net/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(get_dist(get_turf(src), A) > reach)
		return

	if(istype(A, /obj/structure))
		var/mob/living/Target
		for(var/type in accepted_mobs)
			Target = locate(type) in A.contents
			if(Target)
				afterattack(Target, user, proximity)
				break

	if(istype(A, /mob))
		var/accept = FALSE
		for(var/D in accepted_mobs)
			if(istype(A, D))
				accept = TRUE
		for(var/atom/At in src.contents)
			if(isliving(At))
				to_chat(user, "<span class='notice'>Your net is already holding something!</span>")
				accept = FALSE
		if(!accept)
			to_chat(user, "<span class='filter_notice'>[A] can't be trapped in \the [src].</span>")
			return
		var/mob/L = A
		user.visible_message("<span class='notice'>[user] snatches [L] with \the [src].</span>", "<span class='notice'>You snatch [L] with \the [src].</span>")
		L.forceMove(src)
		update_icon()
		update_weight()
		return
	return ..()

/obj/item/material/fishing_net/attack_self(var/mob/user)
	for(var/mob/M in src)
		M.forceMove(get_turf(src))
		user.visible_message("<span class='notice'>[user] releases [M] from \the [src].</span>", "<span class='notice'>You release [M] from \the [src].</span>")
	for(var/obj/item/I in src)
		I.forceMove(get_turf(src))
		user.visible_message("<span class='notice'>[user] dumps \the [I] out of \the [src].</span>", "<span class='notice'>You dump \the [I] out of \the [src].</span>")
	update_icon()
	update_weight()
	return

/obj/item/material/fishing_net/attackby(var/obj/item/W, var/mob/user)
	if(contents)
		for(var/mob/living/L in contents)
			if(prob(25))
				L.attackby(W, user)
	..()

/obj/item/material/fishing_net/update_icon()
	underlays.Cut()
	cut_overlays()

	..()

	name = initial(name)
	desc = initial(desc)
	var/contains_mob = FALSE
	for(var/mob/M in src)
		var/image/victim = image(M.icon, M.icon_state)
		underlays += victim
		name = "filled net"
		desc = "A net with [M] inside."
		contains_mob = TRUE

	if(contains_mob)
		icon_state = contain_state

	else
		icon_state = empty_state

	return

/obj/item/material/fishing_net/proc/update_weight()
	if(icon_state == contain_state)
		slowdown = initial(slowdown) * 2
		reach = 1
	else
		slowdown = initial(slowdown)
		reach = initial(reach)
