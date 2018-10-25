var/global/allowproyspawn = 0
/area/proyoutpost/Initialize(mapload)
	. = ..()
	if (mapload)
		var/global/allowproyspawn = 1


