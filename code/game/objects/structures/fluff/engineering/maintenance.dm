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

	/// The maximum amount the icon_number can be, the final value will be a value between and including 1 and this value
	var/maximum_icon_number = 1

	/// The list of tools that can be used on the panel once it's been opened. It's a key value list where the key is the typepath of the item which points to a list
	var/list/panel_tools

/obj/structure/engineer_maintenance/Initialize(mapload)
	. = ..()
	icon_number = rand(1, maximum_icon_number)

/obj/structure/engineer_maintenance/update_icon()
	if(!panel_open)
		icon_state = initial(icon_state)
		return
	icon_state = "[panel_location]_[panel_type]_[icon_number]"

/obj/structure/engineer_maintenance/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/powerdrill)) // these will always open the panel
		return
	for(var/tool_type in panel_tools)
		if(istype(attacking_item, tool_type))
			return
	return ..()
