#!/bin/bash

#####################################################################################
# reogranize fmriprep outputs for brainlife
#####################################################################################

set -x
set -e

outdir=out
product=""

# get basename for fmri output
sub=$(jq -r '._inputs[] | select(.id == "fmri") | .meta.subject' config.json)
oDir=$outdir/fmriprep/sub-$sub
ses=$(jq -r '._inputs[] | select(.id == "fmri") | .meta.session' config.json)
[ "$ses" != "null" ] && oDir=$oDir/ses-$ses

mkdir -p regress
regressors_tsv=$(find $oDir/func -name "*_desc-confounds_timeseries.tsv")
[[ -f $regressors_tsv ]] && cp $regressors_tsv regress/regressors.tsv
regressors_json=$(find $oDir/func -name "*_desc-confounds_timeseries.json")
[[ -f $regressors_json ]] && cp $regressors_json regress/regressors.json

# need to check if we have surface or volume output,
# this will match for fsaverage, fsaverage5, ...
space=$(jq -r .space config.json)
if [[ $space =~ 'fsaverage' ]] || [[ $space == 'fsnative' ]] ; then
    # for surface/data
    mkdir -p surface-data
    ln -sf ../$(find $oDir/func -name "*_space-${space}_hemi-L_bold.func.gii") surface-data/left.gii
    ln -sf ../$(find $oDir/func -name "*_space-${space}_hemi-R_bold.func.gii") surface-data/right.gii
    product="\"surface-data\": { \"meta\": { \"space\": \"$space\" }, \"tags\": [ \"space-$space\"] }, $product"

    # for surface/vertices (we only need this for fsnative)
    mkdir -p surface-vertices/right surface-vertices/left
    time singularity exec -e -B `pwd`/license.txt:/usr/local/freesurfer/license.txt \
        docker://brainlife/freesurfer_on_mcr:6.0.0 \
        ./convertsurf.sh out/freesurfer/sub-$sub/surf
    product="\"surface-vertices\": { \"meta\": { \"space\": \"$space\" }, \"tags\": [ \"space-$space\"] }, $product"

    # cifti output
    mkdir -p cifti
    ln -sf ../$(find $oDir/func -name "*_bold.dtseries.nii") cifti/cifti.nii
    cifti_json=$(cat $oDir/func/*_bold.dtseries.json)
    product="\"cifti\": { \"meta\": $cifti_json }, $product"

else # else its a volume(bold) output

    bold_json=$(find $oDir/func -name "*_desc-preproc_bold.json")
    time singularity exec -e docker://brainlife/python:2.7.16 python ./merge_json.py -f1 config.json -f2 $bold_json -id_in fmri -out tmp.json
    product="\"bold_img\": {\"meta\": $(cat tmp.json), \"space\": \"$space\", \"tags\": [ \"space-$space\" ]}, $product"

    # get the preproc fmri vol
    mkdir -p bold_img
    #sub-A00008326_ses-DS2_task-rest_acq-645_space-MNI152NLin6Asym_res-2_desc-preproc_bold.nii.gz
    ln -sf ../$(find $oDir/func -name "*_space-${space}_*desc-preproc_bold.nii.gz") bold_img/bold.nii.gz

    # get the preproc fmri volmask
    mkdir -p bold_mask
    ln -sf ../$(find $oDir/func -name "*_space-${space}_*desc-brain_mask.nii.gz") bold_mask/mask.nii.gz
fi

### T1w outputs (subject space) ###
#there are t1w output for each output space, so we can't use wilcard
# TODO - should we output all output spaces?
mkdir -p anat anat_mask
sub=$(jq -r '._inputs[] | select(.id == "t1w") | .meta.subject' config.json)
oDir=$outdir/fmriprep/sub-$sub
ses=$(jq -r '._inputs[] | select(.id == "t1w") | .meta.session' config.json)
[ "$ses" != "null" ] && oDir=$oDir/ses-$ses
#anat
ln -sf ../$(find $oDir/anat -name "*_desc-preproc_T1w.nii.gz" -not -name "*space*") anat/t1.nii.gz
anat_json=$(find $oDir/anat -name "*_desc-preproc_T1w.json" -not -name "*space*")
time singularity exec -e docker://brainlife/python:2.7.16 python ./merge_json.py -f1 config.json -f2 $anat_json -id_in t1w -out tmp.json
product="\"anat\": {\"meta\": $(cat tmp.json) }, $product"
#anat_mask
ln -sf ../$(find $oDir/anat -name "*_desc-brain_mask.nii.gz" -not -name "*space*") anat_mask/mask.nii.gz
anat_mask_json=$(find $oDir/anat -name "*_desc-brain_mask.json" -not -name "*space*")
product="\"anat\": {\"meta\": $(cat $anat_mask_json) }, $product"

### html reports
rm -rf output_report #in case it's already there
mkdir -p output_report
for html in $(cd $outdir && find ./ -name "*.html"); do
    mkdir -p output_report/$(dirname $html)
    cp $outdir/$html output_report/$html
done
for dir in $(cd $outdir && find ./ -name "figures"); do
    mkdir -p output_report/$(dirname $dir)
    cp -r $outdir/$dir output_report/$(dirname $dir)
done
#rename the parent directory to confirm to brainlife html output
mv output_report/fmriprep output_report/html

### aparcaseg parcellation datatype
mkdir -p parcellation
labelsTsv=$outdir/fmriprep/desc-aparcaseg_dseg.tsv
cp ${labelsTsv} ./labels.tsv
#oDir=$outdir/fmriprep/sub-$sub
ln -sf ../$(find $oDir/anat -name "*_desc-aparcaseg_dseg.nii.gz" -not -name "*space*") parcellation/parc.nii.gz

### transform/h5 datatype
mkdir -p transform
#oDir=$outdir/fmriprep/sub-$sub
if [[ ${space} == 'T1w' ]]; then
    space="fsnative"
fi
ln -sf ../$(find $oDir/anat -name "*_from-T1w_to-${space}_mode-image_xfm.h5") transform/warp.h5
ln -sf ../$(find $oDir/anat -name "*_from-${space}_to-T1w_mode-image_xfm.h5") transform/inverse-warp.h5
ln -sf ../$(find $oDir/anat -name "*_from-T1w_to-*mode-image_xfm.txt") transform/affine.txt

### write out product.json
cat << EOF > product.json
{
    $product
    "brainlife": [
        {
            "type": "html",
            "name": "fmriprep report (todo)",
            "desc": "we could show the content of the html report here",
            "path": "output_report"
        }
    ]
}
EOF
