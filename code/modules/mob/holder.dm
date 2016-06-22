//Helper object for picking dionaea (and other creatures) up.
/obj/item/weapon/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/mob/held_mobs.dmi'
	slot_flags = 0
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/head.dmi')
	var/mob/living/contained = null
	var/icon_state_dead
	var/desc_dead
	var/name_dead
	var/isalive

/obj/item/weapon/holder/New()
	item_state = icon_state
	..()
	processing_objects.Add(src)

/obj/item/weapon/holder/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/holder/process()

	if(!get_holding_mob())

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		qdel(src)
	if (isalive && contained.stat == DEAD)
		held_death(1)//If we get here, it means the mob died sometime after we picked it up. We pass in 1 so that we can play its deathmessage

/obj/item/weapon/holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/weapon/holder/proc/get_holding_mob()
	//This function will return the mob which is holding this holder, or null if it's not held
	//It recurses up the hierarchy out of containers until it reaches a mob, or aturf, or hits the limit
	var/x = 0//As a safety, we'll crawl up a maximum of five layers
	var/atom/a = src
	while (x < 5)
		x++
		a = a.loc
		if (istype(a, /turf))
			return null//We must be on a table or a floor, or maybe in a wall. Either way we're not held.

		if (istype(a, /mob))
			return a
		//If none of the above are true, we must be inside a box or backpack or something. Keep recursing up.

	return null//If we get here, the holder must be buried many layers deep in nested containers. Shouldn't happen


