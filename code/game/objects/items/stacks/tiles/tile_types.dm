/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Carpet
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	desc = "A non-descript floor tile"
	w_class = 3
	max_amount = 60
	icon = 'icons/obj/stacks/tiles.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_tiles.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_tiles.dmi',
		)
	randpixel = 7
	drop_sound = 'sound/items/drop/axe.ogg'

/obj/item/stack/tile/New()
	..()
	randpixel_xy()

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "synthetic grass tile"
	singular_name = "synthetic grass tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	origin_tech = list(TECH_BIO = 1)
	drop_sound = 'sound/items/drop/herb.ogg'

/obj/item/stack/tile/grass_alt
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A soft patch of grass."
	icon_state = "tile_grass_alt"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	origin_tech = list(TECH_BIO = 1)
	drop_sound = 'sound/items/drop/herb.ogg'

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile_wood"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	drop_sound = 'sound/items/drop/wooden.ogg'

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	icon_state = "tile_carpet"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/stack/tile/carpet_blue
	name = "blue carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	icon_state = "tile_carpet_blue"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/stack/tile/carpet_rubber
	name = "rubber carpet"
	singular_name = "carpet"
	desc = "A piece of rubber carpet. It is the same size as a normal floor tile!"
	icon_state = "tile_carpet_rubber"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/stack/tile/carpet_art
	name = "adhomian carpet"
	singular_name = "carpet"
	desc = "A piece of fancy adhomian carpet. It is the same size as a normal floor tile!"
	icon_state = "tile_carpet_rubber"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/stack/tile/lino
	name = "old linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile_linoleum"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	drop_sound = 'sound/items/drop/clothing.ogg'
	matter = list(MATERIAL_PLASTIC = 937.5)

/obj/item/stack/tile/lino_grey
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile_linoleum_grey"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	drop_sound = 'sound/items/drop/clothing.ogg'
	matter = list(MATERIAL_PLASTIC = 937.5)

/*
 * Circuits
 */

/obj/item/stack/tile/circuit_blue
	name = "circuit tile"
	singular_name = "circuit tile"
	desc = "An advanced tile covered in various circuitry and wiring."
	icon_state = "tile_bcircuit"
	force = 6.0
	matter = list(DEFAULT_WALL_MATERIAL = 937.5, MATERIAL_GLASS = 937.5)
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = CONDUCT

/obj/item/stack/tile/circuit_green
	name = "circuit tile"
	singular_name = "circuit tile"
	desc = "An advanced tile covered in various circuitry and wiring."
	icon_state = "tile_gcircuit"
	force = 6.0
	matter = list(DEFAULT_WALL_MATERIAL = 937.5, MATERIAL_GLASS = 937.5)
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = CONDUCT

/*
 * Floors
 */

/obj/item/stack/tile/floor
	name = "floor tile"
	singular_name = "floor tile"
	desc = "Those could work as a pretty decent throwing weapon" //why?
	icon_state = "tile"
	force = 6.0
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = CONDUCT

/obj/item/stack/tile/floor_red
	name = "red floor tile"
	singular_name = "red floor tile"
	color = COLOR_RED_GRAY
	icon_state = "tile_white"

/obj/item/stack/tile/floor_steel
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list(MATERIAL_PLASTEEL = 937.5)

/obj/item/stack/tile/floor_white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_PLASTIC = 937.5)

/obj/item/stack/tile/floor_yellow
	name = "yellow floor tile"
	singular_name = "yellow floor tile"
	color = COLOR_BROWN
	icon_state = "tile_white"

/obj/item/stack/tile/floor_dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_PLASTEEL = 937.5)

/obj/item/stack/tile/floor_freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	matter = list(MATERIAL_PLASTIC = 937.5)

/obj/item/stack/tile/silver
	name = "silver floor tile"
	singular_name = "silver floor tile"
	icon_state = "tile_silver"
	matter = list(MATERIAL_SILVER = 937.5)

/obj/item/stack/tile/gold
	name = "golden floor tile"
	singular_name = "golden floor tile"
	icon_state = "tile_gold"
	matter = list(MATERIAL_GOLD = 937.5)

/obj/item/stack/tile/uranium
	name = "uranium floor tile"
	singular_name = "uranium floor tile"
	icon_state = "tile_uranium"
	matter = list(MATERIAL_URANIUM = 937.5)

/obj/item/stack/tile/phoron
	name = "phoron floor tile"
	singular_name = "phoron floor tile"
	icon_state = "tile_plasma"
	matter = list(MATERIAL_PHORON = 937.5)

/obj/item/stack/tile/diamond
	name = "diamond floor tile"
	singular_name = "diamond floor tile"
	icon_state = "tile_diamond"
	matter = list(MATERIAL_DIAMOND = 937.5)

/*
 * Cyborg modules
 */

/obj/item/stack/tile/wood/cyborg
	name = "wood floor tile synthesizer"
	desc = "A device that makes wood floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /obj/item/stack/tile/wood

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes steel floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor

/obj/item/stack/tile/floor_white/cyborg
	name = "white floor tile synthesizer"
	desc = "A device that makes plastic white floor tiles."
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor_white
	build_type = /obj/item/stack/tile/floor_white

/obj/item/stack/tile/floor_freezer/cyborg
	name = "freezer floor tile synthesizer"
	desc = "A device that makes plastic tiles which are mainly used to build freezer rooms."
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor_freezer
	build_type = /obj/item/stack/tile/floor_freezer

/obj/item/stack/tile/floor_dark/cyborg
	name = "dark floor tile synthesizer"
	desc = "A device that makes plasteel dark floor tiles."
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor_dark
	build_type = /obj/item/stack/tile/floor_dark

/obj/item/stack/tile/carpet/cyborg
	name = "carpet tile synthesizer"
	desc = "A device that makes carpet tiles."
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/carpet
	build_type = /obj/item/stack/tile/carpet
