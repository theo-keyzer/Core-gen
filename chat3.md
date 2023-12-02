# Code Generation System Overview

## Custom Generator

The system is designed to generate custom code generators based on the specifications provided in 'unit' files. These 'unit' files define the format of the input data, and actors are responsible for parsing and navigating this input data.

## Input Format Definition

- 'Unit' files describe the format of input data.
- Actors are designed to work with instances of input nodes, implying a structured and hierarchical input format.

## Relational Input

- The input data is relational, suggesting that there are relationships between different elements or entities.
- The 'Its' command is used to navigate to child nodes or related nodes within the input data structure.

## Actor Functionality

- Actors are functions that operate on input node instances.
- The 'Its' command allows actors to navigate to child nodes or nodes related by some form of relationship.
- This implies a hierarchical structure in the input data that can be traversed during code generation.

## Customization and Flexibility

- The ability to generate custom code generators provides a high degree of customization and flexibility.
- The generated code can adapt to different input structures and generate output accordingly.

## Use of Commands

- Various commands like 'Cs' for output, 'Out delay' for delaying output, and others are used in actor templates to define behavior during code generation.

## Parsing and Navigation

- Actors are responsible for parsing and navigating the input data, implying a level of abstraction and separation of concerns.

## Hierarchical Structure

- The mention of relational input and navigation to child nodes suggests a hierarchical structure in the input data.

Overall, the system appears to be designed for generating code generators that can handle diverse input formats with relationships between entities. Actors, through their commands, define the behavior of code generation based on the specific characteristics of the input data. This design allows for a versatile and extensible approach to code generation.

### Defining Relationships in 'unit' Files:

## Elements in a 'unit' File

-   'unit' files contain definitions of components or entities. Each component has elements, and these elements can include references (`Ref`) to other components.
    
## Example of a 'Ref' Relationship

-   Here is an example of how a 'Ref' relationship can be defined in a 'unit' file:

```
        ----------------------------------------------------------------
        Comp Join parent Table
        ----------------------------------------------------------------

        	Element field1  F1 .Field       * link to its field
        	Element table2 R1 Table          * link to another table
        	Element field2  L1 Table.Field    * link to a field in the other table

        Ref  field1 Field check
        Ref  table2 Table check
        Ref2 field2 Field table2 check
```

-   In this example, the 'Join' component has relationships with a 'Field' (`field1`), another 'Table' (`table2`), and a 'Field' in the other table (`field2`).
    
## Explanation

-   `field1`: Refers to a 'Field' component (using 'F1').
-   `table2`: Refers to a 'Table' component (using 'R1').
-   `field2`: Refers to a 'Field' component in `table2` (using 'L1' and 'R1').
    
## Use of 'Ref' Relationships

-   These relationships are crucial for establishing connections between different components or entities in the data model.

### 'Its' Command Navigating Relations:

## 'Its' Command

-   The 'Its' command is a versatile command in the actor template that allows navigation to child nodes or related entities based on the relationships defined in the 'unit' file.
    
## Example 'Its Join' Command

```
    ----------------------------------------------------------------
    Actor join_sel Join
    ----------------------------------------------------------------

    Its table2.Field join_field_sel`
```

## Explanation

-   In this example, the 'Its Join' command is used to navigate to the child nodes of type 'Field' (`table2.Field`) related to the 'Join' component.
    
## Result

-   For each instance of the related 'Field' components in `table2`, the 'join_field_sel' actor will be invoked, allowing specific actions or code generation for each related field.

### Summary:

The combination of defining relationships through 'Ref' in 'unit' files and utilizing the 'Its' command in actor templates provides a powerful mechanism for navigating and operating on related entities within the context of the actor template. It enables a dynamic and flexible approach to processing data based on established relationships.


