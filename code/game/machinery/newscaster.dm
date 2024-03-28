//##############################################
//################### NEWSCASTERS BE HERE! ####
//###-Agouri###################################

#define PRESET_NORTH \
dir = NORTH; \
pixel_y = 30;

#define PRESET_SOUTH \
dir = SOUTH; \
pixel_y = -26;

#define PRESET_WEST \
dir = WEST; \
pixel_x = -8;

#define PRESET_EAST \
dir = EAST; \
pixel_x = 8;

///Global list that contains reference to all newscasters in existence.
var/list/obj/machinery/newscaster/allCasters = list()

/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard newsfeed handler for use on commercial space stations. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "newscaster"
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

	///If the newscaster is broken, boolean
	var/isbroken = FALSE

	///If it starts powered on, boolean
	var/ispowered = TRUE //starts powered, changes with power_change()

	/**
	 * What the screen is displaying
	 *
	 * 0 = welcome screen - main menu
	 * 1 = view feed channels
	 * 2 = create feed channel
	 * 3 = create feed story
	 * 4 = feed story submited sucessfully
	 * 5 = feed channel created successfully
	 * 6 = ERROR: Cannot create feed story
	 * 7 = ERROR: Cannot create feed channel
	 * 8 = print newspaper
	 * 9 = viewing channel feeds
	 * 10 = censor feed story
	 * 11 = censor feed channel
	 */
	var/screen = 0

	var/paper_remaining = 0

	///If the caster can be used to issue wanted posters, boolean
	var/securityCaster = FALSE

	///Unique newscaster unit number
	var/unit_no = 0 //Each newscaster has a unit number

	var/alert_delay = 500

	///If there hasn't been a news/wanted update in the last alert_delay, boolean
	var/alert = FALSE

	///Contains the name of the person who currently uses the newscaster
	var/scanned_user = "Unknown"

	///Feed message
	var/msg = "";

	var/datum/news_photo/photo_data = null
	var/paper_data = ""
	var/paper_name = ""

	///The feed channel which will be receiving the feed, or being created
	var/channel_name = "";

	///If our new channel will be locked to public submissions, boolean
	var/c_locked=FALSE

	///How many hits the newscaster has taken
	var/hitstaken = 0

	var/datum/feed_channel/viewing_channel = null
	var/datum/feed_message/viewing_message = null
	var/global/list/screen_overlays

/obj/machinery/newscaster/north
	PRESET_NORTH

/obj/machinery/newscaster/south
	PRESET_SOUTH

/obj/machinery/newscaster/west
	PRESET_WEST

/obj/machinery/newscaster/east
	PRESET_EAST

/obj/machinery/newscaster/proc/generate_overlays(var/force = 0)
	if(LAZYLEN(screen_overlays) && !force)
		return
	LAZYINITLIST(screen_overlays)
	screen_overlays["newscaster-screen"] = make_screen_overlay(icon, "newscaster-screen")
	screen_overlays["newscaster-title"] = make_screen_overlay(icon, "newscaster-title")
	screen_overlays["newscaster-wanted"] = make_screen_overlay(icon, "newscaster-wanted")
	screen_overlays["newscaster-scanline"] = make_screen_overlay(icon, "newscaster-scanline")
	for(var/i in 1 to 3)
		screen_overlays["crack[i]"] = make_screen_overlay(icon, "crack[i]")

/obj/machinery/newscaster/security_unit
	name = "Security Newscaster"
	securityCaster = 1

/obj/machinery/newscaster/security_unit/north
	PRESET_NORTH

/obj/machinery/newscaster/security_unit/south
	PRESET_SOUTH

/obj/machinery/newscaster/security_unit/west
	PRESET_WEST

/obj/machinery/newscaster/security_unit/east
	PRESET_EAST

/obj/machinery/newscaster/Initialize(mapload)
	. = ..()                                //I just realised the newscasters weren't in the global machines list. The superconstructor call will tend to that
	allCasters += src
	paper_remaining = 15            // Will probably change this to something better
	unit_no = allCasters.len + 1
	if(dir & NORTH)
		alpha = 127
	generate_overlays()
	update_icon() //for any custom ones on the map...

	if(!mapload)
		set_pixel_offsets()

/obj/machinery/newscaster/Destroy()
	allCasters -= src
	return ..()

/obj/machinery/newscaster/set_pixel_offsets()
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

/obj/machinery/newscaster/update_icon()
	if(!ispowered || isbroken)
		icon_state = initial(icon_state)
		set_light(FALSE)
		if(isbroken) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			cut_overlays()
			add_overlay(screen_overlays["crack3"])
		return

	cut_overlays() //reset overlays

	add_overlay(screen_overlays["newscaster-screen"])
	set_light(1.4, 1.3, COLOR_CYAN)

	if(!alert || !SSnews.wanted_issue) // since we're transparent I don't want overlay nonsense
		add_overlay(screen_overlays["newscaster-title"])

	if(SSnews.wanted_issue) //wanted icon state, there can be no overlays on it as it's a priority message
		add_overlay(screen_overlays["newscaster-wanted"])
		return

	if(alert) //new message alert overlay
		add_overlay(screen_overlays["newscaster-alert"])

	if(hitstaken == 0)
		add_overlay(screen_overlays["newscaster-scanline"])

	if(hitstaken > 0) //Cosmetic damage overlay
		add_overlay(screen_overlays["crack[hitstaken]"])

	icon_state = initial(icon_state)
	return

/obj/machinery/newscaster/power_change()
	if(isbroken) //Broken shit can't be powered.
		return
	..()
	if( !(stat & NOPOWER) )
		src.ispowered = 1
		src.update_icon()
	else
		addtimer(CALLBACK(src, PROC_REF(post_power_loss)), rand(1, 15))

/obj/machinery/newscaster/proc/post_power_loss()
	ispowered = 0
	update_icon()

