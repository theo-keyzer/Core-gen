The `Break` command is the same as `Break actor` as it is the default.

The codes returned by the break is 1 for loops, 2 for actor and 3 for commands.
The `go_act` function in `gen.py`, will continue the actor loop if the break was for the comands.
It will return 0 if its is for the actor. Else return the value.

The generated code for the `Its` will continue as long is the return is 0, else returns the returned value.
The commands in the `go_cmd` function that deal with loops, will continue if the return is for the loops or 0.
Else it returns the returned value. There is no need for a loop continue as a break for the actor will continue the loop if there was one
or continue with the calling actor.

When the `Break` command specifies the actor the break applies to, it makes the return value negative
and puts a flag on the actor one up in the calling stack. The actor with the flag on in the `go_act` function will return this value as positive.
Then all the calling code will react in the same way as before. The break is then for the actor one down.

`Add.me set S` and `Add set B abc` is to is to add to a set. Sets do not have duplicates.
A flag gets set in the window stack if a duplicate was added.
`Break cmds for . True` will end this actor is the flag is set.
`Check set B abc` does not add, only checks.
The `Add.break, Check.break`, will break the actor loop like the single `Break` command.
To get more break options, use a separate `Break` command.
The `Add var` also does a check to see if the value added is the same. Like `Add.break var done`


