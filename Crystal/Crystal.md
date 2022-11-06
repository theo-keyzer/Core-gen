# Crystal implementation

# Break command

The actor loop `go_act` works like a `case` switch.
Actors of the same name, are the `when` cases.
The command loop `go_cmds`, loops through the commands in that actor.
The `All, Its` loop, calls the `go_act` function in a loop.
The `Du` command call another actor with `go_act`.

To break out of the `go_cmds`'s loop, it uses a break
to end the loop. The `Break cmd` command and `Unique` does that.
To break out of the actor loop, it returns 2. The `Break actor` does that.
That ends up in the `go_act`, that end it.
To break out of the `Its, All` loop, it returns 1. The `Break loop` command does that.
The actor loop would return 1 if its return is 1.
The return 1 will end up in the calling `Its, All` command that ignores it.

The other implementations make use of a depth value that gets inc/dec.
The problem is the `Du` command `Do/Jump` that may or may not be between
the loops.

# Break condition

The `Break cmd on_error ${val}`, evals the variable string with the `strs` function.
If the variables are missing, it would break out of the `go_cmds`.
The `no_error`, would break when the variables are present - doing checks.

# Loop counter

The `All, Its` command calls `new_act` first that sets the next actor's counter to -1.
The loop calls the `go_act` function, that increments the counter on match.
The `${.-}` is the counter value and `${.+}`, the counter +1.
Also `${.0.string}` for first (if counter is 0) and `${.1.string}` for rest. The value is `string`
The `Du` should inherit this value, but does not.
 

