The actor are like functions that can be called
and a case like statement that matches.
The match is (var exp string), the string can have variables in it.
Actors of the same name, are the case items.
They are given an input node to operate on.
The actor has a list of commands it runs through.

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


