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
is hard coded to navigate this graph.

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

At this point it seemed that multiple steps is better because it can handle more variations and easier to work with.

The `Refu,Ref2` are dependent on other relations that may be not resolved yet.
For this it does a multiple passes, but can get stuck on cirular ones.
All references start off as -1. As they get resolved they change, or go to -2 for no match.
A count of all the -1 ones are returned and when 0, the multiple pass stop.
If the count remains the same between passes, it mean it is stuck and not more passes are needed.
It then does another pass to display the errors. This is only needed for when a single pass does not work.
It is also possible to have some error in the unit files for an unresolved reference.
An unresolved reference is an error even if no match is not.

To use this option, the `err = run.refs(glob.acts)` in main.py need to be changed to `err = run.refs_multi_pass(glob.acts)`

Variables can't use values from child nodes (this version). If needed, navigate with the `Its` and 
store that node with the `Store in Lookup` command.
Then later when needed, use the variable `${.Lookup.name}` to get the `name` value of the stored node.


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












