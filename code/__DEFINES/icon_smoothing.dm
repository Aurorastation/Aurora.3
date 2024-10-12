/* smoothing_flags */
///Do not smooth
#define SMOOTH_FALSE			BITFLAG(0)
///Smooths with exact specified types or just itself
#define SMOOTH_TRUE				BITFLAG(1)
///Smooths with all subtypes of specified types or just itself (this value can replace SMOOTH_TRUE)
#define SMOOTH_MORE				BITFLAG(2)
///If atom should smooth diagonally, this should be present in 'smooth' var
#define SMOOTH_DIAGONAL			BITFLAG(3)
///Atom will smooth with the borders of the map
#define SMOOTH_BORDER			BITFLAG(4)
///Atom is currently queued to smooth.
#define SMOOTH_QUEUED			BITFLAG(5)
///Don't clear the atom's icon_state on smooth.
#define SMOOTH_NO_CLEAR_ICON	BITFLAG(6)
///Add underlays, detached from diagonal smoothing.
#define SMOOTH_UNDERLAYS		BITFLAG(7)

#define USES_SMOOTHING (SMOOTH_TRUE|SMOOTH_MORE)

//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH	2
#define N_SOUTH	4
#define N_EAST	16
#define N_WEST	256
#define N_NORTHEAST	32
#define N_NORTHWEST	512
#define N_SOUTHEAST	64
#define N_SOUTHWEST	1024


#define QUEUE_SMOOTH(thing_to_queue) if(thing_to_queue.smoothing_flags & USES_SMOOTHING){SSicon_smooth.add_to_queue(thing_to_queue)}

#define QUEUE_SMOOTH_NEIGHBORS(thing_to_queue) for(var/atom/atom_neighbor as anything in orange(1, thing_to_queue)) {QUEUE_SMOOTH(atom_neighbor)}
