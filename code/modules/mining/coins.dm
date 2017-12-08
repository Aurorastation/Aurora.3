/*****************************Coin********************************/

	icon = 'icons/obj/items.dmi'
	name = "Coin"
	icon_state = "coin"
	flags = CONDUCT
	force = 0.0
	throwforce = 0.0
	w_class = 1.0
	slot_flags = SLOT_EARS
	var/string_attached
	var/sides = 2

	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

	name = "gold coin"
	icon_state = "coin_gold"

	name = "silver coin"
	icon_state = "coin_silver"

	name = "diamond coin"
	icon_state = "coin_diamond"

	name = "iron coin"
	icon_state = "coin_iron"

	name = "solid phoron coin"
	icon_state = "coin_phoron"

	name = "uranium coin"
	icon_state = "coin_uranium"

	name = "platinum coin"
	icon_state = "coin_adamantine"

	if(iscoil(W))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			user << "<span class='notice'>There already is a string attached to this coin.</span>"
			return
		if (CC.use(1))
			overlays += image('icons/obj/items.dmi',"coin_string_overlay")
			string_attached = 1
			user << "<span class='notice'>You attach a string to the coin.</span>"
		else
			user << "<span class='notice'>This cable coil appears to be empty.</span>"
		return
	else if(iswirecutter(W))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.update_icon()
		overlays = list()
		string_attached = null
		user << "<span class='notice'>You detach the string from the coin.</span>"
	else ..()

	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	playsound(src.loc, 'sound/items/coinflip.ogg', 100, 1, -4)
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")
