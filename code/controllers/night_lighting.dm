#define MORNING_LIGHT_RESET 252000
#define NIGHT_LIGHT_ACTIVE 648000

var/global/datum/lighting_controller/night/night_lighting

/datum/lighting_controller/night

	var/isactive = 0

	var/list/lighting_areas = list(
		                           "/area/hallway/primary/fore",
		                           "/area/hallway/primary/starboard",
		                           "/area/hallway/primary/port",
		                           "/area/hallway/primary/central_one",
		                           "/area/hallway/primary/central_two",
		                           "/area/hallway/primary/central_three",
		                           "/area/hallway/secondary/exit",
		                           "/area/hallway/secondary/entry/fore",
		                           "/area/hallway/secondary/entry/port",
		                           "/area/hallway/secondary/entry/starboard",
		                           "/area/hallway/secondary/entry/aft"
		                           "/area/crew_quarters",
		                           "/area/crew_quarters/locker",
		                           "/area/crew_quarters/fitness",
		                           "/area/crew_quarters/bar",
		                           "/area/engineering/foyer",
		                           "/area/security/lobby",
		                           "/area/storage/tools",
		                           "/area/storage/primary"
		                           )

/datum/lighting_controller/night/proc/process()
	switch (world.timeofday)
		if (0 < MORNING_LIGHT_RESET)
			if (isactive)
				//announce
				deactivate()

		if (NIGHT_LIGHT_ACTIVE to TICKS_IN_DAY)
			if (!isactive)
				//announce
				activate()

/datum/lighting_controller/night/proc/activate()


/datum/lighting_controller/night/proc/deactivate()