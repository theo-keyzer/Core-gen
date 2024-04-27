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
It uses the internal variable names to be able to also use the parent link.

These run in the second pass in the order of the the `Element`s of the `unit` files.
Can get a `not resolved` error if some thing uses a later item.
There is a multi pass option `refs_multi_pass` to solve this.

The `Refu,Ref2` combination replaces the `Ref3,Refq` of other implementations.



