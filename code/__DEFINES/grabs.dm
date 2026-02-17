#define GRAB_STOP_MOVE 		BITFLAG(0)	// Stops the grabbed person from moving.
#define GRAB_FORCE_STAND	BITFLAG(1)  // Forces the grabbed person to stand.
#define GRAB_REVERSE_FACING	BITFLAG(2)	// Forces the grabbed person to face away from the assailant.
#define GRAB_LING_ABSORB	BITFLAG(3)	// Grab is strong enough to allow a changeling to absorb.
#define GRAB_SHIELDS_YOU	BITFLAG(4)	// Grabbed person shields the assailant from bullets.
#define GRAB_SHARE_TILE		BITFLAG(5)	// Grabbed person shares the same tile as the assailant.
#define	GRAB_LADDER_CARRY	BITFLAG(6)	// Grabbed person can be carried up and down ladders.
#define	GRAB_CAN_THROW		BITFLAG(7)	// Grabbed person can be thrown by the grabber.
#define	GRAB_DOWNGRADE_ACT	BITFLAG(8)	// Performing actions while grabbing forces a downgrade.
#define	GRAB_DOWNGRADE_MOVE	BITFLAG(9)	// Movement while grabbing forces a downgrade.
#define	GRAB_FORCE_HARM		BITFLAG(10)	// Grabbed person can be forced to harm themselves.
#define	GRAB_RESTRAINS		BITFLAG(11)	// Grabbed person is restrained, as in handcuffs.
#define GRAB_BLOCK_RESIST	BITFLAG(12)	// Grabbed person cannot cause a grab downgrade by resisting.
#define GRAB_CAN_SELFGRAB	BITFLAG(13)	// You can grab yourself.
#define GRAB_CAN_KILL		BITFLAG(14) // Basically just means "is this GRAB_KILL" under the old system. Allows you to do things that will Definitely Kill People.

#define HAS_GRAB_FLAGS(GRABOBJ, GRABFLAGS)	(GRABOBJ.current_grab.grab_flags & GRABFLAGS)
