/*
	MATERIAL DATUMS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation. ~Z

	PATHS THAT USE DATUMS
		turf/simulated/wall
		obj/item/material
		obj/structure/blocker
		obj/item/stack/material
		obj/structure/table

	VALID ICONS
		WALLS
			stone
			metal
			solid
			cult
		DOORS
			stone
			metal
			resin
			wood
*/

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return

/obj/proc/get_material_name()
	var/material/material = get_material()
	if(material)
		return material.name

// Material definition and procs follow.
/material
	var/name	                          // Unique name for use in indexing the list.
	var/display_name                      // Prettier name for display.
	var/adjective_name					  // To override the name for subtypes and stuff.
	var/use_name
	var/flags = 0                         // Various status modifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"

	// Shards/tables/structures
	var/shard_type = SHARD_SHRAPNEL       // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/list/recipes                      // Holder for all recipes usable with a sheet of this material.
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.

	// Icons
	var/colour_blend = TRUE
	var/icon_colour                                      // Colour applied to products of this material.
	var/wall_colour                                      // Colour applied to walls specifically.
	var/icon_base = "solid"                              // Wall and table base icon tag. See header.
	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/reinf_icon = "reinf_over"                        // Handles type of overlay used for tables and walls. Don't change without checking every use case.
	var/icon/multipart_reinf_icon
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1) // Research level for stacks.
	var/icon/wall_icon
	var/icon/table_icon

	// Attributes
	var/cut_delay = 0            // Delay in ticks when cutting through this wall.
	var/radioactivity            // Radiation var. Used in wall and object processing to irradiate surroundings.
	var/ignition_point           // K, point at which the material catches on fire.
	var/melting_point = 1800     // K, walls will take damage if they're next to a fire hotter than this
	var/integrity = 150          // General-use HP value for products.
	var/protectiveness = 10      // How well this material works as armor.  Higher numbers are better, diminishing returns applies.
	var/opacity = 1              // Is the material transparent? 0.5< makes transparent walls/doors.
	var/reflectivity = 0         // How reflective to light is the material?  Currently used for laser reflection and defense.
	var/explosion_resistance = 5 // Only used by walls currently.
	var/conductive = 1           // Objects with this var add CONDUCTS to flags on spawn.
	var/conductivity = null      // How conductive the material is. Iron acts as the baseline, at 10.
	var/list/composite_material  // If set, object matter var will be a list containing these values.

	// Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	// Damage values.
	var/hardness = 60            // Prob of wall destruction by hulk, used for edge damage in weapons. Also used for bullet protection in armor.
	var/weight = 20              // Determines blunt damage/throwforce for weapons, and whether it can be flipped. Check DEFAULT_TABLE_FLIP_WEIGHT if you want your materai to be tableflippable.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Noise made when you hit structure made of this material.
	var/hitsound = 'sound/weapons/Genhit.ogg'
	// Path to resulting stacktype. Todo remove need for this.
	var/stack_type
	// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"

	//What golem species is created with this material
	var/golem = null

	//automatic-ness for giving drop n' pickup sounds on init.
	var/drop_sound = 'sound/items/drop/axe.ogg'
	var/pickup_sound = 'sound/items/pickup/axe.ogg'

	//for use in material weapons. because tiles and stacks sound different. since cardboard baseball bats sound different from wooden ones and et cetera.
	var/weapon_drop_sound = 'sound/items/drop/metalweapon.ogg'
	var/weapon_pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	var/weapon_hitsound = /singleton/sound_category/swing_hit_sound

	var/shatter_sound = /singleton/sound_category/glass_break_sound //sound it makes when it breaks.

	/// Whether this material is fusion fuel or not.
	var/is_fusion_fuel
	/// Material light. Used for fuel rods.
	var/luminescence

