///////////////////////////////////////////////////////////////
//SS13 Optimized Map loader
//////////////////////////////////////////////////////////////

//global datum that will preload variables on atoms instanciation
GLOBAL_VAR_INIT(use_preloader, FALSE)
GLOBAL_DATUM_INIT(_preloader, /dmm_suite/preloader, new)

/datum/map_load_metadata
	var/bounds
	var/list/atoms_to_initialise

/dmm_suite
		// /"([a-zA-Z]+)" = \(((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"([a-zA-Z\n]*)"\}/g
	var/static/regex/dmmRegex = new(@'"([a-zA-Z]+)" = (?:\(\n|\()((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"([a-zA-Z\n]*)"\}', "g")
		// /^[\s\n]+"?|"?[\s\n]+$|^"|"$/g
	var/static/regex/trimQuotesRegex = new/regex({"^\[\\s\n]+"?|"?\[\\s\n]+$|^"|"$"}, "g")
		// /^[\s\n]+|[\s\n]+$/
	var/static/regex/trimRegex = new/regex("^\[\\s\n]+|\[\\s\n]+$", "g")
	var/static/list/modelCache = list()
	var/static/space_key
	var/loading = FALSE

//text trimming (both directions) helper macro
#define TRIM_TEXT(text) (replacetext_char(text, trimRegex, ""))

#define MAPLOADING_CHECK_TICK \
	if(TICK_CHECK) { \
		if(loading) { \
			SSatoms.map_loader_stop(REF(src)); \
			stoplag(); \
			SSatoms.map_loader_begin(REF(src)); \
		} else { \
			stoplag(); \
		} \
	}

/**
 * Construct the model map and control the loading process
 *
 * WORKING :
 *
 * 1) Makes an associative mapping of model_keys with model
 * 		e.g aa = /turf/unsimulated/wall{icon_state = "rock"}
 * 2) Read the map line by line, parsing the result (using parse_grid)
 *
 */
// dmm_files: A list of .dmm files to load (Required).
// z_offset: A number representing the z-level on which to start loading the map (Optional).
// cropMap: When true, the map will be cropped to fit the existing world dimensions (Optional).
// measureOnly: When true, no changes will be made to the world (Optional).
// no_changeturf: When true, turf/AfterChange won't be called on loaded turfs
/dmm_suite/load_map(dmm_file as file, x_offset as num, y_offset as num, z_offset as num, cropMap as num, measureOnly as num, no_changeturf as num, lower_crop_x as num,  lower_crop_y as num, upper_crop_x as num, upper_crop_y as num)
	//How I wish for RAII
	Master.StartLoadingMap()
	space_key = null
	. = load_map_impl(dmm_file, x_offset, y_offset, z_offset, cropMap, measureOnly, no_changeturf, lower_crop_x, upper_crop_x, lower_crop_y, upper_crop_y)
	Master.StopLoadingMap()

