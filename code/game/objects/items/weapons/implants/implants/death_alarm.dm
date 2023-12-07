#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

/obj/item/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."
	icon_state = "implant_deathalarm"
	implant_icon = "deathalarm"
	implant_color = "#9cdb43"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3, TECH_DATA = 2)
	default_action_type = null
	known = TRUE
	var/mobname = "Will Robinson"

/obj/item/implant/death_alarm/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Idris Incorporated ID-15 \"Profit Margin\" Class Sapient Lifesign Sensor<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
<b>Special Features:</b> Alerts crew to crewmember death.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/implant/death_alarm/process()
	if (!implanted)
		return
	var/mob/M = imp_in

	if(QDELETED(M)) // If the mob got gibbed
		M = null
		activate(null)
	else if(M.stat == DEAD)
		activate("death")

/obj/item/implant/death_alarm/activate(cause = "emp")
	if (malfunction)
		return
	var/mob/M = imp_in
	var/area/A = get_area(M)
	var/location = A.name
	if(cause == "emp" && prob(50))
		location = pick(teleportbeacons)
	if(!A.requires_power) // We assume areas that don't use power are special zones
		var/area/default = world.area
		location = initial(default.name)
	var/death_message = "[mobname] has died in [location]!"
	if(!cause)
		death_message = "[mobname] has died-zzzzt in-in-in..."
	STOP_PROCESSING(SSprocessing, src)

	for(var/channel in list("Security", "Medical", "Command"))
		global_announcer.autosay(death_message, "[mobname]'s Death Alarm", channel)

/obj/item/implant/death_alarm/emp_act(severity)			//for some reason alarms stop going off in case they are emp'd, even without this
	if (malfunction)		//so I'm just going to add a meltdown chance here
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")	//let's shout that this dude is dead
	if(severity == 1)
		if(prob(40))	//small chance of obvious meltdown
			meltdown()
		else if (prob(60))	//but more likely it will just quietly die
			malfunction = MALFUNCTION_PERMANENT
		STOP_PROCESSING(SSprocessing, src)

	spawn(20)
		malfunction--

/obj/item/implant/death_alarm/implanted(mob/source as mob)
	mobname = source.real_name
	START_PROCESSING(SSprocessing, src)
	return TRUE

#undef MALFUNCTION_TEMPORARY
#undef MALFUNCTION_PERMANENT

/obj/item/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	imp = /obj/item/implant/death_alarm
