coba:
	type: command
    name: coba
	permission: umc.op
	script:

	- define v villager["color=plains;villager_level=2"]
	- spawn <[v]> <player.location.forward_flat> persistent
	- define ve <player.location.forward_flat.find_entities[villager].within[3].get[1]>
	- disguise <[ve]> as:ZOMBIE global
	#- libsdisguise mob type:ZOMBIE baby:true target:<[v]>

mcoba2:
	type: command
    name: mcoba
	permission: umc.op
	script:

	- define profesion <script[umc_config].data_key[villager.prof]>

#	- narrate <list[<script[umc_config].data_key[villager.prof]>].get[1]>
	
	- yaml create id:umc-mm
	- yaml id:umc-mm load:../MythicMobs/Mobs/umc.yml 
	
	- define key "am"

	- define umc-mm <yaml[umc-mm].list_keys[]>
	- define list <yaml[umc-mm].list_keys[].filter[contains_any[<[key]>]]>
	- define count <yaml[umc-mm].list_keys[].find_all_partial[<[key]>].count_matches[*]>
	
	- narrate <[umc-mm]>
	- narrate <[list]>	
	- narrate <[count]>

	- foreach <[profesion]> as:ps:
		- narrate "<[loop_index]> - <[ps]>"