/datum/controller/process/news/setup()
    name = "news"
    schedule_interval = 600 // every 60 seconds

    if(!news_controller)
        news_controller = new

/datum/controller/process/news/doWork()
    news_controller.process()

/datum/controller/process/news/getStatName()
    return ..()+"(STAT:[news_controller.running] FLS:[news_controller.fails])"
