/obj/item/grenade/dynamite
	name = "dynamite"
	desc = "A bundle of Adhomian dynamite."
	icon_state = "dynamite"

/obj/item/grenade/dynamite/attack_self(mob/user as mob)
	return

/obj/item/grenade/dynamite/attackby(obj/item/W as obj, mob/user as mob)
	..()
	var/prepared = FALSE
	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())
			activate(user)
			to_chat(user, span("notice", "\The [user] casually lights \the [name] with [W]."))
			prepared = TRUE

	else if(isflamesource(W))
		activate(user)
		to_chat(user, span("notice", "\The [user] lights \the [name]."))
		prepared = TRUE

	else if(istype(W, /obj/item/flame/candle))
		var/obj/item/flame/candle/C = W
		if(C.lit)
			activate(user)
			to_chat(user, span("notice", "\The [user] lights \the [name]."))
			prepared = TRUE

	else if(istype(W, /obj/item/grenade/dynamite))
		var/obj/item/grenade/dynamite/C = W
		if(C.active)
			activate(user)
			to_chat(user, span("notice", "\The [user] lights \the [name]."))
			prepared = TRUE

	if(prepared)
		if(iscarbon(user))
			user.swap_hand()
			var/mob/living/carbon/C = user
			C.throw_mode_on()


/obj/item/grenade/dynamite/frag/prime()
	set waitfor = 0
	..()
	var/turf/O = get_turf(src)
	explosion(O, -1, -1, 3, 4)


/obj/item/grenade/dynamite/frag/throw_impact(atom/hit_atom)
	..()
	if(!active)
		if(prob(25))
			prime()

/obj/item/grenade/dynamite/frag/ex_act(var/severity = 2.0)
	if(!active)
		prime()


/obj/item/storage/box/dynamite
	name = "wooden crate"
	desc = "It's just an ordinary wooden crate."
	icon_state = "dynamite"
	foldable = null
	use_sound = 'sound/effects/doorcreaky.ogg'
	drop_sound = 'sound/items/drop/wooden.ogg'
	chewable = FALSE
	w_class = 4

/obj/item/storage/box/dynamite
	..()
	spill()

/obj/item/storage/box/dynamite/full
	starts_with = list(/obj/item/grenade/dynamite = 6)

