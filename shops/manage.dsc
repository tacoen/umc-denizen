umc-shop-manage:
	type: command
	name: umc-shop
	permission: umc.op
    tab completions:
		1: set|title|price
        2: <yaml[umc-shop].list_keys[]>
		3: <proc[umc-config].context[shop-<context.args.get[1]>]>

	script:

	- yaml id:umc-shop load:data/umc/shop.yml

	- define shop <context.args.get[2].if_null[shop.<util.random.int[<1000>].to[<9999>]>]>
	- define page <context.args.get[3].if_null[buy]>
	- define param1 <context.args.get[4].if_null[10]>

	- choose <context.args.first>:

		- case set:

			- narrate "<[shop]> <[page]>"
			- if <yaml[umc-shop].contains[<[shop]>.<[page]>.items]>:
				- define items <yaml[umc-shop].read[<[shop]>.<[page]>.items]>
				- narrate "Existing: <[items]>"
			- else:
				- narrate "New List"
				- define items <list[air]>

			- define n 0

			- foreach <player.inventory.list_contents> as:i:
				- define i <[i].parsed.split[@].get[2]>
				- if <[i]> != air:
#					- narrate <[i]>
					- define items <[items].include[<[i]>]>
					- define n:+:1
				- if n >= 45:
					- foreach stop
					- narrate "Max: 45"

			- define items <[items].deduplicate.exclude[air]>

			- narrate <[items].alphanumeric>

			- yaml id:umc-shop set <[shop]>.<[page]>.items:<[items].alphanumeric>
			- yaml id:umc-shop set <[shop]>.<[page]>.price:<[param1]>
			- yaml id:umc-shop savefile:data/umc/shop.yml
