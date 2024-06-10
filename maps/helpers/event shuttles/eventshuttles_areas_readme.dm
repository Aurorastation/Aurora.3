// This series of event shuttles should be used to replace the one we've been using for the last several events.
// Each one of the three is geared to have different levels of involvement of the crew. Mainly engineering and operations.
// All three ships will be given their own fluff written out, use as you wish. Or, discard entirely i don't really care.
// As for a technical explination of each ship:
// Artemis is a combat focused spawn shuttle, made to address the issues we (the crew) had with the Konyang Warehouse Raid event.
// Its geared out for heavy security and crew milita use.
// There's also things like the machinists having all of their things packed up, ready to be moved out to somewhere off shuttle to handle IPC's
// -------------------------------------------------------------------------------------------------------------------------
// // Apollo v1 is a humanitarian focused shuttle. It focuses on carrying service related supplies, operations supplies, and most importantly: scientific supplies.
// Additionally, engineering is issued RFD's to be able to build out as the mission requires.
// Only service, operations, and science would have to unload their gear.
// -------------------------------------------------------------------------------------------------------------------------
// Apollo v2 stays in line of the first Apollo, but it adds engineering to the list of departments that need to set up their gear outside.
// -------------------------------------------------------------------------------------------------------------------------
// Apollo v3 goes even further, packing up medical almost entirely. I very much like the idea of medical having to work with a handful of engineers to build a clinic, so this gives
// the option for an organizor to run with that.
// -------------------------------------------------------------------------------------------------------------------------
// Packrat is half a meme, half genuine attempt to encourage a gameplay idea for an event. Every job's gear is packed up in the smallest space possible.
// Its up to the crew as a whole to get all of this gear off the shuttle and deployed into an area
// I think this ship would be best served by existing in a city enviornment. Its shorter size narratively supports that, and its lack of internal walls for the cargo hold
// means that you cant really set up anyones base of operations inside. At most, one department's worth of jobs.
// I strongly reccomend using this ship in an urban enviornment where the crew has buildings around the ship they can move into.

/area/scc_event_shuttle
	name = "SCC Transport Shuttle"
	icon_state = "shuttle"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED
	is_outside = FALSE
