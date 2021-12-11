## Entropy outputs coumputation and visualization
### Computation
loop(Independent_NPIs,1,12)
loop(Synergestic_NPIs,1,26)
### Visualization on a heatmap
entropy_Independent_NPIs <- readr::read_csv('entropy_Independent_NPIs')
entropy_Synergestic_NPIs <- readr::read_csv('entropy_Synergestic_NPIs')
heatmap2(entropy_Independent_NPIs)
heatmap2(entropy_Synergestic_NPIs)
