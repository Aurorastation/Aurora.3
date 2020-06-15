/datum/rune/apparition
	name = "apparition rune"
	desc = "This rune is used to turn a spirit around us into an apparition."
	rune_flags = NO_TALISMAN
	var/mob/living/carbon/human/apparition/apparition

/datum/rune/apparition/Destroy()
	apparition_check()
	return ..()

/datum/rune/apparition/do_rune_action(mob/living/user, atom/movable/A)
	if(!iscarbon(user))
		to_chat(user, span("warning", "Your primitive form cannot use this rune!"))
	if(apparition)
		to_chat(user, span("warning", "This rune already has an active apparition!"))
	var/mob/living/carbon/C = user

	var/mob/abstract/observer/ghost
	for(var/mob/abstract/observer/O in get_turf(A))
		if(!O.client)
			continue
		if(jobban_isbanned(O, "cultist"))
			continue
		ghost = O
		break
	if(!ghost)
		to_chat(user, span("warning", "There are no spirits in the area of the rune!"))
		return fizzle(user)

	user.say("Gal'h'rfikk harfrandid mud[pick("'","`")]gib!")
	apparition = new /mob/living/carbon/human/apparition(get_turf(A))
	user.visible_message("<span class='warning'>A shape forms in the center of the rune. A shape of... a man.</span>", \
	"<span class='warning'>A shape forms in the center of the rune. A shape of... a man.</span>", \
	"<span class='warning'>You hear liquid flowing.</span>")

	var/chose_name = FALSE
	for(var/obj/item/paper/P in get_turf(A))
		if(P.info)
			apparition.real_name = copytext(P.info, findtext(P.info,">")+1, findtext(P.info,"<",2) )
			chose_name = TRUE
			break
	apparition.universal_speak = TRUE
	apparition.all_underwear.Cut()
	apparition.key = ghost.key
	cult.add_antagonist(apparition.mind)
	playsound(get_turf(A), 'sound/magic/exit_blood.ogg', 100, 1)

	if(!chose_name)
		apparition.real_name = pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")
		apparition.real_name += " "
		apparition.real_name += pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")

	log_and_message_admins("used a manifest rune.")

	// The cultist doesn't have to stand on the rune, but they will continually take damage for as long as they have a summoned ghost
	var/can_manifest = TRUE
	while(user?.stat == CONSCIOUS && C.client && can_manifest && apparition)
		can_manifest = C.species.take_manifest_ghost_damage(user)
		sleep(30)
	apparition_check()
	return

/datum/rune/apparition/proc/apparition_check()
	if(apparition)
		apparition.visible_message(FONT_LARGE(SPAN_WARNING("\The [apparition] slowly dissipates into dust and bones.")), \
		FONT_LARGE(SPAN_WARNING("You feel pain, as bonds formed between your soul and this homunculus break.")), \
		SPAN_WARNING("You hear a faint rustling."))
		apparition.dust()
		apparition = null
