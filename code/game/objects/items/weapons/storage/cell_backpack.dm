/obj/item/storage/backpack/cell
	name = "power cell backpack"
	desc = "A specially designed power cell rack backpack. Includes an interior holographic display that shows held cells' charge."
	description_fluff = "Designed by Nanotrasen Scientists in 2462, the power cell backpack, formally known as the 'NT-100 Zeus' or more informally, the 'ABT-DMN-TME'. Using sophisticated sensors first designed four centuries earlier, hooked up to screens designed three centuries earlier, it allows the user to hotswap batteries at a glance, without spending many eye-hours wasted counting charge and doing mental arithmetic."
	icon = 'icons/obj/cell_backpack.dmi'
	icon_state = "cell_rack"
	item_state = "cell_rack"
	contained_sprite = TRUE
	use_sound = 'sound/items/storage/toolbox.ogg'
	drop_sound = 'sound/items/drop/metalboots.ogg'
	can_hold = list(/obj/item/cell)
	max_storage_space = 40 // about 10 cells
	storage_slots = 10
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE

/obj/item/storage/backpack/cell/Initialize()
	. = ..()
	set_light(2, 0.75, LIGHT_COLOR_FIRE)

/obj/item/storage/backpack/cell/slot_orient_objs(var/rows, var/cols, var/list/obj/item/display_contents)
	var/cx = 4
	var/cy = 2+rows
	src.boxes.screen_loc = "4:16,2:16 to [4+cols]:16,[2+rows]:16"

	for(var/obj/item/cell/C in contents)
		C.screen_loc = "[cx]:16,[cy]:16"
		var/current_charge = round((C.charge / C.maxcharge) * 100)
		var/maptext_color = COLOR_BRIGHT_GREEN
		switch(current_charge)
			if(99 to INFINITY)
				maptext_color = COLOR_BRIGHT_GREEN
			if(80 to 99)
				maptext_color = COLOR_OLIVE
			if(60 to 80)
				maptext_color = COLOR_CIVIE_GREEN
			if(40 to 60)
				maptext_color = COLOR_YELLOW
			if(20 to 40)
				maptext_color = COLOR_ORANGE
			if(1 to 20)
				maptext_color = COLOR_RED_LIGHT
			if(-INFINITY to 1)
				maptext_color = COLOR_RED
		C.maptext = "<font color='[maptext_color]'>[current_charge]%</font>"
		C.layer = SCREEN_LAYER + 0.01
		cx++
		if (cx > (4+cols))
			cx = 4
			cy--
	closer.screen_loc = "[4+cols+1]:16,2:16"
	return