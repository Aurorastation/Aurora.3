/obj/item/watertank
	name = "backpack water tank"
	desc = "A watertank backpack with nozzle to water plants."
	icon = 'icons/obj/hydro_equipment.dmi'
	icon_state = "waterpack"
	item_state = "waterpack"
	contained_sprite = 1
	w_class = 3
	slot_flags = SLOT_BACK

	var/obj/item/reagent_containers/spray/chemsprayer/mister/noz
	var/on = FALSE
	var/volume = 500

/obj/item/watertank/Initialize()
	. = ..()
	create_reagents(volume)
	noz = make_noz()
	noz.tank = src
	noz.reagents = reagents
	noz.forceMove(src)

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
	if(use_check_and_message(user))
		return
	on = !on
	if(on)
		if(!noz)
			noz = make_noz()
			noz.tank = src
			noz.reagents = reagents
			noz.forceMove(src)

		//Detach the nozzle into the user's hands
		if(!user.put_in_hands(noz))
			on = FALSE
			to_chat(user, "<span class='warning'>You need a free hand to hold the mister!</span>")
			return
		noz.forceMove(user)
	else
		//Remove from their hands and put back "into" the tank
		remove_noz()
	return

/obj/item/watertank/proc/make_noz()
	return new /obj/item/reagent_containers/spray/chemsprayer/mister()

/obj/item/watertank/equipped(mob/user, slot)
	..()
	if(slot != slot_back)
		remove_noz()

/obj/item/watertank/proc/remove_noz()
	if(!noz)
		noz = make_noz()
		noz.tank = src
		noz.reagents = reagents
		noz.forceMove(src)
	if(ismob(noz.loc))
		var/mob/M = noz.loc
		M.drop_from_inventory(noz,src)
	return

/obj/item/watertank/Destroy()
	qdel(noz)
	noz = null
	return ..()

/obj/item/watertank/attackby(obj/item/W, mob/user, params)
	if(W == noz)
		remove_noz()
		return 1
	else
		return ..()

/obj/item/reagent_containers/spray/chemsprayer/mister
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

/obj/item/reagent_containers/spray/chemsprayer/mister/dropped(mob/user)
	..()
	to_chat(user, "<span class='notice'>The mister snaps back onto the watertank.</span>")
	tank.on = 0
	forceMove(tank)

/obj/item/reagent_containers/spray/chemsprayer/mister/attack_self()
	return

/obj/item/reagent_containers/spray/chemsprayer/mister/Move()
	..()
	if(loc != tank.loc)
		forceMove(tank.loc)

/obj/item/reagent_containers/spray/chemsprayer/mister/afterattack(obj/target, mob/user, proximity)
	if(target.loc == loc) //Safety check so you don't fill your mister with mutagen or something and then blast yourself in the face with it
		return
	..()

//Janitor tank
/obj/item/watertank/janitor
	name = "backpack water tank"
	desc = "A janitorial watertank backpack with nozzle to clean dirt and graffiti."
	icon_state = "waterpackjani"
	item_state = "waterpackjani"

/obj/item/watertank/janitor/Initialize()
	. = ..()
	reagents.add_reagent("cleaner", 500)

/obj/item/reagent_containers/spray/chemsprayer/mister/janitor
	name = "janitor spray nozzle"
	desc = "A janitorial spray nozzle attached to a watertank, designed to clean up large messes."
	icon_state = "misterjani"
	item_state = "misterjani"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()

/obj/item/watertank/janitor/make_noz()
	return new /obj/item/reagent_containers/spray/chemsprayer/mister/janitor(src)

/obj/item/reagent_containers/spray/chemsprayer/mister/janitor/attack_self(var/mob/user)
	amount_per_transfer_from_this = (amount_per_transfer_from_this == 10 ? 5 : 10)
	to_chat(user, "<span class='notice'>You [amount_per_transfer_from_this == 10 ? "remove" : "fix"] the nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>")
