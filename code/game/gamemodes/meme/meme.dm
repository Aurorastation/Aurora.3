//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04

/datum/game_mode/var/list/memes = list()

/datum/game_mode/meme
	name = "Memetic Anomaly"
	config_tag = "meme"
	required_players = 3
	votable = 0 // temporarily disable this mode for voting
	end_on_antag_death = 1

	var/var/list/datum/mind/first_hosts = list()
	var/var/list/assigned_hosts = list()

/datum/game_mode/meme/announce()
	to_world("<B>The current game mode is - Meme!</B>")
	to_world("<B>An unknown creature has infested the mind of a crew member. Find and destroy it by any means necessary.</B>")

/datum/game_mode/meme/can_start()

	. = ..()

	if(. != "true")
		return .

	// for every 10 players, get 1 meme, and for each meme, get a host
	// also make sure that there's at least one meme and one host
	//recommended_enemies = max(src.num_players() / 20 * 2, 2)

	var/list/datum/mind/possible_memes = get_players_for_role(BE_MEME)

	if(possible_memes.len < 2)
		log_admin("MODE FAILURE: MEME. NOT ENOUGH MEME CANDIDATES.")
		return GAME_FAILURE_NO_ANTAGS

	// for each 2 possible memes, add one meme and one host
	while(possible_memes.len >= 2)
		var/datum/mind/meme = pick(possible_memes)
		possible_memes.Remove(meme)

		var/datum/mind/first_host = pick(possible_memes)
		possible_memes.Remove(first_host)
		memes += meme
		first_hosts += first_host

		// so that we can later know which host belongs to which meme
		assigned_hosts[meme.key] = first_host

		meme.assigned_role = "MODE" //So they aren't chosen for other jobs.
		meme.special_role = "Meme"

	return GAME_FAILURE_NONE

/datum/game_mode/meme/pre_setup()
	return 1


/datum/game_mode/meme/post_setup()
	// create a meme and enter it
	for(var/datum/mind/meme in memes)
		var/mob/living/parasite/meme/M = new
		var/mob/original = meme.current
		meme.transfer_to(M)
		M.clearHUD()

		// get the host for this meme
		var/datum/mind/first_host = assigned_hosts[meme.key]
		// this is a redundant check, but I don't think the above works..
		// if picking hosts works with this method, remove the method above
		if(!first_host)
			first_host = pick(first_hosts)
			first_hosts.Remove(first_host)
		M.enter_host(first_host.current)
		//forge_meme_objectives(meme, first_host)

		qdel(original)

	log_admin("Created [memes.len] memes.")

	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	..()
	return

/datum/game_mode/proc/greet_meme(var/datum/mind/meme, var/you_are=1)
	if (you_are)
		to_chat(meme.current, "<span class='danger'>You are a meme!</span>")
	show_objectives(meme)
	return

/datum/game_mode/meme/check_finished()
	var/memes_alive = 0
	for(var/datum/mind/meme in memes)
		if(!istype(meme.current,/mob/living))
			continue
		if(meme.current.stat==2)
			continue
		memes_alive++

	if (memes_alive)
		return ..()
	else
		return 1
