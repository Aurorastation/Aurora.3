// A set of constants used to determine which type of mute an admin wishes to apply.
// Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO, etc. = (MUTE_Ito_chat(C, 1))
// Therefore there needs to be a gap between the flags for the automute flags.
#define MUTE_IC        0x1
#define MUTE_OOC       0x2
#define MUTE_PRAY      0x4
#define MUTE_ADMINHELP 0x8
#define MUTE_DEADCHAT  0x10
#define MUTE_AOOC      0x20
#define MUTE_ALL       0xFFFF

// Number of identical messages required to get the spam-prevention auto-mute thing to trigger warnings and automutes.
#define SPAM_TRIGGER_WARNING  5
#define SPAM_TRIGGER_AUTOMUTE 10

// Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME 6000 // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

// Admin permissions.
#define R_BUILDMODE      BITFLAG(0)
#define R_ADMIN          BITFLAG(1)
#define R_BAN            BITFLAG(2)
#define R_FUN            BITFLAG(3)
#define R_SERVER         BITFLAG(4)
#define R_DEBUG          BITFLAG(5)
#define R_POSSESS        BITFLAG(6)
#define R_PERMISSIONS    BITFLAG(7)
#define R_STEALTH        BITFLAG(8)
#define R_REJUVENATE     BITFLAG(9)
#define R_VAREDIT        BITFLAG(10)
#define R_SOUNDS         BITFLAG(11)
#define R_SPAWN          BITFLAG(12)
#define R_MOD            BITFLAG(13)
#define R_DEV            BITFLAG(14)
#define R_CCIAA          BITFLAG(15) //higher than this will overflow

#define R_MAXPERMISSION 0x8000 // This holds the maximum value for a permission. It is used in iteration, so keep it updated.
#define R_ALL           0x7FFF // All perms forever.

// ticket statuses
#define TICKET_CLOSED   0
#define TICKET_OPEN     1
#define TICKET_ASSIGNED 2

// adminhelp status
#define NOT_ADMINHELPED     0
#define ADMINHELPED         1
#define ADMINHELPED_DISCORD 2

#define STICKYBAN_DB_CACHE_TIME (10 SECONDS)
#define STICKYBAN_ROGUE_CHECK_TIME 5

#define ADMIN_JMP(src) "(<a href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)"
#define COORD(src) "[src ? src.Admin_Coordinates_Readable() : "nonexistent location"]"
#define AREACOORD(src) "[src ? src.Admin_Coordinates_Readable(TRUE) : "nonexistent location"]"
