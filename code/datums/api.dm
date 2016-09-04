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
  var/list/required_params = list() //Required Parameters for the command
  var/statuscode = null
  var/response = null
  var/data = null
/datum/topic_command/proc/run_command(queryparams)
  // Always returns 1 --> Details status in statuscode, response and data
  return 1
/datum/topic_command/proc/check_params_missing(queryparams)
  //Check if some of the required params are missing
  // 0 -> if all params are supplied
  // >=1 -> if a param is missing
  var/list/missing_params = list()
  var/errorcount = 0

  for(var/param in required_params)
    if(queryparams[param] == null)
      errorcount ++
      missing_params += param

  if(errorcount)
    statuscode = 400
    response = "Required params missing"
    data = missing_params
    return errorcount

//Char Names
/datum/topic_command/get_char_list
  name = "get_char_list"
/datum/topic_command/get_char_list/run_command(queryparams)
  if (!ticker)
    statuscode = 500
    response = "Game not started yet!"
    return 1

  var/list/chars = list()

  var/list/mobs = sortmobs()
  for(var/mob/M in mobs)
    if(!M.ckey) continue
    chars[M.name] += M.key ? (M.client ? M.key : "[M.key] (DC)") : "No key"

  statuscode = 200
  response = "Char list fetched"
  data = chars
  return 1

//Admin Count
/datum/topic_command/get_count_admin
  name = "get_count_admin"
/datum/topic_command/get_count_admin/run_command(queryparams)
  var/n = 0
  for (var/client/client in clients)
    if (client.holder && client.holder.rights & (R_ADMIN))
      n++

  statuscode = 200
  response = "Admin count fetched"
  data = n
  return 1

//CCIA Count
/datum/topic_command/get_count_ccia
  name = "get_count_ccia"
/datum/topic_command/get_count_ccia/run_command(queryparams)
  var/n = 0
  for (var/client/client in clients)
    if (client.holder && (client.holder.rights & R_CCIAA) && !(client.holder.rights & R_ADMIN))
      n++

  statuscode = 200
  response = "CCIA count fetched"
  data = n
  return 1

//Mod Count
/datum/topic_command/get_count_mod
  name = "get_count_mod"
/datum/topic_command/get_count_mod/run_command(queryparams)
  var/n = 0
  for (var/client/client in clients)
    if (client.holder && (client.holder.rights & R_MOD) && !(client.holder.rights & R_ADMIN))
      n++

  statuscode = 200
  response = "Mod count fetched"
  data = n
  return 1

//Player Count
/datum/topic_command/get_count_player
  name = "get_count_player"
/datum/topic_command/get_count_player/run_command(queryparams)
  var/n = 0
  for(var/mob/M in player_list)
    if(M.client)
      n++

  statuscode = 200
  response = "Player count fetched"
  data = n
  return 1

//Get available Fax Machines
/datum/topic_command/get_faxmachines
  name = "get_faxmachines"
/datum/topic_command/get_faxmachines/run_command(queryparams)
  var/list/faxlocations = list()

  for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
    faxlocations.Add(F.department)

  statuscode = 200
  response = "Fax machines fetched"
  data = faxlocations
  return 1

//Get Fax List
/datum/topic_command/get_faxlist
  name = "get_faxlist"
  required_params = list("faxtype") //Type of the faxes to be retrieved (sent / received)
/datum/topic_command/get_faxlist/run_command(queryparams)
  if (!ticker)
    statuscode = 500
    response = "Round hasn't started yet! No faxes to display!"
    data = null
    return 1

  var/list/faxes = list()
  switch (queryparams["faxtype"])
    if ("received")
      faxes = arrived_faxes
    if ("sent")
      faxes = sent_faxes

  if (!faxes || !faxes.len)
    statuscode = 404
    response = "No faxes found"
    data = null
    return 1

  var/list/output = list()
  for (var/i = 1, i <= faxes.len, i++)
    var/obj/item/a = faxes[i]
    output += "[i]"
    output[i] = a.name ? a.name : "Untitled Fax"

  statuscode = 200
  response = "Fetched Fax List"
  data = output
  return 1

//Get Specific Fax
/datum/topic_command/get_fax
  name = "get_fax"
  required_params = list("faxtype","faxid")
