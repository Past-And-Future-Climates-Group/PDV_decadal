#!/bin/tcsh
### bash users replace /tcsh with /bash -l
#PBS -N cdo_cmip
#PBS -A UCSB0006
#PBS -l walltime=12:00:00
#PBS -q regular
#PBS -j oe
#PBS -k eod
#PBS -m abe
#PBS -M chenxing@ucsb.edu
#PBS -l select=2:ncpus=36:mpiprocs=36

### Set TMPDIR as recommended
setenv TMPDIR /glade/scratch/$USER/temp
### bash users: export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

### Run the executable
ncl ~/enso/cdo_local.ncl