/*#############################################
			Persistence Helper-Macros
#############################################*/

/**
 * Saves a given variable to the persistence content of an item if and only if that variable is different from its initial value.
 * Input 1 must be a var/list/content, see any example of persistence_get_content()
 * Input 2 can be any variable that is not a datum or reference.
 */
#define SAVE_IF_DIFFERENT(content, var_to_save) if(var_to_save != initial(var_to_save)) {content["[nameof(var_to_save)]"] = var_to_save}

/**
 * Checks if a given variable was saved to persistence, and then sets it if found.
 * Exclusively used for persistence_apply_content(content, x, y, z)
 * Input 1 must be the content variable passed into the proc.
 * Input 2 can be any variable that is not a datum or reference.
 */
#define SET_IF_EXISTS(content, var_to_set) if(content[nameof(var_to_set)]) {var_to_set = content["[nameof(var_to_set)]"]}
