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
The actor loop `go_act` would return 1 if its return is 1.
The return 1 will end up in the calling `Its, All` command that 
will continue with the `go_cmds`. The generated code loop functions
would return the result if `!= 0`.

The other implementations make use of a depth value that gets inc/dec.
It can go back further. The problem is the `Du` command `Do/Jump` 
that may or may not be between the loops.

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
 
# Variable errors

The errors land up in the generated code to track down the error.
Some commands make use of the `s_get_var, strs` functions that would return
the error, but the commands ignore them. They do not land up in the output.
Best is to pass a flag to the functions to print the error. The generator
also need an exit code to indicate that there was errors.

# Loader errors

The input file loader, prints errors as it goes along, mainly the parent and refs.
The run time only checks, but does not generate errors.

# Other input files.

The Json, Yaml and Xml are addons that operate the same way that the rest does.
May need some more work here.

# Collections

These are extra to make interesting test cases.

The `Collect` and `Hash`, store the current node's instance.
The `Unique` and `Group` store strings.

The `Hash` can be accessed as a var, the others by the `All` command.


# Var command

This creates a named entry in the the current node's instance.
Also has a `regex` that breaks down the string as named entries.

# Startup

The generator takes a `,` separated list of actor file followed
by a `,` separated list of def input files. They each are all lumped together.

The first actor's name, is the starting actor. The `go_act` function
loop through all actors with this name.

All comand line arguments are store in the starting node instance as named entries.
They are `${0}, ${1}` variables. To access these variables else where, prefix it with
the starting actor's name like `${.arg.1}`.

# Variables

The `${name} ` gets replaced by the value of the variable `name`. To escape the `${`, use `$${`
The case conversion letter `${name}c`, `c`, captilize the variable value.
The `${eval}$`, it replaces the eval with the `strs` function of the value of `eval`.
That is to get a code block from a separate file and print it `C ${code_block}$`.









