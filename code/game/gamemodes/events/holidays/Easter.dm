/proc/Easter_Game_Start()
    Random_Egg()

//Random egg :D
/proc/Random_Egg()
    world << "<h3>There is a random golden egg hidden somewhere on the station...</h3>"
    /var/list/turf/simulated/floor/Floorlist = list()
    for(var/turf/simulated/floor/T)
        if(T.contents)
            Floorlist += T
    var/turf/simulated/floor/F = Floorlist[rand(1,Floorlist.len)]
    Floorlist = null
    var/obj/structure/closet/C = locate(/obj/structure/closet) in F
    if (C)
        new /obj/item/weapon/reagent_containers/food/snacks/goldenegg(C)
    else
        new /obj/item/weapon/reagent_containers/food/snacks/goldenegg(F)
    var/list/obj/containers = list()
    for(var/obj/item/weapon/storage/S in world)
        if(isNotStationLevel(S.z))	continue
        containers += S
