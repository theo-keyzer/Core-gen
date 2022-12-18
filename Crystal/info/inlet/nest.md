A control field of a nested node. The value 1 is for the top level, 2, next level down and so on.
This is to create a tree from one node type. To navigate to the nodes one level down, use `Its group.right`.
To navigate one level up, use `Its group.left`. The `Its group.up` goes to the node above it of the same level.
The `Its group.down`, to the node below. The value 0 is for nodes that do not form part of this set.
There can be more than one control field for different tree layouts.

```
----------------------------------------------------------------
Comp Frame parent Model FindIn
----------------------------------------------------------------

	Element group      N1 WORD       * search navigation group index tree
```
