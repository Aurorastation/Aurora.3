/obj/item/weapon/monster_manual
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
							/mob/living/simple_animal/mouse/familiar,
							/mob/living/simple_animal/familiar/carcinus,
							/mob/living/simple_animal/familiar/horror,
							/mob/living/simple_animal/familiar/goat,
							/mob/living/simple_animal/familiar/pike
							)
	var/list/monster_info = list(   "It is well known that the blackest of cats make good familiars.",
									"Mice are small but fragile creatures. This one is gifted with unending life, and the ability to renew others.",
									"A mortal decendant of the original Carcinus, it is said their shells are near impenetrable and their claws as sharp as knives.",
									"A creature from other plane, its very own presence is enough to shatter the sanity of men.",
									"A stubborn and mischievous creature, this goat delights in stirring trouble.",
									"The more carnivorous and knowledge hungry cousin of the space carp. Keep away from books."
									)

/obj/item/weapon/monster_manual/attack_self(mob/user as mob)
	if(!user)
		return
	if(!(user.faction == "Space Wizard"))
		user <<"<span class='warning'>When you try to open the book, horrors pours out from among the pages!</span>"
		new /mob/living/simple_animal/hostile/creature(user.loc)
		playsound(user, 'sound/magic/Summon_Karp.ogg', 100, 1)
		return
	else
		user.set_machine(src)
		interact(user)

/obj/item/weapon/monster_manual/interact(mob/user as mob)
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

/obj/item/weapon/monster_manual/Topic(href, href_list)
	..()
	if(!Adjacent(usr))
		usr << browse(null,"window=monstermanual")
		return
	if(href_list["temp"])
		temp = null
	if(href_list["path"])
		if(uses == 0)
			usr << "This book is out of uses."
			return
		var/client/C = get_player()
		if(!C)
			usr << "There are no souls willing to become a familiar."
			return

		var path = text2path(href_list["path"])
		if(!ispath(path))
			usr << "Invalid mob path in [src]. Contact a coder."
			return


		var/mob/living/simple_animal/familiar/F = new path(get_turf(src))
		F.ckey = C.ckey
		F.faction = usr.faction
		F.add_spell(new /spell/contract/return_master(usr),"const_spell_ready")
		if(C.mob && C.mob.mind)
			C.mob.mind.transfer_to(F)
		F << "<B>You are [F], a familiar to [usr]. He is your master and your friend. Aid him in his wizarding duties to the best of your ability.</B>"
		var/newname =  input(F,"Please choose a name. Leaving it blank or canceling will choose the default.", "Name",F.name) as null|text
		if(newname)
			F.name = newname
		temp = "You have summoned \the [F]"
		uses--

	if(Adjacent(usr))
		src.interact(usr)
	else
		usr << browse(null,"window=monstermanual")

/obj/item/weapon/monster_manual/proc/get_player()
	for(var/mob/O in dead_mob_list)
		if(O.client)
			var/getResponse = alert(O,"A wizard is requesting a familiar. Would you like to play as one?", "Wizard familiar summons","Yes","No")
			if(getResponse == "Yes")
				return O.client
	return null