/obj/machinery/newscaster/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			src.isbroken=1
			if(prob(50))
				qdel(src)
			else
				src.update_icon() //can't place it above the return and outside the if-else. or we might get runtimes of null.update_icon() if(prob(50)) goes in.
			return
		else
			if(prob(50))
				src.isbroken=1
			src.update_icon()
			return

/obj/machinery/newscaster/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/newscaster/attack_hand(mob/user as mob)            //########### THE MAIN BEEF IS HERE! And in the proc below this...############

	if(!src.ispowered || src.isbroken)
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(istype(user, /mob/living/carbon/human) || istype(user,/mob/living/silicon) )
		var/mob/living/human_or_robot_user = user
		var/dat
		dat = text("<H3>Newscaster Unit #[src.unit_no]</H3>")

		src.scan_user(human_or_robot_user) //Newscaster scans you

		if(isNotStationLevel(z))
			screen = 24 // No network connectivity

		switch(screen)
			if(0)
				dat += "Welcome to Newscasting Unit #[src.unit_no]<BR> Interface & News Networks: Operational"
				dat += "<BR><FONT SIZE=1>Property of NanoTrasen</font>"
				if(SSnews.wanted_issue)
					dat+= "<HR><A href='?src=\ref[src];view_wanted=1'>Read Wanted Issue</A>"
				dat+= "<HR><BR><A href='?src=\ref[src];create_channel=1'>Create Feed Channel</A>"
				dat+= "<BR><A href='?src=\ref[src];view=1'>View Feed Channels</A>"
				dat+= "<BR><A href='?src=\ref[src];create_feed_story=1'>Submit new Feed story</A>"
				dat+= "<BR><A href='?src=\ref[src];menu_paper=1'>Print newspaper</A>"
				dat+= "<BR><A href='?src=\ref[src];refresh=1'>Re-scan User</A>"
				dat+= "<BR><BR><A href='?src=\ref[human_or_robot_user];mach_close=newscaster_main'>Exit</A>"
				if(src.securityCaster)
					var/wanted_already = 0
					if(SSnews.wanted_issue)
						wanted_already = 1

					dat+="<HR><B>Feed Security functions:</B><BR>"
					dat+="<BR><A href='?src=\ref[src];menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>"
					dat+="<BR><A href='?src=\ref[src];menu_censor_story=1'>Censor Feed Stories</A>"
					dat+="<BR><A href='?src=\ref[src];menu_censor_channel=1'>Mark Feed Channel with [SSatlas.current_map.company_name] D-Notice</A>"
				dat+="<BR><HR>The newscaster recognises you as: <span class='good'>[src.scanned_user]</span>"
			if(1)
				dat+= "Station Feed Channels<HR>"
				if( isemptylist(SSnews.network_channels) )
					dat+="<I>No active channels found...</I>"
				else
					for(var/channel in SSnews.network_channels)
						var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
						if(FC.is_admin_channel)
							dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen '><A href='?src=\ref[src];show_channel=\ref[FC]'>[FC.channel_name]</A></font></B><BR>"
						else
							dat+="<B><A href='?src=\ref[src];show_channel=\ref[FC]'>[FC.channel_name]</A> [(FC.censored) ? ("<span class='warning'>***</span>") : null]<BR></B>"
				dat+="<BR><HR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Back</A>"
			if(2)
				dat+="Creating new Feed Channel..."
				dat+="<HR><B><A href='?src=\ref[src];set_channel_name=1'>Channel Name</A>:</B> [src.channel_name]<BR>"
				dat+="<B>Channel Author:</B> <span class='good'>[src.scanned_user]</span><BR>"
				dat+="<B><A href='?src=\ref[src];set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.c_locked) ? ("NO") : ("YES")]<BR><BR>"
				dat+="<BR><A href='?src=\ref[src];submit_new_channel=1'>Submit</A><BR><BR><A href='?src=\ref[src];setScreen=[0]'>Cancel</A><BR>"
			if(3)
				dat+="Creating new Feed Message..."
				dat+="<HR><B><A href='?src=\ref[src];set_channel_receiving=1'>Receiving Channel</A>:</B> [src.channel_name]<BR>" //MARK
				dat+="<B>Message Author:</B> <span class='good'>[src.scanned_user]</span><BR>"
				dat+="<B><A href='?src=\ref[src];set_new_message=1'>Message Body</A>:</B> [src.msg] <BR>"
				dat+="<B><A href='?src=\ref[src];set_attachment=1'>Attach Photo</A>:</B>  [(src.photo_data ? "Photo Attached" : "No Photo")]</BR>"
				dat+="<B><A href='?src=\ref[src];set_paper=1'>Scan Paper</A>:</B>  [((src.paper_data || src.paper_name) ? "Paper Scanned" : "No Paper")]</BR>"
				dat+="<BR><A href='?src=\ref[src];submit_new_message=1'>Submit</A><BR><BR><A href='?src=\ref[src];setScreen=[0]'>Cancel</A><BR>"
			if(4)
				dat+="Feed story successfully submitted to [src.channel_name].<BR><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(5)
				dat+="Feed Channel [src.channel_name] created successfully.<BR><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(6)
				dat+="<B><span class='boldannounce'>ERROR: Could not submit Feed story to Network.</B></span><HR><BR>"
				if(src.channel_name=="")
					dat+="<span class='boldannounce'>�Invalid receiving channel name.</span><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<span class='boldannounce'>�Channel author unverified.</span><BR>"
				if(src.msg == "" || src.msg == "\[REDACTED\]")
					dat+="<span class='boldannounce'>�Invalid message body.</span><BR>"

				dat+="<BR><A href='?src=\ref[src];setScreen=[3]'>Return</A><BR>"
			if(7)
				dat+="<B><span class='boldannounce'>ERROR: Could not submit Feed Channel to Network.</B></span><HR><BR>"
				var/list/existing_authors = list()
				for(var/channel in SSnews.network_channels)
					var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
					if(FC.author == "\[REDACTED\]")
						existing_authors += FC.backup_author
					else
						existing_authors += FC.author
				if(src.scanned_user in existing_authors)
					dat+="<span class='boldannounce'>�There already exists a Feed channel under your name.</span><BR>"
				if(src.channel_name=="" || src.channel_name == "\[REDACTED\]")
					dat+="<span class='boldannounce'>�Invalid channel name.</span>BR>"
				var/check = 0
				for(var/channel in SSnews.network_channels)
					var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
					if(FC.channel_name == src.channel_name)
						check = 1
						break
				if(check)
					dat+="<span class='boldannounce'>�Channel name already in use.</span><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<span class='boldannounce'>�Channel author unverified.</span><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[2]'>Return</A><BR>"
			if(8)
				var/total_num=length(SSnews.network_channels)
				var/active_num=total_num
				var/message_num=0
				for(var/channel in SSnews.network_channels)
					var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
					if(!FC.censored)
						message_num += length(FC.messages)    //Dont forget, datum/feed_channel's var messages is a list of datum/feed_message
					else
						active_num--
				dat+="Network currently serves a total of [total_num] Feed channels, [active_num] of which are active, and a total of [message_num] Feed Stories." //TODO: CONTINUE
				dat+="<BR><BR><B>Liquid Paper remaining:</B> [(src.paper_remaining) *100 ] cm^3"
				dat+="<BR><BR><A href='?src=\ref[src];print_paper=[0]'>Print Paper</A>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(9)
				dat+="<B>[src.viewing_channel.channel_name]: </B><FONT SIZE=1>\[created by: <span class='boldannounce'>[src.viewing_channel.author]</span>\]</font><HR>"
				if(src.viewing_channel.censored)
					dat+="<span class='warning'><B>ATTENTION:</B></span> This channel has been deemed as threatening to the welfare of the station, and marked with a [SSatlas.current_map.company_name] D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>"
				else
					if( isemptylist(src.viewing_channel.messages) )
						dat+="<I>No feed messages found in channel...</I><BR>"
					else
						var/i = 0
						for(var/datum/feed_message/MESSAGE in src.viewing_channel.messages)
							i++
							dat+="<BLOCKQUOTE style=\"padding:2px 4px;border-left:4px #797979 solid\">[MESSAGE.body] <FONT SIZE=1>\[Likes: <span class='soghun_alt'>[MESSAGE.likes]</span> Dislikes: <span class='boldannounce'>[MESSAGE.dislikes]</span>\]</font><BR>"
							if(MESSAGE.img)
								send_rsc(usr, MESSAGE.img, "tmp_photo[i].png")
								dat+="<img src='tmp_photo[i].png' width = '180'><BR>"
								if(MESSAGE.caption)
									dat+="<FONT SIZE=1><B>[MESSAGE.caption]</B></font><BR>"
								dat+="<BR>"
							dat+="<FONT SIZE=1><A href='?src=\ref[src];view_comments=1;story=\ref[MESSAGE]'>View Comments</A> <A href='?src=\ref[src];add_comment=1;story=\ref[MESSAGE]'>Add Comment</A> <A href='?src=\ref[src];like=1;story=\ref[MESSAGE]'>Like Story</A> <A href='?src=\ref[src];dislike=1;story=\ref[MESSAGE]'>Dislike Story</A></font><BR>"
							dat+="<FONT SIZE=1>\[Story by <span class='boldannounce'>[MESSAGE.author] - [MESSAGE.time_stamp]</span>\]</font></BLOCKQUOTE><BR>"
				dat+="<BR><HR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[1]'>Back</A>"
			if(10)
				dat+="<B>[SSatlas.current_map.company_name] Feed Censorship Tool</B><BR>"
				dat+="<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>"
				dat+="Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</font>"
				dat+="<HR>Select Feed channel to get Stories from:<BR>"
				if(isemptylist(SSnews.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/channel in SSnews.network_channels)
						var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
						dat+="<A href='?src=\ref[src];pick_censor_channel=\ref[FC]'>[FC.channel_name]</A> [(FC.censored) ? ("<span class='warning'>***</span>") : null]<BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(11)
				dat+="<B>[SSatlas.current_map.company_name] D-Notice Handler</B><HR>"
				dat+="<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's"
				dat+="morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed"
				dat+="stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</font><HR>"
				if(isemptylist(SSnews.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/channel in SSnews.network_channels)
						var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
						dat+="<A href='?src=\ref[src];pick_d_notice=\ref[FC]'>[FC.channel_name]</A> [(FC.censored) ? ("<span class='warning'>***</span>") : null]<BR>"

				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Back</A>"
			if(12)
				dat+="<B>[src.viewing_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <span class='boldannounce'>[src.viewing_channel.author]</span> \]</font><BR>"
				dat+="<FONT SIZE=2><A href='?src=\ref[src];censor_channel_author=\ref[src.viewing_channel]'>[(src.viewing_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></font><HR>"


				if( isemptylist(src.viewing_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.viewing_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[[MESSAGE.message_type] by <span class='boldannounce'>[MESSAGE.author]</span>\]</font><BR>"
						dat+="<FONT SIZE=2><A href='?src=\ref[src];censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='?src=\ref[src];censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></font><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[10]'>Back</A>"
			if(13)
				dat+="<B>[src.viewing_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <span class='boldannounce'>[src.viewing_channel.author]</span> \]</font><BR>"
				dat+="Channel messages listed below. If you deem them dangerous to the station, you can <A href='?src=\ref[src];toggle_d_notice=\ref[src.viewing_channel]'>Bestow a D-Notice upon the channel</A>.<HR>"
				if(src.viewing_channel.censored)
					dat+="<span class='warning'><B>ATTENTION:</B></span> This channel has been deemed as threatening to the welfare of the station, and marked with a [SSatlas.current_map.company_name] D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>"
				else
					if( isemptylist(src.viewing_channel.messages) )
						dat+="<I>No feed messages found in channel...</I><BR>"
					else
						for(var/datum/feed_message/MESSAGE in src.viewing_channel.messages)
							dat+="<BLOCKQUOTE style=\"padding:2px 4px;border-left:4px #797979 solid\">[MESSAGE.body] <FONT SIZE=1>\[Likes: <span class='soghun_alt'>[MESSAGE.likes]</span> Dislikes: <span class='boldannounce'>[MESSAGE.dislikes]</span>\]</font><BR>"
							dat+="<FONT SIZE=1><A href='?src=\ref[src];view_comments=1;story=\ref[MESSAGE];privileged=1;'>View Comments</A> <A href='?src=\ref[src];add_comment=1;story=\ref[MESSAGE]'>Add Comment</A> <A href='?src=\ref[src];like=1;story=\ref[MESSAGE]'>Like Story</A> <A href='?src=\ref[src];dislike=1;story=\ref[MESSAGE]'>Dislike Story</A></font><BR>"
							dat+="<FONT SIZE=1>\[Story by <span class='boldannounce'>[MESSAGE.author] - [MESSAGE.time_stamp]</span>\]</font></BLOCKQUOTE><BR>"

				dat+="<BR><A href='?src=\ref[src];setScreen=[11]'>Back</A>"
			if(14)
				dat+="<B>Wanted Issue Handler:</B>"
				var/wanted_already = 0
				var/end_param = 1
				if(SSnews.wanted_issue)
					wanted_already = 1
					end_param = 2

				if(wanted_already)
					dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</font></I>"
				dat+="<HR>"
				dat+="<A href='?src=\ref[src];set_wanted_name=1'>Criminal Name</A>: [src.channel_name] <BR>"
				dat+="<A href='?src=\ref[src];set_wanted_desc=1'>Description</A>: [src.msg] <BR>"
				dat+="<A href='?src=\ref[src];set_attachment=1'>Attach Photo</A>: [(src.photo_data ? "Photo Attached" : "No Photo")]</BR>"
				dat+="<B><A href='?src=\ref[src];set_paper=1'>Scan Paper</A>:</B>  [((src.paper_data || src.paper_name) ? "Paper Scanned" : "No Paper")]</BR>"
				if(wanted_already)
					dat+="<B>Wanted Issue created by:</B><span class='good'> [SSnews.wanted_issue.backup_author]</span><BR>"
				else
					dat+="<B>Wanted Issue will be created under prosecutor:</B><span class='good'> [src.scanned_user]</span><BR>"
				dat+="<BR><A href='?src=\ref[src];submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
				if(wanted_already)
					dat+="<BR><A href='?src=\ref[src];cancel_wanted=1'>Take down Issue</A>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(15)
				dat+="<span class='good'>Wanted issue for [src.channel_name] is now in Network Circulation.</span><BR><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(16)
				dat+="<B><span class='boldannounce'>ERROR: Wanted Issue rejected by Network.</B></span><HR><BR>"
				if(src.channel_name=="" || src.channel_name == "\[REDACTED\]")
					dat+="<span class='boldannounce'>�Invalid name for person wanted.</span><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<span class='boldannounce'>�Issue author unverified.</span><BR>"
				if(src.msg == "" || src.msg == "\[REDACTED\]")
					dat+="<span class='boldannounce'>�Invalid description.</span><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(17)
				dat+="<B>Wanted Issue successfully deleted from Circulation</B><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(18)
				dat+="<B><span class='boldannounce'>-- STATIONWIDE WANTED ISSUE --</B></span><BR><FONT SIZE=2>\[Submitted by: <span class='good'>[SSnews.wanted_issue.backup_author]</span>\]</font><HR>"
				dat+="<B>Criminal</B>: [SSnews.wanted_issue.author]<BR>"
				dat+="<B>Description</B>: [SSnews.wanted_issue.body]<BR>"
				dat+="<B>Photo:</B>: "
				if(SSnews.wanted_issue.img)
					send_rsc(usr, SSnews.wanted_issue.img, "tmp_photow.png")
					dat+="<BR><img src='tmp_photow.png' width = '180'>"
				else
					dat+="None"
				dat+="<BR><BR><A href='?src=\ref[src];setScreen=[0]'>Back</A><BR>"
			if(19)
				dat+="<span class='good'>Wanted issue for [src.channel_name] successfully edited.</span><BR><BR>"
				dat+="<BR><A href='?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(20)
				dat+="<span class='good'>Printing successful. Please receive your newspaper from the bottom of the machine.</span><BR><BR>"
				dat+="<A href='?src=\ref[src];setScreen=[0]'>Return</A>"
			if(21)
				dat+="<span class='boldannounce'>Unable to print newspaper. Insufficient paper. Please notify maintenance personnel to refill machine storage.</span><BR><BR>"
				dat+="<A href='?src=\ref[src];setScreen=[0]'>Return</A>"
			if(22) //comments!
				dat+="<B>Comments:</B></BR>"
				if(isemptylist(src.viewing_message.comments))
					dat+="No comments on this story yet!</BR>"
				else
					for(var/datum/feed_comment/COMMENT in src.viewing_message.comments)
						dat+="<BLOCKQUOTE style=\"padding:2px 4px;border-left:4px #797979 solid;\"><B>\[[world.time]\] [COMMENT.author]:</B>[COMMENT.message]<BR></BLOCKQUOTE>"
				dat+="<A href='?src=\ref[src];setScreen=[9]'>Return</A>"
			if(23) //comments but with more censorship!
				dat+="<B>Comments:</B></BR>"
				if(isemptylist(src.viewing_message.comments))
					dat+="No comments on this story yet!</BR>"
				else
					for(var/datum/feed_comment/COMMENT in src.viewing_message.comments)
						dat+="<BLOCKQUOTE style=\"padding:2px 4px;border-left:4px #797979 solid;\"><B>\[[world.time]\] [COMMENT.author]:</B>[COMMENT.message]<BR><A href='?src=\ref[src];censor_comment=1;comment=\ref[COMMENT]>Censor Comment</A></BLOCKQUOTE>"
				dat+="<A href='?src=\ref[src];setScreen=[9]'>Return</A>"
			if(24) //newscaster is not connected to the station-z-level
				dat += "<B>ERROR: Newscaster unit cannot access main news server!</B></BR>"
				dat += "<BR><A href='?src=\ref[src];setScreen=[0]'>ATTEMPT RESET</A>"

		var/datum/browser/newscaster_main = new(user, "newscaster_main", "Newscaster", 450, 500)
		newscaster_main.set_content(dat)
		newscaster_main.open()
		onclose(human_or_robot_user, "newscaster_main")

/obj/machinery/newscaster/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		if(href_list["set_channel_name"])
			src.channel_name = sanitizeSafe(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", ""), MAX_LNAME_LEN)
			src.updateUsrDialog()
			//src.update_icon()

		else if(href_list["set_channel_lock"])
			src.c_locked = !src.c_locked
			src.updateUsrDialog()
			//src.update_icon()

		else if(href_list["submit_new_channel"])
			//var/list/existing_channels = list() //OBSOLETE
			var/list/existing_authors = list()
			for(var/channel in SSnews.network_channels)
				var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
				//existing_channels += FC.channel_name
				if(FC.author == "\[REDACTED\]")
					existing_authors += FC.backup_author
				else
					existing_authors  +=FC.author
			var/check = 0
			for(var/channel in SSnews.network_channels)
				var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
				if(FC.channel_name == src.channel_name)
					check = 1
					break
			if(src.channel_name == "" || src.channel_name == "\[REDACTED\]" || src.scanned_user == "Unknown" || check || (src.scanned_user in existing_authors) )
				src.screen=7
			else
				var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
				if(choice=="Confirm")
					SSnews.CreateFeedChannel(src.channel_name, src.scanned_user, c_locked)
					src.screen=5
			src.updateUsrDialog()
			//src.update_icon()

		else if(href_list["set_channel_receiving"])
			//var/list/datum/feed_channel/available_channels = list()
			var/list/available_channels = list()
			for(var/channel in SSnews.network_channels)
				var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
				if( (!FC.locked || FC.author == scanned_user) && !FC.censored)
					available_channels += FC.channel_name
			src.channel_name = input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels
			src.updateUsrDialog()

		else if(href_list["set_new_message"])
			src.msg = pencode2html(sanitize(input(usr, "Write your Feed story", "Network Channel Handler", "") as message, max_length = MAX_BOOK_MESSAGE_LEN, encode = 0, trim = 0, extra = 0))
			src.updateUsrDialog()

		else if(href_list["set_attachment"])
			AttachPhoto(usr)
			src.updateUsrDialog()

		else if(href_list["set_paper"])
			AttachPaper(usr)
			src.updateUsrDialog()

		else if(href_list["submit_new_message"])
			if(src.msg =="" || src.msg=="\[REDACTED\]" || src.scanned_user == "Unknown" || src.channel_name == "" )
				src.screen=6
			else
				if(paper_data)
					src.msg += "</BR>Attachment Name: [paper_name]</BR>Attachment:<PRE><BLOCKQUOTE style=\"border: 1px black solid;\">[paper_data]</BLOCKQUOTE></PRE>"
				var/image = photo_data ? photo_data.photo : null
				feedback_inc("newscaster_stories",1)
				var/datum/feed_channel/ch =  SSnews.GetFeedChannel(src.channel_name)
				SSnews.SubmitArticle(src.msg, src.scanned_user, ch, image, 0)
				src.screen=4

			src.updateUsrDialog()

		else if(href_list["add_comment"])
			var/com_msg = sanitize(input(usr, "Write your Comment", "Network Comment Handler", "") as message, encode = 0, trim = 0, extra = 0)
			if(com_msg =="" || com_msg=="\[REDACTED\]" || src.scanned_user == "Unknown" )
				return
			var/datum/feed_message/viewing_story = locate(href_list["story"])
			if(!istype(viewing_story))
				return
			var/datum/feed_comment/comment = new
			comment.author = src.scanned_user
			comment.message = com_msg
			comment.posted = "[worldtime2text()]"
			viewing_story.comments += comment
			to_chat(usr, "Comment successfully added!")
			src.viewing_message = viewing_story
			src.screen = 22
			src.updateUsrDialog()

		else if(href_list["view_comments"])
			var/datum/feed_message/viewing_story = locate(href_list["story"])
			if(!istype(viewing_story))
				return
			src.screen = href_list["privileged"] ? 23 : 22
			src.viewing_message = viewing_story
			src.updateUsrDialog()

		else if(href_list["censor_comment"])
			var/datum/feed_comment/comment = locate(href_list["comment"])
			if(!istype(comment))
				return
			comment.message = "\[REDACTED\]"
			src.screen = 22
			src.updateUsrDialog()

		else if(href_list["like"])
			var/datum/feed_message/viewing_story = locate(href_list["story"])
			if(src.scanned_user == "Unknown" || (src.scanned_user in viewing_story.interacted) || !istype(viewing_story))
				return
			viewing_story.interacted += src.scanned_user
			viewing_story.likes += 1
			src.updateUsrDialog()

		else if(href_list["dislike"])
			var/datum/feed_message/viewing_story = locate(href_list["story"])
			if(src.scanned_user == "Unknown" || (src.scanned_user in viewing_story.interacted) || !istype(viewing_story))
				return
			viewing_story.interacted += src.scanned_user
			viewing_story.dislikes += 1
			src.updateUsrDialog()

		else if(href_list["create_channel"])
			src.screen=2
			src.updateUsrDialog()

		else if(href_list["create_feed_story"])
			src.screen=3
			src.updateUsrDialog()

		else if(href_list["menu_paper"])
			src.screen=8
			src.updateUsrDialog()
		else if(href_list["print_paper"])
			if(!src.paper_remaining)
				src.screen=21
			else
				src.print_paper()
				src.screen = 20
			src.updateUsrDialog()

		else if(href_list["menu_censor_story"])
			src.screen=10
			src.updateUsrDialog()

		else if(href_list["menu_censor_channel"])
			src.screen=11
			src.updateUsrDialog()

		else if(href_list["menu_wanted"])
			var/already_wanted = 0
			if(SSnews.wanted_issue)
				already_wanted = 1

			if(already_wanted)
				src.channel_name = SSnews.wanted_issue.author
				src.msg = SSnews.wanted_issue.body
			src.screen = 14
			src.updateUsrDialog()

		else if(href_list["set_wanted_name"])
			src.channel_name = sanitizeSafe(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""), MAX_LNAME_LEN)
			src.updateUsrDialog()

		else if(href_list["set_wanted_desc"])
			src.msg = sanitize(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
			src.updateUsrDialog()

		else if(href_list["submit_wanted"])
			var/input_param = text2num(href_list["submit_wanted"])
			if(src.msg == "" || src.channel_name == "" || src.scanned_user == "Unknown")
				src.screen = 16
			else
				var/choice = alert("Please confirm Wanted Issue [(input_param==1) ? ("creation.") : ("edit.")]","Network Security Handler","Confirm","Cancel")
				if(choice=="Confirm")
					if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
						var/datum/feed_message/WANTED = new /datum/feed_message
						WANTED.author = src.channel_name
						WANTED.body = src.msg
						WANTED.backup_author = src.scanned_user //I know, a bit wacky
						if(photo_data)
							WANTED.img = photo_data.photo.img
						SSnews.wanted_issue = WANTED
						SSnews.alert_readers()
						src.screen = 15
					else
						if(SSnews.wanted_issue.is_admin_message)
							alert("The wanted issue has been distributed by a [SSatlas.current_map.company_name] higherup. You cannot edit it.","Ok")
							return
						SSnews.wanted_issue.author = src.channel_name
						SSnews.wanted_issue.body = src.msg
						SSnews.wanted_issue.backup_author = src.scanned_user
						if(photo_data)
							SSnews.wanted_issue.img = photo_data.photo.img
						src.screen = 19

			src.updateUsrDialog()

		else if(href_list["cancel_wanted"])
			if(SSnews.wanted_issue.is_admin_message)
				alert("The wanted issue has been distributed by a [SSatlas.current_map.company_name] higherup. You cannot take it down.","Ok")
				return
			var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				SSnews.wanted_issue = null
				for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
					NEWSCASTER.update_icon()
				src.screen=17
			src.updateUsrDialog()

		else if(href_list["view_wanted"])
			src.screen=18
			src.updateUsrDialog()
		else if(href_list["censor_channel_author"])
			var/datum/feed_channel/FC = locate(href_list["censor_channel_author"])
			if(FC.is_admin_channel)
				alert("This channel was created by a [SSatlas.current_map.company_name] Officer or a external news agency. You cannot censor it.","Ok")
				return
			if(FC.author != "<B>\[REDACTED\]</B>")
				FC.backup_author = FC.author
				FC.author = "<B>\[REDACTED\]</B>"
			else
				FC.author = FC.backup_author
			FC.update()
			src.updateUsrDialog()

		else if(href_list["censor_channel_story_author"])
			var/datum/feed_message/MSG = locate(href_list["censor_channel_story_author"])
			if(MSG.is_admin_message)
				alert("This message was created by a [SSatlas.current_map.company_name] Officer or a external news agency. You cannot censor its author.","Ok")
				return
			if(MSG.author != "<B>\[REDACTED\]</B>")
				MSG.backup_author = MSG.author
				MSG.author = "<B>\[REDACTED\]</B>"
			else
				MSG.author = MSG.backup_author
			MSG.parent_channel.update()
			src.updateUsrDialog()

		else if(href_list["censor_channel_story_body"])
			var/datum/feed_message/MSG = locate(href_list["censor_channel_story_body"])
			if(MSG.is_admin_message)
				alert("This channel was created by a [SSatlas.current_map.company_name] Officer or a external news agency. You cannot censor it.","Ok")
				return
			if(MSG.body != "<B>\[REDACTED\]</B>")
				MSG.backup_body = MSG.body
				MSG.backup_caption = MSG.caption
				MSG.backup_img = MSG.img
				MSG.body = "<B>\[REDACTED\]</B>"
				MSG.caption = "<B>\[REDACTED\]</B>"
				MSG.img = null
			else
				MSG.body = MSG.backup_body
				MSG.caption = MSG.caption
				MSG.img = MSG.backup_img

			MSG.parent_channel.update()
			src.updateUsrDialog()

		else if(href_list["pick_d_notice"])
			var/datum/feed_channel/FC = locate(href_list["pick_d_notice"])
			src.viewing_channel = FC
			src.screen=13
			src.updateUsrDialog()

		else if(href_list["toggle_d_notice"])
			var/datum/feed_channel/FC = locate(href_list["toggle_d_notice"])
			if(FC.is_admin_channel)
				alert("This channel was created by a [SSatlas.current_map.company_name] Officer or a external news agency. You cannot place a D-Notice upon it.","Ok")
				return
			FC.censored = !FC.censored
			FC.update()
			src.updateUsrDialog()

		else if(href_list["view"])
			src.screen=1
			src.updateUsrDialog()

		else if(href_list["setScreen"]) //Brings us to the main menu and resets all fields~
			src.screen = text2num(href_list["setScreen"])
			if (src.screen == 0)
				src.scanned_user = "Unknown";
				msg = "";
				src.c_locked=0;
				channel_name="";
				src.viewing_channel = null
				src.viewing_message = null
			src.updateUsrDialog()

		else if(href_list["show_channel"])
			var/datum/feed_channel/FC = locate(href_list["show_channel"])
			src.viewing_channel = FC
			src.screen = 9
			src.updateUsrDialog()

		else if(href_list["pick_censor_channel"])
			var/datum/feed_channel/FC = locate(href_list["pick_censor_channel"])
			src.viewing_channel = FC
			src.screen = 12
			src.updateUsrDialog()

		else if(href_list["refresh"])
			src.updateUsrDialog()



/obj/machinery/newscaster/attackby(obj/item/attacking_item, mob/user)
	if (src.isbroken)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 100, 1)
		for (var/mob/O in hearers(5, src.loc))
			O.show_message("<EM>[user.name]</EM> further abuses the shattered [src.name].")
	else
		if(istype(attacking_item, /obj/item) )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			var/obj/item/W = attacking_item
			if(W.force <15)
				for (var/mob/O in hearers(5, src.loc))
					O.show_message("[user.name] hits the [src.name] with the [W.name] with no visible effect." )
					playsound(src.loc, 'sound/effects/glass_hit.ogg', 100, 1)
			else
				src.hitstaken++
				if(src.hitstaken==3)
					for (var/mob/O in hearers(5, src.loc))
						O.show_message("[user.name] smashes the [src.name]!" )
					src.isbroken=1
					playsound(src.loc, /singleton/sound_category/glass_break_sound, 100, 1)
				else
					for (var/mob/O in hearers(5, src.loc))
						O.show_message("[user.name] forcefully slams the [src.name] with the [attacking_item.name]!" )
					playsound(src.loc, 'sound/effects/glass_hit.ogg', 100, 1)
		else
			to_chat(user, "<span class='notice'>This does nothing.</span>")
	src.update_icon()

/datum/news_photo
	var/is_synth = 0
	var/obj/item/photo/photo = null

/datum/news_photo/New(var/obj/item/photo/p, var/synth)
	is_synth = synth
	photo = p

/obj/machinery/newscaster/proc/AttachPhoto(mob/user as mob)
	if(photo_data)
		if(!photo_data.is_synth)
			photo_data.photo.forceMove(src.loc)
			if(!issilicon(user))
				user.put_in_inactive_hand(photo_data.photo)
		QDEL_NULL(photo_data)

	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo = user.get_active_hand()
		user.drop_from_inventory(photo,src)
		photo_data = new(photo, 0)
	else if(istype(user,/mob/living/silicon))
		var/mob/living/silicon/tempAI = user
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (!selection)
			return

		photo_data = new(selection, 1)

/obj/machinery/newscaster/proc/AttachPaper(mob/user)
	if(paper_data || paper_name)
		paper_name = ""
		paper_data = ""

	if(istype(user.get_active_hand(), /obj/item/paper))
		var/obj/item/paper/attached = user.get_active_hand()
		paper_name = attached.name
		paper_data = attached.info
		to_chat(user, "You scan \the [attached] and add it to the news story.")
	else
		to_chat(user, "The newscaster refuses to scan [user.get_active_hand()].")

//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the newspaper circulating aboard most stations."
	desc_info = "You can alt-click this to roll it up."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	item_state = "newspaper"
	w_class = ITEMSIZE_SMALL	//Let's make it fit in trashbags!
	attack_verb = list("bapped", "thwacked", "educated")
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	var/screen = 0
	var/pages = 0
	var/curr_page = 0
	var/list/datum/feed_channel/news_content = list()
	var/datum/feed_message/important_message = null
	var/scribble=""
	var/scribble_page = null
	var/rolled = FALSE // Whether the newspaper is rolled or not, making it a deadly weapon.

/obj/item/newspaper/attack_self(mob/user as mob)
	if(user.a_intent == I_GRAB)
		if(!rolled)
			user.visible_message(SPAN_NOTICE("\The [user] rolls up \the [src]."),\
									SPAN_NOTICE("You roll up \the [src]."))
			rolled(user)
		return
	if(rolled)
		user.visible_message(SPAN_NOTICE("\The [user] unrolls \the [src] to read it."),\
								SPAN_NOTICE("You unroll \the [src] to read it."))
		rolled(user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/dat
		src.pages = 0
		switch(screen)
			if(0) //Cover
				dat+="<DIV ALIGN='center'><B><FONT SIZE=6>The Griffon</font></B></div>"
				dat+="<DIV ALIGN='center'><FONT SIZE=2>[SSatlas.current_map.company_name]-standard newspaper, for use on [SSatlas.current_map.company_name] Vessels.</font></div><HR>"
				if(isemptylist(src.news_content))
					if(src.important_message)
						dat+="Contents:<BR><ul><B><span class='warning'>**</span>Important Security Announcement<span class='warning'>**</span></B> <FONT SIZE=2>\[page [src.pages+2]\]</font><BR></ul>"
					else
						dat+="<I>Other than the title, the rest of the newspaper is unprinted...</I>"
				else
					dat+="Contents:<BR><ul>"
					for(var/datum/feed_channel/NP in src.news_content)
						src.pages++
					if(src.important_message)
						dat+="<B><span class='warning'>**</span>Important Security Announcement<span class='warning'>**</span></B> <FONT SIZE=2>\[page [src.pages+2]\]</font><BR>"
					var/temp_page=0
					for(var/datum/feed_channel/NP in src.news_content)
						temp_page++
						dat+="<B>[NP.channel_name]</B> <FONT SIZE=2>\[page [temp_page+1]\]</font><BR>"
					dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[src.scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:right;'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV> <div style='float:left;'><A href='?src=\ref[human_user];mach_close=newspaper_main'>Done reading</A></DIV>"
			if(1) // X channel pages inbetween.
				for(var/datum/feed_channel/NP in src.news_content)
					src.pages++ //Let's get it right again.
				var/datum/feed_channel/C = src.news_content[src.curr_page]
				dat+="<FONT SIZE=4><B>[C.channel_name]</B></font><FONT SIZE=1> \[created by: <span class='boldannounce'>[C.author]</span>\]</font><BR><BR>"
				if(C.censored)
					dat+="This channel was deemed dangerous to the general welfare of the station and therefore marked with a <B><span class='warning'>D-Notice</B></span>. Its contents were not transferred to the newspaper at the time of printing."
				else
					if(isemptylist(C.messages))
						dat+="No Feed stories stem from this channel..."
					else
						dat+="<ul>"
						var/i = 0
						for(var/datum/feed_message/MESSAGE in C.messages)
							i++
							dat+="-[MESSAGE.body] <BR>"
							if(MESSAGE.img)
								send_rsc(usr, MESSAGE.img, "tmp_photo[i].png")
								dat+="<img src='tmp_photo[i].png' width = '180'><BR>"
							dat+="<FONT SIZE=1>\[[MESSAGE.message_type] by <span class='boldannounce'>[MESSAGE.author]</span>\]</font><BR><BR>"
						dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[src.scribble]\"</I>"
				dat+= "<BR><HR><DIV STYLE='float:left;'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV> <DIV STYLE='float:right;'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV>"
			if(2) //Last page
				for(var/datum/feed_channel/NP in src.news_content)
					src.pages++
				if(src.important_message!=null)
					dat+="<DIV STYLE='float:center;'><FONT SIZE=4><B>Wanted Issue:</B></FONT></DIV><BR><BR>"
					dat+="<B>Criminal name</B>: <span class='boldannounce'>[important_message.author]</span><BR>"
					dat+="<B>Description</B>: [important_message.body]<BR>"
					dat+="<B>Photo:</B>: "
					if(important_message.img)
						send_rsc(user, important_message.img, "tmp_photow.png")
						dat+="<BR><img src='tmp_photow.png' width = '180'>"
					else
						dat+="None"
				else
					dat+="<I>Apart from some uninteresting Classified ads, there's nothing on this page...</I>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[src.scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:left;'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			else
				dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

		dat+="<BR><HR><div align='center'>[src.curr_page+1]</div>"

		show_browser(human_user, dat, "window=newspaper_main;size=300x400")
		onclose(human_user, "newspaper_main")
	else
		to_chat(user, "The paper is full of intelligible symbols!")


/obj/item/newspaper/Topic(href, href_list)
	var/mob/living/U = usr
	..()
	if ((src in U.contents) || ( istype(loc, /turf) && in_range(src, U) ))
		U.set_machine(src)
		if(href_list["next_page"])
			if(curr_page==src.pages+1)
				return //Don't need that at all, but anyway.
			if(src.curr_page == src.pages) //We're at the middle, get to the end
				src.screen = 2
			else
				if(curr_page == 0) //We're at the start, get to the middle
					src.screen=1
			src.curr_page++
			playsound(src.loc, /singleton/sound_category/page_sound, 50, 1)

		else if(href_list["prev_page"])
			if(curr_page == 0)
				return
			if(curr_page == 1)
				src.screen = 0

			else
				if(curr_page == src.pages+1) //we're at the end, let's go back to the middle.
					src.screen = 1
			src.curr_page--
			playsound(src.loc, /singleton/sound_category/page_sound, 50, 1)

		if (istype(src.loc, /mob))
			src.attack_self(src.loc)


/obj/item/newspaper/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ispen())
		if(rolled)
			user.visible_message(SPAN_NOTICE("\The [user] unrolls \the [src] to write on it."),\
									SPAN_NOTICE("You unroll \the [src] to write on it."))
			rolled()
		if(src.scribble_page == src.curr_page)
			to_chat(user, "<span class='notice'>There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?</span>")
		else
			var/s = sanitize( tgui_input_text(user, "Write something", "Newspaper", "") )
			if (!s)
				return
			if (!in_range(src, usr) && src.loc != usr)
				return
			src.scribble_page = src.curr_page
			src.scribble = s
			src.attack_self(user)
		return TRUE

/obj/item/newspaper/proc/rolled(mob/user)
	if(ishuman(user) && Adjacent(user) && !user.incapacitated())
		if(rolled)
			playsound(src, pickup_sound, PICKUP_SOUND_VOLUME)
		else
			playsound(src, drop_sound, DROP_SOUND_VOLUME)
		rolled = !rolled
		icon_state = "newspaper[rolled ? "_rolled" : ""]"
		item_state = icon_state
		update_icon()

////////////////////////////////////helper procs

// Newscaster scans you
// autorecognition, woo!
/obj/machinery/newscaster/proc/scan_user(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/ID = H.GetIdCard()
		if(ID)
			scanned_user = GetNameAndAssignmentFromId(ID)
		else
			scanned_user = "Unknown"
	else
		var/mob/living/silicon/ai_user = user
		scanned_user = "[ai_user.name] ([ai_user.job])"


/obj/machinery/newscaster/proc/print_paper()
	feedback_inc("newscaster_newspapers_printed",1)
	var/obj/item/newspaper/NEWSPAPER = new /obj/item/newspaper
	for(var/channel in SSnews.network_channels)
		var/datum/feed_channel/FC = SSnews.GetFeedChannel(channel)
		NEWSPAPER.news_content += FC
	if(SSnews.wanted_issue)
		NEWSPAPER.important_message = SSnews.wanted_issue
	playsound(src.loc, 'sound/bureaucracy/print.ogg', 75, 1)
	usr.put_in_hands(NEWSPAPER)
	src.paper_remaining--
	return

/obj/machinery/newscaster/proc/newsAlert(var/news_call)
	if (isNotStationLevel(z))
		clearAlert()
		return
	var/turf/T = get_turf(src)
	if(news_call)
		for(var/mob/O in hearers(world.view-1, T))
			O.show_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"[news_call]\"</span>",2)

		if (!alert)
			alert = 1
			update_icon()
			addtimer(CALLBACK(src, PROC_REF(clearAlert)), 300, TIMER_UNIQUE)

		playsound(src.loc, 'sound/machines/twobeep.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)
	else
		for(var/mob/O in hearers(world.view-1, T))
			O.show_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"Attention! Wanted issue distributed!\"</span>",2)
		playsound(loc, 'sound/machines/warning-buzzer.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)
	return

/obj/machinery/newscaster/proc/clearAlert()
	alert = 0
	update_icon()

#undef PRESET_NORTH
#undef PRESET_SOUTH
#undef PRESET_WEST
#undef PRESET_EAST
