/obj/effect/rune/manifest/do_rune_action(mob/living/user)
	if(!iscarbon(user))
		to_chat(user, span("warning", "Your primitive form cannot use this rune!"))
	if(get_turf(user) != get_turf(src))
		return fizzle(user)

	var/mob/abstract/observer/ghost
	for(var/mob/abstract/observer/O in get_turf(src))
		if(!O.client)
			continue
		if(O.mind?.current?.stat != DEAD)
			continue
		if(jobban_isbanned(O, "cultist"))
			continue
		ghost = O
		break
	if(!ghost)
		return fizzle(user)

	user.say("Gal'h'rfikk harfrandid mud[pick("'","`")]gib!")
	var/mob/living/carbon/human/apparition/D = new(get_turf(src))
	user.visible_message("<span class='warning'>A shape forms in the center of the rune. A shape of... a man.</span>", \
	"<span class='warning'>A shape forms in the center of the rune. A shape of... a man.</span>", \
	"<span class='warning'>You hear liquid flowing.</span>")

	var/chose_name = FALSE
	for(var/obj/item/paper/P in get_turf(src))
		if(P.info)
			D.real_name = copytext(P.info, findtext(P.info,">")+1, findtext(P.info,"<",2) )
			chose_name = TRUE
			break
	D.universal_speak = TRUE
	D.all_underwear.Cut()
	D.key = ghost.key
	cult.add_antagonist(D.mind)
	playsound(loc, 'sound/magic/exit_blood.ogg', 100, 1)

	if(!chose_name)
		D.real_name = pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")
		D.real_name += " "
		D.real_name += pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")

	log_and_message_admins("used a manifest rune.")

	// The cultist doesn't have to stand on the rune, but they will continually take damage for as long as they have a summoned ghost
	while(src && user?.stat == CONSCIOUS && user.client)
		user.take_organ_damage(1, 0)
		sleep(30)
	if(D)
		D.visible_message("<span class='danger'>[D] slowly dissipates into dust and bones.</span>", \
		"<span class='danger'>You feel pain, as bonds formed between your soul and this homunculus break.</span>", \
		"<span class='warning'>You hear a faint rustling.</span>")
		D.dust()
	return
