FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]


RUN apt-get update && apt-get install -y \
    git wget curl build-essential ca-certificates openssl \
    libgl1 libglib2.0-0 \
    x11-apps libxkbcommon0 libxkbcommon-x11-0 \
    libsm6 libxext6 libxrender1 libfontconfig1 \
    libxcb1 libxcb-render0 libxcb-render-util0 libxcb-image0 \
    libxcb-icccm4 libxcb-keysyms1 libxcb-randr0 libxcb-shape0 libxcb-xfixes0 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -p /opt/conda && \
    rm Miniforge3-$(uname)-$(uname -m).sh
ENV PATH="/opt/conda/bin:${PATH}"

COPY . /workspace
WORKDIR /workspace

RUN conda create -n tv python=3.10 pinocchio=3.1.0 numpy=1.26.4 -c conda-forge -y
SHELL ["conda", "run", "-n", "tv", "/bin/bash", "-c"]  

RUN git submodule update --init --depth 1 && \
    cd teleop/televuer && \
    pip install -e . && \
    cd ../robot_control/dex-retargeting && \
    pip install -e . && \
    cd ../../../ && \
    pip install -r requirements.txt

RUN cd third_party/unitree_sdk2_python && \
    pip install -e .

RUN echo "if [ -f /opt/conda/etc/profile.d/conda.sh ]; then" >> /root/.bashrc && \
    echo "    source /opt/conda/etc/profile.d/conda.sh" >> /root/.bashrc && \
    echo "    conda activate tv" >> /root/.bashrc && \
    echo "fi" >> /root/.bashrc

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
