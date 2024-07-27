//Helper proc to check if you can hit them or not.
/proc/check_trajectory(atom/target as mob|obj, atom/firer as mob|obj, pass_flags=PASSTABLE|PASSGLASS|PASSGRILLE|PASSRAILING, obj_flags=null, item_flags=null)
	if(!istype(target) || !istype(firer))
		return 0

	var/obj/projectile/test/trace = new /obj/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	if(!isnull(obj_flags))
		trace.obj_flags = obj_flags
	trace.pass_flags = pass_flags

	return trace.launch_projectile(target) //Test it!

/obj/projectile/proc/_check_fire(atom/target as mob, mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, obj_flags)

//"Tracing" projectile
/obj/projectile/test //Used to see if you can hit them.
	invisibility = 101 //Nope!  Can't see me!
	hitscan = TRUE
	nodamage = TRUE
	damage = 0
	var/list/hit = list()

/obj/projectile/test/process_hitscan()
	. = ..()
	if(!QDELING(src))
		qdel(src)
	return hit

/obj/projectile/test/Collide(atom/A)
	if(A != src)
		hit |= A
	return ..()

/obj/projectile/test/attack_mob()
	return
