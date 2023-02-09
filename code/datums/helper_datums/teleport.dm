//wrapper
/proc/do_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	var/datum/teleport/T = new /datum/teleport/instant/science(arglist(args))
	if(T.stable_creation)
		return TRUE
	return FALSE

/datum/teleport
	var/atom/movable/teleatom //atom to teleport
	var/atom/destination //destination to teleport to
	var/precision = 0 //teleport precision
	var/datum/effect_system/effectin //effect to show right before teleportation
	var/datum/effect_system/effectout //effect to show right after teleportation
	var/soundin //soundfile to play before teleportation
	var/soundout //soundfile to play after teleportation
	var/force_teleport = 1 //if false, teleport will use Move() proc (dense objects will prevent teleportation)
	var/stable_creation = TRUE //This is mostly for portals, which need to delete if the do_teleport fails, due to inhibitors or other reasons we fail to initTeleport properly


/datum/teleport/New(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	..()
	if(!initTeleport(arglist(args)))
		stable_creation = FALSE
		return FALSE
	return TRUE

/datum/teleport/proc/initTeleport(ateleatom,adestination,aprecision,afteleport,aeffectin,aeffectout,asoundin,asoundout)
	if(!setTeleatom(ateleatom))
		return FALSE
	if(!setDestination(adestination))
		return FALSE
	if(!setPrecision(aprecision))
		return FALSE
	setEffects(aeffectin,aeffectout)
	setForceTeleport(afteleport)
	setSounds(asoundin,asoundout)
	return TRUE

//must succeed
/datum/teleport/proc/setPrecision(aprecision)
	if(isnum(aprecision))
		precision = aprecision
		return TRUE
	return FALSE

/datum/teleport/proc/checkInhibitors(atom/adestination)
	if(istype(adestination))
		var/list/turf/good_turfs = list()
		var/list/turf/bad_turfs = list()
		var/turf/T = get_turf(adestination)
		for(var/found_inhibitor in bluespace_inhibitors)
			var/obj/machinery/anti_bluespace/AB = found_inhibitor
			if(T.z != AB.z || get_dist(adestination, AB) > 8 || (AB.stat & (NOPOWER | BROKEN)))
				continue
			AB.use_power_oneoff(AB.active_power_usage)
			bad_turfs += circle_range_turfs(get_turf(AB),8)
			good_turfs += circle_range_turfs(get_turf(AB),9)
		if(length(good_turfs) && length(bad_turfs))
			good_turfs -= bad_turfs
			if(length(good_turfs))
				return pick(good_turfs)

	return adestination

//Check if we're in range of a bluespace inhibitor. We can't be teleported if we are.
/datum/teleport/proc/checkLocalInhibitors(atom/movable/teleportee)
	for(var/obj/machinery/anti_bluespace/AB in range(8, teleportee))
		if(AB.stat & (NOPOWER | BROKEN))
			continue
		else
			AB.use_power_oneoff(AB.active_power_usage)
			return null
	return teleportee


//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	if(istype(adestination))
		destination = checkInhibitors(adestination)
		return TRUE
	return FALSE

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	if(!istype(ateleatom))
		return FALSE

	teleatom = checkLocalInhibitors(ateleatom)
	if(isnull(teleatom))
		return FALSE

	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return FALSE

	return TRUE


//custom effects must be properly set up first for instant-type teleports
//optional
/datum/teleport/proc/setEffects(datum/effect/effect/system/aeffectin=null,datum/effect/effect/system/aeffectout=null)
	effectin = istype(aeffectin) ? aeffectin : null
	effectout = istype(aeffectout) ? aeffectout : null
	return TRUE

//optional
/datum/teleport/proc/setForceTeleport(afteleport)
		force_teleport = afteleport
		return TRUE

//optional
/datum/teleport/proc/setSounds(asoundin=null,asoundout=null)
		soundin = isfile(asoundin) ? asoundin : null
		soundout = isfile(asoundout) ? asoundout : null
		return TRUE

//placeholder
/datum/teleport/proc/teleportChecks()
		return TRUE

/datum/teleport/proc/playSpecials(atom/location,datum/effect_system/effect,sound)
	if(location)
		if(effect)
			spawn(-1)
				src = null
				effect.location = location
				effect.queue()
		if(sound)
			spawn(-1)
				src = null
				playsound(location,sound,60,1)
	return

//do the monkey dance
/datum/teleport/proc/doTeleport()

	var/turf/destturf
	var/turf/curturf = get_turf(teleatom)
	var/area/destarea = get_area(destination)
	if(precision)
		var/list/posturfs = circle_range_turfs(destination,precision)
		destturf = LAZYPICK(posturfs, null)
	else
		destturf = get_turf(destination)

	if(!destturf || !curturf)
		return FALSE

	playSpecials(curturf,effectin,soundin)

	var/obj/structure/bed/stool/chair/C = null
	if(isliving(teleatom))
		var/mob/living/L = teleatom
		if(L.buckled_to)
			C = L.buckled_to

	if(force_teleport)
		teleatom.forceMove(destturf)
		playSpecials(destturf,effectout,soundout)
		var/atom/impediment
		var/valid = 0

		if(destturf.density && destturf != teleatom)
			impediment = destturf

		else
			for(var/atom/movable/A in destturf)
				if(A != teleatom && A.density && A.anchored  && !istype(A, /obj/effect/portal))
					if(A.flags & ON_BORDER)
						if(prob(10))
							impediment = A
							break
					else
						impediment = A
						break

		if(impediment)
			var/turf/newdest
			var/boominess = 0
			for(var/turf/T in range(1, destturf))
				if(!T.density)
					for(var/atom/movable/A in T)
						var/blocked = 0
						if(A.density && A.opacity && A.anchored)
							blocked = 1
							break
						if(!blocked)
							newdest = T
							break




			if(istype(teleatom, /obj) && !istype(teleatom, /obj/effect/portal))
				valid = 1
				var/obj/O = teleatom
				if(newdest)
					O.ex_act(3)

				boominess += max(0, O.w_class - 1)
				if(O.density)
					boominess += 5
				if(O.opacity)
					boominess += 10

			if(istype(teleatom, /mob/living))
				valid = 1
				var/mob/living/L = teleatom
				boominess += L.mob_size/4
				if(!L.incorporeal_move)
					if(istype(L, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = L
						if(newdest)
							var/list/organs_to_gib = list()
							for(var/obj/item/organ/external/ext in H.organs)
								if(!ext.vital) //ensures someone doesn't instantly die, allowing them to slowly die instead
									organs_to_gib.Add(ext)

							if(organs_to_gib.len)
								var/obj/item/organ/external/E = pick(organs_to_gib)
								to_chat(H, "<span class='danger'>You partially phase into \the [impediment], causing your [E.name] to violently dematerialize!</span>")
								H.apply_damage(35, BRUTE, E, 0)

					else
						if(newdest)
							to_chat(L, "<span class='danger'>You partially phase into \the [impediment], causing a chunk of you to violently dematerialize!</span>")
							L.adjustBruteLoss(40)

				else
					newdest = destturf
					valid = 0

			if(valid && newdest)
				destturf.visible_message("<span class ='danger'>There is a sizable emission of energy as \the [teleatom] phases into \the [impediment]!</span>")
				explosion(destturf, ((boominess > 10) ? 1 : 0), ((boominess > 5) ? (boominess/10) : 0), boominess/5, boominess/2)
				teleatom.forceMove(newdest)

			else if(!newdest)
				var/list/turfs_to_teleport = list()
				var/turf/target_turf

				for(var/turf/T in orange(10, get_turf(teleatom)))
					turfs_to_teleport += T
				target_turf = pick(turfs_to_teleport)

				if(target_turf)
					do_teleport(teleatom, target_turf)
				else
					do_teleport(teleatom, get_turf(teleatom))

		else if(istype(teleatom, /mob/living/simple_animal/shade/bluespace))
			var/mob/living/simple_animal/shade/bluespace/BS = teleatom
			for(var/mob/living/L in destturf)
				if(!L.mind && !isvaurca(L))

					if(BS.message_countdown >= 200)
						to_chat(BS, "<span class='notice'><b>You feel relief wash over you as your harried spirit fills into \the [L] like water into a vase.</b></span>")
						BS.mind.transfer_to(L)
						to_chat(L, "<b>You have been restored to a corporeal form. You retain no memories of your time as a bluespace echo, but regardless of your current form the memories of your time before being a bluespace echo are returned.</b>")
						qdel(BS)

					else
						to_chat(BS, "<span class='warning'>You lack the strength of echoes necessary to reattain corporeality in \the [L]!</span>")

					break

	else
		if(teleatom.Move(destturf))
			playSpecials(destturf,effectout,soundout)
	if(C)
		C.forceMove(destturf)

	destarea.Entered(teleatom)

	return TRUE

/datum/teleport/proc/teleport()
	if(teleportChecks())
		return doTeleport()
	return FALSE

/datum/teleport/instant //teleports when datum is created

/datum/teleport/instant/New(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	if(..())
		teleport()
	return


/datum/teleport/instant/science/setEffects(datum/effect/effect/system/aeffectin,datum/effect/effect/system/aeffectout)
	if(!aeffectin || !aeffectout)
		var/datum/effect_system/sparks/aeffect = new(null, FALSE, 5, alldirs)
		effectin = effectin || aeffect
		effectout = effectout || aeffect
		return TRUE
	else
		return ..()

/datum/teleport/instant/science/setPrecision(aprecision)
	..()
	if(istype(teleatom, /obj/item/storage/backpack/holding))
		precision = rand(1,100)

	var/list/bagholding = teleatom.search_contents_for(/obj/item/storage/backpack/holding)
	if(bagholding.len)
		precision = max(rand(1,100)*bagholding.len,100)
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			to_chat(MM, "<span class='danger'>The Bluespace interface on your [teleatom] interferes with the teleport!</span>")
	return TRUE

/datum/teleport/instant/science/teleportChecks()
	if(istype(teleatom, /obj/item/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
		return FALSE


	if(isobserver(teleatom)) // do not teleport ghosts
		return FALSE


	if(!isemptylist(teleatom.search_contents_for(/obj/item/disk/nuclear)))
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			MM.visible_message("<span class='danger'>\The [MM] bounces off of the portal!</span>","<span class='warning'>Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through.</span>")
		else
			teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
		return FALSE

	if(isAdminLevel(destination.z)) //centcomm z-level
		if(!isemptylist(teleatom.search_contents_for(/obj/item/storage/backpack/holding)))
			teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
			return FALSE


	if(destination.z > max_default_z_level()) //Away mission z-levels
		return FALSE
	return TRUE
