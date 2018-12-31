
/obj/machinery/computer/artillerycontrol
	var/reload = 180
	name = "bluespace artillery control"
	icon_state = "control_boxp1"
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	density = 1
	anchored = 1

/obj/machinery/computer/artillerycontrol/machinery_process()
	if(src.reload<180)
		src.reload++

/obj/machinery/computer/artillerycontrol/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "<B>Bluespace Artillery Control:</B><BR>"
	dat += "Locked on<BR>"
	dat += "<B>Charge progress: [reload]/180:</B><BR>"
	dat += "<A href='byond://?src=\ref[src];fireArea=1'>Open Fire - Area</A><BR>"
	dat += "<A href='byond://?src=\ref[src];fireCords=1'>Open Fire - Coordinates</A><BR>"
	dat += "Deployment of weapon authorized by <br>[current_map.company_name] Chief Naval Director<br><br>Remember, friendly fire is grounds for termination of your contract and life.<HR>"
	user << browse(dat, "window=scroll")
	onclose(user, "scroll")
	return

/obj/machinery/computer/artillerycontrol/Topic(href, href_list, var/datum/topic_state/state = default_state)
	if(..())
		return 1

	if(href_list["fireArea"])
		var/area/A = input("Area to jump bombard", "Open Fire") in all_areas
		var/turf/loc = pick(get_area_turfs(A))
		announce_and_fire(loc, usr)
	else if(href_list["fireCords"])
		var/ix = text2num(input("X"))
		var/iy = text2num(input("Y"))
		var/iz = text2num(input("Z"))
		if(!ix || !iy || !iz)
			return
		var/turf/T = get_turf(locate(ix, iy, iz))
		announce_and_fire(T, usr)

/obj/machinery/computer/artillerycontrol/proc/announce_and_fire(var/turf/t, var/mob/user)
	if(!istype(t))
		return
	command_announcement.Announce("Bluespace artillery fire detected. Brace for impact.")
	to_world(sound('sound/effects/yamato_fire.ogg'))
	message_admins("[key_name_admin(user)] has launched an artillery strike.", 1)
	explosion(t,2,5,11)
	reload = 0

/obj/structure/artilleryplaceholder
	name = "artillery"
	icon = 'icons/obj/machines/artillery.dmi'
	anchored = 1
	density = 1

/obj/structure/artilleryplaceholder/decorative
	density = 0