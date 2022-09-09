umc_economy:

    type: economy

    # The Bukkit service priority. Priorities are Lowest, Low, Normal, High, Highest.
    priority: normal
    # The name of the currency in the singular (such as "dollar" or "euro").
    name single: scripto
    # The name of the currency in the plural (such as "dollars" or "euros").
    name plural: scriptos
    # How many digits after the decimal to include. For example, '2' means '1.05' is a valid amount, but '1.005' will be rounded.
    digits: 1
    # Format the standard output for the money in human-readable format. Use "<[amount]>" for the actual amount to display.
    # Fully supports tags.
    format: <[amount]>s
    # A tag that returns the balance of a linked player. Use a 'proc[]' tag if you need more complex logic.
    # Must return a decimal number.
    balance: <player.flag[money].if_null[0]>
    # A tag that returns a boolean indicating whether the linked player has the amount specified by def "<[amount]>".
    # Use a 'proc[]' tag if you need more complex logic.
    # Must return 'true' or 'false'.
    has: <player.flag[money].is[or_more].than[<[amount]>]>
    # A script that removes the amount of money needed from a player.
    # Note that it's generally up to the systems calling this script to verify that the amount can be safely withdrawn, not this script itself.
    # However you may wish to verify that the player has the amount required within this script.
    # The script may determine a failure message if the withdraw was refused. Determine nothing for no error.
    # Use def 'amount' for the amount to withdraw.
    withdraw:
    - flag <player> money:-:<[amount]>
    # A script that adds the amount of money needed to a player.
    # The script may determine a failure message if the deposit was refused. Determine nothing for no error.
    # Use def 'amount' for the amount to deposit.
    deposit:
    - flag <player> money:+:<[amount]>
	