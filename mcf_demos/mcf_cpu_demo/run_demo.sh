#!/bin/bash

# exit when any command fails
set -e

echo_in_yellow() {
  YELLOW='\033[1;33m'
  echo -e "${YELLOW}$1${NORMAL}"
}
SCRIPT_DIR=$(dirname -- $0)

# Parse input kernel size argument
if [ "$#" -eq 1 ]
then
  KERNEL_SIZE=$1
else
  echo_in_yellow "Optional: Pass an integer for the box filter kernel size";
fi

# Add the generated python value types and mcf_tools to the python path
source setup_env.sh

# Run the main demo executable which listens for images, processes them, and publishes the results.
${SCRIPT_DIR}/build/McfCpuDemo ${SCRIPT_DIR}/config &

# Run the python script which publishes raw images to the main demo executable and listens for the 
# results. Uses KERNEL_SIZE if it's been set.
if [ -z ${KERNEL_SIZE+x} ]
then
  python ${SCRIPT_DIR}/python/process_images.py 127.0.0.1 6666 ${SCRIPT_DIR}/data/test_image.jpg
else
  python ${SCRIPT_DIR}/python/process_images.py 127.0.0.1 6666 ${SCRIPT_DIR}/data/test_image.jpg  --kernel_size ${KERNEL_SIZE}
fi

# Kill the main demo executable
killall -9 McfCpuDemo
