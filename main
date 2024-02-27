#!/bin/bash
#PBS -l nodes=1:ppn=16,walltime=9:00:00,vmem=28gb
#PBS -N fmriprep

set -x
set -e

bl2bids

#####################################################################################
#####################################################################################
#write out *plugin* configuration for fmriprep to limit mem/cpus
#this can't prevent the fmriprep/nipype bootup vmem spiking (could kill the job)
#but it seems to help...
cat <<EOF > multi_proc.yml
plugin: LegacyMultiProc
plugin_args: {maxtasksperchild: 1, memory_gb: 14, n_procs: 16, raise_insufficient: false}
EOF

#source bids_funcs.sh

#=======
WORKDIRNAME=work
if [ -d "/scratch/$USER/job_$SLURM_JOB_ID" ]; then
    echo "using NVMe directory"
    WORKDIRNAME=/scratch/$USER/job_$SLURM_JOB_ID/work
fi

outdir=out

#we should avoid using lustre filesystem as workdir on Expsnse@SDSC, 
#admin told me that it's causing high IOP
WORKDIRNAME=work
if [ -d "/scratch/$USER/job_$SLURM_JOB_ID" ]; then
    echo "using NVMe directory"
    WORKDIRNAME=/scratch/$USER/job_$SLURM_JOB_ID/work
fi

inT1w=`jq -r '.t1' config.json`
inT2w=`jq -r '.t2' config.json`
inFMRI=`jq -r '.fmri' config.json`
inFSDIR=`jq -r '.fsin' config.json`

space=$(jq -r .space config.json)

output_space=$space
cifti_output_resolution="91k" #could be 170k-higher resolution CIFTI output (170494 grayordinates @ 1.6mm).

#for volume output
resolution=$(jq -r .resolution config.json)
if [ $resolution != "original" ] && [ $resolution != "null" ] ;then
    output_space=$space:$resolution
fi

skipbidsvalidation=""
[ "$(jq -r .skipbidsvalidation config.json)" == "true" ] && skipbidsvalidation="--skip-bids-validation"

aroma=""
[ "$(jq -r .aroma config.json)" == "true" ] && aroma="--use-aroma"

#####################################################################################
#####################################################################################
# some logical checks
if [[ $inT1w = "null" ]] || [[ $inFMRI = "null" ]] ; then
	echo "app needs minimally a T1w and fmri. exiting"
	exit 1
fi

# extract info from brainlife interface, base on T1w
# get the staging dir, this is where meta information is
stagingDir=$(dirname $inT1w)
echo "ls dir where initial bl info read--> $stagingDir"
ls -dl $stagingDir

if [[ $stagingDir = "." ]]; then
   echo "error finding staging directory. exiting"
   exit 1
fi

#####################################################################################
#####################################################################################
# setup bids dir structure

# if freesurfer provided, copy it to the same level as output dir
# I ahve to copy the whole things in, because fmriprep tries to write stuff inside the freesurfer output directory
# (and fail with "Permission denied: '/export/prod/605d2c37750389fd17eb0118/60623689750389d3f6ec1f20/out/freesurfer/sub-9002/surf/lh.midthickness'"
# error because it's set to read-only.
if [[ $inFSDIR != "null" ]] ; then

    #clean up previous freesurfer dir if it exists
    rm -rf $outdir/freesurfer
    mkdir -p $outdir/freesurfer

    #TODO - strip alphanumeric chars?
    sub=$(jq -r '._inputs[] | select(.id == "t1w") | .meta.subject' config.json)
    cp -rH $inFSDIR $outdir/freesurfer/sub-$sub
    chmod -R +rw $outdir/freesurfer
    fs_dir_line=$(eval "echo --fs-subjects-dir \${outdir}/freesurfer")
else
    fs_dir_line=''
fi

# avoid templateflow problems on HPC's running singularity
mkdir -p templateflow
export SINGULARITYENV_TEMPLATEFLOW_HOME=$PWD/templateflow

# set FreeSurfer
[ -z "$FREESURFER_LICENSE" ] && echo "Please set FREESURFER_LICENSE in .bashrc" && exit 1;
echo $FREESURFER_LICENSE > license.txt

#clean up previous workdir if it exist
rm -rf $WORKDIRNAME && mkdir -p $WORKDIRNAME

# TODO - I shouldn't set cifti-output if it's running in volume mode?
time singularity exec -e \
    docker://nipreps/fmriprep:23.0.2 fmriprep \
    --notrack \
    --resource-monitor \
    --md-only-boilerplate \
    --stop-on-first-crash \
    --use-plugin=multi_proc.yml \
    --output-spaces $output_space \
    --cifti-output $cifti_output_resolution \
    --omp-nthreads 16 \
    --nthreads 16 \
    --force-bbr \
    --use-syn-sdc warn \
    $aroma \
    $skipbidsvalidation \
    $fs_dir_line \
    --skull-strip-template=NKI \
    --work-dir=$WORKDIRNAME \
    --fs-license-file=license.txt \
    bids $outdir participant

echo "done with fmriprep! - now organizing output"
./fmriprep2bl.sh
singularity exec -e docker://brainlife/dipy:1.4.1 ./create_parc_json.py
rm -rf labels.tsv

#for debugging https://github.com/nipreps/fmriprep/issues/2070
#cp -r $WORKDIRNAME debug

rm -r $WORKDIRNAME #saves scratch space/inodes

echo "all done"
