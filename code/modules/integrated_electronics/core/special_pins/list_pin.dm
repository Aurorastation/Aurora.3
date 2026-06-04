/*
 * core/special_pins/list_pin.dm
 * List pin serialization, display, cloning, and safety handling for list-valued circuit data.
 */

// These pins contain a list.
// Lists may contain strings, numbers, weakrefs, nested lists, or null.
// Individual circuits are responsible for deciding what data types they accept.

/datum/integrated_io/list
	name = "list pin"
	data = list()

/datum/integrated_io/list/ask_for_pin_data(mob/user)
	interact(user)

/datum/integrated_io/list/proc/interact(mob/user)
	var/list/my_list = data
	var/t = "<h2>[src]</h2><br>"
	t += "List length: [my_list.len]<br>"
	t += "<a href='byond://?src=[REF(src)]'>Refresh</a>  |  "
	t += "<a href='byond://?src=[REF(src)];add=1'>Add</a>  |  "
	t += "<a href='byond://?src=[REF(src)];remove=1'>Remove</a>  |  "
	t += "<a href='byond://?src=[REF(src)];edit=1'>Edit</a>  |  "
	t += "<a href='byond://?src=[REF(src)];swap=1'>Swap</a>  |  "
	t += "<a href='byond://?src=[REF(src)];clear=1'>Clear</a><br>"
	t += "<hr>"

	for(var/i = 1; i <= my_list.len; i++)
		t += "#[i] | [display_data(my_list[i])]  |  "
		t += "<a href='byond://?src=[REF(src)];edit=1;pos=[i]'>Edit</a>  |  "
		t += "<a href='byond://?src=[REF(src)];remove=1;pos=[i]'>Remove</a><br>"

	var/datum/browser/B = new(user, "list_pin_[REF(src)]", null, 500, 400)
	B.set_content(t)
	B.open(FALSE)

/datum/integrated_io/list/proc/add_to_list(mob/user, new_entry)
	if(isnull(new_entry) && user)
		new_entry = ask_for_data_type(user, null, list("string", "number", "null"))

	Add(new_entry)

/datum/integrated_io/list/proc/Add(new_entry)
	if(!islist(data))
		data = list()

	var/list/my_list = data

	if(my_list.len >= IC_MAX_LIST_LENGTH)
		my_list.Cut(1, 2)

	my_list += list(new_entry)
	holder.on_data_written()

/datum/integrated_io/list/proc/remove_from_list_by_position(mob/user, position)
	var/list/my_list = data

	if(!my_list.len)
		to_chat(user, SPAN_WARNING("The list is empty, there's nothing to remove."))
		return

	if(isnull(position))
		return

	position = round(position)

	if(position < 1 || position > my_list.len)
		return

	my_list.Cut(position, position + 1)
	holder.on_data_written()

/datum/integrated_io/list/proc/remove_from_list(mob/user, target_entry)
	var/list/my_list = data

	if(!my_list.len)
		to_chat(user, SPAN_WARNING("The list is empty, there's nothing to remove."))
		return

	if(isnull(target_entry))
		target_entry = input("Which piece of data do you want to remove?", "Remove") as null|anything in my_list

	if(!isnull(target_entry))
		var/position = my_list.Find(target_entry)
		if(position)
			my_list.Cut(position, position + 1)
			holder.on_data_written()

/datum/integrated_io/list/proc/edit_in_list(mob/user, target_entry)
	var/list/my_list = data

	if(!my_list.len)
		to_chat(user, SPAN_WARNING("The list is empty, there's nothing to modify."))
		return

	if(isnull(target_entry))
		target_entry = input("Which piece of data do you want to edit?", "Edit") as null|anything in my_list

	if(!isnull(target_entry))
		var/i = my_list.Find(target_entry)
		if(i)
			var/edited_entry = ask_for_data_type(user, target_entry, list("string", "number", "null"))
			my_list[i] = edited_entry
			holder.on_data_written()

/datum/integrated_io/list/proc/edit_in_list_by_position(mob/user, position)
	var/list/my_list = data

	if(!my_list.len)
		to_chat(user, SPAN_WARNING("The list is empty, there's nothing to modify."))
		return

	if(isnull(position))
		return

	position = round(position)

	if(position < 1 || position > my_list.len)
		return

	var/target_entry = my_list[position]
	var/edited_entry = ask_for_data_type(user, target_entry, list("string", "number", "null"))
	my_list[position] = edited_entry
	holder.on_data_written()

/datum/integrated_io/list/proc/swap_inside_list(mob/user, first_target, second_target)
	var/list/my_list = data

	if(my_list.len <= 1)
		to_chat(user, SPAN_WARNING("The list is empty, or too small to do any meaningful swapping."))
		return

	if(isnull(first_target))
		first_target = input("Which piece of data do you want to swap? (1)", "Swap") as null|anything in my_list

	if(isnull(first_target))
		return

	if(isnull(second_target))
		second_target = input("Which piece of data do you want to swap? (2)", "Swap") as null|anything in my_list - first_target

	if(isnull(second_target))
		return

	var/first_pos = my_list.Find(first_target)
	var/second_pos = my_list.Find(second_target)

	if(first_pos && second_pos)
		my_list.Swap(first_pos, second_pos)
		holder.on_data_written()

/datum/integrated_io/list/proc/clear_list(mob/user)
	var/list/my_list = data
	my_list.Cut()
	holder.on_data_written()

/datum/integrated_io/list/scramble()
	var/list/my_list = data
	data = shuffle(my_list)
	push_data()

/datum/integrated_io/list/write_data_to_pin(var/new_data)
	if(isnull(new_data))
		data = list()
		holder.on_data_written()
		return

	if(!islist(new_data))
		return

	var/list/new_list = new_data
	var/list/sanitized = list()

	for(var/value in new_list)
		if(isnull(value) || isnum(value) || istext(value) || isweakref(value) || islist(value))
			sanitized += list(value)

	data = sanitized
	holder.on_data_written()

/datum/integrated_io/list/display_pin_type()
	return IC_FORMAT_LIST

/datum/integrated_io/list/Topic(href, href_list, state = GLOB.always_state)
	if(!holder.check_interactivity(usr))
		return

	if(..())
		return TRUE

	if(href_list["add"])
		add_to_list(usr)

	if(href_list["swap"])
		swap_inside_list(usr)

	if(href_list["clear"])
		clear_list(usr)

	if(href_list["remove"])
		if(href_list["pos"])
			remove_from_list_by_position(usr, text2num(href_list["pos"]))
		else
			remove_from_list(usr)

	if(href_list["edit"])
		if(href_list["pos"])
			edit_in_list_by_position(usr, text2num(href_list["pos"]))
		else
			edit_in_list(usr)

	holder.interact(usr)
	interact(usr)

	return TRUE
