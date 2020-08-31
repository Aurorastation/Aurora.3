/obj/screen/plane_master/zparallax_master
	appearance_flags = PLANE_MASTER
	var/scale = 1.0

/obj/screen/plane_master/zparallax_master/New()
	..()
	update_scale()

/obj/screen/plane_master/zparallax_master/proc/update_scale()
	var/matrix/M = matrix()
	M.Scale(scale)
	transform = M

/datum/hud/proc/initialize_zparallax()
	var/client/C = mymob.client
	if(!LAZYLEN(C.zparallax_masters))
		for(var/depth in 0 to OPENTURF_MAX_DEPTH)
			var/obj/screen/plane_master/zparallax_master/ZPM = new()
			ZPM.plane = OPENTURF_MAX_PLANE - depth
			ZPM.scale = (15-depth)/16
			ZPM.update_scale()
			LAZYADD(C.zparallax_masters, ZPM)
	C.screen |= C.zparallax_masters
