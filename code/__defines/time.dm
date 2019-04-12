#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define HOUR *36000
#define HOURS *36000

#define DAY *864000
#define DAYS *864000


#define TICKS *world.tick_lag

#define DS2TICKS(DS) (DS/world.tick_lag)

#define TICKS2DS(T) (T TICKS)

//Timing subsystem
//Don't run if there is an identical unique timer active
//if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer, and returns the id of the existing timer
#define TIMER_UNIQUE			(1<<0)
//For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE			(1<<1)
//Timing should be based on how timing progresses on clients, not the sever.
//	tracking this is more expensive,
//	should only be used in conjuction with things that have to progress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME		(1<<2)
//Timer can be stopped using deltimer()
#define TIMER_STOPPABLE			(1<<3)
//To be used with TIMER_UNIQUE
//prevents distinguishing identical timers with the wait variable
#define TIMER_NO_HASH_WAIT		(1<<4)
//Loops the timer repeatedly until qdeleted
//In most cases you want a subsystem instead
#define TIMER_LOOP				(1<<5)

//added this so sound system would work, i didnt want to touch anything incase anything would break -wezzy