/material/proc/build_rod_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need one rod and one sheet of [display_name] to make anything useful.</span>")
		return
	used_stack.use(1)
	target_stack.use(1)
	to_chat(user, "<span class='notice'>You attach a rod to the [display_name].</span>")
	var/obj/item/stack/S = new rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)

/material/proc/build_wired_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need five wires and one sheet of [display_name] to make anything useful.</span>")
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, "<span class='notice'>You attach wires to the [display_name].</span>")
	var/obj/item/product = new wire_product(get_turf(user))
	if(!(user.l_hand && user.r_hand))
		user.put_in_hands(product)

// Make sure we have a display name and shard icon even if they aren't explicitly set.
/material/New()
	..()
	if(!display_name)
		display_name = name
	if(!use_name)
		use_name = display_name
	if(!adjective_name)
		adjective_name = display_name
	if(!shard_icon)
		shard_icon = shard_type
	if(!icon_base)
		world.log <<  "materials: [src] has unknown icon_base [icon_base]."
/*
	var/skip_blend = FALSE
	switch (icon_base)
		if ("solid")
			wall_icon = 'icons/turf/smooth/composite_solid_color.dmi'
		if ("stone")
			wall_icon = 'icons/turf/smooth/composite_stone.dmi'
			multipart_reinf_icon = 'icons/turf/smooth/composite_stone_reinf.dmi'
		if ("metal")
			wall_icon = 'icons/turf/smooth/composite_metal.dmi'
		if ("wood")
			wall_icon = 'icons/turf/smooth/composite_wood.dmi'
		if ("cult")
			wall_icon = 'icons/turf/smooth/cult_wall.dmi'
			skip_blend = TRUE
		if ("arust")
			wall_icon = 'icons/turf/smooth/rusty_wall.dmi'
			skip_blend = TRUE
		if ("biomass")
			wall_icon = 'icons/turf/smooth/diona_wall.dmi'
			skip_blend = TRUE
		if ("vaurca")
			wall_icon = 'icons/turf/smooth/vaurca_wall.dmi'
			skip_blend = TRUE
		if ("shuttle")
			skip_blend = TRUE
		if ("skrell")
			skip_blend = TRUE
		if("concrete")
			wall_icon = 'icons/turf/smooth/concrete_wall.dmi'
			skip_blend = TRUE
		else
			world.log <<  "materials: [src] has unknown icon_base [icon_base]."*/
	var/blend_colour = wall_colour ? wall_colour : icon_colour
	if (wall_icon && blend_colour && colour_blend)
		wall_icon = new(wall_icon)
		wall_icon.Blend(blend_colour, ICON_MULTIPLY)
		if (multipart_reinf_icon)
			multipart_reinf_icon = new(multipart_reinf_icon)
			multipart_reinf_icon.Blend(blend_colour, ICON_MULTIPLY)

// This is a placeholder for proper integration of windows/windoors into the system.
/material/proc/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)
	return 0

// Weapons handle applying a divisor for this value locally.
/material/proc/get_blunt_damage()
	return weight //todo

// Return the matter comprising this material.
/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter[material_string] = composite_material[material_string]
	else
		temp_matter[name] = SHEET_MATERIAL_AMOUNT
	return temp_matter

// As above.
/material/proc/get_edge_damage()
	return hardness //todo

// Snowflakey, only checked for alien doors at the moment.
/material/proc/can_open_material_door(var/mob/living/user)
	return 1

// Currently used for weapons and objects made of uranium to irradiate things.
/material/proc/products_need_process()
	return (radioactivity>0) //todo

// Used by walls when qdel()ing to avoid neighbor merging.
/material/placeholder
	name = "placeholder"

