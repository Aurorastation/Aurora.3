/**
 * Saves or overrides generic content for a type(+attribute)
 * PARAMS:
 * 	target_type =		Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 *  attribute =			Custom attribute of the generic, can be null if the type definition doesn't require it.
 *  content = 			List of associative values to be saved. ("id" = 123, "value" = "lorem ipsum")
 *	expires_in_days =	Days until the content is deemed expired. Defaults to PERSISTENT_DEFAULT_EXPIRATION_DAYS
 */
/datum/controller/subsystem/persistence/proc/genericSave(var/singleton/persistent_type/generic/target_type, attribute, content, expires_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS)
	if(!content || length(content))
		return

	if(!target_type)
		log_subsystem_persistence_warning("Attempted to add generic with null target type.")
		return

	var/singleton/persistent_type/type_instance = GET_SINGLETON(target_type)
	if(type_instance.requires_attribute && !length(attribute))
		log_subsystem_persistence_warning("Attempted to add generic of type [target_type] without required attribute.")
		return

	if(!expires_in_days || expires_in_days <= 0)
		expires_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS

	if(attribute)
		for(var/datum/persistent_generic/generic as anything in generic_cache)
			if(generic.type_define == target_type && generic.attribute == attribute)
				generic.content = content
				generic.expires_in_days = expires_in_days
				return
	else
		var/datum/persistent_generic/generic = generic_cache[target_type]
		generic.content = content
		generic.expires_in_days = expires_in_days
		return

	var/datum/persistent_generic/new_generic = new /datum/persistent_generic/
	new_generic.type_define = target_type
	new_generic.attribute = attribute
	new_generic.content = content
	new_generic.expires_in_days = expires_in_days
	generic_cache[target_type] = new_generic

/**
 * Retrieve/Loads generic content of a type(+attribute)
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 *  attribute =		Custom attribute of the generic, can be null if the type definition doesn't require it.
 * RETURN:
 *	/persistent_generic or null if not available.
 */
/datum/controller/subsystem/persistence/proc/genericLoad(var/singleton/persistent_type/generic/target_type, attribute)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to load generic with null target type.")
		return

	var/singleton/persistent_type/type_instance = GET_SINGLETON(target_type)
	if(type_instance.requires_attribute && !length(attribute))
		log_subsystem_persistence_warning("Attempted to load generic of type [target_type] without required attribute.")
		return

	if(attribute)
		for(var/datum/persistent_generic/generic as anything in generic_cache)
			if(generic.type_define == target_type && generic.attribute == attribute)
				return generic
	else
		var/datum/persistent_generic/generic = generic_cache[target_type]
		if(generic)
			return generic

	var/result = genericDatabaseLoad(type_instance.database_id, attribute)

	var/datum/persistent_generic/new_generic = new /datum/persistent_generic/
	new_generic.type_define = target_type
	new_generic.attribute = attribute
	new_generic.content = json_decode(result["id"])
	new_generic.expires_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS
	generic_cache[target_type] = new_generic
	return new_generic
