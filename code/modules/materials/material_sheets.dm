// Stacked resources. They use a material datum for a lot of inherited values.
/obj/item/stack/material
	force = 11
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 3
	max_amount = 50
	recyclable = TRUE // Pretty much all materials should be recyclable

	var/default_type = DEFAULT_WALL_MATERIAL
	var/material/material
	var/perunit
	var/apply_colour //temp pending icon rewrite
	var/painted_colour
	var/use_material_sound = TRUE

/obj/item/stack/material/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Use in your hand to bring up the crafting menu."
	. += "If you have enough sheets, click on something on the list to build it."

/obj/item/stack/material/Initialize(mapload, amount)
	. = ..()
	randpixel_xy()

	if(!default_type)
		default_type = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(default_type)
	if(!material)
		return INITIALIZE_HINT_QDEL

	recipes = material.get_recipes()
	stacktype = material.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()
	perunit = SHEET_MATERIAL_AMOUNT

	if(apply_colour)
		var/image/I = new(icon, icon_state)
		I.color = material.icon_colour
		AddOverlays(I)

	if(use_material_sound)	// SEE MATERIALS.DM
		drop_sound = material.drop_sound
		pickup_sound = material.pickup_sound

	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTABLE

	matter = material.get_matter()

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

/obj/item/stack/material/update_icon()
	. = ..()
	ClearOverlays()
	if(material)
		update_strings()
		if(apply_colour) // This is ass, but stops maptext from getting colored.
			var/image/I = new(icon, icon_state)
			if(!painted_colour)
				I.color = material.icon_colour
			else
				I.color = painted_colour
			AddOverlays(I)

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.name != M.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src)
		update_icon()
	if(M)
		M.update_icon()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(obj/item/attacking_item, mob/user)
	if(iscoil(attacking_item))
		material.build_wired_product(user, attacking_item, src)
		return
	else if(istype(attacking_item, /obj/item/stack/rods))
		material.build_rod_product(user, attacking_item, src)
		return
	return ..()

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-silver"
	default_type = MATERIAL_IRON
	apply_colour = TRUE
	icon_has_variants = TRUE

/obj/item/stack/material/iron/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/aluminium
	name = "aluminium"
	icon_state = "sheet-metal"
	default_type = MATERIAL_ALUMINIUM
	apply_colour = TRUE
	icon_has_variants = TRUE

/obj/item/stack/material/aluminium/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/lead
	name = "lead"
	icon_state = "sheet-silver"
	default_type = MATERIAL_LEAD
	apply_colour = TRUE
	icon_has_variants = TRUE

/obj/item/stack/material/lead/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	default_type = MATERIAL_SANDSTONE
	icon_has_variants = TRUE

/obj/item/stack/material/sandstone/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	default_type = MATERIAL_MARBLE
	icon_has_variants = TRUE

/obj/item/stack/material/marble/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	default_type = MATERIAL_DIAMOND
	icon_has_variants = TRUE

/obj/item/stack/material/diamond/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	default_type = MATERIAL_URANIUM
	icon_has_variants = TRUE

/obj/item/stack/material/uranium/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	default_type = MATERIAL_PHORON
	icon_has_variants = TRUE

/obj/item/stack/material/phoron/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	item_state = "sheet-plastic"
	default_type = MATERIAL_PLASTIC
	icon_has_variants = TRUE

/obj/item/stack/material/plastic/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	default_type = MATERIAL_GOLD
	icon_has_variants = TRUE

/obj/item/stack/material/gold/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-silver"
	default_type = MATERIAL_SILVER
	icon_has_variants = TRUE

/obj/item/stack/material/silver/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	default_type = MATERIAL_PLATINUM
	icon_has_variants = TRUE

/obj/item/stack/material/platinum/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-metalhydrogen"
	default_type = MATERIAL_HYDROGEN_METALLIC
	icon_has_variants = TRUE

/obj/item/stack/material/mhydrogen/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

//Fuel for the super portable generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	default_type = MATERIAL_TRITIUM
	apply_colour = TRUE
	icon_has_variants = TRUE

/obj/item/stack/material/tritium/ten/Initialize()
	. = ..()
	amount = 10
	update_icon()

/obj/item/stack/material/tritium/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	default_type = MATERIAL_OSMIUM
	apply_colour = TRUE
	icon_has_variants = TRUE

/obj/item/stack/material/osmium/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/steel
	name = DEFAULT_WALL_MATERIAL
	icon_state = "sheet-metal"
	default_type = DEFAULT_WALL_MATERIAL
	icon_has_variants = TRUE

/obj/item/stack/material/steel/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(is_sharp(attacking_item))
		if(amount < 5)
			to_chat(user, SPAN_WARNING("You need at least five sheets of steel to do this!"))
			return
		user.visible_message("<b>[user]</b> starts carving some steel wool out of \the [src].", SPAN_NOTICE("You start carving some steel wool out of \the [src]."))
		if(do_after(user, 10 SECONDS))
			if(amount < 5)
				return
			to_chat(user, SPAN_NOTICE("You carve some steel wool out of \the [src]."))
			var/obj/item/steelwool/SW = new /obj/item/steelwool(get_turf(src))
			user.put_in_hands(SW)
			use(5)

/obj/item/stack/material/steel/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	default_type = MATERIAL_PLASTEEL
	icon_has_variants = TRUE

/obj/item/stack/material/plasteel/Destroy()
	. = ..()
	GC_TEMPORARY_HARDDEL

