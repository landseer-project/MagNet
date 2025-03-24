# Use Miniconda as the base image
FROM continuumio/miniconda3

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create a new Conda environment named "magnet"
RUN conda create --name magnet python=3.7 -y

# Activate the environment and install dependencies
RUN /bin/bash -c "source activate magnet"

SHELL ["conda", "run", "-n", "watermarknn", "/bin/bash", "-c"]

RUN /bin/bash -c "pip install --no-cache-dir tensorflow keras==2.0.8 numpy scipy matplotlib h5py"

# Copy the MagNet repository into the container
COPY . /app

# Download demo attack data and classifier
RUN wget -O demo_data.zip "https://www.dropbox.com/scl/fi/miem7ydf04hsmnpwzslfk/MagNet_support_data.zip?rlkey=k1a9u2ud2ajzo6un55di3d5xx&e=2&dl=0" && \
    unzip demo_data.zip -d /app/MagNet/ && \
    rm demo_data.zip

# Set environment variable to suppress TensorFlow logs
ENV TF_CPP_MIN_LOG_LEVEL=3

# Ensure the conda environment is used in container commands
SHELL ["conda", "run", "-n", "magnet", "/bin/bash", "-c"]

# Default command
CMD ["bash"]
