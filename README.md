# Generates code for code generators.

They each have a diferent schema for storing the domain knowledge.

Uses a memory database for loading the domain data
and has generated classes to load, retreive and navigate the data.

The files are ini like - line based.
The nodes has a configured parent and are tied
to the above parent.

# This is an actor language.

The actor are like functions that can be called
and a case like statement that matches.
The match is (var exp string), the string can have variables in it.

Actors of the same name, are the case items.

They are given an input node to operate on.

The actor has a list of commands it runs through.

The `C` command prints the output. The `${var}` are the variables of the node.
The variables are generated.

The `Its` command calls another actor with some relation node of it.
This way it can navigate the input tree. The relations are generated.

The `All` command calls another actor that has no relation to it.

It loads the actor and input files and starts at the first actor it has.
The loader is generated.

The actor engine is not generated. It can be customized and extended without
changing the generated code. At some point the generated code needs to
be adjusted as its calls back to the actor engine or the engine wants it to be different.

# Input files

The code generator has a input schema file `gen.unit` to define these nodes
and the relation between them.
```
----------------------------------------------------------------
Comp Comp parent . Find
----------------------------------------------------------------
* Loader definition for defining components - nodes
----------------------------------------------------------------

	Element name       C1 NAME      * of component.
	Element nop        C1 WORD      * readable padding.
	Element parent     R1 COMP      * its parent.
	Element find        C1 WORD      * if need to be found.
	    Opt Find                    * for top level comps
	    Opt FindIn                  * for nested comps
	    Opt .                       * has no name field or not needed.
	Element doc        V1 WORD      * documentation string

Ref parent Comp .

----------------------------------------------------------------
Comp Element parent Comp FindIn
----------------------------------------------------------------
* Loader definition for defining component's elements.
----------------------------------------------------------------

	Element name     C1 NAME  * of element
	Element mw       C1 WORD  * storage type
	    Opt C1                * one word
	    Opt V1                * string to end of line.
	    Opt F1                * link to local comp - same parent - needs a Ref.
	    Opt R1                * link to top level comp - Find - needs a Ref.
	    Opt L1                * link to child of previous link - R1 for first, L1 for chain - needs a Ref2.
	Element mw2      C1 WORD  * data type - not used
	Element pad      C1 WORD  * separator
	Element doc      V1 WORD  * documentation string

```
Here the generator defines itself.


The sample application schema `app.unit` is defined is a similar way.
```
----------------------------------------------------------------
Comp Table parent . Find
----------------------------------------------------------------

	Element name  C1 WORD * a table
	Element pad   C1 WORD * padding, as
	Element value C1 WORD * value

----------------------------------------------------------------
Comp Field parent Table FindIn
----------------------------------------------------------------

	Element name       C1 WORD     * a field name
	Element dt         C1 WORD     * data type
	Element pad        C1 WORD     * padding - to make it more readable.
	Element use        C1 WORD     * grid,search
	  Opt   grid                   * display field in grid on search screen
	  Opt   dropdown               * small select options on capture screen
	  Opt   popup                  * popup search window for value on capture screen
	  Opt   search                 * input for search

----------------------------------------------------------------
Comp Join parent Table
----------------------------------------------------------------

	Element field1  F1 .Field       * link to its field
	Element pad    C1 WORD         * padding - to make it more readable.
	Element table2 R1 Table        * link to other table
	Element field2  L1 Table.Field  * link to other table's field

Ref  field1 Field check
Ref  table2 Table check
Ref2 field2 Field table2 check
```
Here `F1` is a internal reference meaning it links to a field inside a table. 
Both the join and field share the same parent `Table`. Only works if the parents are the same.

The `R1` means that its a reference field. The `Ref` defines the relation
The `L1` is a double link that needs both a table and a field to link to.
The `Ref2` defines the relation for this. It uses the `table2` to get to the `field2`. 
The `table2` needs to be a R1 and be before `field2`.

You need a `Ref` for each `R1,F1` and a `Ref2` for each `L1`. This is what the loader uses for the linking
and what the classes need for navigation and variable lookups.
The `Find` and `FindIn` is for the lookup dict - relies on `name`.
The `R1` needs to go to a `Find` and `L1,F1` need to go to `FindIn`.

The check means it is a error if not found. A dot `.` can be used as optional.

This definition `app.unit` is used by the code generator to build the sample application generator.
```
gen s_check.act   app.unit,act.unit 
```
This would print out errors if somethink is wrong. 
Errors would end up in the generated source files if ignored.
```
gen s_load.act   app.unit,act.unit > sample/load.swift 
gen s_struct.act app.unit,act.unit > sample/structs.swift 
```
The actor template files `s_load.act,s_struct.act` generate the output based on the defintions.
The actor definition file `act.unit` has a schema to define the actor language. This
gets included into the sample app, as it too need to generate.

The `util.swift` has the string utils and the `main.swift` is the runtime engine. 
Both can be copied from the gen application and customized.

