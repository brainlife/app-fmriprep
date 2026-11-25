<h1 align="center">fMRIPrep</h1>

<p align="center">
  Preprocessed BOLD time series (in a volume space or on the cortical surface), confound regressors, a preprocessed T1w and a visual report from raw fMRI and anatomy, with fMRIPrep.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.160"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.160-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> 📍 **This branch, `20.2.3-2`, is the brainlife.io App fMRIPrep - Volume Output** ([doi:10.25663/brainlife.app.160](https://doi.org/10.25663/brainlife.app.160)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Preprocesses task or resting fMRI with fMRIPrep 20.2.3 (motion and distortion correction, BBR registration to the T1w, normalisation) and outputs the preprocessed BOLD volume, brain masks, confound regressors, transforms and an HTML report.**

Converts the inputs to BIDS and runs fMRIPrep 20.2.3 with boundary-based registration, fieldmap-less SyN distortion correction (or the provided fieldmap) and optional ICA-AROMA, writing the BOLD series in the chosen output space and resolution. Use it as the standard preprocessing step before fMRI analysis; it needs at least a T1w and an fMRI, and reuses a FreeSurfer output when given (it must come from the same T1w). Also outputs the preprocessed T1w, its brain mask, the aparc+aseg parcellation and T1w-to-template transforms.

