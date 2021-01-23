/datum/ghostspawner/revenant
	short_name = MODE_REVENANT
	name = "Revenant"
	desc = "A creature borne of bluespace, you are here to wreak havoc and put an end to bluespace experimentation, one station at a time."
	tags = list("Antagonist")

	observers_only = TRUE
	show_on_job_select = FALSE

	enabled = FALSE
	landmark_name = "Revenant"
	max_count = 0

	spawn_mob = /mob/living/carbon/human/revenant
	respawn_flag = ANIMAL

	var/spawn_index = 1 // used to add a numerical identifier to the revenant. increases by 1 per spawn
	var/has_fired = FALSE

/datum/ghostspawner/revenant/spawn_mob(mob/user)
	var/turf/T = select_spawnlocation()
	var/mob/living/carbon/human/revenant/R
	if(T)
		R = new /mob/living/carbon/human/revenant(T)
	else
		to_chat(user, SPAN_WARNING("Unable to find any spawn point."))
		return

	if(R)
		R.real_name = "[R.real_name] ([spawn_index])"
		R.name = R.real_name
		spawn_index++
		announce_ghost_joinleave(user, FALSE, "They are now a [name].")
		R.ckey = user.ckey

	revenants.add_antagonist(R.mind, TRUE, TRUE, FALSE, TRUE, TRUE)
	if(!has_fired)
		INVOKE_ASYNC(src, .proc/play_ambience, R)

	return R

/datum/ghostspawner/revenant/proc/play_ambience(var/mob/living/carbon/human/H)
	for(var/m in player_list - H)
		var/mob/M = m
		if(M.ear_deaf)
			continue
		M.playsound_simple(get_turf(M), 'sound/ambience/tension/tension.ogg', 75, FALSE)
		to_chat(M, FONT_LARGE(SPAN_CULT("A faint hum coming from the station walls fills your ears...")))
	has_fired = TRUE