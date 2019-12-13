//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	density = 1
	anchored = 1.0

	light_color = LIGHT_COLOR_CYAN
	icon_screen = "crew"
	circuit = /obj/item/circuitboard/operating
	var/mob/living/carbon/human/victim = null
	var/obj/machinery/optable/table = null

/obj/machinery/computer/operating/Initialize()
	. = ..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable, get_step(src, dir))
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operating/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)


/obj/machinery/computer/operating/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)


/obj/machinery/computer/operating/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=op")
			return

	user.set_machine(src)
	var/dat = "<HEAD><TITLE>Operating Computer</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[user];mach_close=op'>Close</A><br><br>" //| <A HREF='?src=\ref[user];update=1'>Update</A>"
	if(src.table && (src.table.check_victim()))
		src.victim = src.table.victim
		var/brain_result = "normal"
		if(victim.should_have_organ(BP_BRAIN))
			var/obj/item/organ/internal/brain/brain = victim.internal_organs_by_name[BP_BRAIN]
			if(!brain || victim.stat == DEAD || (victim.status_flags & FAKEDEATH))
				brain_result = "<span class='scan_danger'>none, patient is braindead</span>"
			else if(victim.stat != DEAD)
				if(istype(brain))
					switch(brain.get_current_damage_threshold())
						if(0)
							brain_result = "normal"
						if(1 to 2)
							brain_result = "<span class='scan_notice'>minor brain damage</span>"
						if(3 to 5)
							brain_result = "<span class='scan_warning'>weak</span>"
						if(6 to 8)
							brain_result = "<span class='scan_danger'>extremely weak</span>"
						if(9 to INFINITY)
							brain_result = "<span class='scan_danger'>fading</span>"
						else
							brain_result = "<span class='scan_danger'>ERROR - Hardware fault</span>"
				else
					if(victim.isFBP())
						brain_result = "normal"
					else
						brain_result = "<span class='scan_danger'>ERROR - Organ not recognized</span>"
		else
			brain_result = "<span class='scan_danger'>ERROR - Non-standard biology</span>"
		dat += {"
<B>Patient Information:</B><BR>
Brain Activity: <b>[brain_result]</b><br>
Pulse: <b>[victim.get_pulse(GETPULSE_TOOL)]</b><br>
BP: <b>[victim.get_blood_pressure()]</b><br>
Blood Oxygenation: <b>[victim.get_blood_oxygenation()]</b><br>
"}
	else
		src.victim = null
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>No Patient Detected</B>
"}
	user << browse(dat, "window=op")
	onclose(user, "op")

/obj/machinery/computer/operating/Topic(href, href_list)
	if(..())
		return 1
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
	return


/obj/machinery/computer/operating/machinery_process()
	if(operable())
		src.updateDialog()