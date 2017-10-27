# MultiStageDesign
Optimal Multi stage filter design parameters estimation tool sets for Matlab

**Usage:**  
In Matlab environment, type  
`DatabaseCreation`  
to create the database of optimal solution sets. then use  
`DesignQuery(D,Df,K,Type)`  
to find out the optimal integer valued solution

**Example:**  
`DesignQuery(2000,0.3,3,'M')`
will give you the result of oversampling rate of 2000, delta f of 0.3, 3 stage design with optimal memory usage design parameters.
 
**Other function:**  
`MyFactors\SortingSet.m` will sort out the compsite number in to number of factors (not necessary prime number), example:  

`>> SortingSet(100,3)`

ans =

     5     5     4
    10     5     2
    25     2     2
