/**
 * Creates/saves or overrides generic content for a type(+attribute)
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

	if(target_type.requires_attribute && !length(attribute))
		log_subsystem_persistence_warning("Attempted to add generic of type [target_type] without required attribute.")
		return

	if(!expires_in_days || expires_in_days <= 0)
		expires_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS

	// CACHE HERE
	//genericDatabaseSave(target_type.database_id, attribute, expires_in_days, json_encode(content))

/**
 * Retrieve/Loads generic content of a type(+attribute)
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 *  attribute =		Custom attribute of the generic, can be null if the type definition doesn't require it.
 * RETURN:
 *	List of associative values ("content" = ("id" = 123, "value" = "lorem ipsum"), "created_at" = timestamp, "expires_at" = timestamp) or null if not available.
 */
/datum/controller/subsystem/persistence/proc/genericLoad(var/singleton/persistent_type/generic/target_type, attribute, content, expiration_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS)
	if(!content || length(content))
		return

	if(!target_type)
		log_subsystem_persistence_warning("Attempted to load generic with null target type.")
		return

	if(target_type.requires_attribute && !length(attribute))
		log_subsystem_persistence_warning("Attempted to load generic of type [target_type] without required attribute.")
		return

	var/result = genericDatabaseLoad(target_type.database_id, attribute)
	if(!result || length(result))
		return null

	return list("content" = json_decode(result[1]), "created_at" = result[2], "expires_at" = result[3])