// Places a girder object when a wall is dismantled, also applies reinforced material.
/material/proc/place_dismantled_girder(var/turf/target, var/material/reinf_material)
	var/obj/structure/girder/G = new(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()

// General wall debris product placement.
// Not particularly necessary aside from snowflakey cult girders.
/material/proc/place_dismantled_product(var/turf/target,var/is_devastated)
	for(var/x=1;x<(is_devastated?2:3);x++)
		place_sheet(target)

// Debris product. Used ALL THE TIME.
/material/proc/place_sheet(var/turf/target)
	if(stack_type)
		for(var/obj/item/stack/S in target)
			if(S.type == stack_type && S.amount < S.max_amount)
				S.amount++
				S.update_icon()
				return S
		return new stack_type(target)

// As above.
/material/proc/place_shard(var/turf/target)
	if(shard_type)
		return new /obj/item/material/shard(target, src.name)

// Used by walls and weapons to determine if they break or not.
/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)

/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

// Datum definitions follow.
/material/uranium
	name = MATERIAL_URANIUM
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	reinf_icon = "reinf_stone"
	icon_colour = "#007A00"
	weight = 25
	hardness = 20
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	golem = SPECIES_GOLEM_URANIUM

/material/diamond
	name = MATERIAL_DIAMOND
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	reflectivity = 0.6
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/glass_hit.ogg'
	hitsound = 'sound/effects/glass_hit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)
	golem = SPECIES_GOLEM_DIAMOND
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/material/gold
	name = MATERIAL_GOLD
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 30
	hardness = 15
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	golem = SPECIES_GOLEM_GOLD

/material/bronze
	name = MATERIAL_BRONZE
	stack_type = /obj/item/stack/material/bronze
	weight = 30
	hardness = 50
	conductivity = 11
	icon_colour = "#EDD12F"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	golem = SPECIES_GOLEM_BRONZE

/material/osmium
	name = MATERIAL_OSMIUM
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999ff"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	value = 30

/material/silver
	name = MATERIAL_SILVER
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	golem = SPECIES_GOLEM_SILVER

/material/phoron
	name = MATERIAL_PHORON
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	golem = SPECIES_GOLEM_PHORON
	is_fusion_fuel = TRUE
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/material/phoron/supermatter
	name = MATERIAL_SUPERMATTER
	icon_colour = "#ffff00"
	radioactivity = 20
	conductivity = 100
	integrity = 10
	luminescence = 3
	hardness = 10
	weight = 1000
	sheet_singular_name = "cluster"
	sheet_plural_name = "clusters"
	stack_origin_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_PHORON = 4)
	stack_type = null

/material/stone
	name = MATERIAL_SANDSTONE
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	reinf_icon = "reinf_stone"
	icon_colour = "#d9c179"
	wall_icon = 'icons/turf/smooth/composite_stone.dmi'
	multipart_reinf_icon = 'icons/turf/smooth/composite_stone_reinf.dmi'
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	protectiveness = 5 // 20%
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	golem = SPECIES_GOLEM_SAND
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/material/stone/marble
	name = MATERIAL_MARBLE
	icon_colour = "#b4b1a6"
	weight = 26
	hardness = 70
	stack_type = /obj/item/stack/material/marble
	golem = SPECIES_GOLEM_MARBLE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/material/concrete
	name = MATERIAL_CONCRETE
	icon_colour = COLOR_CONCRETE
	wall_colour = COLOR_CONCRETE
	wall_icon = 'icons/turf/smooth/composite_solid_color.dmi'
	table_icon = 'icons/obj/structure/tables/steel_table.dmi'
	stack_type = null
	golem = null

/material/steel
	name = DEFAULT_WALL_MATERIAL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11
	protectiveness = 10 // 33%
	wall_icon = 'icons/turf/smooth/composite_solid_color.dmi'
	table_icon = 'icons/obj/structure/tables/steel_table.dmi'
	icon_colour = COLOR_GRAY40
	wall_colour = COLOR_GRAY20
	golem = SPECIES_GOLEM_STEEL
	hitsound = 'sound/weapons/smash.ogg'
	weapon_hitsound = 'sound/weapons/metalhit.ogg'