/datum/topic_command/get_fax/run_command(queryparams)
  var/list/faxes = list()
  switch (queryparams["faxtype"])
    if ("received")
      faxes = arrived_faxes
    if ("sent")
      faxes = sent_faxes

  if (!faxes || !faxes.len)
    statuscode = 500
    response = "No faxes found!"
    data = null
    return 1

  var/fax_id = text2num(queryparams["faxid"])
  if (fax_id > faxes.len || fax_id < 1)
    statuscode = 404
    response = "Invalid Fax ID"
    data = null
    return 1

  var/output = list()
  if (istype(faxes[fax_id], /obj/item/weapon/paper))
    var/obj/item/weapon/paper/a = faxes[fax_id]
    output["title"] = a.name ? a.name : "Untitled Fax"

    var/content = replacetext(a.info, "<br>", "\n")
    content = strip_html_properly(content, 0)
    output["content"] = content

    statuscode = 200
    response = "Fax (Paper) with id [fax_id] retrieved"
    data = output
    return 1
  else if (istype(faxes[fax_id], /obj/item/weapon/photo))
    statuscode = 501
    response = "Fax is a Photo - Unable to send"
    data = null
    return 1
  else if (istype(faxes[fax_id], /obj/item/weapon/paper_bundle))
    var/obj/item/weapon/paper_bundle/b = faxes[fax_id]
    output["title"] = b.name ? b.name : "Untitled Paper Bundle"

    if (!b.pages || !b.pages.len)
      statuscode = 500
      response = "Fax Paper Bundle is empty - This should not happen"
      data = null
      return 1

    var/i = 0
    for (var/obj/item/weapon/paper/c in b.pages)
      i++
      var/content = replacetext(c.info, "<br>", "\n")
      content = strip_html_properly(content, 0)
      output["content"] += "Page [i]:\n[content]\n\n"

      statuscode = 200
      response = "Fax (PaperBundle) retrieved"
      data = output
      return 1

  statuscode = 500
  response = "Unable to recognize the fax type. Cannot send contents!"
  data = null
  return 1

//Get Ghosts
/datum/topic_command/get_ghosts
  name = "get_ghosts"
/datum/topic_command/get_ghosts/run_command(queryparams)
  var/list/ghosts[] = list()
  ghosts = get_ghosts(1,1)

  for (var/ghost in ghosts)
    log_debug(ghost)

  statuscode = 200
  response = "Fetched Ghost list"
  data = ghosts
  return 1

// Crew Manifest
/datum/topic_command/get_manifest
  name = "get_manifest"
/datum/topic_command/get_manifest/run_command(queryparams)
  if (!ticker)
    statuscode = 500
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

  statuscode = 200
  response = "Manifest fetched"
  data = positions
  return 1

//Player Ckeys
/datum/topic_command/get_player_list
  name = "get_player_list"
/datum/topic_command/get_player_list/run_command(queryparams)
  var/list/players = list()
  for (var/client/C in clients)
    players += C.key

  statuscode = 200
  response = "Player list fetched"
  data = players
  return 1

//Get info about a specific player
/datum/topic_command/get_player_info
  name = "get_player_info"
  required_params = list("search") //search --> list with data to search for
/datum/topic_command/get_player_info/run_command(queryparams)
  var/list/search = queryparams["search"]

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
    statuscode = 449
    response = "No match found"
    data = null
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
    statuscode = 200
    response = "Client data fetched"
    data = info
    return 1
  else
    statuscode = 449
    response = "Multiple Matches found"
    data = null
    return 1

//Get Server Status
/datum/topic_command/get_serverstatus
  name = "get_serverstatus"
/datum/topic_command/get_serverstatus/run_command(queryparams)
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

  statuscode = 200
  response = "Server Status fetched"
  data = s
  return 1

//Get a Staff List
/datum/topic_command/get_stafflist
  name = "get_stafflist"
/datum/topic_command/get_stafflist/run_command(queryparams)
  var/list/staff = list()
  for (var/client/C in admins)
    staff[C] = C.holder.rank

  statuscode = 200
  response = "Staff list fetched"
  data = staff
  return 1

//Grant Respawn
/datum/topic_command/grant_respawn
  name = "grant_respawn"
  required_params = list("senderkey","target")
/datum/topic_command/grant_respawn/run_command(queryparams)
  var/list/ghosts = get_ghosts(1,1)
  var/target = queryparams["target"]
  var/allow_antaghud = queryparams["allow_antaghud"]
  var/senderkey = queryparams["senderkey"] //Identifier of the sender (Ckey / Userid / ...)

  var/mob/dead/observer/G = ghosts[target]

  if(!G in ghosts)
    statuscode = 404
    response = "Target not in ghosts list"
    data = null
    return 1

  if(G.has_enabled_antagHUD && config.antag_hud_restricted && allow_antaghud == 0)
    statuscode = 409
    response = "Ghost has used Antag Hud - Respawn Aborted"
    data = null
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
    statuscode = 500
    response = "Something went wrong, couldn't find the target's preferences datum"
    data = null
    return 1

  for (var/entry in P.time_of_death)//Set all the prefs' times of death to a huge negative value so any respawn timers will be fine
    P.time_of_death[entry] = -99999

  G.has_enabled_antagHUD = 2
  G.can_reenter_corpse = 1

  G:show_message(text("\blue <B>You may now respawn.  You should roleplay as if you learned nothing about the round during your time with the dead.</B>"), 1)
  log_admin("[senderkey] allowed [key_name(G)] to bypass the 30 minute respawn limit via the API")
  message_admins("Admin [senderkey] allowed [key_name_admin(G)] to bypass the 30 minute respawn limit via the API", 1)


  statuscode = 200
  response = "Respawn Granted"
  data = null
  return 1

