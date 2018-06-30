# MultiStageDesign
Optimal Multistage filter design parameters estimation tool sets for Matlab that is presented in paper [1]. The folder "FilterDesign" contains the different multistage filter design methods that presented in paper [2].

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

**Reference:**

[1] X.Zhu, Y. Wang, W. Hu, et al. “Practical considerations on optimising multistage decimation and interpolation processes,” to appear. “IEEE International Conference on Digital Signal Processing”, Beijing, 2016 OCT 16-18.
[2] Y. Wang, J. D. Reiss, “Time domain performance of decimation filter architectures for high resolution sigma delta analogue to digital conversion”, 132nd AES Convention, Budapest, Hungary, April 26–29, 2012.
