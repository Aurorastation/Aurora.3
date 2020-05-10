var/list/holder_mob_icon_cache = list()

//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/mob/npc/held_mobs.dmi'
	randpixel = 0
	center_of_mass = null
	slot_flags = 0
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/head.dmi')
	origin_tech = null
	drop_sound = null
	var/mob/living/contained = null
	var/icon_state_dead
	var/desc_dead
	var/name_dead
	var/isalive
	contained_sprite = TRUE

	var/static/list/unsafe_containers

	var/last_loc_general	//This stores a general location of the object. Ie, a container or a mob
	var/last_loc_specific	//This stores specific extra information about the location, pocket, hand, worn on head, etc. Only relevant to mobs

/obj/item/holder/proc/setup_unsafe_list()
	unsafe_containers = typecacheof(list(
		/obj/item/storage,
		/obj/item/reagent_containers,
		/obj/structure/closet/crate,
		/obj/machinery/appliance,
		/obj/machinery/microwave
	))

/obj/item/holder/Initialize()
	. = ..()
	if (!unsafe_containers)
		setup_unsafe_list()

	if (!item_state)
		item_state = icon_state

	flags_inv |= ALWAYSDRAW

	START_PROCESSING(SSprocessing, src)

/obj/item/holder/Destroy()
	reagents = null
	STOP_PROCESSING(SSprocessing, src)
	if (contained)
		release_mob()
	return ..()

/obj/item/holder/examine(mob/user)
	if (contained)
		contained.examine(user)

/obj/item/holder/attack_self()
	for(var/mob/M in contents)
		M.show_inv(usr)

/obj/item/holder/process()
	if (!contained)
		qdel(src)

	if(!get_holding_mob() || contained.loc != src)
		if (is_unsafe_container(loc) && contained.loc == src)
			return

		release_mob()

		return
	if (isalive && contained.stat == DEAD)
		held_death(1)//If we get here, it means the mob died sometime after we picked it up. We pass in 1 so that we can play its deathmessage


//This function checks if the current location is safe to release inside
//it returns 1 if the creature will bug out when released
/obj/item/holder/proc/is_unsafe_container(atom/place)
	return is_type_in_typecache(place, unsafe_containers)

//Releases all mobs inside the holder, then deletes it.
//is_unsafe_container should be checked before calling this
//This function releases mobs into wherever the holder currently is. Its not safe to call from a lot of places
//Use release_to_floor for a simple, safe release
/obj/item/holder/proc/release_mob()
	for(var/mob/M in contents)
		var/atom/movable/mob_container
		mob_container = M
		mob_container.forceMove(src.loc)//if the holder was placed into a disposal, this should place the animal in the disposal
		M.reset_view()
		M.Released()

	contained = null
	qdel(src)

//Similar to above function, but will not deposit things in any container, only directly on a turf.
//Can be called safely anywhere. Notably on holders held or worn on a mob
/obj/item/holder/proc/release_to_floor()
	var/turf/T = get_turf(src)

	for(var/mob/M in contents)
		M.forceMove(T) //if the holder was placed into a disposal, this should place the animal in the disposal
		M.reset_view()
		M.Released()

	contained = null

	qdel(src)

