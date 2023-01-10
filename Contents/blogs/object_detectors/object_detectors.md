<head>
    <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
    <script type="text/x-mathjax-config">
        MathJax.Hub.Config({
            tex2jax: {
            skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
            inlineMath: [['$','$']]
            }
        });
    </script>
</head>

# Discussion: Development of R-CNN and YOLO Object Detectors

[return to main](../../../index.md)

[return](../../blogs.md)

### The R-CNN series

Three models: R-CNN, Fast R-CNN and Faster R-CNN

R-CNN:
1. Selective search for region proposal
1. CNN encoder for region-wise feature extraction
1. SVM for feature (resized) classification
1. NN for box regression

Fast R-CNN (based on R-CNN):
1. **feature-wise -> global** feature extraction
1. ROI pooling: feature **(resized) -> (ROI pooled)** classification
1. joint training: **CNN encoder & SVM & NN -> CNN** for detection

Faster R-CNN (based on Fast R-CNN):
1. **selective search -> region proposal network (RPN)** for region proposal
1. feature extraction and RPN **share the weights** of the CNN encoder

### The YOLO series

Three models: YOLO v1-3

YOLO v1:
1. images divided into $n\times n$ grids, corresponding to $n\times n$ objects
1. end-to-end training, outputting $n\times n$ vectors recording all attributes of every box

YOLO v2 (based on YOLO v1):
1. FC layers **removed**
1. **anchor boxes** (reference) introduced
1. **K-means** for anchor box generation
1. each grid corresponding to **multiple** boxes with multiple scales

YOLO v3 (based on YOLO v2):
1. division of **positive and negative** boxes
1. cross entropy -> **binary** cross entropy loss

**References:**

https://blog.csdn.net/u014380165/article/details/72851319

https://blog.csdn.net/weixin_43198141/article/details/90178512

https://www.jianshu.com/p/f87be68977cb

[return](../../blogs.md)

[return to main](../../../index.md)

