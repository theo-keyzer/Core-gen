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

On the `Where` node, `Its attr` is the same as `Its parent.attr` with an actor match of `name = ${.prev_act.attr}`.
The `Its table` is the same as `Its attr.table`.
The `Its from_id` is the same as `Its table.attr` with an actor match of `name = ${.prev_act.from_id}`
The `Refu` is the `attr.table` part and the Ref2, the `.attr` with the match.
The second `Refu` chains to another `table2`. So `Its table2` is the same as `Its from_id.table`.
So now another `Ref2` can go from there.

To go from the `Attr` node to the `Where` node, `Its Where_attr` is the same as
`Its parent.where` with actor match `attr = ${.prev_act.name}` and
`Its Where_from_id`, the same as `Its parent.where` with actor match `from_id = ${.prev_act.name}`


For refs fields, the variable names work the same as as the `Its` command.
On the `Attr` node, it can use `${Where_attr.from_id.name}` and `${Where_from_id.attr.name}`

The `Its` command can hadle none to many relations. The variables will give an error if none,
or just use the first one. It asumes you know wat jou are doing.

```
----------------------------------------------------------------
Comp Where parent Type
----------------------------------------------------------------

	Element attr     F1 Attr      * Field name
	Element from_id  M1 Attr      * From id

Ref     attr Attr check
Ref3 from_id Attr attr Attr table check
```

This is the same example as above as used by some of the other versions.
They use the `Ref3` that is not in this version. Just does more in one step.

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

```
----------------------------------------------------------------
Comp A parent Frame FindIn
----------------------------------------------------------------

	Element model      Q1 Model      * ref to model

Refq model Model domain Frame ?
```

This is the same example as above as used by some of the other versions.
They use the `Refq` that is not in this version. Just does more in one step.
Just here to explain how it worked and how to translate older examples to here.

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

Variables can't use values from child nodes (this version). If needed, navigate with the `Its` and 
store that node with the `Add var Lookup` command.
Then later when needed, use the variable `${._var.Lookup.name}` to get the `name` value of the stored node.

The `Break` command if the most mystifying of them all. Every version has a diffrent implentation of it.
And going back to some older version's code base means its not clear what it does.

This version has an option to break specifying what actor it apyies to, making more usefull and clear.

The `Break` command is the same as `Break actor` as it is the default.

The codes returned by the break is 1 for loops, 2 for actor and 3 for commands.
The `go_act` function in `gen.py`, will continue if the break was for the comands.
It will return 0 if its is for the actor. Else return the value.

The generated code for the `Its` will continue as long is the return is 0, else returns the returned value.
The commands in the `go_cmd` function that deal with loops, will continue if the return is for the loops or 0.
Else it returns the returned value. There is no need for a loop continue as a break for the actor will continue the loop if there was one
or continue with the calling actor.

When the `Break` command specifies the actor the break applies to, it makes the return value negative
and puts a flag on the actor one up in the calling stack. The actor with the flag on in the `go_act` function will return this value as positive.
Then all the calling code will react in the same way as before. The break is then for the actor one down.

The following are some changes. This is to get the older test cases to work.

`Add var N` to add the current node and `Add var Z this is ${name}` to add a string value.
To use it is `${._var.N.name}` or `${._var.Z}`.
`Add set S` and `Add set B abc` is to is to add to a set. Sets do not have duplicates.
A flag gets set in the window stack if a duplicate was added.
`Break cmds for . True` will end this actor is the flag is set.
`Check set B abc` does not add, only checks.
Previous versions, the `Unique,Check` commands had the `Break` builtin.

`Clear set S` to empty it.
`This set.S actor` to call an actor with the set items, for strings in the calling actor, use `${._str}` for the item's value.
The `(_)` is there to not be an actor name. `${._arg}` is the value of the argument passes to this actor.
The `${._key}` variable is the value of the key used for when all keys are used ( `This list actor` ).
The previous versions use the `All` instead of the `This` command for this.

The files `run.py, structs.py` are made with the `gen.sh` in `bld, app/bld` dirs.
They go to the `bld/src, app/bld/src` and can be copied to `src, app/src` if they look ok.
They both use the same program from `src`, but uses different unit files.
The `p_run.act, p_struct.act` are the same for both, but can drift.
The `gen.py, act.unit` will drift. Better to have different app dirs for different projects
to more reliably go back in time. There is no need to keep them in sync.

The `match1.act` is to get a new note from items related to the given keywords.
This can be edited and added to the the `notes.def` file.
The `name` of `A` is the most relatavant word in the `info` field.


There is also a `p_struct2.act`  in the `app/bld` that is intended to be used by an standalone app that does not use the `gen.py`
and any actor files. It has  the `get_list, get_var` functions to get the values from the loaded def files.

In `app/tst2` there is an example of this in `main.py` that loads a def file and navigates through the model.
If the def files captures all the detail to generate an app, an app can also just use the def files.









