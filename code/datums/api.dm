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
  var/name = ""
/datum/topic_command/proc/run_command(queryparams)
  return ""

//Ping Test
/datum/topic_command/ping
  name = "ping"
/datum/topic_command/ping/run_command(queryparams)
  var/x = 1
  for (var/client/C)
    x++
  return x

// /datum/topic_command/command2
//   name=command2
// /datum/topic_command/command2/run(queryparams)
//   return
