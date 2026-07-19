/// The main datum that contains all log entries for a category
/datum/log_category
	/// The category name.
	var/category
	/// The schema version of this log category. Expected format is Major.Minor.Patch.
	var/schema_version = LOG_CATEGORY_SCHEMA_VERSION_NOT_SET
	/// The master category that contains this category.
	var/datum/log_category/master_category
	/// Flags to apply to created log entries.
	var/entry_flags = NONE
	/// If set, this config flag is checked to enable this log category.
	var/config_flag
	/// Whether this category should not be publicly visible.
	var/secret = FALSE
	/// Header information written as the first JSON line in the category file
	var/list/category_header
	/// Whether the readable version of the log message is formatted internally instead of by rust-g which would be nice but WE DONT HAVE THAT
	var/internal_formatting = FALSE
	/// Cached log entries for the current round.
	var/list/entries = list()
	/// Total number of entries this round so far.
	var/entry_count = 0

GENERAL_PROTECT_DATUM(/datum/log_category)

/// Add an entry to this category. Data must already be json-safe.
/datum/log_category/proc/create_entry(message, list/data, list/semver_store)
	var/datum/log_entry/entry = new(
		timestamp = logger.human_readable_timestamp(),
		category = category,
		message = message,
		flags = entry_flags,
		data = data,
		semver_store = semver_store,
	)

	write_entry(entry)
	entry_count += 1
	if(entry_count <= CONFIG_MAX_CACHED_LOG_ENTRIES)
		entries += entry

/// Allows category-specific file splitting. Subcategories always write through their master category.
/datum/log_category/proc/get_output_file(list/entry, extension = "log.json")
	if(master_category)
		return master_category.get_output_file(entry, extension)
	if(secret)
		return "[GLOB.log_directory]/secret/[category].[extension]"
	return "[GLOB.log_directory]/[category].[extension]"

/// Writes an entry to the output file(s) for the category.
/datum/log_category/proc/write_entry(datum/log_entry/entry)
	if(!GLOB.config || CONFIG_GET(flag/log_as_human_readable))
		entry.write_readable_entry_to_file(get_output_file(entry, "log"), format_internally = internal_formatting)

	entry.write_entry_to_file(get_output_file(entry))