/dmm_suite/proc/load_map_impl(dmm_file, x_offset, y_offset, z_offset, cropMap, measureOnly, no_changeturf, x_lower = -INFINITY, x_upper = INFINITY, y_lower = -INFINITY, y_upper = INFINITY)
	var/tfile = dmm_file//the map file we're creating

	/*#### WARNING AURORA SNOWFLAKE SECTION ####*/

	if(isfile(tfile))
		// name/path of dmm file, new var so as to not rename the `tfile` var
		// to maybe maintain compatibility with other codebases
		var/tfilepath = "[tfile]"
		tfile = null
		// use bapi to read, parse, process, mapmanip etc
		// this will "crash"/stacktrace on fail
		// Except when measuring; i don't give a shit about bapi when measuring the map size,
		// if you're changing the map size from bapi you're stupid and deserve it not to work,
		// and i'm not slowing down the whole initialization by a third just for this possibility
		if(!measureOnly)
			tfile = bapi_read_dmm_file(tfilepath)
		// if bapi for whatever reason fails and returns null, or we're measuring
		// try to load it the old dm way instead
		if(!tfile)
			tfile = file2text(tfilepath)

	/*#### END AURORA SNOWFLAKE SECTION ####*/

	if(!x_offset)
		x_offset = 1
	if(!y_offset)
		y_offset = 1
	if(!z_offset)
		z_offset = world.maxz + 1

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/grid_models = list()
	var/key_len = 0

	var/stored_index = 1

	var/list/atoms_to_initialise = list()
	var/has_expanded_world_maxx = FALSE
	var/has_expanded_world_maxy = FALSE

	var/list/regexOutput
	while(findtext(tfile, dmmRegex, stored_index))
		stored_index = dmmRegex.next
		// Datum var lookup is expensive, this isn't
		regexOutput = dmmRegex.group

		// "aa" = (/type{vars=blah})
		if(regexOutput[1]) // Model
			var/key = regexOutput[1]
			if(grid_models[key]) // Duplicate model keys are ignored in DMMs
				continue
			if(key_len != length(key))
				if(!key_len)
					key_len = length(key)
				else
					CRASH("Inconsistent key length in DMM")
			if(!measureOnly)
				grid_models[key] = regexOutput[2]

		// (1,1,1) = {"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}
		else if(regexOutput[3]) // Coords
			if(!key_len)
				CRASH("Coords before model definition in DMM")

			var/curr_x = text2num(regexOutput[3])

			if(curr_x < x_lower || curr_x > x_upper)
				continue

			var/xcrdStart = curr_x + x_offset - 1
			//position of the currently processed square
			var/xcrd
			var/ycrd = text2num(regexOutput[4]) + y_offset - 1
			var/zcrd = text2num(regexOutput[5]) + z_offset - 1

			var/zexpansion = zcrd > world.maxz
			if(zexpansion && !measureOnly) // don't actually expand the world if we're only measuring bounds
				if(cropMap)
					continue
				else
					world.maxz = zcrd //create a new z_level if needed
					SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_Z, world.maxz)
				if(!no_changeturf)
					WARNING("Z-level expansion occurred without no_changeturf set, this may cause problems when /turf/post_change is called.")

			bounds[MAP_MINX] = min(bounds[MAP_MINX], clamp(xcrdStart, x_lower, x_upper))
			bounds[MAP_MINZ] = min(bounds[MAP_MINZ], zcrd)
			bounds[MAP_MAXZ] = max(bounds[MAP_MAXZ], zcrd)

			var/list/gridLines = splittext(regexOutput[6], "\n")

			var/leadingBlanks = 0
			while(leadingBlanks < length(gridLines) && gridLines[++leadingBlanks] == "")
			if(leadingBlanks > 1)
				gridLines.Cut(1, leadingBlanks) // Remove all leading blank lines.

			if(!length(gridLines)) // Skip it if only blank lines exist.
				continue

			if(gridLines[length(gridLines)] == "")
				gridLines.Cut(length(gridLines)) // Remove only one blank line at the end.

			bounds[MAP_MINY] = min(bounds[MAP_MINY], clamp(ycrd, y_lower, y_upper))
			ycrd += length(gridLines) - 1 // Start at the top and work down

			if(!cropMap && ycrd > world.maxy)
				if(!measureOnly)
					world.maxy = ycrd // Expand Y here.  X is expanded in the loop below
					has_expanded_world_maxy = TRUE
				bounds[MAP_MAXY] = max(bounds[MAP_MAXY], clamp(ycrd, y_lower, y_upper))
			else
				bounds[MAP_MAXY] = max(bounds[MAP_MAXY], clamp(min(ycrd, world.maxy), y_lower, y_upper))

			var/maxx = xcrdStart
			if(measureOnly)
				for(var/line in gridLines)
					maxx = max(maxx, xcrdStart + length(line) / key_len - 1)
			else
				//turn off base new Initialization until the whole thing is loaded
				SSatoms.map_loader_begin(REF(src))
				loading = TRUE

				for(var/line in gridLines)
					if((ycrd - y_offset + 1) < y_lower || (ycrd - y_offset + 1) > y_upper)				//Reverse operation and check if it is out of bounds of cropping.
						--ycrd
						continue
					if(ycrd <= world.maxy && ycrd >= 1)
						xcrd = xcrdStart
						for(var/tpos = 1 to length(line) - key_len + 1 step key_len)
							if((xcrd - x_offset + 1) < x_lower || (xcrd - x_offset + 1) > x_upper)			//Same as above.
								++xcrd
								continue								//X cropping.
							if(xcrd > world.maxx)
								if(cropMap)
									break
								else
									world.maxx = xcrd
									has_expanded_world_maxx = TRUE

							if(xcrd >= 1)
								var/model_key = copytext(line, tpos, tpos + key_len)
								var/no_afterchange = no_changeturf || zexpansion
								if(!no_afterchange || (model_key != space_key))
									if(!grid_models[model_key])
										CRASH("Undefined model key in DMM.")
									var/datum/grid_load_metadata/M = parse_grid(grid_models[model_key], model_key, xcrd, ycrd, zcrd, no_changeturf || zexpansion)
									if (M)
										atoms_to_initialise += M.atoms_to_initialise

								// CHECK_TICK
							maxx = max(maxx, xcrd)
							++xcrd
					--ycrd

				loading = FALSE
				//Restore initialization to the previous value
				SSatoms.map_loader_stop(REF(src))

			bounds[MAP_MAXX] = clamp(max(bounds[MAP_MAXX], cropMap ? min(maxx, world.maxx) : maxx), x_lower, x_upper)

		CHECK_TICK

	if(bounds[1] == 1.#INF) // Shouldn't need to check every item
		return null
	else
		if(!measureOnly)
			if(!no_changeturf)
				for(var/turf/T as anything in block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]), locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])))
					//we do this after we load everything in. if we don't; we'll have weird atmos bugs regarding atmos adjacent turfs
					T.post_change(FALSE)

			if(has_expanded_world_maxx || has_expanded_world_maxy)
				SEND_GLOBAL_SIGNAL(COMSIG_GLOB_EXPANDED_WORLD_BOUNDS, has_expanded_world_maxx, has_expanded_world_maxy)

		var/datum/map_load_metadata/M = new
		M.bounds = bounds
		M.atoms_to_initialise = atoms_to_initialise
		return M

