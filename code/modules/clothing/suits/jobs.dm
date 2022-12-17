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
	no_overheat = TRUE
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

/obj/item/clothing/suit/apron/surgery/zeng
	name = "zeng-hu vinyl apron"
	desc = "A key design element in the labwear was utility and compatibility with the Zeng-Hu positronic chassis workers that are ubiquitous throughout the corporation. As a result \
	they are breathable yet non-porous, allowing for ample airflow while retaining the cleanroom standards expected of a medical and scientific uniform."
	icon_state = "zeng_apron"
	item_state = "zeng_apron"

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

/obj/item/clothing/suit/chef/nt
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_chef_jacket"
	item_state = "nt_chef_jacket"

/obj/item/clothing/suit/chef/idris
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "idris_chef_jacket"
	item_state = "idris_chef_jacket"

//Chef
/obj/item/clothing/suit/chef/classic
	name = "classic chef's apron"
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = 0
	no_overheat = TRUE

//Security
/obj/item/clothing/suit/storage/security
	name = "security jacket parent item"
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	contained_sprite = TRUE
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS

/obj/item/clothing/suit/storage/security/hos
	name = "head of security jacket"
	desc = "This piece of clothing was specifically designed for asserting superior authority."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "hos_jacket"
	item_state = "hos_jacket"

/obj/item/clothing/suit/storage/security/officer
	name = "corporate security jacket"
	desc = "This jacket is for those special occasions when corporate security actually feels safe."

/obj/item/clothing/suit/storage/security/officer/zav
	icon_state = "zav_jacket"
	item_state = "zav_jacket"

/obj/item/clothing/suit/storage/security/officer/zav/alt
	icon_state = "zav_jacket_alt"
	item_state = "zav_jacket_alt"

/obj/item/clothing/suit/storage/security/officer/idris
	icon_state = "idris_jacket"
	item_state = "idris_jacket"

/obj/item/clothing/suit/storage/security/officer/idris/alt
	icon_state = "idris_jacket_alt"
	item_state = "idris_jacket_alt"

/obj/item/clothing/suit/storage/security/officer/pmc
	icon_state = "pmc_jacket"
	item_state = "pmc_jacket"

/obj/item/clothing/suit/storage/security/officer/pmc/alt
	icon_state = "pmc_jacket_alt"
	item_state = "pmc_jacket_alt"

/obj/item/clothing/suit/storage/security/investigator
	name = "investigator jacket"
	desc = "An investigator jacket. Stylish, professional, yet comfortable."
	icon_state = "nt_invest_coat"
	item_state = "nt_invest_coat"
	allowed = list(
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/gun/energy,
		/obj/item/gun/projectile,
		/obj/item/melee/baton,
		/obj/item/device/taperecorder,
		/obj/item/clothing/accessory/badge/investigator
	)

/obj/item/clothing/suit/storage/security/investigator/zavod
	icon_state = "zav_invest_coat"
	item_state = "zav_invest_coat"

/obj/item/clothing/suit/storage/security/investigator/pmc
	icon_state = "pmc_invest_coat"
	item_state = "pmc_invest_coat"

/obj/item/clothing/suit/storage/security/investigator/idris
	icon_state = "idris_invest_coat"
	item_state = "idris_invest_coat"

/obj/item/clothing/suit/storage/toggle/warden
	name = "warden coat"
	desc = "A thick, rugged overcoat, with corporate livery emblazoned on it."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "nt_warden_coat"
	item_state = "nt_warden_coat"
	opened = TRUE
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/warden/zavod
	icon_state = "zav_warden_coat"
	item_state = "zav_warden_coat"
	
/obj/item/clothing/suit/storage/toggle/warden/zavod/alt
	icon_state = "zav_warden_coat_alt"
	item_state = "zav_warden_coat_alt"

/obj/item/clothing/suit/storage/toggle/warden/pmc
	icon_state = "pmc_warden_coat"
	item_state = "pmc_warden_coat"

/obj/item/clothing/suit/storage/toggle/warden/idris
	icon_state = "idris_warden_coat"
	item_state = "idris_warden_coat"

/obj/item/clothing/suit/storage/toggle/det_trench // Not security anymore, but used in the loadout.
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. Perfect for your next act of autodefenestration!"
	icon_state = "detective"
	item_state = "detective"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/device/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/box/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/device/taperecorder,/obj/item/clothing/accessory/badge/investigator)

