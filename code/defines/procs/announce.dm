/var/datum/announcement/priority/priority_announcement
/var/datum/announcement/priority/command/command_announcement

/datum/announcement
	var/title = "Attention"
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	var/print = 0
	var/channel_name = "Announcements"
	var/announcement_type = "Announcement"

/datum/announcement/New(var/do_log = 1, var/new_sound = null, var/do_newscast = 0, var/do_print = 0)
	sound = new_sound
	log = do_log
	newscast = do_newscast
	print = do_print

/datum/announcement/priority/New(var/do_log = 1, var/new_sound = 'sound/misc/announcements/notice.ogg', var/do_newscast = 0, var/do_print = 0)
	..(do_log, new_sound, do_newscast, do_print)
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"

/datum/announcement/priority/command/New(var/do_log = 1, var/new_sound = 'sound/misc/announcements/notice.ogg', var/do_newscast = 0, var/do_print = 0)
	..(do_log, new_sound, do_newscast, do_print)
	title = "[SSatlas.current_map.boss_name] Update"
	announcement_type = "[SSatlas.current_map.boss_name] Update"

/datum/announcement/priority/security/New(var/do_log = 1, var/new_sound = 'sound/misc/announcements/notice.ogg', var/do_newscast = 0, var/do_print = 0)
	..(do_log, new_sound, do_newscast, do_print)
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/announcement/proc/Announce(var/message, var/new_title = "", var/new_sound = null, var/do_newscast = newscast, var/msg_sanitized = 0, var/do_print = 0, var/zlevels = SSatlas.current_map.contact_levels)
	if(!message)
		return
	var/message_title = length(new_title) ? new_title : title
	var/message_sound = new_sound ? new_sound : sound

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
		message_title = sanitizeSafe(message_title)

	var/msg = FormMessage(message, message_title)
	for(var/mob/M in GLOB.player_list)
		if(isnewplayer(M))
			continue

		// Due to spam, only print announcements if the ghost is in the matching z-level, OR if it's a Horizon message.
		if((isghost(M) && ((zlevels == SSatlas.current_map.contact_levels) || (GET_Z(M) in zlevels))) || (!isdeaf(M) && (GET_Z(M) in zlevels)))
			var/turf/T = get_turf(M)
			if(T)
				to_chat(M, msg)
				if(message_sound && !isdeaf(M) && (M.client?.prefs.sfx_toggles & ASFX_VOX))
					sound_to(M, message_sound)

	if(do_newscast && zlevels == SSatlas.current_map.contact_levels)
		NewsCast(message, message_title)
	if(do_print && zlevels == SSatlas.current_map.contact_levels)
		post_comm_message(message_title, message)
	Log(message, message_title)

/datum/announcement/proc/FormMessage(var/message, var/message_title)
	. = "<h2 class='alert'>[message_title]</h2>"
	. += "<br><span class='alert'>[message]</span>"
	if (announcer)
		. += "<br><span class='alert'> -[html_encode(announcer)]</span>"

/datum/announcement/minor/FormMessage(var/message, var/message_title)
	. = "<b>[message]</b>"

/datum/announcement/priority/command/FormMessage(var/message, var/message_title)
	. = "<h2 class='alert'>[SSatlas.current_map.boss_name] Update</h2>"
	if (message_title)
		. += "<h3 class='alert'>[message_title]</h3>"

	. += "<br><span class='alert'>[message]</span><br>"
	. += "<br>"

/datum/announcement/priority/security/FormMessage(var/message, var/message_title)
	. = "<font size=4 color='red'>[message_title]</font>"
	. += "<br><span class='warning'>[message]</span>"

/datum/announcement/proc/NewsCast(message as text, message_title as text)
	if(!newscast)
		return

	var/datum/news_announcement/news = new
	news.channel_name = channel_name
	news.author = announcer
	news.message = message
	news.message_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

/datum/announcement/proc/Log(message as text, message_title as text)
	if(log)
		log_say("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)

/proc/GetNameAndAssignmentFromId(var/obj/item/card/id/I)
	if(!I)
		return "Unknown"
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	return I.assignment ? "[I.registered_name], [I.assignment]" : I.registered_name

/proc/level_seven_announcement(var/list/affecting_z = list())
	if(!length(affecting_z))
		affecting_z += SSmapping.levels_by_trait(ZTRAIT_STATION)

	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/level_7_biohazard.ogg', zlevels = affecting_z)

/proc/ion_storm_announcement(var/list/affecting_z = list())
	if(!length(affecting_z))
		affecting_z += SSmapping.levels_by_trait(ZTRAIT_STATION)

	command_announcement.Announce("It has come to our attention that the ship has passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert", zlevels = affecting_z)

/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank, var/join_message)
	if(SSticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		AnnounceArrivalSimple(character.real_name, rank, join_message)

/proc/AnnounceArrivalSimple(var/name, var/rank = "visitor", var/join_message = "has arrived on the [SSatlas.current_map.station_type]", var/new_sound = 'sound/misc/announcements/notice.ogg')
	GLOB.global_announcer.autosay("[name], [rank], [join_message].", "Arrivals Announcer")
