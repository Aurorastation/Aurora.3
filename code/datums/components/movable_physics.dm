/// Delete the component once all movement has stopped.
#define MOVABLE_PHYSICS_QDEL_WHEN_STOPPED (1<<0)

/// Gives a movable lightweight visual motion across turfs using pixel offsets.
/datum/component/movable_physics
	// pixel_x and pixel_y form the horizontal plane; "vertical" here means height on pixel_z.
	/// Horizontal velocity, in pixels per second.
	var/vector/horizontal_velocity
	/// Vertical speed, in pixels per second.
	var/vertical_velocity
	/// Horizontal deceleration, in pixels per second squared.
	var/horizontal_friction
	/// Downward acceleration, in pixels per second squared.
	var/z_gravity
	/// The pixel height treated as the floor.
	var/z_floor
	/// Direction of horizontal movement in trigonometric degrees.
	var/angle_of_movement
	/// Optional component behavior flags.
	var/physics_flags
	/// The parent's movement animation setting before physics began.
	var/cached_animate_movement
	/// Sound played when the parent bounces off the floor.
	var/bounce_sound
	/// Whether this component is currently moving its parent.
	var/is_moving = FALSE

/datum/component/movable_physics/Initialize(_horizontal_velocity = 0, _vertical_velocity = 0, _horizontal_friction = 0, _z_gravity = 0, _z_floor = 0, _angle_of_movement = 0, _physics_flags = 0, _bounce_sound)
	. = ..()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	angle_of_movement = normalize_angle(_angle_of_movement)
	horizontal_velocity = vector(_horizontal_velocity * cos(angle_of_movement), _horizontal_velocity * sin(angle_of_movement))
	vertical_velocity = _vertical_velocity
	horizontal_friction = _horizontal_friction
	z_gravity = _z_gravity
	z_floor = _z_floor
	physics_flags = _physics_flags
	bounce_sound = _bounce_sound

	if(vertical_velocity || horizontal_velocity.size)
		start_movement()

/datum/component/movable_physics/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_IMPACT, PROC_REF(on_throw_impact), override = TRUE)

/datum/component/movable_physics/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_IMPACT)
	stop_movement(FALSE)

/// Starts processing visual movement.
/datum/component/movable_physics/proc/start_movement()
	if(is_moving)
		return

	var/atom/movable/moving_atom = parent
	cached_animate_movement = moving_atom.animate_movement
	moving_atom.animate_movement = NO_STEPS
	is_moving = TRUE
	START_PROCESSING(SSmovable_physics, src)
	moving_atom.SpinAnimation(speed = 1 SECOND, loops = 2)

/// Stops processing and restores the parent's normal movement animation.
/datum/component/movable_physics/proc/stop_movement(delete_if_finished = TRUE)
	if(!is_moving)
		return

	var/atom/movable/moving_atom = parent
	moving_atom.animate_movement = cached_animate_movement
	is_moving = FALSE
	STOP_PROCESSING(SSmovable_physics, src)
	if(delete_if_finished && (physics_flags & MOVABLE_PHYSICS_QDEL_WHEN_STOPPED))
		qdel(src)

/datum/component/movable_physics/proc/on_throw_impact(datum/source, atom/hit_atom, datum/thrownthing/throwing_datum)
	SIGNAL_HANDLER

	var/atom/movable/moving_atom = source
	if(throwing_datum?.target_turf)
		ricochet(90 - get_angle(moving_atom, throwing_datum.target_turf))

/datum/component/movable_physics/proc/bounce_off_floor(atom/movable/moving_atom)
	var/new_angle = normalize_angle(angle_of_movement + rand(-3000, 3000) / 100)
	horizontal_velocity.Turn(angle_of_movement - new_angle)
	angle_of_movement = new_angle
	if(bounce_sound)
		playsound(moving_atom, bounce_sound, 50, TRUE)
	moving_atom.SpinAnimation(speed = 0.5 SECONDS, loops = 1)
	moving_atom.pixel_z = z_floor
	horizontal_velocity.size = max(0, horizontal_velocity.size - (vertical_velocity * 0.8))
	vertical_velocity = max(0, ((vertical_velocity * -0.8) - 4))

/datum/component/movable_physics/proc/ricochet(bounce_angle)
	var/new_angle = normalize_angle((180 - bounce_angle) - angle_of_movement)
	horizontal_velocity.Turn(angle_of_movement - new_angle)
	angle_of_movement = new_angle

/datum/component/movable_physics/proc/normalize_angle(angle)
	return SIMPLIFY_DEGREES(angle)

/datum/component/movable_physics/process(seconds_per_tick)
	var/atom/movable/moving_atom = parent
	if(horizontal_velocity.size <= 0 && moving_atom.pixel_z <= z_floor && vertical_velocity <= 0)
		horizontal_velocity.size = 0
		vertical_velocity = 0
		moving_atom.pixel_z = z_floor
		stop_movement()
		return PROCESS_KILL

	moving_atom.pixel_x += horizontal_velocity.x * seconds_per_tick
	moving_atom.pixel_y += horizontal_velocity.y * seconds_per_tick
	horizontal_velocity.size = max(0, horizontal_velocity.size - (horizontal_friction * seconds_per_tick))

	moving_atom.pixel_z = max(z_floor, moving_atom.pixel_z + (vertical_velocity * seconds_per_tick))
	if(moving_atom.pixel_z > z_floor)
		vertical_velocity -= z_gravity * seconds_per_tick
	else if(vertical_velocity < 0)
		bounce_off_floor(moving_atom)

	if(moving_atom.pixel_x > 16)
		if(moving_atom.Move(get_step(moving_atom, EAST)))
			moving_atom.pixel_x = -16
		else
			moving_atom.pixel_x = 16
			ricochet(0)
		return

	if(moving_atom.pixel_x < -16)
		if(moving_atom.Move(get_step(moving_atom, WEST)))
			moving_atom.pixel_x = 16
		else
			moving_atom.pixel_x = -16
			ricochet(0)
		return

	if(moving_atom.pixel_y > 16)
		if(moving_atom.Move(get_step(moving_atom, NORTH)))
			moving_atom.pixel_y = -16
		else
			moving_atom.pixel_y = 16
			ricochet(180)
		return

	if(moving_atom.pixel_y < -16)
		if(moving_atom.Move(get_step(moving_atom, SOUTH)))
			moving_atom.pixel_y = 16
		else
			moving_atom.pixel_y = -16
			ricochet(180)
