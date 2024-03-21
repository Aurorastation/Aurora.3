/singleton/autolathe_recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden
	var/category
	var/power_use = 0
	var/is_stack

/singleton/autolathe_recipe/bucket
	name = "bucket"
	path = /obj/item/reagent_containers/glass/bucket
	category = "General"

/singleton/autolathe_recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight/empty
	category = "General"

/singleton/autolathe_recipe/floor_light
	name = "floor light"
	path = /obj/machinery/floor_light
	category = "General"

/singleton/autolathe_recipe/tile_circuit_blue
	name = "circuit tile, blue"
	path = /obj/item/stack/tile/circuit_blue
	category = "General"
	is_stack = 1

/singleton/autolathe_recipe/tile_circuit_green
	name = "circuit tile, green"
	path = /obj/item/stack/tile/circuit_green
	category = "General"
	is_stack = 1

/singleton/autolathe_recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/extinguisher
	category = "General"

/singleton/autolathe_recipe/jar
	name = "jar"
	path = /obj/item/glass_jar
	category = "General"

/singleton/autolathe_recipe/bowl
	name = "bowl"
	path = /obj/item/reagent_containers/cooking_container/board/bowl
	category = "General"

/singleton/autolathe_recipe/crowbar
	name = "crowbar"
	path = /obj/item/crowbar
	category = "Tools"

/singleton/autolathe_recipe/multitool
	name = "multitool"
	path = /obj/item/device/multitool
	category = "Tools"

/singleton/autolathe_recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner
	category = "Tools"

/singleton/autolathe_recipe/weldertool
	name = "welding tool"
	path = /obj/item/weldingtool
	category = "Tools"

/singleton/autolathe_recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/screwdriver
	category = "Tools"

/singleton/autolathe_recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/wirecutters
	category = "Tools"

/singleton/autolathe_recipe/wrench
	name = "wrench"
	path = /obj/item/wrench
	category = "Tools"

/singleton/autolathe_recipe/hatchet
	name = "hatchet"
	path = /obj/item/material/hatchet
	category = "Tools"

/singleton/autolathe_recipe/minihoe
	name = "mini hoe"
	path = /obj/item/material/minihoe
	category = "Tools"

/singleton/autolathe_recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset
	category = "General"

/singleton/autolathe_recipe/radio_bounced
	name = "shortwave radio"
	path = /obj/item/device/radio/off
	category = "General"

/singleton/autolathe_recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding
	category = "General"

/singleton/autolathe_recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/material/steel
	category = "General"
	is_stack = 1

/singleton/autolathe_recipe/aluminium
	name = "aluminium sheets"
	path = /obj/item/stack/material/aluminium
	category = "General"
	is_stack = TRUE

/singleton/autolathe_recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/material/glass
	category = "General"
	is_stack = 1

/singleton/autolathe_recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/material/glass/reinforced
	category = "General"
	is_stack = 1

/singleton/autolathe_recipe/rods
	name = "metal rods"
	path = /obj/item/stack/rods
	category = "General"
	is_stack = 1

/singleton/autolathe_recipe/barbed_wire
	name = "barbed wire"
	path = /obj/item/stack/barbed_wire
	category = "General"
	is_stack = 1

/singleton/autolathe_recipe/knife
	name = "kitchen knife"
	path = /obj/item/material/knife
	category = "General"

/singleton/autolathe_recipe/drinking_glass
	name = "drinking glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass
	category = "General"

/singleton/autolathe_recipe/half_pint_glass
	name = "half pint glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/square
	category = "General"

/singleton/autolathe_recipe/rocks_glass
	name = "rocks glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/rocks
	category = "General"

/singleton/autolathe_recipe/sherry_glass
	name = "sherry glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shake
	category = "General"

/singleton/autolathe_recipe/cocktail_glass
	name = "cocktail glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cocktail
	category = "General"

/singleton/autolathe_recipe/shot_glass
	name = "shot glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shot
	category = "General"

/singleton/autolathe_recipe/pint_glass
	name = "pint glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/pint
	category = "General"

/singleton/autolathe_recipe/mug_glass
	name = "mug glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/mug
	category = "General"

/singleton/autolathe_recipe/flute_glass
	name = "flute glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/flute
	category = "General"

/singleton/autolathe_recipe/cognac_glass
	name = "cognac glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cognac
	category = "General"

/singleton/autolathe_recipe/goblet_glass
	name = "goblet glass"
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/goblet
	category = "General"

/singleton/autolathe_recipe/bottle
	name = "bottle"
	path = /obj/item/reagent_containers/food/drinks/bottle
	category = "General"

/singleton/autolathe_recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder
	category = "General"

/singleton/autolathe_recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/airlock_electronics
	category = "Engineering"

