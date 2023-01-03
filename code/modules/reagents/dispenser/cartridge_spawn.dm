/client/proc/spawn_chemdisp_cartridge(size in list("small", "medium", "large"))
	set name = "Spawn Chemical Dispenser Cartridge"
	set category = "Admin"

	var/rtype = input("Enter full or partial reagent path.", "Reagent Search") as text
	if(!rtype)
		return

	var/list/matches
	for(var/path in Singletons.GetSubtypeList(/singleton/reagent/))
		if(findtext("[path]", rtype))
			LAZYADD(matches, path)

	var/reagent
	if(!LAZYLEN(matches))
		return

	if(LAZYLEN(matches) == 1)
		reagent = matches[1]
	else
		reagent = input("Select a reagent type", "Pick reagent", matches[1]) as null|anything in matches
		if(!reagent)
			return

	var/obj/item/reagent_containers/chem_disp_cartridge/C
	switch(size)
		if("small") C = new /obj/item/reagent_containers/chem_disp_cartridge/small(usr.loc)
		if("medium") C = new /obj/item/reagent_containers/chem_disp_cartridge/medium(usr.loc)
		if("large") C = new /obj/item/reagent_containers/chem_disp_cartridge(usr.loc)
	C.reagents.add_reagent(reagent, C.volume)
	var/singleton/reagent/R = GET_SINGLETON(reagent)
	C.setLabel(R.name)
	log_admin("[key_name(usr)] spawned a [size] reagent container containing [reagent] at ([usr.x],[usr.y],[usr.z])",admin_key=key_name(usr))