/obj/item/slime_extract/Value(var/base)
	return base * Uses

/obj/item/ammo_casing/Value()
	if(!BB)
		return 1
	return ..()

	. = ..()
	if(reagents)
		for(var/a in reagents.reagent_list)
			var/datum/reagent/reg = a
			. += reg.value * reg.volume
	. = round(.)

/obj/item/stack/Value(var/base)
	return base * amount

/obj/item/stack/material/Value()
	if(!material)
		return ..()
	return material.value * amount

	var/material/mat = get_material_by_name(material)
	if(mat)
		return mat.value
	return 0

	return material.value * worth_multiplier

	return worth
