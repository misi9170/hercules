#!/bin/bash
#SBATCH --job-name=emu
#SBATCH --time=1:00:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=36
#SBATCH --account=ssc
# #SBATCH --qos=high

# A lot of modules and conda stuff
# source /nopt/nrel/apps/anaconda/5.3/etc/profile.d/conda.sh
# module use /nopt/nrel/apps/modules/centos74/modulefiles
# module use /not/nrel/apps/modules/default/modulefiles
module purge
# module load conda/5.3
module load helics/helics-3.1.0_openmpi
module load netcdf-c/4.7.3/gcc-mpi
module load conda
#export FI_PROVIDER_PATH=$PREFIX/lib/libfabric/prov
#export LD_LIBRARY_PATH=$PREFIX/lib/libfabric:$PREFIX/lib/release_mt:$LD_LIBRARY_PATH
conda activate /home/msinner/emu_moa_dev/conda-env/emupy
# module load intel-mpi/2018.0.3

# module load mkl
# module load mpt


# Set up the helics broker
helics_broker -t zmq  -f 2 --loglevel="debug" & 

# Need to set this to your emu_python folder
python emu_runscript.py emu_input_longsim.yaml >> logemu 2>&1  & # Start the controller center and pass in input file

# Now go back to scratch folder and launch the job
mpirun -n 36 /home/msinner/emu_moa_dev/amr-wind/build/amr_wind amr_input.inp >> logamr 2>&1 