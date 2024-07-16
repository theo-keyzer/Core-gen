
## Introduction
It converts the input to output.

## Actors.
The actor node has a list of commands to run.
It uses a data node or object passed.
The actor has a match condition.

Actor variables.
The actor match has access to the same variables as the commands in the actor has.
The match is string based.
The idea is to have a separate match function for the node option that compares data objects.

Actor flow.
Multiple actors of the same name can match, and the Break command stops any further matches.

Actor commands.
The Du, All, Its, This and That commands call other actors.

Actor function.
The go_act function in the run-time engine processes the actor call.
It calls the go_cmds function to process the command list.

Actor generated.
The generated code for the actors is the loader and data classes.
No runtime code is generated for this.

## The Commands.
The command nodes.

Command generated.
The generated code for the cmds is the loader and data classes.
No runtime code is generated for this.

Actor commands.
The commands has access to the variables and functions in the node object of the actor.

## Data Nodes.
The data nodes.

Node variables.
The variables are the node items.
Or node items related via a path.

Node commands.
The Its command gets other related nodes via a path.

Node functions.
The get_var function in the generated code get the values for the varaiables.
The do_its function there calls the go_act function with a related node.

Node generated.
The generated code for the nodes is the loader, data classes and run-time functions.

Node flow.
The code in the nodes can chain to other node functions.
A path is passed for the route.
The returned code can end loops.

## Node options.
Command node options is specified like Add.me.break.
This is separated to the Add token and a list with the rest.
Data node options is the same.
This is to add extra options to a node without changing the input file format.
Options do not have a value, but can be parsed later on.

Option commands.
The command is Its options.

Option variables.
The variable name is options.

## Collection Nodes.
The collection nodes.
Any data can be added here.
It has a map for the collections.
A node path uses the same format for variable names as it does for the Append and This commands.

Commands.
They are Add and This.
The This path actor, calls the actor with the node of the path.
The This path. actor, calls the actor in a loop with each map or list entry.
The This command uses a path as starting point whereas the Its command uses the current node to start.

Add.
To add to a list, its Add path string.
To add to a map, its Add path:key string.
Add _:D abc, put the string into the D.
Add.list _:L, creates the list to L.
Add _.L abc, adds the string abc to the L list if L is a list.
Add.map _:M, creates the map M.
Add _.M:S abc adds the abc string to S entry of the map M if M is a map.
Add.map _.M:M2, creates the map M2 in the Map M if M is a map.

Areas.
It has a node path to specify where to add.
The (.) is the current node. If it is a node entry, it is without the (.).
The (_) is for the collection nodes.

Options.
They are me, node, json, eval, map, list, file and strs to specify what to add. It defaults to the string provided.
The break is to break out of the actor loop for duplicates.
Its also sets a break flag for the Break command to use for advanced breaks.

Option check.
This is to check that no duplicates are added.

Option clear.
For the list and map, it will recreate it if there and create it if not.
Without the clear, it will not recreate it if already t and create it if not.

Option node.
This is add a node object versus a string of it.

Option me.
This is to add the current object.

Option strs.
The string value is processed via the strs function to replace variable names.
The result is passed to the strs function again to further replace variable names.
This is for when a variable has a variable name in it.

Variables.
For the D it is _.D.
If the value is a data node, the path works the same as the data node.
If the value is a map, the path is in the map.
Any items can have data nodes in it.
