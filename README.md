[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.160-blue.svg)](https://doi.org/10.25663/brainlife.app.160)

# app-run-fmriprep

This app runs [fMRIPrep](https://github.com/poldracklab/fmriprep) on the [brainlife.io](https://brainlife.io/) interface. fMRIPrep is a robust processing tool delevoped by the [Poldrack Lab at Stanford](https://poldracklab.stanford.edu/). The pipelines process T1w, T2w, fMRI, and fieldmaps by calling a series of functions from FSL, FreeSurfer, ANTs, and nipy. It applies these tools in a principled way designed to handle common imaging artifacts and biases in a parimonious manner. It outputs processed anatomical and functional images for further analysis. 

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
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations 

Please cite the following articles when publishing papers that used data, code or other resources created by the brainlife.io community. 

* Esteban, O., Markiewicz, C. J., Blair, R. W., Moodie, C. A., Isik, A. I., Erramuzpe, A., ... & Oya, H. (2019). fMRIPrep: a robust preprocessing pipeline for functional MRI. Nature methods, 16(1), 111-116.
* Be sure to use fMRIPrep's documentation ([citing tools](https://fmriprep.readthedocs.io/en/stable/citing.html)) which will include the relevant references for the operations performed within this pipeline. 
* Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). https://doi.org/10.1038/s41597-019-0073-y

## Running the App 

### On Brainlife.io

Check out the brainlife app [here](https://doi.org/10.25663/brainlife.app.160)

### Running Locally

A
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
 
B
  1) Alternatively, there is a command line interface useful for debugging.

## Output

This app outputs the completed fmriprep dir, along with some of the outputs mapped for the brainlife interface.

### Dependencies

This App requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies. It also requires [jq](https://stedolan.github.io/jq/).

---

<sub> This material is based upon work supported by the National Science Foundation Graduate Research Fellowship under Grant No. 1342962. Any opinion, findings, and conclusions or recommendations expressed in this material are those of the authors(s) and do not necessarily reflect the views of the National Science Foundation. </sub>
