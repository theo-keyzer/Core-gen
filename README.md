# Intro

Processes data with actor files (templates).
The data can be in files, json, database, web or its `def` files.
The `def` file format is defined in `unit` files.
The `unit` files are like a database schema and the `def` files
are like database data. Extra setup steps need to be done if needed.

Other template generators has the output as text with code embedded.
Here it has special commands to format and output text.

The document is for the python version.


# Startup
Start.
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


# Variable
Variable names.
Variable names are from the current node with options to get other values.
The ${name} gets replaced by the value of the name item.
The `${_.D}` is from the var D and`${_.D.build.domain.name}`, a route to name.
The routes are via a dict or def relations.

The following are variables from the actor window.

The `${}` is the current node.
The `${._key}` variable is the value of the key used for when all key and values are used ( `This list. actor` ).
The `${._lcnt} or ${.-}` is the loop counter.
The `${.+}` is the loop counter plus 1.
The `${._arg}` is the argument passes to the actor.
The `${.0.first} {.1.rest}` is the text first if the loop counter is 0 and rest if > 0.

The `${.main.1}`, uses the `main` actor in the window calling stack for its current node to get the varaible.
The other window variables are also available like `${.main..arg}`
The `Du` command, calls another actor, but should have the same variable values.

The following are global.

The `${._list.A}`, the value is the list item.
The `${._set}`, the value is the set dict.
The `${_.D}` is like `${._var.D}`.
The `${._ins}` is output captured between the `In on, In off` commands.

The format options, reformats the value. `${name:u}` converts it to upper case.
If the item is a list, `${:-}` is the value at the loop index.
The `${:sort:join}`, sorts the list and the output is `a,b,c` string.

