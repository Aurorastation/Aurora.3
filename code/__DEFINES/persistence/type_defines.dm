/*###################################################
	Defines for type definitions
###################################################*/

// ##### Base type definitions

// Persistent type definition found in database
ABSTRACT_TYPE(/singleton/persistent_type)
	var/database_id = 0 // Set during subsystem init
	var/definition_type_value = 0 // Hard coded in "ss13_persistent_type_definitions.definition_type", DO NOT MODIFY - Database constant
	var/title = ""
	var/description = ""
	var/requires_attribute = FALSE

/**
 *	Hook proc that is called by the subsystem starting finalization.
 *  Hooks are used for implementing finalization logic for mechanics that either
 *  don't have a single trigger to save or where repetitive saving would be too costly.
 *  Should return nothing, returned values are discarded.
 */
/singleton/persistent_type/proc/finalization_hook()
	SHOULD_CALL_PARENT(FALSE)
	return

ABSTRACT_TYPE(/singleton/persistent_type/generic)
	definition_type_value = 1 // DO NOT MODIFY - Database constant

ABSTRACT_TYPE(/singleton/persistent_type/history)
	definition_type_value = 2 // DO NOT MODIFY - Database constant
	var/singleton/persistent_type_history_expiration_rule/expiration_rule = null

ABSTRACT_TYPE(/singleton/persistent_type/history/character)
	// Empty stub

// ##### Macros for new custom type definitions
// - TYPE_NAME = Name of the type definition, used to upsert into database, cannot be updated - Changes result in a new type definition in the DB
// - TITLE = Title of the type definition, used for display purposes
// - DESCRIPTION = Description of the type definition, used for display purposes
// - REQUIRES_ATTRIBUTE = Boolean, whether this type definition requires an attribute to be specified
// - EXPIRATION_RULE = For history type definitions, the expiration rule to apply to records of this type.
//					   See /singleton/persistent_type_history_expiration_rule and subtypes for available rules.

// Basic generic persistent type definition
#define CREATE_PERSISTENT_TYPE_GENERIC(TYPE_NAME, TITLE, DESCRIPTION, REQUIRES_ATTRIBUTE) \
	/singleton/persistent_type/generic/##TYPE_NAME \
	{ \
		title = #TITLE; \
		description = #DESCRIPTION; \
		requires_attribute = ##REQUIRES_ATTRIBUTE; \
	}

// Basic history persistent type definition
#define CREATE_PERSISTENT_TYPE_HISTORY(TYPE_NAME, TITLE, DESCRIPTION, REQUIRES_ATTRIBUTE, EXPIRATION_RULE) \
	/singleton/persistent_type/history/##TYPE_NAME \
	{ \
		title = #TITLE; \
		description = #DESCRIPTION; \
		requires_attribute = ##REQUIRES_ATTRIBUTE; \
		expiration_rule = ##EXPIRATION_RULE; \
	}

// Character history persistent type definition - Enforces character ID validation when used
#define CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(TYPE_NAME, TITLE, DESCRIPTION, EXPIRATION_RULE) \
	/singleton/persistent_type/history/character/##TYPE_NAME \
	{ \
		title = #TITLE; \
		description = #DESCRIPTION; \
		requires_attribute = TRUE; \
		expiration_rule = ##EXPIRATION_RULE; \
	}
