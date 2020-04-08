/obj/effect/rune/armor
	can_talisman = TRUE

/obj/effect/rune/armor/do_rune_action(mob/living/user, obj/O = src)
	if(istype(O, /obj/effect/rune))
		user.say("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	else
		user.whisper("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	user.visible_message(span("warning", "The rune disappears with a flash of red light, and a set of armor appears on [user]..."), span("cult", "You are blinded by the flash of red light! You feel the armor of the Dark One form around you."))

	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		var/construct_class
		if(narsie_cometh)
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Harvester")
		else
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Artificer")

		var/list/static/construct_types = list("Juggernaut" = /mob/living/simple_animal/construct/armoured,
											   "Wraith" = /mob/living/simple_animal/construct/wraith,
											   "Artificer" = /mob/living/simple_animal/construct/builder,
											   "Harvester" = /mob/living/simple_animal/construct/harvester)
		
		var/construct_path = construct_types[construct_class]
		var/mob/living/simple_animal/construct/Z = new construct_path(get_turf(C))
		Z.key = C.key
		if(iscultist(C))
			cult.add_antagonist(Z.mind)
		C.death()
		construct_msg(Z, construct_class)
		Z.cancel_camera()
	
	else if(ishuman(user))
		user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
		user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
		user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)
		user.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), slot_back)
		user.put_in_hands(new /obj/item/melee/cultblade(user))

	qdel(O)
	return TRUE

/obj/effect/rune/armor/proc/construct_msg(mob/construct, var/type)
	switch(type)
		if("Juggernaut")
			to_chat(construct, span("cult", "You are playing a Juggernaut. Though slow, you can withstand extreme punishment, and rip apart enemies and walls alike."))
		if("Wraith")
			to_chat(construct, span("cult", "You are playing a Wraith. Though relatively fragile, you are fast, deadly, and even able to phase through walls."))
		if("Artificer")
			to_chat(construct, span("cult", "You are playing an Artificer. You are incredibly weak and fragile, but you are able to construct fortifications, repair allied constructs (by clicking on them), and even create new constructs"))
		if("Harvester")
			to_chat(construct, span("cult", "You are playing a Harvester. You are gifted with the ability to open doors with your mind, to draw runes at will, and to teleport back to Nar'Sie. Seek out all non-believers and bring them to the Geometer."))
	to_chat(construct, span("cult", "You are still bound to serve your creator, follow their orders and help them complete their goals at all costs."))
