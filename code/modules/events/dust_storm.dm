/datum/event/dust_storm
    var/const/stormStart    = 30
    var/const/shredInterval = 5
    var/const/stormEnd      = 80
    announceWhen            = 1
    endWhen                 = stormEnd + 20
    var/postStartTicks      = 0
    var/stormDirection
    var/list/affectedItems  = list("walls" = list(), "windows" = list(), "doors" = list(), "mechs" = list())

/datum/event/dust_storm/announce()
    command_announcement.Announce("A dust storm is approaching the outpost. Everyone is advised to report inside.", "Storm Hazard")

/datum/event/dust_storm/start()
    stormDirection = rand(cardinal)
    findAffectedItems()
    updateOverlays(1, 155)

/datum/event/dust_storm/tick()
    var/damageLower
    var/damageUpper
    var/obstructMove

    if(activeFor <= stormStart)
        damageLower = 0
        damageUpper = 10
        obstructMove = 0
        postStartTicks++

    if(activeFor == stormStart)
        command_announcement.Announce("The storm has arrived. Please remain inside until the storm has passed.", "Storm Hazard")
        updateOverlays(2, 255)

    if(activeFor >= stormStart && activeFor <= stormEnd)
        damageLower = 10
        damageUpper = 30
        obstructMove = 1
        postStartTicks++

    if(postStartTicks == shredInterval)
        postStartTicks = 0
        shred(damageLower, damageUpper, obstructMove)

    if(activeFor == stormEnd)
        updateOverlays(2, 100)

/datum/event/dust_storm/end()
    command_announcement.Announce("The dust storm has passed. Please ensure that no harm has come to the station's superstructure.", "Storm Hazard")
    updateOverlays(3)

/datum/event/dust_storm/proc/shred(var/damageLower = 10, var/damageUpper = 30, var/obstructMove = 0)
    for(var/mob/living/C)
        if(!C.loc || !(C.loc.z in config.station_levels))
            continue

        if(obstructMove && istype(C, /mob/living/carbon/human))
            var/mob/living/carbon/human/H = C
            if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.flags & NOSLIP))
                obstructMove = 0

        if(istype(C.loc, /turf/planet))
            var/defenceZone = pick("head", "chest", "groin", "l_arm", "r_arm", "l_leg", "r_leg")
            C.apply_damage(rand(damageLower,damageUpper), BRUTE, defenceZone, 1, null, 1, 1)
            if(obstructMove)
                step(C, stormDirection)
            continue

        else if(istype(C.loc, /obj/mecha) && istype(C.loc.loc, /turf/planet))
            var/obj/mecha/targetMecha = C.loc
            targetMecha.take_damage(rand(damageLower, damageUpper))
            targetMecha.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
            if(!(targetMecha in affectedItems["mechs"]))
                targetMecha.log_message("Damage sustained from environmental hazard.")
                affectedItems["mechs"] += targetMecha
            continue

        else if(istype(C.loc, /obj/structure/closet) && istype(C.loc.loc, /turf/planet))
            var/obj/structure/closet/targetCloset = C.loc
            var/damage = rand(damageLower, damageUpper)
            if(damage >= targetCloset.health)
                targetCloset.visible_message("\red \the [src] gets shredded by the metal dust!")
            targetCloset.damage(damage)
            if(obstructMove)
                step(targetCloset, stormDirection)
            continue

    for(var/turf/simulated/wall/Wall in affectedItems["walls"])
        if(prob(25))
            Wall.take_damage(rand(damageLower,damageUpper))

    for(var/obj/structure/window/Window in affectedItems["windows"])
        if(prob(25))
            Window.take_damage(rand(damageLower,damageUpper))

    for(var/obj/machinery/door/Door in affectedItems["doors"])
        if(prob(25))
            Door.take_damage(rand(damageLower,damageUpper))

/datum/event/dust_storm/proc/findAffectedItems()
    var/checkDirection  = turn(stormDirection, 180)

    for(var/turf/simulated/wall/Wall)
        if(!(Wall.z in config.station_levels))
            continue
        var/turf/planet/T = get_step(Wall, checkDirection)
        if(!T || !istype(T))
            continue
        else
            affectedItems["walls"] += Wall

    for(var/obj/structure/window/Window)
        if(!(Window.z in config.station_levels))
            continue
        var/turf/planet/T = get_step(Window, checkDirection)
        if(!T || !istype(T))
            continue
        else
            affectedItems["windows"] += Window

    for(var/obj/machinery/door/Door)
        if(!(Door.z in config.station_levels))
            continue
        var/turf/planet/T = get_step(Door, checkDirection)
        if(!T || !istype(T))
            continue
        else
            affectedItems["doors"] += Door

/datum/event/dust_storm/proc/updateOverlays(var/state = 1, var/alpha = null)
    for(var/turf/planet/Planet)
        if(!(Planet.z in config.station_levels))
            continue
        switch(state)
            if(1)
                var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
                img.blend_mode = BLEND_MULTIPLY
                img.alpha = alpha
                Planet.storm_overlay = img
                Planet.overlays += Planet.storm_overlay
                continue
            if(2)
                Planet.overlays -= Planet.storm_overlay
                var/image/img = image(icon ='icons/turf/walls.dmi', icon_state = "overlay_damage")
                img.blend_mode = BLEND_MULTIPLY
                img.alpha = alpha
                Planet.storm_overlay = img
                Planet.overlays += Planet.storm_overlay
                continue
            if(3)
                Planet.overlays -= Planet.storm_overlay
                Planet.storm_overlay = ""
                continue
