/obj/item/grenade/dynamite
	name = "dynamite"
	desc = "A bundle of Adhomian dynamite."
	icon_state = "dynamite"
	item_state = "dynamite"
	activation_sound = 'sound/items/flare.ogg'

/obj/item/grenade/dynamite/attack_self(mob/user)
	return

/obj/item/grenade/dynamite/attackby(obj/item/attacking_item, mob/user)
	..()
	if(active)
		return

	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.isOn())
			activate(user)

	else if(attacking_item.isFlameSource())
		activate(user)

	else if(istype(attacking_item, /obj/item/flame/candle))
		var/obj/item/flame/candle/C = attacking_item
		if(C.lit)
			activate(user)

	else if(istype(attacking_item, /obj/item/grenade/dynamite))
		var/obj/item/grenade/dynamite/C = attacking_item
		if(C.active)
			activate(user)


/obj/item/grenade/dynamite/activate(mob/user)
	..()
	user.visible_message(SPAN_DANGER("\The [user] lights \the [src]!"))
	if(iscarbon(user))
		user.swap_hand()
		var/mob/living/carbon/C = user
		C.throw_mode_on()

/obj/item/grenade/dynamite/prime()
	var/turf/O = get_turf(src)
	explosion(O, -1, -1, 3, 4)
	qdel(src)
	return


/obj/item/grenade/dynamite/throw_impact(atom/hit_atom)
	..()
	if(!active)
		if(prob(25))
			prime()

/obj/item/grenade/dynamite/ex_act(var/severity = 2.0)
	if(!active)
		prime()

/obj/item/grenade/dynamite/fire_act()
	if(!active)
		prime()
