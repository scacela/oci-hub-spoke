Example: how spoke computes get assigned to spoke subnets and named appropriately:

Variables:
2 spokes              (1,   2)
2 subnets per spoke   (a,   b)
2 computes per subnet (-1, -2)

I. First, spoke subnets are created.
   Below shows the relationship between the spoke subnet's indices and attributes:

num spokes * num subnets per spoke = 2 * 2 = 4
|
|
(oci_core_subnet.network_spoke_sub[i]): (spoke num)(if using 2 subnets, subnet a or b)
|                                          |          |
|   _______________________________________|          |
|  | _________________________________________________|
|  || 
0: 1a
1: 1b
2: 2a
3: 2b

II. Then, attributes of the spoke subnet instance are assigned to a spoke compute instance.
    Below shows the relationship between the spoke compute's indices and attributes:

num spokes * num subnets per spoke * num computes per subnet = 2 * 2 * 2 = 8 
|
|
(oci_core_instance.spoke_compute[i]): (spoke num)(if using 2 subnets, subnet a or b): -(num computes per spoke)
|                                          |          |                                    |
|   _______________________________________|          |                                    |
|  | _________________________________________________|                                    |
|  ||   ___________________________________________________________________________________|
|  ||  | _
0: 1a -1  |
1: 1b -1  |_
2: 2a -1  | \
3: 2b -1 _|  \ 
         _   num 2 sets of indices for 2 computes per spoke
4: 1a -2  |  /
5: 1b -2  |_/
6: 2a -2  |
7: 2b -2 _|