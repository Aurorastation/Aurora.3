/datum/rune/raise_dead
	name = "revival rune"
	desc = "This rune is used to revive a body in exchange for a dead sacrifice."
	rune_flags = NO_TALISMAN

/datum/rune/raise_dead/do_rune_action(mob/living/user, atom/movable/A)
	var/mob/living/carbon/human/corpse_to_raise
	var/mob/living/carbon/human/body_to_maim

	var/is_sacrifice_target
	for(var/mob/living/carbon/human/M in get_turf(A))
		if(M.stat == DEAD)
			if(M.mind == cult?.sacrifice_target)
				is_sacrifice_target = TRUE
			else
				corpse_to_raise = M
				if(M.key)
					M.ghostize(TRUE)
				break
	if(!corpse_to_raise)
		if(is_sacrifice_target)
			to_chat(user, SPAN_WARNING("The Geometer of blood wants this mortal for himself."))
		return fizzle(user)

	is_sacrifice_target = FALSE
	for(var/datum/rune/R in SScult.rune_list)
		var/found_sacrifice = FALSE
		for(var/mob/living/carbon/human/N in get_turf(R.parent))
			if(N?.mind == cult?.sacrifice_target)
				is_sacrifice_target = TRUE
			else
				if(N.stat != DEAD)
					body_to_maim = N
					found_sacrifice = TRUE
					break
		if(found_sacrifice)
			break

	if(!body_to_maim)
		if(is_sacrifice_target)
			to_chat(user, SPAN_CULT("The Geometer of Blood wants that corpse for himself."))
		else
			to_chat(user, SPAN_WARNING("The sacrifical corpse is not dead. You must free it from this world of illusions before it may be used."))
		return fizzle(user)

	var/mob/abstract/observer/ghost
	for(var/mob/abstract/observer/O in get_turf(A))
		if(!O.client)
			continue
		if(O.mind?.current?.stat != DEAD)
			continue
		if(jobban_isbanned(O, "cultist"))
			continue
		ghost = O
		break

	if(!ghost)
		to_chat(user, SPAN_WARNING("You require a restless spirit which clings to this world. Beckon their prescence with the sacred chants of Nar-Sie."))
		var/area/Ar = get_area(A)
		for(var/mob/M in dead_mob_list)
			to_chat(M, "[ghost_follow_link(user, M)] <span class='cult'>A cultist is attempting to revive a body in [Ar.name]!</span>")
		return fizzle(user)

	corpse_to_raise.revive()

	corpse_to_raise.key = ghost.key	//the corpse will keep its old mind! but a new player takes ownership of it (they are essentially possessed)
									//This means, should that player leave the body, the original may re-enter
	user.say("Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
	corpse_to_raise.visible_message("<span class='warning'>[corpse_to_raise]'s eyes glow with a faint red as \he stands up, slowly starting to breathe again.</span>", \
	"<span class='warning'>Life... I'm alive again...</span>", \
	"<span class='warning'>You hear a faint, slightly familiar whisper.</span>")
	body_to_maim.visible_message("<span class='danger'>[body_to_maim] is torn apart, a black smoke swiftly dissipating from \his wounds!</span>", \
	"<span class='danger'>You feel as your blood boils, tearing you apart.</span>", \
	"<span class='danger'>You hear a thousand voices, all crying in pain.</span>")

	var/list/obj/item/organ/external/possible_limbs = list()
	var/limbs_to_drop = round(rand(1, 3))
	for(var/obj/item/organ/external/E in body_to_maim.organs)
		if(E.vital)
			continue
		possible_limbs += E

	for(var/i = 1; i < limbs_to_drop + 1; i++)
		var/obj/item/organ/external/limb = pick(possible_limbs)
		limb.droplimb(FALSE, DROPLIMB_BURN)

	to_chat(corpse_to_raise, SPAN_CULT("Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root."))
	to_chat(corpse_to_raise, SPAN_CULT("Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring it back."))
	return