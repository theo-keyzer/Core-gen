Motivation for Conversion:

The primary motivation for simplifying the join syntax should be to improve accessibility for novice users. By offering a more intuitive and self-documenting approach, you can lower the learning curve and encourage wider adoption of the system.

Benefits of a Custom DSL for Input:

Here's a breakdown of the value proposition of a custom Domain-Specific Language (DSL) for input:

    Reduced Complexity: A custom DSL can provide a more concise and focused language specifically tailored to defining data models and their relationships. This reduces the need for users to learn a general-purpose programming language or a complex configuration format.
    Improved Readability: Custom DSLs can leverage keywords and syntax conventions that are meaningful within the context of the data model. This makes the input files easier to understand and maintain, especially for non-technical users.
    Error Prevention: By enforcing specific structures and validation rules within the DSL, you can help prevent syntax errors and invalid configurations during input definition. This leads to more robust and reliable data models.
    Extensibility: A well-designed custom DSL can be extended to accommodate future requirements without significantly altering the existing syntax. This allows for future growth and adaptation of the system.
    Separation of Concerns: Defining input using a dedicated DSL separates the data model from the processing logic of the application. This promotes code clarity and maintainability.

Added the `Join` to the generator for the `app/tst/def_unit.act` to convert the refs usable for the `unit` files.

The `Join attr to Attr` will find a path to the `Attr` and create the `Element` and the refs to link them.
The `Join a to A using frame`, will use `frame` element to find the `A` comp.
The `Join table from Type using attr Attr table` will copy the `table` field from the comp referenced by the `attr` element.


