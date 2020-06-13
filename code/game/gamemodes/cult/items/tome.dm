/obj/item/book/tome
	name = "arcane tome"
	description_cult = null
	icon_state = "tome"
	item_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	unique = TRUE
	slot_flags = SLOT_BELT

/obj/item/book/tome/attack(mob/living/M, mob/living/user)
	if(isobserver(M))
		var/mob/abstract/observer/D = M
		D.manifest(user)
		attack_admins(D, user)
		return

	if(!istype(M))
		return

	if(!iscultist(user))
		return ..()

	if(iscultist(M))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	M.take_organ_damage(0, rand(5,20)) //really lucky - 5 hits for a crit
	visible_message(span("warning", "\The [user] beats \the [M] with \the [src]!"))
	to_chat(M, span("danger", "You feel searing heat inside!"))
	attack_admins(M, user)

/obj/item/book/tome/proc/attack_admins(var/mob/living/M, var/mob/living/user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had the [name] used on them by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used [name] on [M.name] ([M.ckey])</font>")
	msg_admin_attack("[key_name_admin(user)] used [name] on [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))


/obj/item/book/tome/attack_self(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/scribe = user
	if(use_check_and_message(scribe))
		return

	if(iscultist(scribe))
		if(!isturf(scribe.loc))
			to_chat(scribe, span("warning", "You do not have enough space to write a proper rune."))
			return

		var/turf/T = get_turf(scribe)

		if(T.is_hole || T.is_space())
			to_chat(scribe, span("warning", "You are unable to write a rune here."))
			return

		// This counts how many runes exist in the game, for some sort of arbitrary rune limit. I trust the old devs had their reasons. - Geeves
		if(SScult.check_rune_limit())
			to_chat(scribe, span("warning", "The cloth of reality can't take that much of a strain. Remove some runes first!"))
			return
		else
			switch(alert("What shall you do with the tome?", "Tome of Nar'sie", "Read it", "Scribe a rune", "Cancel"))
				if("Cancel")
					return
				if("Read it")
					if(use_check_and_message(user))
						return
					user << browse("[SScult.tome_data]", "window=Arcane Tome")
					return

		//only check if they want to scribe a rune, so they can still read if standing on a rune
		if(locate(/obj/effect/rune) in scribe.loc)
			to_chat(scribe, span("warning", "There is already a rune in this location."))
			return

		if(use_check_and_message(scribe))
			return

		var/chosen_rune
		//var/network
		chosen_rune = input("Choose a rune to scribe.") as null|anything in SScult.runes_by_name
		if(!chosen_rune)
			return

		if(use_check_and_message(scribe))
			return

		scribe.visible_message(SPAN_CULT("[scribe] slices open their palm with a ceremonial knife, drawing arcane symbols with their blood..."))
		playsound(scribe, 'sound/weapons/bladeslice.ogg', 50, FALSE)
		scribe.drip(4)

		if(do_after(scribe, 50))
			var/area/A = get_area(scribe)
			if(use_check_and_message(scribe))
				return
			
			//prevents using multiple dialogs to layer runes.
			if(locate(/obj/effect/rune) in get_turf(scribe)) //This is check is done twice. once when choosing to scribe a rune, once here
				to_chat(scribe, span("warning", "There is already a rune in this location."))
				return

			log_and_message_admins("created \an [chosen_rune] at \the [A.name] - [user.loc.x]-[user.loc.y]-[user.loc.z].") //only message if it's actually made

			var/obj/effect/rune/R = new(get_turf(scribe), SScult.runes_by_name[chosen_rune])
			to_chat(scribe, SPAN_CULT("You finish drawing the Geometer's markings."))
			R.blood_DNA = list()
			R.blood_DNA[scribe.dna.unique_enzymes] = scribe.dna.b_type
			R.color = scribe.species.blood_color
	else
		to_chat(user, span("cult", "The book seems full of illegible scribbles."))

/obj/item/book/tome/examine(mob/user)
	..(user)
	if(!iscultist(user) || !isobserver(user))
		to_chat(user, "An old, dusty tome with frayed edges and a sinister looking cover.")
	else
		to_chat(user, "The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Contains the details of every ritual his followers could think of. Most of these are useless, though.")

/obj/item/book/tome/cultify()
	return