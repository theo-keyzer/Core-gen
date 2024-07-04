
## Introduction
It converts the input to output.

## Actors
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
This is to add extra options to a node without changing the input file format.
Options do not have a value, but can be parsed later on.

Option commands.
The command is Its options.

Option variables.
The variable name is options.

## Collection Nodes
The collection nodes.
Any data can be added here.
It has a dict for var, set and list.
The Add command can also add to the current node (me), or to a path to a node (node).
That is if it is a dict or a list.

Commands.
They are Add, Clear, Check and This.
The This command is also path driven like the Its command.
The This command uses the var, set and list as starting point whereas the Its command uses the current node to start.

Areas.
They are var, list, set, node and me to specify where to add.

Options.
They are me, node, json, eval and strs to specify what to add. It defaults to the string provided.
The break is to break out of the actor loop for duplicates.
Its also sets a break flag for the Break command to use for advanced breaks.

Option node.
This is add a node object versus a string of it.
Not as complete as the variable names.

Option me.
This is to add the current object.

Option strs.
The string value is processed via the strs function to replace variable names.
The result is passed to the strs function again to further replace variable names.
This is for when a variable has a variable name in it.

Variables.
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

## Code generation.
Metrics.

Size.
If the input def and actor file size is larger than the generated code, it is a wast of time to build and maintain the system.

Time.
Write twice. Write the code and then see how to generate it.
No point if it is used once.
If it is to expand a system, then it is just to see how to generate it.

Scope changes.
If the scope of the project changes a lot, it make sense to even generate hard coded files.
It becomes easier to re-generate the whole project than to modify parts of it every time.
This where the most errors seem to happen.

Business logic.
The actor deal with the general logic with some exceptions.
This is hard to define as it relates to too many areas.
Better to just code it or hard code the actors for this.
An example of this is form_validate.a in the java. Maybe it can be better.
In short, do not waist time on it. In long, it may interest you to define it.

Refine and optimize.
In a a large system less effort is done to make it better.
The generator is better at refactoring as it reaches a larger area.
If this code can do this, then this code can use it like this.

Complexity.
The actors break down complexity into small parts.
So it can build larger complex systems.

Memory.
The actors have a good memory how to build.
Its like generating employees.

Code.
The code generated is fragments of hand written code.
It is no obscure mess.
It gets reviewed, tested and handed over.

Handover.
The code is handed over to the maintenance team.
The generator is a personal tool and they have no interest or skill in learning it.


Projects to generate are rare, so it is hard to see if it is worth the effort.
With enough skill, all projects can be generated.
Every project expands the generator to build the system.
This make the generator more capable to build a new generator.

## Process
The build process

Robot
The run-rime engine is the the lab robot.
The robot knows where to find items as part of the run-time is generated.
The input def files has the ingredients.
The actor files has the formula for the mixing and instuctions for the robot.

Nodes.
Takes notes.
Separate the formulas from the ingredients.
Start the lab tests.

## Concept
The concept process

Topic.
A document is build for every topic based on its name.
The document links to a section based on the concept to other documents.
The content is shared to all topic files if the topic name is (.)
The content is shared to all topic files within the nested level group if the topic name is (_).

Build.
The topic name is given to build the document.
Multiple topics can be combined like var,cmd.
All topics can be combined with (*).
The import is given to import the files or not.

Concept.
Some of the topics can be concepts.
This is to create links to simular concepts.
The links can then be to relate concepts and topics.
