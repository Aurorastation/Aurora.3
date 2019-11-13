/obj/item/clothing/accessory/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	slot = "utility"
	var/slots = 3
	var/obj/item/storage/internal/hold
	w_class = 3.0

/obj/item/clothing/accessory/storage/Initialize()
	. = ..()
	hold = new/obj/item/storage/internal(src)
	hold.storage_slots = slots
	hold.max_storage_space = 12
	hold.max_w_class = 2

/obj/item/clothing/accessory/storage/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		hold.open(user)
		return

	if (hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		..(user)

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object as obj)
	if (has_suit)
		return

	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W as obj, mob/user as mob)
	return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	hold.emp_act(severity)
	..()

/obj/item/clothing/accessory/storage/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You empty [src].</span>")
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	src.add_fingerprint(user)

/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon_state = "webbing"

/obj/item/clothing/accessory/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"
	slots = 5

/obj/item/clothing/accessory/storage/brown_vest
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon_state = "vest_brown"
	slots = 5

/obj/item/clothing/accessory/storage/white_vest
	name = "white webbing vest"
	desc = "Durable white synthcotton vest with lots of pockets to carry essentials."
	icon_state = "vest_white"
	slots = 5

/obj/item/clothing/accessory/storage/overalls
	name = "overalls"
	desc = "Heavy-duty overalls for use on the work site, with plenty of convenient pockets to boot."
	icon_state = "mining_overalls"
	overlay_state = "mining_overalls"
	slots = 5

/obj/item/clothing/accessory/storage/overalls/mining
	name = "shaft miner's overalls"
	desc = "Heavy-duty overalls. Ostensibly for your protection, not vacuum-rated. Comes with convenient pockets for miscellaneous tools."


/obj/item/clothing/accessory/storage/overalls/engineer
	name = "engineer's overalls"
	desc = "Heavy-duty overalls to keep all your extra tools and notes in place, and keep the inevitable oil off your jumpsuit."
	icon_state = "engineering_overalls"
	overlay_state = "engineering_overalls"

/obj/item/clothing/accessory/storage/overalls/chief
	name = "chief engineer's overalls"
	desc = "Heavy duty overalls, bleached white to signify a \"Chief Engineer.\" Keeping them clean until the end of shift is a challenge unto itself."
	icon_state = "ce_overalls"
	overlay_state = "ce_overalls"

/obj/item/clothing/accessory/storage/pouches
	name = "drop pouches"
	desc = "Synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_brown" //todo: get a different sprite for it
	overlay_state = "thigh_brown"


/obj/item/clothing/accessory/storage/pouches/verb/flip_side()
	set category = "Object"
	set name = "Flip drop pouches"
	set src in usr

	if (use_check_and_message(usr))
		return
	if (!flippable)
		to_chat(usr, "You cannot flip \the [src] as it is not a flippable item.")
		return

	src.flipped = !src.flipped
	if(src.flipped)
		if(!overlay_state)
			src.icon_state = "[icon_state]_flip"
		else
			src.overlay_state = "[overlay_state]_flip"
	else
		if(!overlay_state)
			src.icon_state = initial(icon_state)
		else
			src.overlay_state = initial(overlay_state)
	to_chat(usr, "You change \the [src] to be on your [src.flipped ? "left" : "right"] side.")
	update_clothing_icon()
	src.inv_overlay = null
	src.mob_overlay = null

/obj/item/clothing/accessory/storage/pouches/black
	name = "black drop pouches"
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_black"
	overlay_state = "thigh_black"
	slots = 5

/obj/item/clothing/accessory/storage/pouches/brown
	name = "brown drop pouches"
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_brown"
	overlay_state = "thigh_brown"
	slots = 5

/obj/item/clothing/accessory/storage/pouches/white
	name = "white drop pouches"
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_white"
	overlay_state = "thigh_white"
	slots = 5

/obj/item/clothing/accessory/storage/pouches/colour
	icon_state = "thigh_colour"
	overlay_state = "thigh_white"

/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife-loops."
	icon_state = "unathiharness2"
	slots = 2

/obj/item/clothing/accessory/storage/knifeharness/Initialize()
	. = ..()
	hold.max_storage_space = 4
	hold.can_hold = list(
		/obj/item/material/hatchet/unathiknife,
		/obj/item/material/kitchen/utensil/knife,
		/obj/item/material/kitchen/utensil/knife/plastic,
		/obj/item/material/knife,
		/obj/item/material/knife/ritual
	)

	new /obj/item/material/hatchet/unathiknife(hold)
	new /obj/item/material/hatchet/unathiknife(hold)

/obj/item/clothing/accessory/storage/bayonet
	name = "bayonet sheath"
	desc = "A leather sheath designated to hold a bayonet."
	icon_state = "holster_machete"
	slots = 1

/obj/item/clothing/accessory/storage/bayonet/Initialize()
	. = ..()
	hold.max_storage_space = 4
	hold.max_w_class = 3
	hold.can_hold = list(
		/obj/item/material/knife/bayonet
	)

	new /obj/item/material/knife/bayonet(hold)

/obj/item/clothing/accessory/storage/bandolier
	name = "bandolier"
	desc = "A pocketed belt designated to hold shotgun shells."
	icon_state = "bandolier"
	item_state = "bandolier"
	slots = 16

/obj/item/clothing/accessory/storage/bandolier/Initialize()
	. = ..()
	hold.max_storage_space = 16
	hold.can_hold = list(
		/obj/item/ammo_casing/shotgun
	)