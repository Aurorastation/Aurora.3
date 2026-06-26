#define GRAB_STOP_MOVE 		BITFLAG(0)	// Stops the grabbed person from moving.
#define GRAB_FORCE_STAND	BITFLAG(1)  // Forces the grabbed person to stand.
#define GRAB_REVERSE_FACING	BITFLAG(2)	// Forces the grabbed person to face away from the assailant.
#define GRAB_SHIELDS_YOU	BITFLAG(3)	// Grabbed person shields the assailant from bullets.
#define GRAB_SHARE_TILE		BITFLAG(4)	// Grabbed person shares the same tile as the assailant.
#define	GRAB_CAN_THROW		BITFLAG(5)	// Grabbed person can be thrown by the grabber.
#define	GRAB_DOWNGRADE_ACT	BITFLAG(6)	// Performing actions while grabbing forces a downgrade.
#define	GRAB_DOWNGRADE_MOVE	BITFLAG(7)	// Movement while grabbing forces a downgrade.
#define	GRAB_FORCE_HARM		BITFLAG(8)	// Grabbed person can be forced to harm themselves.
#define	GRAB_RESTRAINS		BITFLAG(9)	// Grabbed person is restrained, as in handcuffs.
#define GRAB_BLOCK_RESIST	BITFLAG(10)	// Grabbed person cannot cause a grab downgrade by resisting.
#define GRAB_CAN_KILL		BITFLAG(11) // Basically just means "is this GRAB_KILL" under the old system. Allows you to do things that will Definitely Kill People.
#define GRAB_FORCE_LYING	BITFLAG(12) // Opposite of GRAB_FORCE_STAND, forces the grabbed person to be lying down.
#define GRAB_WIELDED		BITFLAG(13) // Grab made up of 2 or more grabs. Ignores checks for already having a grab on someone.
#define GRAB_WALK_FORWARD	BITFLAG(14) // Basically you don't moonwalk if this is set

/// equivalent of /obj/item/grab/proc/has_grab_flags, but without proc overhead for hot procs like canmove
#define HAS_GRAB_FLAGS(GRABOBJ, GRABFLAGS)	(GRABOBJ.current_grab.grab_flags & GRABFLAGS)