/**
 * Fill a given tile with its area/turf/objects/mobs
 * Variable model is one full map line (e.g /turf/unsimulated/wall{icon_state = "rock"}, /area/mine/explored)
 *
 * WORKING :
 *
 * 1) Read the model string, member by member (delimiter is ',')
 *
 * 2) Get the path of the atom and store it into a list
 *
 * 3) a) Check if the member has variables (text within '{' and '}')
 *
 * 3) b) Construct an associative list with found variables, if any (the atom index in members is the same as its variables in members_attributes)
 *
 * 4) Instanciates the atom with its variables
 *
 */

/datum/grid_load_metadata
	var/list/atoms_to_initialise
	var/list/atoms_to_delete

/dmm_suite/proc/parse_grid(model as text, model_key as text, xcrd as num,ycrd as num,zcrd as num, no_changeturf as num)
	//This should only ever be called by load_map_impl() after announcing the map is being loaded to SSatoms
	PRIVATE_PROC(TRUE)

	/*Method parse_grid()
	- Accepts a text string containing a comma separated list of type paths of the
		same construction as those contained in a .dmm file, and instantiates them.
	*/

	var/list/members //will contain all members (paths) in model (in our example : /turf/unsimulated/wall and /area/mine/explored)
	var/list/members_attributes //will contain lists filled with corresponding variables, if any (in our example : list(icon_state = "rock") and list())
	var/list/cached = modelCache[model]
	var/index

	if(cached)
		members = cached[1]
		members_attributes = cached[2]
	else
		/////////////////////////////////////////////////////////
		//Constructing members and corresponding variables lists
		////////////////////////////////////////////////////////

		members = list()
		members_attributes = list()
		index = 1

		var/old_position = 1
		var/dpos

		do
			//finding next member (e.g /turf/unsimulated/wall{icon_state = "rock"} or /area/mine/explored)
			dpos = find_next_delimiter_position(model, old_position, ",", "{", "}") //find next delimiter (comma here) that's not within {...}

			var/full_def = TRIM_TEXT(copytext(model, old_position, dpos)) //full definition, e.g : /obj/foo/bar{variables=derp}
			var/variables_start = findtext(full_def, "{")
			var/atom_def = text2path(TRIM_TEXT(copytext(full_def, 1, variables_start))) //path definition, e.g /obj/foo/bar
			old_position = dpos + 1

			if(!atom_def) // Skip the item if the path does not exist.  Fix your crap, mappers!
	#ifdef UNIT_TEST
				log_error("Couldn't find atom path specified in map: [full_def]")
	#endif
				if (dpos == 0)
					break
				else
					continue

			members += atom_def

			//transform the variables in text format into a list (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
			var/list/fields

			if(variables_start)//if there's any variable
				full_def = copytext(full_def,variables_start+1,length(full_def))//removing the last '}'
				fields = readlist(full_def, ";")
				if(length(fields))
					if(!trimtext(fields[length(fields)]))
						--fields.len
					for(var/I in fields)
						var/value = fields[I]
						if(istext(value))
							fields[I] = apply_text_macros(value)

			//then fill the members_attributes list with the corresponding variables
			members_attributes.len++
			members_attributes[index++] = fields

			MAPLOADING_CHECK_TICK
		while(dpos != 0)

		//check and see if we can just skip this turf
		//So you don't have to understand this horrid statement, we can do this if
		// 1. no_changeturf is set
		// 2. the space_key isn't set yet
		// 3. there are exactly 2 members
		// 4. with no attributes
		// 5. and the members are world.turf and world.area
		// Basically, if we find an entry like this: "XXX" = (/turf/default, /area/default)
		// We can skip calling this proc every time we see XXX
		if(no_changeturf && !space_key && length(members) == 2 && length(members_attributes) == 2 && length(members_attributes[1]) == 0 && length(members_attributes[2]) == 0 && (world.area in members) && (world.turf in members))
			space_key = model_key
			return

		modelCache[model] = list(members, members_attributes)

	////////////////
	//Instanciation
	////////////////

	//since we've switched off autoinitialisation, record atoms to initialise later
	var/list/atoms_to_initialise = list()

	//The next part of the code assumes there's ALWAYS an /area AND a /turf on a given tile
	var/turf/crds = locate(xcrd,ycrd,zcrd)

	//first instance the /area and remove it from the members list
	index = length(members)
	if(members[index] != /area/template_noop)
		var/atype = members[index]
		var/atom/instance = GLOB.areas_by_type[atype]
		var/list/attr = members_attributes[index]
		if (LAZYLEN(attr))
			GLOB._preloader.setup(attr)//preloader for assigning  set variables on atom creation
		if(!instance)
			instance = new atype(null)
			atoms_to_initialise += instance
		if(crds)
			instance.contents += crds

		if(GLOB.use_preloader && instance)
			GLOB._preloader.load(instance)

	//then instance the /turf

	var/first_turf_index = 1
	while(!ispath(members[first_turf_index], /turf)) //find first /turf object in members
		first_turf_index++

	//instanciate the first /turf
	var/turf/T
	if(members[first_turf_index] != /turf/template_noop)
		T = instance_atom(members[first_turf_index],members_attributes[first_turf_index],crds,no_changeturf)
		atoms_to_initialise += T

	if(T)
		//if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		while(index <= length(members) - 1) // Last item is an /area
			T = instance_atom(members[index],members_attributes[index],crds,no_changeturf)//instance new turf
			index++
			atoms_to_initialise += T

	//finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index-1)
		atoms_to_initialise += instance_atom(members[index],members_attributes[index],crds,no_changeturf)

	var/datum/grid_load_metadata/M = new
	M.atoms_to_initialise = atoms_to_initialise
	return M

