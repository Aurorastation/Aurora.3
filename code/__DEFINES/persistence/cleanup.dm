/*####################################################
	Defines for cleanups and expirations
####################################################*/

#define PERSISTENT_DEFAULT_EXPIRATION_DAYS 30 // Default expire timespan for newly created persistent content.
#define PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS 30 // Grace period for expired database entries before they get cleaned up, objects only.

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
	var/max_round_count = 0

/singleton/persistent_type_history_expiration_rule/round_count/five
	max_round_count = 5

/singleton/persistent_type_history_expiration_rule/round_count/ten
	max_round_count = 10

// Keep records for X days
ABSTRACT_TYPE(/singleton/persistent_type_history_expiration_rule/age)
	var/max_age_days = 0

/singleton/persistent_type_history_expiration_rule/age/default
	max_age_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS

/singleton/persistent_type_history_expiration_rule/age/week
	max_age_days = 7

/singleton/persistent_type_history_expiration_rule/age/quarter_month
	max_age_days = 90

/singleton/persistent_type_history_expiration_rule/age/half_year
	max_age_days = 180

/singleton/persistent_type_history_expiration_rule/age/year
	max_age_days = 365
