Graph B-C for 1
Graph C-A for 2
Graph C-A for 1
Graph C-B for 2
Graph A-B for 3
Graph A-C for 2
Graph A-B for 4
Graph B-A for 1
Graph B-C for 4
Graph B-C for 3
Graph B-C for 5

Matrix A B C for 1
Matrix C C C for 2
Matrix A A C for 3
Matrix C B A for 1
Matrix A B C for 2
Matrix A C C for 3
Matrix A C B for 4
Matrix C A C for 5
Matrix C C A for 4


Node n1  parent  . v = 9
Node n11 parent n1 v = 9
 Link n22
Node n12 parent n1 v = 9

Node n2   parent   . v = 9
Node n21  parent  n2 v = 9
 Link n11
Node n22  parent  n2 v = 9
Node n221 parent n22 v = 9
 Link n1
----------------------------------------------------------------
Table tb1 as a
----------------------------------------------------------------

Field t1f1 NUM   display dropdown
Field t1f2 FLOAT dispaly normal,grid

----------------------------------------------------------------
Table tb2 as b
----------------------------------------------------------------

Field t2f1 VAR display normal,grid

Join t2f1 tb1 t1f1 for grid
Join t2f1 tb1 t1f1 for grid


* Some docs

