var/global/datum/news_controller/news_controller

/datum/news_controller
    var/count = 0       //Count of articles pulled and published
    var/publish_time    //Ingame time for when the stored article is to be published
    var/article_id      //Stored article's primary-key
    var/running = 1     //Boolean value, self-explanitory
    var/fails = 0       //Counter for failed queries
    var/max_fails = 5   //Maximum amount of failures before the controller is killed

/datum/news_controller/proc/process()
    if(!running)                        //Not running, return.
        return

    if(fails >= max_fails)              //Too many failures, killing.
        kill()
        return

    if(!article_id && !publish_time)    //No entry stored. Update and get one.
        update()
        return

    if(publish_time < world.time)       //Time to publish the article.
        publish()
        if(fails)
            fails = 0

//Stores a new article for publishing.
/datum/news_controller/proc/update()
    establish_db_connection()
    if(!dbcon.IsConnected())
        error("SQL database connection failed. News_controller failed to retreive information.")
        fails++
        return

    var/DBQuery/update_query = dbcon.NewQuery("SELECT id, publishtime FROM ss13_news WHERE status = 2 ORDER BY publishtime ASC LIMIT [count],1")
    update_query.Execute()

    if(update_query.ErrorMsg())
        fails++
        return

    if(!update_query.RowCount())
        kill()
        return

    while(update_query.NextRow())
        article_id = text2num(update_query.item[1])
        publish_time = text2num(update_query.item[2]) * 600

    count++

//Publish the stored article.
/datum/news_controller/proc/publish()
    establish_db_connection()
    if(!dbcon.IsConnected())
        error("SQL database connection failed. News_controller failed to retreive information.")
        fails++
        return

    var/DBQuery/publish_query = dbcon.NewQuery("SELECT channel, author, body FROM ss13_news WHERE id=[article_id]")
    publish_query.Execute()

    var/article_channel
    var/article_author
    var/article_content
    while(publish_query.NextRow())
        article_channel = publish_query.item[1]
        article_author = publish_query.item[2]
        article_content = publish_query.item[3]

    var/channel_found
    for(var/datum/feed_channel/FC in news_network.network_channels)
        if(FC.channel_name == article_channel)
            channel_found = 1
            break

    if(!channel_found)
        news_network.CreateFeedChannel(article_channel, article_author, 0)

    news_network.SubmitArticle(article_content, article_author, article_channel)

    article_id = null
    publish_time = null
    update()

//Kills the controller.
/datum/news_controller/proc/kill()
    running = 0
    return
