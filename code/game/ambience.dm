// Ambience presets.
// All you need to do to make an area play one of these is set their ambience var to one of these lists.
// You can even combine them by adding them together, since they're just lists, however you'd have to do that in initialization.

// For weird alien places like Srom.
#define AMBIENCE_OTHERWORLDLY list(\
	'sound/ambience/otherworldly/otherworldly1.ogg',\
	'sound/ambience/otherworldly/otherworldly2.ogg',\
	'sound/ambience/otherworldly/otherworldly3.ogg'\
	)

// Restricted, military, or mercenary aligned locations like the armory, the merc ship/base, BSD, etc.
#define AMBIENCE_HIGHSEC list(\
	'sound/ambience/highsec/highsec1.ogg',\
	'sound/ambience/highsec/highsec2.ogg',\
	'sound/ambience/highsec/highsec3.ogg',\
	'sound/ambience/highsec/highsec4.ogg'\
	)

// Ruined structures found on the surface or in the caves.
#define AMBIENCE_RUINS list(\
	'sound/ambience/ruins/ruins1.ogg',\
	'sound/ambience/ruins/ruins2.ogg',\
	'sound/ambience/ruins/ruins3.ogg',\
	'sound/ambience/ruins/ruins4.ogg',\
	'sound/ambience/ruins/ruins5.ogg',\
	'sound/ambience/ruins/ruins6.ogg'\
	)

// Similar to the above, but for more technology/signaling based ruins.
#define AMBIENCE_TECH_RUINS list(\
	'sound/ambience/tech_ruins/tech_ruins1.ogg',\
	'sound/ambience/tech_ruins/tech_ruins2.ogg',\
	'sound/ambience/tech_ruins/tech_ruins3.ogg'\
	)

// The actual chapel room, and maybe some other places of worship.
#define AMBIENCE_CHAPEL list(\
	'sound/ambience/chapel/chapel1.ogg',\
	'sound/ambience/chapel/chapel2.ogg',\
	'sound/ambience/chapel/chapel3.ogg',\
	'sound/ambience/chapel/chapel4.ogg'\
	)

// For peaceful, serene areas, distinct from the Chapel.
#define AMBIENCE_HOLY list(\
	'sound/ambience/holy/holy1.ogg',\
	'sound/ambience/holy/holy2.ogg'\
	)

// Generic sounds for less special rooms.
#define AMBIENCE_GENERIC list(\
	'sound/ambience/generic/generic1.ogg',\
	'sound/ambience/generic/generic2.ogg',\
	'sound/ambience/generic/generic3.ogg',\
	'sound/ambience/generic/generic4.ogg',\
	'sound/ambience/generic/generic5.ogg',\
	'sound/ambience/generic/generic6.ogg',\
	'sound/ambience/generic/generic7.ogg',\
	'sound/ambience/generic/generic8.ogg'\
	)

// Sounds of PA announcements, presumably involving shuttles?
#define AMBIENCE_ARRIVALS list(\
	'sound/ambience/arrivals/arrivals1.ogg',\
	'sound/ambience/arrivals/arrivals2.ogg',\
	'sound/ambience/arrivals/arrivals3.ogg',\
	'sound/ambience/arrivals/arrivals4.ogg',\
	'sound/ambience/arrivals/arrivals5.ogg',\
	'sound/ambience/arrivals/arrivals6.ogg',\
	'sound/ambience/arrivals/arrivals7.ogg'\
	)


// Sounds suitable for being inside dark, tight corridors in the underbelly of the station.
#define AMBIENCE_MAINTENANCE list(\
	'sound/ambience/maintenance/maintenance1.ogg',\
	'sound/ambience/maintenance/maintenance2.ogg',\
	'sound/ambience/maintenance/maintenance3.ogg',\
	'sound/ambience/maintenance/maintenance4.ogg',\
	'sound/ambience/maintenance/maintenance5.ogg',\
	'sound/ambience/maintenance/maintenance6.ogg',\
	'sound/ambience/maintenance/maintenance7.ogg',\
	'sound/ambience/maintenance/maintenance8.ogg',\
	'sound/ambience/maintenance/maintenance9.ogg',\
	'sound/ambience/maintenance/maintenance10.ogg',\
	'sound/ambience/maintenance/maintenance11.ogg',\
	'sound/ambience/maintenance/maintenance12.ogg'\
	)

