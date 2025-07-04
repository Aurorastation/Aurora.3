/obj/item/eightball
	name = "magic eightball"
	desc = "A black ball with a stenciled number eight in white on the side. It seems full of dark liquid."

	icon = 'icons/obj/toy.dmi'
	icon_state = "eightball"

	w_class = WEIGHT_CLASS_TINY

	var/shaking = FALSE
	var/on_cooldown = FALSE

	var/shake_time = 50
	var/cooldown_time = 100

	var/static/list/possible_answers = list(
		"It is certain",
		"It is decidedly so",
		"Without a doubt",
		"Yes definitely",
		"You may rely on it",
		"As I see it, yes",
		"Most likely",
		"Outlook good",
		"Yes",
		"Signs point to yes",
		"Reply hazy try again",
		"Ask again later",
		"Better not tell you now",
		"Cannot predict now",
		"Concentrate and ask again",
		"Don't count on it",
		"My reply is no",
		"My sources say no",
		"Outlook not so good",
		"Very doubtful")

	var/question

/obj/item/eightball/attack_self(mob/user)
	if(shaking)
		return

	if(on_cooldown)
		to_chat(user, SPAN_WARNING("\The [src] was shaken recently, it needs time to settle."))
		return

	var/query = sanitize(input(user,"What is your question?", "Magic eightball") as text|null)
	if(query)
		question = query
	else
		return

	user.visible_message(SPAN_NOTICE("\The [user] starts shaking \the [src]."),
							SPAN_NOTICE("You start shaking \the [src]."),
							"You hear shaking and sloshing.")

	shaking = TRUE

	start_shaking(user)
	if(do_after(user, shake_time))
		var/answer = get_answer()

		visible_message(SPAN_NOTICE("\The [src] rattles, \"[answer]\"."))

		on_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(clear_cooldown)), cooldown_time)

	shaking = FALSE

/obj/item/eightball/proc/start_shaking(user)
	return

/obj/item/eightball/proc/get_answer()
	return pick(possible_answers)

/obj/item/eightball/proc/clear_cooldown()
	on_cooldown = FALSE
	question = null

/obj/item/eightball/haunted
	shake_time = 200
	cooldown_time = 1800
	var/ghostly_reply
	var/answered = FALSE

/obj/item/eightball/haunted/start_shaking(mob/user)
	for(var/mob/abstract/ghost/observer/O in GLOB.player_list)
		if(O.client)
			to_chat(O, "[ghost_follow_link(user, O)] <span class='deadsay'><font size=3><b>\The [user] is shaking \the [src], hoping to get an answer to \"[question]\".<a href='byond://?src=[REF(src)];candidate=[REF(O)]'>(Answer)</a></b></font></span>")

/obj/item/eightball/haunted/Topic(href, href_list)
	if(href_list["candidate"])
		var/mob/abstract/ghost/observer/candidate = locate(href_list["candidate"])
		if(!candidate)
			return
		if(candidate != usr)
			return
		if(!shaking)
			return
		if(answered)
			return
		else
			get_ghost_answer(candidate)
		return 1

/obj/item/eightball/haunted/proc/get_ghost_answer(mob/user)
	var/answer = tgui_input_list(user, "Choose the answer.", "Magic Eight-Ball", possible_answers)

	if(answered)
		return

	if(answer)
		ghostly_reply = answer
		answered = TRUE

/obj/item/eightball/haunted/get_answer()
	if(ghostly_reply)
		return ghostly_reply
	else
		return pick(possible_answers)

/obj/item/eightball/haunted/clear_cooldown()
	..()
	ghostly_reply = null
	answered = FALSE

/obj/item/eightball/broken
	name = "broken magic eightball"
	desc = "A black ball with a stenciled number eight in white on the side. It is cracked and seems empty."
	var/fixed_answer

/obj/item/eightball/broken/Initialize()
	. = ..()
	fixed_answer = pick(possible_answers)

/obj/item/eightball/broken/get_answer()
	return fixed_answer
