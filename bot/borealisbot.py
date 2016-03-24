import borealis.bot as borealisbot
import logging
import os

def main():
	logging.basicConfig(format='%(asctime)s: %(levelname)-8s - %(message)s', datefmt='%m/%d/%Y %I:%M:%S', level=logging.INFO)
	config_path = 'config.yml'

	while True:
		try:
			bot = borealisbot.DiscordBot(config_path)
			bot.run()
		except Exception as e:
			logging.critical(e)
			break

if __name__ == '__main__':
	main()
