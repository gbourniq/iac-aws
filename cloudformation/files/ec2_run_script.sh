#!/bin/bash

echo "Running EC2 script as $(whoami)"
source ~/.bashrc

echo "Creating '${REPOSITORY_NAME}' conda environment..."
conda create --name ${REPOSITORY_NAME} -y
conda activate ${REPOSITORY_NAME}

# Commenting because not enough memory on t2.micro
# echo "Updating '${REPOSITORY_NAME}' environment..."
# conda env update -f ${HOME}/${REPOSITORY_NAME}/environment.yml -n ${REPOSITORY_NAME}

echo "Git checkout to branch ${BRANCH_NAME}"
cd ${HOME}/${REPOSITORY_NAME}
git checkout ${BRANCH_NAME}

# Commenting because not enough memory on t2.micro
# echo "Installing project dependencies with poetry"
# poetry install
