
## Introduction
A start.

## Actors
The actor node has a list of commands to run.
It uses a data node or object passed.

Actor variables.
The actor match has access to the same variables as the commands in the actor has.

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

## The Commands
The command nodes.

Command generated.
The generated code for the cmds is the loader and data classes.
No runtime code is generated for this.

Actor commands.
The commands has access to the variables and functions in the node object of the actor.

## Data Nodes
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

## Node options
Command node options is specified like Add.me.break.
This is separated to the Add token and a list with the rest.
Data node options is the same.

Option commands.
The command is Its options.

Option variables.
The variable name is options.

## Collection Nodes
The collection nodes.
Any data can be added here.
It has a dict for var, set and list.
The Add command can also add to the current node (me), or to a path to a node (node).

Collection commands.
They are Add, Clear, Check and This.
The This command is also path driven like the Its command.
The This command uses the var, set and list as starting point whereas the Its command uses the current node to start.

Collection areas.
They are var, list, set, node and me to specify where to add.

Collection options.
They are me, node, json, eval to specify what to add. It defaults to the string provided.
The break is to break out of the actor loop for duplicates.
Its also sets a break flag for the Break command to use for advanced breaks.

Collection variables.
For debugging, ._list.D, ._set.D
For the var.D it is _.D
If the var is a data node, it works the same as the data node.
If the var is a dict, it is the dict items.
A dict var can have data nodes in it.
The path is then via the dict into the data node.

## Json Nodes
The json nodes is converted to python nodes.
The are dict, list and objects.

Json commands.
They are Add.json, That json

Json variables.
The variables are the dict items.
Or nested dict items via a path.
