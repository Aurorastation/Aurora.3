/proc/ext_python(var/script, var/arguments, var/scriptsprefix = 1)
	if(scriptsprefix) script = "scripts/" + script

	if(world.system_type == MS_WINDOWS)
		script = replacetext(script, "/", "\\")

	var/command = GLOB.config.python_path + " " + script + " " + arguments

	return shell(command)
