#define PANEL_LOCATION_FLOOR "floor"
#define PANEL_LOCATION_WALL "wall"
#define PANEL_TYPE_PIPE "pipe"
#define PANEL_TYPE_ELECTRIC "electric"

ABSTRACT_TYPE(/obj/structure/engineer_maintenance)
	name = "abstract engineering maintenance"
	desc = "You shouldn't be able to read this."
	icon = 'icons/obj/engineering_fluff.dmi'
	anchored = TRUE
	density = FALSE

	/// Whether the panel is currently open or not
	var/panel_open = FALSE

	/// Indicates where this maintenance panel can be found: floor | wall
	var/panel_location

	/// Indicates what type of maintenance panel this is: pipe | electric
	var/panel_type

	/// The randomly generated icon number to display, see the DMI for the sprites associated with each number
	var/icon_number

	/// A key-value list of icons numbers and their descriptions, the icon_number is pick()'d from this list. The key is the icon_number, while the value is the description
	var/list/icon_numbers_and_descriptions

	/// The detailed description shown only when the panel is opened, determined by the icon_number chosen above
	var/detailed_desc

	/// The key-value list of tools that can be used on the panel once it's been opened. The key is the typepath of the item, and the value is a singleton which holds some data to be used
	var/list/panel_tools

	/// The list of tool names that can be used on the panel once it's open, but in name format, to be used in mechanics_hints
	var/list/panel_tool_names = list()

/obj/structure/engineer_maintenance/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += SPAN_NOTICE("Any wrench, or an impact drill with the wrenchbit selected, can be used to open/close the panel.")
	if(panel_open)
		. += SPAN_NOTICE("The following tools can be used to interact with the panel:")
	for(var/tool_name in panel_tool_names)
		. += SPAN_NOTICE("- [tool_name]")

/obj/structure/engineer_maintenance/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(panel_open)
		. += SPAN_NOTICE(detailed_desc)
	. += SPAN_ITALIC("OOC NOTE: This object is purely a fluff item, and has no mechanical effect.")

/obj/structure/engineer_maintenance/Initialize(mapload)
	. = ..()
	name = panel_location == PANEL_LOCATION_FLOOR ? "maintenance panel" : "large maintenance panel" // floor panels are smaller than the wall mounted ones
	icon_number = pick(icon_numbers_and_descriptions)
	detailed_desc = icon_numbers_and_descriptions[icon_number]
	for(var/tool_type in panel_tools)
		var/atom/tool = tool_type
		panel_tool_names += initial(tool.name)

	var/turf/target_turf = panel_location == PANEL_LOCATION_FLOOR ? get_turf(src) : get_step(src, NORTH)
	RegisterSignal(target_turf, COMSIG_ATOM_DECONSTRUCTED, PROC_REF(remove_self))

/obj/structure/engineer_maintenance/proc/remove_self()
	SIGNAL_HANDLER
	qdel(src)

/obj/structure/engineer_maintenance/update_icon()
	if(!panel_open)
		icon_state = initial(icon_state)
		return
	icon_state = "[panel_location]_[panel_type]_[icon_number]"

/obj/structure/engineer_maintenance/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.iswrench()) // Any wrench is good, but we explicltly include the impact drill to send a helpful msg if they just have the screwdriver bit attached.
		if(!attacking_item.iswrench())
			to_chat(user, SPAN_WARNING("\The [attacking_item] must have its wrenchbit inserted to remove \the [src]'s bolts!"))
			return
		if (istype(attacking_item, /obj/item/powerdrill))
			user.visible_message("[SPAN_BOLD("[user]")] starts [panel_open ? "closing" : "opening"] \the [src]...", SPAN_NOTICE("You start [panel_open ? "closing" : "opening"] \the [src]..."), SPAN_NOTICE("You hear the whirr of an impact drill..."))
		else
			user.visible_message("[SPAN_BOLD("[user]")] starts manually [panel_open ? "closing" : "opening"] \the [src]...", SPAN_NOTICE("You start manually [panel_open ? "closing" : "opening"] \the [src]..."))
		if(attacking_item.usesound)
			playsound(get_turf(src), attacking_item.usesound, 30, TRUE)
		if (istype(attacking_item, /obj/item/powerdrill))
			if(!do_after(user, rand(2, 3) SECONDS, src))
				return
		else
			if(!do_after(user, rand(5, 7) SECONDS, src))
				return
		user.visible_message("[SPAN_BOLD("[user]")] [panel_open ? "closes" : "opens"] \the [src]!", SPAN_NOTICE("You [panel_open ? "close" : "open"] \the [src]!"))
		panel_open = !panel_open
		update_icon()
		playsound(get_turf(src), panel_open ? /singleton/sound_category/hatch_open : /singleton/sound_category/hatch_close, 30, TRUE)
		return
	if(panel_open)
		for(var/tool_type in panel_tools)
			if(istype(attacking_item, tool_type))
				var/singleton/engineer_maintenance_tool/tool_usage = GET_SINGLETON(panel_tools[tool_type])
				tool_usage.perform_action(user, attacking_item, src)
				return
	return ..()

