/proc/get_subfolders(var/root)
	var/list/folders = list()
	var/list/contents = flist(root)

	for(var/file in contents)
		//Check if the filename ends with / to see if its a folder
		if(copytext(file,-1,0) != "/")
			continue
		folders.Add("[root][file]")

	return folders

/// Returns the md5 of a file at a given path.
/proc/md5filepath(path)
	. = md5(file(path))

/// Save file as an external file then md5 it.
/// Used because md5ing files stored in the rsc sometimes gives incorrect md5 results.
/proc/md5asfile(file)
	var/static/notch = 0
	// its importaint this code can handle md5filepath sleeping instead of hard blocking, if it's converted to use rust_g.
	var/filename = "tmp/md5asfile.[world.realtime].[world.timeofday].[world.time].[world.tick_usage].[notch]"
	notch = WRAP(notch+1, 0, 2**15)
	fcopy(file, filename)
	. = md5filepath(filename)
	fdel(filename)

/**
 * Takes a directory and returns every file within every sub directory.
 * If extensions_filter is provided then only files that end in that extension are given back.
 * If extensions_filter is a list, any file that matches at least one entry is given back.
 */
/proc/pathwalk(path, extensions_filter)
	var/list/jobs = list(path)
	var/list/filenames = list()

	while(jobs.len)
		var/current_dir = pop(jobs)
		var/list/new_filenames = flist(current_dir)
		for(var/new_filename in new_filenames)
			// if filename ends in / it is a directory, append to currdir
			if(findtext(new_filename, "/", -1))
				jobs += "[current_dir][new_filename]"
				continue
			// filename extension filtering
			if(extensions_filter)
				if(islist(extensions_filter))
					for(var/allowed_extension in extensions_filter)
						if(endswith(new_filename, allowed_extension))
							filenames += "[current_dir][new_filename]"
							break
				else if(endswith(new_filename, extensions_filter))
					filenames += "[current_dir][new_filename]"
			else
				filenames += "[current_dir][new_filename]"
	return filenames
