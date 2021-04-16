## Entropy outputs coumputation and visualization
### Computation
loop(docs_phenotype_file_1,1,8)
### Visualization on a heatmap
entropy_outputs <- readr::read_csv('entropy_outputs.csv')
heatmap2(entropy_outputs)
