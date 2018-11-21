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

//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	if(istype(adestination))
		destination = adestination
		return 1
	return 0

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return 0
	if(istype(ateleatom))
		teleatom = ateleatom
		return 1
	return 0

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

		if(destturf.density)
			impediment = destturf

		else
			for(var/atom/A in destturf)
				if(A.density)
					impediment = A
					break

		if(impediment)
			var/turf/newdest
			var/boominess = 0
			for(var/turf/T in range(1, destturf))
				if(!T.density)
					for(var/atom/A in T)
						var/blocked = 0
						if(A.density && A.opacity)
							blocked = 1
							break
						if(!blocked)
							newdest = T
							break

			if(istype(teleatom, /obj))
				var/obj/O = teleatom
				if(newdest)
					O.forceMove(newdest)
					O.ex_act(3)
				else
					O.crush_act()
				boominess += O.w_class
				if(O.density)
					boominess += 5
				if(O.opacity)
					boominess += 10

			if(istype(teleatom, /mob/living))
				var/mob/living/L = teleatom
				boominess += L.mob_size/4
				if(istype(L, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = L
					if(newdest)
						var/obj/item/organ/external/E = pick(H.organs)
						to_chat(H, "<span class='danger'>You partially phase into \the [impediment], causing your \the [E] to bloodily dematerialize!</span>")
						E.droplimb(0,DROPLIMB_BLUNT)
						H.forceMove(newdest)
					else
						to_chat(H, "<span class='danger'>Your life flashes before your eyes as you phase into \the [impediment] before the universe suddenly and violently corrects itself!</span>")
						H.gib()
				else
					if(newdest)
						to_chat(L, "<span class='danger'>You partially phase into \the [impediment], causing a chunk of you to bloodily dematerialize!</span>")
						L.adjustBruteLoss(40)
						L.forceMove(newdest)
					else
						to_chat(L, "<span class='danger'>Your life flashes before your eyes as you phase into \the [impediment] before the universe suddenly and violently corrects itself!</span>")
						L.gib()

			if(!newdest)
				boominess += 5

			destturf.visible_message("<span class ='danger'>There is a sizable emission of energy as \the [teleatom] phases into \the [impediment]!</span>")
			explosion(destturf, ((boominess > 10) ? 1 : 0), ((boominess > 5) ? (boominess/5) : 0), boominess/5, boominess/2)

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

	if(!isemptylist(teleatom.search_contents_for(/obj/item/weapon/disk/nuclear)))
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			MM.visible_message("<span class='danger'>\The [MM] bounces off of the portal!</span>","<span class='warning'>Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through.</span>")
		else
			teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
		return 0

	if(destination.z in current_map.admin_levels) //centcomm z-level
		if(istype(teleatom, /obj/mecha))
			var/obj/mecha/MM = teleatom
			MM.occupant << "<span class='danger'>\The [MM] would not survive the jump to a location so far away!</span>"
			return 0
		if(!isemptylist(teleatom.search_contents_for(/obj/item/weapon/storage/backpack/holding)))
			teleatom.visible_message("<span class='danger'>\The [teleatom] bounces off of the portal!</span>")
			return 0


	if(destination.z > max_default_z_level()) //Away mission z-levels
		return 0
	return 1