/obj/structure/engineer_maintenance/pipe
	desc = "A metal cover, surrounded by yellow warning stripes around the edges. The warning on the cover reads: 'DANGER! RISK OF INJURY.' as well as 'Utility maintenance hatch. To be used only for maintenance by trained engineering personnel.'"
	icon_state = "floor_pipe_cover"
	panel_location = PANEL_LOCATION_FLOOR
	panel_type = PANEL_TYPE_PIPE
	icon_numbers_and_descriptions = list(
		"1" = "The hatch contains three pipes, from different loops, going around the place. Water, steam, any utility used are going through these pipes. There is also a large equalization valve right next to the red and the blue pipe, hinting that this might equalize pressure or maybe heat.",
		"2" = "You can see three pipes, a manifold with a meter and valve merging together. These kinds of pipes carry around all kinds of utility or gases around the place. The valve and connected meter allow the user to merge the currently unconnected white loop with the cyan one, while also showing the flow rate.",
		"3" = "Three pipes, crossing each other, next to a metal grate are located in this hatch. Behind the little grate you can spot more of the pipe network, before giving way to the darkness. There is not much else in here.",
		"4" = "A high-pressure pipe, together with an electrical flow meter and a keypad can be seen in this hatch. High pressure pipes like these usually carry gases around the place. Probably in higher quantities than usual. The interface allows the user to adjust the flow rate or to close the pipe completely."
	)
	panel_tools = list(
		/obj/item/pipewrench = /singleton/engineer_maintenance_tool/steam_pipe,
		/obj/item/hammer = /singleton/engineer_maintenance_tool/steam_pipe,
		/obj/item/device/multitool = /singleton/engineer_maintenance_tool/steam_pipe
	)

/obj/structure/engineer_maintenance/pipe/wall
	icon_state = "wall_pipe_cover"
	pixel_y = 16
	panel_location = PANEL_LOCATION_WALL
	icon_numbers_and_descriptions = list(
		"1" = "A large maintenance hatch, containing two pipes, belonging to the same loop that carries a lot of utility around, be it water, gasses or maybe even steam. On the left there are more pipes, further back. You probably need to stick your head into the opening to see more.",
		"2" = "A large maintenance hatch, containing a large user interface for the surrounding pipe networks. It contains flow meters for different loops, a keypad interface, as well as a port for multitool port. Almost all parameters of this section's pipe network can be adjusted with this.",
		"3" = "A big hatch, containing some high-capacity pipes. These larger pipes are also more maintenance intensive - due to increased wear. Behind the pipes you see even more pipes, belonging to different loops, as well as some labels and warning signs.",
		"4" = "A seemingly end section of two pipe loops, leading further into the hull, out of sight. There is a lever on the right, to open, close or flush the loop. 'WARNING: CHECK PRESSURE BEFORE FLUSHING.' is written in red letters above said lever."
	)

/obj/structure/engineer_maintenance/electric
	desc = "A metal cover, surrounded by orange warning stripes around the edges. The warning on the cover reads: 'DANGER. RISK OF ELECTROCUTION.' as well as 'Electrical maintenance hatch. To be used only for maintenance by trained engineering personnel.'"
	icon_state = "floor_electric_cover"
	panel_location = PANEL_LOCATION_FLOOR
	panel_type = PANEL_TYPE_ELECTRIC
	icon_numbers_and_descriptions = list(
		"1" = "This hatch contains a little breaker box and accompanying buttons. There are numbers and labels, all relating to surrounding equipment and lights. It is hard to differentiate between all these without the appropiate circuit diagram.",
		"2" = "Within this hatch there is a control power meter interface, making it possible to deduce the amount of electrical power going through this spot, as well as where it goes and what exactly uses it. Mostly used to monitor power consumption, as APCs can be unreliable in fringe cases, this interface here allows connection with different tools, for maintenance and data collection purposes.",
		"3" = "In this maintenance hatch you can see an enormous amount of loose wires, some neatly placed, some entangled, some all over the place, together with some high voltage connection ports.",
		"4" = "This hatch contains an interface, showing this area's power consumption, distribution and eventual voltage peaks. Contains some firmly secured data storage devices to collect usage data, most likely. Also has connection ports for multitools and debuggers for troubleshooting.",
		"5" = "In this hatch, firmly secured, you can see a heavy industrial voltage meter, with six industrial electrical connections. Used to connect different types of machinery or electrical equipment together and protect said equipment against short circuits."
	)
	panel_tools = list(
		/obj/item/wirecutters = /singleton/engineer_maintenance_tool/electrical_spark,
		/obj/item/stack/cable_coil = /singleton/engineer_maintenance_tool/electrical_spark,
		/obj/item/device/multitool = /singleton/engineer_maintenance_tool/electrical_hum
	)

