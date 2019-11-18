

/obj/item/mecha_parts/mecha_tracking
	name = "exosuit tracking beacon"
	desc = "Device used to transmit exosuit data."
	icon = 'icons/obj/device.dmi'
	icon_state = "motion2"
	origin_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	var/control = 0//

/obj/item/mecha_parts/mecha_tracking/Initialize()
	. = ..()
	if (in_mecha())
		exo_beacons.Add(src)//For the sake of exosuits which spawn with a preinstalled tracking beacon

/obj/item/mecha_parts/mecha_tracking/Destroy()
	exo_beacons.Remove(src)
	return ..()

/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_info()
	if(!in_mecha())
		return 0
	var/obj/mecha/M = src.loc
	var/cell_charge = M.get_charge()
	var/answer = {"<b>Name:</b> [M.name]<br>
						<b>Integrity:</b> [M.health/initial(M.health)*100]%<br>
						<b>Cell charge:</b> [isnull(cell_charge)?"Not found":"[M.cell.percent()]%"]<br>
						<b>Airtank:</b> [M.return_pressure()]kPa<br>
						<b>Pilot:</b> [M.occupant||"None"]<br>
						<b>Location:</b> [get_area(M)||"Unknown"]<br>
						<b>Active equipment:</b> [M.selected||"None"]"}
	if(istype(M, /obj/mecha/working/ripley))
		var/obj/mecha/working/ripley/RM = M
		answer += "<b>Used cargo space:</b> [RM.cargo.len/RM.cargo_capacity*100]%<br>"

	return answer


//Alternate version of this proc for nanoui
/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_info_nano()
	if(!in_mecha())
		return 0
	var/obj/mecha/M = src.loc
	var/cell_charge = M.get_charge()
	var/list/answer = list()
	answer["name"] = M.name
	answer["health"] = round((M.health/initial(M.health))*100, 0.1)
	answer["charge"] = "[isnull(cell_charge)?"Not found":M.cell.percent()]%"
	answer["air"]	 = "[M.return_pressure()]"
	if (M.occupant)
		answer["pilot"]	=	M.occupant.name
	answer["location"]	=	get_area(M)
	answer["active"] = M.selected || "None"
	answer["ref"] = "\ref[src]"
	answer["control"] = control

	if(istype(M, /obj/mecha/working/ripley))
		var/obj/mecha/working/ripley/RM = M
		answer["cargo"] =  "[RM.cargo.len/RM.cargo_capacity*100]"

	return answer

/obj/item/mecha_parts/mecha_tracking/proc/install(var/obj/mecha/M, var/mob/living/user = null)
	if (!istype(M))
		return

	if (M.state < 3)
		to_chat(user, span("warning", "You need to open the maintenance panel in order to install \the [src]"))
		return

	for (var/obj/item/mecha_parts/mecha_tracking/B in M.contents)
		to_chat(user, span("warning", "[M] already has a tracker installed. Please remove the existing one."))
		return

	user.drop_from_inventory(src,M)
	playsound(get_turf(user), 'sound/items/Deconstruct.ogg', 50, 1)
	exo_beacons.Add(src)
	user.visible_message("[user] installs [src] in [M].", "You install [src] in [M]")

/obj/item/mecha_parts/mecha_tracking/proc/uninstall(var/mob/living/user)
	var/obj/mecha/M = in_mecha()
	if (!M)//This should never happen
		return

	user.put_in_hands(src)
	exo_beacons.Remove(src)
	user.visible_message("[user] removes [src] from [M].", "You remove [src] from [M]")


/obj/item/mecha_parts/mecha_tracking/emp_act()
	qdel(src)
	return

/obj/item/mecha_parts/mecha_tracking/ex_act(var/severity = 2.0)
	qdel(src)
	return

/obj/item/mecha_parts/mecha_tracking/proc/in_mecha()
	if(istype(src.loc, /obj/mecha))
		return src.loc
	return 0

/obj/item/mecha_parts/mecha_tracking/proc/shock(var/mob/user)
	return//No killswitch on the basic version

/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_log()
	if(!src.in_mecha())
		return 0
	var/obj/mecha/M = src.loc
	return M.get_log_html()




//Subclass of tracking beacon which has the killswitch function
/obj/item/mecha_parts/mecha_tracking/control
	control = 1
	name = "Exosuit Control Beacon"
	desc = "Device used to transmit exosuit data. Allows an administrator to trigger a killswitch and remotely shutdown the exosuit."

//Remote killswitch fucks everything up.
//The suit is probably not unsalvageable, but will require extensive repairs and be crippled
/obj/item/mecha_parts/mecha_tracking/control/shock(var/mob/user)
	var/obj/mecha/M = in_mecha()
	if(M)
		M.occupant_message(span("danger", "Remote termination protocol initiated. This exosuit is now shutting down, please exit immediately. Continued operation may incur disciplinary action or death of user."))
		M.emp_act(1)
		M.random_internal_damage(95)//Trigger all possible forms of internal damage
		M.misconfigure_systems(95)
		//Screw up all systems, including maintenance mode which will cause immediate stop
		M.log_message("Remote termination protocol initiated by [user].",1)

	qdel(src)

/obj/item/storage/box/mechabeacons
	name = "Exosuit Control Beacons"

/obj/item/storage/box/mechabeacons/fill()
	new /obj/item/mecha_parts/mecha_tracking/control(src)
	new /obj/item/mecha_parts/mecha_tracking/control(src)
	new /obj/item/mecha_parts/mecha_tracking/control(src)
	new /obj/item/mecha_parts/mecha_tracking/control(src)
	new /obj/item/mecha_parts/mecha_tracking/control(src)
	new /obj/item/mecha_parts/mecha_tracking/control(src)
	new /obj/item/mecha_parts/mecha_tracking/control(src)
