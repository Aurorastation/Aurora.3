/*###################################################
	Subsystem cache structures
###################################################*/

/datum/persistent_record_container // Container for combining records of type(+attribute)
	var/singleton/persistent_type/history/type_define = null // Definition type
	var/attribute = null // Attribute for aggregation records into type+attribute groups
	var/list/datum/persistent_record/records = list() // Container contents

/datum/persistent_record
	var/id = 0
	var/created_at = ""
	var/game_id = ""
	var/value = null // Treat this as string value

/datum/persistent_generic
	var/singleton/persistent_type/history/type_define = null // Definition type
	var/attribute = null // Attribute for aggregation into type+attribute
	var/content = null
	var/expires_in_days = PERSISTENT_EXPIRATION_CLEANUP_DELAY_DAYS
