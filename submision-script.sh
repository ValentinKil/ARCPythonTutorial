#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=96000
#SBATCH --time=48:00:00
#SBATCH --partition=long
#SBATCH --job-name=my_python_job
#SBATCH --mail-type=ALL
#SBATCH --mail-user=name.surname@college.ox.ac.uk
#SBATCH --account=name_of_the_project

# Store original directory and print useful environment variables
ORIG=$(pwd)
echo "TMPDIR: $TMPDIR"
echo "SCRATCH: $SCRATCH"

# Set up directories
SCRATCH_DIR="$TMPDIR/run_$SLURM_JOB_ID"
mkdir -p "$SCRATCH_DIR"
mkdir -p "$SCRATCH_DIR/output"

DEST="$DATA/run_$SLURM_JOB_ID"
mkdir -p "$DEST"


cd "$SCRATCH_DIR" || exit 1
echo "Current directory: $(pwd)"

# Copy input files and program to scratch directory
SRC_DIR="$ORIG/path/to/code/src"
cp -r "$SRC_DIR" "$SCRATCH_DIR"

# in the background, touch files every 6 hours so they’re not deleted by tmpwatch
while true ; do sleep 6h ; find . -type f -exec touch {} + ; done &


# Load Anaconda module
module load Anaconda3

# Create or activate Conda environment
export CONPREFIX=$DATA/envname
source activate "$CONPREFIX" || { echo "Failed to activate Conda environment!"; exit 1; }

# Install required packages
conda install pip
pip install -r "$SCRATCH_DIR/src/requirements.txt" || { echo "Failed to install dependencies!"; exit 1; }

# Print job details
echo "Running on host: $(hostname)"
echo "Scratch directory: $SCRATCH_DIR"
echo "Output directory: $DEST"

# Run Python script
SCRIPT="$ORIG/path/to/code/script.py" 
cp -r "$SCRIPT" "$SCRATCH_DIR"
python script.py --output-dir "$SCRATCH_DIR/output" --data-dir "$DATA/dataset/data.npz" || { echo "Python script execution failed!"; exit 1; }

# Copy output files back to the destination directory
cp -r "$SCRATCH_DIR/output/"* "$DEST" || { echo "Failed to copy output files!"; exit 1; }

# Clean up scratch directory
rm -rf "$SCRATCH_DIR"

echo "Job completed successfully."