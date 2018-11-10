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

Articles in utilizing the IAS inversion method for asteroids: 

Pursiainen, S., & Kaasalainen, M. (2013). Iterative alternating sequential
(IAS) method for radio tomography of asteroids in 3D. Planetary and Space
Science, 82, 84-98.

Pursiainen, S., and M. Kaasalainen. "Detection of anomalies in radio
tomography of asteroids: Source count and forward errors." Planetary and
Space Science 99 (2014): 36-47.

Pursiainen, S., & Kaasalainen, M. (2014). Sparse source travel-time
tomography of a laboratory target: accuracy and robustness of anomaly
detection. Inverse Problems, 30(11), 114016.

Pursiainen, Sampsa, and Mikko Kaasalainen. "Electromagnetic 3D subsurface
imaging with source sparsity for a synthetic object." Inverse Problems
31.12 (2015): 125004.



