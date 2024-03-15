/singleton/item_modifier
	var/name
	var/list/type_setups

/singleton/item_modifier/Initialize()
	. = ..()
	for(var/prop_type in type_setups)
		var/obj/item/prop = new type_setups[prop_type]
		var/list/type_setup = list()
		type_setup[SETUP_NAME] = prop.name
		type_setup[SETUP_DESCRIPTION] = prop.desc
		type_setup[SETUP_ICON] = prop.icon
		type_setup[SETUP_ICON_STATE] = prop.icon_state
		type_setup[SETUP_ARMOR] = prop.armor.Copy()
		type_setup[SETUP_MAX_PRESSURE] = prop.max_pressure_protection
		type_setup[SETUP_MAX_TEMPERATURE] = prop.max_heat_protection_temperature
		type_setup[SETUP_SIEMANS_COEFFICIENT] = prop.siemens_coefficient
		type_setup[SETUP_ALLOWED_ITEMS] = prop.allowed.Copy()
		if(istype(prop, /obj/item/clothing/head))
			var/obj/item/clothing/head/H = prop
			type_setup[SETUP_LIGHT_OVERLAY] = H.light_overlay
		type_setups[prop_type] = type_setup

/singleton/item_modifier/proc/RefitItem(obj/item/I)
	if(!istype(I))
		return FALSE

	var/item_type = get_ispath_key(type_setups, I.type)
	if(!item_type)
		return FALSE

	var/type_setup = type_setups[item_type]
	if(!type_setup)
		return FALSE

	I.name = type_setup[SETUP_NAME]
	I.desc = type_setup[SETUP_DESCRIPTION]
	I.icon = type_setup[SETUP_ICON]
	I.icon_state = type_setup[SETUP_ICON_STATE]
	var/list/armor_def = type_setup[SETUP_ARMOR]
	I.armor = armor_def.Copy()
	I.max_pressure_protection = type_setup[SETUP_MAX_PRESSURE]
	I.max_heat_protection_temperature = type_setup[SETUP_MAX_TEMPERATURE]
	I.siemens_coefficient = type_setup[SETUP_SIEMANS_COEFFICIENT]
	var/list/allowed_def = type_setup[SETUP_ALLOWED_ITEMS]
	I.allowed = allowed_def.Copy()
	if(istype(I, /obj/item/clothing/head))
		var/obj/item/clothing/head/H = I
		H.light_overlay = type_setup[SETUP_LIGHT_OVERLAY]
	return TRUE
