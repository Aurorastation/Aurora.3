/obj/item/weapon/ladder_mobile
	name = "mobile ladder"
	desc = "A lightweight deployable ladder. Used to move vertical. Or to bash face in with."
	icon_state = "ladder01"
	icon = 'icons/obj/structures.dmi'
    throw_range = 3
    throw_force = 12
    force = 10

/obj/item/weapon/ladder_mobile/proc/place_ladder(atom/A,mob/user)

    if(istype(A, /turf/simulated/open))         //Place into open space
        user.visible_message("<span class='warning'>[user] begins to lower the ladder into the hole</span>")
        var/turf/below_loc = GetBelow(A)
        if (!below_loc || (istype(/turf/space,GetBelow(src))))
            user << "<span class='notice'>Why would you do that?!</span>"
            return
        var/obj/structure/ladder/mobile/body/R = new(A)
        var/obj/structure/ladder/mobile/base/D = new(A)
        D.forceMove(below_loc)
        R.target_down = D 
        D.target_up = R

        user.drop_item()
        qdel(src)

    if(istype(A, /turf/simulated/floor))        //Place onto Floor
        user.visible_message("<span class='warning'>[user] begins deploying the ladder on the floor</span>")
        var/turf/upper_loc = GetAbove(A)
        if (!upper_loc || !istype(upper_loc,/turf/simulated/open))
            user << "<span class='notice'>There is something above. You can't deploy!</span>"
            return
        
        var/obj/structure/ladder/mobile/base/R = new(A)
        var/obj/structure/ladder/mobile/body/D = new(A)
        D.forceMove(upper_loc) // moves A up to upper_loc.
        R.target_up = D
        D.target_down = R

        user.drop_item()
        qdel(src)

/obj/item/weapon/ladder_mobile/afterattack(atom/A, mob/user,proximity) 
    if(!proximity)
        return
    addtimer(CALLBACK(src, .proc/place_ladder, A, user), 5000)
    
    //place_ladder(A,user)
    





