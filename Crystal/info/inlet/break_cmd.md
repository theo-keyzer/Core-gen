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
The actor loop `go_act` would return 1 if its return is 1.
The return 1 will end up in the calling `Its, All` command that 
will continue with the `go_cmds`. The generated code loop functions
would return the result if `!= 0`.
The other implementations make use of a depth value that gets inc/dec.
It can go back further. The problem is the `Du` command `Do/Jump` 
that may or may not be between the loops.

