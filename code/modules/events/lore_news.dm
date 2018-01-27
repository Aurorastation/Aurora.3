var/global/list/lore_news_list = list()

/datum/event/lore_news
	endWhen = 10

/datum/event/lore_news/announce()

    if(!dbcon.IsConnected())
        log_debug("SQL ERROR during lore news selection. Failed to connect.")
    else
        var/DBQuery/query = dbcon.NewQuery("SELECT id, author, channel, body FROM ss13_news WHERE deleted_at IS NULL ORDER BY RAND() LIMIT 0,1")
        query.Execute()
        if(query.NextRow())
            var/id = query.item[1]
            var/author = query.item[2]
            var/channel = query.item[3]
            var/body = query.item[4]

            news_network.SubmitArticle(body, author, channel, null, 1)
        else
            log_game("ERROR during lore news selection. No news stories found.")
