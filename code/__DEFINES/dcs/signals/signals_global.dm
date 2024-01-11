// Global signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

/// called post /obj/item initialize (obj/item/created_item)
#define COMSIG_GLOB_ATOM_AFTER_POST_INIT "!atom_after_post_init"
