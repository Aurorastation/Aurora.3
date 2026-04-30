/*####################################################
	Generics or object related defines
####################################################*/

#define PERSISTENT_DEFAULT_EXPIRATION_DAYS 30 // Default expire timespan for newly created persistent objects
#define PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS 30 // Grace period for expired database entries before they get cleaned up.

/*###################################################
	Defines for type definitions and their relations
###################################################*/

// "Abstract type" of persistent type definition found in database
/singleton/persistency_type_definition
	var/definition_type_value = 0 // Hard coded in ss13_persistent_type_definitions.definition_type, DO NOT MODIFY - Database constant
	var/title = ""
	var/description = ""
	var/requires_attribute = FALSE

/singleton/persistency_type_definition/generic
	definition_type_value = 1 // DO NOT MODIFY - Database constant

/singleton/persistency_type_definition/history
	definition_type_value = 2 // DO NOT MODIFY - Database constant
	// Singleton of /singleton/persistency_type_history_expiration_rule/
	var/expiration_rule = null

// Persistency type "history" expiration rules
ABSTRACT_TYPE(/singleton/persistency_type_history_expiration_rule)

// Keep X rows of type per attribute
ABSTRACT_TYPE(/singleton/persistency_type_history_expiration_rule/row_count)
	var/max_row_count = 0

/singleton/persistency_type_history_expiration_rule/row_count/hundred
	var/max_row_count_per_type = 100

// Keep records of type per attribute for X rounds
ABSTRACT_TYPE(/singleton/persistency_type_history_expiration_rule/round_count)
	var/max_round_count_per_type = 0

/singleton/persistency_type_history_expiration_rule/round_count/ten
	max_round_count_per_type = 10

// Keep records for X days
/singleton/persistency_type_history_expiration_rule/max_age_days_default
	var/max_age_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS

// Macros for creating persistent type definition subtypes
#define CREATE_PERSISTENT_TYPE_DEFINITION_GENERIC(TYPE_NAME, TITLE, DESCRIPTION, REQUIRES_ATTRIBUTE) \
	/singleton/persistency_type_definition/generic/##TYPE_NAME \
	{ \
		title = #TITLE; \
		description = #DESCRIPTION; \
		requires_attribute = #REQUIRES_ATTRIBUTE; \
	}

#define CREATE_PERSISTENT_TYPE_DEFINITION_HISTORY(TYPE_NAME, TITLE, DESCRIPTION, REQUIRES_ATTRIBUTE, EXPIRATION_RULE) \
	/singleton/persistency_type_definition/history/##TYPE_NAME \
	{ \
		title = #TITLE; \
		description = #DESCRIPTION; \
		requires_attribute = #REQUIRES_ATTRIBUTE; \
		expiration_rule = #EXPIRATION_RULE; \
	}

// Singleton list of generic persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_DEFINITION_GENERIC(basic, "Title", "A persistent generic with no special properties.", FALSE)
// => creates /singleton/persistency_type_definition/generic/basic


// Singleton list of history persistent type definitions, created by the macro above.
// CREATE_PERSISTENT_TYPE_DEFINITION_HISTORY(basic, "Title", "A persistent record type with no special properties.", FALSE, /singleton/persistency_type_history_expiration_rule/row_count/hundred)
// => creates /singleton/persistency_type_definition/history/basic with an expiration rule of 100 rows per attribute

