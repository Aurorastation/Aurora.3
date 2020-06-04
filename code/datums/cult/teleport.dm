/datum/rune/teleport
	name = "teleportation rune"
	desc = "This rune is used to teleport around to other teleport runes of our creation."
	var/network

/datum/rune/teleport/New()
	..()
	addtimer(CALLBACK(src, .proc/random_network), 10) // if this rune somehow spawned without a network, we assign a random one
	SScult.teleport_runes += src

/datum/rune/teleport/Destroy()
	SScult.teleport_runes -= src
	return ..()

/datum/rune/teleport/get_cultist_fluff_text()
	. = ..()
	if(network)
		. += "This rune's network tag reads: <span class='cult'><b><i>[network]</i></b></span>."

/datum/rune/teleport/proc/random_network()
	if(!network) // check if it hasn't been assigned yet
		network = pick(SScult.teleport_network)

/datum/rune/teleport/do_rune_action(mob/living/user, atom/movable/A)
	var/turf/T = get_turf(user)
	if(isNotStationLevel(T.z))
		to_chat(user, span("warning", "You are too far from the station, Nar'sie is unable to reach you here."))
		return fizzle(user)

	var/list/datum/rune/teleport/possible_runes = list()
	for(var/datum/rune/teleport/R in SScult.teleport_runes)
		if(R == src)
			continue
		if(R.network != src.network)
			continue
		possible_runes += R

	if(length(possible_runes))
		user.say("Sas'so c'arta forbici!")//Only you can stop auto-muting
		user.visible_message("<span class='warning'>[user] disappears in a flash of red light!</span>", \
		"<span class='cult'>You feel as your body gets dragged through the dimension of Nar-Sie!</span>", \
		"<span class='warning'>You hear a sickening crunch and sloshing of viscera.</span>")
		user.forceMove(get_turf(pick(possible_runes)))
		return TRUE
	return fizzle(user, A) //Use friggin manuals, Dorf, your list was of zero length.
