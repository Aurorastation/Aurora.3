var/global/list/overmap_sectors =  list()

/proc/is_lemurian_sea_sector()
	return SSatlas.current_sector?.name in list(SECTOR_LEMURIAN_SEA, SECTOR_LEMURIAN_SEA_FAR)
