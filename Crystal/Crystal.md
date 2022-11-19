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
The `Du` inherits this value.
 
# Variable errors

The errors land up in the generated code to track down the error.
Some commands make use of the `s_get_var, strs` functions that would return
the error, but the commands ignore them. The errors are printed though.

This to get as much done as posible. The exit code is 1 for errors.

# Loader errors

The input file loader, prints errors as it goes along, mainly the parent and refs.
The run time only checks these, but does not generate errors.

# Other input files.

The Json, Yaml and Xml are addons that operate the same way that the rest does.
May need some more work here.

# Collections

These are to collect data for later use.

The `Collect` and `Hash`, store the current node's instance.
The `Unique` and `Group` store strings - does not duplicate.

The `Hash` can be accessed as a var `${.Hash.A.Open.foo}`, the others by the `All` command.

These denormalizes the input to be more elegant for the generator.
 
# Var command

This creates a named entry in the the current node's instance.
The `Var foo = bar`, sets the variable. To access it, `${foo}`
The `Var .list_act.foo = abar`, set the variable in the node instance that is current
in the `list_act`. The current actors are on the stack. To access it, `${.list_act.foo}`,
or when on that node instance (back to the list_act), `${foo}`.

Also has a `regex` that can break down the string as named entries.

# Startup

The generator takes a `,` separated list of actor files followed
by a `,` separated list of def input files. They each are all lumped together.

The first actor's name, is the starting actor. The `go_act` function
loop through all actors with this name.

All comand line arguments are store in the starting node instance as named entries.
They are `${0}, ${1}` variables. To access these variables else where, prefix it with
the starting actor's name like `${.main.1}`.

# Variables

The `${name} ` gets replaced by the value of the variable `name`. To escape the `${`, use `$${`
The case conversion letter `c` like `${name}c`, captilize the variable's value.
The `${.arg}` is the value of the argument passed from the previous actor.
The `${eval}$`, it replaces the eval with the `strs` function of the value of `eval`.
That is to get a code block from a separate file and print it `C ${code_block}$`.

# Actor match

Actor have a case like match on all the actors of the same name.

`Actor list_act Node name = tb1`, here it matches the varable `name` to `tb1`
The `&=` would be false if the previous one failed. The `|=` would be true if the previous one was true.
The variable has a `?` option like `name? = tb1`. This would fail if `name` does not exist.
No error is printed and the global errors flag is not updated - not seen as an error.

# Actor calls

The `All, Its and Du` commands, calls the `new_act` function to set up
a new actor window on the stack. It passes the match data `(variable, eq, value)` and `arg` string.
The value is evaluated from the current node instance.
The `Du` command calls `go_act` with the current node instance, the others, the generated code that call `go_act`.
The `go_act` function uses the new node instance. The match uses this instance
and return if the match failed. Then it loops through all actors with its given name.
Each of these actors, have there own match data and skips the ones that do not match.

# Input files

The input files are word based separated by tabs or spaces. The last column
can be a variable string `(V1)`, that is the string to the end of the line.
There is one whitespace between the previous word and it. Use a padding word
before it to get all the columns alligned if needed.

# Refs

The `R1` is a ref to another node, `F1`, ref to local node,
`L1`, ref to local node of the `R1`, M1, ref to local node of an element of `R1`
of a node that has a `L1` ref.

```
----------------------------------------------------------------
Comp Attr parent Type FindIn
----------------------------------------------------------------

	Element table    R1 TABLE            * Pointer to (Table).
	Element name     C1 NAME             * Colomn name.

Ref table Type check

----------------------------------------------------------------
Comp Where parent Type
----------------------------------------------------------------

	Element attr     F1 Attr      * Field name
	Element from_id  M1 Attr      * From id
	Element eq       C1 WORD      * =
	Element id       F1 Attr      * id

Ref     attr Attr check
Ref       id Attr check
Ref3 from_id Attr attr Attr table check

```

The `Ref3` uses the `M1` field `from_id`. The link goes to node of type `Attr`.
It uses the `attr` field to get to `Attr` node. In that node it uses the `table` field
to be used as the parent `(Type)` to find the `Attr` in.
The `from_id, attr` can be different node types.
The refs run in a sequence at `Element` level. So the `F1, R1` must be before the `M1`.

To use the links from the `Where` node, use `attr,from_id,id`. To use it from the `Attr` node,
use `Where_attr, Where_from_id, Where_id`. These are the reverse links that loops to match.
The `Its` cmd will get them all, The variables will get the first one.

The `L1` is a simpler model of this, it uses the `R1` instead of the `F1` to get to the parent.
The `F1` share the same parent. The `R1` finds the parent - top level nodes.






`