/material/diona
	name = MATERIAL_DIONA
	icon_colour = null
	stack_type = null
	wall_icon = 'icons/turf/smooth/diona_wall.dmi'
	table_icon = 'icons/obj/structure/tables/diona_table.dmi'
	icon_base = "biomass"
	colour_blend = FALSE
	integrity = 100
	weight = 23
	// below is same as wood
	melting_point = T0C + 300
	ignition_point = T0C + 288
	golem = SPECIES_GOLEM_WOOD
	hitsound = 'sound/effects/woodhit.ogg'

/material/diona/place_dismantled_product()
	return

/material/diona/place_dismantled_girder(var/turf/target)
	new /obj/structure/diona/vines(target)

/material/steel/holographic
	name = "holo" + DEFAULT_WALL_MATERIAL
	display_name = DEFAULT_WALL_MATERIAL
	stack_type = null
	shard_type = SHARD_NONE

/material/plasteel
	name = MATERIAL_PLASTEEL
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	wall_icon = 'icons/turf/smooth/composite_reinf.dmi'
	icon_colour = "#545c68"
	wall_colour = COLOR_GRAY20
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 10
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = 3750, "platinum" = 3750) //todo
	golem = SPECIES_GOLEM_PLASTEEL
	hitsound = 'sound/weapons/smash.ogg'
	weapon_hitsound = 'sound/weapons/metalhit.ogg'

/material/plasteel/titanium
	name = MATERIAL_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	integrity = 600
	conductivity = 2.38
	hardness = 90
	weight = 25
	protectiveness = 25
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	golem = SPECIES_GOLEM_TITANIUM

/material/glass
	name = MATERIAL_GLASS
	stack_type = /obj/item/stack/material/glass
	table_icon = 'icons/obj/structure/tables/glass_table.dmi'
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/glass_hit.ogg'
	hardness = 30
	weight = 15
	protectiveness = 0 // 0%
	conductivity = 1 // Glass shards don't conduct.
	icon_base = "glass"
	door_icon_base = "stone"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 4)
	created_window = /obj/structure/window/basic
	wire_product = /obj/item/stack/material/glass/wired
	rod_product = /obj/item/stack/material/glass/reinforced
	golem = SPECIES_GOLEM_GLASS
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/material/glass/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)

	if(!user || !used_stack || !created_window || !window_options.len)
		return 0

	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>This task is too complex for your clumsy hands.</span>")
		return 1

	var/turf/T = user.loc
	if(!istype(T))
		to_chat(user, "<span class='warning'>You must be standing on open flooring to build a window.</span>")
		return 1

	var/title = "Sheet-[used_stack.name] ([used_stack.get_amount()] sheet\s left)"
	var/choice = tgui_input_list(user, "What would you like to construct?", title, window_options)

	if(!choice || !used_stack || !user || used_stack.loc != user || user.stat || user.loc != T)
		return 1

	// Get data for building windows here.
	var/list/possible_directions = GLOB.cardinal.Copy()
	var/window_count = 0
	for (var/obj/structure/window/check_window in user.loc)
		window_count++
		possible_directions  -= check_window.dir

	// Get the closest available dir to the user's current facing.
	var/build_dir = SOUTHWEST //Default to southwest for fulltile windows.
	var/failed_to_build

	if(window_count >= 4)
		failed_to_build = 1
	else
		if(choice in list("One Direction","Windoor"))
			if(possible_directions.len)
				for(var/direction in list(user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
					if(direction in possible_directions)
						build_dir = direction
						break
			else
				failed_to_build = 1
			if(!failed_to_build && choice == "Windoor")
				if(!is_reinforced())
					to_chat(user, "<span class='warning'>This material is not reinforced enough to use for a door.</span>")
					return
				for(var/obj/obstacle in T)
					if((obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && obstacle.dir == user.dir)
						failed_to_build = 1
	if(failed_to_build)
		to_chat(user, "<span class='warning'>There is no room in this location.</span>")
		return 1

	var/build_path = /obj/structure/windoor_assembly
	var/sheets_needed = window_options[choice]
	if(choice == "Windoor")
		build_dir = user.dir
	else
		build_path = created_window

	if(used_stack.get_amount() < sheets_needed)
		to_chat(user, "<span class='warning'>You need at least [sheets_needed] sheets to build this.</span>")
		return 1

	// Build the structure and update sheet count etc.
	used_stack.use(sheets_needed)
	new build_path(T, build_dir, 1)
	return 1

/material/glass/proc/is_reinforced()
	return (hardness > 35) //todo

/material/glass/wired
	name = MATERIAL_GLASS_WIRED
	display_name = "wired glass"
	stack_type = /obj/item/stack/material/glass/wired
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/glass_hit.ogg'
	hardness = 40
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = 1875, MATERIAL_GLASS = 3750)
	window_options = list()
	created_window = null
	wire_product = null
	rod_product = null

/material/glass/reinforced
	name = MATERIAL_GLASS_REINFORCED
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/glass_hit.ogg'
	hardness = 40
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = 1875, MATERIAL_GLASS = 3750)
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 5)
	created_window = /obj/structure/window/reinforced
	wire_product = null
	rod_product = null

