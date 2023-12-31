SUBSYSTEM_DEF(news)
	name = "News"
	flags = SS_NO_FIRE
	var/list/datum/feed_channel/network_channels = list()
	var/datum/feed_message/wanted_issue
	var/list/forum_topics

/datum/controller/subsystem/news/Recover()
	src.network_channels = SSnews.network_channels
	src.wanted_issue = SSnews.wanted_issue

/datum/controller/subsystem/news/Initialize(timeofday)
	CreateFeedChannel("Station Announcements", "Automatic Announcement System", 1, 1, "New Station Announcement Available")
	CreateFeedChannel("Tau Ceti Daily", "CentComm Minister of Information", 1, 1)
	CreateFeedChannel("The Gibson Gazette", "Editor Carl Ritz", 1, 1)

	if (GLOB.config.news_use_forum_api)
		load_forum_news_config()

		INVOKE_ASYNC(src, PROC_REF(load_from_forums))

	return SS_INIT_SUCCESS

/datum/controller/subsystem/news/proc/load_from_forums()
	if (!GLOB.config.forum_api_path || !global.forum_api_key)
		LOG_DEBUG("SSnews: Unable to load from forums, API path or key not set up.")
		return

	if (!length(forum_topics))
		return

	for (var/topic_id in forum_topics)
		var/datum/http_request/forum_api/initial = new("forums/topics")
		initial.prepare_get("[topic_id]")
		initial.begin_async()
		UNTIL(initial.is_complete())

		var/datum/http_response/initial_response = initial.into_response()
		if (initial_response.errored)
			testing("Errored: [initial_response.error]")
			LOG_DEBUG("SSnews: errored: [initial_response.error]")
			continue


		var/list/forum_topic = initial_response.body
		var/datum/feed_channel/channel = CreateFeedChannel(
			forum_topic["title"], "System", TRUE, TRUE, FALSE
		)

		var/datum/http_request/forum_api/posts = new("forums/topics")
		posts.prepare_get("[topic_id]/posts", list("sortDir" = "desc", "hidden" = 0, "page" = 1, "perPage" = 20))
		posts.begin_async()
		UNTIL(posts.is_complete())

		var/datum/http_response/posts_response = posts.into_response()
		if (posts_response.errored)
			LOG_DEBUG("SSnews: errored getting posts from [topic_id]: [posts_response.error]")
			continue

		var/list/forum_posts = posts_response.body

		var/news_count = 1
		var/archive_limit = 10
		var/total_vol_count = forum_posts["totalResults"]
		var/count_pulled = length(forum_posts["results"])

		if (total_vol_count < 20)
			archive_limit = total_vol_count - archive_limit

		for (var/i = count_pulled; i > 0; i--)
			var/list/post = forum_posts["results"][i]

			if (news_count > archive_limit)
				SubmitArticle(
					post["content"], GetForumAuthor(topic_id, post["id"]), channel,
					null, FALSE, "Story", GetForumTimestamp(post["date"])
				)

			var/datum/computer_file/data/news_article/news = new()
			news.filename = "[channel.channel_name] vol. [total_vol_count - count_pulled + news_count]"
			news.stored_data = post["content"]
			GLOB.ntnet_global.available_news.Add(news)

			if (news_count > archive_limit)
				news.archived = 1
			else
				news.archived = 0

			news_count++

/datum/controller/subsystem/news/proc/load_forum_news_config()
	var/json = file2text("config/news.json")

	if (!length(json))
		return

	try
		var/list/data = json_decode(json)
		if (!data["news_topics"] || !length(data["news_topics"]))
			return

		forum_topics = data["news_topics"]
		forum_topics -= "_comment"

	catch(var/exception/e)
		LOG_DEBUG("SSnews: error loading news.json. [e]")

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
		log_world("SSnews: Attempted to submit a article from [author] without a proper channel")
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

/datum/controller/subsystem/news/proc/GetForumAuthor(topic_id, post_id)
	topic_id = "[topic_id]"
	post_id = text2num(post_id)

	if (!forum_topics[topic_id])
		return prob(50) ? "John Doe" : "Jane Doe"

	var/list/authors = forum_topics[topic_id]
	var/idx = post_id % authors.len
	return authors[idx + 1]

/datum/controller/subsystem/news/proc/GetForumTimestamp(timestamp)
	// Input format is: 2020-05-10T16:34:50Z

	timestamp = replacetextEx(timestamp, "T", " ")
	timestamp = replacetextEx(timestamp, "Z", "")

	var/year = text2num(copytext(timestamp, 1, 5))
	var/new_year = year + 442
	timestamp = replacetext(timestamp, "[year]", "[new_year]")

	return timestamp

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
