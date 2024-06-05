The generator takes a `,` separated list of actor files followed
by a `,` separated list of input def files. They each are all lumped together.

The first actor's name, is the starting actor. The `go_act` function
loop through all actors with this name.

All comand line arguments are store in the starting node instance as named entries.
They are `${0}, ${1}` variables. To access these variables else where, prefix it with
the starting actor's name like `${.main.1}`.

From here, other actors are called with the `All, That, This` commands.

The calling actor would then have a node instance it can use to output text
or to navigate further.

