/**
 * Ctrl click
 */
/mob/proc/CtrlClickOn(atom/A)
	A.CtrlClick(src)

/mob/proc/CtrlShiftClickOn(var/atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(var/mob/user)
	return

/atom/proc/CtrlClick(var/mob/user)
	return

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

/**
 * Ctrl mouse wheel click
 * Except for tagging datumns same as control click (<-- not implemented in Aurora yet)
 */
/mob/proc/CtrlMiddleClickOn(atom/A)
	// if(check_rights_for(client, R_ADMIN))
	// 	client.toggle_tag_datum(A)
	// 	return
	CtrlClickOn(A)
