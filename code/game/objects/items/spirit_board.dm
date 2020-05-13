/obj/item/spirit_board
	name = "spirit board"
	desc = "A wooden board with letters etched into it, used in seances."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spirit_board"
	var/next_use = 0
	var/planchette = "A"
	var/lastuser = null

/obj/item/spirit_board/examine(mob/user)
	..(user)
	to_chat(user, "The planchette is sitting at \"[planchette]\".")

/obj/item/spirit_board/attack_hand(mob/user)
	if(!isturf(loc)) //so if you want to play the use the board, you need to put it down somewhere
		..()
	else
		spirit_board_pick_letter(user)

/obj/item/spirit_board/MouseDrop(mob/user as mob)
	if((user == usr && (!use_check(user))) && (user.contents.Find(src) || in_range(src, user)))
		if(ishuman(usr))
			forceMove(get_turf(usr))
			usr.put_in_hands(src)

/obj/item/spirit_board/attack_ghost(var/mob/abstract/observer/user)
	spirit_board_pick_letter(user)
	return ..()

/obj/item/spirit_board/proc/spirit_board_pick_letter(mob/M)
	if(!spirit_board_checks(M))
		return 0
	planchette = input("Choose the letter.", "Seance!") as null|anything in list(
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
		"YES", "NO", "GOODBYE")
	if(!planchette || !Adjacent(M) || next_use > world.time)
		return	next_use = world.time + rand(30,50)

	lastuser = M.ckey

	visible_message("<span class='notice'>The planchette slowly moves... and stops at the letter \"[planchette]\".</span>")

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
		to_chat(M, "<span class='warning'>It's too bright here to use \the [src]!</span>")
		return 0

	//mobs in range check
	var/users_in_range = 0
	for(var/mob/living/L in orange(1,src))
		if(L.ckey)
			if(L.stat != CONSCIOUS || L.restrained())
				to_chat(M, "<span class='warning'>\The [L] does not seem to be paying attention to the [src].</span>")
			else
				users_in_range++

	if(users_in_range < 2)
		to_chat(M, "<span class='warning'>There are not enough people to use \the [src]!</span>")
		return 0

	return 1