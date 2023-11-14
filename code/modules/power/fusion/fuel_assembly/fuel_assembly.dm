/obj/item/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machinery/fusion.dmi'
	icon_state = "fuel_assembly"

	var/material_name
	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/fuel_type
	var/fuel_colour
	var/radioactivity = 0
	var/initial_amount

/obj/item/fuel_assembly/New(newloc, _material, _colour)
	if(_material)
		fuel_type = _material
	if(_colour)
		fuel_colour = _colour
	..(newloc)

/obj/item/fuel_assembly/Initialize()
	. = ..()

	if(ispath(fuel_type, /singleton/reagent))
		var/singleton/reagent/R = GET_SINGLETON(fuel_type)
		fuel_type = lowertext(initial(R.name))
		fuel_colour = initial(R.color)
		initial_amount = 50000

	var/material/material = SSmaterials.get_material_by_name(fuel_type)
	if(istype(material))
		initial_amount = SHEET_MATERIAL_AMOUNT * 5 // Fuel compressor eats 5 sheets.
		name = "[material.use_name] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [material.use_name]."
		fuel_colour = material.icon_colour
		fuel_type = material.use_name
		if(material.radioactivity)
			radioactivity = material.radioactivity
			desc += " It is warm to the touch."
			START_PROCESSING(SSprocessing, src)
		if(material.luminescence)
			set_light(material.luminescence, material.luminescence, material.icon_colour)
	else
		name = "[fuel_type] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [fuel_type]."

	icon_state = "blank"
	var/image/I = image(icon, "fuel_assembly")
	I.color = fuel_colour
	overlays += list(I, image(icon, "fuel_assembly_bracket"))
	rod_quantities[fuel_type] = initial_amount

/obj/item/fuel_assembly/process()
	. = ..()
	if(!radioactivity)
		return PROCESS_KILL

	if(isturf(loc))
		SSradiation.radiate(src, max(1,Ceil(radioactivity/15)))

/obj/item/fuel_assembly/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

// Mapper shorthand.
/obj/item/fuel_assembly/deuterium/New(newloc)
	..(newloc, MATERIAL_DEUTERIUM)

/obj/item/fuel_assembly/tritium/New(newloc)
	..(newloc, MATERIAL_TRITIUM)

/obj/item/fuel_assembly/phoron/New(newloc)
	..(newloc, MATERIAL_PHORON)

/obj/item/fuel_assembly/supermatter/New(newloc)
	..(newloc, MATERIAL_SUPERMATTER)

/obj/item/fuel_assembly/hydrogen/New(newloc)
	..(newloc, MATERIAL_HYDROGEN_METALLIC)