The `strs` function in gen.py`, replaces the variable names of a string with their values.
Some of the actor commands, calls this function for an item so that the item can be combined with variables.
This is not done for every item, and can be added if needed. 

### Purpose
The use cases.
- Output -  print variable value.
- Match -  compare value.
### Special
Special variable names are prefixed by (.).
- Window -  .actor, the def of the actor.
- Collections -  .\_set, .\_var, .\_list
- Counters -  .+, loop counter.
- Depth -  .\_depth, the actor stack depth.
- Arg -  .\_arg, argument passed from previous actor.
- Conditional -  .0, first or rest of loop counter.
- Eval -  \$, the content is re evaluated.
- Optional -  ?, no error on var.
### Errors
Variable name errors.
The errors land up in the generated code to track down the error.
Some commands make use of the `s_get_var, strs` functions that would return
the error, but the commands ignore them. The errors are printed though.


# Actor
The actors
The actor are like functions that can be called
and a case like statement that matches.
The match is (var exp string), the string can have variables in it.
Actors of the same name, are the case items.
They are given an input node to operate on.
The actor has a list of commands it runs through.

The actor match also has a `?` to match the variable no error. The `??`, matches the not found error.
There is no error reported when using it. The error can be on both sides of the equation. `name = ${name}`

```
----------------------------------------------------------------
Actor a . model.name ?= test
----------------------------------------------------------------
```

Here the `?=` match for if no error.


```
----------------------------------------------------------------
Actor a . model.name ??
Break
Actor a . model.name = test
----------------------------------------------------------------
```

Here the `Break` will break out of the actor match on error and not get to next one.

```
----------------------------------------------------------------
Actor a . model = test
----------------------------------------------------------------
```

Or in some cases, this would also work as the values are the same for both.

The `?model?` error is no `model` field where as `?model.?`, is no reference to the `model`.



### Purpose
Use cases.
- Navigate -  call actor with a def.
- Collect -  collect defs or strings.
- Limit -  break out of loops.
- Print -  print output text.
### Name
Command names.
- All -  actor call with all nodes of type.
- Its -  actor call with defs related to current node.
- Du -  actor call with the current node.
- This -  actor call with data from collections
- That -  actor call with nodes from external data like url,db,json,file.
- C -  print output line.
- Cs -  print output with no new line.
- Break -  break out of the actor.
- Out -  delay or omitting output based on further output.
- Add -  Add to collections
- Clear -  Clear collections
- Check -  Check unique in collection
#### Collect
Collection commands.
The `Add` command is to add data to the `var,set,list` collections.
It can also add to `me`, the current node, or `node`, some other node.
It has command options `(Add.)` as what to add. It defaults to adding a string.
The options are `node,me,json` The node has a path to a node.

`Add.me var N` is to add the current node and `Add var Z this is ${name}` to add a string value.
To use it is `${_.N.name}` or `${_.Z}`.
`Add.me set S` and `Add set B abc` is to is to add to a set. Sets do not have duplicates.
A flag gets set in the window stack if a duplicate was added.
`Break cmds for . True` will end this actor is the flag is set.
`Check set B abc` does not add, only checks.
The `Add.break, Check.break`, will break the actor loop like the single `Break` command.
To get more break options, use a separate `Break` command.
The `Add var` also does a check to see if the value added is the same. Like `Add.break var done`
The `Add me` is to add to the value to the current node if it is a list,set or dict.
The `Add.me` is a way to differentiate between using the current node or the string value.
A empty string now no longer defaults to the current node.
The order of the command options does not matter. `Add.me.break` is the same as `Add.break.me`
Add list always adds, but it could break before adding a duplicate.
For now, use the `Check list` for duplicates.

The `Add.json var E {"ids": [4,5,6], "userId": 7}` puts a json node in E.
`C ${_.E:} - ${_.E.userId:} ${_.E.ids:}  ${_.E.ids:0}` outputs `{'ids': [4, 5, 6], 'userId': 7} - 7 [4, 5, 6]  4`.
The `(:)` has the variable formating options. Here it converts the object to a string.
It is now possible now to add to this dict with `Add.me var J.${name}`
The `me` is the current node item or it can be a string like `Add var J.${name} ${value}`
The `Add.node var J.${name} _.F`, can add the var F to this dict.
Or `Add.node me ${name} _.F` to add the F var node to the current node. 
The `${_.F}` is a string whereas `_.F` is the value in it. This to navigate the a node tree,
save it in F with `Add.me var F`, then navigate in another node tree and save it there.

The `Add node:_.J ${name} ${value}` is the same as `Add var J.${name} ${value}`



#### Break
Break command.
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



### Call
Actor calls.
The `All, Its, This, That and Du` commands, calls the `new_act` function to set up
a new actor window on the stack. It passes the `arg` string.
The `Du` command calls `go_act` with the current node instance, the others, the generated code that call `go_act`.
The `go_act` function uses the new node instance. The match uses this instance
and return if the match failed. Then it loops through all actors with its given name.
Each of these actors, have there own match data and skips the ones that do not match.

The `Its`, uses the current node, whereas `This`, uses a node from the collection.
They join up to complete a path route.

The `That` uses data from external sources.


#### That
Actor calls.
```
That db from test.db rows SELECT * from ship
That file at inlet/startup.md include
That json of id.json list_act0
That url.get at https://jsonplaceholder.typicode.com/posts/1 response_list
That re_sub ${._var.replace} ${._var.input} output (?<!\$)\$\{((\.)*(\w+)(\.\w+)*)\}n
That regx string ${._var.str} response_list (\w+)\(([\w,\s]+)\)\s+=\s+(\w+)\(([\w,\s]+)\)\s*\*\s*(\w+)\(([\w,\s]+)\)
```


#### Loop
Loop counter.
The `All, Its` command calls `new_act` first that sets the next actor's counter to -1.
The loop calls the `go_act` function, that increments the counter on match.
The `${.-}` is the counter value and `${.+}`, the counter +1.
Also `${.0.string}` for first (if counter is 0) and `${.1.string}` for rest. The value is `string`
The `Du` inherits this value.


### Match
Actor matching.
Actor have a case like match on all the actors of the same name.
`Actor list_act Node name = tb1`, here it matches the varable `name` to `tb1`
`Actor list_act Node name = ${._arg}`, here it matches the varable `name` to the argument passed.
The `&=` would be false if the previous one failed. The `|=` would be true if the previous one was true.
The variable has a `?` option like `name ?= tb1`. This would fail if `name` does not exist.
In this case no error is printed and the global errors flag is not updated - not seen as an error.


#### Matching
Match cases.
- Equal -  (=), var equal to value.
- In -  (in), var is in the value list 
- Has -  (has), var list is in the value
- Is -  (is), sorted var list is the same as the sorted value list 
# Input
Input files.
### File
Input files.
The input files are word based separated by tabs or spaces. The last column
can be a variable string `(V1)`, that is the string to the end of the line.
There is one whitespace between the previous word and it. Use a padding word
before it to get all the columns alligned if needed.


### Other
Other input.
Json files can be loaded at runtime that operate the same way that the rest does.
Other file types are not done here.


### Errors
Load errors.
The input file loader, prints errors as it goes along, mainly the parent and refs.
The run time only checks these, but does not generate errors.


### Types
Data type
- Word - C1, word.
- String - V1, string to end of line.
- Local - F1, link to local comp - same parent - needs a Ref.
- Ref - R1, link to top level comp - Find - needs a Ref.
- Indirect - L1, link to child of previous link - R1 for first, L1 for chain - needs a Ref2.
- Copy - U0, use a ref field in a node that is refed by a field in the current node - needs a Refu.
- Nest - N1, control field of a nested node.
### Nest
Node nesting.
A control field of a nested node. The value 1 is for the top level, 2, next level down and so on.
This is to create a tree from one node type. To navigate to the nodes one level down, use `Its group`.
The value 0 is for nodes that do not form part of this set.
There can be more than one control field for different tree layouts.

```
----------------------------------------------------------------
Comp Frame parent Model FindIn
----------------------------------------------------------------

	Element group      N1 WORD       * search navigation group index tree
