/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_GLASS = 2000)
	chemicals = list(/singleton/reagent/acid = 20)

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		if(ispath(build_path, /obj/item/circuitboard))
			var/obj/item/circuitboard/CB = build_path
			var/atom/machine = initial(CB.build_path)
			desc = "Used in the construction of a: <b>[capitalize_first_letters(initial(machine.name))]</b>, [initial(machine.desc)]"
		else
			var/atom/A = build_path
			desc = initial(A.desc)
