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

All volume files contain both **meta-data** and **voxels**. The meta-data is just a set of
information about the file's contents while the voxels are a 3D or 4D array of values.

#### Meta-Data

A quick and easy way to examine an MRI volume file is by using the command `mri_info` from
FreeSurfer; this command understands most MRI file formats and prints about a page of meta-data from
the requested file. Here's an example.

```
> mri_info /Volumes/server/Freesurfer_subjects/bert/mri/brain.mgz

Volume information for /Volumes/server/Freesurfer_subjects/bert/mri/brain.mgz
          type: MGH
    dimensions: 256 x 256 x 256
   voxel sizes: 1.0000, 1.0000, 1.0000
          type: UCHAR (0)
           fov: 256.000
           dof: 1
        xstart: -128.0, xend: 128.0
        ystart: -128.0, yend: 128.0
        zstart: -128.0, zend: 128.0
            TR: 0.00 msec, TE: 0.00 msec, TI: 0.00 msec, flip angle: 0.00 degrees
       nframes: 1
      PhEncDir: UNKNOWN
ras xform present
     xform info: x_r =  -1.0000, y_r =   0.0000, z_r =   0.0000, c_r =     5.3997
               : x_a =   0.0000, y_a =   0.0000, z_a =   1.0000, c_a =    18.0000
               : x_s =   0.0000, y_s =  -1.0000, z_s =   0.0000, c_s =     0.0000

 talairach xfm : /Volumes/server/Freesurfer_subjects/bert/mri/transforms/talairach.xfm
 Orientation   : LIA
Primary Slice Direction: coronal

voxel to ras transform:
               -1.0000   0.0000   0.0000   133.3997
                0.0000   0.0000   1.0000  -110.0000
                0.0000  -1.0000   0.0000   128.0000
                0.0000   0.0000   0.0000     1.0000

voxel-to-ras determinant -1

ras to voxel transform:
               -1.0000   0.0000   0.0000   133.3997
               -0.0000  -0.0000  -1.0000   128.0000
               -0.0000   1.0000  -0.0000   110.0000
                0.0000   0.0000   0.0000     1.0000
```

There's a lot of information here, not all of which is in the scope of this post. Here are a few of
the most important pieces of information:

* **type** (MGH) just tells us the file format.
* **dimensions** (256 x 256 x 256) tells us the number of voxels in each dimension. FreeSurfer volumes
  usually have the size \\(256 \times 256 \times 256\\) as in this example.
* **voxel sizes** (1.0000, 1.0000, 1.0000) tells us the thickness of the voxels in each direction. Here
  we see that the voxels are 1 mm\\(^3\\) in size, but EPIs often have differently sized voxels or
  voxels that are not isotropic (e.g., \\(1.5 \times 2 \times 2\\) mm\\(^3\\)).
* **type** (UCHAR (0)) refers to kind of value stored in each voxel; in most formats (MGH and NifTI)
  this can be a variety of sizes of integers or floating-point numbers. UCHAR means unsigned
  character, which is a misleading name (derived from an outdated precedent in C) for a single byte
  that can be between 0 and 255. Usually, for volumes containing parameters or measurements, this
  type will be a 32 or 64 byte floating-point value; for labels these will be integers.
* **fov** and **dof**, as well as **TR**, **TE**, **TI**, **flip angle**, and **PhEncDir**, are all
  parameters related to MRI aquisition and are beyond the scope of this post.
