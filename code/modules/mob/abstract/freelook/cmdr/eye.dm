// SYND EYE

/mob/abstract/eye/syndnet
	// Camera eye mob for syndicate networks.
	name = "Inactive Syndicate Eye"
	name_suffix = "Syndicate Eye"

/mob/abstract/eye/syndnet/Initialize()
	. = ..()
	visualnet = syndnet

/mob/abstract/eye/syndnet/proc/toggle_eye(mob/user)
	if (user.eyeobj == src)
		release(user)
		return FALSE
	else
		possess(user)
		return TRUE