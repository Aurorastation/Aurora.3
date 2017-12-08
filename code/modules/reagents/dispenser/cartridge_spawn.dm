/client/proc/spawn_chemdisp_cartridge(size in list("small", "medium", "large"), reagent in chemical_reagents_list)
	set name = "Spawn Chemical Dispenser Cartridge"
	set category = "Admin"

	switch(size)
	C.reagents.add_reagent(reagent, C.volume)
	var/datum/reagent/R = chemical_reagents_list[reagent]
	C.setLabel(R.name)
	log_admin("[key_name(usr)] spawned a [size] reagent container containing [reagent] at ([usr.x],[usr.y],[usr.z])",admin_key=key_name(usr))