```

# Window
Actor stack windows
### Purpose
Use cases.
- Store -  stores values needed.
- Stack -  window are stored on the calling stack.
- Access -  access to stack items.
### Name
Window variables.
- name - actor name
- cnt - loop counter
- dat - node instance
- attr - node variable
- eq - equation
- value - compare value
- arg - argument passed from previos actor
- flno - line number of the calling actor
- is\_on - out delay is on
- is\_trig - out delay is triggered
- is\_prev - previous actor has trigger
- on\_pos - cmd index for trigger
- cur\_pos - current cmd index
- cur\_act - current actor index
# Refs
refs
Knowledge graphs captures information, but may not capture enough detail how to navigate the graph.
The result end up hard codeing the graph's navigation.

The `Ref`'s captures the navigation paths while also ensuring the input is valid.

One input file is used by many actor files to generate even more output files.
So the input needs to be simple for the actors to use and also have enough detail
for the actors to be not hard coded.

The actors also need to be robust enough to deal with input changes.
The input needs to be captued without too much detail.

The core-gen is a boot strap to generate the application generator.
For this it needs the graph diagram of the input. The app generator
is then hard coded to navigate this graph.

For now see the other docs for more detail.

A `Ref` links a nodes's field to some other node. It can only link to nodes
that do not have a parent (top level nodes). These are done in the first pass.

The `Ref2` link to a node by using some other link for the parent to find the node in it.

The `Refu` uses a link to a node and copies some other link of it.

These run in the second pass in the order of the the `Element`s of the `unit` files.
Can get a `not resolved` error if some thing uses a later item.
There is a multi pass option `refs_multi_pass` to solve this.

The `Refu,Ref2` combination replaces the `Ref3,Refq` of other implementations.
```
----------------------------------------------------------------
Comp Table parent . Find
----------------------------------------------------------------

	Element name C1 NAME             * Its name.

----------------------------------------------------------------
Comp Attr parent Table FindIn
----------------------------------------------------------------

	Element table    R1 TABLE            * Pointer to (Table).
	Element name     C1 NAME             * Colomn name.

Ref table Table .
```

On the `Attr` node, `Its table` is the same as `All Table` with an actor match of `name = ${.prev_act.table}`
The `.prev_act` is any actor name that is in the calling stack. That actor has the reference to `Attr` node
that it was working on to get the value of the `table` variable.
```
----------------------------------------------------------------
Comp Where parent Table
----------------------------------------------------------------

	Element attr     F1 Attr      * Field name
	Element table    U0 Table     * the table of the attr
	Element from_id  L1 Attr      * From id
	Element table2   U0 Table     * the table of the from attr

