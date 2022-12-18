
The `R1` is a ref to another node, `F1`, ref to local node,
`L1`, ref to local node of the `R1`, M1, ref to local node of an element of `R1`
of a node that has a `L1` ref.

Sample of of a units file.

```
----------------------------------------------------------------
Comp Attr parent Type FindIn
----------------------------------------------------------------

	Element table    R1 Type             * Pointer to (Type).
	Element relation C1 WORD             * Relation type
	Element name     C1 NAME             * Colomn name.

Ref table Type check

----------------------------------------------------------------
Comp Where parent Type
----------------------------------------------------------------

	Element attr     F1 Attr      * Field name
	Element from_id  M1 Attr      * From id

Ref     attr Attr check
Ref3 from_id Attr attr Attr table check

```

The `Ref3` uses the `M1` field `from_id`. The link goes to node of type `Attr`.
It uses the `attr` field to get to `Attr` node. In that node it uses the `table` field
to be used as the parent `(Type)` to find the `Attr` in.
The `from_id, attr` can be different node types.
The refs run in a sequence at `Element` level. First it does the `F1, R1` ones, then the the `M1, L1` ones.

Sample of def file.

```
--------------------------------------------------------
Type User User
--------------------------------------------------------

Attr Contractor_employee     view contractor_name

Where contractor_name  id_number = contractor_id

---------------------------------------------
Type Contractor_employee Contractor Employee
---------------------------------------------

Attr . . id_number
```

If this data had to be loaded into a database, the foreign links need to be populated.
Need select statements to get to the id's for this. The loader's refs does this.
```
Attr.tablep = Select id from type where name = 'Contractor_employee'
Where.attrp = Select id from attr where name = 'contractor_name' and attr.parentp = parentp
Where.from_idp = Select id from attr where name = 'id_number' and attr.parentp = Atrr[ Where.attrp ].tablep
```

To use the links from the `Where` node, use `attr,from_id,id`. To use it from the `Attr` node,
use `Where_attr, Where_from_id, Where_id`. These are the reverse links that loops to match.
The `Its` cmd will get them all, The variables will get the first one.

The `L1` is a simpler model of this, it uses the `R1` instead of the `F1` to get to the parent.
The `F1` share the same parent. The `R1` finds the parent - top level nodes.

The `check` on the refs, means it is an error if it does find the link. A `(.)` here,
means it is optional link. The value then also need to be a `(.)` if it is optional.
If the value if different, then it is an error if not found. A `(?)` here means
link if can, but no error if not.


