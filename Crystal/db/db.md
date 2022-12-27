### Database version

Added the domain node so that models can be loaded and re loaded separately into the database.
The model names is now unique within the domain.
The frame has a reference to a domain - mainly to its own domain.
The a's references the model in the frame's ref domain.
A new link type `Q1` was added for this type of reference.
Only in the db version. Need to use this gen to re gen it - see gen.sh

All the a's in a frame would link into its domain ref.
There is no link type, but the frame's name can be used for that.

The memory reference id's is only usable if the complete data set
is loaded at once into the database. The refs
can be relinked, after selecting the data, with the `Refs` command.

In the database, the refs can be emulated with select joins
`select name from domain,model,frame,a where a.pk_id = 5
and frame.pk_id = a.parent_id and domain.name = frame.domain
and model.parent_id = domain.pk_id and model.name = a.model`

And back, `select a.name from domain,model,frame,a where model.pk_id = 2
and domain.pk_id = model.parent_id and frame.domain = domain.pk_id
and a.parent_id = frame.pk_id and a.name = model.name`

The `update_ref.act` updates the refs on the database. This makes the selects easier.
The `cre_tbl3.act` adds the ids for this.

In the `note.unit`, the `Q1` links to a node where the node's parent is is referenced by a
field that is in the link's parent node.

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

	Element domain     R1 WORD       * ref to domain
	Element name       C1 WORD       * frame name
	
Ref domain Domain ?

----------------------------------------------------------------
Comp A parent Frame FindIn
----------------------------------------------------------------

	Element model      Q1 WORD       * ref to model
	Element name       C1 WORD       * a name

Refq model Model domain Frame ?
```

The `Refq` uses the `Q1` field `model`. The link goes to node of type `Model`.
It uses the `domain` field (the one with the `R1`) to be used as the parent `(Domain)` to find the `Model` in.
This is the same as `L1` except the `domain` field is not in `A`, but in `A's` parent, `Frame`.


```
----------------------------------------------------------------
Comp Use parent A
----------------------------------------------------------------

	Element frame      Q1 Frame      * ref to frame
	Element a          L1 A          * ref to a in frame

Refq frame Frame model A ?
Ref2 a A frame ?
```

The `Ref2` uses the `L1` field `a`. The link goes to node of type `A`.
It uses the `frame` field (the one with the `Q1`) to be used as the parent (`Frame`) to find the `A` in.