/obj/item/holder/attackby(obj/item/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/holder/dropped(mob/user)

	///When an object is put into a container, drop fires twice.
	//once with it on the floor, and then once in the container
	//This conditional allows us to ignore that first one. Handling of mobs dropped on the floor is done in process
	if (istype(loc, /turf))
		//Repeat this check
		//If we're still on the turf a few frames later, then we have actually been dropped or thrown
		//Release the mob accordingly
		addtimer(CALLBACK(src, .proc/post_drop), 3)
		return

	if (istype(loc, /obj/item/storage))	//The second drop reads the container its placed into as the location
		update_location()

/obj/item/holder/proc/post_drop()
	if (isturf(loc))
		release_mob()

/obj/item/holder/equipped(var/mob/user, var/slot)
	..()
	update_location(slot)

/obj/item/holder/proc/update_location(var/slotnumber = null)
	if (!slotnumber)
		if (istype(loc, /mob))
			slotnumber = get_equip_slot()

	report_onmob_location(1, slotnumber, contained)

/obj/item/holder/attack_self(mob/M as mob)

	if (contained && !(contained.stat & DEAD))
		if (istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			switch(H.a_intent)
				if(I_HELP)
					H.visible_message("<span class='notice'>[H] pets [contained].</span>")

				if(I_HURT)
					contained.adjustBruteLoss(3)
					H.visible_message("<span class='alert'>[H] crushes [contained].</span>")
	else
		to_chat(M, "[contained] is dead.")


/obj/item/holder/show_message(var/message, var/m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

//Mob procs and vars for scooping up
/mob/living/var/holder_type


/obj/item/holder/proc/held_death(var/show_deathmessage = 0)
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
			M.visible_message("<b>[contained.name]</b> dies.")
	//update_icon()


/mob/living/proc/get_scooped(var/mob/living/carbon/grabber, var/mob/user = null)
	if(!holder_type || buckled || pinned.len || !Adjacent(grabber))
		return

	if (user == src)
		if (grabber.r_hand && grabber.l_hand)
			to_chat(user, "<span class='warning'>They have no free hands!</span>")
			return
	else if ((grabber.hand == 0 && grabber.r_hand) || (grabber.hand == 1 && grabber.l_hand))//Checking if the hand is full
		to_chat(grabber, "<span class='warning'>Your hand is full!</span>")
		return

	src.verbs += /mob/living/proc/get_holder_location//This has to be before we move the mob into the holder


	spawn(2)
		var/obj/item/holder/H = new holder_type(loc)

		src.forceMove(H)


		H.contained = src



		if (src.stat == DEAD)
			H.held_death()//We've scooped up an animal that's already dead. use the proper dead icons
		else
			H.isalive = 1//We note that the mob is alive when picked up. If it dies later, we can know that its death happened while held, and play its deathmessage for it




		var/success = 0
		if (src == user)
			success = grabber.put_in_any_hand_if_possible(H, 0,1,1)
		else
			H.attack_hand(grabber)//We put this last to prevent some race conditions
			if (H.loc == grabber)
				success = 1

		if (success)
			if (user == src)
				to_chat(grabber, "<span class='notice'>[src.name] climbs up onto you.</span>")
				to_chat(src, "<span class='notice'>You climb up onto [grabber].</span>")
			else
				to_chat(grabber, "<span class='notice'>You scoop up [src].</span>")
				to_chat(src, "<span class='notice'>[grabber] scoops you up.</span>")

			H.sync(src)

		else
			to_chat(user, "Failed, try again!")
			//If the scooping up failed something must have gone wrong
			H.release_mob()

		return success


/mob/living/proc/get_holder_location()
	set category = "Abilities"
	set name = "Check held location"
	set desc = "Find out where on their person, someone is holding you."

	if (!usr.get_holding_mob())
		to_chat(src, "Nobody is holding you!")
		return

	if (istype(usr.loc, /obj/item/holder))
		var/obj/item/holder/H = usr.loc
		H.report_onmob_location(0, H.get_equip_slot(), src)

/obj/item/holder/human
	icon = null
	contained_sprite = FALSE
	var/holder_icon = 'icons/mob/holder_complex.dmi'
	var/list/generate_for_slots = list(slot_l_hand_str, slot_r_hand_str, slot_back_str)
	slot_flags = SLOT_BACK


/obj/item/holder/proc/sync(var/mob/living/M)
	src.name = M.name
	src.overlays = M.overlays
	dir = M.dir
	reagents = M.reagents

/obj/item/holder/human/sync(var/mob/living/M)
	cut_overlays()
	// Generate appropriate on-mob icons.
	var/mob/living/carbon/human/owner = M
	if(!icon && istype(owner) && owner.species)
		var/icon/I = new /icon()

		var/skin_colour = rgb(owner.r_skin, owner.g_skin, owner.b_skin)
		var/hair_colour = rgb(owner.r_hair, owner.g_hair, owner.b_hair)
		var/eye_colour =  rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)
		var/species_name = lowertext(owner.species.get_bodytype())

		for(var/cache_entry in generate_for_slots)
			var/cache_key = "[owner.species]-[cache_entry]-[skin_colour]-[hair_colour]"
			if(!holder_mob_icon_cache[cache_key])

				// Generate individual icons.
				var/icon/mob_icon = icon(holder_icon, "[species_name]_holder_[cache_entry]_base")
				mob_icon.Blend(skin_colour, ICON_ADD)
				var/icon/hair_icon = icon(holder_icon, "[species_name]_holder_[cache_entry]_hair")
				hair_icon.Blend(hair_colour, ICON_ADD)
				var/icon/eyes_icon = icon(holder_icon, "[species_name]_holder_[cache_entry]_eyes")
				eyes_icon.Blend(eye_colour, ICON_ADD)

				// Blend them together.
				mob_icon.Blend(eyes_icon, ICON_OVERLAY)
				mob_icon.Blend(hair_icon, ICON_OVERLAY)

				// Add to the cache.
				holder_mob_icon_cache[cache_key] = mob_icon

			var/newstate
			switch (cache_entry)
				if (slot_l_hand_str)
					newstate = "[species_name]_lh"
				if (slot_r_hand_str)
					newstate = "[species_name]_rh"
				if (slot_back_str)
					newstate = "[species_name]_ba"

			I.Insert(holder_mob_icon_cache[cache_key], newstate)


		dir = 2
		var/icon/mob_icon = icon(owner.icon, owner.icon_state)
		I.Insert(mob_icon, species_name)
		icon = I
		icon_state = species_name
		item_state = species_name

		contained_sprite = TRUE

		color = M.color
		name = M.name
		desc = M.desc
		copy_overlays(M)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			if(H.l_hand == src)
				H.update_inv_l_hand()
			else if(H.r_hand == src)
				H.update_inv_r_hand()
			else
				H.regenerate_icons()

		..()

//#TODO-MERGE
//Port the reduced-duplication holder method from baystation upstream:
//https://github.com/Baystation12/Baystation12/blob/master/code/modules/mob/holder.dm

//Mob specific holders.
//w_class mainly determines whether they can fit in trashbags. <=2 can, >=3 cannot
/obj/item/holder/diona
	name = "diona nymph"
	desc = "It's a little plant critter."
	desc_dead = "It used to be a little plant critter."
	icon = 'icons/mob/diona.dmi'
	icon_state = "nymph"
	icon_state_dead = "nymph_dead"
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 5)
	slot_flags = SLOT_HEAD | SLOT_EARS | SLOT_HOLSTER
	w_class = 2

/obj/item/holder/drone
	name = "maintenance drone"
	desc = "It's a small maintenance robot."
	icon_state = "drone"
	item_state = "drone"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 5)
	slot_flags = SLOT_HEAD
	w_class = 4

