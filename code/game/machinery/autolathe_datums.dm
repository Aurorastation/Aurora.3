/var/global/list/autolathe_recipes
/var/global/list/autolathe_categories

/proc/populate_lathe_recipes()

	//Create global autolathe recipe list if it hasn't been made already.
	autolathe_recipes = list()
	autolathe_categories = list()
	for(var/R in subtypesof(/datum/autolathe/recipe))
		var/datum/autolathe/recipe/recipe = new R
		autolathe_recipes += recipe
		autolathe_categories |= recipe.category

		var/obj/item/I = new recipe.path
		// Since this runs before SSatoms runs, we've got to force initialization manually.
		if (!I.initialized)
			SSatoms.InitAtom(I, list(TRUE))

		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material]*1.25 // More expensive to produce than they are to recycle.
		qdel(I)

/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden
	var/category
	var/power_use = 0
	var/is_stack

/datum/autolathe/recipe/bucket
	name = "bucket"
	path = /obj/item/reagent_containers/glass/bucket
	category = "General"

/datum/autolathe/recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight
	category = "General"

/datum/autolathe/recipe/floor_light
	name = "floor light"
	path = /obj/machinery/floor_light
	category = "General"

/datum/autolathe/recipe/tile_circuit_blue
	name = "circuit tile, blue"
	path = /obj/item/stack/tile/circuit_blue
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/tile_circuit_green
	name = "circuit tile, green"
	path = /obj/item/stack/tile/circuit_green
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/extinguisher
	category = "General"

/datum/autolathe/recipe/jar
	name = "jar"
	path = /obj/item/glass_jar
	category = "General"

/datum/autolathe/recipe/bowl
	name = "bowl"
	path = /obj/item/reagent_containers/glass/beaker/bowl
	category = "General"

/datum/autolathe/recipe/crowbar
	name = "crowbar"
	path = /obj/item/crowbar
	category = "Tools"

/datum/autolathe/recipe/multitool
	name = "multitool"
	path = /obj/item/device/multitool
	category = "Tools"

/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner
	category = "Tools"

/datum/autolathe/recipe/weldertool
	name = "welding tool"
	path = /obj/item/weldingtool
	category = "Tools"

/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/screwdriver
	category = "Tools"

/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/wirecutters
	category = "Tools"

/datum/autolathe/recipe/wrench
	name = "wrench"
	path = /obj/item/wrench
	category = "Tools"

/datum/autolathe/recipe/hatchet
	name = "hatchet"
	path = /obj/item/material/hatchet
	category = "Tools"

/datum/autolathe/recipe/minihoe
	name = "mini hoe"
	path = /obj/item/material/minihoe
	category = "Tools"

/datum/autolathe/recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset
	category = "General"

/datum/autolathe/recipe/radio_bounced
	name = "station bounced radio"
	path = /obj/item/device/radio/off
	category = "General"

/datum/autolathe/recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding
	category = "General"

/datum/autolathe/recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/material/steel
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/material/glass
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/material/glass/reinforced
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rods
	name = "metal rods"
	path = /obj/item/stack/rods
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/knife
	name = "kitchen knife"
	path = /obj/item/material/knife
	category = "General"

/datum/autolathe/recipe/drinking_glass
	name = "drinking glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass
	category = "General"

/datum/autolathe/recipe/bottle
	name = "bottle"
	path = /obj/item/reagent_containers/food/drinks/bottle
	category = "General"

/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder
	category = "General"

/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/airlock_electronics
	category = "Engineering"

/datum/autolathe/recipe/airalarm
	name = "air alarm electronics"
	path = /obj/item/airalarm_electronics
	category = "Engineering"

/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/firealarm_electronics
	category = "Engineering"

/datum/autolathe/recipe/powermodule
	name = "power control module"
	path = /obj/item/module/power_control
	category = "Engineering"

/datum/autolathe/recipe/stockparts_box
	name = "stock parts box"
	path = /obj/item/storage/bag/stockparts_box
	category = "Engineering"

/datum/autolathe/recipe/rfd_ammo
	name = "compressed matter cartridge"
	path = /obj/item/rfd_ammo
	category = "Engineering"

/datum/autolathe/recipe/scalpel
	name = "scalpel"
	path = /obj/item/surgery/scalpel
	category = "Medical"

/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	path = /obj/item/surgery/circular_saw
	category = "Medical"

/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/surgery/surgicaldrill
	category = "Medical"

/datum/autolathe/recipe/retractor
	name = "retractor"
	path = /obj/item/surgery/retractor
	category = "Medical"

/datum/autolathe/recipe/cautery
	name = "cautery"
	path = /obj/item/surgery/cautery
	category = "Medical"

/datum/autolathe/recipe/hemostat
	name = "hemostat"
	path = /obj/item/surgery/hemostat
	category = "Medical"

/datum/autolathe/recipe/beaker
	name = "glass beaker"
	path = /obj/item/reagent_containers/glass/beaker
	category = "Medical"

/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/reagent_containers/glass/beaker/large
	category = "Medical"

/datum/autolathe/recipe/vial
	name = "glass vial"
	path = /obj/item/reagent_containers/glass/beaker/vial
	category = "Medical"

/datum/autolathe/recipe/autoinjector
	name = "autoinjector"
	path = /obj/item/reagent_containers/hypospray/autoinjector
	category = "Medical"

/datum/autolathe/recipe/autoinhaler
	name = "autoinhaler"
	path = /obj/item/reagent_containers/inhaler
	category = "Medical"

/datum/autolathe/recipe/syringe
	name = "syringe"
	path = /obj/item/reagent_containers/syringe
	category = "Medical"

