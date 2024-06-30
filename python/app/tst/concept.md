
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
Data node options is not implemented, but can be added if meaningful.

## Collection Nodes
The collection nodes.
Any data can be added here.

Collection areas.
They are var, list and set.

Collection commands.
They are Add, Clear, Check and This.

Collection options.
They are me, json, eval and break.

## Json Nodes
The json nodes.
