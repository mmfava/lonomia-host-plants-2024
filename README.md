# A neglected risk factor for lonomism: The host plants of *Lonomia achelous* and *Lonomia obliqua*

## Abstract

The survival of Lonomia spp. relies heavily on their host plants, especially during their larval stage, which is associated with lonomism, a severe and potentially fatal envenomation. To enhance our understanding of the relationship between the two caterpillar species involved in these cases - Lonomia achelous Crammer 1777 and Lonomia obliqua Walker 1855 - and their respective host plants, as well as to evaluate the factors that may increase the risk of human envenomation, we conducted a comprehensive bibliographical survey. This survey included information on biological characteristics, human uses, and geographical distribution, sourced from scientific literature and expert opinions in the Saturniidae family. Our findings revealed that both species are polyphagous, and their host plants share the characteristic of containing tannins in their leaves. Most host species have at least one human use, which escalates the risk of unintentional contact with the caterpillars. Furthermore, the geographical distribution of both species aligns with the distribution of their native host plants, which are predominantly heliophilous. Despite potential local or regional fluctuations due to habitat fragmentation, the global distribution range of L. obliqua is believed to have remained stable over time. This work provides a comprehensive insight into the interactions between Lonomia spp., their hosts, and the environment, which is crucial for developing effective prevention and control strategies for Lonomia spp. accidents in South America.

--------

## Environment Setup

- **Containerization**: We execute our analyses within a Docker container using the `quay.io/jupyter/datascience-notebook` image. This approach ensures a consistent and reproducible computing environment across different platforms, simplifying dependency management and streamlining the setup process.

- **Programming Language**: Our analysis is conducted using [R version 4.3.2 (2023-10-31)](https://cran.r-project.org/bin/windows/base/R-4.3.2-win.exe), chosen for its comprehensive statistical analysis and graphical capabilities.

- **Dependency Management**: We meticulously list and install all dependencies and necessary R packages through the Jupyter notebook titled [0.1_install_requirements.ipynb](0.1_install_requirements.ipynb), ensuring a seamless setup for conducting analyses.

## Data Acquisition

Interested parties can request data via email:<br>
- biologist.mmf@gmail.com<br>
- marilia.melo.favalesso@gmail.com

## Data Processing and Analysis

- **Data Download**: We have developed custom-built functions in the script [0.2_functions_download_hosp_data.R](0.2_functions_download_hosp_data.R) to streamline the process of downloading host data. These functions are utilized within the [1_download_merge_datasets.ipynb](1_download_merge_datasets.ipynb) notebook, enabling efficient acquisition and integration of datasets crucial for subsequent analysis.

- **Spatial Analysis**: The [2_distribution_hosts.ipynb](2_distribution_hosts.ipynb) notebook contains the spatial analysis, utilizing kernel density estimation (KDE) to map the distribution of host plants. This analysis intersects with *Lonomia* occurrence points and localities with reported lonomism cases, providing insights into spatial patterns and potential risk areas.

- **Descriptive Analysis**
  - **Temporal Trends**: The notebook [3_temporal_graph.ipynb](3_temporal_graph.ipynb) explores temporal analysis, charting the discovery timeline of new *Lonomia spp.* hosts. Through graphical representations, it uncovers trends and patterns in host discovery over time.
  - **Host Uses and Biological Characteristics**: The [4_describe.ipynb](4_describe.ipynb) notebook examines the principal human uses and biological characteristics associated with the host plants of *Lonomia* species. This comprehensive analysis sheds light on the ecological and anthropogenic factors influencing lonomism, facilitating informed strategies for prevention and mitigation.

