//////Exile implants will allow you to use the station gate, but not return home. This will allow security to exile badguys/for badguys to exile their kill targets////////


	name = "implanter-exile"

	..()
	update()
	return


	name = "exile"
	desc = "Prevents you from returning from away missions"

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [current_map.company_name] Employee Exile Implant<BR>
<b>Implant Details:</b> The onboard gateway system has been modified to reject entry by individuals containing this implant<BR>"}
		return dat

	name = "Glass Case- 'Exile'"
	desc = "A case containing an exile implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-r"


	New()
		..()
		return


/obj/structure/closet/secure_closet/exile
	name = "Exile Implants"
	req_access = list(access_hos)

	New()
		..()
		sleep(2)
		return
