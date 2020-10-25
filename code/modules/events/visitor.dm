/datum/event/visitor
    no_fake = 1
    var/datum/ghostspawner/human/visitor/spawner

/datum/event/visitor/setup()
    spawner = SSghostroles.get_spawner("visitor")

/datum/event/visitor/start()
    if(istype(spawner))
        spawner.enable()
