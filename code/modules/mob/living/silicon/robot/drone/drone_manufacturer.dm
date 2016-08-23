/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in world)
		if(D.key && D.client)
			drones++
	return drones

/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing maintenance drones."

	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 5000

	var/fabricator_tag = "Exodus"
	var/drone_progress = 0
	var/produce_drones = 1
	var/time_last_drone = 500
	var/drone_type = /mob/living/silicon/robot/drone

	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"

/obj/machinery/drone_fabricator/derelict
	name = "construction drone fabricator"
	fabricator_tag = "Derelict"
	drone_type = /mob/living/silicon/robot/drone/construction

/obj/machinery/drone_fabricator/New()
	..()

/obj/machinery/drone_fabricator/power_change()
	..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/drone_fabricator/process()

	if(ticker.current_state < GAME_STATE_PLAYING)
		return

	if(stat & NOPOWER || !produce_drones)
		if(icon_state != "drone_fab_nopower") icon_state = "drone_fab_nopower"
		return

	if(drone_progress >= 100)
		icon_state = "drone_fab_idle"
		return

	icon_state = "drone_fab_active"
	var/elapsed = world.time - time_last_drone
	drone_progress = round((elapsed/config.drone_build_time)*100)

	if(drone_progress >= 100)
		visible_message("\The [src] voices a strident beep, indicating a drone chassis is prepared.")

/obj/machinery/drone_fabricator/examine(mob/user)
	..(user)
	if(produce_drones && drone_progress >= 100 && istype(user,/mob/dead) && config.allow_drone_spawn && count_drones() < config.max_maint_drones)
		user << "<BR><B>A drone is prepared. Select 'Join As Drone' from the Ghost tab to spawn as a maintenance drone.</B>"

/obj/machinery/drone_fabricator/proc/create_drone(var/client/player)

	if(stat & NOPOWER)
		return

	if(!produce_drones || !config.allow_drone_spawn || count_drones() >= config.max_maint_drones)
		return

	if(!player || !istype(player.mob,/mob/dead))
		return

	announce_ghost_joinleave(player, 0, "They have taken control over a maintenance drone.")
	visible_message("\The [src] churns and grinds as it lurches into motion, disgorging a shiny new drone after a few moments.")
	flick("h_lathe_leave",src)

	time_last_drone = world.time
	var/mob/living/silicon/robot/drone/new_drone = new drone_type(get_turf(src))
	new_drone.transfer_personality(player)
	new_drone.master_fabricator = src

	drone_progress = 0

/mob/dead/verb/join_as_drone()

	set category = "Ghost"
	set name = "Join As Drone"
	set desc = "If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a maintenance drone."


	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "<span class='danger'>The game hasn't started yet!</span>"
		return

	if(!(config.allow_drone_spawn))
		src << "<span class='danger'>That verb is not currently permitted.</span>"
		return

	if (!src.stat || !client)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if(jobban_isbanned(src,"Cyborg"))
		usr << "<span class='danger'>You are banned from playing synthetics and cannot spawn as a drone.</span>"
		return

	if(!MayRespawn(1))
		return

	var/deathtime = world.time - get_death_time(MINISYNTH)//get/set death_time functions are in mob_helpers.dm
	if(istype(src,/mob/dead/observer))
		var/mob/dead/observer/G = src
		if(G.has_enabled_antagHUD == 1 && config.antag_hud_restricted)
			usr << "<span class='notice'>Upon using the antagHUD you forfeighted the ability to join the round.</span>"
			return


	if (deathtime < RESPAWN_MINISYNTH)
		var/timedifference_text = time2text(RESPAWN_MINISYNTH - deathtime,"mm:ss")
		var/basetime = time2text(RESPAWN_MINISYNTH,"mm:ss")
		usr << "<span class='warning'>You may only spawn again as a drone more than [basetime] minutes after your death. You have [timedifference_text] left.</span>"
		return

	var/list/all_fabricators = list()
	for(var/obj/machinery/drone_fabricator/DF in world)
		if(DF.stat & NOPOWER || !DF.produce_drones)
			continue
		if(DF.drone_progress >= 100)
			all_fabricators[DF.fabricator_tag] = DF

	if(!all_fabricators.len)
		src << "<span class='danger'>There are no available drone spawn points, sorry.</span>"
		return

	var/choice = input(src,"Which fabricator do you wish to use?") as null|anything in all_fabricators
	if(choice)
		var/obj/machinery/drone_fabricator/chosen_fabricator = all_fabricators[choice]
		chosen_fabricator.create_drone(src.client)
