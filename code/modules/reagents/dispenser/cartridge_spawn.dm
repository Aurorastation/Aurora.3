/client/proc/spawn_chemdisp_cartridge(size in list("small", "medium", "large"), reagent in decls_repository.get_decls_of_subtype(/decl/reagent/))
	set name = "Spawn Chemical Dispenser Cartridge"
	set category = "Admin"

	var/obj/item/reagent_containers/chem_disp_cartridge/C
	switch(size)
		if("small") C = new /obj/item/reagent_containers/chem_disp_cartridge/small(usr.loc)
		if("medium") C = new /obj/item/reagent_containers/chem_disp_cartridge/medium(usr.loc)
		if("large") C = new /obj/item/reagent_containers/chem_disp_cartridge(usr.loc)
	C.reagents.add_reagent(reagent, C.volume)
	var/decl/reagent/R = decls_repository.get_decl(reagent)
	C.setLabel(R.name)
	log_admin("[key_name(usr)] spawned a [size] reagent container containing [reagent] at ([usr.x],[usr.y],[usr.z])",admin_key=key_name(usr))
