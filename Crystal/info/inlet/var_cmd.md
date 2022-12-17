This creates a named entry in the the current node's instance.
The `Var foo = bar`, sets the variable. To access it, `${foo}`
The `Var .list_act.foo = abar`, set the variable in the node instance that is current
in the `list_act`. The current actors are on the stack. To access it, `${.list_act.foo}`,
or when on that node instance (back to the list_act), `${foo}`.

Also has a `regex` that can break down the string as named entries.

