/obj/item/weapon/key/soldier
	name = "fortress key"
	key_data = "soldier"

/obj/item/weapon/key/hand
	name = "commander key"
	key_data = "captain"

/obj/item/weapon/key/armory
	name = "armory key"
	key_data = "armory"

/obj/item/weapon/key/mayor
	name = "governor key"
	key_data = "mayor"

/obj/item/weapon/key/bar
	name = "bar key"
	key_data = "bar"

/obj/item/weapon/key/cell
	name = "cell key"
	key_data = "cell"

/obj/item/weapon/key/chief
	name = "constable chief key"
	key_data = "chief"

/obj/item/weapon/key/medical
	name = "clinic key"
	key_data = "medical"

/obj/item/weapon/key/blacksmith
	name = "blacksmith key"
	key_data = "blacksmith"

/obj/item/weapon/key/trader
	name = "trader key"
	key_data = "merchant"

/obj/item/weapon/key/inn
	name = "inn keys"
	key_data = "inn"

/obj/item/weapon/key/inn/attack_self(mob/user as mob)
	switch(key_data)
		if("inn")
			key_data = "room one"

		if("room one")
			key_data = "room two"

		if("room two")
			key_data = "room three"

		if("room three")
			key_data = "room four"

		if("room four")
			key_data = "inn"
	to_chat(usr, "<span class='info'>You select the [lowertext(key_data)] key.</span>")
