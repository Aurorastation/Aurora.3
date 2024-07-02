// This series of event shuttles should be used to replace the one we've been using for the last several events.
// Each one of the three is geared to have different levels of involvement of the crew. Mainly engineering and operations.
// All three ships will be given their own fluff written out, use as you wish. Or, discard entirely i don't really care.
// As for a technical explanation of each ship:
//
// Artemis is a combat focused spawn shuttle, made to address the issues we (the crew) had with the Konyang Warehouse Raid event.
// Its geared out for heavy security and crew militia use.
// There's also things like the machinists having all of their things packed up, ready to be moved out to somewhere off shuttle to handle IPC's
// -------------------------------------------------------------------------------------------------------------------------
// // Apollo v1 is a humanitarian focused shuttle. It focuses on carrying service related supplies, operations supplies, and most importantly: scientific supplies.
// Additionally, engineering is issued RFD's to be able to build out as the mission requires.
// Only service, operations, and science would have to unload their gear.
// -------------------------------------------------------------------------------------------------------------------------
// Apollo v2 stays in line of the first Apollo, but it adds engineering to the list of departments that need to set up their gear outside.
// -------------------------------------------------------------------------------------------------------------------------
// Apollo v3 goes even further, packing up medical almost entirely. I very much like the idea of medical having to work with a handful of engineers to build a clinic, so this gives
// the option for an organizer to run with that.
// -------------------------------------------------------------------------------------------------------------------------
// Packrat is half a meme, half genuine attempt to encourage a gameplay idea for an event. Every job's gear is packed up in the smallest space possible.
// Its up to the crew as a whole to get all of this gear off the shuttle and deployed into an area
// I think this ship would be best served by existing in a city environment. Its shorter size narratively supports that, and its lack of internal walls for the cargo hold
// means that you cant really set up anyone's base of operations inside. At most, one department's worth of jobs.
// I strongly recommend using this ship in an urban environment where the crew has buildings around the ship they can move into.
//
// Fluff:
//
// SCCV Corrugated Chariot
// description: The Corrugated Chariot is the flagship of the Orion Express Modular Delivery System (OEM-DS) line of destroyer sized freighters. Design of the pattern started at the begining of the Konyang Hivebot Crisis of 2466, heavily influcenced by data recieved from both local aid workers, the IAC, and the SCC's own mission to the planet. The need for modular shuttle tender and freighter was identified, and the Chariot delivers. The class features a two deck design, with shuttles docked in mounting clamps on the first deck. And a large warehouse and pressure tank on the second. Crewed by positronics, the ship's ammenities are non existant.
// sizeclass: OEM-DS Freighter
// shiptype: civilian freighter - destroyer

/area/scc_event_shuttle
	name = "SCC Transport Shuttle"
	icon_state = "shuttle"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED
	is_outside = FALSE
