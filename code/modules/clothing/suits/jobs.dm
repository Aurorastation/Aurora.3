/*
 * Job related
 */

//Botonist
/obj/item/clothing/suit/apron
	name = "botanist apron"
	desc = "A basic blue apron meant for botanists."
	icon_state = "blueapron"
	item_state = "blueapron"
	blood_overlay_type = "armor"
	body_parts_covered = 0
	allowed = list (/obj/item/reagent_containers/spray/plantbgone,/obj/item/device/analyzer/plant_analyzer,/obj/item/seeds,/obj/item/reagent_containers/glass/fertilizer,/obj/item/material/minihoe)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

obj/item/clothing/suit/apron/colored
	name = "multipurpose apron"
	desc = "A multipurpose apron that comes in many colors."
	icon_state = "apron"
	item_state = "apron"
	allowed = list (/obj/item/reagent_containers/food/drinks/shaker,/obj/item/material/kitchen/utensil, /obj/item/reagent_containers/food/condiment/, /obj/item/reagent_containers/food/drinks/bottle/)

/obj/item/clothing/suit/apron/overalls
	name = "coveralls"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	item_state = "overalls"

/obj/item/clothing/suit/apron/overalls/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

obj/item/clothing/suit/apron/overalls/blue
	color = "#3429d1"

/obj/item/clothing/suit/apron/surgery
	name = "surgical apron"
	desc = "To keep their blood off while you knife them."
	icon_state = "surgeon"
	item_state = "surgeon"
	allowed = list(/obj/item/stack/medical, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/syringe, \
	/obj/item/device/healthanalyzer, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/tank/emergency_oxygen, /obj/item/device/breath_analyzer, /obj/item/reagent_containers/blood)

//Captain
/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon_state = "captunic"
	item_state = "captunic"
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon_state = "capjacket"
	item_state = "capjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = 0

//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "This suit says to you 'hush'!"
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/bible,/obj/item/nullrod,/obj/item/reagent_containers/food/drinks/bottle/holywater)

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	item_state = "nun"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/bible,/obj/item/nullrod,/obj/item/reagent_containers/food/drinks/bottle/holywater)

//Chef
/obj/item/clothing/suit/chef
	name = "chef's apron"
	desc = "An apron used by a high class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (/obj/item/material/knife)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "classic chef's apron"
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = 0

//Security
/obj/item/clothing/suit/security/navyofficer
	name = "security officer's jacket"
	desc = "This jacket is for those special occasions when a security officer actually feels safe."
	icon_state = "officerbluejacket"
	item_state = "officerbluejacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/security/navywarden
	name = "warden's jacket"
	desc = "Perfectly suited for the warden that wants to leave an impression of style on those who visit the brig."
	icon_state = "wardenbluejacket"
	item_state = "wardenbluejacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/security/navyhos
	name = "head of security's jacket"
	desc = "This piece of clothing was specifically designed for asserting superior authority."
	icon_state = "hosbluejacket"
	item_state = "hosbluejacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//Detective

/obj/item/clothing/suit/storage/det_jacket
	name = "detective's jacket"
	desc = "Stylish yet comfortable professional jacket manufactured by CL corporation for NT detectives. Unique fiber structure will offer moderate protection from various hazards investigators may encounter in the line of duty."
	icon_state = "det_jacket"
	item_state = "det_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/box/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/device/taperecorder)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/toggle/det_trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon_state = "detective"
	item_state = "detective"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/box/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/device/taperecorder)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/toggle/det_trench/black
	name = "black trenchcoat"
	icon_state = "detective2"

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	item_state = "det_suit"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/taperecorder)
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."
	icon_state = "forensics_red"

/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon_state = "forensics_blue"

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	allowed = list (/obj/item/device/analyzer, /obj/item/device/flashlight, /obj/item/device/multitool, /obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner, \
	/obj/item/crowbar, /obj/item/screwdriver, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/wrench, /obj/item/tank/emergency_oxygen, \
	/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering)
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

//Lawyer
/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	name = "blue suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_blue"
	item_state = "suitjacket_blue"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	opened = TRUE

/obj/item/clothing/suit/storage/lawyer/purpjacket
	name = "purple suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS

//Internal Affairs
/obj/item/clothing/suit/storage/toggle/liaison
	name = "liaison jacket"
	desc = "A smooth black jacket."
	icon_state = "ia_jacket"
	item_state = "ia_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	opened = TRUE

//Resprited from IAA jacket
/obj/item/clothing/suit/storage/toggle/suitjacket
	name = "suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket"
	item_state = "suitjacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	opened = TRUE

/obj/item/clothing/suit/storage/toggle/suitjacket/blazer
	name = "blazer"
	desc = "A charming jacket."
	desc_fluff = "for when you want to play ball sports like an aristocrat."
	icon_state = "blazer"
	item_state = "blazer"
	opened = TRUE

//Medical
/obj/item/clothing/suit/storage/toggle/fr_jacket
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon_state = "fr_jacket"
	item_state = "fr_jacket"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/stack/medical, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/syringe, \
	/obj/item/device/healthanalyzer, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/tank/emergency_oxygen, /obj/item/device/breath_analyzer, /obj/item/reagent_containers/blood)
	body_parts_covered = UPPER_TORSO|ARMS
	opened = TRUE

/obj/item/clothing/suit/storage/toggle/fr_jacket/ems
	name = "\improper EMS jacket"
	desc = "A dark blue, martian-pattern, EMS jacket. It sports high-visibility reflective stripes and a star of life on the back."
	icon_state = "ems_jacket"
	item_state = "ems_jacket"

/obj/item/clothing/suit/storage/medical_chest_rig
	name = "medic chest-rig"
	desc = "A white chest-rig with pouches worn by medical first responders, meant to carry their equipment."
	icon_state = "paramed_armor"
	item_state = "paramed_armor"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/stack/medical, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/syringe, \
	/obj/item/device/healthanalyzer, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/tank/emergency_oxygen, /obj/item/device/breath_analyzer, /obj/item/reagent_containers/blood)
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/medical_chest_rig/emt
	name = "first responder vest"
	desc = "A dark green vest adorned with high-visibility stripes. Has pouches to carry equipment with."
	icon = 'icons/clothing/kit/emt.dmi'
	contained_sprite = TRUE
	icon_state = "emtvest"
	item_state = "emtvest"

//Mime
/obj/item/clothing/suit/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here
	body_parts_covered = 0

/obj/item/clothing/suit/storage/toggle/emt_jacket
	name = "first responder jacket"
	desc = "A dark green first responder jacket."
	icon = 'icons/clothing/kit/emt.dmi'
	contained_sprite = TRUE
	icon_state = "emtjacket"
	item_state = "emtjacket"
