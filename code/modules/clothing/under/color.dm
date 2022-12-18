/obj/item/clothing/under/color
	name = "grey jumpsuit"
	desc = "A basic jumpsuit."
	desc_info = "Jumpsuits can have their sleeves rolled up/down via the Roll Up/Down Sleeves verb, and also have their upper body part be up/down via the \
	the Rolled Up/Down verb."
	icon = 'icons/clothing/under/uniforms/jumpsuits.dmi'
	icon_state = "grey"
	item_state = "grey"
	item_icons = null
	contained_sprite = TRUE

	var/overlay_logo

/obj/item/clothing/under/color/get_mob_overlay(var/mob/living/carbon/human/human, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(overlay_logo && slot == slot_w_uniform_str)
		var/suffix = rolled_down ? "_d" : rolled_sleeves ? "_r" : ""
		var/image/overlay_logo_image = image(mob_icon, null, overlay_logo + suffix, human ? human.layer + 0.01 : MOB_LAYER + 0.01)
		overlay_logo_image.appearance_flags = RESET_COLOR
		I.add_overlay(overlay_logo_image)
	return I

/obj/item/clothing/under/color/colorable
	name = "colorable jumpsuit"
	desc = "A colorable non-descript jumpsuit."
	icon_state = "colorable"
	item_state = "colorable"

/obj/item/clothing/under/color/orange
	name = "orange jumpsuit"
	desc = "It's standardised prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "orange"
	item_state = "orange"
	has_sensor = 2
	sensor_mode = 3
	var/id

/obj/item/clothing/under/color/orange/cell1
	desc = "It's standardised SCC prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position.\nThis one has \"Cell 1\" marked on it."
	id = "Cell 1"

/obj/item/clothing/under/color/orange/cell2
	desc = "It's standardised SCC prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position.\nThis one has \"Cell 2\" marked on it."
	id = "Cell 2"

/obj/item/clothing/under/color/orange/cell3
	desc = "It's standardised SCC prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position.\nThis one has \"Cell 3\" marked on it."
	id = "Cell 3"

/obj/item/clothing/under/color/orange/cell4
	desc = "It's standardised SCC prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position.\nThis one has \"Cell 4\" marked on it."
	id = "Cell 4"

/obj/item/clothing/under/color/black
	name = "black jumpsuit"
	desc = "A black jumpsuit."
	icon_state = "black"
	item_state = "black"

/obj/item/clothing/under/color/grey
	name = "grey jumpsuit"
	desc = "A grey jumpsuit."
	icon_state = "grey"
	item_state = "grey"

/obj/item/clothing/under/color/white
	name = "white jumpsuit"
	desc = "A white jumpsuit."
	icon_state = "white"
	item_state = "white"

/obj/item/clothing/under/color/darkred
	name = "darkred jumpsuit"
	desc = "A dark red jumpsuit."
	icon_state = "darkred"
	item_state = "darkred"

/obj/item/clothing/under/color/red
	name = "red jumpsuit"
	desc = "A red jumpsuit."
	icon_state = "red"
	item_state = "red"

/obj/item/clothing/under/color/lightred
	name = "lightred jumpsuit"
	desc = "A light red jumpsuit."
	icon_state = "lightred"
	item_state = "lightred"

/obj/item/clothing/under/color/lightbrown
	name = "lightbrown jumpsuit"
	desc = "A light brown jumpsuit."
	icon_state = "lightbrown"
	item_state = "lightbrown"

/obj/item/clothing/under/color/brown
	name = "brown jumpsuit"
	desc = "A brown jumpsuit."
	icon_state = "brown"
	item_state = "brown"

/obj/item/clothing/under/color/yellow
	name = "yellow jumpsuit"
	desc = "A yellow jumpsuit."
	icon_state = "yellow"
	item_state = "yellow"

/obj/item/clothing/under/color/yellowgreen
	name = "yellowgreen jumpsuit"
	desc = "A yellow green jumpsuit."
	icon_state = "yellowgreen"
	item_state = "yellowgreen"

/obj/item/clothing/under/color/lightgreen
	name = "lightgreen jumpsuit"
	desc = "A light green jumpsuit."
	icon_state = "lightgreen"
	item_state = "lightgreen"

/obj/item/clothing/under/color/green
	name = "green jumpsuit"
	desc = "A green jumpsuit."
	icon_state = "green"
	item_state = "green"

/obj/item/clothing/under/color/aqua
	name = "aqua jumpsuit"
	desc = "An aqua jumpsuit."
	icon_state = "aqua"
	item_state = "aqua"

/obj/item/clothing/under/color/lightblue
	name = "lightblue jumpsuit"
	desc = "A light blue jumpsuit."
	icon_state = "lightblue"
	item_state = "lightblue"

/obj/item/clothing/under/color/blue
	name = "blue jumpsuit"
	desc = "A blue jumpsuit."
	icon_state = "blue"
	item_state = "blue"

/obj/item/clothing/under/color/darkblue
	name = "darkblue jumpsuit"
	desc = "A dark blue jumpsuit."
	icon_state = "darkblue"
	item_state = "darkblue"

/obj/item/clothing/under/color/purple
	name = "purple jumpsuit"
	desc = "A purple jumpsuit."
	icon_state = "purple"
	item_state = "purple"

/obj/item/clothing/under/color/lightpurple
	name = "lightpurple jumpsuit"
	desc = "A light purple jumpsuit."
	icon_state = "lightpurple"
	item_state = "lightpurple"

/obj/item/clothing/under/color/pink
	name = "pink jumpsuit"
	desc = "A pink jumpsuit."
	icon_state = "pink"
	item_state = "pink"

