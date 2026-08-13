/**
 * Saves or overrides generic content for a type(+attribute)
 * PARAMS:
 * 	target_type =		Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 *  content = 			List of associative values to be saved. ("id" = 123, "value" = "lorem ipsum")
 *  attribute =			Custom attribute of the generic, can be null if the type definition doesn't require it. Defaults to null.
 *	expires_in_days =	Days until the content is deemed expired. Defaults to PERSISTENT_DEFAULT_EXPIRATION_DAYS.
 */
/datum/controller/subsystem/persistence/proc/genericSave(var/singleton/persistent_type/generic/target_type, content, attribute = null, expires_in_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS)
	if(!content || !length(content))
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

	attribute = length("[attribute]") > 0 ? attribute : null
	var/datum/persistent_generic/generic = generic_cache[typesGetCacheName(target_type, attribute)]
	if(generic)
		generic.content = json_encode(content)
		generic.expires_in_days = expires_in_days
		return

	var/datum/persistent_generic/new_generic = new /datum/persistent_generic/
	new_generic.type_define = target_type
	new_generic.attribute = attribute
	new_generic.content = json_encode(content)
	new_generic.expires_in_days = expires_in_days
	generic_cache[typesGetCacheName(target_type, attribute)] = new_generic

/**
 * Retrieve/Loads generic content of a type(+attribute)
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 *  attribute =		Custom attribute of the generic, can be null if the type definition doesn't require it. Defaults to null.
 *  skip_caching =	If set to TRUE, database results won't be added to the generic cache. Defaults to FALSE.
 * RETURN:
 *	/persistent_generic or null if not available.
 */
/datum/controller/subsystem/persistence/proc/genericLoad(var/singleton/persistent_type/generic/target_type, attribute = null, skip_caching = FALSE)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to load generic with null target type.")
		return

	var/singleton/persistent_type/type_instance = GET_SINGLETON(target_type)
	if(type_instance.requires_attribute && !length(attribute))
		log_subsystem_persistence_warning("Attempted to load generic of type [target_type] without required attribute.")
		return

	attribute = length("[attribute]") > 0 ? attribute : null
	var/datum/persistent_generic/generic = generic_cache[typesGetCacheName(target_type, attribute)]
	if(generic)
		return generic

	var/result = genericDatabaseLoad(type_instance.database_id, attribute)
	if(!result)
		return null

	var/datum/persistent_generic/new_generic = new /datum/persistent_generic/
	new_generic.type_define = target_type
	new_generic.attribute = attribute
	new_generic.content = json_decode(result["content"])
	new_generic.created_at = result["created_at"]
	new_generic.expires_at = result["expires_at"]
	new_generic.expires_in_days = 0
	if(!skip_caching)
		generic_cache[typesGetCacheName(target_type, attribute)] = new_generic
	return new_generic

/**
 * Retrieves all known attributes of a generic type.
 * PARAMS:
 * 	target_type =	Singleton persistent type definition. See /singleton/persistent_type/generic and subtypes.
 * RETURN:
 *	Distinct list of attributes or empty list.
 */
/datum/controller/subsystem/persistence/proc/genericGetAllAttributesForType(var/singleton/persistent_type/generic/target_type)
	if(!target_type)
		log_subsystem_persistence_warning("Attempted to load all generic attributes with null target type.")
		return list()

	var/singleton/persistent_type/type_instance = GET_SINGLETON(target_type)
	if(!type_instance)
		log_subsystem_persistence_warning("Attempted to load all generic attributes of type [target_type], but no singleton instance was found.")
		return list()

	if(!type_instance.requires_attribute)
		log_subsystem_persistence_warning("Attempted to load all generic attributes of type [target_type], but this type does not support attributes.")
		return list()

	var/list/attributes = genericDatabaseGetAllAttributes(type_instance.database_id) // Retrieve all attributes in the database

	for(var/datum/persistent_generic/cache_entry in generic_cache) // Get attributes that aren't in the database yet
		if(cache_entry.type_define == target_type && cache_entry.attribute && !(cache_entry.attribute in attributes))
			attributes += cache_entry.attribute

	if(!attributes)
		return list()
	return attributes