Ref      attr Attr                           check
Refu    table Table  attr    Attr table
Ref2  from_id Attr   table
Refu   table2 Table  from_id Attr table
```

On the `Where` node, `Its attr` is the same as `Its parent.Attr` with an actor match of `name = ${.prev_act.attr}`.
The `Its table` is the same as `Its attr.table`.
The `Its from_id` is the same as `Its table.Attr` with an actor match of `name = ${.prev_act.from_id}`
The `Refu` is the `attr.table` part and the Ref2, the `.attr` with the match.
The second `Refu` chains to another `table2`. So `Its table2` is the same as `Its from_id.table`.
So now another `Ref2` can go from there.

To go from the `Attr` node to the `Where` node, `Its Where_attr` is the same as
`Its parent.Where` with actor match `attr = ${.prev_act.name}` and
`Its Where_from_id`, the same as `Its parent.Where` with actor match `from_id = ${.prev_act.name}`


For refs fields, the variable names work the same as as the `Its` command.
On the `Attr` node, it can use `${Where_attr.from_id.name}` and `${Where_from_id.attr.name}`

The `Its` command can hadle none to many relations. The variables will give an error if none,
or just use the first one. It asumes you know wat jou are doing. The variables can't go into child nodes.

```
----------------------------------------------------------------
Comp Domain parent . Find
----------------------------------------------------------------

	Element name       C1 WORD       * node name

----------------------------------------------------------------
Comp Model parent Domain FindIn
----------------------------------------------------------------

	Element name       C1 WORD       * node name

----------------------------------------------------------------
Comp Frame parent Model FindIn
----------------------------------------------------------------

	Element group      N1 WORD       * search navigation group index tree
	Element domain     R1 Domain     * ref to domain

Ref domain Domain .

----------------------------------------------------------------
Comp A parent Frame FindIn
----------------------------------------------------------------
* Use domain from parent
* The U0 is a hidden field - only has the pointer
----------------------------------------------------------------

	Element domain     U0 Domain     * the domain of frame
	Element model      L1 Model      * ref to model

Refu domain Domain parent Frame domain .
Ref2 model Model domain .

```

Here `Its domain` is the same as `Its parent.domain`. The `Ref2` will then use the `domain`
to find a `model` for it.


The `group` element with the `N1` is a nested field. With the `Its group`, it can get to its 
sub nodes with a value one higher than the current one, up to the one with the same level. The values of zero are skipped.
Previous versions had more directions to navigate.

From the `gen.unit` file of the base generator

```
----------------------------------------------------------------
Comp Comp parent . Find
----------------------------------------------------------------

	Element name   C1 NAME          * of component.
	Element parent R1 COMP          * its parent.

Ref parent Comp .

----------------------------------------------------------------
Comp Element parent Comp FindIn
----------------------------------------------------------------

	Element name C1 NAME  * of element
	Element mw   C1 WORD  * storage type
	Element mw2  C1 WORD  * parser type - not used
	
----------------------------------------------------------------
Comp Ref parent Comp
----------------------------------------------------------------

	Element element F1 ELEMENT       * link to local element
	Element comp    R1 COMP          * link to comp
	Element opt     C1 WORD          * optional or check - error if not found
	
Ref element Element check
Ref    comp Comp    check
	
```

This works the same way as the app unit files do.
On a `Element` node it can get a value in a `Ref` node with `${Ref_element.opt}`
This is because the `Ref` has a link to the `Element` on the `element` field
and this is just a reverse of it. The `Element` node could have included `comp,opt`
and not need the reverse link and just use `${opt}`. But then some of then use `Ref2,Refu`
that has many more fields that also have to be included. Most of the elements do not use refs
and would make it look messy. A usefull technique to master.

Added the `p_check.act` in `app/bld` to see if the units files are correct to some degree.
You can build simular ones to see if the input `def` files are valid for the actor files that use them
as they just assume it is all correct. It can help with debuging.

The `Refu,Ref2` are dependent on other relations that may be not resolved yet.
For this it does a multiple passes, but can get stuck on cirular ones.
All references start off as -1. As they get resolved they change, or go to -2 for no match.
A count of all the -1 ones are returned and when 0, the multiple pass stop.
If the count remains the same between passes, it mean it is stuck and not more passes are needed.
It then does another pass to display the errors. This is only needed for when a single pass does not work.
It is also possible to have some error in the unit files for an unresolved reference.
An unresolved reference is an error even if no match is not.

To use this option, the `err = run.refs(glob.acts)` in main.py need to be changed to `err = run.refs_multi_pass(glob.acts)`

The refs have an option flag to specify how to deal with `not found` errors. If it is `check`,
then it will be an error. If it is `?`, then there is no error.
Otherwise it is the optional value to use when none. It is an error if not found and the value looking for is different to this.
It can be `(.)` or anything else like `None`.