////////////////
//Helpers procs
////////////////

//Instance an atom at (x,y,z) and gives it the variables in attributes
/dmm_suite/proc/instance_atom(path,list/attributes, turf/crds, no_changeturf)
	if (LAZYLEN(attributes))
		GLOB._preloader.setup(attributes, path)

	if(crds)
		if(!no_changeturf && ispath(path, /turf))
			. = crds.ChangeTurf(path, FALSE, TRUE, TRUE)
		else
			. = create_atom(path, crds)//first preloader pass

	if(GLOB.use_preloader && .)//second preloader pass, for those atoms that don't ..() in New()
		GLOB._preloader.load(.)

	MAPLOADING_CHECK_TICK

/dmm_suite/proc/create_atom(path, crds)
	set waitfor = FALSE
	. = new path (crds)

//find the position of the next delimiter,skipping whatever is comprised between opening_escape and closing_escape
//returns 0 if reached the last delimiter
/dmm_suite/proc/find_next_delimiter_position(text as text,initial_position as num, delimiter=",",opening_escape="\"",closing_escape="\"")
	var/position = initial_position
	var/next_delimiter = findtext(text,delimiter,position,0)
	var/next_opening = findtext(text,opening_escape,position,0)

	while((next_opening != 0) && (next_opening < next_delimiter))
		position = findtext(text,closing_escape,next_opening + 1,0)+1
		next_delimiter = findtext(text,delimiter,position,0)
		next_opening = findtext(text,opening_escape,position,0)

	return next_delimiter

