# A neglected risk factor for lonomism: The host plants of *Lonomia achelous* and *Lonomia obliqua*


## Abstract

The host plants play a crucial role in the survival of Lonomia spp., particularly during their larval stage, which is the sole phase associated with lonomism, a severe and potentially fatal envenomation. To contribute to the understanding of the relationship between the two caterpillar species involved in such cases - Lonomia achelous Crammer 1777 and Lonomia obliqua Walker 1855 -  and their respective host plants, as well as to evaluate the factors that may increase the risk of  human envenomation, a bibliographical survey about specific interactions was conducted (biological characteristics, human uses, and geographical distribution). The data was sourced from scientific literature and/or opinion from experts in the Saturniidae family. The findings revealed that both species are polyphagous, and the presence of tannins in the leaves is a shared characteristic among their host plants. Most host species have at least one human use, thereby escalating the risk of inadvertent contact with the caterpillars. Additionally, the geographical distribution of both species aligns with the distribution of their native host plants, which are predominantly heliophilous. Despite potential local or regional fluctuations due to habitat fragmentation, it is believed that the global distribution range of L. obliqua has remained stable over time. This work provides an extensive panoramic insight into the interactions between Lonomia spp., their hosts, and the environment, which is essential for developing effective prevention and control strategies for Lonomia spp. accidents in South America.

--------

## Environment Setup

- **Containerization**: Analyses are executed within a Docker container using the `quay.io/jupyter/datascience-notebook` image. This approach ensures a consistent and reproducible computing environment across different platforms, facilitating dependency management and streamlining the setup process.

- **Programming Language**: The analysis is conducted using [R version 4.3.2 (2023-10-31)](https://cran.r-project.org/bin/windows/base/R-4.3.2-win.exe), chosen for its comprehensive statistical analysis and graphical capabilities.

- **Dependency Management**: All dependencies and necessary R packages are meticulously listed and installed through the Jupyter notebook titled [0.1_install_requirements.ipynb](0.1_install_requirements.ipynb), ensuring a seamless setup for conducting analyses.

## Data Acquisition

Interested parties can request data via email:<br>
- biologist.mmf@gmail.com<br>
- marilia.melo.favalesso@gmail.com

## Data Processing and Analysis

- **Data Download**: The script [0.2_functions_download_hosp_data.R](0.2_functions_download_hosp_data.R)introduces custom-built functions to streamline the process of downloading host data. These functions are employed within the [1_download_merge_datasets.ipynb](1_download_merge_datasets.ipynb) notebook, enabling the efficient acquisition and integration of datasets pivotal for subsequent analysis.

- **Spatial Analysis**: The [2_distribution_hosts.ipynb](2_distribution_hosts.ipynb) notebook contains the spatial analysis, employing kernel density estimation (KDE) to map the distribution of host plants. This analysis intersects with *Lonomia* occurrence points and localities with reported lonomism cases, offering insights into spatial patterns and potential risk areas.

- **Descriptive Analysis**
  - **Temporal Trends**: The notebook [3_temporal_graph.ipynb](3_temporal_graph.ipynb) delves into temporal analysis, charting the discovery timeline of new *Lonomia spp.* hosts. Through graphical representations, it uncovers trends and patterns in host discovery over time.
  - **Host Uses and Biological Characteristics**: The [4_describe.ipynb](4_describe.ipynb) notebook provides an examination of the principal human uses and biological characteristics associated with the host plants of *Lonomia* species. This comprehensive analysis sheds light on the ecological and anthropogenic factors influencing lonomism, facilitating informed strategies for prevention and mitigation.

