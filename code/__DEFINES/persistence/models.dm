/*###################################################
	Subsystem cache structures
###################################################*/

// Data transfer objects - Used by the subsystem for aggregation and result returns, these should be treated as read-only when handed by the subsystem

/datum/persistent_record_container // Container for combining records of type(+attribute)
	var/singleton/persistent_type/history/type_define = null // Definition type
	var/attribute = null // Attribute for aggregation records into type+attribute groups
	var/list/datum/persistent_record/records = list() // Container contents

/datum/persistent_record // Single persistent record
	var/id = 0 // Database ID - Might be a non-existend (virtual) ID if the record hasn't been saved yet
	var/created_at = "" // Timestamp when the record was saved
	var/game_id = "" // Game Id when the record was saved
	var/value = null // Treat this as string value

/datum/persistent_generic // Persistent generic data holder
	var/singleton/persistent_type/history/type_define = null // Definition type
	var/attribute = null // Attribute for aggregation into type+attribute
	var/content = null // Treat this as a string - Open for implementing caller (e.g. raw string or json)
	var/expires_in_days = PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS // Expiration timespan used when generic is saved