//build a list from variables in text form (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
//return the filled list
/dmm_suite/proc/readlist(text as text, delimiter=",")
	. = list()
	if (!text)
		return

	var/position
	var/old_position = 1
	while(position != 0)
		// find next delimiter that is not within  "..."
		position = find_next_delimiter_position(text,old_position,delimiter)

		// check if this is a simple variable (as in list(var1, var2)) or an associative one (as in list(var1="foo",var2=7))
		var/equal_position = findtext(text,"=",old_position, position)
		var/trim_left = TRIM_TEXT(copytext(text,old_position,(equal_position ? equal_position : position)))
		var/left_constant = parse_constant(trim_left)
		if(position)
			old_position = position + length(text[position])
		if(!left_constant) // damn newlines man. Exists to provide behavior consistency with the above loop. not a major cost becuase this path is cold
			continue

		if(equal_position && !isnum(left_constant))
			// Associative var, so do the association.
			// Note that numbers cannot be keys - the RHS is dropped if so.
			var/trim_right = TRIM_TEXT(copytext(text, equal_position + length(text[equal_position]), position))
			var/right_constant = parse_constant(trim_right)
			.[left_constant] = right_constant
		else  // simple var
			. += list(left_constant)

/dmm_suite/proc/parse_constant(text)
	// number
	var/num = text2num(text)
	if(isnum(num))
		return num

	// string
	if(text[1] == "\"")
		// insert implied locate \" and length("\"") here
		// It's a minimal timesave but it is a timesave
		// Safe becuase we're guarenteed trimmed constants
		return copytext(text, 2, -1)

	// list
	if(copytext(text, 1, 6) == "list(")//6 == length("list(") + 1
		return readlist(copytext(text, 6, -1))

	// typepath
	var/path = text2path(text)
	if(ispath(path))
		return path

	// file
	if(text[1] == "'")
		return file(copytext_char(text, 2, -1))

	// null
	if(text == "null")
		return null

	// not parsed:
	// - pops: /obj{name="foo"}
	// - new(), newlist(), icon(), matrix(), sound()

	// fallback: string
	return text

/dmm_suite/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

//////////////////
//Preloader datum
//////////////////

GLOBAL_LIST_INIT(_preloader_path, null)

/dmm_suite/preloader
	parent_type = /datum
	var/list/attributes

/dmm_suite/preloader/proc/setup(list/the_attributes, path)
	if(LAZYLEN(the_attributes))
		GLOB.use_preloader = TRUE
		attributes = the_attributes
		GLOB._preloader_path = path

/dmm_suite/preloader/proc/load(atom/what)
	GLOB.use_preloader = FALSE
	var/list/attributes = src.attributes
	for(var/attribute in attributes)
		var/value = attributes[attribute]
		if(islist(value))
			value = deep_copy_list(value)
		#ifdef TESTING
		if(what.vars[attribute] == value)
			var/message = "<font color=green>[what.type]</font> at [AREACOORD(what)] - <b>VAR:</b> <font color=red>[attribute] = [isnull(value) ? "null" : (isnum(value) ? value : "\"[value]\"")]</font>"
			log_mapping("DIRTY VAR: [message]")
			GLOB.dirty_vars += message
		#endif
		what.vars[attribute] = value

/area/template_noop
	name = "Area Passthrough"
	icon_state = "noop"
	area_flags = AREA_FLAG_PREVENT_PERSISTENT_TRASH

/turf/template_noop
	name = "Turf Passthrough"
	icon_state = "noop"

#undef TRIM_TEXT
#undef MAPLOADING_CHECK_TICK
