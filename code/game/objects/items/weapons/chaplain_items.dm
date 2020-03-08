// Nullrod, Aspergillum, Burial Urn

/obj/item/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = 2
	var/cooldown = 0 // floor tap cooldown
	var/static/list/nullchoices = list("Null Rod" = /obj/item/nullrod/, "Null Staff" = /obj/item/nullrod/staff, "Null Orb" = /obj/item/nullrod/orb, "Null Athame" = /obj/item/nullrod/athame)

/obj/item/nullrod/staff
	name = "null staff"
	desc = "A staff of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullstaff"
	item_state = "nullstaff"
	slot_flags = SLOT_BELT | SLOT_BACK
	w_class = 4

/obj/item/nullrod/orb
	name = "null sphere"
	desc = "An orb of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullorb"
	item_state = "nullorb"

/obj/item/nullrod/athame
	name = "null athame"
	desc = "An athame of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullathame"
	item_state = "nullathame"

/obj/item/nullrod/obsidianshards
	name = "obsidian shards"
	desc = "A loose pile of obsidian shards, waiting to be assembled into a religious focus."
	icon_state = "nullshards"
	item_state = "nullshards"

/obj/item/nullrod/verb/change(mob/user)
	set name = "Reassemble Null Item"
	set category = "Object"
	set src in usr

	if(use_check_and_message(user, USE_FORCE_SRC_IN_USER))
		return

	var/picked = input("What form would you like your obsidian relic to take?", "Reassembling your obsidian relic") as null|anything in nullchoices

	if(use_check_and_message(user, USE_FORCE_SRC_IN_USER))
		return
	if(!ispath(nullchoices[picked]))
		return

	to_chat(user, span("notice", "You start reassembling your obsidian relic."))
	if(!do_after(user, 2 SECONDS))
		return

	var/obj/item/nullrod/chosenitem = nullchoices[picked]
	new chosenitem(get_turf(user))
	qdel(src)
	user.put_in_hands(chosenitem)

/obj/item/nullrod/attack(mob/M as mob, mob/living/user as mob)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	if(LAZYLEN(user.spell_list))
		user.silence_spells(300) //30 seconds
		to_chat(user, span("danger", "You've been silenced!"))
		return

	if(!user.IsAdvancedToolUser())
		to_chat(user, span("danger", "You don't have the dexterity to use this!"))
		return

	if((user.is_clumsy()) && prob(50))
		to_chat(user, span("danger", "The [src] slips out of your hand and you hit yourself!"))
		visible_message(span("danger", "[user] fumbles with the [src] and hits themselves in the process!"))
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if(M.stat != DEAD && ishuman(M) && user.a_intent != I_HURT)
		var/mob/living/K = M
		if(cult && (K.mind in cult.current_antagonists) && prob(75))
			if(do_after(user, 15))
				K.visible_message(span("danger", "[user] waves \the [src] over \the [K]'s head, [K] looks captivated by it."), span("warning", "[user] waves the [src] over your head. <b>You see a foreign light, asking you to follow it. Its presence burns and blinds.</b>"))
				var/choice = alert(K,"Do you want to give up your goal?","Become cleansed","Resist","Give in")
				switch(choice)
					if("Resist")
						K.visible_message(span("warning", "The gaze in [K]'s eyes remains determined."), span("notice", "You turn away from the light, remaining true to the Geometer!"))
						K.say("*scream")
						K.take_overall_damage(5, 15)
						admin_attack_log(user, M, "attempted to deconvert", "was unsuccessfully deconverted by", "attempted to deconvert")
					if("Give in")
						K.visible_message(span("notice", "[K]'s eyes become clearer, the evil gone, but not without leaving scars."))
						K.take_overall_damage(10, 20)
						cult.remove_antagonist(K.mind)
						admin_attack_log(user, M, "successfully deconverted", "was successfully deconverted by", "successfully deconverted")
			else
				user.visible_message(span("warning", "[user]'s concentration is broken!"), span("warning", "Your concentration is broken! You and your target need to stay uninterrupted for longer!"))
				return
		else
			to_chat(user, span("danger", "The [src] appears to do nothing."))
			M.visible_message(span("danger", "\The [user] waves \the [src] over \the [M]'s head."))
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(prob(25))
					H.cure_all_traumas(cure_type = CURE_SOLITUDE)
				else if(prob(20))
					H.cure_all_traumas(cure_type = CURE_CRYSTAL)
			return
	else if(user.a_intent != I_HURT) // to prevent the chaplain from hurting peoples accidentally
		to_chat(user, span("notice", "The [src] appears to do nothing."))
		return
	else
		return ..()

/obj/item/nullrod/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A, /turf/simulated/floor) && (cooldown + 5 SECONDS < world.time))
		cooldown = world.time
		user.visible_message(span("notice", "[user] loudly taps their [src.name] against the floor."))
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		var/datum/callback/cb = CALLBACK(src, /obj/effect/rune/revealrunes/.proc/do_rune_action)
		cb.Invoke(user, src)
		return

/obj/item/reagent_containers/spray/aspergillum
	name = "aspergillum"
	desc = "A ceremonial item for sprinkling holy water, or other liquids, on a subject."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "aspergillum"
	item_state = "aspergillum"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	spray_size = 1
	volume = 10
	spray_sound = 'sound/effects/jingle.ogg'

/obj/item/material/urn
	name = "urn"
	desc = "A vase used to store the ashes of the deceased."
	icon = 'icons/obj/urn.dmi'
	icon_state = "urn"
	applies_material_colour = TRUE
	w_class = ITEMSIZE_SMALL

/obj/item/material/urn/attack(var/obj/A, var/mob/user, var/proximity)
	if(!istype(A, /obj/effect/decal/cleanable/ash))
		return ..()
	else if(proximity)
		if(contents.len)
			to_chat(user, span("warning", "\The [src] is already full!"))
			return
		user.visible_message("[user] scoops \the [A] into \the [src], securing the lid.", "You scoop \the [A] into \the [src], securing the lid.")
		desc = "A vase used to store the ashes of the deceased. It contains some ashes."
		A.forceMove(src)

/obj/item/material/urn/attack_self(mob/user)
	if(!contents.len)
		to_chat(user, span("warning", "\The [src] is empty!"))
		return
	else
		for(var/obj/effect/decal/cleanable/ash/A in contents)
			A.dropInto(loc)
			user.visible_message("[user] pours \the [A] out from \the [src].", "You pour \the [A] out from \the [src].")
			desc = "A vase used to store the ashes of the deceased."
