/obj/item/mold
	name = "spoon mold"
	desc = "A mold used in blacksmithing."
	icon = 'icons/adhomai/blacksmith.dmi'
	icon_state = "mold"
	w_class = 2
	var/material/filling
	var/outcome = /obj/item/weapon/material/kitchen/utensil/spoon
	var/needed_ammount = 1
	var/list/allowed_materials = list("iron", DEFAULT_WALL_MATERIAL, "bronze", "silver", "gold", "plasteel", "titanium", "platinum", "meteoric iron")
	var/use_material = TRUE

/obj/item/mold/update_icon()
	overlays.Cut()
	if(filling)
		add_overlay("[icon_state]_filling")

/obj/item/mold/proc/create_result(var/turf/T)
	if(use_material)
		new outcome(T, filling.name)
	else
		new outcome(T)

/obj/item/mold/fork
	name = "fork mold"
	outcome = /obj/item/weapon/material/kitchen/utensil/fork

/obj/item/mold/knife
	name = "knife mold"
	outcome = /obj/item/weapon/material/kitchen/utensil/knife

/obj/item/mold/shovel
	name = "shovel mold"
	icon_state = "mold_shovel"
	allowed_materials = list("iron", DEFAULT_WALL_MATERIAL, "plasteel")
	use_material = FALSE
	outcome = /obj/item/weapon/material/kitchen/utensil/spoon
	needed_ammount = 3

/obj/item/mold/shield
	name = "shield fittings mold"
	icon_state = "mold_shield"
	allowed_materials = list("iron", DEFAULT_WALL_MATERIAL, "plasteel")
	outcome = /obj/item/weapon/material/shieldbits
	needed_ammount = 5

/obj/item/mold/pike
	name = "spearhead mold"
	icon_state = "mold_blade"
	outcome = /obj/item/weapon/material/spearhead
	needed_ammount = 5

/obj/item/mold/butterflyblade
	name = "knife blade mold"
	outcome = /obj/item/weapon/material/butterflyblade
	needed_ammount = 3

/obj/item/mold/butterflyhandle
	name = "knife grip mold"
	outcome = /obj/item/weapon/material/butterflyhandle
	needed_ammount = 4

/obj/item/mold/pickaxe
	name = "pickaxe head mold"
	outcome = /obj/item/weapon/material/blacksmith_piece/pickaxe
	needed_ammount = 6
	allowed_materials = list("iron", DEFAULT_WALL_MATERIAL, "silver", "gold", "plasteel")

/obj/item/mold/axehead
	name = "axe head mold"
	outcome = /obj/item/weapon/material/blacksmith_piece/axe
	needed_ammount = 6

/obj/item/mold/ring
	name = "ring mold"
	icon_state = "mold_shield"
	outcome = /obj/item/clothing/ring/material
	needed_ammount = 2

/obj/item/mold/key
	name = "key mold"
	icon_state = "mold_key"
	outcome = /obj/item/weapon/key
	needed_ammount = 1

/obj/item/mold/lock
	name = "lock mold"
	icon_state = "mold_key"
	outcome = /obj/item/weapon/material/lock_construct
	needed_ammount = 1

/obj/item/mold/armor
	name = "armor plate mold"
	outcome = /obj/item/weapon/material/armor_plating
	needed_ammount = 3

/obj/item/mold/bat
	name = "bat mold"
	outcome = /obj/item/weapon/material/twohanded/baseballbat
	needed_ammount = 10

/obj/item/mold/halberd
	name = "halberd mold"
	icon_state = "mold_shovel"
	outcome = /obj/item/weapon/material/blacksmith_piece/halberd
	needed_ammount = 15

/obj/item/mold/sword
	name = "sword mold"
	icon_state = "mold_blade"
	outcome = /obj/item/weapon/material/sword/amohdan_sword
	needed_ammount = 15