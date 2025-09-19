// This is the base type that handles everything. Subtypes can be easily created by tweaking variables in this file to your liking.

/obj/item/modular_computer
	name = "Modular Computer"
	desc = DESC_PARENT

	var/lexical_name = "computer"
	/// Whether the computer is turned on.
	var/enabled = FALSE
	/// Whether the computer is active/opened/it's screen is on.
	var/screen_on = TRUE
	/// Whether the computer is working.
	var/working = TRUE
	/// Whether you can reset this device with the tech support card.
	var/can_reset = FALSE
	/// A currently active program running on the computer.
	var/datum/computer_file/program/active_program
	/// A flag that describes this device type
	var/hardware_flag = 0
	/// Last tick power usage of this computer
	var/last_power_usage = 0
	/// Used for deciding if battery percentage has chandged
	var/last_battery_percent = 0
	var/last_world_time = "00:00"
	var/list/last_header_icons
	/// Looping sound for when the computer is on
	var/datum/looping_sound/computer/soundloop
	/// Whether or not this modular computer uses the looping sound. Also handles ambience beeps.
	var/looping_sound = TRUE
	/// Whether the computer is emagged.
	var/computer_emagged = FALSE
	/// Set automatically. Whether the computer used APC power last tick.
	var/apc_powered = FALSE
	/// Power usage when the computer is open (screen is active) and can be interacted with. Remember hardware can use power too.
	var/base_active_power_usage = 50
	/// Power usage when the computer is idle and screen is off (currently only applies to laptops)
	var/base_idle_power_usage = 5
	/// Whether the computer is enrolled in the company device management or not. 0 - unconfigured 1 - enrolled (work device) 2 - unenrolled (private device)
	var/enrolled = DEVICE_UNSET
	/// Used for specifying the software preset of the console
	var/_app_preset_type
	/// Last time sound was played
	var/ambience_last_played_time
	/// Toggles whether pAI can interact with the modular computer while installed in it
	var/pAI_lock = FALSE
	/// ID used for chat client registering
	var/obj/item/card/id/registered_id = null
	/// Mode used for health/reagent scanners
	var/scan_mode = null
	/// Used for the PDA analyser spam detection
	var/last_scan = 0
	var/silent = FALSE
	var/doorcode = "smindicate"
	var/hidden = FALSE
	var/initial_name
	/// overmap sector the computer is linked to
	var/obj/effect/overmap/visitable/linked

	/// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	/// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	/// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	/// This isn't meant to be used on it's own. Subtypes should supply their own icon.
	icon = null
	/// And no random pixelshifting on-creation either.
	icon_state = null
	randpixel = 0
	center_of_mass = null
	/// Icon state when the computer is turned off
	var/icon_state_unpowered
	/// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/icon_state_menu = "menu"
	var/icon_state_menu_key = "black_key"
	var/icon_state_screensaver
	var/icon_state_screensaver_key
	var/icon_state_broken
	var/screensaver_light_range = 0
	var/screensaver_light_color
	var/menu_light_color
	/// Adds onto the output_message proc's range
	var/message_output_range = 0
	/// Maximal hardware size. Currently, tablets have 1, laptops 2 and consoles 3. Limits what hardware types can be installed.
	var/max_hardware_size = 0
	/// Amount of steel sheets refunded when disassembling an empty frame of this computer.
	var/steel_sheet_cost = 5
	/// Tile range of lighting emitted by the computer.
	light_range = 0
	/// Intensity of lighting emitted by the computer. Valid range between 0 and 1.
	light_power = 0
	/// Idle programs on background. They still receive process calls but can't be interacted with.
	var/list/idle_threads = list()
	/// Enabled services that run in background and handle things pasively. Supported on all CPUs.
	var/list/enabled_services = list()
	var/power_has_failed = FALSE
	var/is_holographic = FALSE

	/// Damage of the chassis. If the chassis takes too much damage it will break apart.
	/// Current damage level
	var/damage = 0
	/// Damage level at which the computer ceases to operate
	var/broken_damage = 50
	/// Damage level at which the computer breaks apart.
	var/max_damage = 100

	/// Important hardware (must be installed for computer to work)
	/// CPU. Without it the computer won't run. Better CPUs can run more programs at once.
	var/obj/item/computer_hardware/processor_unit/processor_unit
	/// Network Card component of this computer. Allows connection to NTNet
	var/obj/item/computer_hardware/network_card/network_card
	/// Hard Drive component of this computer. Stores programs and files.
	var/obj/item/computer_hardware/hard_drive/hard_drive

	/// Optional hardware (improves functionality, but is not critical for computer to work in most cases)
	/// An internal power source for this computer. Can be recharged.
	var/obj/item/computer_hardware/battery_module/battery_module
	/// ID Card slot component of this computer. Mostly for HoP modification console that needs ID slot for modification.
	var/obj/item/computer_hardware/card_slot/card_slot
	/// Nano Printer component of this computer, for your everyday paperwork needs.
	var/obj/item/computer_hardware/nano_printer/nano_printer
	/// Portable data storage
	var/obj/item/computer_hardware/hard_drive/portable/portable_drive
	/// AI slot, an intellicard housing that allows modifications of AIs.
	var/obj/item/computer_hardware/ai_slot/ai_slot
	/// Tesla Link, Allows remote charging from nearest APC.
	var/obj/item/computer_hardware/tesla_link/tesla_link
	/// Personal AI, can control the device via a verb when installed
	var/obj/item/device/paicard/personal_ai
	var/obj/item/computer_hardware/flashlight/flashlight
	var/listener/listener

	var/registered_message = ""

	var/click_sound = 'sound/machines/holoclick.ogg'

	charge_failure_message = " does not have a battery installed."
