### Database version

Added the domain node so that models can be loaded and re loaded separately into the database.
The model names is now unique within the domain.
The frame has a reference to a domain - mainly to its own domain.
The a's references the model in the frame's ref domain.
A new link type `Q1` was added for this type of reference.
Only in the db version. Need to use this gen to re gen it - see gen.sh

All the a's in a frame would link into its domain ref.
There is no link type, but the frame's name can be used for that.

The reference id's are not stored in the database. The refs
can be relinked, after selecting the data, with the `Refs` command.

In the database, the refs can be emulated with select joins
`select name from domain,model,frame,a where a.pk_id = 5
and frame.pk_id = a.parent_id and domain.name = frame.domain
and model.parent_id = domain.pk_id and model.name = a.model`

And back, `select a.name from domain,model,frame,a where model.pk_id = 2
and domain.pk_id = model.parent_id and frame.domain = domain.pk_id
and a.parent_id = frame.pk_id and a.name = model.name`

Other queries may be more usefull, or the generator can
incrementaly select what it needs.


