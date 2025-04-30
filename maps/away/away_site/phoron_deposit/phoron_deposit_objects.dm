//Fauna spawner object
/obj/effect/fauna_spawner
	name = "Fauna spawner"
	desc = "A fauna spawner you're not supposed to see"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "ghostspawpoint"

	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

	var/first_spawn_done = FALSE
	var/spawning_enabled = FALSE
	var/list/active_mobs = list()
	var/max_active_mobs = 5
	var/pit_present = FALSE
	var/list/mob_choices = list(
        /mob/living/simple_animal/hostile/carp/phoron_deposit,
        /mob/living/simple_animal/hostile/carp/shark/phoron_deposit,
        /mob/living/simple_animal/hostile/carp/shark/reaver/phoron_deposit,
        /mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit,
        /mob/living/simple_animal/hostile/gnat/phoron_deposit
    )

/obj/effect/fauna_spawner/Initialize()
	. = ..()
	if(!islist(GLOB.fauna_spawners))
		GLOB.fauna_spawners = list()
	GLOB.fauna_spawners |= src
	first_spawn_done = FALSE

/obj/effect/fauna_spawner/Destroy()
    if(islist(GLOB.fauna_spawners))
        GLOB.fauna_spawners -= src
    return ..()

/obj/effect/fauna_spawner/proc/start_spawning()
    if (spawning_enabled)
        return
    spawning_enabled = TRUE
    spawn()
        while (spawning_enabled && src)
            if (length(active_mobs) < max_active_mobs)
                spawn_mob()
            sleep(rand(5 SECONDS, 10 SECONDS))

/obj/effect/fauna_spawner/proc/spawn_mob()
    var/mob_type
    if (!first_spawn_done)
        mob_type = /mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit
        first_spawn_done = TRUE
    else
        mob_type = pick(mob_choices)
    var/mob/living/simple_animal/hostile/new_mob = new mob_type(src.loc)
    if (!new_mob)
        return
    new_mob.spawner_source = src
    active_mobs += new_mob
    if (!pit_present)
        new /obj/structure/pit(src.loc)
        pit_present = TRUE

/obj/effect/fauna_spawner/proc/mob_died(var/mob/living/simple_animal/hostile/mob_ref)
     active_mobs -= mob_ref

/obj/effect/fauna_spawner/proc/stop_spawning()
    spawning_enabled = FALSE

/proc/activate_fauna_spawners(var/z)
    if(!islist(GLOB.fauna_spawners) || !length(GLOB.fauna_spawners))
        return
    for(var/obj/effect/fauna_spawner/F in GLOB.fauna_spawners)
        if(F?.loc?.z == z)
            F.start_spawning()

// Mob stuff

/mob/living/simple_animal/hostile/carp/shark/phoron_deposit
	maxHealth = 55
	health = 55

/mob/living/simple_animal/hostile/carp/shark/reaver/phoron_deposit
	maxHealth = 55
	health = 55
	speed = 5

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit
	maxHealth = 70
	health = 70
	speed = 3
	var/tmp/wall_breaking_allowed = FALSE // The eel gets to break walls just to make sure the event can't be cheesed by building them
	var/tmp/breaking_wall = FALSE
	var/tmp/target_turf = null

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit/Move(NewLoc)
	if(!wall_breaking_allowed)
		return ..()

	if(!breaking_wall)
		if(istype(NewLoc, /turf/simulated/wall))
			breaking_wall = TRUE
			var/turf/wall = NewLoc
			spawn(0)
				sleep(5 SECONDS)
				if(wall && istype(wall, /turf/simulated/wall) && wall == get_turf(wall) && get_dist(src, wall) == 1)
					visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down the [wall]!"))
					playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
					wall.ChangeTurf(/turf/simulated/floor/exoplanet/asteroid/ash/rocky)
					new /obj/effect/decal/cleanable/floor_damage/broken6(get_turf(wall))
				breaking_wall = FALSE
			return FALSE

	return ..()

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit/Initialize()
	. = ..()
	target_turf = locate(132, 176, src.z) //The coordinates lead to the phoron deposit
	if (isturf(target_turf))
		wall_breaking_allowed = TRUE
		GLOB.move_manager.move_towards(src, target_turf, 5, TRUE) //The mobs move to the deposit at different speeds. Hence why they aren't initialized under a shared proc

/mob/living/simple_animal/hostile/carp/phoron_deposit/Initialize()
    . = ..()
    var/turf/target = locate(132, 176, src.z)
    if (isturf(target))
        GLOB.move_manager.move_towards(src, target, 3, TRUE)

/mob/living/simple_animal/hostile/carp/shark/phoron_deposit/Initialize()
    . = ..()
    var/turf/target = locate(132, 176, src.z)
    if (isturf(target))
        GLOB.move_manager.move_towards(src, target, 3, TRUE)

