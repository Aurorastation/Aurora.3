/obj/item/slime_extract/Value(var/base)
	return base * uses

/obj/item/ammo_casing/Value()
	if(!BB)
		return 1
	return ..()

/obj/item/reagent_containers/Value()
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

/obj/item/ore/Value()
	var/material/mat = SSmaterials.get_material_by_name(material)
	if(mat)
		return mat.value
	return 0

/obj/item/material/Value()
	return material.value * worth_multiplier

/obj/item/spacecash/Value()
	return worth