/obj/item/weapon/holder/attack_self(mob/M as mob)

	if (contained && !(contained.stat & DEAD))
		if (istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			switch(H.a_intent)
				if(I_HELP)
					H.visible_message("\blue [H] pets [contained]")

				if(I_HURT)
					contained.adjustBruteLoss(5)
					H.visible_message("\red [H] crushes [contained]")
	else
		M << "[contained] is dead."


/obj/item/weapon/holder/proc/show_message(var/message, var/m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

//Mob procs and vars for scooping up
/mob/living/var/holder_type


/obj/item/weapon/holder/proc/held_death(var/show_deathmessage = 0)
	//This function is called when the mob in the holder dies somehow.
	isalive = 0

	if (icon_state_dead)
		icon_state = icon_state_dead

	if (desc_dead)
		desc = desc_dead

	if (name_dead)
		name = name_dead

	slot_flags = 0
	if (show_deathmessage)//Since we've just crushed a creature in our hands, we want everyone nearby to know that it died
		//We have to play it as a visible message on the grabber, because the normal death message played on the dying mob won't show if it's being held
		var/mob/M = get_holding_mob()
		if (M)
			M.visible_message("<b>\The [contained.name]</b> dies")
	//update_icon()


/mob/living/proc/get_scooped(var/mob/living/carbon/grabber)
	if(!holder_type || buckled || pinned.len)
		return

	if ((grabber.hand == 0 && grabber.r_hand) || (grabber.hand == 1 && grabber.l_hand))//Checking if the hand is full
		grabber << "Your hand is full!"
		return


	var/obj/item/weapon/holder/H = new holder_type(loc)
	src.loc = H
	H.name = loc.name
	H.attack_hand(grabber)
	H.contained = src

	if (src.stat == DEAD)
		H.held_death()//We've scooped up an animal that's already dead. use the proper dead icons
	else
		H.isalive = 1//We note that the mob is alive when picked up. If it dies later, we can know that its death happened while held, and play its deathmessage for it

	grabber << "You scoop up [src]."
	src << "[grabber] scoops you up."
	grabber.status_flags |= PASSEMOTES
	return

//Mob specific holders.
//w_class mainly determines whether they can fit in trashbags. <=2 can, >=3 cannot
/obj/item/weapon/holder/diona
	name = "diona nymph"
	desc = "It's a little plant critter."
	desc_dead = "It used to be a little plant critter."
	icon_state = "nymph"
	icon_state_dead = "nymph_dead"
	origin_tech = "magnets=3;biotech=5"
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING
	w_class = 2




/obj/item/weapon/holder/drone
	name = "maintenance drone"
	desc = "It's a small maintenance robot."
	icon_state = "drone"
	origin_tech = "magnets=3;engineering=5"
	slot_flags = SLOT_HEAD
	w_class = 2

/obj/item/weapon/holder/cat
	name = "cat"
	desc = "It's a cat. Meow."
	desc_dead = "It's a dead cat."
	icon_state = "cat_tabby"
	icon_state_dead = "cat_tabby_dead"
	origin_tech = null
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/weapon/holder/cat/black
	icon_state = "cat_black"
	icon_state_dead = "cat_black_dead"
	slot_flags = SLOT_HEAD

/obj/item/weapon/holder/cat/kitten
	name = "kitten"
	icon_state = "cat_kitten"
	icon_state_dead = "cat_kitten_dead"
	slot_flags = SLOT_HEAD
	w_class = 1


/obj/item/weapon/holder/borer
	name = "cortical borer"
	desc = "It's a slimy brain slug. Gross."
	icon_state = "brainslug"
	origin_tech = "biotech=6"
	w_class = 1

/obj/item/weapon/holder/monkey
	name = "monkey"
	desc = "It's a monkey. Ook."
	icon_state = "monkey"
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/weapon/holder/monkey/farwa
	name = "farwa"
	desc = "It's a farwa."
	icon_state = "farwa"
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/weapon/holder/monkey/stok
	name = "stok"
	desc = "It's a stok. stok."
	icon_state = "stok"
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/weapon/holder/monkey/neaera
	name = "neaera"
	desc = "It's a neaera."
	icon_state = "neaera"
	slot_flags = SLOT_HEAD
	w_class = 3

//Holders for mice
/obj/item/weapon/holder/mouse
	name = "mouse"
	desc = "It's a fuzzy little critter."
	desc_dead = "It's filthy vermin, throw it in the trash."
	icon_state = "mouse_brown"
	icon_state_dead = "mouse_brown_dead"
	origin_tech = "biotech=2"
	w_class = 1


/obj/item/weapon/holder/mouse/white
	icon_state = "mouse_white"
	icon_state_dead = "mouse_white_dead"

/obj/item/weapon/holder/mouse/gray
	icon_state = "mouse_gray"
	icon_state_dead = "mouse_gray_dead"

/obj/item/weapon/holder/mouse/brown
	icon_state = "mouse_brown"
	icon_state_dead = "mouse_brown_dead"


//Lizards

/obj/item/weapon/holder/lizard
	name = "lizard"
	desc = "It's a hissy little lizard. Is it related to Unathi?"
	desc_dead = "It doesn't hiss anymore"
	icon_state_dead = "lizard_dead"
	icon_state = "lizard"
	origin_tech = "null"
	slot_flags = 0
	w_class = 1

//Chicks and chickens
/obj/item/weapon/holder/chick
	name = "chick"
	desc = "It's a fluffy little chick, until it grows up."
	desc_dead = "How could you do this? You monster!"
	icon_state_dead = "chick_dead"
	origin_tech = "null"
	slot_flags = 0
	icon_state = "chick"
	w_class = 1


/obj/item/weapon/holder/chicken
	name = "chicken"
	desc = "It's a feathery, tasty-looking chicken."
	desc_dead = "Now it's ready for plucking and cooking!"
	icon_state = "chicken_brown"
	icon_state_dead = "chicken_brown_dead"
	origin_tech = "null"
	slot_flags = 0
	w_class = 2

/obj/item/weapon/holder/chicken/brown
	icon_state = "chicken_brown"
	icon_state_dead = "chicken_brown_dead"

/obj/item/weapon/holder/chicken/black
	icon_state = "chicken_black"
	icon_state_dead = "chicken_black_dead"

/obj/item/weapon/holder/chicken/white
	icon_state = "chicken_white"
	icon_state_dead = "chicken_white_dead"



//Mushroom
/obj/item/weapon/holder/mushroom
	name = "walking mushroom"
	name_dead = "mushroom"
	desc = "It's a massive mushroom... with legs?"
	desc_dead = "Shame, he was a really fun-guy."
	icon_state = "mushroom"
	icon_state_dead = "mushroom_dead"
	origin_tech = "null"
	slot_flags = SLOT_HEAD
	w_class = 2