/material/glass/phoron
	name = MATERIAL_GLASS_PHORON
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MATERIAL_BRITTLE
	integrity = 100
	icon_colour = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	created_window = /obj/structure/window/borosilicate
	wire_product = null
	rod_product = /obj/item/stack/material/glass/phoronrglass
	golem = SPECIES_GOLEM_PHORON

/material/glass/phoron/reinforced
	name = MATERIAL_GLASS_REINFORCED_PHORON
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronrglass
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list() //todo
	created_window = /obj/structure/window/borosilicate/reinforced
	hardness = 40
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list() //todo
	rod_product = null

/material/plastic
	name = MATERIAL_PLASTIC
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)
	golem = SPECIES_GOLEM_PLASTIC
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/material/plastic/holographic
	name = MATERIAL_PLASTIC_HOLO
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/material/osmium
	name = MATERIAL_OSMIUM
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/mhydrogen
	name = MATERIAL_HYDROGEN_METALLIC
	display_name = "metallic hydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	golem = SPECIES_GOLEM_HYDROGEN
	is_fusion_fuel = TRUE

/material/platinum
	name =  MATERIAL_PLATINUM
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/material/iron
	name = MATERIAL_IRON
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	golem = SPECIES_GOLEM_IRON
	hitsound = 'sound/weapons/smash.ogg'
	weapon_hitsound = 'sound/weapons/metalhit.ogg'

/material/aluminium
	name = MATERIAL_ALUMINIUM
	stack_type = /obj/item/stack/material/aluminium
	icon_colour = "#cccdcc"
	weight = 18
	conductivity = 29.48
	hitsound = 'sound/weapons/smash.ogg'
	weapon_hitsound = 'sound/weapons/metalhit.ogg'

/material/lead
	name = MATERIAL_LEAD
	stack_type = /obj/item/stack/material/lead
	icon_colour = "#5f5960"
	weight = 32
	conductivity = 4.39
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	weapon_hitsound = 'sound/weapons/metalhit.ogg'

// Adminspawn only, do not let anyone get this.
/material/elevatorium
	name = MATERIAL_ELEVATOR
	display_name = "elevator panelling"
	stack_type = null
	icon_colour = "#666666"
	wall_icon = 'icons/turf/smooth/composite_solid_color.dmi'
	integrity = 1200
	melting_point = 6000
	explosion_resistance = 200
	hardness = 500
	weight = 500
	protectiveness = 80