/datum/autolathe/recipe/syringegun_ammo
	name = "syringe gun cartridge"
	path = /obj/item/syringe_cartridge
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_blanks
	name = "ammunition (shotgun, blank)"
	path = /obj/item/ammo_casing/shotgun/blank
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_beanbag
	name = "ammunition (shotgun, beanbag)"
	path = /obj/item/ammo_casing/shotgun/beanbag
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_flash
	name = "ammunition (shotgun, flash)"
	path = /obj/item/ammo_casing/shotgun/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_rubber
	name = "ammunition (.45, rubber)"
	path = /obj/item/ammo_magazine/c45m/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_flash
	name = "ammunition (.45, flash)"
	path = /obj/item/ammo_magazine/c45m/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_smg_rubber
	name = "ammunition (9mm rubber top mounted)"
	path = /obj/item/ammo_magazine/mc9mmt/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/detective_revolver_rubber
	name = "ammunition (.38, rubber)"
	path = /obj/item/ammo_magazine/c38/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/consolescreen
	name = "console screen"
	path = /obj/item/stock_parts/console_screen
	category = "Devices and Components"

/datum/autolathe/recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter
	category = "Devices and Components"

/datum/autolathe/recipe/signaler
	name = "signaler"
	path = /obj/item/device/assembly/signaler
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra
	category = "Devices and Components"

/datum/autolathe/recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor
	category = "Devices and Components"

/datum/autolathe/recipe/tube
	name = "light tube"
	path = /obj/item/light/tube
	category = "General"

/datum/autolathe/recipe/bulb
	name = "light bulb"
	path = /obj/item/light/bulb
	category = "General"

/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/material/ashtray/glass
	category = "General"

/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/camera_assembly
	category = "Engineering"

/datum/autolathe/recipe/suit_cooling
	name = "portable suit cooling unit"
	path = /obj/item/device/suit_cooling_unit/no_cell
	category = "Engineering"

/datum/autolathe/recipe/emergency_cell
	name = "miniature cell"
	path = /obj/item/cell/device/emergency_light/empty
	category = "Engineering"

/datum/autolathe/recipe/cable_coil
	name = "cable coil"
	path = /obj/item/stack/cable_coil
	category = "Devices and Components"
	is_stack = 1

/datum/autolathe/recipe/labeler
	name = "hand labeler"
	path = /obj/item/hand_labeler
	category = "General"

/datum/autolathe/recipe/destTagger
	name = "destination tagger"
	path = /obj/item/device/destTagger
	category = "General"

/datum/autolathe/recipe/debugger
	name = "debugger"
	path = /obj/item/device/debugger
	category = "Engineering"

// Basic Stock Parts for Engineering
/datum/autolathe/recipe/micromanip
	name = "micro-manipulator"
	path = /obj/item/stock_parts/manipulator
	category = "Devices and Components"

/datum/autolathe/recipe/matterbin
	name = "matter bin"
	path = /obj/item/stock_parts/matter_bin
	category = "Devices and Components"

/datum/autolathe/recipe/capacitor
	name = "capacitor"
	path = /obj/item/stock_parts/capacitor
	category = "Devices and Components"

/datum/autolathe/recipe/scanningmod
	name = "scanning module"
	path = /obj/item/stock_parts/scanning_module
	category = "Devices and Components"

/datum/autolathe/recipe/microlaser
	name = "micro-laser"
	path = /obj/item/stock_parts/micro_laser
	category = "Devices and Components"

/datum/autolathe/recipe/flamethrower
	name = "flamethrower"
	path = /obj/item/flamethrower/full
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_revolver_1
	name = "ammunition (.357)"
	path = /obj/item/ammo_magazine/a357
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_revolver_2
	name = "ammunition (.45)"
	path = /obj/item/ammo_magazine/c45m
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_stetchkin
	name = "ammunition (9mm)"
	path = /obj/item/ammo_magazine/mc9mm
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_stetchkin_flash
	name = "ammunition (9mm, flash)"
	path = /obj/item/ammo_magazine/mc9mm/flash
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_c20r
	name = "ammunition (10mm)"
	path = /obj/item/ammo_magazine/a10mm
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_arifle
	name = "ammunition (7.62mm)"
	path = /obj/item/ammo_magazine/c762
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_smg
	name = "ammunition (9mm top mounted)"
	path = /obj/item/ammo_magazine/mc9mmt
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_carbine
	name = "ammunition (5.56mm)"
	path = /obj/item/ammo_magazine/a556
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun
	name = "ammunition (slug, shotgun)"
	path = /obj/item/ammo_casing/shotgun
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_pellet
	name = "ammunition (shell, shotgun)"
	path = /obj/item/ammo_casing/shotgun/pellet
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/tacknife
	name = "tactical knife"
	path = /obj/item/material/knife/tacknife
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/stunshell
	name = "ammunition (stun cartridge, shotgun)"
	path = /obj/item/ammo_casing/shotgun/stunshell
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/clip_boltaction
	name = "ammunition clip (7.62mm)"
	path = /obj/item/ammo_magazine/boltaction
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/detective_revolver_lethal
	name = "ammunition (.38)"
	path = /obj/item/ammo_magazine/c38
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/submachine_mag
	name = "submachinegun magazine (.45)"
	path = /obj/item/ammo_magazine/submachinemag
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/uzi_mag
	name = "stick magazine (.45)"
	path = /obj/item/ammo_magazine/c45uzi
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/rfd_construction
	name = "rapid-fabrication-device c-class"
	path = /obj/item/rfd/construction
	hidden = 1
	category = "Engineering"

/datum/autolathe/recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/trap
	name = "mechanical trap"
	path = /obj/item/trap
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/welder_industrial
	name = "industrial welding tool"
	path = /obj/item/weldingtool/largetank
	hidden = 1
	category = "Tools"

/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/handcuffs
	hidden = 1
	category = "General"