/singleton/autolathe_recipe/airalarm
	name = "air alarm electronics"
	path = /obj/item/airalarm_electronics
	category = "Engineering"

/singleton/autolathe_recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/firealarm_electronics
	category = "Engineering"

/singleton/autolathe_recipe/powermodule
	name = "power control module"
	path = /obj/item/module/power_control
	category = "Engineering"

/singleton/autolathe_recipe/stockparts_box
	name = "stock parts box"
	path = /obj/item/storage/bag/stockparts_box
	category = "Engineering"

/singleton/autolathe_recipe/scalpel
	name = "scalpel"
	path = /obj/item/surgery/scalpel
	category = "Medical"

/singleton/autolathe_recipe/circularsaw
	name = "circular saw"
	path = /obj/item/surgery/circular_saw
	category = "Medical"

/singleton/autolathe_recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/surgery/surgicaldrill
	category = "Medical"

/singleton/autolathe_recipe/retractor
	name = "retractor"
	path = /obj/item/surgery/retractor
	category = "Medical"

/singleton/autolathe_recipe/cautery
	name = "cautery"
	path = /obj/item/surgery/cautery
	category = "Medical"

/singleton/autolathe_recipe/hemostat
	name = "hemostat"
	path = /obj/item/surgery/hemostat
	category = "Medical"

/singleton/autolathe_recipe/beaker
	name = "glass beaker"
	path = /obj/item/reagent_containers/glass/beaker
	category = "Medical"

/singleton/autolathe_recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/reagent_containers/glass/beaker/large
	category = "Medical"

/singleton/autolathe_recipe/vial
	name = "glass vial"
	path = /obj/item/reagent_containers/glass/beaker/vial
	category = "Medical"

/singleton/autolathe_recipe/autoinjector
	name = "autoinjector"
	path = /obj/item/reagent_containers/hypospray/autoinjector
	category = "Medical"

/singleton/autolathe_recipe/autoinhaler
	name = "autoinhaler"
	path = /obj/item/reagent_containers/inhaler
	category = "Medical"

/singleton/autolathe_recipe/syringe
	name = "syringe"
	path = /obj/item/reagent_containers/syringe
	category = "Medical"

/singleton/autolathe_recipe/syringe/large
	name = "large syringe"
	path = /obj/item/reagent_containers/syringe/large

/singleton/autolathe_recipe/syringegun_ammo
	name = "syringe gun cartridge"
	path = /obj/item/syringe_cartridge
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/shotgun_blanks
	name = "ammunition (shotgun, blank)"
	path = /obj/item/ammo_casing/shotgun/blank
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/shotgun_beanbag
	name = "ammunition (shotgun, beanbag)"
	path = /obj/item/ammo_casing/shotgun/beanbag
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/shotgun_flash
	name = "ammunition (shotgun, flash)"
	path = /obj/item/ammo_casing/shotgun/flash
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_rubber
	name = "ammunition (.45, rubber)"
	path = /obj/item/ammo_magazine/c45m/rubber
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_flash
	name = "ammunition (.45, flash)"
	path = /obj/item/ammo_magazine/c45m/flash
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_smg_rubber
	name = "ammunition (9mm rubber top mounted)"
	path = /obj/item/ammo_magazine/mc9mmt/rubber
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/detective_revolver_rubber
	name = "ammunition (.38, rubber)"
	path = /obj/item/ammo_magazine/c38/rubber
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/consolescreen
	name = "console screen"
	path = /obj/item/stock_parts/console_screen
	category = "Devices and Components"

/singleton/autolathe_recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter
	category = "Devices and Components"

/singleton/autolathe_recipe/signaler
	name = "signaler"
	path = /obj/item/device/assembly/signaler
	category = "Devices and Components"

/singleton/autolathe_recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra
	category = "Devices and Components"

/singleton/autolathe_recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer
	category = "Devices and Components"

/singleton/autolathe_recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor
	category = "Devices and Components"

/singleton/autolathe_recipe/tube
	name = "light tube"
	path = /obj/item/light/tube
	category = "General"

/singleton/autolathe_recipe/bulb
	name = "light bulb"
	path = /obj/item/light/bulb
	category = "General"

/singleton/autolathe_recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/material/ashtray/glass
	category = "General"

/singleton/autolathe_recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/camera_assembly
	category = "Engineering"

/singleton/autolathe_recipe/suit_cooling
	name = "portable suit cooling unit"
	path = /obj/item/device/suit_cooling_unit/no_cell
	category = "Engineering"

/singleton/autolathe_recipe/emergency_cell
	name = "miniature cell"
	path = /obj/item/cell/device/emergency_light/empty
	category = "Engineering"

/singleton/autolathe_recipe/cable_coil
	name = "cable coil"
	path = /obj/item/stack/cable_coil
	category = "Devices and Components"
	is_stack = 1

