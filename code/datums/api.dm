//
// This file contains the API functions for the serverside API
//

//Init the API at startup
/hook/startup/proc/setup_api()
  for (var/path in typesof(/datum/topic_command) - /datum/topic_command)
    var/datum/topic_command/A = new path()
    topic_commands[A.name] = A

  return 1

//API Boilerplate
/datum/topic_command
  var/name = null
  var/statuscode = null
  var/response = null
  var/data = null
/datum/topic_command/proc/run_command(queryparams)
  return 1

//Ping Test
/datum/topic_command/ping
  name = "ping"
/datum/topic_command/ping/run_command(queryparams)
  var/x = 1
  for (var/client/C)
    x++
  statuscode = "200"
  response = "Pong"
  data = x
  return 1

//Player Count
/datum/topic_command/count_players
  name = "count_players"
/datum/topic_command/count_players/run_command(queryparams)
  var/n = 0
  for(var/mob/M in player_list)
    if(M.client)
      n++

  statuscode = "200"
  response = "Player count fetched"
  data = n
  return 1

//Admin Count
/datum/topic_command/count_admin
  name = "count_admin"
/datum/topic_command/count_admin/run_command(queryparams)
  var/n = 0
  for (var/client/client in clients)
    if (client.holder && client.holder.rights & (R_ADMIN))
      n++

  statuscode = "200"
  response = "Admin count fetched"
  data = n
  return 1

//Mod Count
/datum/topic_command/count_mod
  name = "count_mod"
/datum/topic_command/count_mod/run_command(queryparams)
  var/n = 0
  for (var/client/client in clients)
    if (client.holder && (client.holder.rights & R_MOD) && !(client.holder.rights & R_ADMIN))
      n++

  statuscode = "200"
  response = "Mod count fetched"
  data = n
  return 1

//CCIA Count
/datum/topic_command/count_ccia
  name = "count_ccia"
/datum/topic_command/count_ccia/run_command(queryparams)
  var/n = 0
  for (var/client/client in clients)
    if (client.holder && (client.holder.rights & R_CCIAA) && !(client.holder.rights & R_ADMIN))
      n++

  statuscode = "200"
  response = "CCIA count fetched"
  data = n
  return 1

//Player Ckeys
/datum/topic_command/player_list_ckey
  name = "player_list_ckey"
/datum/topic_command/player_list_ckey/run_command(queryparams)
  var/list/players = list()
  for (var/client/C in clients)
    players += C.key

  statuscode = "200"
  response = "Player list fetched"
  data = players
  return 1

//Char Names
/datum/topic_command/char_list
  name = "char_list"
/datum/topic_command/char_list/run_command(queryparams)
  if (!ticker)
    statuscode = "500"
    response = "Game not started yet!"
    return 1

  var/list/chars = list()

  var/list/mobs = sortmobs()
  for(var/mob/M in mobs)
    if(!M.ckey) continue
    chars[M.name] += M.key ? (M.client ? M.key : "[M.key] (DC)") : "No key"

  statuscode = "200"
  response = "Char list fetched"
  data = chars
  return 1

// Crew Manifest
/datum/topic_command/manifest
  name = "manifest"
/datum/topic_command/manifest/run_command(queryparams)
  if (!ticker)
    statuscode = "500"
    response = "Game not started yet!"
    return 1

  var/list/positions = list()
  var/list/set_names = list(
      "heads" = command_positions,
      "sec" = security_positions,
      "eng" = engineering_positions,
      "med" = medical_positions,
      "sci" = science_positions,
      "civ" = civilian_positions,
      "bot" = nonhuman_positions
    )

  for(var/datum/data/record/t in data_core.general)
    var/name = t.fields["name"]
    var/rank = t.fields["rank"]
    var/real_rank = make_list_rank(t.fields["real_rank"])

    var/department = 0
    for(var/k in set_names)
      if(real_rank in set_names[k])
        if(!positions[k])
          positions[k] = list()
        positions[k][name] = rank
        department = 1
    if(!department)
      if(!positions["misc"])
        positions["misc"] = list()
      positions["misc"][name] = rank

  // for(var/k in positions)
  //   positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"

  statuscode = "200"
  response = "Manifest fetched"
  data = positions
  return 1

//Get a Staff List
/datum/topic_command/stafflist
  name = "stafflist"