* **xstart**/**xend**, **ystart**/**yend**, and **zstart**/**zend** tell us how FreeSurfer
  interprets the voxels in this volume as a 3D coordinate system (more on this later).
* **nframes** tells us the number of frames in a 4D volume. Frames are almost always stored in the
  volume as the last (4th) dimension.
* **three transformations** appear in the output in the form of \\(4\times 4\\) matrices; we will
  discuss these shortly transformations shortly.
* **Orientation** (LIA) and **primary slice direction** (coronal) tell us roughly how the volume is
  organized (more about this below also).

Note that the above values are not the only meta-data in an MGH file, and NifTI files have a
slightly different set of meta-data that includes things like fields to specify the intent of the
data (examples of intents: time-series data, parameters data, shape data). Full documentation of the
meta-data in these formats is beyond the scope of this post, but you can read more about MGH file
headers [here](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/MghFormat) and more about NifTI
file headers [here](https://nifti.nimh.nih.gov/pub/dist/src/niftilib/nifti1.h). That latter link is
a well-commented C header-file; for a more human-readable explanation, try
[here](https://brainder.org/2012/09/23/the-nifti-file-format/).

Another good way to look at the meta-data in a volume file is to load it with the relevant
programming environment and examine the data-structures there. Here are a few examples (click to
expand):

* Python (using [nibabel](http://nipy.org/nibabel/))
  ```python
  import nibabel                      as nib
  import nibabel.freesurfer.mghformat as mgh
  
  # MGH/MGZ files
  mgh_file = mgh.load('/Volumes/server/Freesurfer_subjects/wl_subj042/mri/brain.mgz')
  mgh_file.header['dims']
  #=> array([256, 256, 256,   1], dtype=int32)
  mgh_file.header.get_affine()
  #=> array([[-1.00000000e+00, -1.16415322e-10,  0.00000000e+00,  1.32361809e+02],
  #=>        [ 0.00000000e+00, -1.90266292e-09,  9.99999940e-01, -9.83241651e+01],
  #=>        [ 0.00000000e+00, -9.99999940e-01,  2.23371899e-09,  1.30323082e+02],
  #=>        [ 0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  1.00000000e+00]])
  
  # NifTI files
  nii_file = nib.load('/Volumes/server/Freesurfer_subjects/ernie/mri/ribbon.nii.gz')
  nii_file.header['datatype']
  #=> array(2, dtype=int16)
  # (Note: the header data loaded by Nibabel are quite unprocessed and opaque)
  ```
* Python (using [neuropythy](https://github.com/noahbenson/neuropythy), which wraps nibabel)
  ```python
  import neuropythy as ny
  
  sub = ny.freesurfer_subject('wl_subj042')
  sub.mgh_images['brain'].header['dims']
  #=> array([256, 256, 256,   1], dtype=int32)
  sub.voxel_to_native_matrix
  #=> array([[-1.00000000e+00, -1.16415322e-10,  0.00000000e+00,  1.32361809e+02],
  #=>        [ 0.00000000e+00, -1.90266292e-09,  9.99999940e-01, -9.83241651e+01],
  #=>        [ 0.00000000e+00, -9.99999940e-01,  2.23371899e-09,  1.30323082e+02],
  #=>        [ 0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  1.00000000e+00]])
  ```
* Matlab
  ```matlab
  addpath(genpath('/Applications/freesurfer/matlab')); % (FS installation dir on Mac)
  
  mgh = MRIread('/Volumes/server/Freesurfer_subjects/wl_subj042/mri/brain.mgz');
  mgh.volres
  %
  % ans =
  % 
  %     1.0000    1.0000    1.0000
  %
  mgh.vox2ras
  %
  % ans =
  % 
  %    -1.0000   -0.0000         0  132.3618
  %          0   -0.0000    1.0000  -98.3242
  %          0   -1.0000    0.0000  130.3231
  %          0         0         0    1.0000
  %
  %   % Note that this is the same matrix as in Python, just rounded better
  
  tbUse vistasoft;
  % ...
  
  nii = niftiRead('/Volumes/server/Freesurfer_subjects/ernie/mri/ribbon.nii.gz');
  nii.dim
  % 
  % ans =
  % 
  %    256   256   256
  %
  ```
* Mathematica (using [Neurotica](https://github.com/noahbenson/Neurotica))
  ```
  <<Neurotica`
  
  mghFile = Import[
    "/Volumes/server/Freesurfer_subjects/wl_subj042/mri/brain.mgz",
    {"GZIP", "MGH"}];
  Options[mghFile, VoxelDimensions]
  (*=> {1., 1., 1.} *)
  
  niiFile = Import[
    "/Volumes/server/Freesurfer_subjects/ernie/mri/ribbon.nii.gz",
    {"GZIP", "NifTI"}];
  Options[niiFile, VoxelDimensions]
  (*=> {1., 1., 1.} *)
  ```

##### Affine Transformations and Orientations

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


##### Affine Transformations and Orientations

###### Background

Linear transformations in 3D Euclidean geometry fall into a few categories:
* <img src="{{ site.baseurl }}/images/mri-geometry/affine_scaling.png" style="width: 250px; vertical-align: middle;" alt="Scaling"/>
* <img src="{{ site.baseurl }}/images/mri-geometry/affine_reflection.png" style="width: 250px; vertical-align: middle" alt="Reflection"/>
* <img src="{{ site.baseurl }}/images/mri-geometry/affine_rotation.png" style="width: 250px; vertical-align: middle;" alt="Rotation"/>
* <img src="{{ site.baseurl }}/images/mri-geometry/affine_translation.png" style="width: 250px; vertical-align: middle;" alt="Translation"/>
* <img src="{{ site.baseurl }}/images/mri-geometry/affine_shearing.png" style="width: 250px; vertical-align: middle;" alt="Shearing"/>
* Other: $$f(\boldsymbol{v}) = \boldsymbol{0}$$ is technically a linear transformation, but
  transformations not listed above don't usually come up in neuroscience, and even shearing is very
  rarely used.

Usually, in neuroscience, the only transformations that matter are reflection, rotation, and
translation; occasionally scaling comes into play as well. Of these four transformations, all but
translation can be represented together in a \\(3 \times 3\\) matrix where:

$$ \begin{pmatrix}x\\y\\z\end{pmatrix} = \begin{pmatrix}a & b & c\\d & e & f\\g & h & i\end{pmatrix}
     \cdot \begin{pmatrix}x_0\\y_0\\z_0\end{pmatrix}. $$
     
For more information about how matrices can act as linear transformations, see [this
page](http://mathworld.wolfram.com/LinearTransformation.html) for a technical description and [this
page](http://linear.ups.edu/html/section-LT.html) for more of a linear algebra review. [This
page](https://www.tutorialspoint.com/computer_graphics/3d_transformation.htm) is also decent for
getting some intuition about the connection between the matrices and the transformations
themselves.

Translation can be done by simply adding a 3D vector to this result. However, an alternate way to
store translation along with the other transformations described above is to use a \\(4 \times
4\\) matrix, which is often called an *affine transformation matrix*. We write this transformation
as:

$$ \begin{pmatrix}x\\y\\z\\1\end{pmatrix} = \begin{pmatrix}a & b & c & t_x\\d & e & f & t_y\\g & h &
     i & t_z\\0 & 0 & 0 & 1\end{pmatrix}
     \cdot \begin{pmatrix}x_0\\y_0\\z_0\\1\end{pmatrix}. $$

Because they can succinctly store all of these transformations in a single matrix, affine
transformation matrices are used in neuroscience volume files to tell the user how to align the data
contained within them to some standard reference.

###### Orientations

In the example image (illustrating the radiological/neurological perspective conflict) above, it is
clear that were the radiologist and the neurologist to design different file standards for an MRI
volume file, they might prefer to organize the voxels in slightly different ways. The radiologist
would probably want the slices of the image stored in the file starting with the bottom of the head
(as slice 0) and ending with the top of the head; the neurologist may want the slices stored in a
different order. In fact, there's no particular right or wrong way to store the slices, and the
slices needn't even be horizontal slices. In some experiments the slices will be coronal or
sagital. In order to efficiently express the ordering of the rows, columns, and slices of the file,
a standard three-letter code can be used where each letter indicates the direction
(**R**ight/**L**eft, **A**nterior/**P**osterior, **S**uperior/**I**nferior) that is increasing for
the particular dimension; for example, orientation SPL would indicate that the first dimension is
pointing in the **S**uperior direction, the second dimension is pointing in the **P**osterior
direction, and the third dimension is pointing in the **L**eft direction. **WARNING**: the
convention I just described is used by FreeSurfer and other software but not *all* software. In
particular, I believe that AFNI uses the opposite notation, where SPL would instead be represented
as IAR; however, I do not use AFNI myself and unsure if this is (still) true. Check your favorite
software's documentation to be certain!

The most common orientations I see are:

* **RAS**. The way we typically think about the position and coordinate system of our own brain is
  in a RAS orientation where the \\(x\\)-axis points out your right ear, the \\(y\\)-axis points
  out your nose, and the \\(z\\)-axis points out the top of your head. Surface files are almost
  always stored in a RAS coordinate system, and many other volume files are as well.
* **LIA**. FreeSurfer uses LIA orientation for all of its volumetric data files. This means that
  the first dimension stored in the volume increases to the left, the next increases to the right,
  and the slices increase from posterior to anterior. I do not completely understand why this
  particular orientation was chosen by MGH. [This
  website](http://www.grahamwideman.com/gw/brain/fs/coords/fscoords.htm) is very useful for
  understanding FreeSurfer's volumetric coordinate system more fully.
* **LPS**. The Winawer lab A/P slice prescription in various protocols (e.g., that used for
  retinotopy) yields LPS oriented volume files.

###### Relationship to Voxels and Volumes

NifTI and MGH files always contain at least one affine transformation matrix, as we saw in the
examples above. The purpose of this transformation varies by file, however. In most cases, the
matrix is used to tell the user how to align the voxels with some other reference. This reference
might be a standard brain/space such as Talairach coordinates or MNI, or it might be the coordinate
system for the surface representation of the brain.

Regardless of what the affine transformation aligns the voxels *to*, the coordinates being
transformed are usually the 0-based indices of the voxels, which I will call \\((i,j,k)\\). So, for
example, if \\(\mathbf{M}\\) is a \\(4\times 4\\) affine transformation matrix from the header of a
volume file, then:

$$ \begin{pmatrix}x\\y\\z\\1\end{pmatrix} = \mathbf{M} \cdot \begin{pmatrix}i\\j\\k\\1\end{pmatrix} $$.

There is no single convention for what an affine transformation in a volume file actually means, so
**it is unwise to assume that you know the correct orientation of a file you obtained from someone
else** just because the affine transformation looks familiar. The NifTI file standard in fact
includes two affine transforms, the "qform" and the "sform" with special numbers in the header that
are supposed to give the user a hint as to what the transformations align the voxels
to. Interpreting these values is beyond the scope of this post; I generally suggest keeping the
qform and sform matrices identical in NifTI files to avoid confusion.

**FreeSurfer.** The affine transformation stored in most FreeSurfer mgh/mgz files in a subject's
directory (such as those shown in the examples above of brain.mgz) align the voxel indices with
a RAS oriented space that I usually call "FreeSurfer native"; confusingly, this is not quite the
same coordinate system as used in FreeSurfer's surface files, though this transformation can be
derived from them. See the section on surface data below for details on how FreeSurfer's various
coordinate systems align.




## (Under Construction)

