umc-mmob-init-cmd:
	type: command
	name: umc-mmob-init
	permission: umc.op
    tab completions:
		1: <list[*].include[<server.list_files[../LibsDisguises/Skins/].exclude[readme]>]>
		2: <list[force]>
		
	script:
	
	- define arg <context.args.get[1].if_null[*]>
	- define arg2 <context.args.get[2].if_null[both]>
	- define skns <server.list_files[../LibsDisguises/Skins/].exclude[readme].alphanumeric>
	
	- yaml create id:umc-mm
	- yaml id:umc-mm load:../MythicMobs/Mobs/umc.yml 

	- yaml create id:umc-disg
	- yaml id:umc-disg load:../LibsDisguises/configs/disguises.yml 
	
	- foreach <[skns]> as:s:
	
		- define f <[s].split[.].get[1]>
		- define ke <[f].split[-]>
		- define r <[ke].get[1]>
		- define te <[ke].get[2]>
		- define x <[ke].get[3]>
		
		- define n <[ke].get[4].if_null[steve]>
		- define mname "<[r]>-<[te]>-<[x]>"

		- narrate "<[s]> <[r]>-<[te]> <list[<script[umc_config].data_key[villager.prof]>].get[<[x]>].if_null[NITWIT]> <[n]>"
			
		- if <yaml[umc-disg].contains[Disguises.<[f]>]> && <[arg2]> != "force":
			- narrate "Disguise: existed!"
		- else:
			- if <[n]> == slim || <n> == alex:
				- execute as_op "savedisguise <[f]> player coenan setSoundGroup VILLAGER setNameVisible false setSkin <[s]>:slim"
			- else:
				- execute as_op "savedisguise <[f]> player coenan setSoundGroup VILLAGER setNameVisible false setSkin <[s]>"
			- wait 10s

		- if <yaml[umc-mm].contains[<[f]>]> && <[arg2]> != "force":
			- narrate "Mythicmobs: existed!"
		- else:
		
			- define data.Type:Villager
			- define data.Faction:<[r]>

			#- narrate <list[<script[umc_config].data_key[villager.prof]>].get[<[x]>]>

			- define "data.Disguise:<[f]> setSoundGroup VILLAGER setNameVisible false setDynamicName true"
			- define data.Options.Profession:<list[<script[umc_config].data_key[villager.prof]>].get[<[x]>].if_null[NITWIT]>
			- define data.AITargetSelectors:<list[clear|attacker]>
			- narrate <[data]>
			- yaml id:umc-mm set <[mname]>:<[data]>

			- yaml id:umc-mm savefile:../MythicMobs/Mobs/umc.yml 

	- narrate "Check: /MythicMobs/Mobs/umc.yml and /LibsDisguises/configs/disguises.yml"

    - run umc-mmob-load
	
	- narrate "reloaded: umc-mmob-load"


umc-mmob-load:
    type: task
    debug: false
	script:
		- yaml create id:umc-mm
		- yaml id:umc-mm load:../MythicMobs/Mobs/umc.yml
		- define mmc <list[]>
		- define mmp <list[]>
		- flag server umc.mmob:!

		- foreach <yaml[umc-mm].list_keys[]> as:m:
			- define ke <[m].split[-]>
			- define r "<[ke].get[1]>-<[ke].get[2]>"

			- define mmp <[mmp].include[<[ke].get[2]>]>
			- define mmc <[mmc].include[<[ke].get[1]>]>

			- flag server umc.mmob.<[ke].get[1]>:->:<[m]>


		#- flag server umc.mmob.prof:<[mmp].deduplicate.alphabetical>
		- flag server umc.mmob.color:<[mmc].deduplicate.alphabetical>

#		- narrate <server.flag[umc.mmob]>
