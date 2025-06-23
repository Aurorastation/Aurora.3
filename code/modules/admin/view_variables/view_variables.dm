
// Variables to not even show in the list.
// step_* and bound_* are here because they literally break the game and do nothing else.
// parent_type is here because it's pointless to show in VV.
/var/list/view_variables_hide_vars = list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "parent_type", "step_x", "step_y", "step_size")
// Variables not to expand the lists of. Vars is pointless to expand, and overlays/underlays cannot be expanded.
/var/list/view_variables_dont_expand = list("overlays", "underlays", "vars", "screen", "our_overlays", "priority_overlays", "queued_overlays")

// Acceptable 'in world', as VV would be incredibly hampered otherwise
/client/proc/debug_variables(datum/D in world)
	set category = "Debug"
	set name = "View Variables"
	debug_variables_open(D)

/client/proc/debug_variables_open(datum/thing, search = "")
	if(!check_rights(0))
		return

	if(!thing)
		return

	var/static/list/blacklist = list(/datum/configuration)
	if(is_type_in_list(thing,blacklist))
		return

	var/islist = islist(thing) || (!isdatum(thing) && hascall(thing, "Cut")) // Some special lists dont count as lists, but can be detected by if they have list procs

	var/icon/sprite
	if(istype(thing, /atom))
		var/atom/A = thing
		if(A.icon && A.icon_state)
			sprite = icon(A.icon, A.icon_state)
			send_rsc(usr, sprite, "view_vars_sprite.png")

	send_rsc(usr, 'code/js/view_variables.js', "view_variables.js")

	var/list/header = islist ? list("<b>/list</b>") : thing.vv_get_header()

	var/list/dropdownoptions = thing.vv_get_dropdown()

	var/html = {"
		<html>
		<head>
			<script src='view_variables.js'></script>
			<title>[thing] ([REF(thing)] - [thing.type])</title>
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
							<td><div align='center'>[header.Join()]</div></td>
						</tr></table>
						<div align='center'>
							<b><font size='1'>[replacetext("[get_debug_type(thing)]", "/", "/<wbr>")]</font></b>
							[holder.marked_datum == thing ? "<br/><font size='1' color='red'><b>Marked Object</b></font>" : ""]
						</div>
					</td>
					<td width='50%'>
						<div align='center'>
							<a id='refresh' data-initial-href='byond://?_src_=vars;datumrefresh=[REF(thing)];search=' href='byond://?_src_=vars;datumrefresh=[REF(thing)];search=[search]'>Refresh</a>
							<form>
								<select name='file'
										size='1'
										onchange='loadPage(this.form.elements\[0\])'
										target='_parent._top'
										onmouseclick='this.focus()'
										style='background-color:#ffffff'>
									<option>Select option</option>
									[dropdownoptions.Join()]
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
				[make_view_variables_var_list(thing)]
			</ol>
		</body>
		</html>
		"}

	usr << browse(html, "window=variables[REF(thing)];size=520x720")


/proc/make_view_variables_var_list(datum/D)
	. = ""
	var/list/variables = D.make_variable_list()
	variables = sortList(variables)
	for(var/x in variables)
		CHECK_TICK
		. += make_view_variables_var_entry(D, x, D.vars[x])

/datum/proc/make_variable_list()
	. = list()
	for(var/x in vars)
		CHECK_TICK
		if(x in view_variables_hide_vars)
			continue
		if(!can_vv_get(x))
			continue
		. += x
	return .

/proc/make_view_variables_value(datum/D, value, varname = "*")
	var/vtext = ""
	var/debug_type = get_debug_type(value, FALSE)
	var/extra = list()
	if(istext(value))
		debug_type = null // it's kinda annoying here; we can tell the type by the quotes
		vtext = "\"[html_encode(value)]\""
	else if(isicon(value))
		vtext = "[value]"
	else if(isfile(value))
		vtext = "'[value]'"
	else if(istype(value, /datum))
		var/datum/DA = value
		if("[DA]" == "[DA.type]" || !"[DA]")
			vtext = "<a href='byond://?_src_=vars;Vars=[REF(DA)]'>[REF(DA)]</a> - [DA.type]"
		else
			vtext = "<a href='byond://?_src_=vars;Vars=[REF(DA)]'>[REF(DA)]</a> - [DA] ([DA.type])"
	else if(istype(value, /client))
		var/client/C = value
		vtext = "<a href='byond://?_src_=vars;Vars=[REF(C)]'>[REF(C)]</a> - [C] ([C.type])"
	else if(islist(value))
		var/list/L = value
		vtext = "/list ([length(L)])"

		//Let's just compute it once instead of for every element
		var/is_normal_list = IS_NORMAL_LIST(L)

		if(!(varname in view_variables_dont_expand) && length(L) > 0 && length(L) < 100)
			extra += "<ul>"

			//Loop through the list and make the elements into html
			for(var/index in 1 to length(L))
				var/entry = L[index]

				//If the key is a valid associative key (not a number)
				if(is_normal_list && IS_VALID_ASSOC_KEY(entry))

					//The possibly associative key is actually referencing something, now we know the list is associative
					if(!isnull(L[entry]))
						extra += "<li>[index]: [make_view_variables_value(D, entry)] -> [make_view_variables_value(D, L[entry])]</li>"
					//The possibly associative key is not referencing anything, so it's just a normal element in the list
					else
						extra += "<li>[index]: [make_view_variables_value(D, entry)]</li>"

				//The list is a list with numbers as keys
				else
					extra += "<li>[index]: [make_view_variables_value(D, entry)]</li>"

			extra += "</ul>"

		else if(length(L) >= 100)
			vtext = "([length(L)]): <ul><li><a href='byond://?_src_=vars;datumview=[REF(L)];varnameview=[varname];original_datum=[REF(D)]'>List too large to display, click to view.</a></ul>"

	else
		vtext = "[value]"

	return "<span class=type>[debug_type]</span> <span class=value>[vtext]</span>[jointext(extra, "")]"

/proc/make_view_variables_var_entry(datum/D, varname, value, level=0)
	var/ecm = null

	if(D)
		//These are the VV_HK_BASIC_* defines
		ecm = {"
			(<a href='byond://?_src_=vars;datumedit=[REF(D)];varnameedit=[varname]'>E</a>)
			(<a href='byond://?_src_=vars;datumchange=[REF(D)];varnamechange=[varname]'>C</a>)
			(<a href='byond://?_src_=vars;datummass=[REF(D)];varnamemass=[varname]'>M</a>)
			"}

	var/valuestr = make_view_variables_value(D, value, varname)

	return "<li>[ecm]<span class='key'>[varname]</span> = [valuestr]</li>"
