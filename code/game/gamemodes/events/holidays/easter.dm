/proc/Easter_Game_Start()
    Random_Egg()

//Random egg
/proc/Random_Egg()
    to_world("<h3>There is a golden egg hidden somewhere on the station...</h3>")
    var/list/Floorlist = list()
    for(var/turf/T in world)
        var/turf/simulated/floor/F = T
        if(istype(F) && F.contents)
            Floorlist += T
    var/turf/simulated/floor/F = Floorlist[rand(1,Floorlist.len)]
    Floorlist = null
    var/obj/structure/closet/C = locate(/obj/structure/closet) in F
    if (C)
        new /obj/item/reagent_containers/food/snacks/goldenegg(C)
    else
        new /obj/item/reagent_containers/food/snacks/goldenegg(F)