/material/wood
	name = MATERIAL_WOOD
	stack_type = /obj/item/stack/material/wood // why wouldn't it have a stacktype seriously guys why
	icon_colour = WOOD_COLOR_GENERIC
	integrity = 50
	icon_base = "wood"
	wall_icon = 'icons/turf/smooth/composite_wood.dmi'
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18
	protectiveness = 8 // 28%
	conductivity = 1
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	shatter_sound = /singleton/sound_category/wood_break_sound
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"
	golem = SPECIES_GOLEM_WOOD
	hitsound = 'sound/effects/woodhit.ogg'
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
	weapon_drop_sound = 'sound/items/drop/woodweapon.ogg'
	weapon_pickup_sound = 'sound/items/pickup/woodweapon.ogg'
	weapon_hitsound = 'sound/weapons/woodenhit.ogg'
	reinf_icon = "reinf_wood"

/material/wood/birch
	name = MATERIAL_BIRCH
	stack_type = /obj/item/stack/material/wood/coloured/birch
	icon_colour = WOOD_COLOR_BIRCH

/material/wood/mahogany
	name = MATERIAL_MAHOGANY
	stack_type = /obj/item/stack/material/wood/coloured/mahogany
	icon_colour = WOOD_COLOR_RICH

/material/wood/maple
	name = MATERIAL_MAPLE
	stack_type = /obj/item/stack/material/wood/coloured/maple
	icon_colour = WOOD_COLOR_PALE

/material/wood/bamboo
	name = MATERIAL_BAMBOO
	stack_type = /obj/item/stack/material/wood/coloured/bamboo
	icon_colour = WOOD_COLOR_PALE2

/material/wood/ebony
	name = MATERIAL_EBONY
	stack_type = /obj/item/stack/material/wood/coloured/ebony
	icon_colour = WOOD_COLOR_BLACK

/material/wood/walnut
	name = MATERIAL_WALNUT
	stack_type = /obj/item/stack/material/wood/coloured/walnut
	icon_colour = WOOD_COLOR_CHOCOLATE

/material/wood/yew
	name = MATERIAL_YEW
	stack_type = /obj/item/stack/material/wood/coloured/yew
	icon_colour = WOOD_COLOR_YELLOW

/material/wood/log //This is gonna replace wood planks in a  way for NBT, leaving it here for now
	name = MATERIAL_WOOD_LOG
	stack_type = /obj/item/stack/material/wood/log
	icon_colour = "#824B28"
	integrity = 50
	explosion_resistance = 4
	hardness = 30
	weight = 30 //Logs are heavier then normal pieces of wood
	conductivity = 0.8
	melting_point = T0C+380
	ignition_point = T0C+328
	destruction_desc = "splinters"
	sheet_singular_name = "pice"
	sheet_plural_name = "piles"

/material/wood/branch
	name = MATERIAL_WOOD_BRANCH
	stack_type = /obj/item/stack/material/wood/branch
	icon_colour = "#824B28"
	integrity = 10
	explosion_resistance = 0
	hardness = 0.1
	weight = 7
	melting_point = T0C+220
	ignition_point = T0C+218
	sheet_singular_name = "bundle"
	sheet_plural_name = "bundle"

/material/rust
	name = MATERIAL_RUST
	display_name = "rusty steel"
	stack_type = null
	icon_colour = "#B7410E"
	icon_base = "arust"
	wall_icon = 'icons/turf/smooth/rusty_wall.dmi'
	integrity = 250
	explosion_resistance = 8
	hardness = 15
	weight = 18

/material/wood/holographic
	name = MATERIAL_WOOD_HOLO
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/material/cardboard
	name = MATERIAL_CARDBOARD
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	shatter_sound = /singleton/sound_category/cardboard_break_sound
	golem = SPECIES_GOLEM_CARDBOARD
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	weapon_hitsound = 'sound/weapons/cardboardhit.ogg'

/material/cult
	name = MATERIAL_CULT
	display_name = "daemon stone"
	icon_base = "cult"
	wall_icon = 'icons/turf/smooth/cult_wall.dmi'
	colour_blend = FALSE
	icon_colour = COLOR_CULT
	reinf_icon = "reinf_cult"
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "resin"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target)

