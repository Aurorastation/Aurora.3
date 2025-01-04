// mouse signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument


///from base of atom/MouseDrop(): (/atom/over, /mob/user)
#define COMSIG_MOUSEDROP_ONTO "mousedrop_onto"
	#define COMPONENT_CANCEL_MOUSEDROP_ONTO (1<<0)
///from base of atom/handle_mouse_drop_receive: (/atom/from, /mob/user)
#define COMSIG_MOUSEDROPPED_ONTO "mousedropped_onto"
	#define COMPONENT_CANCEL_MOUSEDROPPED_ONTO (1<<0)