/obj/item/stack/material/plasteel/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/shuttle
	name = "plastitanium"
	icon_state = "sheet-plastitanium"
	item_state = "sheet-metal"
	default_type = MATERIAL_SHUTTLE
	icon_has_variants = TRUE

/obj/item/stack/material/shuttle/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MATERIAL_WOOD
	icon_has_variants = TRUE

/obj/item/stack/material/wood/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/coloured
	icon_state = "sheet-woodcolour"

/obj/item/stack/material/wood/coloured/birch
	color = WOOD_COLOR_BIRCH

/obj/item/stack/material/wood/coloured/birch/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/coloured/mahogany
	color = WOOD_COLOR_RICH

/obj/item/stack/material/wood/coloured/mahogany/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/coloured/maple
	color = WOOD_COLOR_PALE

/obj/item/stack/material/wood/coloured/maple/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/coloured/bamboo
	icon_state = "sheet-bamboo"

/obj/item/stack/material/wood/coloured/bamboo/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/coloured/ebony
	color = WOOD_COLOR_BLACK

/obj/item/stack/material/wood/coloured/ebony/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/coloured/walnut
	color = WOOD_COLOR_CHOCOLATE

/obj/item/stack/material/wood/coloured/walnut/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/coloured/yew
	color = WOOD_COLOR_YELLOW

/obj/item/stack/material/wood/coloured/yew/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/log
	name = "log"
	icon_state = "sheet-log"
	default_type = MATERIAL_WOOD_LOG
	max_amount = 25
	icon_has_variants = TRUE
	var/chopping

/obj/item/stack/material/wood/log/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/wood/log/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.can_woodcut() && isturf(loc) && !chopping)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		chopping = TRUE
		visible_message(SPAN_NOTICE("\The [user] begins chopping \the [src] into planks."),
				SPAN_NOTICE("You begin chopping \the [src] into planks."))
		playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
		if(do_after(user, 70))
			if(amount && Adjacent(user))
				use(1)
				var/obj/item/stack/material/wood/W = new(get_turf(user))
				W.amount = rand(2,3)
		chopping = FALSE
		return
	else
		..()

/obj/item/stack/material/wood/branch
	name = "branch"
	icon_state = "sheet-branch"
	default_type = MATERIAL_WOOD_BRANCH
	max_amount = 25
	icon_has_variants = TRUE

/obj/item/stack/material/wood/branch/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()


/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	default_type = MATERIAL_CLOTH
	icon_has_variants = TRUE
	apply_colour = TRUE

/obj/item/stack/material/cloth/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/cloth/attackby(obj/item/attacking_item, mob/user)
	if(is_sharp(attacking_item))
		user.visible_message(SPAN_NOTICE("\The [user] begins cutting up [src] with [attacking_item]."),
							SPAN_NOTICE("You begin cutting up [src] with [attacking_item]."))
		if(attacking_item.use_tool(src, user, 20, volume = 50)) // takes less time than bedsheets, a second per rag produced on average
			to_chat(user, SPAN_NOTICE("You cut [src] into pieces!"))
			for(var/i in 1 to rand(1,3)) // average of 2 per
				new /obj/item/reagent_containers/glass/rag(get_turf(src))
			use(1)
		return
	..()

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	default_type = MATERIAL_CARDBOARD
	icon_has_variants = TRUE

/obj/item/stack/material/cardboard/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/leather
	name = "leather"
	desc = "Created by only the finest of biogenerators!"
	icon_state = "sheet-leather"
	default_type = MATERIAL_LEATHER
	icon_has_variants = TRUE

/obj/item/stack/material/leather/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/leather/fine
	name = "fine leather"
	desc = "Handcrafted by an artisan, this leather is a wonderful status symbol for the wealthy few... Despite it not being any tougher than its biogenerated counterpart."
	default_type = MATERIAL_LEATHER_FINE

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	default_type = MATERIAL_GLASS
	icon_has_variants = TRUE

/obj/item/stack/material/glass/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/glass/wired
	name = "wired glass"
	icon = 'icons/obj/item/stacks/tiles.dmi'
	icon_state = "glass_wire"
	default_type = MATERIAL_GLASS_WIRED

/obj/item/stack/material/glass/wired/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	item_state = "sheet-rglass"
	default_type = MATERIAL_GLASS_REINFORCED

/obj/item/stack/material/glass/reinforced/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-pglass"
	item_state = "sheet-pglass"
	default_type = MATERIAL_GLASS_PHORON

/obj/item/stack/material/glass/phoronglass/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-prglass"
	item_state = "sheet-prglass"
	default_type = MATERIAL_GLASS_REINFORCED_PHORON

/obj/item/stack/material/glass/phoronrglass/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/bronze
	name = "bronze"
	icon_state = "sheet-brass"
	default_type = "bronze"
	icon_has_variants = TRUE

/obj/item/stack/material/bronze/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet-titanium"
	default_type = MATERIAL_TITANIUM
	icon_has_variants = TRUE

/obj/item/stack/material/titanium/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/graphite
	name = "graphite"
	icon_state = "sheet-graphite"
	default_type = MATERIAL_GRAPHITE
	icon_has_variants = TRUE

/obj/item/stack/material/graphite/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "puck"
	default_type = MATERIAL_DEUTERIUM

/obj/item/stack/material/deuterium/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/material/supermatter
	name = "stable supermatter cluster"
	icon_state = "sheet-supermatter"
	max_amount = 5
	default_type = MATERIAL_SUPERMATTER
	color = COLOR_YELLOW
	icon_has_variants = TRUE

/obj/item/stack/material/supermatter/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()