/obj/item/holder/drone/heavy
	name = "construction drone"
	desc = "It's a really big maintenance robot."
	icon_state = "constructiondrone"
	item_state = "constructiondrone"
	w_class = 6//You're not fitting this thing in a backpack

/obj/item/holder/drone/mining
	name = "mining drone"
	desc = "It's a plucky mining drone."
	icon_state = "mdrone"
	item_state = "mdrone"

/obj/item/holder/cat
	name = "cat"
	desc = "It's a cat. Meow."
	desc_dead = "It's a dead cat."
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "cat2"
	icon_state_dead = "cat2_dead"
	item_state = "cat2"
//Setting item state to cat saves on some duplication for the in-hand versions, but we cant use it for head.
//Instead, the head versions are done by duplicating the cat
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/holder/cat/black
	icon_state = "cat"
	icon_state_dead = "cat_black_dead"
	slot_flags = SLOT_HEAD
	item_state = "cat"

/obj/item/holder/cat/black/familiar
	icon_state = "cat3"
	icon_state_dead = "cat3_dead"
	item_state = "cat3"

/obj/item/holder/cat/kitten
	name = "kitten"
	icon_state = "kitten"
	icon_state_dead = "cat_kitten_dead"
	slot_flags = SLOT_HEAD
	w_class = 1
	item_state = "kitten"

/obj/item/holder/cat/penny
	name = "Penny"
	desc = "An important cat, straight from Central Command."
	icon_state = "penny"
	icon_state_dead = "penny_dead"
	slot_flags = SLOT_HEAD
	w_class = 1
	item_state = "penny"

/obj/item/holder/carp/baby
	name = "baby space carp"
	desc = "Awfully cute! Looks friendly!"
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "babycarp"
	item_state = "babycarp"
	slot_flags = SLOT_HEAD
	flags_inv = HIDEEARS|BLOCKHEADHAIR // carp wings blocks stuff - geeves
	w_class = 1

/obj/item/holder/carp/baby/verb/toggle_block_hair(mob/user)
	set name = "Toggle Hair Coverage"
	set category = "Object"

	flags_inv ^= BLOCKHEADHAIR
	to_chat(user, span("notice", "[src] will now [flags_inv & BLOCKHEADHAIR ? "hide" : "show"] hair."))

/obj/item/holder/borer
	name = "cortical borer"
	desc = "It's a slimy brain slug. Gross."
	icon_state = "brainslug"
	origin_tech = list(TECH_BIO = 6)
	w_class = 1

/obj/item/holder/monkey
	name = "monkey"
	desc = "It's a monkey. Ook."
	icon_state = "monkey"
	item_state = "monkey"
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/holder/monkey/farwa
	name = "farwa"
	desc = "It's a farwa."
	icon_state = "farwa"
	item_state = "farwa"
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/holder/monkey/stok
	name = "stok"
	desc = "It's a stok. stok."
	icon_state = "stok"
	item_state = "stok"
	slot_flags = SLOT_HEAD
	w_class = 3

/obj/item/holder/monkey/neaera
	name = "neaera"
	desc = "It's a neaera."
	icon_state = "neaera"
	item_state = "neaera"
	slot_flags = SLOT_HEAD
	w_class = 3

