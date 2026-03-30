FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

WORKDIR /workspace

# System deps (cv2, etc.)
RUN apt-get update && apt-get install -y \
    git \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Install EXACT working core stack first
RUN pip install \
    torch==2.5.1+cu124 \
    torchvision==0.20.1+cu124 \
    torchaudio==2.5.1+cu124 \
    --index-url https://download.pytorch.org/whl/cu124

# Critical versions (avoid your previous issues)
RUN pip install \
    tokenizers==0.21.0 \
    transformers==4.54.1 \
    accelerate==1.6.0 \
    diffusers==0.32.1 \
    opencv-python==4.10.0.84 \
    bitsandbytes==0.49.2

# Install sd-scripts (exact commit you used)
RUN git clone https://github.com/kohya-ss/sd-scripts.git && \
    cd sd-scripts && \
    git checkout b2abe873a5fed9490aa29e4b9678f909d6c8a10f && \
    pip install -e .

# Install rest of your environment
COPY freeze.txt /tmp/freeze.txt
RUN pip install -r /tmp/freeze.txt --no-deps

# Default working dir
WORKDIR /workspace/sd-scripts
