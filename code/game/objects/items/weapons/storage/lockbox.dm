//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = 4
	max_w_class = 3
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	req_access = list(access_armory)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


			if(src.broken)
				user << "<span class='warning'>It appears to be broken.</span>"
				return
			if(src.allowed(user))
				src.locked = !( src.locked )
				if(src.locked)
					src.icon_state = src.icon_locked
					user << "<span class='notice'>You lock \the [src]!</span>"
					return
				else
					src.icon_state = src.icon_closed
					user << "<span class='notice'>You unlock \the [src]!</span>"
					return
			else
				user << "<span class='warning'>Access Denied</span>"
			if(emag_act(INFINITY, user, W, "The locker has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
				W:spark_system.queue()
				playsound(src.loc, "sparks", 50, 1)
		if(!locked)
			..()
		else
			user << "<span class='warning'>It's locked!</span>"
		return


	show_to(mob/user as mob)
		if(locked)
			user << "<span class='warning'>It's locked!</span>"
		else
			..()
		return

	if(!broken)
		if(visual_feedback)
			visual_feedback = "<span class='warning'>[visual_feedback]</span>"
		else
			visual_feedback = "<span class='warning'>The locker has been sliced open by [user] with an electromagnetic card!</span>"
		if(audible_feedback)
			audible_feedback = "<span class='warning'>[audible_feedback]</span>"
		else
			audible_feedback = "<span class='warning'>You hear a faint electrical spark.</span>"

		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		visible_message(visual_feedback, audible_feedback)
		return 1

	name = "lockbox of loyalty implants"
	req_access = list(access_security)

	New()
		..()


	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)

	New()
		..()

	name = "Weapons lockbox"
	req_access = list(access_armory)

	New()
		..()

	name = "medal box"
	desc = "A locked box used to store medals."
	icon_state = "medalbox+l"
	item_state = "syringe_kit"
	w_class = 3
	max_w_class = 2
	req_access = list(access_captain)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"

	..()
	new /obj/item/clothing/accessory/medal/conduct(src)
	new /obj/item/clothing/accessory/medal/conduct(src)
	new /obj/item/clothing/accessory/medal/conduct(src)
	new /obj/item/clothing/accessory/medal/bronze_heart(src)
	new /obj/item/clothing/accessory/medal/bronze_heart(src)
	new /obj/item/clothing/accessory/medal/nobel_science(src)
	new /obj/item/clothing/accessory/medal/nobel_science(src)
	new /obj/item/clothing/accessory/medal/iron/merit(src)
	new /obj/item/clothing/accessory/medal/iron/merit(src)
	new /obj/item/clothing/accessory/medal/silver/valor(src)
	new /obj/item/clothing/accessory/medal/silver/security(src)
	new /obj/item/clothing/accessory/medal/silver/security(src)