/datum/topic_command/stafflist/run_command(queryparams)
  var/list/staff = list()
  for (var/client/C in admins)
    staff[C] = C.holder.rank

  statuscode = "200"
  response = "Staff list fetched"
  data = staff
  return 1

//Get Server Status
/datum/topic_command/serverstatus
  name = "serverstatus"
/datum/topic_command/serverstatus/run_command(queryparams)
  var/list/s[] = list()
  s["version"] = game_version
  s["mode"] = master_mode
  s["respawn"] = config.abandon_allowed
  s["enter"] = config.enter_allowed
  s["vote"] = config.allow_vote_mode
  s["ai"] = config.allow_ai
  s["host"] = host ? host : null
  s["players"] = 0
  s["stationtime"] = worldtime2text()
  s["roundduration"] = round_duration()

  if(queryparams["status"] == "2")
    var/list/players = list()
    var/list/admins = list()

    for(var/client/C in clients)
      if(C.holder)
        if(C.holder.fakekey)
          continue
        admins[C.key] = C.holder.rank
      players += C.key

    s["players"] = players.len
    s["playerlist"] = list2params(players)
    s["admins"] = admins.len
    s["adminlist"] = list2params(admins)
  else
    var/n = 0
    var/admins = 0

    for(var/client/C in clients)
      if(C.holder)
        if(C.holder.fakekey)
          continue	//so stealthmins aren't revealed by the hub
        admins++
      s["player[n]"] = C.key
      n++

    s["players"] = n
    s["admins"] = admins

  statuscode = "200"
  response = "Server Status fetched"
  data = s
  return 1

//Get info about a specific player
/datum/topic_command/playerinfo
  name = "playerinfo"
/datum/topic_command/playerinfo/run_command(queryparams)

  var/list/search = params2list(queryparams["search"])
  if(isnull(search))
    statuscode = "400"
    response = "search parameter not supplied"
    return 1

  var/list/ckeysearch = list()
  for(var/text in search)
    ckeysearch += ckey(text)

  var/list/match = list()

  for(var/mob/M in mob_list)
    var/strings = list(M.name, M.ckey)
    if(M.mind)
      strings += M.mind.assigned_role
      strings += M.mind.special_role
    for(var/text in strings)
      if(ckey(text) in ckeysearch)
        match[M] += 10 // an exact match is far better than a partial one
      else
        for(var/searchstr in search)
          if(findtext(text, searchstr))
            match[M] += 1

  var/maxstrength = 0
  for(var/mob/M in match)
    maxstrength = max(match[M], maxstrength)
  for(var/mob/M in match)
    if(match[M] < maxstrength)
      match -= M

  if(!match.len)
    statuscode = "449"
    response = "No match found"
    return 1
  else if(match.len == 1)
    var/mob/M = match[1]
    var/info = list()
    info["key"] = M.key
    if (M.client)
      var/client/C = M.client
      info["discordmuted"] = C.mute_discord ? "Yes" : "No"
    info["name"] = M.name == M.real_name ? M.name : "[M.name] ([M.real_name])"
    info["role"] = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind"
    var/turf/MT = get_turf(M)
    info["loc"] = M.loc ? "[M.loc]" : "null"
    info["turf"] = MT ? "[MT] @ [MT.x], [MT.y], [MT.z]" : "null"
    info["area"] = MT ? "[MT.loc]" : "null"
    info["antag"] = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind"
    info["hasbeenrev"] = M.mind ? M.mind.has_been_rev : "No mind"
    info["stat"] = M.stat
    info["type"] = M.type
    if(isliving(M))
      var/mob/living/L = M
      info["damage"] = list2params(list(
            oxy = L.getOxyLoss(),
            tox = L.getToxLoss(),
            fire = L.getFireLoss(),
            brute = L.getBruteLoss(),
            clone = L.getCloneLoss(),
            brain = L.getBrainLoss()
          ))
    else
      info["damage"] = "non-living"
    info["gender"] = M.gender
    statuscode = "200"
    response = "Client data fetched"
    data = info
    return 1
  else
    statuscode = "449"
    response = "Multiple Matches found"
    return 1


//Send a Command Report
/datum/topic_command/sendcommandreport
  name = "sendcommandreport"
