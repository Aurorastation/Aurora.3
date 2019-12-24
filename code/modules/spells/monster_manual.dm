/obj/item/monster_manual
	name = "bestiarum"
	desc = "A book detailing various magical creatures."
	icon = 'icons/obj/library.dmi'
	icon_state = "bookHacking"
	throw_speed = 1
	throw_range = 5
	w_class = 2
	var/uses = 1
	var/temp = null
	var/list/monster = list(/mob/living/simple_animal/familiar/pet/cat,
							/mob/living/simple_animal/rat/familiar,
							/mob/living/simple_animal/familiar/carcinus,
							/mob/living/simple_animal/familiar/horror,
							/mob/living/simple_animal/familiar/goat,
							/mob/living/simple_animal/familiar/pike
							)
	var/list/monster_info = list(   "It is well known that the blackest of cats make good familiars.",
									"Rats are small but fragile creatures. This one is gifted with unending life, and the ability to renew others.",
									"A mortal decendant of the original Carcinus, it is said their shells are near impenetrable and their claws as sharp as knives.",
									"A creature from other plane, its very own presence is enough to shatter the sanity of men.",
									"A stubborn and mischievous creature, this goat delights in stirring trouble.",
									"The more carnivorous and knowledge hungry cousin of the space carp. Keep away from books."
									)

/obj/item/monster_manual/attack_self(mob/living/user as mob)
	if(!user)
		return
	if(!user.is_wizard())
		to_chat(user, "<span class='warning'>When you try to open the book, horrors pours out from among the pages!</span>")
		new /mob/living/simple_animal/hostile/creature(user.loc)
		playsound(user, 'sound/magic/Summon_Karp.ogg', 100, 1)
		return
	else
		user.set_machine(src)
		interact(user)

/obj/item/monster_manual/interact(mob/user as mob)
	var/dat
	if(temp)
		dat = "[temp]<br><a href='byond://?src=\ref[src];temp=1'>Return</a>"
	else
		dat = "<center><h3>bestiarum</h3>You have [uses] uses left.</center>"
		for(var/i=1;i<=monster_info.len;i++)
			var/mob/M = monster[i]
			var/name = capitalize(initial(M.name))
			dat += "<BR><a href='byond://?src=\ref[src];path=[monster[i]]'>[name]</a> - [monster_info[i]]</BR>"
	user << browse(dat,"window=monstermanual")
	onclose(user,"monstermanual")

/obj/item/monster_manual/Topic(href, href_list)
	..()
	if(!Adjacent(usr))
		usr << browse(null,"window=monstermanual")
		return
	if(href_list["temp"])
		temp = null
	if(href_list["path"])
		if(uses == 0)
			to_chat(usr, "This book is out of uses.")
			return

		var/datum/ghosttrap/ghost = get_ghost_trap("wizard familiar")
		var path = text2path(href_list["path"])
		if(!ispath(path))
			to_chat(usr, "Invalid mob path in [src]. Contact a coder.")
			return

		if(!(path in monster))
			return

		var/mob/living/simple_animal/F = new path(get_turf(src))
		temp = "You have attempted summoning \the [F]"
		ghost.request_player(F,"A wizard is requesting a familiar.", 60 SECONDS)
		uses--
		spawn(600)
			if(F)
				if(!F.ckey || !F.client)
					F.visible_message("With no soul to keep \the [F] linked to this plane, it fades away.")
					qdel(F)
					uses++
				else
					F.faction = usr.faction
					F.add_spell(new /spell/contract/return_master(usr), "const_spell_ready")
					to_chat(F, "<B>You are [F], a familiar to [usr]. He is your master and your friend. Aid him in his wizarding duties to the best of your ability.</B>")

		if(Adjacent(usr))
			src.interact(usr)

		else
			usr << browse(null,"window=monstermanual")
