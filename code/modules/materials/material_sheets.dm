// Stacked resources. They use a material datum for a lot of inherited values.
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	max_amount = 50

	var/default_type = DEFAULT_WALL_MATERIAL
	var/material/material
	var/perunit
	var/apply_colour //temp pending icon rewrite
	drop_sound = 'sound/items/drop/axe.ogg'

/obj/item/stack/material/Initialize()
	. = ..()
	randpixel_xy()

	if(!default_type)
		default_type = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(default_type)
	if(!material)
		qdel(src)
		return

	recipes = material.get_recipes()
	stacktype = material.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()
	perunit = SHEET_MATERIAL_AMOUNT

	if(apply_colour)
		color = material.icon_colour

	if(material.conductive)
		flags |= CONDUCT

	matter = material.get_matter()
	update_strings()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	singular_name = material.sheet_singular_name

	if(amount>1)
		name = "[material.use_name] [material.sheet_plural_name]"
		desc = "A stack of [material.use_name] [material.sheet_plural_name]."
		gender = PLURAL
	else
		name = "[material.use_name] [material.sheet_singular_name]"
		desc = "A [material.sheet_singular_name] of [material.use_name]."
		gender = NEUTER

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.name != M.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M) M.update_strings()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(iscoil(W))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material.build_rod_product(user, W, src)
		return
	return ..()

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-silver"
	default_type = MATERIAL_IRON
	apply_colour = 1

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	default_type = MATERIAL_SANDSTONE
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	default_type = MATERIAL_MARBLE
	drop_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	default_type = MATERIAL_DIAMOND
	drop_sound = 'sound/items/drop/glass.ogg'

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	default_type = MATERIAL_URANIUM

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	default_type = MATERIAL_PHORON
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/glass.ogg'

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	item_state = "sheet-plastic"
	default_type = MATERIAL_PLASTIC
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/card.ogg'

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	default_type = MATERIAL_GOLD
	icon_has_variants = TRUE

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	default_type = MATERIAL_OSMIUM

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-silver"
	default_type = MATERIAL_SILVER
	icon_has_variants = TRUE

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	default_type = MATERIAL_PLATINUM
	icon_has_variants = TRUE

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = MATERIAL_HYDROGEN_METALLIC

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	default_type = MATERIAL_TRITIUM
	apply_colour = 1

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	default_type = MATERIAL_OSMIUM
	apply_colour = 1

/obj/item/stack/material/steel
	name = DEFAULT_WALL_MATERIAL
	icon_state = "sheet-metal"
	default_type = DEFAULT_WALL_MATERIAL
	icon_has_variants = TRUE

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	default_type = MATERIAL_PLASTEEL
	icon_has_variants = TRUE

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MATERIAL_WOOD
	drop_sound = 'sound/items/drop/wooden.ogg'

/obj/item/stack/material/woodlog
	name = "log"
	icon_state = "sheet-wood"
	default_type = MATERIAL_WOOD_LOG

/obj/item/stack/material/woodbranch
	name = "branch"
	icon_state = "sheet-wood"
	default_type = MATERIAL_WOOD_BRANCH


/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	default_type = MATERIAL_CLOTH
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/stack/material/cloth/attackby(obj/item/I, mob/user)
	if(is_sharp(I))
		user.visible_message("<span class='notice'>\The [user] begins cutting up [src] with [I].</span>", "<span class='notice'>You begin cutting up [src] with [I].</span>")
		if(do_after(user, 20)) // takes less time than bedsheets, a second per rag produced on average
			to_chat(user, "<span class='notice'>You cut [src] into pieces!</span>")
			for(var/i in 1 to rand(1,3)) // average of 2 per
				new /obj/item/reagent_containers/glass/rag(get_turf(src))
			use(1)
		return
	..()

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	default_type = MATERIAL_CARDBOARD
	drop_sound = 'sound/items/drop/box.ogg'

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	default_type = MATERIAL_LEATHER
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/leather.ogg'

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	default_type = MATERIAL_GLASS
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/glass.ogg'

/obj/item/stack/material/glass/wired
	name = "wired glass"
	icon = 'icons/obj/stacks/tiles.dmi'
	icon_state = MATERIAL_GLASS_WIRED
	default_type = "wired glass"

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	item_state = "sheet-rglass"
	default_type = MATERIAL_GLASS_REINFORCED

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-phoronglass"
	item_state = "sheet-pglass"
	default_type = MATERIAL_GLASS_PHORON

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-phoronrglass"
	item_state = "sheet-prglass"
	default_type = MATERIAL_GLASS_REINFORCED_PHORON
/obj/item/stack/material/bronze
	name = "bronze"
	icon_state = "sheet-brass"
	default_type = "bronze"
	icon_has_variants = TRUE

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet-titanium"
	default_type = MATERIAL_TITANIUM
	icon_has_variants = TRUE