/datum/topic_command/sendcommandreport/run_command(queryparams)
  var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
  var/reporttitle = sanitizeSafe(queryparams["title"]) //Title of the report
  var/reportbody = sanitize(queryparams["body"]) //Body of the report
  var/reporttype = queryparams["type"] //Type of the report: freeform / ccia / admin
  var/reportsender = sanitize(queryparams["sendername"]) //Name of the sender
  var/reportannounce = queryparams["announce"] //Announce the contents report to the public: 1 / 0

  if(!senderkey)
    statuscode = "400"
    response = "Parameter senderkey not set"
    return 1
  if(!reportbody)
    statuscode = "400"
    response = "Parameter reportbody not set"
    return 1
  if(!reporttitle)
    reporttitle = "NanoTrasen Update"
  if(!reporttype)
    reporttype = "freeform"
  if(!reportannounce)
    reportannounce = 1

  //Send the message to the communications consoles
  for (var/obj/machinery/computer/communications/C in machines)
    if(! (C.stat & (BROKEN|NOPOWER) ) )
      var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( C.loc )
      P.name = "[command_name()] Update"
      P.info = replacetext(reportbody, "\n", "<br/>")
      P.update_space(P.info)
      P.update_icon()
      C.messagetitle.Add("[command_name()] Update")
      C.messagetext.Add(P.info)

  //Set the report footer for CCIA Announcements
  if (reporttype == "ccia")
    if (reportsender)
      reportbody += "<br/><br/>- [reportsender], Central Command Internal Affairs Agent, [commstation_name()]"
    else
      reportbody += "<br/><br/>- CCIAAMS, [commstation_name()]"

  if(reportannounce == 1)
    command_announcement.Announce(reportbody, reporttitle, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
  if(reportannounce == 0)
    world << "\red New NanoTrasen Update available at all communication consoles."
    world << sound('sound/AI/commandreport.ogg')


  log_admin("[senderkey] has created a command report via the api: [reportbody]")
  message_admins("[senderkey] has created a command report via the api", 1)
  feedback_add_details("admin_verb","CCR")

  statuscode = "200"
  response = "Command Report sent"
  return 1


//Get available Fax Machines
/datum/topic_command/getfaxmachines
  name = "getfaxmachines"
/datum/topic_command/getfaxmachines/run_command(queryparams)
  var/list/faxlocations = list()

  for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
    faxlocations.Add(F.department)

  statuscode = "200"
  response = "Fax machines fetched"
  data = faxlocations
  return 1

//Send Fax
/datum/topic_command/sendfax
  name = "sendfax"
/datum/topic_command/sendfax/run_command(queryparams)
  var/list/responselist = list()
  var/list/sendsuccess = list()
  var/list/targetlist = queryparams["target"] //Target locations where the fax should be sent to
  var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
  var/faxtitle = sanitizeSafe(queryparams["title"]) //Title of the report
  var/faxbody = sanitize(queryparams["body"]) //Body of the report
  var/faxsender = sanitize(queryparams["sendername"]) //Name of the sender
  var/faxannounce = queryparams["announce"] //Announce the contents report to the public: 1 / 0

  if(!targetlist || targetlist.len < 1)
    statuscode = "400"
    response = "Parameter target not set"
    return 1
  if(!senderkey)
    statuscode = "400"
    response = "Parameter senderkey not set"
    return 1
  if(!faxtitle)
    statuscode = "400"
    response = "Parameter title not set"
    return 1
  if(!faxbody)
    statuscode = "400"
    response = "Parameter body not set"
    return 1
  if(!faxannounce)
    faxannounce = 1

  var/sendresult = 0

  //Send the fax
  for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
    if (F.department in targetlist)
      sendresult = send_fax(F, faxtitle, faxbody, senderkey)
      if (sendresult == 1)
        sendsuccess.Add(F.department)
        responselist[F.department] = "success"
      else
        responselist[F.department] = "failed"

  //Announce that the fax has been sent
  if(faxannounce == 1)
    if(sendsuccess.len < 1)
      command_announcement.Announce("A fax message from Central Command could not be delivered because all of the following fax machines are inoperational: <br>"+list2text(targetlist, ", "), "Fax Received", new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
    else
      command_announcement.Announce("A fax message from Central Command has been sent to the following fax machines: <br>"+list2text(sendsuccess, ", "), "Fax Received", new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);

  statuscode = "200"
  response = "Fax sent"
  data = responselist
  return 1

/datum/topic_command/sendfax/proc/send_fax(var/obj/machinery/photocopier/faxmachine/F, title, body, senderkey)
  log_debug("fax sent to [F.department] with Title: [title] and Body: [body]")
  // Create the reply message
  var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( null ) //hopefully the null loc won't cause trouble for us
  P.name = "[command_name()] - [title]"
  P.info = body
  P.update_icon()

  // Stamps
  var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
  stampoverlay.icon_state = "paper_stamp-cent"
  if(!P.stamped)
    P.stamped = new
  P.stamped += /obj/item/weapon/stamp
  P.overlays += stampoverlay
  P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

  if(F.recievefax(P))
    log_and_message_admins("[senderkey] sent a fax message to the [F.department] fax machine via the api. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[F.x];Y=[F.y];Z=[F.z]'>JMP</a>)")
    sent_faxes += P
    return 1
  else
    usr << "\red Message reply failed."
    qdel(P)
    return 2


//Restartserver
/datum/topic_command/restart
  name = "restart"
/datum/topic_command/restart/run_command(queryparams)
  var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)

  if(!senderkey)
    statuscode = "400"
    response = "Parameter senderkey not set"
    return 1

  world << "<font size=4 color='#ff2222'>Server restarting by remote command.</font>"
  log_and_message_admins("World restart initiated remotely by [senderkey].")
  feedback_set_details("end_error","remote restart")

  if (blackbox)
    blackbox.save_all_data_to_sql()

  spawn(50)
    log_game("Rebooting due to remote command.")
    world.Reboot(10)

  statuscode = "200"
  response = "Restart Command accepted"
  return 1


//Get Ghosts
/datum/topic_command/getghosts
  name = "getghosts"
/datum/topic_command/getghosts/run_command(queryparams)
  var/list/ghosts[] = list()
  ghosts = get_ghosts(1,1)

  for (var/ghost in ghosts)
    log_debug(ghost)

  statuscode = "200"
  response = "Fetched Ghost list"
  data = ghosts
  return 1

//Get Ghosts
/datum/topic_command/grantrespawn
  name = "grantrespawn"
/datum/topic_command/grantrespawn/run_command(queryparams)
  var/list/ghosts = get_ghosts(1,1)
  var/target = queryparams["target"]
  log_debug("target: [target]")
  var/allow_antaghud = queryparams["allow_antaghud"]
  log_debug("allow_antaghud: [allow_antaghud]")
  var/senderkey = queryparams["senderkey"] //Identifier of the sender (Ckey / Userid / ...)
  log_debug("senderkey: [senderkey]")

  if(!senderkey)
    statuscode = "400"
    response = "Parameter senderkey not set"
    return 1

  if(!target)
    statuscode = "400"
    response = "Parameter target not set"
    return 1

  var/mob/dead/observer/G = ghosts[target]

  if(!G in ghosts)
    statuscode = "404"
    response = "Target not in ghosts list"
    return 1
    
  if(G.has_enabled_antagHUD && config.antag_hud_restricted && allow_antaghud == 0)
    statuscode = "409"
    response = "Ghost has used Antag Hud - Respawn Aborted"
    return 1
  G.timeofdeath=-19999  /* time of death is checked in /mob/verb/abandon_mob() which is the Respawn verb.
                     timeofdeath is used for bodies on autopsy but since we're messing with a ghost I'm pretty sure
                     there won't be an autopsy.
                  */
  var/datum/preferences/P

  if (G.client)
    P = G.client.prefs
  else if (G.ckey)
    P = preferences_datums[G.ckey]
  else
    statuscode = "500"
    response = "Something went wrong, couldn't find the target's preferences datum"
    return 1

  for (var/entry in P.time_of_death)//Set all the prefs' times of death to a huge negative value so any respawn timers will be fine
    P.time_of_death[entry] = -99999

  G.has_enabled_antagHUD = 2
  G.can_reenter_corpse = 1

  G:show_message(text("\blue <B>You may now respawn.  You should roleplay as if you learned nothing about the round during your time with the dead.</B>"), 1)
  log_admin("[senderkey] allowed [key_name(G)] to bypass the 30 minute respawn limit via the API")
  message_admins("Admin [senderkey] allowed [key_name_admin(G)] to bypass the 30 minute respawn limit via the API", 1)


  statuscode = "200"
  response = "Respawn Granted"
  return 1
