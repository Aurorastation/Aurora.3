/obj/machinery/computer/assembly_fab
	name = "R&D assembly fabricator"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	req_access = list(access_research)	//Data and setting manipulation requires scientist access.
    var/list/available_cases

/obj/machinery/computer/assembly_fab/proc/CallMaterialName(var/ID)
	var/return_name = ID
	switch(return_name)
		if("metal")
			return_name = "Metal"
		if("glass")
			return_name = "Glass"
		if("gold")
			return_name = "Gold"
		if("silver")
			return_name = "Silver"
		if("phoron")
			return_name = "Solid Phoron"
		if("uranium")
			return_name = "Uranium"
		if("diamond")
			return_name = "Diamond"
	return return_name

/obj/machinery/computer/assembly_fab/Initialize()
	. = ..()
	SSresearch.assembly_fabs += src
    available_cases = SSresearch.get_cases()