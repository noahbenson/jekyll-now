---
layout: post
title: HCP Data Tutorial using Neuropythy
---

<a name="top"></a>A demonstration of how to use Neuropythy to examine data from the Human Connectome Project

---

## <a name="TOC"></a> Table of Contents

* [Introduction](#introduction)
  * [The Human Connectome Project](#intro-hcp)
  * [The Neuropythy Library](#intro-neuropythy)
  * [Caveats and Warnings](#intro-warnings)
  * [Suggested Background Reading](#suggested-reading)
* [Getting Started](#getting-started)
  * [Getting Access to the HCP Database](#hcp-access)
  * [Setting Up Neuropythy](#neuropythy-setup)
* [Directly Downloading Subjects by ID](#download)
* [HCP Subjects in Neuropythy](#hcp-subject)
  * [The Subject class](#subject-class)
    * [The Many Hemispheres of an HCP Subject](#hemispheres)
      * [The Cortex Class](#cortex)
      * [The FreeSurfer Hemispheres](#freesurfer)
      * [The fs_LR Hemispheres](#fslr)
    * [HCP Subject Images](#images)
  * [HCP Subject Properties](#properties)
  * [Updating Subjects](#updating)
* [Auto-downloading Subjects as Requested](#auto-download)
* [Auto-downloading Retinotopy Data](#auto-retinotopy)

---

## <a name="introduction"></a> Introduction

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

This page describes the use of [the Neuropythy library](https://github.com/noahbenson/neuropythy) to
access data from [the Human Connectome Project](https://humanconnectome.org/). Neuropythy provides
a clean data-oriented interface to the HCP data by presenting it seamlessly as a set of organized
python data objects. These data are provided lazily to the user without any need to worry about the
details of downloading or caching the data itself.

---

### <a name="intro-hcp"></a> The Human Connectome Project

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

The [Human Connectome Project](https://en.wikipedia.org/wiki/Human_Connectome_Project) is a large
research effort to collect multiple types of human neuroscience data. There are many components to
the project, all of which are worth looking into, but this page will deal only with a small part of
it. The first dataset discussed here is the structural data for 1200 healthy adults collected by the
[WU-Minn-Oxford consortium](https://www.humanconnectome.org/); the second dataset is the set of
181 retinotopic maps published by [Benson et al. (2018)](https://doi.org/10.1101/308247). The 181
subjects in the latter dataset are a subset of 1200 HCP subjects--the retinotopic mapping data
itself was collected and preprocessed by the WU-Minn_Oxford consortium then used by Benson et al. to
solve population receptive field (pRF) models throughout the brain.

Both of these HCP datasets are of great value to the scientific community; however, there is a
considerable learning-curve for accessing or understanding either of these datasets. Though HCP
structural data is readily available in the form of a set of highly-structured directories and files
via [their database page](https://db.humanconnectome.org/) as well as
[an Amazon bucket](https://wiki.humanconnectome.org/display/PublicData/How+to+Get+Access+to+the+HCP+OpenAccess+Amazon+S3+B),
user-friendly documentation on these files is difficult to find. Additionally, although there exist
good tools such as [workbench](https://www.humanconnectome.org/tutorials) for interacting with the
data, such tools are not intended to provide a clean data-oriented interface to an open-source
interpreter (in this case, python). [Neuropythy](https://github.com/noahbenson/neuropythy) provides
this interface.

---

### <a name="neuropythy"></a> The Neuropythy Library

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

[Neuropythy](https://github.com/noahbenson/neuropythy/) is a Python library that is intended to
provide a set of useful tools for the analysis of neuroscience data with an emphasis on visual
neuroscience and the cortical surface. It was originally written to work only with
[FreeSurfer](https://surfer.nmr.mgh.harvard.edu/) but has since been extended to understand HCP
subjects as well.

A key feature of Neuropythy's design is that it specifically empowers the user to examine data a
simple hierarchical data object in a REPL environment such as IPython / Jupyter. To this end, data
is never loaded until it is explicitly required and is always memoized upon loading--you don't have
to wait for Neuropythy to read in every file in a subject's directory in order to instantiate a
subject object, and no matter how many times you access a piece of subject data, it will only be
read from disk or calculated the first time it's requested. These features make it good for
exploring data interactively and for prototyping more focused scripts or functions.

A full tutorial of Neuropythy's features is unfortunately beyond the scope of this page, but future
posts will explore Neuropythy more completely. Neuropythy is compatible with both Python 2 and
Python 3; installation instructions can be found on its
[GitHub page](https://github.com/noahbenson/neuropythy/).

---

### <a name="intro-warnings"></a> Caveats and Warnings

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

The author of Neuropythy was not involved the Human Connectome Project directly, and in particular
was not involved in the creation of the HCP data schema; to that end, there is no guarantee that the
author's interpretation of the HCP data schema are 'correct'. In other words; though the author has
interpreted the file `100610/MNINonLinear/fsaverage_LR59k/100610.L.BA.59k_fs_LR.label.gii` to be the
Brodmann area labels for the 59k-vertex-resolution version of the fs_LR atlas conformed to subject
100610's left hemisphere, this interpretation (or that of other files) may not be the interpretation
understood by the HCP internally. The author has spent a lot of time looking through these files and
believes that the interpretation provided by Neuropythy is mostly correct, but users are encouraged
to examine two data structures that explicitly describe the mappings of files to data in an HCP
subject's directory: `neuropythy.hcp.files.subject_directory_structure` and
`neuropythy.hcp.files.subject_structure`; the former describes the mapping in terms of the subject's
directory structure while the latter describes it interms of the subject's neuropythy data
structure.

---

### <a name="suggested-reading"></a> Suggested Background Reading

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

This page is designed to be most informative to people who are already familiar with Python and
IPython notebooks and the basics of MRI and neuroscientific data representation. There are numerous
tutorials available online for Python and IPython (just one example for IPython can be found
[here](https://www.codecademy.com/articles/how-to-use-ipython)), but in addition to these,
familiarity with the [nibabel](http://nipy.org/nibabel/tutorials.html) and
[numpy](https://docs.scipy.org/doc/numpy/user/quickstart.html) /
[scipy](https://www.scipy.org/getting-started.html) libraries can be useful. For information on MRI
data structures in general, see [this tutorial]({ site.baseurl }/MRI-Geometry/). For general
information on retinotopic mapping, see [this turorial]({site.baseurl}/Retinotopy-Tutorial/).

---

### <a name="getting-started"></a> Getting Started

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

This section documents the steps required to get access the the HCP data and to setup Neuropythy.

---

### <a name="hcp-access"></a> Getting Access to the HCP Database

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

The HCP database is free to access, but you must register with the HCP in order to obtain login
credentials. To do so, visit [the ConnectomeDB page](https://db.humanconnectome.org/) and follow the
instructions to create an account. Once you have created an account, you should be able to login to
the database and browse the available datasets. You may use this interface to access the HCP data,
but this page instead describes how to use Neuropythy to access the data via the HCP Amazon S3
bucket. The official information on how to do this can be found
[at this page](https://wiki.humanconnectome.org/display/PublicData/How+To+Connect+to+Connectome+Data+via+AWS).
The first few steps, through the creation of the AWS credentials are required in order to use
Neuropythy as an interface to the data--without these, Neuropythy cannot access the data on your
behalf. Once you have generated your AWS key ("ACCESS KEY ID") and secret ("SECRET ACCESS KEY"), it
is recommended that you put them in a file in your home directory named `.hcp-passwd`; this file
should contain a single line '<key>:<secret>'; e.g.,
`AKIAJXBFCLTXZ4LARDTA:WttGC7//vq1eQ8M90vBTPkZaEBHo1YoKX04RgkHl`. Alternately, you can put them in
environment variables `HCP_KEY` and `HCP_SECRET` or you may pass them to the `download` and
`auto_download` functions as an option `credentials=(key, secret)`.

---

### <a name="neuropythy-getting-started"></a> Setting Up Neuropythy

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

Installation instructions for Neuropythy can be found
[here](https://github.com/noahbenson/neuropythy). It should in general be easy to install Neuropythy
vis `pip install neuropythy` or `pip install --user neuropythy`, but you can also clone the github
tree then run `python setup.py install`.

Note that in order to use the HCP `download` and `auto_download` functions, you will need to install
the [`s3fs`](https://github.com/dask/s3fs) package as well. This package is an optional requirement
for Neuropythy so is not installed by default; however it should be easy to install via `pip` as
well. In order to download and retinotopy data, you will need to have the
[`h5py`](https://www.h5py.org/) package installed as well. In addition, the
[matplotlib](https://matplotlib.org/) library is recommended if you with to use any of Neuropythy's
graphics features (e.g., `neuropythy.graphics.cortex_plot`).

In order to load Neuropythy, you just import it:

```python
import neuropythy as ny
```

Typically, one either sets the `SUBJECTS_DIR` environmental variable to be one's FreeSurfer subjects
directory, and Neuropythy will discover and use this if possible. If you do not set your subjects
directory this way, you can tell Neuropythy about your directory in another way:

```python
ny.freesurfer.add_subject_path('/Volumes/server/Freesurfer_subjects')
```

The same mechanism works for HCP subjects as well; you typically want to either set the
`HCP_SUBJECTS_DIR` environment variable to the path you use to store your HCP subject data or you
will want to inform Neuropythy directly:

```python
ny.hcp.add_subject_path('/Volumes/server/HCP/subjects')
```

Note that for the HCP subject path, this directory can be automatically propagated with subject data
(see the sections on [manually](#download) and [automatically](#auto-download) downloading subjects,
below) and thus needn't containsubject data initially.

---

## <a name="download"></a> Directly Downloading Subjects by ID

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

In order to access data from an HCP subjet you must have that data on local storage. Although
Neuropythy will automate the download of this data (see below) and can even put this data in a 
temporary directory, storing the HCP data permanently will drastically decrease the runtime of any
script or function that uses the HCP data. One way to download an HCP subject's data is to tell
Neuropythy explicitly to download all the data that it knows about for the subject. This can be done
using the `neuropythy.hcp.download` function:

```
import neuropythy as ny
help(ny.hcp.download)
#=> download(sid) downloads the data for subject with the given subject id. By default, the subject
#=>   will be placed in the first HCP subject directory in the subjects directories list.
#=> 
#=> Note: In order for downloading to work, you must have s3fs installed. This is not a requirement
#=> for the neuropythy library and does not install automatically when installing via pip. The
#=> github repository for this library can be found at https://github.com/dask/s3fs. Installation
#=> instructions can be found here: http://s3fs.readthedocs.io/en/latest/install.html
#=> 
#=> Accepted options include:
#=>   * credentials (default: None) may be used to specify the Amazon AWS Bucket credentials, which
#=>     can be generated from the HCP db (https://db.humanconnectome.org/). If this argument can be
#=>     coerced to a credentials tuple via the to_credentials function, that result will be used. If
#=>     None, then the function will try to detect credentials via the detect_credentials function
#=>     and will use those. If none of these work, an error is raised.
#=>   * subjects_path (default: None) specifies where the subject should be placed. If None, then
#=>     the first directory in the subjects paths list is used. If there is not one of these then
#=>     an error is raised.
#=>   * overwrite (default: False) specifies whether or not to overwrite files that already exist.
#=>     In addition to True (do overwrite) and False (don't overwrite), the value 'error' indicates
#=>     that an error should be raised if a file already exists.
```

For example, `ny.hcp.download(100610)` will download all the structural data for HCP subject 100610
to your current HCP subjects' directory. Note that this subject's data will be placed in a directory
named `100610`, so the subject's directory is named with the subject's ID and is found in the HCP
subjects' directory (note the difference between "a subject's directory" and "the subjects'
directory"). If you wish to download this subject's directory to a specific subjects' directory, you
can provide the subjects' directory via the `subjects_path` option.

Downloading a subject's directory can take several minutes depending on your internet
connection. Note that `download` does not download every file in a subject's directory but rather
downloads all of the files that it knows about (this includes the vast majority of all the
structural files as of when this page was written). Retinotopy data cannot be downloaded via the
`download` function.

Once you have downloaded a subejct's data, you can examine that subject using Neuropythy's data
structures. These data are typically accessed via the `neuropythy.hcp_subject()` function which
requires a subejct-ID and yields a `Subject` object. These data are detailed in the following
section.

---

## <a name="hcp-subject"></a> HCP Subjects in Neuropythy

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

If you're already familiar with Neuropythy's FreeSurfer subject interface, then the HCP subject
interface should be very familiar--both the `neuropythy.freesurfer.Subject` and the
`neuropythy.hcp.Subject` classes are inherited from `neuropythy.mri.Subject`. The two subject types
differ in the specific data that are included, but not in the structure of that data. This section
describes how to access the various subject data and its general shape.

---

### <a name="subject-class"></a> The Subject class

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

A Neuropythy HCP subject can be created using the `neuropythy.hcp_subject` function:

```python
sub = ny.hcp_subject(100610)
sub
#=> Subject(<100610>, <'/Volumes/server/Projects/HCP/subjects/100610'>)
```

An HCP subject object contains a small number of member variables that provide access to most of the
relevant subject data. These member variables include the following:
* `sub.hemis` is a dictionary whose keys are the names of hemispheres (such as 'lh' and 'rh') and
  whose values are the hemisphere objects (class `neuropythy.mri.Cortex`), which themselves contain
  more subject data (see [below](#hemispheres)).
* `sub.images` is a dictionary whose keys are the names of 3D volume images (such as 'ribbon' and
  'brain' in FreeSurfer). Neuropythy is not explicitly designed to be good at handling image data,
  so it tends to store these images as simple `nibabel` types, such as
  `nibabel.nifti1.Nifti1Image`. This tutorial will not examine these in great detail, but see
  [below](#images). 
* `sub.path`, `sub.name`, and `sub.meta_data` and a few additional member variables store meta-data
  and technical details about the subject.
  
Subjects are immutable objects, meaning you cannot modify any of the data contained in a
subject. You can, however, efficiently make a copy of a subject with a small change. For example, if
you wanted to add an image to the subject, you would do the following:

```python
import nibabel as nib
sub = ny.hcp_subject(100610)

# load in the image we want to add
img = nib.load('/path/to/my/image.nii')

# make a new images dict with the additional image; note that images
# is not actually a traditional python dict but rather a persistent
# dict type based on the pyrsistent package
images = sub.images.set('new_image', img)

# note that the sub's image's haven't changed:
'new_image' in sub.images
#=> False

# but it is in the new images dict
'new_image' in images
#=> True

# make a new copy of the subject with the new images
sub = sub.copy(images=images)
'new_image' in sub.images
#=> True
```

This immutable organization is used throughout Neuropythy's data structures. For the most part, it
does not affect typical usage of the library--it basically just means that the data provided by
Neuropythy are read-only. Although a full discussion of the various advantages of immutability and
why it was chosen for use in Neuropythy are beyond the scope of this article, the primary reason is
simple: immutability enables [lazy evaluation](https://en.wikipedia.org/wiki/Lazy_evaluation), and
lazy evaluation drastically improves the performance of exploratory data analysis.

---

#### <a name="hemispheres"></a> The Many Hemispheres of an HCP Subject

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

The majority of an HCP subject's structural data is stored in a set of hemisphere objects, tracked
by the subject's `hemis` dictionary. Each value in a subject's `hemis` dictionary is a `Cortex`
object, which itself tracks the various structural data related to a hemisphere. If you just take a
look at the keys in a subject's `hemis` dictionary, you can see that there are a large number of
'hemispheres'--far more than two:

```python
sub = ny.hcp_subject(100610)
sorted( sub.hemis.keys() )
#=> ['lh', 'lh_LR164k', 'lh_LR164k_MSMAll', 'lh_LR164k_MSMSulc', 'lh_LR32k',
#=>  'lh_LR32k_MSMAll', 'lh_LR32k_MSMSulc', 'lh_LR59k', 'lh_LR59k_MSMAll',
#=>  'lh_LR59k_MSMSulc', 'lh_lowres', 'lh_lowres_MSMAll', 'lh_lowres_MSMSulc',
#=>  'lh_native', 'lh_native_MSMAll', 'lh_native_MSMSulc', 'rh', 'rh_LR164k',
#=>  'rh_LR164k_MSMAll', 'rh_LR164k_MSMSulc', 'rh_LR32k', 'rh_LR32k_MSMAll',
#=>  'rh_LR32k_MSMSulc', 'rh_LR59k', 'rh_LR59k_MSMAll', 'rh_LR59k_MSMSulc', 
#=>  'rh_lowres', 'rh_lowres_MSMAll', 'rh_lowres_MSMSulc', 'rh_native',
#=>  'rh_native_MSMAll', 'rh_native_MSMSulc']
```

We'll start by looking at the data tracked by a `Cortex` object abstractly then look at the
differences and details pertaining to the many hemispheres represented in an HCP subject.

---

##### <a name="cortex"></a> The Cortex Class

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

The `neuropythy.mri.Cortex` class is used by both FreeSurfer and HCP subjects in Neuropythy to
represent the structural information available for a single hemisphere (left or right). The most
important data organized by the `Cortex` class are the cortical surfaces (such as the white,
midgray, and pial surface meshes), the spherical registrations, and the vertex properties. For both
FreeSurfer and HCP subjects, each hemisphere has a single set of vertices with multiple vertex
coordinate sets for the different surface meshes and registrations--in other words, vertex 12 is the
white mesh, the pial mesh, and every other surface or registration refers to the same cortical
surface position, which can be thought to represent a line-segment through the gray matter.

In order to represent these various surface data, the following member variables are included in
cortical hemisphere objects:
* `hemi.chirality` is the chirality of the hemisphere: either `'lh'` or `'rh'`.
* `hemi.vertex_count` is the number of vertices used to represent the hemisphere `hemi`.
* `hemi.indices` and `hemi.labels` give the vertex indices and the vertex labels. In a `Cortex`
  object, labels and indices will be equal and both equivalent to `range(hemi.vertex_count)`.
* `hemi.properties` is a persistent dictionary (in fact, a `pimms.ITable` object, which is much like
  a persistent `pandas.DataFrame`) of the properties for the cortex; these include data such as
  'curvature', 'thickness', parcellations, and a variety of other structural data. If you have
  retinotopy data available, the pRF properties will also appear here. The data for each property is
  an numpy array of vertex-data whose first dimension is equal to `hemi.vertex_count`.
* `hemi.tess` is a `neuropythy.geometry.Tesselation` object that stores details of the subject's
  triangle mesh--the connections between vertices in the hemisphere's surface representations. All
  meshes attached to `hemi` will share this tesselation object and thus share vertices (but
  different meshes, such as white and pial, may give the vertices different positions).
* `hemi.surfaces` is the persistent dictionary of cortical surface meshes. Meshes are similar to
  cortex objects in that they inherit the indices, labels, properties and tesselation of their
  parent cortex objects, but they additionally provide a coordinate matrix of vertex positions and a
  variety of data related to these. For example, one can evaluate
  `hemi.surfaces['white'].face_areas` to obtain the surface area of every face in the white surface
  of the hemisphere `hemi`.
* `hemi.registrations` is similar to the `hemi.surfaces` value in that it is a persistent dictionary
  whose values are meshes, but unlike `hemi.surfaces`, it contains spherical meshes that have been
  registered to some cortical space such as FreeSurfer's `fsaverage` atlas. HCP subjects are all
  registerd to their own `native` space, to FreeSurfer's `fsaverage` atlas, and to the HCP's `fs_LR`
  atlas. In general, it is not necessary to use the `hemi.registrations` object directly; when one
  needs to interpolate data between subjects or between a subject and an atlas, calling
  `from_hemi.interpolate(onto_hemi, from_data)` should handle the details.

---

##### <a name="freesurfer"></a> The FreeSurfer Hemispheres

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

The HCP processing pipeline begins by running FreeSurfer's `recon-all` program on the subject's
preprocessed anatomical T1-weighted MR image; accordingly all HCP subjects have basic FreeSurfer
data included. These hemispheres, as generated by FreeSurfer, are available in the subject's
`'lh_native'` and `'rh_native'` hemispheres, which are equivalent to `'lh'` and `'rh'` (i.e., `'lh'`
is an alias for `'lh_native'` in `sub.hemis`). These hemispheres are also, for convenience, mapped
to the member variables `sub.lh` and `sub.rh`

---

##### <a name="fslr"></a> The fs_LR Hemispheres

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

In addition to using FreeSurfer, the HCP processing pipeline aligns each subject to an atlas called
`fs_LR` that is based on imaging measurements from a large pool of HCP subjects. Two different
methods were developed by the HCP for the alignment to this atlas: the `MSMSulc` and `MSMAll`
methods. `MSMSulc` is similar to FreeSurfer's alignment algorithms in that is uses
anatomical/structural data, but not additional imaging data such as resting-state correlations or
myelination data. `MSMAll` uses all of these imaging data and thus in theory should be a better
alignment with better correspondence between subjects. However, Neuropythy provides both sets of
data to the user by providing the different alignments in different hemisphere objects. For example,
where `sub.hemis['rh_LR32k_MSMAll']` is a cortex object build using the `MSMAll` alignment while
`sub.hemis['rh_LR32k_MSMSulc']` is the same cortex (with an equivalent tesselation) built using the
`MSMSulc` alignment. Because it is assumed that the user usually doesn't care about these detauls,
hemispheres with names like `sub.hemis['rh_LR32k']` (i.e., lacking an `_MSMAll` or `_MSMSulc`
suffix) are aliases for the `MSMAll` hemispheres (but see the `default_alignment` option of the
`neuropythy.hcp_subject` if you wish to change this). Because of this aliasing, it is generally not
necessary to think about the `MSMAll` and `MSMSulc` versions of the data, but the data are provided
in case the user wishes to compare alignment methods or examine data aligned by structure only.

The distinction between `MSMAll` and `MSMSulc` and the aliases for HCP subject hemispheres is part
of the reason why HCP subjects have a very large number of hemispheres in the `sub.hemis`
variable. In addition to this, however, the HCP provides multiple versions of a subject's cortical
surfaces that have been optimized for transferring and comparing data across subjects. These meshes
are the following (listing LH meshes only):
* `sub.hemis['lh_LR32k']` is a low-resolution mesh with approximately 32 thousand vertices per
  hemisphere. 
* `sub.hemis['lh_LR59k']` is a mid-resolution mesh with approximately 59 thousand vertices per
  hemisphere. 
* `sub.hemis['lh_LR164k']` is a low-resolution mesh with approximately 164 thousand vertices per
  hemisphere.

In these `fs_LR` meshes, vertices are arranged to be equivalent across subjects (a bit like having
your subject's vertices pre-aligned to the `fsaverage`). Although these meshes are not optimal for
calculating structural data, they are excellent for comparing functional data across subjects.

---

#### <a name="images"></a> HCP Subject Images

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

MR Image objects are not the focus of the Neuropythy library, so relatively little space is devoted
to them here. The list of all images tracked by an HCP subject object can be found as follows:

```python
sub = ny.hcp_subject(100610)
sorted(sub.images.keys())
#=> ['T1', 'T1_to_T2_ratio', 'T1_to_T2_ratio_all', 'T1_unrestored',
#=>  'T1_warped', 'T1_warped_unrestored', 'T2', 'T2_brain',
#=>  'T2_brain_warped', 'T2_unrestored', 'T2_warped',
#=>  'T2_warped_unrestored', 'bias', 'bias_warped', 'brain',
#=>  'brain_mask', 'brain_warped', 'brainmask', 'brainmask_warped',
#=>  'lh_gray_mask', 'lh_white_mask', 'parcellation',
#=>  'parcellation2005', 'parcellation2005_warped',
#=>  'parcellation_warped', 'ribbon', 'ribbon_warped',
#=>  'wm_parcellation', 'wm_parcellation_warped']
```

The `sub.images` values themselves are typically `nibabel.nifti1.Nifti1Image` objects.

---

#### <a name="properties"></a> HCP Subject Properties

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

The `sub.properties` persistent dictionary stores much of the important structural data for a
subject, and stores retinotopic mapping parameter data for subjects with retinotopic data, if you
have downloaded retinotopy data or have enabled its auto-downloading (see below). To see the list of
properties, you can use the following code:

```python
sub = ny.hcp_subject(100610)
sorted(sub.lh.properties.keys())
#=> ['areal_distortion', 'areal_distortion_FS', 'atlas',
#=>  'brodmann_area', 'convexity', 'curvature', 'index', 'label',
#=>  'lowres-prf_eccentricity', 'lowres-prf_polar_angle',
#=>  'lowres-prf_radius', 'lowres-prf_variance_explained',
#=>  'midgray_surface_area', 'parcellation', 'parcellation_2005',
#=>  'pial_surface_area', 'roi', 'thickness',
#=>  'thickness_uncorrected', 'white_surface_area']
```

Accessing these data via, for example, `sub.lh.prop('curvature')` will yield a list of curvature
values, one per vertex.

---

### <a name="updating"></a> Updating Subjects

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

Subject objects in Neuropythy are immutable; this is, in part, because various lazy calculations
stored in Neuropythy's object structures may be keeping track of a given subject object for future
use--changing the object prior to that calculation could produce undefined behavior. For those who
have not programmed in an immutable data language before, this may seem like a major problem--how
does one give a subject object custom data for use in later analyses? The answer to this is that one
doesn't change the subject object but instead creates a copy of the subject with the new data
appended:

```python
sub = ny.hcp_subject(100610)
new_lh = sub.lh.with_prop('the_prop', prop_data)
new_hemis = sub.hemis.set('lh', new_lh)
sub = sub.copy(hemis=new_hemis)
sorted(sub.lh.properties.keys())
#=> ['areal_distortion', 'areal_distortion_FS', 'atlas',
#=>  'brodmann_area', 'convexity', 'curvature', 'index', 'label',
#=>  'lowres-prf_eccentricity', 'lowres-prf_polar_angle',
#=>  'lowres-prf_radius', 'lowres-prf_variance_explained',
#=>  'midgray_surface_area', 'parcellation', 'parcellation_2005',
#=>  'pial_surface_area', 'roi', 'the_prop', 'thickness',
#=>  'thickness_uncorrected', 'white_surface_area']
sub.lh is new_lh
#=> True
```

While this may appear cumbersome, it is usually fairly straightforward; the following example code
shows how one might load data automatically from a separate data directory for every subject
analyzed.

```python
class sub_hemi(object):
   '''
    sub_hemi(subject_id, hemname) yields the hemisphere object for the
      given subject and hemisphere name ('lh' or 'rh').
   '''
   cache = {}
   @staticmethod
   def __call__(sid, hname):
      import os
      key = (sid, hname)
      if key not in sub_hemi.cache:
          sub_dir = os.path.join(data_path, subject_id, hname + '-extra-data.mgz')
          data = ny.load(sub_dir) # Assume this is an MGZ file containing a vector
          hemi = ny.hcp_subject(sid).hemis[hname]
          hemi = hemi.with_prop(extra_data=data)
          sub_hemi.cache[key] = hemi
      return sub_hemi.cache[key]
```

---

## <a name="auto-download"></a> Auto-downloading Subjects as Requested

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

In addition to downloading subjects manually using the `nueropythy.hcp.download` function, one can
also instruct Neuropythy to automatically download HCP subject data as requested. This means that if
you perform some analysis on the white surface of subject 100610, Neuropythy will dutifully download
the white surface data for that subject as well as any of the data you analyzed, but won't download
any of the extra data not requested such as the data for the pial surface or for the subject's
various atlases. In this way, auto-downloading remains fast and efficient even when performing
exploratory analysis.

Enabling auto-downloading is simple:

```python
import neuropythy as ny
ny.hcp.auto_download('structure')
# Note: Currently, as of the date this tutorial was written, there
# is an additional argument required for the above line to work--
# this is the option database='hcp-openaccess-temp', which is
# required due to migration ocurring on the HCP's end. When this
# migration is over, the above line should work fine again without
# the additional option.
```

Note that if you have not configured the `HCP_SUBJECTS_DIR` environment variable nor called
`ny.hcp.add_subject_path` then you will also need to pass the `subjects_path=path` option to the
`auto_download` function; otherwise it will use your configured path. Once the `auto_download`
function has been called, you may access HCP subject data freely as if you had the entire dataset
downloaded--it should be as easy as that!

---

## <a name="auto-retinotopy"></a> Auto-downloading Retinotopy Data

<div class="toTop"><p>(<a href="#top">Back to Top</a>)</p></div>

One final feature of Neuropythy is the ability to download retinotopic mapping data from the [Open
Science Foundation page](https://osf.io/bw9ec/) associated with [Benson et
al. (2018)](https://doi.org/10.1101/308247). This data exists in one single file, so note that when
that file is auto-downloaded (the first time one requests a subject object after enabling retinotopy
auto-downloading), Neuropythy will appear to hang for a short time. This is because it must stop and
download the entire database (approximately 1 GB). This file is stored as `prfresults.mat`, in the
root of the HCP subjects' directory.

To enable auto-downloading of retinotopy data, simply call `ny.hcp.auto_download` with `True` for
the first argument instead of `'structure'`--this will enable auto-downloading of both the
structural and the retinotopy data.

Once you have turned on auto-downloading of retinotopy data, the HCP subjects' hemispheres should
contain additional properties:
* The `LR32k` meshes will contain the properties `'lowres-prf_polar_angle'`,
  `'lowres-prf_eccentricity'`, `'lowres-prf_radius'`, and `'lowres-prf_variance_explained'`. The
  polar angle data is stored in terms of degrees of clockwise rotation starting from the upper
  vertical meridian, so a value of 90 indicates the right horizontal meridian while a value of -90
  indicates the left horizontal meridian. The eccentricity data is stored in terms of degrees of the
  visual field. The variance explained is the fraction (between 0 and 1) of the measured BOLD
  variance explained by the pRF model. The pRF radius is the size of one standard deviation of the
  Gaussian blob used to describe the pRF.
* The `native` FreeSurfer hemispheres (`sub.lh` and `sub.rh`) also contain these properties;
  however, they are deduced from the `LR32k` hemispheres by interpolation. The first time you
  request the retinotopy data from a native hemisphere, this interpolation must be calculated;
  however, the results are cached on disk in the subject's directory; thus this delay occurs only
  the first time one requests the data from the native hemisphere ever.
* Although these data are not available yet, the `LR59k` hemispheres (and the native hemispheres via
  interpolation) will eventually also include the normal-resolution properties: `'prf_polar_angle'`,
  `'prf_eccentricity'`, `'prf_variance_explained'`, and `'prf_radius'`. These properties are the
  same as the lowres properties; they were just solved on a higher-resolution mesh.

---

<p style="width: 100%; text-align: center;"><a href="#top">Back to Top</a></p>


