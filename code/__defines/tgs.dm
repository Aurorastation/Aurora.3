//tgstation-server DMAPI

//All functions and datums outside this document are subject to change with any version and should not be relied on

//CONFIGURATION

//create this define if you want to do configuration outside of this file
#ifndef TGS_EXTERNAL_CONFIGURATION

//Comment this out once you've filled in the below
//#error TGS API unconfigured

//Required interfaces (fill in with your codebase equivalent):

//create a global variable named `Name` and set it to `Value`
//These globals must not be modifiable from anywhere outside of the server tools
#define TGS_DEFINE_AND_SET_GLOBAL(Name, Value) var/global/_tgs_##Name = ##Value

//Read the value in the global variable `Name`
#define TGS_READ_GLOBAL(Name) global._tgs_##Name

//Set the value in the global variable `Name` to `Value`
#define TGS_WRITE_GLOBAL(Name, Value) global._tgs_##Name = ##Value

//Disallow ANYONE from reflecting a given `path`, security measure to prevent in-game priveledge escalation
#define TGS_PROTECT_DATUM(Path)

//display an announcement `message` from the server to all players
#define TGS_WORLD_ANNOUNCE(message) world << "[html_encode(##message)]"

//Notify current in-game administrators of a string `event`
#define TGS_NOTIFY_ADMINS(event) message_admins(##event)

//Write an info `message` to a server log
#define TGS_INFO_LOG(message) log_tgs("[##message]")

//Write an error `message` to a server log
#define TGS_ERROR_LOG(message) log_tgs("[##message]", SEVERITY_ERROR)

//Get the number of connected /clients
#define TGS_CLIENT_COUNT clients.len

#endif

//EVENT CODES

//TODO

//REQUIRED HOOKS

//Call this somewhere in /world/New() that is always run
//event_handler: optional user defined event handler. The default behaviour is to broadcast the event in english to all connected admin channels
/world/proc/TgsNew(datum/tgs_event_handler/event_handler)
	return

//Call this when your initializations are complete and your game is ready to play before any player interactions happen
//This may use world.sleep_offline to make this happen so ensure no changes are made to it while this call is running
/world/proc/TgsInitializationComplete()
	return

//Put this somewhere in /world/Topic(T, Addr, Master, Keys) that is always run before T is modified
#define TGS_TOPIC var/tgs_topic_return = TgsTopic(T); if(tgs_topic_return) return tgs_topic_return

//Call this at the beginning of world/Reboot(reason)
/world/proc/TgsReboot()
	return

//DATUM DEFINITIONS
//unless otherwise specified all datums defined here should be considered read-only, warranty void if written

//represents git revision information about the current world build
/datum/tgs_revision_information
	var/commit			//full sha of compiled commit
	var/origin_commit	//full sha of last known remote commit. This may be null if the TGS repository is not currently tracking a remote branch

//represents a merge of a GitHub pull request
/datum/tgs_revision_information/test_merge
	var/number				//pull request number
	var/title				//pull request title
	var/body				//pull request body
	var/author				//pull request github author
	var/url					//link to pull request html
	var/pull_request_commit	//commit of the pull request when it was merged
	var/time_merged			//timestamp of when the merge commit for the pull request was created
	var/comment				//optional comment left by the one who initiated the test merge

//represents a connected chat channel
/datum/tgs_chat_channel
	var/id					//internal channel representation
	var/friendly_name		//user friendly channel name
	var/server_name			//server name the channel resides on
	var/provider_name		//chat provider for the channel
	var/is_admin_channel	//if the server operator has marked this channel for game admins only
	var/is_private_channel	//if this is a private chat channel

//represents a chat user
/datum/tgs_chat_user
	var/id							//Internal user representation
	var/friendly_name				//The user's public name
	var/mention						//The text to use to ping this user in a message
	var/datum/tgs_chat_channel/channel	//The /datum/tgs_chat_channel this user was from

//user definable callback for handling events
/datum/tgs_event_handler/proc/HandleEvent(event_code)
	return

//user definable chat command
/datum/tgs_chat_command
	var/name = ""			//the string to trigger this command on a chat bot. e.g. TGS3_BOT: do_this_command
	var/help_text = ""		//help text for this command
	var/admin_only = FALSE	//set to TRUE if this command should only be usable by registered chat admins

//override to implement command
//sender: The tgs_chat_user who send to command
//params: The trimmed string following the command name
//The return value will be stringified and sent to the appropriate chat
/datum/tgs_chat_command/proc/Run(datum/tgs_chat_user/sender, params)
	CRASH("[type] has no implementation for Run()")

//FUNCTIONS

//Returns the respective string version of the API
/world/proc/TgsMaximumAPIVersion()
	return

/world/proc/TgsMinimumAPIVersion()
	return

//Gets the current version of the server tools running the server
/world/proc/TgsVersion()
	return

//Returns TRUE if the world was launched under the server tools and the API matches, FALSE otherwise
//No function below this succeeds if it returns FALSE
/world/proc/TgsAvailable()
	return

/world/proc/TgsInstanceName()
	return

//Get the current `/datum/tgs_revision_information`
/world/proc/TgsRevision()
	return

//Gets a list of active `/datum/tgs_revision_information/test_merge`s
/world/proc/TgsTestMerges()
	return

//Forces a hard reboot of BYOND by ending the process
//unlike del(world) clients will try to reconnect
//If the service has not requested a shutdown, the next server will take over
/world/proc/TgsEndProcess()
	return

//Gets a list of connected tgs_chat_channel
/world/proc/TgsChatChannelInfo()
	return

//Sends a message to connected game chats
//message: The message to send
//channels: optional channels to limit the broadcast to
/world/proc/TgsChatBroadcast(message, list/channels)
	return

//Send a message to non-admin connected chats
//message: The message to send
//admin_only: If TRUE, message will instead be sent to only admin connected chats
/world/proc/TgsTargetedChatBroadcast(message, admin_only)
	return

//Send a private message to a specific user
//message: The message to send
//user: The /datum/tgs_chat_user to send to
/world/proc/TgsChatPrivateMessage(message, datum/tgs_chat_user/user)
	return

/*
The MIT License

Copyright (c) 2017 Jordan Brown

Permission is hereby granted, free of charge,
to any person obtaining a copy of this software and
associated documentation files (the "Software"), to
deal in the Software without restriction, including
without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom
the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
