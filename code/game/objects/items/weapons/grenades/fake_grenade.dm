/obj/item/weapon/grenade/fake
	name = "fragmentation grenade"
	icon_state = "frag"

/obj/item/weapon/grenade/fake/prime()
	active = 0
	playsound(src.loc, get_sfx("explosion"), 50, 1, 30)