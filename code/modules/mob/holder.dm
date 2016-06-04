//Helper object for picking dionaea (and other creatures) up.
/obj/item/weapon/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/mob/held_mobs.dmi'
	slot_flags = null
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/head.dmi')
	var/mob/living/contained = null

/obj/item/weapon/holder/New()
	item_state = icon_state
	..()
	processing_objects.Add(src)

/obj/item/weapon/holder/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/holder/process()

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		qdel(src)

/obj/item/weapon/holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

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

	grabber << "You scoop up [src]."
	src << "[grabber] scoops you up."
	grabber.status_flags |= PASSEMOTES
	return

//Mob specific holders.
//w_class mainly determines whether they can fit in trashbags. <=2 can, >=3 cannot
/obj/item/weapon/holder/diona
	name = "diona nymph"
	desc = "It's a little plant critter."
	icon_state = "nymph"
	origin_tech = "magnets=3;biotech=5"
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING
	w_class = 2

/obj/item/weapon/holder/diona/dead
	name = "diona nymph"
	desc = "It used to be a little plant critter"
	icon_state = "nymph_dead"
	origin_tech = "magnets=3;biotech=5"
	slot_flags = null
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
	icon_state = "cat_tabby"
	origin_tech = null
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/weapon/holder/cat/dead
	name = "cat"
	desc = "It's a dead cat."
	icon_state = "cat_tabby_dead"
	origin_tech = null
	slot_flags = null
	w_class = 3

/obj/item/weapon/holder/cat/black
	icon_state = "cat_black"
	slot_flags = SLOT_HEAD

/obj/item/weapon/holder/cat/black/dead
	icon_state = "cat_black_dead"
	slot_flags = null

/obj/item/weapon/holder/cat/kitten
	name = "kitten"
	icon_state = "cat_kitten"
	slot_flags = SLOT_HEAD
	w_class = 1

/obj/item/weapon/holder/cat/kitten/dead
	icon_state = "cat_kitten_dead"
	slot_flags = null
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
	desc = "It's a fuzzy little critter"
	icon_state = "mouse_brown"
	origin_tech = "biotech=2"
	w_class = 1


/obj/item/weapon/holder/mouse/white
	icon_state = "mouse_white"

/obj/item/weapon/holder/mouse/gray
	icon_state = "mouse_gray"

/obj/item/weapon/holder/mouse/brown
	icon_state = "mouse_brown"

/obj/item/weapon/holder/deadmouse
	name = "mouse"
	desc = "It's filthy vermin, throw it in the trash"
	icon_state = "mouse_gray_dead"
	origin_tech = "null"
	w_class = 1

/obj/item/weapon/holder/deadmouse/white
	icon_state = "mouse_white_dead"

/obj/item/weapon/holder/deadmouse/gray
	icon_state = "mouse_gray_dead"

/obj/item/weapon/holder/deadmouse/brown
	icon_state = "mouse_brown_dead"

//Lizards

/obj/item/weapon/holder/lizard
	name = "lizard"
	desc = "It's a hissy little lizard. Is it related to Unathi?"
	icon_state = "lizard"
	origin_tech = "null"
	slot_flags = null
	w_class = 1

/obj/item/weapon/holder/lizard/dead
	desc = "It doesn't hiss anymore"
	icon_state = "lizard_dead"

//Chicks and chickens
/obj/item/weapon/holder/chick
	name = "chick"
	desc = "It's a fluffy little chick, until it grows up"
	origin_tech = "null"
	slot_flags = null
	icon_state = "chick"
	w_class = 1

/obj/item/weapon/holder/chick/dead
	desc = "How could you do this? You monster!"
	icon_state = "chick_dead"

/obj/item/weapon/holder/chicken
	name = "chicken"
	desc = "It's a feathery tasty-looking chicken"
	icon_state = "chicken_brown"
	origin_tech = "null"
	slot_flags = null
	w_class = 2

/obj/item/weapon/holder/chicken/brown
	icon_state = "chicken_brown"

/obj/item/weapon/holder/chicken/black
	icon_state = "chicken_black"

/obj/item/weapon/holder/chicken/white
	icon_state = "chicken_white"

/obj/item/weapon/holder/chicken/brown/dead
	desc = "Now it's ready for plucking and cooking!"
	icon_state = "chicken_brown_dead"

/obj/item/weapon/holder/chicken/black/dead
	desc = "Now it's ready for plucking and cooking!"
	icon_state = "chicken_black_dead"

/obj/item/weapon/holder/chicken/white/dead
	desc = "Now it's ready for plucking and cooking!"
	icon_state = "chicken_white_dead"


//Mushroom
/obj/item/weapon/holder/mushroom
	name = "walking mushroom"
	desc = "It's a massive mushroom... with legs?"
	icon_state = "mushroom"
	origin_tech = "null"
	slot_flags = SLOT_HEAD
	w_class = 2

/obj/item/weapon/holder/mushroom/dead
	name = "mushroom"
	desc = "Shame, he was a really fun-guy"
	icon_state = "mushroom_dead"