Once complied, it works the same as above.
```
sample tst.act tst.def
```
The input definition file `tst.def` is shown here.
```
----------------------------------------------------------------
Table tb1 as a
----------------------------------------------------------------

Field t1f1 NUM   display dropdown
Field t1f2 FLOAT dispaly normal,grid

----------------------------------------------------------------
Table tb2 as b
----------------------------------------------------------------

Field t2f1 VAR display normal,grid

Join t2f1 to tb1 t1f1
```
Here the `Join` links the `t2f1` field to the `t1f1` field of table `tb1`.

The actor/template like language is to navigate the input data nodes.
The actor ends up in an instance of a class. From there
it can print the fields of the instance and go to another actor.

# Actor input files

The actor template file `tst2.act` is shown here.
```
----------------------------------------------------------------
Actor arg
----------------------------------------------------------------

All Table table_sel

----------------------------------------------------------------
Actor table_sel Table
----------------------------------------------------------------

Out delay

Cs Select (

Its Field field_sel
Its Join join_sel

Cs ) from ${name}  ${value} 

Its Join join_from
Its Join join_where

C

----------------------------------------------------------------
Actor field_sel Field use has grid
----------------------------------------------------------------

Cs ${.1., } ${parent.value} .${name} 

----------------------------------------------------------------
Actor join_sel Join
----------------------------------------------------------------

Its table2.Field join_field_sel

----------------------------------------------------------------
Actor join_field_sel Field use has grid
----------------------------------------------------------------

Cs , ${parent.value} .${name} 

----------------------------------------------------------------
Actor join_from Join
----------------------------------------------------------------

Cs , ${table2.name}  ${table2.value} 

----------------------------------------------------------------
Actor join_where Join
----------------------------------------------------------------

Cs  ${.0.where } ${.1.and } ${parent.value} .${field1.name}  = ${table2.value} .${field2.name}
```

The output would be:
```
Select (a.t1f2) from tb1 a
Select (b.t2f1, a.t1f2) from tb2 b, tb1 a where b.t2f1 = a.t1f1
```
The `Join` class has the `parent,field1,table2,field2` variables that point to `Field,Table` instances.
The `parent` variable goes to the `Table` it belonged to that has the `value` variable. 
The `${.0.}` outputs `where ` if it is the first row and `${.1.}` outputs `and ` if it is not the first row.
The actor has a case like matcher to limit and separate the rows, so it is the first row that matches.
The `${.+}` is the row number. The `${.arg}` is the arument passed.

The `Its` loops on its child nodes `Field,Join`.

It uses the first actor's name `arg` as the starting actor. 
```
All Table table_sel
```
Call the actor `table_sel` for all the instances of the `Table` class.
```
Actor table_sel Table
```
The `table_sel` is the name of the actor, `Table` a reminder that the operations are from the Table class.
It gets a handle on the `Table` class instance. The actor would ignore this actor if the node type passed is not `Table`.
Not checked if it is a `.` or nothing.

The `Cs` prints the output code with no newline. 
```
Its Field field_sel
```
Calls the actor `field_sel` for all its child fields. The `Table` class has the code for `Field,Join`.

The `${name}` is the value of the variable `name` in the `Table` class. 
```
----------------------------------------------------------------
Actor field_sel Field use has grid
----------------------------------------------------------------

Cs ${.1., } ${parent.value} .${name} 
```
The `use` is a variable of the `Field` class.
The `has` match a list of values `normal,grid` from the `use` variable to an item `grid`, `in` works the other way round.

The `${parent.value}`, the parent would go to `Table` and then the value of it.

Variable names are lower case, other has special meaning to get to the value. The same aplies to Its.

The `${.1.}` has the value of `, ` if it is not the first entry.
```
Out delay
```
Delays the output and is triggered by the next actor's output. If the next actor has no
output, it gets disgarded. This is to avoid having empty selects.
```

Its table2.Field join_field_sel
```
The `Join` node has a pointer variable `table2` going to `Table` that has a lsit of fields
that gets passed to the `join_field_sel` actor.

# More

The `${name}l` is to convert it to lower case. The `${name} ` has no conversion.
Variable `${.Table.tb1.name}` global access to input data. Matches the tables's name to `tb1`.
The `${.actor_name.}` access to the node that the actor has.
`Break` - breaks the actor loop - if non matches it can get to the default one.
`Break loop` - break the calling loop - if only needing one.
`Unique` - for not duplication code.
The `&=` on the actor's match is true is the previous one was true. 
The `Its .actor_name` - use that actor's node instead.


# JSON input files

See examples how to navigate json files.

# Building: Swift version 5.6.2
```
mkdir app
cd app
swift package init --type=executable
```
copy source files to Sources/app
```
swift build
```

# Usage

The sample generator is joined with the code generator in src.
You can run the examples from it.

# Version

Small core version that can to be changed as needed.
Can be ported to other languages - mostly generated.
The json and group are examples on how to add plugins.
The `V-lang` version is very simular to this one. The
`golang` version is older and not as well automated.
The `Crytal-lang` one is newer.

# Licence

The MIT License.

# Contribution

You can clone repository to contribute.



