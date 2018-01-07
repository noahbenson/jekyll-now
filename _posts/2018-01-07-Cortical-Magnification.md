---
layout: post
title: Cortical Magnification
---

## Introduction

In this post, I explore the concept of cortical magnification using a custom dataset from the
Winawer lab, in which 8 subjects were shown 12 scans each of colorful retinotopic mapping stimuli.

### Retinotopy

A retinotopic map refers to the layout of one half of the visual field on the cortical surface in a
manner that topologically preserves the layout of the retina. 

![retinotopy intro_slide]({{ site.baseurl }}/images/cmag/retinotopy_intro.png "Retinotopy")

Retinotopic maps have a consistent layout across individuals with many visual areas. These visual
areas tile the occipital cortex, each containing a retinotopic map. The following shows the
group-average retinotopic mapping data from the Human Connectome Project.

![retinotopic maps_slide]({{ site.baseurl }}/images/cmag/retinotopic_maps.png "Retinotopic Maps")


### Cortical Magnification

The visual field must be warped in order to be mapped onto the cortical surface because the cortical
surface is not flat but curved and complex. This transformation additionally biases certain parts of
the visual field by allocating more of the cortex to them than other parts.

![cortical warping slide]({{ site.baseurl }}/images/cmag/retinotopy_warping.png "Retinotopic Maps
are Warped on the Cortical Surface")

The measure of how much of the cortex is devoted to how much of the visual field is called
**cortical magnification**. It generally has units similar to mm/deg or mm mm\\(^2\\)/deg\\(^2\\).

Cortical magnification is known to decrease with eccentricity in V1 according to the following
formula by Horton and Hoyt (1991):

$$ m = \frac{17.3}{0.75 + e} $$

where \\(m\\) and \\(e\\) are the mm/deg of cortical magnification and deg of eccentricity,
respectively.

![cortical mag slide]({{ site.baseurl }}/images/cmag/cortical_mag.png "Proposed Cortical
Magnification in V1")


## Data

Cortical magnification was calculated either on a per-face basis (i.e., using each face of the
cortial surface) or by using path-based metrics in which a path is drawn over a small patch of
cortex and the cortical surface length of the path is divided by the visual field path-length. Paths
were drawn both radially (along iso-angular lines across a particular point) or tangentially (along
iso-eccentric lines across a particular point). Per-face magnification was calculated in both
radial and tangential directions as well, and averaged around particular points for display.

### Average Cortical Magnification

The following image shows the cortical magnification for path-based calculations; note that the
dotted black lines show the 1.5, 3, and 6 degree iso-eccentricity lines, and the entire field is
shown out to 12 degrees (note that there is a logarithmic scaling to eccentricity).

![path_cmag_vfield]({{ site.baseurl }}/images/cmag/path_cmag_vfield.png "Path-base Cortical
Magnification, projected to the visual field")




