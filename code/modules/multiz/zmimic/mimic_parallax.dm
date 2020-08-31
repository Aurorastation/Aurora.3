/obj/screen/plane_master/zparallax_master
	appearance_flags = PLANE_MASTER

/obj/screen/plane_master/zparallax_master/New()
	..()
	var/matrix/M = matrix()
	M.Scale(15/16)
	transform = M

/datum/hud/proc/initialize_zparallax()
	var/client/C = mymob.client
	if(!LAZYLEN(C.zparallax_masters))
		for(var/depth in 1 to OPENTURF_MAX_DEPTH)
			var/obj/screen/plane_master/zparallax_master/ZPM = new()
			ZPM.plane = OPENTURF_MAX_PLANE - depth
			LAZYADD(C.zparallax_masters, ZPM)
	C.screen |= C.zparallax_masters
