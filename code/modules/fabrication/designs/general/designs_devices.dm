ABSTRACT_TYPE(/singleton/fabricator_recipe/components)
	name = "Abstract Components"
	category = "Components"

/singleton/fabricator_recipe/components/consolescreen
	name = "console screen"
	path = /obj/item/stock_parts/console_screen

/singleton/fabricator_recipe/components/igniter
	name = "igniter"
	path = /obj/item/assembly/igniter

/singleton/fabricator_recipe/components/signaler
	name = "signaler"
	path = /obj/item/assembly/signaler

/singleton/fabricator_recipe/components/sensor_infra
	name = "infrared sensor"
	path = /obj/item/assembly/infra

/singleton/fabricator_recipe/components/timer
	name = "timer"
	path = /obj/item/assembly/timer

/singleton/fabricator_recipe/components/sensor_prox
	name = "proximity sensor"
	path = /obj/item/assembly/prox_sensor

/singleton/fabricator_recipe/components/cable_coil
	name = "cable coil"
	path = /obj/item/stack/cable_coil
	is_stack = TRUE

// Basic Stock Parts for Engineering
/singleton/fabricator_recipe/components/micromanip
	name = "micro-manipulator"
	path = /obj/item/stock_parts/manipulator

/singleton/fabricator_recipe/components/matterbin
	name = "matter bin"
	path = /obj/item/stock_parts/matter_bin

/singleton/fabricator_recipe/components/capacitor
	name = "capacitor"
	path = /obj/item/stock_parts/capacitor

/singleton/fabricator_recipe/components/scanningmod
	name = "scanning module"
	path = /obj/item/stock_parts/scanning_module

/singleton/fabricator_recipe/components/microlaser
	name = "micro-laser"
	path = /obj/item/stock_parts/micro_laser

ABSTRACT_TYPE(/singleton/fabricator_recipe/devices)
	name = "Abstract Devices"
	category = "Devices"

/singleton/fabricator_recipe/devices/binoculars
	name = "binoculars"
	path = /obj/item/binoculars
	resources = list(MATERIAL_ALUMINIUM = 250, MATERIAL_GLASS = 250)

/singleton/fabricator_recipe/devices/eftpos
	name = "EFTPOS scanner"
	path = /obj/item/eftpos
	resources = list(MATERIAL_ALUMINIUM = 100, MATERIAL_GLASS = 50, MATERIAL_PLASTIC = 50)

/singleton/fabricator_recipe/devices/quikpay
	name = "QuikPay scanner"
	path = /obj/item/quikpay
	resources = list(MATERIAL_ALUMINIUM = 100, MATERIAL_GLASS = 50, MATERIAL_PLASTIC = 50)

/singleton/fabricator_recipe/devices/export_scanner
	name = "export scanner"
	path = /obj/item/export_scanner
	resources = list(MATERIAL_ALUMINIUM = 100, MATERIAL_GLASS = 50, MATERIAL_PLASTIC = 50)

/singleton/fabricator_recipe/devices/laser_pointer
	name = "red laser pointer"
	path = /obj/item/laser_pointer/red
	resources = list(MATERIAL_ALUMINIUM = 50, MATERIAL_GLASS = 25)

/singleton/fabricator_recipe/devices/laser_pointer/green
	name = "green laser pointer"
	path = /obj/item/laser_pointer/green

/singleton/fabricator_recipe/devices/laser_pointer/blue
	name = "blue laser pointer"
	path = /obj/item/laser_pointer/blue

/singleton/fabricator_recipe/devices/laser_pointer/purple
	name = "purple laser pointer"
	path = /obj/item/laser_pointer/purple

/singleton/fabricator_recipe/devices/paper_scanner
	name = "paper scanner chassis"
	path = /obj/item/paper_scanner/empty
	resources = list(MATERIAL_ALUMINIUM = 200, MATERIAL_GLASS = 100, MATERIAL_PLASTIC = 100)

/singleton/fabricator_recipe/devices/price_scanner
	name = "price scanner"
	path = /obj/item/price_scanner

/singleton/fabricator_recipe/devices/radio_engineering
	name = "engineering shortwave radio"
	path = /obj/item/radio/eng/off

/singleton/fabricator_recipe/devices/radio_medical
	name = "medical shortwave radio"
	path = /obj/item/radio/med/off

/singleton/fabricator_recipe/devices/radio_security
	name = "security shortwave radio"
	path = /obj/item/radio/sec/off

/singleton/fabricator_recipe/devices/radio_science
	name = "science shortwave radio"
	path = /obj/item/radio/sci/off
