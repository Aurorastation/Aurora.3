/obj/effect/rune/armor
	can_talisman = TRUE

/obj/effect/rune/armor/do_rune_action(mob/living/user)
	if(istype(src, /obj/effect/rune))
		user.say("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	else
		user.whisper("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	user.visible_message(span("warning", "The rune disappears with a flash of red light, and a set of armor appears on [user]..."), span("warning", "You are blinded by the flash of red light! After you're able to see again, you see that you are now wearing a set of armor."))

	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		var/construct_class
		if(narsie_cometh)
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Harvester")
		else
			construct_class = alert(C, "Please choose which type of construct you wish to become.", "Construct Selection", "Juggernaut", "Wraith", "Artificer")
		switch(construct_class)
			if("Juggernaut")
				var/mob/living/simple_animal/construct/armoured/Z = new /mob/living/simple_animal/construct/armoured(get_turf(C.loc))
				Z.key = C.key
				if(iscultist(C))
					cult.add_antagonist(Z.mind)
				C.death()
				construct_msg(Z, construct_class)
				Z.cancel_camera()
			if("Wraith")
				var/mob/living/simple_animal/construct/wraith/Z = new /mob/living/simple_animal/construct/wraith(get_turf(C.loc))
				Z.key = C.key
				if(iscultist(C))
					cult.add_antagonist(Z.mind)
				C.death()
				construct_msg(Z, construct_class)
				Z.cancel_camera()
			if("Artificer")
				var/mob/living/simple_animal/construct/builder/Z = new /mob/living/simple_animal/construct/builder(get_turf(C.loc))
				Z.key = C.key
				if(iscultist(C))
					cult.add_antagonist(Z.mind)
				C.death()
				construct_msg(Z, construct_class)
				Z.cancel_camera()
			if("Harvester")
				var/mob/living/simple_animal/construct/builder/Z = new /mob/living/simple_animal/construct/harvester(get_turf(C.loc))
				Z.key = C.key
				if(iscultist(C))
					cult.add_antagonist(Z.mind)
				C.death()
				construct_msg(Z, construct_class)
				Z.cancel_camera()
	else if(istype(user, /mob/living/carbon/human))
		user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
		user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
		user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)
		user.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), slot_back)
		user.put_in_hands(new /obj/item/melee/cultblade(user))

	qdel(src)
	return

/obj/effect/rune/armor/proc/construct_msg(mob/construct, var/type)
	to_chat(construct, span("cult", "You are playing a [type]. You are gifted with the ability to open doors with your mind, to draw runes at will, and to teleport back to Nar'Sie. Seek out all non-believers and bring them to the Geometer."))
	to_chat(construct, span("cult", "You are still bound to serve your creator, follow their orders and help them complete their goals at all costs."))