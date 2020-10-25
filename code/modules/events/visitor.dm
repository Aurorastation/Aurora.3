/datum/event/visitor
    no_fake = 1
    var/datum/ghostspawner/human/visitor/spawner

/datum/event/rescue_pod/setup()
    spawner = SSghostroles.get_spawner("visitor")

/datum/event/rescue_pod/start()
    if(istype(spawner))
        spawner.enable()
