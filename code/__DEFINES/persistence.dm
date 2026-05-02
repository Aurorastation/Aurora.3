/*####################################################
	Defines for cleanups and expirations
####################################################*/

#define PERSISTENT_DEFAULT_EXPIRATION_DAYS 30 // Default expire timespan for newly created persistent content, mainly objects and history records with age rule
#define PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS 30 // Grace period for expired database entries before they get cleaned up

// ##### Persistent type "history" expiration rules
// Rules are applied on the combination type+attribute

ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule)

// Keep X rows
ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule/row_count)
	var/max_row_count = 0

/singleton/persistent_type_history_expiration_rule/row_count/hundred
	max_row_count = 100

/singleton/persistent_type_history_expiration_rule/row_count/thousand
	max_row_count = 1000

// Keep records for X rounds
ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule/round_count)
	var/max_round_count_per_type = 0

/singleton/persistent_type_history_expiration_rule/round_count/five
	max_round_count_per_type = 5

/singleton/persistent_type_history_expiration_rule/round_count/ten
	max_round_count_per_type = 10

// Keep records for X days
ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule/age)
	var/max_age_days = 0

/singleton/persistent_type_history_expiration_rule/age/default
	max_age_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS

/singleton/persistent_type_history_expiration_rule/age/quarter_month
	max_age_days = 90

/singleton/persistent_type_history_expiration_rule/age/half_year
	max_age_days = 180

/singleton/persistent_type_history_expiration_rule/age/year
	max_age_days = 365

/*###################################################
	Defines for type definitions
###################################################*/

// ##### Base type definitions

// Persistent type definition found in database
ABSTRACT_TYPE(/singleton/persistent_type)
	var/definition_type_value = 0 // Hard coded in "ss13_persistent_type_definitions.definition_type", DO NOT MODIFY - Database constant
	var/title = ""
	var/description = ""
	var/requires_attribute = FALSE

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
		requires_attribute = #REQUIRES_ATTRIBUTE; \
	}

// Basic history persistent type definition
#define CREATE_PERSISTENT_TYPE_HISTORY(TYPE_NAME, TITLE, DESCRIPTION, REQUIRES_ATTRIBUTE, EXPIRATION_RULE) \
	if(findtext("character", #TYPE_NAME)) \
		fail("Cannot use this macro for creating a type of 'character', use CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER instead.", __FILE__, __LINE__); \
	/singleton/persistent_type/history/##TYPE_NAME \
	{ \
		title = #TITLE; \
		description = #DESCRIPTION; \
		requires_attribute = #REQUIRES_ATTRIBUTE; \
		expiration_rule = #EXPIRATION_RULE; \
	}

// Character history persistent type definition - Enforces character ID validation when used
#define CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(TYPE_NAME, TITLE, DESCRIPTION, EXPIRATION_RULE) \
	/singleton/persistent_type/history/character/##TYPE_NAME \
	{ \
		title = #TITLE; \
		description = #DESCRIPTION; \
		requires_attribute = TRUE; \
		expiration_rule = #EXPIRATION_RULE; \
	}

// ##### List of custom type definitions using the macros above

// Singleton list of generic persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_GENERIC(basic, "Title", "A persistent generic with no special properties.", FALSE)
// => creates /singleton/persistent_type/generic/basic

// Singleton list of history persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_HISTORY(basic, "Title", "A persistent record type with no special properties.", FALSE, /singleton/persistent_type_history_expiration_rule/row_count/hundred)
// => creates /singleton/persistent_type/history/basic with an expiration rule of 100 rows

// Singleton list of history persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_HISTORY_CHARACTER(basic, "Title", "A persistent record type with no special properties.", /singleton/persistent_type_history_expiration_rule/age/year)
// => creates /singleton/persistent_type/history/character/basic with an expiration age rule of 365 days and mandatory attribute (character ID)

/*###################################################
	Subsystem cache structures
###################################################*/

/datum/persistent_record_container // Container for combining records of type(+attribute)
	var/type_id = 0 // Definition type
	var/attribute = null // Attribute for aggregation records into type+attribute groups
	var/list/datum/persistent_record/records = list() // Container contents

/datum/persistent_record
	var/id = 0
	var/created_at = ""
	var/value = null
