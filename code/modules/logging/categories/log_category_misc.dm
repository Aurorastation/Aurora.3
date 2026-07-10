/datum/log_category/attack
	category = LOG_CATEGORY_ATTACK
	config_flag = /datum/config_entry/flag/log_attack

/datum/log_category/combat
	category = LOG_CATEGORY_COMBAT
	config_flag = /datum/config_entry/flag/log_attack

/datum/log_category/config
	category = LOG_CATEGORY_CONFIG

/datum/log_category/filter
	category = LOG_CATEGORY_FILTER

/datum/log_category/signal
	category = LOG_CATEGORY_SIGNAL
	config_flag = /datum/config_entry/flag/log_signals

/datum/log_category/suspicious_login
	category = LOG_CATEGORY_SUSPICIOUS_LOGIN
	config_flag = /datum/config_entry/flag/log_suspicious_login

/datum/log_category/telecomms
	category = LOG_CATEGORY_TELECOMMS
	config_flag = /datum/config_entry/flag/log_telecomms

/datum/log_category/tool
	category = LOG_CATEGORY_TOOL
	config_flag = /datum/config_entry/flag/log_tools

/datum/log_category/paper
	category = LOG_CATEGORY_PAPER

/datum/log_category/manifest
	category = LOG_CATEGORY_MANIFEST
	config_flag = /datum/config_entry/flag/log_manifest

/datum/log_category/loadout
	category = LOG_CATEGORY_LOADOUT
	config_flag = /datum/config_entry/flag/log_loadout

/datum/log_category/misc
	category = LOG_CATEGORY_MISC

/datum/log_category/tgs
	category = LOG_CATEGORY_TGS

/datum/log_category/ntsl
	category = LOG_CATEGORY_NTSL

/datum/log_category/world
	category = LOG_CATEGORY_WORLD

/datum/log_category/topic
	category = LOG_CATEGORY_TOPIC

/datum/log_category/perf
	category = LOG_CATEGORY_PERF
	entry_flags = ENTRY_USE_DATA_W_READABLE

/datum/log_category/qdel
	category = LOG_CATEGORY_QDEL
	entry_flags = ENTRY_USE_DATA_W_READABLE

/datum/log_category/harddel
	category = LOG_CATEGORY_HARDDEL
	entry_flags = ENTRY_USE_DATA_W_READABLE

/datum/log_category/debug
	category = LOG_CATEGORY_DEBUG
	config_flag = /datum/config_entry/flag/log_debug

/datum/log_category/debug_asset
	category = LOG_CATEGORY_DEBUG_ASSET
	config_flag = /datum/config_entry/flag/log_asset
	master_category = /datum/log_category/debug

/datum/log_category/debug_job
	category = LOG_CATEGORY_DEBUG_JOB
	config_flag = /datum/config_entry/flag/log_job_debug
	master_category = /datum/log_category/debug

/datum/log_category/debug_lua
	category = LOG_CATEGORY_DEBUG_LUA
	master_category = /datum/log_category/debug

/datum/log_category/debug_mapping
	category = LOG_CATEGORY_DEBUG_MAPPING
	master_category = /datum/log_category/debug

/datum/log_category/debug_sql
	category = LOG_CATEGORY_DEBUG_SQL
	master_category = /datum/log_category/debug

/datum/log_category/runtime
	category = LOG_CATEGORY_RUNTIME

/datum/log_category/href
	category = LOG_CATEGORY_HREF
	config_flag = /datum/config_entry/flag/log_hrefs

/datum/log_category/href_tgui
	category = LOG_CATEGORY_HREF_TGUI
	master_category = /datum/log_category/href
