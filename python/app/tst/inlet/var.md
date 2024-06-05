Variable names are from the current node with options to get other values.
The ${name} gets replaced by the value of the name item.
The `${_.D}` is from the var D and`${_.D.build.domain.name}`, a route to name.
The routes are via a dict or def relations.

The following are variables from the actor window.

The `${}` is the current node.
The `${._key}` variable is the value of the key used for when all key and values are used ( `This list. actor` ).
The `${._lcnt} or ${.-}` is the loop counter.
The `${.+}` is the loop counter plus 1.
The `${._arg}` is the argument passes to the actor.
The `${.0.first} {.1.rest}` is the text first if the loop counter is 0 and rest if > 0.

The `${.main.1}`, uses the `main` actor in the window calling stack for its current node to get the varaible.
The other window variables are also available like `${.main..arg}`
The `Du` command, calls another actor, but should have the same variable values.

The following are global.

The `${._list.A}`, the value is the list item.
The `${._set}`, the value is the set dict.
The `${_.D}` is like `${._var.D}`.
The `${._ins}` is output captured between the `In on, In off` commands.

The format options, reformats the value. `${name:u}` converts it to upper case.
If the item is a list, `${:-}` is the value at the loop index.
The `${:sort:join}`, sorts the list and the output is `a,b,c` string.

The `strs` function in gen.py`, replaces the variable names of a string with their values.
Some of the actor commands, calls this function for an item so that the item can be combined with variables.
This is not done for every item, and can be added if needed. 
