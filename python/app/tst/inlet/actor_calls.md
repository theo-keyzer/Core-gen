The `All, Its, This, That and Du` commands, calls the `new_act` function to set up
a new actor window on the stack. It passes the `arg` string.
The `Du` command calls `go_act` with the current node instance, the others, the generated code that call `go_act`.
The `go_act` function uses the new node instance. The match uses this instance
and return if the match failed. Then it loops through all actors with its given name.
Each of these actors, have there own match data and skips the ones that do not match.

The `Its`, uses the current node, whereas `This`, uses a node from the collection.
They join up to complete a path route.

The `That` uses data from external sources.

