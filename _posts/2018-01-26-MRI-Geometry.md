---
layout: post
title: MRI Data Representation and Geometry
---

An introduction to the representation of data and geometry in neuroscience MRI.

## Introduction

MRI data is usually discussed as if analyzing it were the most natural thing in the world. In
reality, however, the alignment of volumes and the interpolation of data between representations is
only simple in theory. Similarly, the storage of surface data is usually opaque and
unintuitive. This post describes the fundamentals of geometry as it applies to MRI brain data with
an emphasis on FreeSurfer.

## File Formats

All volume-based formats store 3D or 4D arrays of voxels in some fashion with a variety of
additional meta-data. Anatomical images are typically 3D while EPIs are typically 4D (x,y,z, and
time).

### Volume Data (EPIs and Anatomical Images)

Volumes are typically stored in one of a few ways:

* DICOM (.dcm) files are the de-facto standard for MRI machines in most cases; the format is
  somewhat involved and is documented fully [here](https://www.dicomstandard.org/current/) (though I
  don't suggest trying to learn the format from this page.) Though some of the meta-data in dicom
  files is not always transferable to other formats, it's usually preferable not to operate on dicom
  files directly during data analysis.
* NifTI (.nii or .nii.gz) files were created by the NIH as a solution to a previous file format
  called ANALYZE that was widely seen as problematic. These files are probably the most commonly
  used format for sharing/distributing MRI data as of when this post was written. They are usually
  gzipped (.nii.gz) in order to save space. The NifTI standard has a few versions, but most
  libraries and programs that read one will read all, and I've rarely if ever encountered issues
  with the NifTI version of a file. The NifTI header allows one to store a variety of meta-data that
  are most important for data analysis.
* MGH (.mgh or .mgz) files are essentially FreeSurfer's version of the NifTI file; the formats are
  fairly similar, at least within the perspective of the scope of this post. MGH files are typically
  gzipped (.mgz) to save space much like NifTI files.
* Other formats, like ANALYZE, don't appear very often in my experience, and are beyond the scope of
  this post.

#### Typical Meta-Data

Consider the following problem: I give you a T1-weighted MR image of a subject and ask you to tell
me if you think the subject's left hemisphere occipital cortex is unusually large. You open the file
and see something that looks like this:

![example_volume]({{ site.baseurl }}/images/mri-geometry/example_volume.gif
                  "Example Slices from a T1w volume")

Looking at this, you might conclude that, if anything, the left hemisphere is a little smaller in
the occipital cortex than the right. If you were to email me that response, I would probably respond
with something like this: "Are you sure you're looking at the left hemisphere? Maybe your MRI viewer
is using radiological coordinates? (I.e., where the RH appears on the left of the image)". In fact,
this is the case with the above GIF, and, in fact, this subject's left hemisphere is slightly larger
than their right (though not abnormally so).

The confusion here extends from different standards for how we look at MRI data. Most researchers I
have met tend to think about the brain from a first person perspective, meaning that they expect the
RH to be on the right side of an image, the LH to be on the left side of an image, the superior
brain to be on the top of the image, etc. When they see a horizontal slice, as in the animation
above, they assume that they are looking *down* onto the brain rather than *up* into the
brain. However, imagine you are a radiologist performing an MRI scan on a patient; you might be in
the habit of thinking about the brains of patients as if you were sitting in front of the scanner
with them laying supine--as if you were looking forward into your subject's inferior brain. The
following image (click-through to original context at [VTK.org](http://vtk.org/)) illustrates the
problem:

[![mri_coords](https://www.vtk.org/Wiki/images/thumb/e/ed/DICOM-OrientationDiagram-Radiologist-vs-NeuroSurgeon.png/800px-DICOM-OrientationDiagram-Radiologist-vs-NeuroSurgeon.png "Cartoon demonstrating an issue with MRI coordinate systems")](https://www.vtk.org/Wiki/Proposals:Orientation#DICOM_LPS_Differences_in_Visualization_presented_to_Radiologist_and_NeuroSurgeons)

Additionally, consider that even if every MRI scanner and neuroscientist in the world used the same
coordinate system, this would make it easy to tell which hemisphere was which, but it wouldn't
guarantee that two scans of the same subject were necessarily aligned: subjects don't necessarily
have their heads in identical positions between scans.

Accordingly, we need to be able to, at a minimum, store some amount of information about the
coordinate system employed in any MRI volume file, and ideally some amount of information about how
to precisely align the brain to some standard orientation.

##### Background: Affine Transformations

Linear transformations in 3D Euclidean geometry fall into a few categories:
* <p style="vertical-align: middle;"><img src="{{ site.baseurl }}/images/mri-geometry/affine_scaling.png" style="width: 250px;" alt="Scaling"/></p>
* <img src="{{ site.baseurl }}/images/mri-geometry/affine_reflection.png" style="width: 250px; vertical-align: middle" alt="Reflection"/>
* ![affine_rotation]({{ site.baseurl }}/images/mri-geometry/affine_rotation.png =250x)
* ![affine_transposition]({{ site.baseurl }}/images/mri-geometry/affine_transposition.png =250x)
* ![affine_shearing]({{ site.baseurl }}/images/mri-geometry/affine_shearing.png =250x)
* Other:  $$f(x,y,z) = (0,0,0)$$ is technically a linear transformation, but transformations not
  listed above don't usually come up in neuroscience, and even shearing is very rarely used.

Usually, in neuroscience, the only transformations that matter or reflection, rotation, and
transposition; occasionally scaling comes into play as well. Of these four transformations, all but
transposition can be represented together in a \\(3 \times 3\\) matrix where:

$$ \begin{pmatrix}x\\y\\z\end{pmatrix} = \begin{pmatrix}a & b & c\\d & e & f\\g & h & i\end{pmatrix}
     \cdot \begin{pmatrix}x_0\\y_0\\z_0\end{pmatrix}. $$
     
For more information about how matrices can act as linear transformations, see [this
page](http://mathworld.wolfram.com/LinearTransformation.html) for a technical description and [this
page](http://linear.ups.edu/html/section-LT.html) for more of a linear algebra review. [This
page](https://www.tutorialspoint.com/computer_graphics/3d_transformation.htm) is also decent for
getting some intuition about the connection between the matrices and the transformations
themselves.

Transposition can be done by simply adding a 3D vector to this result. However, an alternate way to
store transposition along with the other transformations described above is to use a \\(4 \times
4\\) matrix, which is often called an *affine transformation matrix*. We write this transformation
as:

$$ \begin{pmatrix}x\\y\\z\\1\end{pmatrix} = \begin{pmatrix}a & b & c & t_x\\d & e & f & t_y\\g & h &
     i & t_z\\0 & 0 & 0 & 1\end{pmatrix}
     \cdot \begin{pmatrix}x_0\\y_0\\z_0\\1\end{pmatrix}. $$

Because they can succinctly store all of these transformations in a single matrix, affine
transformation matrices are used in neuroscience volume files to tell the user how to align the data
contained within them to some standard reference.


## (Under Construction)










