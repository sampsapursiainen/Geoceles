Geoceles (© 2018 Sampsa Pursiainen) is a simple tool for finite element 
based forward and inverse simulations in geimaging of small planetary bodies. 
With Geoceles, one can segment  a realistic multilayer geometry and generate 
a finite element mesh, if triangular surface grids (in ASCII DAT file format) 
are available. The current version also allows using a graphics card to 
speed up the mesh segmentation as well asforward (lead field) and inversion 
computations. Geoceles inherits from the Zeffiro Interface for Brain Imaging
(© 2018 Sampsa Pursiainen). Instructions can be found at: 

https://github.com/sampsapursiainen/zeffiro_interface/wiki


Quick tips to start: 

1. Install Matlab Parallel Computing Toolbox
2. If using Geoceles on a standard laptop or desktop computer without GPU, 
edit the row 4 of the geoceles.ini file into "UseGPU 0". The default is 1. 
