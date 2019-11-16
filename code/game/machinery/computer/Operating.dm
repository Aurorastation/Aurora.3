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
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>Name:</B> [src.victim.real_name]<BR>
<B>Age:</B> [src.victim.age]<BR>
<B>Blood Type:</B> [src.victim.b_type]<BR>
<BR>
<B>Health:</B> [src.victim.health]<BR>
<B>Brute Damage:</B> [src.victim.getBruteLoss()]<BR>
<B>Toxins Damage:</B> [src.victim.getToxLoss()]<BR>
<B>Fire Damage:</B> [src.victim.getFireLoss()]<BR>
<B>Suffocation Damage:</B> [src.victim.getOxyLoss()]<BR>
<B>Patient Status:</B> [src.victim.stat ? "Non-Responsive" : "Stable"]<BR>
<B>Heartbeat rate:</B> [victim.get_pulse(GETPULSE_TOOL)]<BR>
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




/obj/machinery/computer/operating/advanced
	name = "advanced operating computer"
	density = 1
	anchored = 1.0
	icon_state = "crew"
	icon_state = "computer"
	circuit = /obj/item/circuitboard/advoperating
	interact_offline = 0
	var/screen = 1

/obj/machinery/computer/operating/advanced/New()
	..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable/lifesupport, get_step(src, dir))
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operating/advanced/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)


/obj/machinery/computer/operating/advanced/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/operating/advanced/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if (user.stat)
		return

	if (table && table.victim == user)
		return

	var/data[0]

	data["table"] = 0
	data["screen"] = screen
	if (table)
		if (istype(table, /obj/machinery/optable/lifesupport))
			data["table"] = 2
		else
			data["table"] = 1

		if (screen == 1)
			var/patientgeneral[0]
			var/patienthealth[0]
			if (table.victim)
				var/mob/living/carbon/human/patient = table.victim
				patientgeneral["Name"] = patient.real_name
				patientgeneral["Age"] = patient.age
				patientgeneral["BloodType"] = patient.b_type
				data["patientgeneral"] = patientgeneral;

				patienthealth["Health"] = round(patient.health)
				patienthealth["Brute"] = round(patient.getBruteLoss())
				patienthealth["Toxins"] = round(patient.getToxLoss())
				patienthealth["Burn"] = round(patient.getFireLoss())
				patienthealth["Suffocation"] = round(patient.getOxyLoss())
				patienthealth["Status"] = patient.stat ? "Non-responsive" : "Stable"
				patienthealth["Heartrate"] = patient.get_pulse(GETPULSE_TOOL)
				if (data["table"] == 2)
					patienthealth["BloodLevel"] = round(patient.vessel.get_reagent_amount("blood"))
				data["patienthealth"] = patienthealth;

			if (data["table"] == 2)
				var/obj/machinery/optable/lifesupport/A = table
				data["buckled"] = A.buckled
				data["lifesupport"] = A.onlifesupport()

				if (A.reagents.reagent_list.len)
					data["hasreagents"] = 1
					var/loadedreagents[0]
					for(var/datum/reagent/chem in A.reagents.reagent_list)
						loadedreagents.Add(list(list("name" = chem.name, "volume" = round(chem.volume))))
					data["loadedreagents"] = loadedreagents;
				else
					data["hasreagents"] = 0

				if (A.airsupply)
					data["hasair"] = 1
					var/air[0]
					air["internalpressure"] = round(A.airsupply.air_contents.return_pressure())
					air["releasepressure"] = round(A.airsupply.distribute_pressure)
					data["air"] = air;
				else
					data["hasair"] = 0

				if (A.bloodbag)
					data["hasblood"] = 1
					var/blood[0]
					blood["volume"] = A.bloodbag.reagents.total_volume
					if (A.bloodbag.reagents.reagent_list.len)
						for (var/datum/reagent/blood/Blood in A.bloodbag.reagents.reagent_list)
							blood["type"] = Blood.data["blood_type"]
					else
						blood["type"] = "N/A"
					data["blood"] = blood;
				else
					data["hasblood"] = 0

				var/program[0]
				program["autotransfuse"] = A.checkprogram("AUTO_TRANSFUSE")
				program["transfuseactive"] = A.checkprogram("TRANSFUSE_ACTIVE")
				program["autoair"] = A.checkprogram("AUTO_AIR")
				program["airactive"] = A.checkprogram("AIR_ACTIVE")
				program["purge"] = A.checkprogram("PURGE")
				program["emagged"] = A.emagged
				data["program"] = program;

		else if (screen == 2)
			if (data["table"] == 1)
				screen = 1
				return

			var/obj/machinery/optable/lifesupport/B = table
			data["log"] = B.internallog;

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "operating_computer.tmpl", "Operating Computer", 540, 680)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/computer/operating/advanced/Topic(href, href_list)
	if(..())
		return

	if (istype(table, /obj/machinery/optable/lifesupport))
		var/obj/machinery/optable/lifesupport/A = table
		if (href_list["toggle_lifesupport"])
			A.toggleactive()
			return 1
		if (href_list["eject_advanced"])
			A.eject(href_list["eject_advanced"])
			return 1
		if (href_list["toggle_program"])
			A.toggleprogram(null, href_list["toggle_program"])
			return 1
		if (href_list["select_screen"])
			screen = text2num(href_list["select_screen"])
			return 1
		if (href_list["clear_log"])
			A.clearlog()
			return 1
	return 1