//Holders for rats
/obj/item/holder/rat
	name = "rat"
	desc = "It's a fuzzy little critter."
	desc_dead = "It's filthy vermin, throw it in the trash."
	icon = 'icons/mob/npc/rat.dmi'
	icon_state = "rat_brown_sleep"
	item_state = "rat_brown"
	icon_state_dead = "rat_brown_dead"
	slot_flags = SLOT_EARS
	origin_tech = list(TECH_BIO = 2)
	w_class = 1

/obj/item/holder/rat/white
	icon_state = "rat_white_sleep"
	item_state = "rat_white"
	icon_state_dead = "rat_white_dead"

/obj/item/holder/rat/gray
	icon_state = "rat_gray_sleep"
	item_state = "rat_gray"
	icon_state_dead = "rat_gray_dead"

/obj/item/holder/rat/brown
	icon_state = "rat_brown_sleep"
	item_state = "rat_brown"
	icon_state_dead = "rat_brown_dead"

/obj/item/holder/rat/hooded
	icon_state = "rat_hooded_sleep"
	item_state = "rat_hooded"
	icon_state_dead = "rat_hooded_dead"

/obj/item/holder/rat/irish
	icon_state = "rat_irish_sleep"
	item_state = "rat_irish"
	icon_state_dead = "rat_irish_dead"

//Lizards

/obj/item/holder/lizard
	name = "lizard"
	desc = "It's a hissy little lizard. Is it related to Unathi?"
	desc_dead = "It doesn't hiss anymore."
	icon_state_dead = "lizard_dead"
	icon_state = "lizard"

	slot_flags = 0
	w_class = 1

//Chicks and chickens
/obj/item/holder/chick
	name = "chick"
	icon = 'icons/mob/npc/livestock.dmi'
	desc = "It's a fluffy little chick, until it grows up."
	desc_dead = "How could you do this? You monster!"
	icon_state_dead = "chick_dead"
	slot_flags = 0
	icon_state = "chick"
	w_class = 1


/obj/item/holder/chicken
	name = "chicken"
	icon = 'icons/mob/npc/livestock.dmi'
	desc = "It's a feathery, tasty-looking chicken."
	desc_dead = "Now it's ready for plucking and cooking!"
	icon_state = "chicken_brown"
	icon_state_dead = "chicken_brown_dead"
	slot_flags = 0
	w_class = 2

/obj/item/holder/chicken/brown
	icon_state = "chicken_brown"
	icon_state_dead = "chicken_brown_dead"

/obj/item/holder/chicken/black
	icon_state = "chicken_black"
	icon_state_dead = "chicken_black_dead"

/obj/item/holder/chicken/white
	icon_state = "chicken_white"
	icon_state_dead = "chicken_white_dead"



//Mushroom
/obj/item/holder/mushroom
	name = "walking mushroom"
	name_dead = "mushroom"
	desc = "It's a massive mushroom... with legs?"
	desc_dead = "Shame, he was a really fun-guy."	// HA
	icon_state = "mushroom"
	icon_state_dead = "mushroom_dead"
	slot_flags = SLOT_HEAD
	w_class = 2



//pAI
/obj/item/holder/pai
	icon = 'icons/mob/npc/pai.dmi'
	dir = EAST
	slot_flags = SLOT_HEAD

/obj/item/holder/pai/drone
	icon_state = "repairbot_rest"
	item_state = "repairbot"

/obj/item/holder/pai/cat
	icon_state = "cat_rest"
	item_state = "cat"

/obj/item/holder/pai/rat
	icon_state = "rat_rest"
	item_state = "rat"

/obj/item/holder/pai/monkey
	icon_state = "monkey_rest"
	item_state = "monkey"

/obj/item/holder/pai/rabbit
	icon_state = "rabbit_rest"
	item_state = "rabbit"
/obj/item/holder/pai/custom
	var/customsprite = 1

/obj/item/holder/pai/custom/sync(mob/living/M)
	..()
	set_paiholder()

/obj/item/holder/pai/custom/proc/set_paiholder()

	if(contained && customsprite == 1)
		icon = CUSTOM_ITEM_SYNTH
		icon_state = "[contained.icon_state]-holder"
		item_state = "[contained.icon_state]"

//corgi

/obj/item/holder/corgi
	name = "corgi"
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "corgi"
	item_state = "corgi"
	w_class = 3

/obj/item/holder/fox
	name = "fox"
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "fox"
	item_state = "fox"
	w_class = 3

/obj/item/holder/schlorrgo
	name = "schlorrgo"
	icon = 'icons/mob/npc/livestock.dmi'
	icon_state = "schlorgo"
	item_state = "schlorgo"
	w_class = ITEMSIZE_NORMAL