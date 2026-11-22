/// Called when something is added to a client's screen : /client/proc/add_to_screen(screen_add)
#define COMSIG_CLIENT_SCREEN_ADD "client_screen_add"

/// Called when something is removed from a client's screen : /client/proc/remove_from_screen(screen_remove)
#define COMSIG_CLIENT_SCREEN_REMOVE "client_screen_remove"

/// Requests cursor state evaluation after login/mob transfer or throw-mode changes: ()
#define COMSIG_CLIENT_CURSOR_UPDATE "client_cursor_update"

/// Fired by the Shift key macros: (held)
#define COMSIG_CLIENT_CURSOR_SHIFT "client_cursor_shift"

/// Fired when the client starts a drag or drops its target: (dragging)
#define COMSIG_CLIENT_CURSOR_DRAG "client_cursor_drag"