| | |
|---|---|
| 📥 **Inputs** | `neuro/anat/t1w` · `neuro/func/task` · `neuro/freesurfer` · `neuro/anat/t2w` (optional) · `neuro/fmap` (optional) |
| 📤 **Outputs** | `neuro/func/task` · `neuro/mask` ×2 · `neuro/regressors` · `neuro/anat/t1w` · `report/html` · `neuro/transform/h5` · `neuro/parcellation/volume` |
| 🐳 **Container** | `nipreps/fmriprep:20.2.3` |
| ⚙️ **Resources** | 8 CPUs · 9 h walltime |
| 🔑 **Requires** | `FREESURFER_LICENSE` |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.160](https://doi.org/10.25663/brainlife.app.160) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1w` | `neuro/anat/t1w` | yes | t1 anatomy to register the input fmri data. Please be sure to use the same t1 used to generate the freesurfer input. |
| `fmri` | `neuro/func/task` (!preprocessed) | yes | fmri data to preprocess |
| `freesurfer` | `neuro/freesurfer` (!v5) | yes | freesurfer output used to aid preprocessing |
| `t2w` | `neuro/anat/t2w` | no | Optional T2-weighted image of the same subject, added to the BIDS input for fMRIPrep. |
| `fmap` | `neuro/fmap` | no | 2phasemag fieldmap is not yet supported by fmriprep (https://github.com/poldracklab/sdcflows/issues/15) - should be supported by now |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `bold_img` | `neuro/func/task` | Preprocessed BOLD time series (bold.nii.gz) in the selected output space, with the events file when present. |
| `bold_mask` | `neuro/mask` | There is no such datatype tag for mask as "bold". It will be removed in favor of "func" |
| `regress` | `neuro/regressors` | fMRIPrep confounds table (regressors.tsv and .json): motion, physiological and other nuisance time series. |
| `anat` | `neuro/anat/t1w` | preprocessed t1 (same alignment as the original t1, but level adjusted - editme) |
| `anat_mask` | `neuro/mask` | Brain mask of the preprocessed T1w in native T1w space. |
| `output_report` | `report/html` | fmriprep HTML report and figures |
| `transform` | `neuro/transform/h5` | Transforms between T1w and the template space: warp.h5, inverse-warp.h5 and affine.txt. |
| `parcellation` | `neuro/parcellation/volume` | FreeSurfer aparc+aseg segmentation in T1w space with its label table. |

<details>
<summary><b>⚙️ Parameters</b> (4)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `space` | enum | `T1w` | output space of the preprocessed func/task output (bold). Options: `T1w`, `MNI152NLin2009cAsym`, `MNI152NLin6Asym`. |
| `resolution` | enum | `original` | Output resolution appended to the output space (space:resolution); 'original' keeps the input BOLD resolution. Options: `original`, `res-2`, `res-3`. |
| `skipbidsvalidation` | boolean | `false` | Skip the BIDS validation of input data. Try this option if your data is not BIDS compatible but you'd like to go ahead and process it through fmriprep anyway. |
| `aroma` | boolean | `false` | Use ICA based procedure to identify confounding time series related to head-motion [Prium2015]. |

</details>

<!-- brainlife-app:end -->

## About

This App runs [fMRIPrep](https://github.com/nipreps/fmriprep) on brainlife.io. fMRIPrep is a robust preprocessing pipeline developed by the [Poldrack Lab at Stanford](https://poldracklab.stanford.edu/). It processes T1w, T2w, fMRI and fieldmap data by calling a series of functions from FSL, FreeSurfer, ANTs and nipy, applied in a principled way designed to handle common imaging artifacts and biases parsimoniously, and outputs processed anatomical and functional images for further analysis.

The App converts its inputs to BIDS and runs fMRIPrep with boundary-based registration (`--force-bbr`), fieldmap-less SyN distortion correction (`--use-syn-sdc`) unless a fieldmap is provided, and the NKI skull-stripping template. See the [fMRIPrep documentation](https://fmriprep.readthedocs.io/en/stable/) for details of each step.

## 🏷️ Versions on brainlife.io

Two Apps are built from this repository, one for each kind of output; each runs from its own branch.

| App | fMRIPrep | Output | Branch | Run it | Status |
|---|---|---|---|---|---|
| fMRIPrep - Surface Output | 20.2.1 | GIFTI surfaces (fsaverage5/6 or fsnative) and 91k CIFTI | [`20.2.1`](https://github.com/brainlife/app-fmriprep/tree/20.2.1) | [doi:10.25663/brainlife.app.267](https://doi.org/10.25663/brainlife.app.267) | current |
| **fMRIPrep - Volume Output** (this branch) | 20.2.3 | BOLD volume in T1w, MNI152NLin2009cAsym or MNI152NLin6Asym space | [`20.2.3-2`](https://github.com/brainlife/app-fmriprep/tree/20.2.3-2) | [doi:10.25663/brainlife.app.160](https://doi.org/10.25663/brainlife.app.160) | current |

Use the surface-output App when your analysis is surface- or grayordinate-based, and the volume-output App otherwise. The default branch (`master`) is a development version that runs fMRIPrep 24.1.1; it is not the code behind either registered App.

## 🚀 Running the App

### ☁️ On brainlife.io

Open the [surface-output](https://doi.org/10.25663/brainlife.app.267) or [volume-output](https://doi.org/10.25663/brainlife.app.160) App, choose the inputs from your project, set the options and press **Execute**.

**Inputs**

- **T1w** (`neuro/anat/t1w`): the anatomy used to register the fMRI. Use the same T1w that was used to generate the FreeSurfer input.
- **fMRI** (`neuro/func/task`, not tagged `preprocessed`): the BOLD run to preprocess, with its sbref, events and physio files when present.
- **FreeSurfer** (`neuro/freesurfer`, not tagged `v5`): a FreeSurfer output of the same T1w, reused by fMRIPrep instead of running recon-all.
- **T2w** (`neuro/anat/t2w`, optional): a T2-weighted image of the same subject.
- **Fieldmap** (`neuro/fmap`, optional): phase-difference, fieldmap, two-phase or EPI (pepolar) fieldmaps used for distortion correction.

**Options**

- **`space`**: the output space. Volume App: `T1w` (default), `MNI152NLin2009cAsym` or `MNI152NLin6Asym`. Surface App: `fsaverage5` (default), `fsaverage6` or `fsnative`.
- **`resolution`** (volume App): `original` keeps the input BOLD resolution; `res-2` or `res-3` selects a template resolution.
- **`aroma`** (volume App): run ICA-AROMA to identify confounding time series related to head motion.
- **`skipbidsvalidation`**: skip the BIDS validation of the input data. Try this if your data is not BIDS-compatible but you want fMRIPrep to process it anyway.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/), a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html), and the `bl2bids` command on your `PATH` (`main` calls it to build the BIDS input from `config.json`). fMRIPrep runs from the `nipreps/fmriprep` container.

1. Clone this repository and check out the App you want (`git checkout 20.2.1` for surface output, `git checkout 20.2.3-2` for volume output).
2. Create `config.json` with the paths to your inputs and the options you want. `config.json.sample` shows a complete example, including the `_inputs` metadata (subject, session) that `bl2bids` uses. The essential keys are:

   ```json
   {
       "t1": "./input/t1w/t1.nii.gz",
       "fmri": "./input/fmri/bold.nii.gz",
       "fsin": "./input/freesurfer/output",
       "space": "T1w",
       "resolution": "original",
       "skipbidsvalidation": false
   }
   ```

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

`clean.sh` removes the outputs and working files of a previous run.

## 📦 Outputs

The full fMRIPrep derivatives are written to `out/`. The App maps the main results to brainlife.io datatypes:

```text
regress/           regressors.tsv and regressors.json (fMRIPrep confounds)
anat/              t1.nii.gz, the preprocessed T1w in native T1w space
anat_mask/         mask.nii.gz, its brain mask
output_report/     fMRIPrep HTML report and figures
# volume-output App
bold_img/          bold.nii.gz (preprocessed BOLD in the chosen space) and events.tsv when present
bold_mask/         mask.nii.gz, the BOLD brain mask
transform/         warp.h5, inverse-warp.h5 and affine.txt between T1w and the template
parcellation/      parc.nii.gz (FreeSurfer aparc+aseg in T1w space) with its label table
# surface-output App
surface-data/      left.gii and right.gii, the BOLD time series on each hemisphere
surface-vertices/  left and right surface vertices (only meaningful for fsnative)
cifti/             cifti.nii, the 91k grayordinate dtseries
```

## 🩺 Troubleshooting

- **`app needs minimally a T1w and fmri. exiting`**: provide both a T1w and an fMRI input.
- **`Please set FREESURFER_LICENSE in .bashrc`**: no FreeSurfer license is available. Set `FREESURFER_LICENSE` when running locally; brainlife.io provides it automatically.
- **Two-phase/magnitude (`2phasemag`) fieldmaps**: these were not supported by the fMRIPrep distortion-correction module ([sdcflows issue #15](https://github.com/poldracklab/sdcflows/issues/15)) when these Apps were built.
- **Input fails BIDS validation**: set `skipbidsvalidation`.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Esteban O, et al. fMRIPrep: a robust preprocessing pipeline for functional MRI. *Nature Methods* 16:111–116 (2019). [doi:10.1038/s41592-018-0235-4](https://doi.org/10.1038/s41592-018-0235-4)
- fMRIPrep - Volume Output. brainlife.io App. [doi:10.25663/brainlife.app.160](https://doi.org/10.25663/brainlife.app.160)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Josh Faskowitz ([@faskowit](https://github.com/faskowit))
- Soichi Hayashi ([@soichih](https://github.com/soichih))
- Franco Pestilli ([@francopestilli](https://github.com/francopestilli), project director)

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

This material is based upon work supported by the National Science Foundation Graduate Research Fellowship under Grant No. 1342962. Any opinion, findings, and conclusions or recommendations expressed in this material are those of the authors(s) and do not necessarily reflect the views of the National Science Foundation.

## ⚖️ License

[MIT](LICENSE). fMRIPrep is distributed under the [Apache License 2.0](https://github.com/nipreps/fmriprep/blob/master/LICENSE).
