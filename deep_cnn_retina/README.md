# Blindness detector

Transfer learning on resnet-18 to detect symptoms of diabetic retinopathy 
based on retina photos taken using fundus photography. 
The full dataset is too large to store on github, so I have included a few sample images.


Labels corresponding to symptom

    0 - No DR

    1 - Mild

    2 - Moderate

    3 - Severe

    4 - Proliferative DR


The network can be debugged on a CPU, but is best trained with GPUs

#Sample output for one epoch:

Epoch    0 /   29
--------------------
train
Batch    0/  92 (0.00 %)
Batch   10/  92 (10.87 %)
Batch   20/  92 (21.74 %)
Batch   30/  92 (32.61 %)
Batch   40/  92 (43.48 %)
Batch   50/  92 (54.35 %)
Batch   60/  92 (65.22 %)
Batch   70/  92 (76.09 %)
Batch   80/  92 (86.96 %)
Batch   90/  92 (97.83 %)
       train Loss:   0.7792 Acc:   0.7125
val
Batch    0/  23 (0.00 %)
Batch   10/  23 (43.48 %)
Batch   20/  23 (86.96 %)
         val Loss:   0.6391 Acc:   0.7517
