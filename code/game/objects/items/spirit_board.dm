/obj/item/spirit_board
	name = "spirit board"
	desc = "A wooden board with letters etched into it, used in seances."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spirit_board"
	var/next_use = 0
	var/planchette = "A"
	var/lastuser = null

/obj/item/spirit_board/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The planchette is sitting at \"[planchette]\"."

/obj/item/spirit_board/attack_hand(mob/user)
	if(!isturf(loc)) //so if you want to play the use the board, you need to put it down somewhere
		..()
	else
		spirit_board_pick_letter(user)

/obj/item/spirit_board/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if((over == user && (!use_check(over))) && (over.contents.Find(src) || in_range(src, over)))
		if(ishuman(user))
			forceMove(get_turf(user))
			user.put_in_hands(src)

/obj/item/spirit_board/attack_ghost(var/mob/abstract/ghost/user)
	spirit_board_pick_letter(user)
	return ..()

/obj/item/spirit_board/proc/spirit_board_pick_letter(mob/M)
	if(!spirit_board_checks(M))
		return 0
	planchette = tgui_input_list(M, "Choose the letter.", "Seance!", list(
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
		"YES", "NO", "GOODBYE"))
	if(!planchette || !Adjacent(M) || next_use > world.time)
		return	next_use = world.time + rand(30,50)

	lastuser = M.ckey

	visible_message(SPAN_NOTICE("The planchette slowly moves... and stops at the letter \"[planchette]\"."))

/obj/item/spirit_board/proc/spirit_board_checks(mob/M)
	//cooldown
	var/bonus = 0
	if(M.ckey == lastuser)
		bonus = 10

	if(next_use - bonus > world.time )
		return 0

	//lighting check
	var/light_amount = 0
	var/turf/T = get_turf(src)
	light_amount = T.get_lumcount()


	if(light_amount > 0.2)
		to_chat(M, SPAN_WARNING("It's too bright here to use \the [src]!"))
		return 0

	//mobs in range check
	var/users_in_range = 0
	for(var/mob/living/L in orange(1,src))
		if(L.ckey)
			if(L.stat != CONSCIOUS || L.restrained())
				to_chat(M, SPAN_WARNING("\The [L] does not seem to be paying attention to the [src]."))
			else
				users_in_range++

	if(users_in_range < 2)
		to_chat(M, SPAN_WARNING("There are not enough people to use \the [src]!"))
		return 0

	return 1


/obj/item/spirit_board/tajara
	name = "ghostly board"
	desc = "An adhomian ghostly board, used in divination rituals. This one is blue and has the symbol of a moon on it."
	icon_state = "tajara_board"
