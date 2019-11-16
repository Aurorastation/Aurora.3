/obj/item/grenade/fake
	name = "fragmentation grenade"
	desc = "A military fragmentation grenade, designed to explode in a deadly shower of fragments, this one is just a toy however."
	icon_state = "frag"
	fake = TRUE

/obj/item/grenade/fake/prime()
	active = 0
	playsound(src.loc, get_sfx("explosion"), 50, 1, 30)
	icon_state = "frag"
