# Evaluation code for binary and multilabel video segmentation

## Overview
We provide code for video object segmentation to evaluate binary as well as multilabel video segmentation results.
The multilabel evaluation scheme is adopted from ![Ochs et al.](https://lmb.informatik.uni-freiburg.de/Publications/2014/OB14b/pami_moseg.pdf). We add an additional measure ∆-Object that represents the accuracy of the segmented object count.
The Hungarian algorithm is used to find the best assignment of estimated segmentations to ground truth segmentations throughout the video sequence. This way we do not depend upon specific label IDs - meaning it doesn't matter whether we assigned label A to background and label B to an object or the other way around. However what does matter, is that the assignment is consistent throughout the video.

The Figure below shows an overlay of a ground truth segmentation mask with a "positive" region (segmented object) and a "negative" region (background). The estimated segmentation is shown in orange. To evaluate object segmentation accuaracy we provide the following accuracy measures: 
* Precision, 
* Recall, 
* F-measure, 
* Intersection over Union and 
* ∆-Object.

<p align="center">
  <img height="200" src="/images/accuracy-measures.png">
</p>

### Precision
Precision is the ratio between true positive (correctly segmented object) and the entire estimated object region. A precision of "1" means that all pixels labeled as object A are all correctly classified, there are no pixels erroneusly labeled as the object A.
<p align="center">
  <img height="250" src="/images/accuracy-measures-P.png">
</p>

### Recall
Recall is the ratio between true positive (correctly segmented object) and the entire ground truth object region. A recall of "1" means that the ground truth object segmentation is entirely detected correctly, htere are no ground truth regions that are not detected as such.
<p align="center">
  <img height="250" src="/images/accuracy-measures-R.png">
</p>

### F-measure
The F-measure (or F1-score) is the harmonic mean of precision and recall.
<p align="center">
  <img height="45" src="/images/accuracy-measures-F.png">
</p>

### Intersection over Union (IoU)
<p align="center">
  <img height="250" src="/images/accuracy-measures-IoU.png">
</p>

### ![Delta](https://latex.codecogs.com/gif.latex?%5Clarge%20%5CDelta)-Object
∆-Object represents the accuracy of the segmented object count. ∆-Object is the average absolute difference of the ground truth object count in each frame and the number of objects identified by the algorithm. A drawback of the evaluation scheme proposed by ![Ochs et al.](https://lmb.informatik.uni-freiburg.de/Publications/2014/OB14b/pami_moseg.pdf) is that it does not penalize algorithms much for large numbers of unnecessary (additional) segmented objects. Thus, the F-score alone does not entirely capture whether the algorithm has an accurate count of the number of objects and the additional ∆-Object measure is necessary for a representative evaluation.

## Code Documentation

The multilabel evaluation code (default version) can be run in matlab as follows
```
evaluation( '/path/to/segmentations/', '/path/to/images/', '/path/to/annotaions/');
```

To evaluate binary video segmentation masks the "mode" has to be set to "binary"
```
evaluation( '/path/to/segmentations/', '/path/to/images/', '/path/to/annotaions/', 'mode', 'binary' );
```


## Citation
If this helps your research please cite:

    `@inproceedings{bideau_CVPR_2018,
      author    = {Bideau, Pia and RoyChowdhury, Aruni and Menon, Rakesh R and Learned-Miller, Erik},
      title     = {The best of both worlds: Combining cnns and geometric constraints for hierarchical motion segmentation},
      booktitle = {Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition},
      pages={508--517},
      year      = {2018}
    }`

## Contacts
- [Pia Bideau](https://people.cs.umass.edu/~pbideau/)
