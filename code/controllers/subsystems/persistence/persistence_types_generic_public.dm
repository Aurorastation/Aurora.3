/**
 * Creates/saves or overrides generic content for a type(+attribute)
 * PARAMS:
 * 	target_type =			Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 *  attribute =				Custom attribute of the generic, can be null if the type definition doesn't require it.
 *  content = 				List of associative values to be saved. ("id" = 123, "value" = "lorem ipsum")
 *	expiration_in_days =	Days until the content is deemed expired. Defaults to PERSISTENT_DEFAULT_EXPIRATION_DAYS
 */
/datum/controller/subsystem/persistence/proc/genericSave(var/singleton/persistent_type/generic/target_type, attribute, content, expiration_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS)
	if(!content || length(content))
		return

	if(!target_type)
		log_subsystem_persistence_warning("Attempted to add generic with null target type.")
		return

	if(target_type.requires_attribute && !length(attribute))
		log_subsystem_persistence_warning("Attempted to add generic of type [target_type] without required attribute.")
		return

	if(!expiration_in_days || expiration_in_days <= 0)
		expiration_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS

	// TODO

/**
 * Retrieve/Loads generic content of a type(+attribute)
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 *  attribute =		Custom attribute of the generic, can be null if the type definition doesn't require it.
 * RETURN:
 *	List of associative values ("id" = 123, "value" = "lorem ipsum") or null if not available.
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

	// TODO
