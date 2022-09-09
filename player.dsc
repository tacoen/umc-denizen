umc-player-cmd:
    type: command
    name: umc-player
    aliases:
		- player
    tab completions:
        1: login|logout|register|password|stats|skin-load|skin-save|intro
		2: <proc[umc-config].context[<context.args.get[1]>]>
		3: <proc[umc-config].context[<context.args.get[2]>-<context.args.get[2]>]>

    script:

	- define cpwd <player.flag[umc.login].if_null[null]>
	- define pwd <context.args.get[2].if_null[null]>
	- define npwd <context.args.get[3].if_null[null]>

    - choose <context.args.first>:
		- case stats:
			- run locally stats	def.stat:<[pwd]> def.qu:<[npwd]>
		- case login:
			- run locally login def.pwd:<[pwd]> def.cpwd:<[cpwd]>
		- case logout:
			- run locally logout
		- case register:
			- run locally register def.pwd:<[pwd]>
		- case password:
			- run locally password def.pwd:<[pwd]> def.cpwd:<[cpwd]> def.npwd:<[npwd]>
		- case skin-load:
			- run locally skin-load
		- case skin-save:
			- run locally skin-save
		- case reset:
			- run locally reset
		- case lock:
			- ~run umc-task-lock-screen
			- ~run umc-task-gametitle
		- case intro:
			- ~run umc-task-lock-screen
			- ~run umc-task-gametitle-long
			- ~run umc-task-unlock-screen			
		- case unlock:
			- run umc-task-unlock-screen

		- default:
			- narrate format:umc "umc login scripts"
			- stop

	stats:
		- if <player.flag[umc.active]>:
			- if <[qu]> != null:
				- narrate <[qu]>
				- define val <player.statistic[<[stat]>].qualifier[<[qu]>].if_null[0]>
			- else:
				- define val <player.statistic[<[stat]>].if_null[0]>

			- narrate "<[stat].replace_text[_].with[ ].to_titlecase> : <[val]>

		- else:
			- narrate format:umc "Player not active."

	skin-load:
		- if <player.flag[umc.active]>:
			- if <player.flag[umc.skin].if_null[null]> == null:
				- narrate format:umc "No skin record. Use <&e>/player skin-save<&7> to save <player.name> skin."
			- else:
				- adjust <player> skin_blob:<player.flag[umc.skin]>
				- narrate format:umc "Player skin found and loaded."

	skin-save:
		- if <player.flag[umc.active]>:
			- flag player umc.skin:<player.skin_blob>
			- narrate format:umc "Player skin saved."

	skin-reset:
		- if <player.flag[umc.active]>:
			- flag player umc.skin:!

	skin-init:
		- if <player.flag[umc.active]>:
			- wait 1s
			- if <player.flag[umc.skin]>:
				- adjust <player> skin_blob:<player.flag[umc.skin]>
				- narrate format:umc "Player skin found and loaded."
			- else:
				- flag player umc.skin:<player.skin_blob>
				- narrate format:umc "Player skin saved."

	logout:
		- flag player umc.active:!
		- kick <player> "reason:Player Logout."
	
	login:

		- if <[cpwd].equals[<[pwd]>]>:
			- narrate format:umc "Verified!"
			- flag player umc.active:true expire:2h
			- wait 5t
			- if <player.flag[umc.skin].if_null[null]> == null:
				- run locally skin-init
			- else:
				- run locally skin-load

			- run umc-task-unlock-screen

		- else:
			- if <[cpwd].equals[null]>:
				- narrate format:umc "No player record. Use <&e>/player register [password]<&f> to register."
			- else:
				- narrate format:umc "Wrong Password."

	password:
		- if <[cpwd].equals[<[pwd]>]>:
			- flag player umc.login:<[npwd]>
			- narrate format:umc "Password Successfully change."

		- else:
			- narrate format:umc "Current Password not match."
			- flag player umc.active:!

	register:

		- if <[cpwd].equals[null]>:
			- narrate format:umc "User has been registered!"
			- stop
		- if <[pwd].equals[null]>:
			- narrate format:umc "Password can't be empty"
			- stop

		- flag player umc.login:<[pwd]>
		- narrate format:umc "Name: <player.name>"
		- narrate format:umc "Password: <[pwd]>"

		- flag player umc.active:true expire:12h
		- run umc-player-cmd path:unlock-screen

	reset-absolute:
		- flag player umc.login:!
		- flag player umc.active:!
