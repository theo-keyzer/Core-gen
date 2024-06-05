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


