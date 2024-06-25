Comp (Component) = Table
Each Comp definition is essentially describing a table structure.
Element = Field
The Element entries within a Comp are describing the fields or columns of that table.
Ref, Ref2, Refu = Relationships
These seem to be defining different types of relationships or links between the tables (Comps) and their fields (Elements).

This analogy helps to clarify the overall structure being described in the document. It suggests that the system is defining a data model with interconnected components, similar to a relational database schema but with some additional complexity in how the relationships are defined and navigated.
The parent attribute in the Comp definitions could be seen as establishing a hierarchy or inheritance between tables, which is a concept that goes beyond simple relational database models.
The Find and FindIn attributes might be related to how these components can be searched or queried within the system.
With this understanding, the document appears to be describing a sophisticated data modeling and navigation system, with the ability to define complex relationships and navigation paths between different data components.

The definition of `Comp,Element` from gen.unit.

```
----------------------------------------------------------------
Comp Comp parent . Find
----------------------------------------------------------------
* Loader definition for defining components.
----------------------------------------------------------------

	Element name   C1 NAME          * of component.
	Element nop    C1 WORD          * ignored.
	Element parent R1 COMP          * its parent.
	Element find   C1 WORD          * if need to be found.
		Opt Find                    * for top level comps
		Opt FindIn                  * for nested comps
		Opt .                       * has no name field or not needed.
	Element doc    V1 WORD          * documentation string

Ref parent Comp .

----------------------------------------------------------------
Comp Element parent Comp FindIn
----------------------------------------------------------------
* Loader definition for defining component's elements.
----------------------------------------------------------------

	Element name C1 NAME  * of element
	Element mw   C1 WORD  * storage type
		Opt C1          * word
		Opt V1          * string to end of line.
		Opt F1          * link to local comp - same parent - needs a Ref.
		Opt R1          * link to top level comp - Find - needs a Ref.
		Opt L1          * link to child of previous link - uses R1,U0 for first, L1 for chain - needs a Ref2.
		Opt N1          * nested comp
		Opt U0          * copies a link from a previous link  - no input - needs a Refu
	Element mw2  C1 WORD  * parser type - not used
	Element pad  C1 WORD  * separator
	Element doc  V1 WORD  * documentation string

```

The definition of `Ref,Ref2,Refu` from gen.unit.

```
----------------------------------------------------------------
Comp Ref parent Comp
----------------------------------------------------------------
* Relation of element to comp
----------------------------------------------------------------

	Element element F1 ELEMENT       * link to local element
	Element comp    R1 COMP          * link to comp
	Element opt     C1 WORD          * optional or check - error if not found
		Opt check                    * check - error if not found
		Opt .                        * optional, if value is also a (.)
		Opt ?                        * no error if not found
	Element var     C1 WORD          * not used
	Element doc     V1 WORD          * doc string
	
Ref element Element check
Ref comp Comp       check
	
----------------------------------------------------------------
Comp Ref2 parent Comp
----------------------------------------------------------------
* Relation of element to comp and child of comp
----------------------------------------------------------------

	Element element  F1 ELEMENT       * link to remote element
	Element comp     R1 COMP          * linking Comp
	Element element2 F1 ELEMENT       * use this link for remote parent
	Element opt      C1 WORD          * optional or check - error if not found
		Opt check                 * check
		Opt .                     * optional value to use
	Element var      C1 WORD          * not used
	Element doc      V1 WORD          * doc string
	
Ref element  Element check
Ref comp     Comp    check
Ref element2 Element check
	
----------------------------------------------------------------
Comp Refu parent Comp
----------------------------------------------------------------
* Copy of element to comp and child of comp
----------------------------------------------------------------

	Element element  F1 ELEMENT       * link to remote element
	Element comp     R1 COMP          * linking and ref Comp
	Element element2 C1 ELEMENT       * use this element 
	Element comp_ref R1 COMP          * ref Comp if comps differ
	Element element3 C1 ELEMENT       * use this link from element for remote parent
	Element opt      C1 WORD          * optional or check - error if not found
		Opt check                 * check
		Opt .                     * optional value to use
	Element var      C1 WORD          * not used
	Element doc      V1 WORD          * doc string
	
Ref element  Element check
Ref comp     Comp    check
Ref comp_ref Comp    check
```

These make up the defintions for the core generator to generate the application generators.
They live in bld and app/bld2 (newer version).

May sound abstract, but it defines itself. May get yourself lost by modifing it.

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

The `Its` command navigates from the current node to other nodes via its relations.
The `All` command, navigates to all node of a type.

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

The  core generator is the building blocks needed to define the input schema to generate the application generator.
Each generator has its own schema, but the the run-time engine is common to all.

The generated code of the generators is used to load input files, navigate between nodes and get values from a node. The run-time engine uses a script like file that interacts with the generated code.

The unit files (schema) define what the input files look like. The loader loads the input into the generated classes and build up the the relations between them.
The loader is generated based on the unit files.
The core generator has the generated loader and classes for loading and navigating unit files.

