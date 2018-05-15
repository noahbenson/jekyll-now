---
layout: post
title: The Human Connectome Project 7T Retinotopy Database
---

<a name="top"></a>Poster presentation for the 2018 Vision Sciences Society conference.

---

## Introduction

This page documents the 2018 VSS Poster on the HCP 7T Retinotopy
Dataset by Benson, Jamison, Vu, Winawer, and Kay. A PDF of the poster
can be found below along with details about the broader project and
links to relevant resources. Please contact [Noah
Benson](mailto:nben@nyu.edu) for inquiries.

The HCP 7T retinotopy dataset is more fully documented in a paper,
currently available on bioarxiv:

Benson NC, Jamison KW, Arcaro MJ, Vu AT, Glasser MF, Coalson TS, Van
Essen DV, Yacoub E, Ugurbil K, Winawer J, Kay K (**2018**) The HCP 7T
Retinotopy Dataset. *bioRxiv* doi:10.1101/308247

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

## Resources

**The full HCP 7T Retinotopy Dataset, including all pRF solutions for
all 181 subjects, can be found [here](https://osf.io/bw9ec).**

The retinotopic atlas is included in the
[neuropythy](https://github.com/noahbenson/neuropythy) library, which
is publicly available on github. The raw data files that describe the
atlas (stored in FreeSurfer's "curv" format) can be found in the
`neuropythy/lib/data/fsaverage/surf` directory. To apply the
retinotopy atlas to a subject, we suggest one of two methods:
1. Use the [neuropythy docker](https://hub.docker.com/r/nben/neuropythy);
   if you have [Docker](https://docker.com) installed, you can simply
   run the following command:
   ```bash
   > docker run -it --rm -v <path to your freesurfer subjects directory>:/subjects nben/neuropythy:latest benson14_retinotopy --verbose <subject ID>
   ```
   Note that you can pass the flag `--help` in place of the `--verbose <subject ID>`
   to see further options.
2. If you have Python 2.7 installed, you can install the neuropythy
   library using pip: `pip install neuropythy`. You can then use the
   following command:
   ```bash
   > python -m neuropythy benson14_retinotopy --verbose <subject ID>
   ```
   Note that in this case, you will need to have your `SUBJECTS_DIR`
   environment variable set to your FreeSurfer subjects directory.

Note that in both of the above cases, the `benson14_retinotopy` refers
to the method pioneered by Benson *et al.* (2014). See also [this page]({{site.baseurl}}/Retinotopy-Tutorial/)
for further details about retinotopic atlases and retinotopy in
general.

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


