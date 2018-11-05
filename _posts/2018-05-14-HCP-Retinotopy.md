---
layout: post
title: The Human Connectome Project 7T Retinotopy Database
---

<a name="top"></a>Poster presentation for the 2018 Vision Sciences Society conference.

---

## Introduction

This page documents the 2018 VSS Poster and SfN Presentation on the HCP 7T
Retinotopy Dataset by Benson, Jamison, Vu, Arcaro, *et al*. A PDF of the poster
can be found below along with details about the broader project and links to
relevant resources. Please contact [Noah Benson](mailto:nben@nyu.edu) for
inquiries.

The HCP 7T retinotopy dataset is more fully documented in a
[paper](https://doi.org/10.1101/308247), currently available on bioarxiv and in
press at the Journal of Vision:

Benson NC, Jamison KW, Arcaro MJ, Vu AT, Glasser MF, Coalson TS, Van Essen DV,
Yacoub E, Ugurbil K, Winawer J, Kay K (**2018**) The HCP 7T Retinotopy
Dataset. *bioRxiv* doi:10.1101/308247


## Resources

**The full HCP 7T Retinotopy Dataset, including all pRF solutions for all 181
subjects, can be found [at the project's OSF site](https://osf.io/bw9ec).**

The [Human Connectome Project, WU-Minn
consortium](https://www.humanconnectome.org/) conducted the experiments and 
collected the data for this project. The raw and preprocessed data can be
downloaded from their [database website](https://db.humanconnectome.org), which
requires registration but is otherwise free. The data were preprocessed using
the HCP pipelines, information about which can be found
[here](https://www.humanconnectome.org/software/hcp-mr-pipelines); the pipelines
may be downloaded via their [github
page](https://github.com/Washington-University/HCPpipelines).

### Tools for Interacting with HCP Retinotopy Data

The HCP retinotopy data can be accessed directly by the HCP's workbench tool,
information about which can be found
[here](https://www.humanconnectome.org/software/), or via
[neuropythy](https://github.com/noahbenson/neuropythy), a Python library. In
particular, neuropythy can automatically download both HCP structural data and
the retinotopy data and organize it into coherent Python data structures; for
more information, see [this page]({{site.baseurl}}/HCP-and-Neuropythy/).

The retinotopic atlas (discussed on the VSS Poster) is included in the
[neuropythy](https://github.com/noahbenson/neuropythy) library, which
is publicly available on github. The raw data files that describe the
atlas (stored in FreeSurfer's MGH format) can be found in the
`neuropythy/lib/data/fsaverage/surf` directory. To apply the
retinotopy atlas to a subject, we suggest one of two methods (for more
information, see [this page]()):
1. Use the [neuropythy docker](https://hub.docker.com/r/nben/neuropythy);
   if you have [Docker](https://docker.com) installed, you can simply
   run the following command:
   ```bash
   > docker run -it --rm -v <path to your freesurfer subjects directory>:/subjects nben/neuropythy atlas --verbose <subject ID>
   ```
   Note that you can pass the flag `--help` in place of the `--verbose <subject ID>`
   to see further options.
2. If you have Python installed, you can install the neuropythy
   library using pip: `pip install neuropythy`. You can then use the
   following command:
   ```bash
   > python -m neuropythy atlas --verbose <subject ID>
   ```
   Note that in this case, you will need to have your `SUBJECTS_DIR`
   environment variable set to your FreeSurfer subjects directory, or you
   must provide a full path instead of a subject ID..

See also [this page]({{site.baseurl}}/Retinotopy-Tutorial/)
for further details about retinotopic atlases and retinotopy in
general.


## The VSS 2018 Poster

If your browser does not support embedded PDF content, you can
download the poster
[here]({{site.baseurl}}/images/hcp-retinotopy/vss2018-poster.pdf).

<embed src="{{site.baseurl}}/images/hcp-retinotopy/vss2018-poster.pdf" type="application/pdf" width="100%" height="500px" />


Notes:
* The retinotopic atlas derived from the HCP 7T retinotopy dataset is
  an extension of previous work (Benson *et al.*, 2014) in which a
  template of retinotopy was fit to group-average retinotopy data from
  19 subjects; this new atlas is fit to the group-average from the 181
  subjects in the HCP dataset.
* The retinotopic atlas differs from other atlases, such as the Wang
  *et al.* (2015) atlas, in that the retinotopic atlas shown here
  describes not only visual area boundaries of the cortical surface
  but also the retinotopic coordinates (polar angle, eccentricity) and
  the pRF size of each location in early visual cortex.
* Although the retinotopic atlas is shown with the Wang *et al.*
  (2015) atlas super-imposed for comparison, this Wang atlas was not
  used in the construction of the retinotopic atlas.
* The retinotopic atlas includes several regions beyond V1, V2, and
  V3; although these regions are shown, we have not yet systematically
  evaluated their accuracy and cannot recommend their use for
  predictive purposes. However, their inclusion in the atlas
  stabilizes the fitting of the V1-V3 regions, thus their inclusion
  improves the predictive power of these regions.
* The plot of PRF size in terms of eccentricity shows the best-fit
  line for each visual area as well as a shaded region that denotes
  the inner two quartiles of the pRF measurements. Due to the number
  of measurements included in these fits, the S.E.M. and 95%
  confidence intervals are smaller than the thickness of the lines
  plotted.

## References

* Benson NC, Jamison KW, Arcaro MJ, Vu AT, Glasser MF, Coalson TS, Van
  Essen DV, Yacoub E, Ugurbil K, Winawer J, Kay K (**2018**) The HCP 7T
  Retinotopy Dataset. *bioRxiv* doi:10.1101/308247
* The WU-Minn Human Connectome Project: An overview. *NeuroImage*
  80:62-79.
* Kay KN, Winawer J, Mezer A, Wandell BA (**2013**) Compressive spatial
  summation in human visual cortex. *J Neurophysiol* **110**:481-94.
* Wang L, Mruczek RE, Arcaro MJ, Kastner S (**2015**) Probabilistic Maps
  of Visual Topography in Human Cortex. *Cereb Cortex* **5**:3911-31.
* Benson NC, Butt OH, Brainard DH, Aguirre GK (**2014**) Correction of
  Distortion in Flattened Representations of the Cortical Surface
  Allows Prediction of V1-V3 Functional Organization from
  Anatomy. *PLOS Comput Biol* **10**(3):e1003538


