# An Overlooked Risk Factor for Lonomism: Host Plants of *Lonomia achelous* Crammer 1777 and *Lonomia obliqua* Walker 1955

## Authors
Marília Melo Favalesso[1,*], Matheus Valentim[2,*], Matías Emanuel Martínez[1], Admir Cesar de Oliveira Júnior[3,*], Lisete Maria Lorini[4], Shirley Martins Silva[5], Ana Tereza Bittencourt Guimarães[5], and Maria Elisa Peichoto[1]

<small>

[1] National Council for Scientific and Technical Research (CONICET), National Institute of Tropical Medicine (INMeT) - ANLIS “Dr. Carlos G Malbrán”, Research Group in Biotoxinology (GrinBiTox), Argentina. <br>
[2] IT University of Copenhagen, Denmark <br>
[3] Federal University of Paraná, Brazil <br>
[4] University of Passo Fundo, Brazil <br>
[5] State University of West Paraná, Center for Biological and Health Sciences, Brazil. 

[*] Data analysis

</small>

## Abstract

Lonomism envenoming is a serious and potentially fatal condition caused by exposure to the larvae of *L. achelous* and *L. obliqua* Walker 1855. These caterpillars are polyphagous and feed on a wide variety of plants ([Lorini, 2008](https://www.anolisbooks.com.br/produtos/detalhes/705/lepidopteros-de-importancia-medica-principais-especies-no-rio-grande-do-sul)). This means that exposure to *Lonomia* can occur in places where the presence of these hosts is common. Despite the importance of host plants in the life cycle of *Lonomia* and in human envenoming, relatively little is known about how the relationship between these organisms impacts envenoming cases.
In this context, the host plants of *Lonomia* spp. can be considered a risk factor for lonomism envenoming, as the caterpillars go through their entire life cycle on the host, and the accidents reported commonly occur in people who handle or accidentally touch colonies in trees ([Favalesso et al. 2023](https://linkinghub.elsevier.com/retrieve/pii/S0001-706X(22)00468-5)). Therefore, knowledge about the ecology and distribution of the host plants is fundamental to understanding and preventing envenoming by *Lonomia*.
Like other venomous animals, it is speculated that anthropogenic changes have created favorable conditions for the presence of *Lonomia* spp. caterpillars. Moreover, it is hypothesized that the loss of native hosts would be responsible for an adaptation of the caterpillars to non-native species in the South American continent, which would lead them to occupy new types of environments ([Favalesso et al., 2019](https://www.sciencedirect.com/science/article/abs/pii/S0001706X18309872); [Garcia, 2013](https://acervodigital.ufpr.br/handle/1884/31744?show=full); [Lorini, 1999]()). Although this hypothesis has been discussed in a variety of studies on lonomism (see chapter 1), little progress has been made to corroborate or refute it.
Thus, the aim of this chapter is to carry out a bibliographic and documentary review of the hosts of *L. achelous* and *L. obliqua* to characterize them in terms of their evolutionary origin (native or non-native), associated human uses, as well as the biological properties and distributive characteristics of the native hosts that may be related to the presence and distribution of both species. With this review, the aim is to provide relevant information for the design of prevention and control strategies for accidents by *Lonomia* spp. in South America.

> Future link for the thesis or paper.

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

