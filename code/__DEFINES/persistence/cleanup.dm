/*####################################################
	Defines for cleanups and expirations
####################################################*/

#define PERSISTENT_DEFAULT_EXPIRATION_DAYS 30 // Default expire timespan for newly created persistent content
#define PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS 30 // Grace period for expired database entries before they get cleaned up, objects only

// ##### Persistent type "history" expiration rules
// Rules are applied on the combination type+attribute
// See type definition macros on their usage
// Abstract marked types are used for type catching in code and not to be used in type definitions

ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule)

// Keep last X rows - This rule removes all records exceeding the newest X records by count
ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule/row_count)
	var/max_row_count = 0

/singleton/persistent_type_history_expiration_rule/row_count/ten
	max_row_count = 10

/singleton/persistent_type_history_expiration_rule/row_count/hundred
	max_row_count = 100

/singleton/persistent_type_history_expiration_rule/row_count/thousand
	max_row_count = 1000

// Keep records for X rounds - This rule removes all records that don't belong to the last X finished rounds
ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule/round_count)
	var/max_round_count = 0

/singleton/persistent_type_history_expiration_rule/round_count/ten
	max_round_count = 10

/singleton/persistent_type_history_expiration_rule/round_count/fifty
	max_round_count = 50

/singleton/persistent_type_history_expiration_rule/round_count/hundred
	max_round_count = 100

// Keep records for X days - This rule removes all records that are older then X days since their creation
ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule/age)
	var/max_age_days = 0

/singleton/persistent_type_history_expiration_rule/age/default
	max_age_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS

/singleton/persistent_type_history_expiration_rule/age/week
	max_age_days = 7

/singleton/persistent_type_history_expiration_rule/age/quarter_year
	max_age_days = 90

/singleton/persistent_type_history_expiration_rule/age/half_year
	max_age_days = 180

/singleton/persistent_type_history_expiration_rule/age/year
	max_age_days = 365
