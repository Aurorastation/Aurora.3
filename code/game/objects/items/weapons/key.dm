/obj/item/weapon/key
	name = "key"
	desc = "A keyring with a key."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "key1"
	//If not a standard key, offset the keyfob overlay here.
	var/fob_offset_x = 0
	var/fob_offset_y = 0
	var/obj/item/weapon/keyfob/has_keyfob = null
	w_class = 1

/obj/item/weapon/key/attackby(var/obj/item/weapon/keyfob/A, mob/user)
	if(!istype(A))
		return
	else if(has_keyfob)
		to_chat(user, "<span class='warning'>The keyring already has a keyfob!</span>")
		return
	to_chat(user, "<span class='notice'>You add the [has_keyfob.name] to the keyring.</span>")
	user.drop_from_inventory(A)
	A.forceMove(src)
	has_keyfob = A
	add_keyfob(A)

/obj/item/weapon/key/attack_self(mob/user)
	if(has_keyfob)
		to_chat(user, "<span class='notice'>You remove the [has_keyfob.name] from the keyring.</span>")
		has_keyfob.forceMove(get_turf(src))
		has_keyfob = null
		cut_overlays()
	else
		to_chat(user, "<span class='warning'>The keyring has no keyfob!</span>")

/obj/item/weapon/key/proc/add_keyfob(var/obj/item/weapon/keyfob/A)
	var/image/keyfob_overlay = image('icons/obj/vehicles.dmi', A.icon_state)
	keyfob_overlay.pixel_x = src.fob_offset_x + A.fob_offset_x
	keyfob_overlay.pixel_y = src.fob_offset_y + A.fob_offset_y
	add_overlay(keyfob_overlay)

/obj/item/weapon/key/janicart
	desc = "A keyring with a key for a janitor's cart."

/obj/item/weapon/key/cargo_train
	desc = "A keyring with a key for a cargo train."

/obj/item/weapon/key/minecarts
	desc = "A keyring with a key for a mining engine."


/obj/item/weapon/keyfob
	name = "keyfob"
	desc = "It's a keyfob that can attach to a keyring."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon_keyfob"
	//If the keyfob's connection point is not (8,10) on a 32x32 canvas, offset it to that point using these vars.
	var/fob_offset_x = 0
	var/fob_offset_y = 0
	w_class = 1

/obj/item/weapon/keyfob/pussy_wagon
	name = "Pussy Wagon keyfob"
	desc = "It's a keyfob that reads 'Pussy Wagon'."

/obj/item/weapon/keyfob/pickaxe
	name = "pickaxe keyfob"
	desc = "It's a keyfob that's shaped like a pickaxe."
	icon_state = "mine_keyfob"

/obj/item/weapon/keyfob/choo_choo
	name = "choo choo keyfob"
	desc = "It's a keyfob that reads 'Choo Choo!'."
	icon_state = "train_keyfob"