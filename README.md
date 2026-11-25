[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.160-blue.svg)](https://doi.org/10.25663/brainlife.app.160)

# app-run-fmriprep

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Preprocesses fMRI with fMRIPrep 20.2.1 and outputs the BOLD time series on the cortical surface (GIFTI in fsaverage or fsnative space and 91k CIFTI), with confound regressors, the preprocessed T1w and an HTML report.**

Converts the inputs to BIDS and runs fMRIPrep 20.2.1 with boundary-based registration and fieldmap-less SyN distortion correction (or the provided fieldmap), sampling the BOLD series onto the chosen FreeSurfer surface space and writing a 91k grayordinate CIFTI. Use it when the analysis is surface- or grayordinate-based; use the volume-output App otherwise. It needs at least a T1w and an fMRI and reuses a FreeSurfer output when given (it must come from the same T1w).

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.267](https://doi.org/10.25663/brainlife.app.267)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1w` | `neuro/anat/t1w` | yes | t1 anatomy to register the input fmri data. Please be sure to use the same t1 used to generate the freesurfer input. |
| `fmri` | `neuro/func/task` (!preprocessed) | yes | fmri data to preprocess |
| `freesurfer` | `neuro/freesurfer` (!v5) | yes | freesurfer output used to aid preprocessing |
| `t2w` | `neuro/anat/t2w` | no | Optional T2-weighted image of the same subject, added to the BIDS input for fMRIPrep. |
| `fmap` | `neuro/fmap` | no | 2phasemag fieldmap is not yet supported by fmriprep (https://github.com/poldracklab/sdcflows/issues/15) - testing 1.5.2 should should suppor it. |

| Output | Datatype | Description |
|---|---|---|
| `regress` | `neuro/regressors` | fMRIPrep confounds table (regressors.tsv and .json): motion, physiological and other nuisance time series. |
| `anat` | `neuro/anat/t1w` | preprocessed t1 (same alignment as the original t1, but level adjusted - editme) |
| `anat_mask` | `neuro/mask` | Brain mask of the preprocessed T1w in native T1w space. |
| `output_report` | `report/html` | fmriprep HTML report and figures |
| `cifti` | `neuro/cifti` | surface timeseries data in cifti |
| `surface-data` | `neuro/surface/data` | BOLD time series sampled on the left and right surfaces (left.gii, right.gii) in the selected surface space. |
| `surface-vertices` | `neuro/surface/vertices` | surface vertices. only meaningful for fsnative. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `space` | enum | `fsaverage5` | FreeSurfer surface space for the surface outputs (fsaverage variants or fsnative). Options: `fsaverage5`, `fsaverage6`, `fsnative`. |
| `skipbidsvalidation` | boolean | `false` | Skip the BIDS validation of input data. Try this option if your data is not BIDS compatible but you'd like to go ahead and process it through fmriprep anyway. |

Runtime: container `nipreps/fmriprep:20.2.1`; 8 CPUs; 14 GB memory; 9 h walltime; needs `FREESURFER_LICENSE`.

Please cite:
- Esteban O et al. fMRIPrep: a robust preprocessing pipeline for functional MRI. Nature Methods 16:111-116 (2019). [doi:10.1038/s41592-018-0235-4](https://doi.org/10.1038/s41592-018-0235-4)

<!-- brainlife-app:end -->

This app runs [fMRIPrep](https://github.com/poldracklab/fmriprep) on the [brainlife.io](https://brainlife.io/) interface. fMRIPrep is a robust processing tool delevoped by the [Poldrack Lab at Stanford](https://poldracklab.stanford.edu/). The pipelines process T1w, T2w, fMRI, and fieldmaps by calling a series of functions from FSL, FreeSurfer, ANTs, and nipy. It applies these tools in a principled way designed to handle common imaging artifacts and biases in a parimonious manner. It outputs processed anatomical and functional images for further analysis. 

#### citiations and resources to consider
* fMRIPrep paper: [nature methods paper](https://doi.org/10.1038/s41592-018-0235-4)
* fMRIPrep documentation: [read the docs](https://fmriprep.readthedocs.io/en/stable/)
* fMRIPrep also provides documentation to credit the tools employed in the pipeline: [citing tools](https://fmriprep.readthedocs.io/en/stable/citing.html)

### Authors
- Josh Faskowitz ([@faskowit](https://github.com/faskowit))
- Soichi Hayashi ([@soichih](https://github.com/soichih))

### Project director
- Franco Pestilli ([@francopestilli](https://github.com/francopestilli))

### Funding 

[![NSF-GRFP-1342962](https://img.shields.io/badge/NSF_GRFP-1342962-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1342962)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-1342962](https://img.shields.io/badge/NSF_DGE-1342962-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1342962)

## Running the App 

### On Brainlife.io

Check out the brainlife app [here](https://doi.org/10.25663/brainlife.app.160)

### Running Locally

A)
  1) git clone this repo.
  2) Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

  ```json
  {
    "t1": "./t1.nii.gz",
    "fmri": "./bold.nii.gz",
    "freesurfer": "./fsdir"
  }
  ```

  3. Launch the App by executing `main`

  ```bash
  ./main
  ```
 
B)
  Alternatively, there is a command line interface useful for debugging.

## Output

This app outputs the completed fmriprep dir, along with some of the outputs mapped for the brainlife interface. There are two different apps that run this code, so based on the app run, it will affect the output (volume vs. surface output). 

The outputs will include a `bold.nii.gz`, `mask.nii.gz`, `regressors.tsv`, `t1.nii.gz`, and some html output for quality control.

### Dependencies

This App requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies. It also requires [jq](https://stedolan.github.io/jq/).

---

#### MIT Copyright (c) brainlife.io

<sub> This material is based upon work supported by the National Science Foundation Graduate Research Fellowship under Grant No. 1342962. Any opinion, findings, and conclusions or recommendations expressed in this material are those of the authors(s) and do not necessarily reflect the views of the National Science Foundation. </sub>