// Life support machinery at work, keeping everyone breathing.
#define AMBIENCE_ENGINEERING list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg'\
	)

#define AMBIENCE_SINGULARITY list(\
	'sound/ambience/singularity/singularity1.ogg',\
	'sound/ambience/singularity/singularity2.ogg',\
	'sound/ambience/singularity/singularity3.ogg',\
	'sound/ambience/singularity/singularity4.ogg'\
	)

//CHOMP Edit Sounds for atmos
#define AMBIENCE_ATMOS list(\
	'sound/ambience/atmospherics/atmospherics1.ogg',\
	'sound/ambience/atmospherics/atmospherics2.ogg'\
	)

// Creepy AI/borg stuff.
#define AMBIENCE_AI list(\
	'sound/ambience/ai/ai1.ogg',\
	'sound/ambience/ai/ai2.ogg',\
	'sound/ambience/ai/ai3.ogg'\
	)

// Peaceful sounds when floating in the void.
#define AMBIENCE_SPACE list(\
	'sound/ambience/space/space_serithi.ogg',\
	'sound/ambience/space/space1.ogg'\
	)

// Vaguely spooky sounds when around dead things.
#define AMBIENCE_GHOSTLY list(\
	'sound/ambience/ghostly/ghostly1.ogg',\
	'sound/ambience/ghostly/ghostly2.ogg'\
	)

// Concerning sounds, for when one discovers something horrible happened in a PoI.
#define AMBIENCE_FOREBODING list(\
	'sound/ambience/foreboding/foreboding1.ogg',\
	'sound/ambience/foreboding/foreboding2.ogg'\
	)

// If we ever add geothermal PoIs or other places that are really hot, this will do.
#define AMBIENCE_LAVA list(\
	'sound/ambience/lava/lava1.ogg'\
	)

// Cult-y ambience, for some PoIs, and maybe when the cultists darken the world with the ritual.
#define AMBIENCE_UNHOLY list(\
	'sound/ambience/unholy/unholy1.ogg'\
	)

#define AMBIENCE_ELEVATOR list(\
	'sound/ambience/elevator.ogg'\
	)

//CHOMPedit: Exploration outpost ambience.
#define AMBIENCE_EXPOUTPOST list(\
	'sound/ambience/expoutpost/expoutpost1.ogg',\
	'sound/ambience/expoutpost/expoutpost2.ogg',\
	'sound/ambience/expoutpost/expoutpost3.ogg',\
	'sound/ambience/expoutpost/expoutpost4.ogg'\
	)

//CHOMP Edit Sounds for Substation rooms. Just electrical sounds, really.
#define AMBIENCE_SUBSTATION list(\
	'sound/ambience/substation/substation1.ogg',\
	'sound/ambience/substation/substation2.ogg',\
	'sound/ambience/substation/substation3.ogg',\
	'sound/ambience/substation/substation4.ogg',\
	'sound/ambience/substation/substation5.ogg',\
	'sound/ambience/substation/substation6.ogg',\
	'sound/ambience/substation/substation7.ogg',\
	'sound/ambience/substation/substation8.ogg'\
	)

//CHOMP Edit Sounds for hangars
#define AMBIENCE_HANGAR list(\
	'sound/ambience/hangar/hangar1.ogg',\
	'sound/ambience/hangar/hangar2.ogg',\
	'sound/ambience/hangar/hangar3.ogg',\
	'sound/ambience/hangar/hangar4.ogg',\
	'sound/ambience/hangar/hangar5.ogg',\
	'sound/ambience/hangar/hangar6.ogg'\
	)

//wind sounds for outside places
#define AMBIENCE_WINDY list(\
	'sound/effects/wind/wind_2_1.ogg',\
	'sound/effects/wind/wind_2_2.ogg',\
	'sound/effects/wind/wind_3_1.ogg',\
	'sound/effects/wind/wind_4_1.ogg',\
	'sound/effects/wind/wind_4_2.ogg',\
	'sound/effects/wind/wind_5_1.ogg'\
	)
