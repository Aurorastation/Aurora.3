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

	var/first_rift_done = FALSE

/datum/ghostspawner/revenant/cant_spawn(mob/user)
	. = ..()
	if(!. && revenants.rifts_left <= 0)
		return "The final rift has been closed."

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
	if(R.client)
		to_chat(R, FONT_LARGE(SPAN_CULT("You can now speak with all revenants in the game world by using \"[R.client.prefs.language_prefixes[1]]rs\" before a message.")))
	if(!has_fired)
		INVOKE_ASYNC(src, PROC_REF(play_ambience), R)
	INVOKE_ASYNC(src, PROC_REF(check_rift))

	return R

/datum/ghostspawner/revenant/proc/play_ambience(var/mob/living/carbon/human/H)
	for(var/m in GLOB.player_list - H)
		var/mob/M = m
		if(M.ear_deaf)
			continue
		M.playsound_local(get_turf(M), 'sound/ambience/tension/tension.ogg', 75, FALSE)
		to_chat(M, FONT_LARGE(SPAN_CULT("A faint hum coming from the station walls fills your ears...")))
	has_fired = TRUE

/datum/ghostspawner/revenant/proc/check_rift()
	if(revenants.revenant_rift || revenants.rifts_left <= 0)
		return
	var/kills_needed = ((initial(revenants.rifts_left) - revenants.rifts_left) + 1) * 5
	if(revenants.kill_count > kills_needed)
		var/turf/rift_turf
		var/list/possible_landmarks = list()
		for(var/thing in GLOB.landmarks_list)
			var/obj/effect/landmark/landmark = thing
			if(landmark.name == "RevenantRift")
				possible_landmarks += landmark
		if(length(possible_landmarks))
			var/obj/effect/landmark/L = pick(possible_landmarks)
			rift_turf = get_turf(L)
		if(rift_turf)
			new /obj/effect/portal/revenant(rift_turf)
			if(!first_rift_done)
				command_announcement.Announce("[SSatlas.current_map.station_name], we're detecting energy signatures eerily similar to a bluespace rift breach inside your hull. [SScargo.shuttle ? "We're sending you a bluespace neutralizer via the cargo shuttle. If you need more, your research department should be able to print neutralizers as well if they've been increasing their bluespace research levels. " : ""]Locate the rift and shut it down.", "Bluespace Breach Alert")
				first_rift_done = TRUE
				if(SScargo.shuttle)
					var/turf/T = pick_area_turf(pick(SScargo.shuttle.shuttle_area), list(/proc/not_turf_contains_dense_objects))
					if(T)
						var/obj/structure/closet/crate/C = new /obj/structure/closet/crate(T)
						C.name += " (Neutralizer)"
						new /obj/item/bluespace_neutralizer(C)
