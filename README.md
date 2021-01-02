# Coder's Bot

🖥️ Discord BOT made for developers written in V.

## Features

* `message.txt` files auto-removed and sent on hastebin.androz2091.fr
* `!ask` command that points to dontasktoask.com
* `!lmg` command that sends a link with the search to lmgtfy.com
* `!joke` command to get a random geek joke

## Installation (linux)

### Download and build V

* `git clone https://github.com/vlang/v`
* `cd v`
* `apt-get install build-essential`
* `make`
* `./v symlink`

### Install discord.v

* `apt-get install libssl-dev`
* `git clone https://github.com/Terisback/discord.v.git ~/.vmodules/discordv`

### Download the repo

* `git clone https://github.com/Androz2091/coders-bot.git`
* `export BOT_TOKEN="939383093930"` (replace `939383093930` with your bot token)
* `v run codersbot.v`
