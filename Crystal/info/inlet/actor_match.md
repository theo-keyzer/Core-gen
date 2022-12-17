Actor have a case like match on all the actors of the same name.
`Actor list_act Node name = tb1`, here it matches the varable `name` to `tb1`
The `&=` would be false if the previous one failed. The `|=` would be true if the previous one was true.
The variable has a `?` option like `name? = tb1`. This would fail if `name` does not exist.
No error is printed and the global errors flag is not updated - not seen as an error.