/singleton/autolathe_recipe/labeler
	name = "hand labeler"
	path = /obj/item/device/hand_labeler
	category = "General"

/singleton/autolathe_recipe/destTagger
	name = "destination tagger"
	path = /obj/item/device/destTagger
	category = "General"

/singleton/autolathe_recipe/cratescanner
	name = "crate contents scanner"
	path = /obj/item/device/cratescanner
	category = "General"

/singleton/autolathe_recipe/debugger
	name = "debugger"
	path = /obj/item/device/debugger
	category = "Engineering"

// Basic Stock Parts for Engineering
/singleton/autolathe_recipe/micromanip
	name = "micro-manipulator"
	path = /obj/item/stock_parts/manipulator
	category = "Devices and Components"

/singleton/autolathe_recipe/matterbin
	name = "matter bin"
	path = /obj/item/stock_parts/matter_bin
	category = "Devices and Components"

/singleton/autolathe_recipe/capacitor
	name = "capacitor"
	path = /obj/item/stock_parts/capacitor
	category = "Devices and Components"

/singleton/autolathe_recipe/scanningmod
	name = "scanning module"
	path = /obj/item/stock_parts/scanning_module
	category = "Devices and Components"

/singleton/autolathe_recipe/microlaser
	name = "micro-laser"
	path = /obj/item/stock_parts/micro_laser
	category = "Devices and Components"

/singleton/autolathe_recipe/flamethrower
	name = "flamethrower"
	path = /obj/item/flamethrower/full
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_revolver_1
	name = "ammunition (.357)"
	path = /obj/item/ammo_magazine/a357
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_revolver_2
	name = "ammunition (.45)"
	path = /obj/item/ammo_magazine/c45m
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_stetchkin
	name = "ammunition (9mm)"
	path = /obj/item/ammo_magazine/mc9mm
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_stetchkin_flash
	name = "ammunition (9mm, flash)"
	path = /obj/item/ammo_magazine/mc9mm/flash
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_c20r
	name = "ammunition (10mm)"
	path = /obj/item/ammo_magazine/a10mm
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_arifle
	name = "ammunition (7.62mm)"
	path = /obj/item/ammo_magazine/c762
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_smg
	name = "ammunition (9mm top mounted)"
	path = /obj/item/ammo_magazine/mc9mmt
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_carbine
	name = "ammunition (5.56mm, large)"
	path = /obj/item/ammo_magazine/a556
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_carbinepolymer
	name = "ammunition (5.56mm, polymer)"
	path = /obj/item/ammo_magazine/a556/polymer
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_smallcarbine
	name = "ammunition (5.56mm, small)"
	path = /obj/item/ammo_magazine/a556/carbine
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/magazine_smallcarbinepolymer
	name = "ammunition (5.56mm, small polymer)"
	path = /obj/item/ammo_magazine/a556/carbine/polymer
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/shotgun
	name = "ammunition (slug, shotgun)"
	path = /obj/item/ammo_casing/shotgun
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/shotgun_pellet
	name = "ammunition (shell, shotgun)"
	path = /obj/item/ammo_casing/shotgun/pellet
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/tacknife
	name = "tactical knife"
	path = /obj/item/material/knife/tacknife
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/stunshell
	name = "ammunition (stun cartridge, shotgun)"
	path = /obj/item/ammo_casing/shotgun/stunshell
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/clip_boltaction
	name = "ammunition clip (7.62mm)"
	path = /obj/item/ammo_magazine/boltaction
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/detective_revolver_lethal
	name = "ammunition (.38)"
	path = /obj/item/ammo_magazine/c38
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/submachine_mag
	name = "submachinegun magazine (.45)"
	path = /obj/item/ammo_magazine/submachinemag
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/uzi_mag
	name = "stick magazine (.45)"
	path = /obj/item/ammo_magazine/c45uzi
	hidden = 1
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hidden = 1
	category = "Devices and Components"

/singleton/autolathe_recipe/trap
	name = "mechanical trap"
	path = /obj/item/trap
	hidden = 1
	category = "Devices and Components"

/singleton/autolathe_recipe/welder_industrial
	name = "industrial welding tool"
	path = /obj/item/weldingtool/largetank
	hidden = 1
	category = "Tools"

/singleton/autolathe_recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/handcuffs
	hidden = 1
	category = "General"

/singleton/autolathe_recipe/brassknuckles
	name = "brass knuckles"
	path = /obj/item/clothing/gloves/brassknuckles
	hidden = 1
	category = "General"

/singleton/autolathe_recipe/grenade
	name = "grenade casing"
	path = /obj/item/grenade/chem_grenade
	category = "Arms and Ammunition"

/singleton/autolathe_recipe/grenade/large
	name = "large grenade casing"
	path = /obj/item/grenade/chem_grenade/large
	hidden = TRUE