//Ping Test
/datum/topic_command/ping
  name = "ping"
/datum/topic_command/ping/run_command(queryparams)
  var/x = 1
  for (var/client/C)
    x++
  statuscode = 200
  response = "Pong"
  data = x
  return 1

//Restart Round
/datum/topic_command/restart_round
  name = "restart_round"
  required_params = list("senderkey")
/datum/topic_command/restart_round/run_command(queryparams)
  var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)

  world << "<font size=4 color='#ff2222'>Server restarting by remote command.</font>"
  log_and_message_admins("World restart initiated remotely by [senderkey].")
  feedback_set_details("end_error","remote restart")

  if (blackbox)
    blackbox.save_all_data_to_sql()

  spawn(50)
    log_game("Rebooting due to remote command.")
    world.Reboot(10)

  statuscode = 200
  response = "Restart Command accepted"
  data = null
  return 1

//Get available Fax Machines
/datum/topic_command/send_adminmsg
  name = "send_adminmsg"
  required_params = list("ckey","msg","senderkey")
/datum/topic_command/send_adminmsg/run_command(queryparams)
  /*
    We got an adminmsg from IRC bot lets split the API
    expected output:
      1. ckey = ckey of person the message is to
      2. msg = contents of message, parems2list requires
      3. rank = Rank that should be displayed
      4. senderkey = the ircnick that send the message.
  */

  var/client/C
  var/req_ckey = ckey(queryparams["ckey"])

  for(var/client/K in clients)
    if(K.ckey == req_ckey)
      C = K
      break
  if(!C)
    statuscode = 404
    response = "No client with that name on server"
    data = null
    return 1

  var/rank = queryparams["rank"]
  if(!rank)
    rank = "Admin"

  var/message =	"<font color='red'>[rank] PM from <b><a href='?discord_msg=[queryparams["senderkey"]]'>[queryparams["senderkey"]]</a></b>: [queryparams["msg"]]</font>"
  var/amessage =  "<font color='blue'>[rank] PM from <a href='?discord_msg=[queryparams["senderkey"]]'>[queryparams["senderkey"]]</a> to <b>[key_name(C)]</b> : [queryparams["msg"]]</font>"

  C.received_discord_pm = world.time
  C.discord_admin = queryparams["senderkey"]

  C << 'sound/effects/adminhelp.ogg'
  C << message

  for(var/client/A in admins)
    if(A != C)
      A << amessage


  statuscode = 200
  response = "Admin Message sent"
  data = null
  return 1

//Send a Command Report
/datum/topic_command/send_commandreport
  name = "send_commandreport"
  required_params = list("senderkey","body")
/datum/topic_command/send_commandreport/run_command(queryparams)
  var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
  var/reporttitle = sanitizeSafe(queryparams["title"]) //Title of the report
  var/reportbody = sanitize(queryparams["body"]) //Body of the report
  var/reporttype = queryparams["type"] //Type of the report: freeform / ccia / admin
  var/reportsender = sanitize(queryparams["sendername"]) //Name of the sender
  var/reportannounce = queryparams["announce"] //Announce the contents report to the public: 1 / 0

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

  statuscode = 200
  response = "Command Report sent"
  data = null
  return 1

//Send Fax
/datum/topic_command/send_fax
  name = "send_fax"
  required_params = list("target","senderkey","title","body")
/datum/topic_command/send_fax/run_command(queryparams)
  var/list/responselist = list()
  var/list/sendsuccess = list()
  var/list/targetlist = queryparams["target"] //Target locations where the fax should be sent to
  var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
  var/faxtitle = sanitizeSafe(queryparams["title"]) //Title of the report
  var/faxbody = sanitize(queryparams["body"]) //Body of the report
  var/faxsender = sanitize(queryparams["sendername"]) //Name of the sender
  var/faxannounce = queryparams["announce"] //Announce the contents report to the public: 1 / 0

  if(!targetlist || targetlist.len < 1)
    statuscode = 400
    response = "Parameter target not set"
    data = null
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

  log_admin("[faxsender] sent a fax via the API: : [faxbody]")
  message_admins("[faxsender] sent a fax via the API", 1)

  statuscode = 200
  response = "Fax sent"
  data = responselist
  return 1

/datum/topic_command/send_fax/proc/send_fax(var/obj/machinery/photocopier/faxmachine/F, title, body, senderkey)
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
    qdel(P)
    return 2
