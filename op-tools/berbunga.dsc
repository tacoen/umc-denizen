rumputkan:
	type: command
	name: berumput
    permission: umc.op
    tab completions:
		1: tall|small
		2: <list[_random].include[<script[umc_config].data_key[plants.<context.args.get[1]>]>]>
		3: 5|10|20|30

	script:

	- define t <context.args.get[1]>
	
	- if <[t]> == "tall":
		- define nulla "tall_grass"
		- define daftar <script[umc_config].data_key[plants.tall]>
	- else:
		- define nulla "grass"
		- define daftar <script[umc_config].data_key[plants.small]>

	- define w <context.args.get[2].if_null[_random]>
	- define r <context.args.get[3].if_null[20]>
	- define s <context.args.get[4].if_null[<[nulla]>]>


#	- modifyblock <player.location.find_blocks[<[s]>].within[<[r]>]> <[daftar]>

	- if <[t]> == "tall":
		- if <[e].material.half> == "bottom":
			- define re <[e]>
		- modifyblock <[e]> air
	- else:
		- narrate "<[e]>"
		- define re <[e]>
			
	- if <[W]> == "_random":
		- modifyblock <player.location.find_blocks[<[s]>].within[<[r]>]> <[daftar]> delayed
	- else:
		- modifyblock <[re]> <[W]> delayed
	
	
bungakan:
    type: command
    name: berbunga
    permission: umc.op
    usage: /berbunga empty|put radius type
    tab completions:
        1: empty|put
		2: 5|10|20|30
		3: <list[_random].include[<script[umc_config].data_key[potflower].keys>].include[<script[umc_config].data_key[potflower._flower]>].include[<script[umc_config].data_key[potflower._bonzai]>].include[<script[umc_config].data_key[potflower._mushroom]>].include[<script[umc_config].data_key[potflower._woods]>].include[<script[umc_config].data_key[potflower._crimson]>]>
    

	script:

	- define w <context.args.get[3].if_null[_random]>
	- define r <context.args.get[2].if_null[20]>

    - choose <context.args.first>:

		- case empty:

			- foreach <player.location.find_blocks[potted_*].within[<[r]>]> as:pots:
				- modifyblock <[pots]> flower_pot delayed
			
		- case put:

			- define n <player.location.find_blocks[flower_pot].within[<[r]>].count_matches[*]>
			- define single false
			
			- choose <[w]>:
				- case "_random":
					- define bunga <list[].include[<script[umc_config].data_key[potflower._flower]>].include[<script[umc_config].data_key[potflower._bonzai]>].include[<script[umc_config].data_key[potflower._mushroom]>].include[<script[umc_config].data_key[potflower._crimson]>].include[<script[umc_config].data_key[potflower._woods]>].random[<[n]>]>
				- case "_flower":
					- define bunga <list[].include[<script[umc_config].data_key[potflower._flower]>].random[<[n]>]>
				- case "_bonzai":
					- define bunga <list[].include[<script[umc_config].data_key[potflower._bonzai]>].random[<[n]>]>
				- case "_crimson":
					- define bunga <list[].include[<script[umc_config].data_key[potflower._crimson]>].random[<[n]>]>
				- case "_mushroom":
					- define bunga <list[].include[<script[umc_config].data_key[potflower._mushroom]>].random[<[n]>]>
				- case "_woods":
					- define bunga <list[].include[<script[umc_config].data_key[potflower._woods]>].random[<[n]>]>
				- default:
					- define b <[w]>
					- define single true
					
			- foreach <player.location.find_blocks[flower_pot].within[<[r]>]> as:pots:
			
				- if <[single]> == false:
					- define b <[bunga].get[<[loop_index]>].if_null[<[bunga].random>]>

				- modifyblock <[pots]> <[b]> delayed
					
	
		- default:

			- define bunga <list[].include[<script[umc_config].data_key[potflower._flower]>].include[<script[umc_config].data_key[potflower._bonzai]>].include[<script[umc_config].data_key[potflower._mushroom]>].include[<script[umc_config].data_key[potflower._crimson]>].alphabetical>
			- narrate <[bunga]>
