dozerwater_command:
    type: command
    debug: false
    name: dozerwater
    usage: /dozer
	
	script:
	
	- define deep <context.args.get[1].if_null[5]>
	
	- foreach <util.list_numbers_to[<[deep]>]> as:d:
		- narrate <[d]>
		- modifyblock <player.location.below[<[d]>]> water
		- modifyblock <player.location.below[<[d]>].left> water
		- modifyblock <player.location.below[<[d]>].right> water
		
	

dozer_command:
    type: command
    debug: false
    name: dozer
    usage: /dozer

	script:
	
	- define mat <context.args.get[1].if_null[DIRT_PATH/]>
    
	- if <player.has_flag[dozer]>:
        - flag player dozer:!
        - narrate "<&b>Dozer Mode: off"
    - else:	
        - flag player dozer:<[mat]>
        - narrate "<&b>Dozer Mode -- carefull using: <player.flag[dozer]>"

dozerin_world:
    type: world
    debug: false
	
    events:
	
        after player steps on block:
			- if <player.has_flag[dozer]> && <player.item_in_hand.contains[clock]>:

				- if <player.location.below.material.contains[air].not>:
					- modifyblock <player.location.below> <player.flag[dozer]>
				- if <player.location.below.left.material.contains[air].not>:
					- modifyblock <player.location.below.left> <player.flag[dozer]>
				- if <player.location.below.left.material.contains[air].not>:
					- modifyblock <player.location.below.left> <player.flag[dozer]>			
					
				- modifyblock <player.location.find_blocks[*grass].within[5]> air
				- modifyblock <player.location.find_blocks[*leaves].within[3]> air
				- modifyblock <player.location.find_blocks[*log].within[2]> air
					
					