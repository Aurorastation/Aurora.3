/obj/item/watertank
	name = "backpack water tank"
	desc = "A watertank backpack with nozzle to clean dirt and graffiti."
	icon = 'icons/obj/hydro_equipment.dmi'
	icon_state = "waterpack"
	item_state = "waterpack"
	contained_sprite = 1
	w_class = 3
	slot_flags = SLOT_BACK
	slowdown = 1

	var/obj/item/weapon/reagent_containers/spray/noz
	var/on = FALSE
	var/volume = 500

/obj/item/watertank/New()
	..()
	create_reagents(volume)
	noz = make_noz()

/obj/item/watertank/ui_action_click()
	toggle_mister()

/obj/item/watertank/verb/toggle_mister()
	set name = "Toggle Mister"
	set category = "Object"
	var/mob/living/carbon/human/user
	if(istype(usr,/mob/living/carbon/human))
		user = usr
	else
		return
	if(!user)
		return
	if (user.back!= src)
		to_chat(user, "<span class='warning'>The watertank must be worn properly to use!</span>")
		return
	if(user.incapacitated())
		return
	on = !on
	if(on)
		if(noz == null)
			noz = make_noz()

		//Detach the nozzle into the user's hands
		if(!user.put_in_hands(noz))
			on = FALSE
			to_chat(user, "<span class='warning'>You need a free hand to hold the mister!</span>")
			return
		noz.loc = user
	else
		//Remove from their hands and put back "into" the tank
		remove_noz()
	return

/obj/item/watertank/proc/make_noz()
	return new /obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor(src)

/obj/item/watertank/equipped(mob/user, slot)
	..()
	if(slot != slot_back)
		remove_noz()

/obj/item/watertank/proc/remove_noz()
	if(ismob(noz.loc))
		var/mob/M = noz.loc
		M.drop_from_inventory(noz)
		noz.loc = src
	return

/obj/item/watertank/Destroy()
	qdel(noz)
	return ..()

/obj/item/watertank/attackby(obj/item/W, mob/user, params)
	if(W == noz)
		remove_noz()
		return 1
	else
		return ..()

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister
	name = "water mister"
	desc = "A mister nozzle attached to a water tank."
	icon = 'icons/obj/hydro_equipment.dmi'
	icon_state = "mister"
	item_state = "mister"
	contained_sprite = 1
	w_class = 3
	amount_per_transfer_from_this = 50
	volume = 500
	slot_flags = 0

	var/obj/item/watertank/tank

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor/New(parent_tank)
	..()
	if(check_tank_exists())
		tank = parent_tank
		reagents = tank.reagents	//This mister is really just a proxy for the tank's reagents
		loc = tank
	return

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor/dropped(mob/user)
	..()
	to_chat(user, "<span class='notice'>The mister snaps back onto the watertank.</span>")
	tank.on = 0
	loc = tank

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor/attack_self()
	return

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/proc/check_tank_exists()
	if (!tank || !istype(tank, /obj/item/watertank))	//To avoid weird issues from admin spawns
		qdel(src)
		return 0
	else
		return 1

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor/Move()
	..()
	if(loc != tank.loc)
		loc = tank.loc

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor/afterattack(obj/target, mob/user, proximity)
	if(target.loc == loc) //Safety check so you don't fill your mister with mutagen or something and then blast yourself in the face with it
		return
	..()

//Janitor tank
/obj/item/watertank/janitor
	name = "backpack water tank"
	desc = "A janitorial watertank backpack with nozzle to clean dirt and graffiti."
	icon_state = "waterpackjani"
	item_state = "waterpackjani"

/obj/item/watertank/janitor/New()
	..()
	reagents.add_reagent("cleaner", 500)

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor
	name = "janitor spray nozzle"
	desc = "A janitorial spray nozzle attached to a watertank, designed to clean up large messes."
	icon_state = "misterjani"
	item_state = "misterjani"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()

/obj/item/watertank/janitor/make_noz()
	return new /obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor(src)

/obj/item/weapon/reagent_containers/spray/chemsprayer/mister/janitor/attack_self(var/mob/user)
	amount_per_transfer_from_this = (amount_per_transfer_from_this == 10 ? 5 : 10)
	to_chat(user, "<span class='notice'>You [amount_per_transfer_from_this == 10 ? "remove" : "fix"] the nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>")