/obj/structure/engineer_maintenance/electric/wall
	icon_state = "wall_electric_cover"
	pixel_y = 16
	panel_location = PANEL_LOCATION_WALL
	icon_numbers_and_descriptions = list(
		"1" = "A large hatch, containing a relay, with controlling circuits, as well as multiple terminal blocks of equipment connections from the surrounding area. On the right you can see some space to give the cooling fans and filters some room to circulate air.",
		"2" = "A maintenance hatch, containing big busbars, contactors and appropiate surge protectors. Labels and warning signs warn the user about power spikes, overload and damage to the area, if handled inappropiately. Multiple indicators and the seperate human machine interface allow for manipulation with a debugger, multitool or more for maintenance reasons.",
		"3" = "A hatch containing a large emergency battery backup system, integrated within a SCADA System. SCADA stands for Supervisory Control And Data Acquisition, meaning this is one of the control units for the surrounding area. It comes with multiple control panels, grounding strips for its wiring, ground fault circuit interrupters, and many more safety systems. The wiring diagram looks very complex and the attached maintenance log on the inside of the hatch is almost full. A large warning is printed above the user interface: 'Attention: Hephaestus Industries GATEKEEPER Anti-Tamper System enclosed. Maintenance only through authorized engineering personnel. All access will be logged and documented.'",
		"4" = "A hatch, containing multiple conduit junctions, relays and circuit breakers, coming with a user interface for maintenance. A lot of cables surround this hatch on all sides, mostly tucked behind some cable trays and cable tunnels. Will need a lot of fiddling to fix or repair any of this."
	)

#undef PANEL_LOCATION_FLOOR
#undef PANEL_LOCATION_WALL
#undef PANEL_TYPE_PIPE
#undef PANEL_TYPE_ELECTRIC

/singleton/engineer_maintenance_tool
	/// The message displayed to the people around when the user starts using the tool
	var/action_message_start = "%USER% starts fiddling on the %TARGET% with the %TOOL%..."

	/// The message displayed to the person performing the action when the user starts using the tool
	var/self_action_message_start = "You start fiddling on the %TARGET% with the %TOOL%..."

	/// The message displayed to the people around when the user finishes using the tool
	var/action_message_end = "%USER% finishes fiddling on the %TARGET% with the %TOOL%!"

	/// The message displayed to the person performing the action when the user finishes using the tool
	var/self_action_message_end = "You finish fiddling on the %TARGET% with the %TOOL%!"

	/// The sound played when the user starts using the tool
	var/usage_sound

	/// Whether we should use the tool's sound if no usage_sound is available
	var/use_tool_sound_if_no_usage_sound = TRUE

	/// Sound to play when the action finishes
	var/finish_sound

/singleton/engineer_maintenance_tool/proc/perform_action(var/mob/user, var/obj/item/tool, var/obj/structure/engineer_maintenance/target)
	var/message_start = action_message_start
	message_start = replacetext(message_start, "%USER%", SPAN_BOLD("[user]"))
	message_start = replacetext(message_start, "%TOOL%", tool.name)
	message_start = replacetext(message_start, "%TARGET%", target.name)

	var/self_message_start = self_action_message_start
	self_message_start = replacetext(self_message_start, "%TOOL%", tool.name)
	self_message_start = replacetext(self_message_start, "%TARGET%", target.name)

	user.visible_message(message_start, SPAN_NOTICE(self_message_start))

	if(usage_sound)
		playsound(get_turf(target), usage_sound, 30, TRUE)
	else if(use_tool_sound_if_no_usage_sound && tool.usesound)
		playsound(get_turf(target), tool.usesound, 30, TRUE)

	if(!do_after(user, rand(5, 10) SECONDS, target))
		return

	var/message_end = action_message_end
	message_end = replacetext(message_end, "%USER%", SPAN_BOLD("[user]"))
	message_end = replacetext(message_end, "%TOOL%", tool.name)
	message_end = replacetext(message_end, "%TARGET%", target.name)

	var/self_message_end = self_action_message_end
	self_message_end = replacetext(self_message_end, "%TOOL%", tool.name)
	self_message_end = replacetext(self_message_end, "%TARGET%", target.name)

	user.visible_message(message_end, SPAN_NOTICE(self_message_end))

	if(finish_sound)
		playsound(get_turf(target), finish_sound, 30, TRUE)

/singleton/engineer_maintenance_tool/steam_pipe
	finish_sound = /singleton/sound_category/steam_pipe

/singleton/engineer_maintenance_tool/electrical_hum
	finish_sound = /singleton/sound_category/electrical_hum

/singleton/engineer_maintenance_tool/electrical_spark
	finish_sound = /singleton/sound_category/electrical_spark

/singleton/engineer_maintenance_tool/electrical_spark/perform_action(mob/user, obj/item/tool, obj/structure/engineer_maintenance/target)
	. = ..()
	spark(get_turf(target), 2)