/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/cleanable/blood(target)

/material/cult/reinf
	name = MATERIAL_CULT_REINFORCED
	icon_colour = COLOR_CULT_REINFORCED
	display_name = "human remains"

/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)

/material/resin
	name = MATERIAL_RESIN
	icon_colour = "#E85DD8"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"

/material/leather
	name = MATERIAL_LEATHER
	icon_colour = "#5C4831"
	stack_type = /obj/item/stack/material/leather
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	hardness = 1
	weight = 1
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	golem = SPECIES_GOLEM_MEAT
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/material/leather/fine
	name = MATERIAL_LEATHER_FINE
	icon_colour = "#4B3A27"
	stack_type = /obj/item/stack/material/leather/fine
	ignition_point = T0C+320
	melting_point = T0C+320

/material/cotton
	name = MATERIAL_COTTON
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	hardness = 1
	weight = 1
	golem = SPECIES_GOLEM_CLOTH
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	weapon_hitsound = 'sound/weapons/towelwhip.ogg'

/material/carpet
	name = MATERIAL_CARPET
	display_name = "comfy"
	use_name = "red upholstery"
	stack_type = /obj/item/stack/tile/carpet
	hardness = 1
	weight = 1
	icon_colour = COLOR_RED
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%
	table_icon = 'icons/obj/structure/tables/fancy_table.dmi'
	golem = SPECIES_GOLEM_CLOTH
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	weapon_hitsound = 'sound/weapons/towelwhip.ogg'

/material/carpet/black
	name = MATERIAL_CARPET_BLACK
	use_name = "black upholstery"
	stack_type = /obj/item/stack/tile/carpet/black
	icon_colour = COLOR_BLACK
	table_icon = 'icons/obj/structure/tables/fancy_table_black.dmi'

/material/carpet/blue
	name = MATERIAL_CARPET_BLUE
	use_name = "blue upholstery"
	stack_type = /obj/item/stack/tile/carpet/lightblue
	icon_colour = COLOR_BLUE
	table_icon = 'icons/obj/structure/tables/fancy_table_blue.dmi'

/material/carpet/cyan
	name = MATERIAL_CARPET_CYAN
	use_name = "cyan upholstery"
	stack_type = /obj/item/stack/tile/carpet/cyan
	icon_colour = COLOR_CYAN
	table_icon = 'icons/obj/structure/tables/fancy_table_cyan.dmi'

/material/carpet/green
	name = MATERIAL_CARPET_GREEN
	use_name = "green upholstery"
	stack_type = /obj/item/stack/tile/carpet/green
	icon_colour = COLOR_GREEN
	table_icon = 'icons/obj/structure/tables/fancy_table_green.dmi'

/material/carpet/orange
	name = MATERIAL_CARPET_ORANGE
	use_name = "orange upholstery"
	stack_type = /obj/item/stack/tile/carpet/orange
	icon_colour = COLOR_ORANGE
	table_icon = 'icons/obj/structure/tables/fancy_table_green.dmi'

/material/carpet/purple
	name = MATERIAL_CARPET_PURPLE
	use_name = "purple upholstery"
	stack_type = /obj/item/stack/tile/carpet/purple
	icon_colour = COLOR_PURPLE
	table_icon = 'icons/obj/structure/tables/fancy_table_purple.dmi'

/material/carpet/red
	name = MATERIAL_CARPET_RED
	stack_type = /obj/item/stack/tile/carpet/red
	icon_colour = COLOR_RED
	table_icon = 'icons/obj/structure/tables/fancy_table_red.dmi'

/material/cloth
	name = MATERIAL_CLOTH
	stack_type = /obj/item/stack/material/cloth
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	flags = MATERIAL_PADDING
	hardness = 1
	weight = 1
	golem = SPECIES_GOLEM_CLOTH
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	weapon_hitsound = 'sound/weapons/towelwhip.ogg'

