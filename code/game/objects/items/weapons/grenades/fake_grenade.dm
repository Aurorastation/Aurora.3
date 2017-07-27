/obj/item/weapon/grenade/fake
	icon_state = "frag"

/obj/item/weapon/grenade/fake/prime()
	active = 0
	playsound(src.loc, get_sfx("explosion"), 50, 1, 30)