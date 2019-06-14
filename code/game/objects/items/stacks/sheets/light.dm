/obj/item/stack/light_w
	name = "wired glass tile"
	singular_name = "wired glass floor tile"
	desc = "A glass tile, which is wired, somehow."
	icon = 'icons/obj/stacks/tiles.dmi'
	icon_state = "glass_wire"
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	max_amount = 60

/obj/item/stack/light_w/attackby(var/obj/O, mob/user as mob)
	if(istype(O, /obj/item/stack/material/steel))
		var/obj/item/stack/material/steel/M = O
		if (M.use(1))
			var/obj/item/L = new /obj/item/stack/tile/light
			user.drop_from_inventory(L,get_turf(src))
			to_chat(user, "<span class='notice'>You make a light tile.</span>")
			use(1)
		else
			to_chat(user, "<span class='warning'>You need one metal sheet to finish the light tile!</span>")

	else if(istype(O, /obj/item/weapon/wirecutters))
		user.drop_from_inventory(O,get_turf(src))
		to_chat(user, "<span class='notice'>You detach the wire from the [name].</span>")
		new /obj/item/stack/cable_coil(user.loc, 5)
		new /obj/item/stack/material/glass(user.loc, 1)
		use(1)
	else
		return ..()