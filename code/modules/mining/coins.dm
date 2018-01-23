/*****************************Coin********************************/

/obj/item/weapon/coin
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

/obj/item/weapon/coin/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/weapon/coin/gold
	name = "gold coin"
	icon_state = "coin_gold"

/obj/item/weapon/coin/silver
	name = "silver coin"
	icon_state = "coin_silver"

/obj/item/weapon/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"

/obj/item/weapon/coin/iron
	name = "iron coin"
	icon_state = "coin_iron"

/obj/item/weapon/coin/phoron
	name = "solid phoron coin"
	icon_state = "coin_phoron"

/obj/item/weapon/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"

/obj/item/weapon/coin/platinum
	name = "platinum coin"
	icon_state = "coin_adamantine"

/obj/item/weapon/coin/erp
	name = "erp token"
	icon_state = "erp_token"
	desc = "Put this in her slot to redeem your erp token. Good for 1 deciseconds of erp."

/obj/item/weapon/coin/erp/attack(/mob/living/carbon/human/target, /mob/living/carbon/human/user, var/target_zone)
	if(!istype(target) || !istype(user) || target_zone != "groin")
		return
	else
		user.visible_message(\
			"[user] inserts the [src] into [target]'s slot...",\
			"You insert the [src] into [target]'s slot...",\
			"You hear the distinct sound of a coin going into a vending machine..."\
		)
		playsound(target.loc, 'sound/machines/vending.ogg', 35, 1)
		user << "You have 1 decisecond of erp left with [target]."
		target << "You have 1 decisecond of erp left with [target]."
		qdel(src)
		sleep(1) //Measured in deciseconds
		user << "Your time has expired with [target]. Please insert another ERP token."
		target << "Your time has expired with [user]."

/obj/item/weapon/coin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iscoil(W))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			user << "<span class='notice'>There already is a string attached to this coin.</span>"
			return
		if (CC.use(1))
			add_overlay("coin_string_overlay")
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
		cut_overlays()
		string_attached = null
		user << "<span class='notice'>You detach the string from the coin.</span>"
	else ..()

/obj/item/weapon/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	playsound(src.loc, 'sound/items/coinflip.ogg', 100, 1, -4)
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")
