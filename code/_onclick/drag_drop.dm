/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	recieving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(!usr || !over)
		return
	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows

	INVOKE_ASYNC(over, TYPE_PROC_REF(/atom, MouseDrop_T), src, usr, src_location, over_location, src_control, over_control, params)

// receive a mousedrop
/atom/proc/MouseDrop_T(atom/dropping, mob/user, src_location, over_location, src_control, over_control, params)
	return