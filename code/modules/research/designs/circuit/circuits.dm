/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_GLASS = 2000, MATERIAL_PHORON = 25)
	chemicals = list(/singleton/reagent/acid = 20)
	var/list/flatpak_materials

/datum/design/circuit/New()
	..()
	if(!(build_type & MECHFAB))
		return
	var/obj/item/circuitboard/board = build_path
	var/product_path = initial(board.build_path)
	if(istext(product_path))
		product_path = text2path(product_path)
	if(!ispath(product_path, /obj))
		build_type &= ~MECHFAB

/datum/design/circuit/GetFabricationName(var/fabricator)
	if(istype(fabricator, /obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator))
		return "[name] flatpak"
	return ..()

/datum/design/circuit/GetFabricationDesc(var/fabricator)
	if(istype(fabricator, /obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator))
		return "A deployable flatpak containing everything needed to set up \a [lowertext(name)]."
	return ..()

/datum/design/circuit/GetFabricationMaterials(var/fabricator)
	if(!istype(fabricator, /obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator))
		return ..()
	if(flatpak_materials)
		return flatpak_materials

	// Start with the material cost of printing the circuit board itself.
	flatpak_materials = materials.Copy()
	var/obj/item/circuitboard/board = new build_path

	// Both computer frames and normal machine blueprints consume five cable lengths.
	var/obj/item/stack/cable_coil/cable = new
	for(var/material in cable.matter)
		flatpak_materials[material] = (flatpak_materials[material] || 0) + (cable.matter[material] * 5)
	qdel(cable)

	if(board.board_type == BOARD_COMPUTER)
		// A computer frame consumes five steel sheets and two glass sheets.
		flatpak_materials[MATERIAL_STEEL] = (flatpak_materials[MATERIAL_STEEL] || 0) + (5 * SHEET_MATERIAL_AMOUNT)
		flatpak_materials[MATERIAL_GLASS] = (flatpak_materials[MATERIAL_GLASS] || 0) + (2 * SHEET_MATERIAL_AMOUNT)
	else
		// A normal machine blueprint consumes two steel sheets.
		flatpak_materials[MATERIAL_STEEL] = (flatpak_materials[MATERIAL_STEEL] || 0) + (2 * SHEET_MATERIAL_AMOUNT)

		// Add the raw material value of every component required by the related board.
		for(var/component_type in board.req_components)
			var/component_path = component_type
			if(istext(component_path))
				component_path = text2path(component_path)
			if(!ispath(component_path, /obj/item))
				continue
			var/obj/item/component = new component_path
			var/component_count = board.req_components[component_type]
			for(var/material in component.matter)
				flatpak_materials[material] = (flatpak_materials[material] || 0) + (component.matter[material] * component_count)
			qdel(component)
	qdel(board)

	SSmaterials.normalize_material_amounts(flatpak_materials)
	return flatpak_materials

/datum/design/circuit/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator))
		return new /obj/item/flatpak(newloc, build_path, GetFabricationMaterials(fabricator))
	return ..()

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		if(ispath(build_path, /obj/item/circuitboard))
			var/obj/item/circuitboard/CB = build_path
			var/atom/machine = initial(CB.build_path)
			desc = "Used in the construction of a: [capitalize_first_letters(initial(machine.name))], [initial(machine.desc)]"
		else
			var/atom/A = build_path
			desc = initial(A.desc)