/mob/living/simple_animal/hostile/carp/shark/reaver/phoron_deposit/Initialize()
    . = ..()
    var/turf/target = locate(132, 176, src.z)
    if (isturf(target))
        GLOB.move_manager.move_towards(src, target, 5, TRUE)

/mob/living/simple_animal/hostile/gnat/phoron_deposit/Initialize()
    . = ..()
    var/turf/target = locate(132, 176, src.z)
    if (isturf(target))
        GLOB.move_manager.move_towards(src, target, 1, TRUE)

/mob/living/simple_animal/hostile/proc/phoron_deposit_death_notify()
    if(spawner_source)
        spawner_source.mob_died(src)

/mob/living/simple_animal/hostile/carp/phoron_deposit/death()
    ..()
    phoron_deposit_death_notify()

/mob/living/simple_animal/hostile/carp/shark/phoron_deposit/death()
    ..()
    phoron_deposit_death_notify()

/mob/living/simple_animal/hostile/carp/shark/reaver/phoron_deposit/death()
    ..()
    phoron_deposit_death_notify()

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit/death()
    ..()
    phoron_deposit_death_notify()

/mob/living/simple_animal/hostile/gnat/phoron_deposit/death()
    ..()
    phoron_deposit_death_notify()

// Phoron deposit turf

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit
	name = "phoron deposit"
	desc = "A rare deposit, full of crystal phoron. You can drill it to extract it, but you've a feeling you should prepare accordingly first..."
	var/mineral_amount = 300

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit/Initialize()
	..()
	var/turf/T = get_turf(src)
	if (T)
		T.has_resources = TRUE
		if (!T.resources)
			T.resources = list()
		T.resources[ORE_PHORON] = mineral_amount

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit/Destroy()
	var/turf/T = get_turf(src)
	if (T && T.resources)
		T.resources[ORE_PHORON] = max(0, T.resources[ORE_PHORON] - mineral_amount)
		if (T.resources[ORE_PHORON] <= 0)
			T.resources -= ORE_PHORON
		if (!length(T.resources))
			T.has_resources = FALSE
	..()

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit/gets_dug(var/mob/user)
	..()
	for (var/mob/M in view(null, src))
		M.show_message(SPAN_DANGER("You struggle to retain your balance as the ground beneath you violently tremors. This can't be just the work of the drill, something is coming!<br>"), 1)
	for (var/mob/L in world)
		if (L.client && L.z == src.z)
			if (!L.client.prefs || (L.client.prefs.sfx_toggles & ASFX_MUSIC))
				sound_to(L, 'sound/music/phoron_deposit.ogg')
	sleep(16 SECONDS)
	activate_fauna_spawners(src.z)

//Corpse
/obj/effect/landmark/corpse/einstein
	name = "Einstein Prospector"
	corpseuniform = /obj/item/clothing/under/rank/einstein
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/einstein
	corpsesuit = /obj/item/clothing/suit/space/void/einstein
	corpseid = TRUE
	corpseidjob = "Prospector (Einstein)"
	corpseidicon = "einstein_card"
	corpsepocket1 = /obj/item/storage/wallet/random

//Paper
/obj/item/paper/phoron_deposit/briefing_note
	name = "printed message"
	desc = "A message printed from a computer."
	info = "<h4>Einstein Engines Internal Communication</h4><br>\
From: Central Command<br>\
To: EEV Origination<br>\
<br>\
We have received credible intelligence that a large Conglomerate vessel is inbound to the sector, the sensor equipment on this vessel is very likely to detect the deposit. Therefore, awaiting further reinforcements is no longer an option. The deposit must be extracted before our competitors reach it.<br>\
<br>\
We understand your concerns regarding the caverns and the presence of fauna. We've prepared a plan of action to ensure the extraction is conducted safely, despite shortage of personnel.<br>\
<br>\
1. Gather all available resources.<br>\
An abundance of ammunition may prove necessary, bring as much as possible. Steel and plasteel will also be required in order to fortify the area around your drilling equipment. Additionally, you are advised to bring medicinal injectors in the event of an emergency, especially painkillers.<br>\
<br>\
2. Construct a defensive perimeter around the deposit. <br>\
Steel and plasteel barricades with barbed wire are advised. Construct several layers, if there is sufficient material to do so.<br>\
<br>\
3. Begin drilling operations.<br>\
Be prepared to defend yourselves upon activation of drilling equipment. We estimate that extracting the deposit entirely will take approximately 15 minutes.<br>\
<br>\
4. Evacuate the site.<br>\
Once the deposit is empty, abandon the defenses and quickly exfiltrate with the phoron. Should the presence of fauna be as intense as we anticipate, it is vital that the area is evacuated with haste. Do not attempt to hold the position.<br>\
<br>\
Follow these steps precisely, and the likelihood of a swift and safe extraction is high. Report back immediately upon mission success.<br>\
<br>\
Good luck.<br>\
<font size=1>Einstein Engines. Lead by our history, leading our future.</font>"
