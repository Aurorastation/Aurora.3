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
