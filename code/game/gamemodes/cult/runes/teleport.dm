var/global/list/teleport_runes = list()
var/global/list/static/teleport_network = list("Vernuth", "Koglan", "Irgros", "Akon")

/obj/effect/rune/teleport
	can_talisman = TRUE

/obj/effect/rune/teleport/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/random_network), 10) // if this rune somehow spawned without a network, we assign a random one

/obj/effect/rune/teleport/examine(mob/user)
	..()
	if(iscultist(user) && network)
		to_chat(user, "This rune's network tag reads: <span class='cult'><b><i>[network]</i></b></span>.")

/obj/effect/rune/teleport/proc/random_network()
	if(!network) // check if it hasn't been assigned yet
		network = pick(teleport_network)

/obj/effect/rune/teleport/do_rune_action(mob/living/user)
	var/turf/T = get_turf(user)
	if(isNotStationLevel(T.z))
		to_chat(user, span("warning", "You are too far from the station, Nar'sie is unable to reach you here."))
		return fizzle(user)

	var/list/obj/effect/rune/teleport/possible_runes = list()
	for(var/obj/effect/rune/R in teleport_runes)
		if(R == src)
			continue
		if(R.network != src.network)
			continue
		possible_runes += R

	if(length(possible_runes))
		if(istype(src,/obj/effect/rune))
			user.say("Sas[pick("'","`")]so c'arta forbici!")//Only you can stop auto-muting
		else
			user.whisper("Sas[pick("'","`")]so c'arta forbici!")
		user.visible_message("<span class='warning'>[user] disappears in a flash of red light!</span>", \
		"<span class='cult'>You feel as your body gets dragged through the dimension of Nar-Sie!</span>", \
		"<span class='warning'>You hear a sickening crunch and sloshing of viscera.</span>")
		user.forceMove(get_turf(pick(possible_runes)))
		return TRUE
	if(istype(src, /obj/effect/rune))
		return fizzle(user) //Use friggin manuals, Dorf, your list was of zero length.
	else
		call(/obj/effect/rune/proc/fizzle)(user)
		return

/obj/effect/rune/teleport/Initialize()
	. = ..()
	teleport_runes += src

/obj/effect/rune/teleport/Destroy()
	teleport_runes -= src
	. = ..()