/material/hide //TODO make different hides somewhat different among them
	name = MATERIAL_HIDE
	stack_origin_tech = list(TECH_MATERIAL = 2)
	stack_type = /obj/item/stack/material/animalhide
	door_icon_base = "wood"
	icon_colour = "#5C4831"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MATERIAL_PADDING
	hardness = 1
	weight = 1
	protectiveness = 3 // 13%
	golem = SPECIES_GOLEM_MEAT
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/material/hide/corgi
	name = MATERIAL_HIDE_CORGI
	stack_type = /obj/item/stack/material/animalhide/corgi
	icon_colour = "#F9A635"

/material/hide/cat
	name = MATERIAL_HIDE_CAT
	stack_type = /obj/item/stack/material/animalhide/cat
	icon_colour = "#444444"

/material/hide/monkey
	name = MATERIAL_HIDE_MONKEY
	stack_type = /obj/item/stack/material/animalhide/monkey
	icon_colour = "#914800"

/material/hide/lizard
	name = MATERIAL_HIDE_LIZARD
	stack_type = /obj/item/stack/material/animalhide/lizard
	icon_colour = "#34AF10"

/material/hide/human
	name = MATERIAL_HIDE_HUMAN
	stack_type = /obj/item/stack/material/animalhide/human
	icon_colour = "#833C00"

/material/hide/barehide
	name = "bare hide"
	stack_type = /obj/item/stack/material/animalhide/barehide

/material/hide/wetleather
	name = "wet leather"
	stack_type = /obj/item/stack/material/animalhide/wetleather

/material/bone
	name = MATERIAL_BONE
	icon_colour = "#e3dac9"
	icon_base = "stone"
	reinf_icon = "reinf_stone"
	sheet_singular_name = "bone"
	sheet_plural_name = "bones"
	weight = 10
	hardness = 20
	integrity = 70
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "stone"
	protectiveness = 10 // 33%
	golem = SPECIES_GOLEM_MEAT

/material/bone/necromancer
	name = MATERIAL_BONE_CURSED
	weight = 20
	integrity = 150
	hardness = 60
	protectiveness = 20 // 50%

/material/vaurca
	name = MATERIAL_VAURCA
	display_name = "alien biomass"
	stack_type = null
	icon_colour = "#1C7400"
	icon_base = "vaurca"
	wall_icon = 'icons/turf/smooth/vaurca_wall.dmi'
	colour_blend = FALSE
	integrity = 400
	melting_point = 6000
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 10

/material/shuttle
	name = MATERIAL_SHUTTLE
	display_name = "plastitanium alloy"
	stack_type = null
	reinf_icon = "no_sprite"//placeholder
	icon_base = "shuttle"
	//wall_icon = 'icons/turf/smooth/composite_solid_color.dmi'
	colour_blend = FALSE
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	protectiveness = 80 // 80%
	cut_delay = 20 SECONDS

/material/shuttle/skrell
	name = MATERIAL_SHUTTLE_SKRELL
	table_icon = 'icons/obj/structure/tables/skrell_table.dmi'
	display_name = "superadvanced alloy"
	weight = 23
	colour_blend = FALSE
	icon_colour = null
	icon_base = "skrell"

/material/graphite
	name = MATERIAL_GRAPHITE
	stack_type = /obj/item/stack/material/graphite
	icon_colour = "#666666"
	shard_type = SHARD_STONE_PIECE
	weight = 20
	hardness = 20
	protectiveness = 5 // 20%
	conductivity = 5
	sheet_singular_name = "bar"
	sheet_plural_name = "bars"
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/material/tritium
	name = MATERIAL_TRITIUM
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = TRUE
	value = 300

/material/deuterium
	name = MATERIAL_DEUTERIUM
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = TRUE
