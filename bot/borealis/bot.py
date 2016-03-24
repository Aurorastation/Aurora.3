import discord
import socket
import logging
import yaml
import os.path
import struct
import random
import pickle
import _thread
from urllib import parse

class DiscordBot(discord.Client):
	def __init__(self, config, **kwargs):
		super(DiscordBot, self).__init__(**kwargs)

		self.read_config(config)
		self.listening = False

	def run(self):
		self.login(self.credentials['email'], self.credentials['password'])
		logging.info("Starting bot.")

		super(DiscordBot, self).run()

	def on_ready(self):
		logging.info("Bot ready and running.")
		logging.info("Logged in as: {0}.".format(self.user.name))
		self.do_greeting(None)

		_thread.start_new_thread(self.receive_nudges, ())

	def on_message(self, msg):
		words = msg.content.split(' ')

		if words[0] == None:
			return

		if words[0][0] == "!":
			self.do_command(msg, words)

		return

	def read_config(self, config_path):
		if os.path.isfile(config_path) == False:
			raise Exception("Invalid config path.")

		logging.info("Reading config from file: {0}.".format(config_path))
		with open(config_path, 'r') as f:
			config = yaml.load(f)

		self.last_config = config_path

		self.credentials = config['credentials']
		self.channels = config['channels']

		self.allow_everyone = config['allow_everyone']
		self.allow_nudging = config['allow_nudging']
		self.nudge_config = config['nudge_config']

		self.greeting = config['greeting']

		self.server_info = config['server_info']

		self.commands = config['commands']

		self.authorization = config['authorization']

	def do_greeting(self, channel):
		if self.greeting == None or self.greeting == "":
			return

		if channel != None:
			self.send_message(channel, self.greeting)
		else:
			self.forward_message("lobby", self.greeting)

	def check_authorization(self, user, required_access):
		if required_access == None or isinstance(user, discord.Member) == False:
			return False

		for role in user.roles:
			if role.name.lower() in self.authorization['admin']:
				return True

			if required_access == 1 and role.name.lower() in self.authorization['mod']:
				return True

			if required_access == 2 and role.name.lower() in self.authorization['cciaa']:
				return True

		return False

	def do_command(self, msg, words):
		command = words[0][1:].lower()
		response = None

		if command in self.commands['admin_commands'] or command in self.commands['cciaa_commands'] or command in self.commands['mod_commands']:
			authorization = 1

			if command in self.commands['cciaa_commands']:
				authorization = 2
			elif command in self.commands['admin_commands']:
				authorization = 3

			if self.check_authorization(msg.author, authorization) == False:
				self.send_message(msg.channel, "Error: you lack authorization to use this command.")
				return

		#General commands
		if command == "help":
			response =	"```-----------BOREALIS Directives-----------\n"
			for sorted_command in sorted(self.commands['public_commands'].keys()):
				response += "[+] !{0} - {1}\n".format(sorted_command, self.commands['public_commands'][sorted_command])

			response += "----------------------------------------```"
		elif command == "helpadmin" or command == "helpmod" or command == "helpcciaa":
			use_list = "admin_commands"
			if command == "helpmod":
				use_list = "mod_commands"
			elif command == "helpcciaa":
				use_list = "cciaa_commands"

			response = "```-------------Restricted Commands-------------\n"
			response += "These commands have mark-up syntax! Replace all [placeholders] with pure text, no brackets needed!\n"
			response += "Note that these commands are authorized based on your chat server role! If you do not have authorization, you will be informed as such and the command will fail!\n"
			response += "----------------------------------------\n"
			for sorted_command in sorted(self.commands[use_list].keys()):
				response += "[+] !{0} - {1}\n".format(sorted_command, self.commands[use_list][sorted_command])

			response += "----------------------------------------```"
		elif command == "greet":
			self.do_greeting(msg.channel)
		elif command == "mentionstatus":
			response = "I will use the everyone-mention."
			if self.allow_everyone == False:
				response = "I will not use the everyone-mention."

			response = "{0} - {1}".format(msg.author.mention(), response)
		elif command == "nudgestatus":
			response = "I am actively receiving nudges."
			if self.allow_nudging == False:
				response = "I am not receiving nudges."

			response = "{0} - {1}".format(msg.author.mention(), response)
		elif command == "playercount":
			count = self.ping_server(b"players")

			if count == None:
				response = "{0} - Sorry! I was unable to ping the server!".format(msg.author.mention())
			else:
				response = "{0} - There are {1} players on the server.".format(msg.author.mention(), count)
		elif command == "admincount":
			count = self.ping_server(b"admins")

			if count == None:
				response = "{0} - Sorry! I was unable to ping the server!".format(msg.author.mention())
			else:
				response = "{0} - There are {1} admins and mods on the server.".format(msg.author.mention(), count)
		elif command == "cciaacount":
			count = self.ping_server(b"cciaa")

			if count == None:
				response = "{0} - Sorry! I was unable to ping the server!".format(msg.author.mention())
			else:
				response = "{0} - There are {1} duty officers on the server.".format(msg.author.mention(), count)
		elif command == "gamemode":
			gamemode = self.ping_server(b"gamemode")

			if gamemode == None:
				response = "{0} - Sorry! I was unable to ping the server!".format(msg.author.mention())
			else:
				response = "{0} - The current gamemode is {1}.".format(msg.author.mention(), gamemode)
		elif command == "manifest":
			server_reply = self.ping_server(b"manifest")

			if server_reply == None:
				response = "{0} - Sorry! I was unable to ping the server!".format(msg.author.mention())
			elif isinstance(server_reply, str):
				response = "{0} - The server replied with this: {1}.".format(msg.author.mention(), server_reply)
			else:
				response = "Current crew manifest:\n\n```\n"
				for key in sorted(server_reply.keys()):
					response += "{0}:\n".format(key.upper())

					for chunk in server_reply[key].split('&'):
						chunk = chunk.replace("+", " ")
						dat = chunk.split('=')
						if len(dat) == 2:
							response += "{0} as {1}\n".format(parse.unquote(dat[0]), parse.unquote(dat[1]))
					response += "\n\n"
				response += "```"
		elif command == "who":
			server_reply = self.ping_server(b"who")

			if server_reply == None:
				response = "{0} - Sorry! I was unable to ping the server!".format(msg.author.mention())
			else:
				response = "Current player list:\n\n```\n"
				for value in server_reply.split('&'):
					response += value
					response += "\n"
				response += "```"

		#Authorized commands:
		elif command == "togglenudges":
			self.allow_nudging = not self.allow_nudging

			if self.allow_nudging == True:
				response = "{0} - Nudge receiver now accepts connections. Now forwarding messages from within the game.".format(msg.author.mention())
			else:
				response = "{0} - Nudge receiver no longer accepting connections. No longer forwarding messages from within the game.".format(msg.author.mention())
		elif command == "togglementions":
			self.allow_everyone = not self.allow_everyone

			if self.allow_everyone == True:
				response = "{0} - Now mentioning everyone when needed.".format(msg.author.mention())
			else:
				response = "{0} - No longer mentioning everyone in my messages.".format(msg.author.mention())
		elif command == "refreshconfig":
			response = "{0} - Config refreshed, as per your request.".format(msg.author.mention())
			try:
				self.read_config(self.last_config)
			except Exception as e:
				response = "{0} - error refreshing config: {1}".format(msg.author.mention(), e)
		elif command == "adminmsg":
			if len(words) < 3:
				response = "Not enough arguments passed! Couldn't execute the command."
			else:
				message = ""
				i = 2
				while i < len(words):
					message += words[i]

					if i < len(words) - 1:
						message += "+"

					i += 1

				to_send = "adminmsg={0}&key={1}&sender={2}&msg={3}".format(words[1], self.server_info["key"], msg.author.name, message)

				server_reply = self.ping_server(bytes(to_send, "utf-8"))

				if server_reply == None:
					response = "Sorry! I couldn't execute the command for whatever reason!"
				else:
					response = "Got a reply back from the server! '{0}'".format(server_reply)
		elif command == "mute":
			if len(words) < 2:
				response = "Not enough argumetns passed! Couldn't execute the command."
			else:
				server_reply = self.ping_server(bytes("mute={0}&admin={1}&key={2}".format(words[1], msg.author.name, self.server_info["key"]), "utf-8"))

				if server_reply == None:
					response = "Sorry! I couldn't execute the command for whatever reason!"
				else:
					response = "Got a reply back from the server! '{0}'".format(server_reply)
		elif command == "restartserver":
			logging.info("Server restart command issued by {0}.".format(msg.author.name))
			server_reply = self.ping_server(bytes("restart={0}&key={1}".format(msg.author.name, self.server_info["key"]), "utf-8"))

			if server_reply == None:
				response = "I think we did it. I didn't get a response, so I think it worked!"
		elif command == "announceserver":
			if len(words) < 2:
				response = "Not enough arguments passed! Couldn't execute the command."
			else:
				message = ""
				i = 1
				while i < len(words):
					message += words[i]

					if i < len(words) - 1:
						message += "+"

					i += 1

				server_reply = self.ping_server(bytes("announce={0}&key={1}&msg={2}".format(msg.author.name, self.server_info["key"], message), "utf-8"))

				if server_reply == None:
					response = "Sorry! I couldn't execute the command for whatever reason!"
				else:
					response = "Got a reply back from the server! '{0}'".format(server_reply)
		elif command == "notes":
			if len(words) < 2:
				response = "Not enough argumetns passed! Couldn't execute the command."
			else:
				server_reply = self.ping_server(bytes("notes={0}&key={1}".format(words[1], self.server_info["key"]), "utf-8"))

				if server_reply == None:
					response = "Sorry! I couldn't execute the command for whatever reason!"
				else:
					response = server_reply
		elif command == "info":
			if len(words) < 2:
				response = "Not enough arguments passed! Couldn't execute the command."
			else:
				server_reply = self.ping_server(bytes("info={0}&key={1}".format(words[1], self.server_info["key"]), "utf-8"))

				if server_reply == None:
					response = "Sorry! I was unable to ping the server!"
				elif isinstance(server_reply, str):
					response = "The server replied with this: {0}.".format(server_reply)
				else:
					response = "Information on {0}:\n\n```\n".format(server_reply["key"])
					for key in sorted(server_reply.keys()):
						if key == "damage" and server_reply[key] != "non-living":
							for chunk in server_reply[key].split('&'):
								chunk = chunk.replace("+", " ")
								dat = chunk.split('=')
								if len(dat) == 2:
									response += "{0} damage at: {1}\n".format(parse.unquote(dat[0]), parse.unquote(dat[1]))
						else:
							response += "{0} = {1}\n".format(key, server_reply[key])
					response += "```"
		elif command == "age":
			if len(words) < 2:
				response = "Not enough arguments passed! Couldn't execute the command."
			else:
				server_reply = self.ping_server(bytes("age={0}&key={1}".format(words[1], self.server_info["key"]), "utf-8"))

				if server_reply == None:
					response = "Sorry! I was unable to ping the server!"
				else:
					response = "The server replied with this: {0}.".format(server_reply)
		elif command == "faxlist":
			received = "received"
			if len(words) < 2:
				self.send_message(msg.channel, "{0} - You didn't specify whether you want received or sent faxes. Assuming you wanted **received**.".format(msg.author.mention()))
			elif words[1].lower() != "received" and words[1].lower() != "sent":
				self.send_message(msg.channel, "{0} - You used an invalid key on specifying whether you want received or sent faxes. Assuming you wanted **received**.".format(msg.author.mention()))
			else:
				received = words[1].lower()

			server_reply = self.ping_server(bytes("faxlist={0}&key={1}".format(received, self.server_info["key"]), "utf-8"))

			if server_reply == None:
				response = "Sorry! I couldn't execute the command for whatever reason!"
			else:
				if isinstance(server_reply, str) == True:
					response = server_reply
				else:
					response = "Here are the faxes I got!"
					for key in server_reply:
						response += "\n{0} - {1}".format(key, server_reply[key])
		elif command == "getfax":
			received = "received"
			if len(words) < 3:
				response = "Not enough arguments passed! Couldn't execute the command."
			elif words[1].isdigit == False:
				response = "{0} - You didn't give me an integer! I cannot work with this!".format(msg.author.mention())
			else:
				if words[2].lower() != "received" and words[2].lower() != "sent":
					self.send_message(msg.channel, "{0} - You used an invalid key on specifying whether you want received or sent faxes. Assuming you wanted **received**.".format(msg.author.mention()))
				else:
					received = words[2].lower()

				fax_id = words[1]
				server_reply = self.ping_server(bytes("getfax={0}&key={1}&received={2}".format(fax_id, self.server_info["key"], received), "utf-8"))

				if server_reply == None:
					response = "Sorry! I couldn't execute the command for whatever reason!"
				else:
					if isinstance(server_reply, str):
						response = server_reply
					else:
						response = "Fax titled '{0}':\n\n```{1}```".format(server_reply["title"], server_reply["content"])

		if response != None:
			self.send_message(msg.channel, response)
		elif random.randrange(10) == 8:
			self.send_message(msg.channel, "..Were you talking to me...?")

	def forward_message(self, destination, msg):
		if destination not in self.channels:
			return

		if msg == None:
			return

		if self.allow_everyone == False and msg.find("@everyone") != -1:
			msg.replace("@everyone", "")

		invite = self.get_invite(self.channels[destination])
		self.accept_invite(invite)
		self.send_message(invite.channel, msg)

	def receive_nudges(self):
		if self.nudge_config['port'] == None or self.nudge_config['hostname'] == None:
			logging.error("Runtime error while starting receive_nudges(): hostname or port unspecified.")
			return

		if self.listening == True:
			return
		else:
			self.listening = True

		logging.info("Receive_nudges() started.")
		port = self.nudge_config['port']
		host = self.nudge_config['hostname']
		backlog = 5
		size = 1024
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.bind((host, port))
		s.listen(backlog)

		while True:
			client, _ = s.accept()

			if self.allow_nudging == False:
				client.close()
				continue

			data = client.recv(size)
			client.close()
			truedata = pickle.loads(data)
			to = None
			msg = None

			if truedata.get('key', '') != self.nudge_config['key']:
				continue

			if truedata.get('channel', None) != None:
				to = truedata['channel']
			else:
				continue

			msg = truedata['data']
			self.forward_message(to, msg)

	def decode_packet(self, packet):
		if packet != "":
			if b"\x00" in packet[0:2] or b"\x83" in packet[0:2]:

				sizebytes = struct.unpack('>H', packet[2:4])  # array size of the type identifier and content # ROB: Big-endian!
				size = sizebytes[0] - 1  # size of the string/floating-point (minus the size of the identifier byte)
				if b'\x2a' in packet[4:5]:  # 4-byte big-endian floating-point
					unpackint = struct.unpack('f', packet[5:9])  # 4 possible bytes: add them up together, unpack them as a floating-point

					return int(unpackint[0])
				elif b'\x06' in packet[4:5]:  # ASCII string
					unpackstr = ''  # result string
					index = 5  # string index
					indexend = index + size

					string = packet[5:indexend].decode("utf-8")
					string = string.replace('\x00', '')

					return string
		return None

	def ping_server(self, question):
		try:

			query = b'\x00\x83'
			query += struct.pack('>H', len(question) + 6)
			query += b'\x00\x00\x00\x00\x00'
			query += question
			query += b'\x00'

			s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			s.connect((self.server_info['hostname'], self.server_info['port']))
			s.settimeout(30)

			if s == None:
				return None

			s.sendall(query)

			data = b''
			while True:
				buf = s.recv(1024)
				data += buf
				szbuf = len(buf)
				if szbuf < 1024:
					break

			s.close()

			response = self.decode_packet(bytes(data))

			if response != None:
				if isinstance(response, int) == True or (response.find('&') + response.find('=') == -2):
					return response
				else:
					parsed_response = {}
					for chunk in response.split('&'):
						chunk = chunk.replace("+", " ")
						dat = chunk.split('=')
						parsed_response[dat[0]] = ''
						if len(dat) == 2:
							parsed_response[dat[0]] = parse.unquote(dat[1])

					return parsed_response
			else:
				return None
		except socket.timeout:
			return None
		except socket.error:
			return None
