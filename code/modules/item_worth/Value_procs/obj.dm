/obj/Value()
	. = ..()
	for(var/a in contents)
		. += get_item_value(a)