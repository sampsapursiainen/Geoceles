Geoceles (© 2018 Sampsa Pursiainen) is a simple tool for finite element 
based forward and inverse simulations in geoimaging of small planetary bodies. 
With Geoceles, one can segment  a realistic multilayer geometry and generate 
a finite element mesh, if triangular surface grids (in ASCII DAT file format) 
are available. The current version also allows using a graphics card to 
speed up the mesh segmentation as well asforward (lead field) and inversion 
computations. Geoceles inherits from the Zeffiro Interface for Brain Imaging
(© 2018 Sampsa Pursiainen). Instructions can be found at: 

https://github.com/sampsapursiainen/zeffiro_interface/wiki

Article in which Geoceles has been used: 

Sorsa, L. I., Takala, M., Bambach, P., Deller, J., Vilenius, E., Agarwal, 
J., Carroll, K., Karatekin, O., & Pursiainen, S. (2020). Tomographic 
inversion of gravity gradient field for a synthetic Itokawa model. Icarus, 
336, 113425.

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

Quick tips to start: 

- Install Matlab Parallel Computing Toolbox

- If using Geoceles on a standard laptop or desktop computer without GPU, 
edit the row 4 of the geoceles.ini file into "UseGPU 0". The default is 1. 

- Create a surface model in which layers are numerally in an ascending
order from the innermost to the outermost, i.e., from inside Deep 1, Deep
2, Surface 1, Surface 2, etc.

- The surfaces and sensors can be scaled (via "scaling"). For example
points distributed over a unit sphere can be scaled to 10 km orbit size
using 10000 as the scaling factor. Similarly any surface model can be
scaled to its actual size.

- The detail layers 1-4 can be placed deep inside and they render fine.

- One needs to choose the meshing resolution in the main window (it is the
element size in meters), so that the meshing routine works appropriately.
For example, 3 meters for a 200 m diameter object.

- After that the volume mesh can be created (volume mesh button).

- One needs to choose a suitable number of basis functions (lead field
size in main window). For example, 500. The default in the box is 50000
which is kind of a large value.

- Then by pressing the lead field button the lead field will be created.
One can choose between the vector gravimetry and scalar gravimetrly in the
"imaging method" drop-down box. For me, the scalar version has been easier
regarding choosing the inversion parameters.

- After generating the lead field, one needs to press" basis
interpolation" if the LF interpolation option has not been checked. This
will enable inverting the data and creating a 3D image out of the
reconstruction.

- Then one needs to generate synthetic data (if there is no real data
available) with the dialog box that opens in the "forward tools" menu. The
real data can be imported in the same menu as well. In the data creation
toolbox, one can create a small density anomaly to be localize. One can
also change the layer densities in the main window before calculating the
data. In that case, one needs to press the "update density" button after
the update.

- Now the system can be inverted with one of the tools inthe inverse tools
menu. For example IAS MAP Estimation. That will require shape and scale
parameters as regularization parameters as the input. Also the number of
iterations needs to be fixed. The reconstruction will be obtained after
pressing start.

- The reconstruction can be visualized after the inverse iteration by
choosing Recon. Volume or Recon. Surface as the visualization type in the
main window and then clicking either visualize volume or visualize
surfaces.