/obj/item/clothing/suit/storage/toggle/det_trench/black
	name = "black trenchcoat"
	icon_state = "detective2"

//Lawyer

/obj/item/clothing/suit/storage/lawyer/purpjacket
	name = "purple suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS

//Internal Affairs
/obj/item/clothing/suit/storage/liaison
	name = "liaison vest"
	desc = "A smooth suit vest. Freshly drycleaned, ready for a day of firm handshakes and dynamic synergy paradigm shifts."
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	icon_state = "nt_liaison_vest"
	item_state = "nt_liaison_vest"
	blood_overlay_type = "coat"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/liaison/zeng
	icon_state = "zeng_liaison_vest"
	item_state = "zeng_liaison_vest"

/obj/item/clothing/suit/storage/liaison/zavod
	icon_state = "zav_liaison_vest"
	item_state = "zav_liaison_vest"

/obj/item/clothing/suit/storage/liaison/heph
	icon_state = "heph_liaison_vest"
	item_state = "heph_liaison_vest"

/obj/item/clothing/suit/storage/liaison/pmc
	icon_state = "pmc_liaison_vest"
	item_state = "pmc_liaison_vest"

/obj/item/clothing/suit/storage/liaison/idris
	icon_state = "idris_liaison_vest"
	item_state = "idris_liaison_vest"

/obj/item/clothing/suit/storage/liaison/orion
	icon_state = "orion_liaison_vest"
	item_state = "orion_liaison_vest"


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
	desc_extended = "for when you want to play ball sports like an aristocrat."
	icon_state = "blazer"
	item_state = "blazer"
	opened = TRUE

/obj/item/clothing/suit/storage/toggle/suitjacket/blazer/long
	name = "long blazer"
	desc = "A charming long jacket."
	desc_extended = "For when you want to play ball sports like an aristocrat."
	icon_state = "longblazer"
	item_state = "longblazer"
	opened = TRUE

//Medical
/obj/item/clothing/suit/storage/toggle/fr_jacket
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon = 'icons/obj/item/clothing/department_uniforms/medical.dmi'
	contained_sprite = TRUE
	icon_state = "nt_emt_jacket"
	item_state = "nt_emt_jacket"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/stack/medical, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/syringe, \
	/obj/item/device/healthanalyzer, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/tank/emergency_oxygen, /obj/item/device/breath_analyzer, /obj/item/reagent_containers/blood, /obj/item/clothing/head/hardhat/first_responder)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/fr_jacket/zeng
	desc = "A first responder jacket in the classic white and purple of Zeng-Hu Pharmaceuticals."
	icon_state = "zeng_emt_jacket"
	item_state = "zeng_emt_jacket"

/obj/item/clothing/suit/storage/toggle/fr_jacket/pmc
	desc = "A first responder jacket in the classic black and blue of the PMCG."
	icon_state = "pmc_emt_jacket"
	item_state = "pmc_emt_jacket"

/obj/item/clothing/suit/storage/toggle/fr_jacket/pmc/alt
	icon_state = "pmc_alt_emt_jacket"
	item_state = "pmc_alt_emt_jacket"


/obj/item/clothing/suit/storage/medical_chest_rig
	name = "medic chest-rig"
	desc = "A white chest-rig with pouches worn by medical first responders, meant to carry their equipment."
	icon_state = "paramed_armor"
	item_state = "paramed_armor"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/stack/medical, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/syringe, \
	/obj/item/device/healthanalyzer, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/tank/emergency_oxygen, /obj/item/device/breath_analyzer, /obj/item/reagent_containers/blood, /obj/item/clothing/head/hardhat/first_responder)
	body_parts_covered = UPPER_TORSO

//Mime
/obj/item/clothing/suit/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here
	body_parts_covered = 0

// Bartender
/obj/item/clothing/suit/storage/bartender
	name = "bartender jacket"
	desc = "A fancy jacket worn by corporate bartenders."
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	icon_state = "nt_bartender_jacket"
	item_state = "nt_bartender_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/bartender/idris
	icon_state = "idris_bartender_jacket"
	item_state = "idris_bartender_jacket"

// Machinist

/obj/item/clothing/suit/storage/machinist
	name = "machinist jacket"
	desc = "Functional, rugged durability. The perfect workwear for tinkering with muscle cars, robots and giant mechas."
	icon = 'icons/obj/item/clothing/department_uniforms/operations.dmi'
	icon_state = "machinist_jacket"
	item_state = "machinist_jacket"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
