/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon = 'icons/mob/clothing/suit/hazardvest.dmi'
	icon_state = "hazard"
	item_state = "hazard"
	contained_sprite = TRUE
	blood_overlay_type = "armor"
	allowed = list (/obj/item/device/analyzer, /obj/item/device/flashlight, /obj/item/device/multitool, /obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner, \
	/obj/item/crowbar, /obj/item/screwdriver, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/wrench, /obj/item/tank/emergency_oxygen, \
	/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering, /obj/item/storage/bag/inflatable)
	body_parts_covered = UPPER_TORSO
	var/opened

/obj/item/clothing/suit/storage/hazardvest/verb/Toggle() //copied from storage toggle
	set name = "Toggle Hazard Vest"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	opened = !opened
	to_chat(usr, SPAN_NOTICE("You [opened ? "unzip" : "zip"] \the [src]."))
	playsound(src, 'sound/items/zip.ogg', EQUIP_SOUND_VOLUME, TRUE)
	icon_state = "[initial(icon_state)][opened ? "_open" : ""]"
	item_state = icon_state
	update_clothing_icon()

/obj/item/clothing/suit/storage/hazardvest/blue
	name = "blue hazard vest"
	desc = "A high-visibility vest used in work zones. This one is blue."
	icon_state = "hazard_b"
	item_state = "hazard_b"

/obj/item/clothing/suit/storage/hazardvest/blue/atmos
	name = "atmospheric hazard vest"
	desc = "A high-visibility vest used in work zones. This one is used by atmospheric technicians."

/obj/item/clothing/suit/storage/hazardvest/white
	name = "white hazard vest"
	desc = "A high-visibility vest used in work zones. This one is white."
	icon_state = "hazard_w"
	item_state = "hazard_w"

/obj/item/clothing/suit/storage/hazardvest/green
	name = "green hazard vest"
	desc = "A high-visibility vest used in work zones. This one is green."
	icon_state = "hazard_g"
	item_state = "hazard_g"

/obj/item/clothing/suit/storage/hazardvest/purple
	name = "purple hazard vest"
	desc = "A high-visibility vest used in work zones. This one is purple."
	icon_state = "hazard_p"
	item_state = "hazard_p"

/obj/item/clothing/suit/storage/hazardvest/nblue
	name = "navy blue hazard vest"
	desc = "A high-visibility vest used in work zones. This one is navy blue."
	icon_state = "hazard_nb"
	item_state = "hazard_nb"

/obj/item/clothing/suit/storage/hazardvest/red
	name = "red hazard vest"
	desc = "A high-visibility vest used in work zones. This one is red."
	icon_state = "hazard_r"
	item_state = "hazard_r"

/obj/item/clothing/suit/storage/hazardvest/teal
	name = "teal hazard vest"
	desc = "A high-visibility vest used in work zones. This one is teal."
	icon_state = "hazard_t"
	item_state = "hazard_t"

/obj/item/clothing/suit/storage/hazardvest/ce
	name = "chief engineer's hazard vest"
	desc = "A high-visibility vest used in work zones. This one is white with a gold stripe."
	icon_state = "hazard_ce"
	item_state = "hazard_ce"


// Misc

/obj/item/clothing/suit/storage/hazardvest/fsf
	name = "gunner's mate vest"
	desc = "A high-visibility vest worn by a gunner's mate in the Solarian Navy. This one is green.";
	icon_state = "hazard_fsf"
	item_state = "hazard_fsf"

/obj/item/clothing/suit/storage/hazardvest/iac
	desc = "It's a lightweight vest. Made of a dark, navy mesh with highly-reflective white material, designed to be worn by the Interstellar Aid Corps as a high-visibility vest, over any other clothing. The I.A.C. logo is prominently  displayed on the back of the vest, between the shoulders."
	name = "IAC hazard vest"
	icon_state = "hazard_iac"
	item_state = "hazard_iac"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)
