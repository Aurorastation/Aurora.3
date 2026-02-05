GLOBAL_VAR_INIT(maze_cell_count, 0)

/datum/maze_cell
	var/name
	var/uid
	var/x
	var/y
	var/ox
	var/oy

/datum/maze_cell/New(var/nx,var/ny,var/nox,var/noy)
	GLOB.maze_cell_count++
	uid = GLOB.maze_cell_count
	name = "cell #[uid]"
	x = nx
	y = ny
	ox = nox
	oy = noy
