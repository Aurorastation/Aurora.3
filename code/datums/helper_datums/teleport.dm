//wrapper
/proc/do_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	new /datum/teleport/instant/science(arglist(args))
	return

/datum/teleport
	var/atom/movable/teleatom //atom to teleport
	var/atom/destination //destination to teleport to
	var/precision = 0 //teleport precision
	var/datum/effect_system/effectin //effect to show right before teleportation
	var/datum/effect_system/effectout //effect to show right after teleportation
	var/soundin //soundfile to play before teleportation
	var/soundout //soundfile to play after teleportation
	var/force_teleport = 1 //if false, teleport will use Move() proc (dense objects will prevent teleportation)


/datum/teleport/New(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	..()
	if(!initTeleport(arglist(args)))
		return 0
	return 1

/datum/teleport/proc/initTeleport(ateleatom,adestination,aprecision,afteleport,aeffectin,aeffectout,asoundin,asoundout)
	if(!setTeleatom(ateleatom))
		return 0
	if(!setDestination(adestination))
		return 0
	if(!setPrecision(aprecision))
		return 0
	setEffects(aeffectin,aeffectout)
	setForceTeleport(afteleport)
	setSounds(asoundin,asoundout)
	return 1

//must succeed
/datum/teleport/proc/setPrecision(aprecision)
	if(isnum(aprecision))
		precision = aprecision
		return 1
	return 0

/datum/teleport/proc/checkInhibitors(atom/adestination)
	if(istype(adestination))
		var/list/turf/good_turfs = list()
		var/list/turf/bad_turfs = list()
		for(var/found_inhibitor in circlerange(adestination,8))
			if(!istype(found_inhibitor,/obj/machinery/anti_bluespace))
				continue
			var/obj/machinery/anti_bluespace/AB = found_inhibitor
			if(AB.stat & (NOPOWER | BROKEN) )
				continue
			AB.use_power(AB.active_power_usage)
			bad_turfs += circlerangeturfs(get_turf(AB),8)
			good_turfs += circlerangeturfs(get_turf(AB),9)
		if(good_turfs.len && bad_turfs.len)
			good_turfs -= bad_turfs
			return pick(good_turfs)

	return adestination

//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	if(istype(adestination))
		destination = checkInhibitors(adestination)
		return 1
	return 0

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	if(!istype(ateleatom))
		return 0

	teleatom = checkInhibitors(ateleatom)
	if(isturf(teleatom))
		var/turf/T = teleatom
		var/atom/valid_atoms = list()
		for(var/atom/movable in T)
			valid_atoms += T
		ateleatom = pick(valid_atoms)

	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return 0

	return 1


//custom effects must be properly set up first for instant-type teleports
//optional
/datum/teleport/proc/setEffects(datum/effect/effect/system/aeffectin=null,datum/effect/effect/system/aeffectout=null)
	effectin = istype(aeffectin) ? aeffectin : null
	effectout = istype(aeffectout) ? aeffectout : null
	return 1

//optional
/datum/teleport/proc/setForceTeleport(afteleport)
		force_teleport = afteleport
		return 1

//optional
/datum/teleport/proc/setSounds(asoundin=null,asoundout=null)
		soundin = isfile(asoundin) ? asoundin : null
		soundout = isfile(asoundout) ? asoundout : null
		return 1

//placeholder
/datum/teleport/proc/teleportChecks()
		return 1

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
		var/list/posturfs = circlerangeturfs(destination,precision)
		destturf = safepick(posturfs)
	else
		destturf = get_turf(destination)

	if(!destturf || !curturf)
		return 0

	playSpecials(curturf,effectin,soundin)

	var/obj/structure/bed/chair/C = null
	if(isliving(teleatom))
		var/mob/living/L = teleatom
		if(L.buckled)
			C = L.buckled

	if(force_teleport)
		teleatom.forceMove(destturf)
		playSpecials(destturf,effectout,soundout)
		var/atom/impediment
		var/valid = 0

		if(destturf.density && destturf != teleatom)
			impediment = destturf

		else
			for(var/atom/movable/A in destturf)
				if(A != teleatom && A.density && A.anchored)
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




			if(istype(teleatom, /obj))
				valid = 1
				var/obj/O = teleatom
				if(newdest)
					O.ex_act(3)

				boominess += max(0, O.w_class - 1)
				if(O.density)
					boominess += 5
				if(O.opacity)
					boominess += 10

			if(istype(teleatom, /obj/mecha))
				valid = 1
				var/obj/mecha/M = teleatom
				if(istype(M, /obj/mecha))
					var/obj/mecha/T = M
					if(newdest)
						M.ex_act(3)
						T.occupant.adjustHalLoss(25)
						to_chat(T.occupant, "<span class='danger'>You feel a sharp abdominal pain inside yourself as the [teleatom] phases into \the [impediment]</span>")

					boominess += max(0, M.w_class - 1)
					if(M.density)
						boominess += 5
					if(M.opacity)
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
								E.droplimb(0,DROPLIMB_BLUNT)

					else
						if(newdest)
							to_chat(L, "<span class='danger'>You partially phase into \the [impediment], causing a chunk of you to violently dematerialize!</span>")
							L.adjustBruteLoss(40)

					if(!newdest && L.mind)
						var/mob/living/simple_animal/shade/bluespace/BS = new /mob/living/simple_animal/shade/bluespace(destturf)
						to_chat(L, "<span class='danger'>You feel your spirit violently rip from your body in a flurry of violent extradimensional disarray!</span>")
						L.mind.transfer_to(BS)
						to_chat(BS, "<b>You are now a bluespace echo - consciousness imprinted upon wavelengths of bluespace energy. You currently retain no memories of your previous life, but do express a strong desire to return to corporeality. You will die soon, fading away forever. Good luck!</b>")
						BS.original_body = L

						var/list/turfs_to_teleport = list()
						for(var/turf/T in orange(20, get_turf(BS)))
							turfs_to_teleport += T
						do_teleport(BS, pick(turfs_to_teleport))

						for(var/mob/living/M in L)
							if(M.mind)
								var/mob/living/simple_animal/shade/bluespace/more_BS = new /mob/living/simple_animal/shade/bluespace(get_turf(M))
								to_chat(M, "<span class='danger'>You feel your spirit violently rip from your body in a flurry of violent extradimensional disarray!</span>")
								M.mind.transfer_to(more_BS)
								to_chat(more_BS, "<b>You are now a bluespace echo - consciousness imprinted upon wavelengths of bluespace energy. You currently retain no memories of your previous life, but do express a strong desire to return to corporeality. You will die soon, fading away forever. Good luck!</b>")
								more_BS.original_body = M

								for(var/turf/T in orange(20, get_turf(BS)))
									turfs_to_teleport += T
								do_teleport(more_BS, pick(turfs_to_teleport))

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

	return 1

/datum/teleport/proc/teleport()
	if(teleportChecks())
		return doTeleport()
	return 0

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
		return 1
	else
		return ..()

/datum/teleport/instant/science/setPrecision(aprecision)
	..()
	if(istype(teleatom, /obj/item/weapon/storage/backpack/holding))
		precision = rand(1,100)

	var/list/bagholding = teleatom.search_contents_for(/obj/item/weapon/storage/backpack/holding)
	if(bagholding.len)
		precision = max(rand(1,100)*bagholding.len,100)
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			MM << "<span class='danger'>The Bluespace interface on your [teleatom] interferes with the teleport!</span>"
	return 1

/datum/teleport/instant/science/teleportChecks()
	if(istype(teleatom, /obj/item/weapon/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
		return 0

	
	if(isobserver(teleatom)) // do not teleport ghosts
		return 0


	if(!isemptylist(teleatom.search_contents_for(/obj/item/weapon/disk/nuclear)))
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			MM.visible_message("<span class='danger'>\The [MM] bounces off of the portal!</span>","<span class='warning'>Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through.</span>")
		else
			teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
		return 0

	if(destination.z in current_map.admin_levels) //centcomm z-level

		if(!isemptylist(teleatom.search_contents_for(/obj/item/weapon/storage/backpack/holding)))
			teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
			return 0


	if(destination.z > max_default_z_level()) //Away mission z-levels
		return 0
	return 1
