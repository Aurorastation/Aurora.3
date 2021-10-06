
// Variables to not even show in the list.
// step_* and bound_* are here because they literally break the game and do nothing else.
// parent_type is here because it's pointless to show in VV.
/var/list/view_variables_hide_vars = list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "parent_type", "step_x", "step_y", "step_size")
// Variables not to expand the lists of. Vars is pointless to expand, and overlays/underlays cannot be expanded.
/var/list/view_variables_dont_expand = list("overlays", "underlays", "vars", "screen", "our_overlays", "priority_overlays", "queued_overlays")
// Variables that runtime if you try to test associativity of the lists they contain by indexing
/var/list/view_variables_no_assoc = list("verbs", "contents")

// Acceptable 'in world', as VV would be incredibly hampered otherwise
/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View Variables"
	debug_variables_open(D)

/client/proc/debug_variables_open(var/datum/D, var/search = "")
	if(!check_rights(0))
		return

	if(!D)
		return

	var/static/list/blacklist = list(/datum/configuration)
	if(blacklist[D.type])
		return

	var/icon/sprite
	if(istype(D, /atom))
		var/atom/A = D
		if(A.icon && A.icon_state)
			sprite = icon(A.icon, A.icon_state)
			send_rsc(usr, sprite, "view_vars_sprite.png")

	send_rsc(usr, 'code/js/view_variables.js', "view_variables.js")

	var/html = {"
		<html>
		<head>
			<script src='view_variables.js'></script>
			<title>[D] (\ref[D] - [D.type])</title>
			<style>
				body { font-family: Arial, "Helvetica Neue", Helvetica, sans-serif; font-size: 10pt; }
				.key, .type, .value { font-family: "Fira Code", Consolas, Menlo, Monaco, "Lucida Console", "Liberation Mono", "DejaVu Sans Mono", "Bitstream Vera Sans Mono", "Courier New", monospace, sans-serif; font-size: 9pt; }
				.key { font-weight: bold }
				.type { text-decoration: underline; color: gray }
			</style>
		</head>
		<body onload='selectTextField(); updateSearch()'>
			<div align='center'>
				<table width='100%'><tr>
					<td width='50%'>
						<table align='center' width='100%'><tr>
							[sprite ? "<td><img src='view_vars_sprite.png'></td>" : ""]
							<td><div align='center'>[D.get_view_variables_header()]</div></td>
						</tr></table>
						<div align='center'>
							<b><font size='1'>[replacetext("[get_debug_type(D)]", "/", "/<wbr>")]</font></b>
							[holder.marked_datum == D ? "<br/><font size='1' color='red'><b>Marked Object</b></font>" : ""]
						</div>
					</td>
					<td width='50%'>
						<div align='center'>
							<a id='refresh' data-initial-href='?_src_=vars;datumrefresh=\ref[D];search=' href='?_src_=vars;datumrefresh=\ref[D];search=[search]'>Refresh</a>
							<form>
								<select name='file'
								        size='1'
								        onchange='loadPage(this.form.elements\[0\])'
								        target='_parent._top'
								        onmouseclick='this.focus()'
								        style='background-color:#ffffff'>
									<option>Select option</option>
									<option />
									<option value='?_src_=vars;mark_object=\ref[D]'>Mark Object</option>
									<option value='?_src_=vars;call_proc=\ref[D]'>Call Proc</option>
									[D.get_view_variables_options()]
								</select>
							</form>
						</div>
					</td>
				</tr></table>
			</div>
			<hr/>
			<font size='1'>
				<b>E</b> - Edit, tries to determine the variable type by itself.<br/>
				<b>C</b> - Change, asks you for the var type first.<br/>
				<b>M</b> - Mass modify: changes this variable for all objects of this type.<br/>
			</font>
			<hr/>
			<table width='100%'><tr>
				<td width='20%'>
					<div align='center'>
						<b>Search:</b>
					</div>
				</td>
				<td width='80%'>
					<input type='text'
					       id='filter'
					       name='filter_text'
					       value='[search]'
					       onkeyup='updateSearch()'
					       onchange='updateSearch()'
					       style='width:100%;' />
				</td>
			</tr></table>
			<hr/>
			<ol id='vars'>
				[make_view_variables_var_list(D)]
			</ol>
		</body>
		</html>
		"}

	usr << browse(html, "window=variables\ref[D];size=520x720")


/proc/make_view_variables_var_list(datum/D)
	. = ""
	var/list/variables = list()
	for(var/x in D.vars)
		CHECK_TICK
		if(x in view_variables_hide_vars)
			continue
		variables += x
	variables = sortList(variables)
	for(var/x in variables)
		CHECK_TICK
		. += make_view_variables_var_entry(D, x, D.vars[x])

/proc/make_view_variables_value(value, varname = "*")
	var/vtext = ""
	var/debug_type = get_debug_type(value, FALSE)
	var/extra = list()
	if(isnull(value))
		// get_debug_type displays this
	else if(istext(value))
		debug_type = null // it's kinda annoying here; we can tell the type by the quotes
		vtext = "\"[html_encode(value)]\""
	else if(isicon(value))
		vtext = "[value]"
	else if(isfile(value))
		vtext = "'[value]'"
	else if(istype(value, /datum))
		var/datum/DA = value
		if("[DA]" == "[DA.type]" || !"[DA]")
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA.type]"
		else
			vtext = "<a href='?_src_=vars;Vars=\ref[DA]'>\ref[DA]</a> - [DA] ([DA.type])"
	else if(istype(value, /client))
		var/client/C = value
		vtext = "<a href='?_src_=vars;Vars=\ref[C]'>\ref[C]</a> - [C] ([C.type])"
	else if(islist(value))
		var/list/L = value
		vtext = "([L.len])"
		if(!(varname in view_variables_dont_expand) && L.len > 0 && L.len < 100)
			extra += "<ul>"
			for (var/index = 1 to L.len)
				var/entry = L[index]
				if(!isnum(entry) && !isnull(entry) && !(varname in view_variables_no_assoc) && L[entry] != null)
					extra += "<li>[index]: [make_view_variables_value(entry)] -> [make_view_variables_value(L[entry])]</li>"
				else
					extra += "<li>[index]: [make_view_variables_value(entry)]</li>"
			extra += "</ul>"
		else if(L.len >= 100)
			vtext = "([L.len]): <ul><li><a href='?_src_=vars;datumview=\ref[L];varnameview=[varname]'>List too large to display, click to view.</a></ul>"

	else
		vtext = "[value]"

	return "<span class=type>[debug_type]</span> <span class=value>[vtext]</span>[jointext(extra, "")]"

/proc/make_view_variables_var_entry(datum/D, varname, value, level=0)
	var/ecm = null

	if(D)
		ecm = {"
			(<a href='?_src_=vars;datumedit=\ref[D];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref[D];varnamechange=[varname]'>C</a>)
			(<a href='?_src_=vars;datummass=\ref[D];varnamemass=[varname]'>M</a>)
			"}

	var/valuestr = make_view_variables_value(value, varname)

	return "<li>[ecm]<span class='key'>[varname]</span> = [valuestr]</li>"
