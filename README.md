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
 
