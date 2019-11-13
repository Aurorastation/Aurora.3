/*****************************Coin********************************/

/obj/item/coin
	icon = 'icons/obj/coins.dmi'
	name = "Coin"
	icon_state = "coin"
	randpixel = 8
	desc = "A flat disc or piece of metal with an official stamp. An archaic type of currency."
	flags = CONDUCT
	force = 0.0
	throwforce = 0.0
	w_class = 1.0
	slot_flags = SLOT_EARS
	var/string_attached
	var/sides = 2
	var/cmineral = null
	drop_sound = 'sound/items/drop/ring.ogg'

/obj/item/coin/New()
	randpixel_xy()

/obj/item/coin/gold
	name = "gold coin"
	icon_state = "coin_gold_heads"
	cmineral = "gold"

/obj/item/coin/silver
	name = "silver coin"
	icon_state = "coin_silver_heads"
	cmineral = "silver"

/obj/item/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond_heads"
	cmineral = "diamond"

/obj/item/coin/iron
	name = "iron coin"
	icon_state = "coin_iron_heads"
	cmineral = "iron"

/obj/item/coin/phoron
	name = "solid phoron coin"
	icon_state = "coin_phoron_heads"
	cmineral = "phoron"

/obj/item/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium_heads"
	cmineral = "uranium"

/obj/item/coin/platinum
	name = "platinum coin"
	icon_state = "coin_platinum_heads"
	cmineral = "platinum"

/obj/item/coin/platinum
	name = "mythril coin"
	icon_state = "coin_mythril_heads"
	cmineral = "mythril"

/obj/item/coin/battlemonsters
	name = "battlemonsters coin"
	icon_state = "coin_battlemonsters_heads"
	cmineral = "battlemonsters"

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iscoil())
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, "<span class='notice'>There already is a string attached to this coin.</span>")
			return
		if (CC.use(1))
			add_overlay("coin_string_overlay")
			string_attached = 1
			to_chat(user, "<span class='notice'>You attach a string to the coin.</span>")
		else
			to_chat(user, "<span class='notice'>This cable coil appears to be empty.</span>")
		return
	else if(W.iswirecutter())
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.update_icon()
		cut_overlays()
		string_attached = null
		to_chat(user, "<span class='notice'>You detach the string from the coin.</span>")
	else ..()

/obj/item/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	flick("coin_[cmineral]_flip", src)
	icon_state = "coin_[cmineral]_[comment]"
	playsound(src.loc, 'sound/items/coinflip.ogg', 100, 1, -4)
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")
