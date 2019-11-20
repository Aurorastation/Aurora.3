/var/datum/controller/subsystem/news/SSnews

/datum/controller/subsystem/news
	name = "News"
	flags = SS_NO_FIRE
	var/list/datum/feed_channel/network_channels = list()
	var/datum/feed_message/wanted_issue

/datum/controller/subsystem/news/Recover()
	src.network_channels = SSnews.network_channels
	src.wanted_issue = SSnews.wanted_issue

/datum/controller/subsystem/news/New()
	NEW_SS_GLOBAL(SSnews)

/datum/controller/subsystem/news/Initialize(timeofday)
	CreateFeedChannel("Station Announcements", "Automatic Announcement System", 1, 1, "New Station Announcement Available")
	CreateFeedChannel("Tau Ceti Daily", "CentComm Minister of Information", 1, 1)
	CreateFeedChannel("The Gibson Gazette", "Editor Carl Ritz", 1, 1)
	if(config.sql_enabled)
		load_from_sql()
	..()

/datum/controller/subsystem/news/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		log_debug("SSnews: SQL ERROR - Failed to connect.")
		return
	var/DBQuery/channel_query = dbcon.NewQuery("SELECT id, name, author, locked, is_admin_channel, announcement FROM ss13_news_channels WHERE deleted_at IS NULL ORDER BY name ASC")
	channel_query.Execute()
	while(channel_query.NextRow())
		CHECK_TICK
		var/datum/feed_channel/channel = null
		try
			channel = CreateFeedChannel(
				channel_query.item[2],
				channel_query.item[3],
				text2num(channel_query.item[4]),
				text2num(channel_query.item[5]),
				channel_query.item[6])
		catch(var/exception/ec)
			log_debug("SSnews: Error when loading channel: [ec]")
			continue
		var/DBQuery/news_query = dbcon.NewQuery("SELECT body, author, is_admin_message, message_type, ic_timestamp, url FROM ss13_news_stories WHERE deleted_at IS NULL AND channel_id = :channel_id: AND publish_at < NOW() AND (publish_until > NOW() OR publish_until IS NULL) AND approved_at IS NOT NULL ORDER BY publish_at DESC")
		news_query.Execute(list("channel_id" = channel_query.item[1]))
		while(news_query.NextRow())
			CHECK_TICK
			try
				SubmitArticle(news_query.item[1], news_query.item[2], channel, null, text2num(news_query.item[3]), news_query.item[4], news_query.item[5])
			catch(var/exception/en)
				log_debug("SSnews: Error when loading news: [en]")

/datum/controller/subsystem/news/proc/GetFeedChannel(var/channel_name)
	if(network_channels[channel_name])
		return network_channels[channel_name]
	return null

/datum/controller/subsystem/news/proc/CreateFeedChannel(var/channel_name, var/author, var/locked, var/adminChannel = 0, var/announcement_message)
	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = channel_name
	newChannel.author = author
	newChannel.locked = locked
	newChannel.is_admin_channel = adminChannel
	if(announcement_message)
		newChannel.announcement = announcement_message
	else
		newChannel.announcement = "Breaking news from [channel_name]!"
	network_channels[channel_name] = newChannel
	return newChannel

/datum/controller/subsystem/news/proc/SubmitArticle(var/msg, var/author, var/datum/feed_channel/channel, var/obj/item/photo/photo, var/adminMessage = 0, var/message_type = "", var/time_stamp)
	if(!channel)
		log_debug("SSnews: Attempted to submit a article from [author] without a proper channel",SEVERITY_ERROR)
		return
	
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = author
	newMsg.body = msg
	if(time_stamp)
		newMsg.time_stamp = time_stamp
	else
		newMsg.time_stamp = "[worldtime2text()]"
	newMsg.is_admin_message = adminMessage
	if(message_type)
		newMsg.message_type = message_type
	if(photo)
		newMsg.img = photo.img
		newMsg.caption = photo.scribble
	insert_message_in_channel(channel, newMsg) //Adding message to the network's appropriate feed_channel

/datum/controller/subsystem/news/proc/insert_message_in_channel(var/datum/feed_channel/FC, var/datum/feed_message/newMsg)
	FC.messages += newMsg
	newMsg.parent_channel = FC
	FC.update()
	alert_readers(FC.announcement)

/datum/controller/subsystem/news/proc/alert_readers(var/annoncement)
	set waitfor = FALSE
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert(annoncement)
		NEWSCASTER.update_icon()

	var/list/receiving_pdas = new
	for (var/obj/item/device/pda/P in PDAs)
		if (!P.owner)
			continue
		if (P.toff)
			continue
		receiving_pdas += P
		
	for(var/obj/item/device/pda/PDA in receiving_pdas)
		PDA.new_news(annoncement)


/datum/feed_message
	var/author =""
	var/body =""
	var/message_type ="Story"
	var/datum/feed_channel/parent_channel
	var/is_admin_message = 0
	var/icon/img = null
	var/icon/caption = ""
	var/time_stamp = ""
	var/backup_body = ""
	var/backup_author = ""
	var/icon/backup_img = null
	var/icon/backup_caption = ""
	var/list/comments = list()
	var/list/interacted = list()
	var/likes = 0
	var/dislikes = 0

/datum/feed_message/proc/clear()
	src.author = ""
	src.body = ""
	src.caption = ""
	src.img = null
	src.time_stamp = ""
	src.backup_body = ""
	src.backup_author = ""
	src.backup_caption = ""
	src.backup_img = null
	src.comments = list()
	src.interacted = list()
	src.likes = 0
	src.dislikes = 0
	parent_channel.update()

/datum/feed_channel
	var/channel_name=""
	var/list/datum/feed_message/messages = list()
	var/locked=0 //If public stories are accepted
	var/author=""
	var/backup_author=""
	var/censored=0
	var/is_admin_channel=0 //If it can be censored, ...
	var/updated = 0
	var/announcement = "" //The text that should be broadcasted when a new story is posted

/datum/feed_channel/proc/update()
	updated = world.time

/datum/feed_channel/proc/clear()
	src.channel_name = ""
	src.messages = list()
	src.locked = 0
	src.author = ""
	src.backup_author = ""
	src.censored = 0
	src.is_admin_channel = 0
	src.announcement = ""
	update()

/datum/feed_comment
	var/author = ""
	var/message = ""
	var/posted = 0
