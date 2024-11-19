FROM dantorres3600/cuda_dev_base:latest

# Install base packages.
RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  libyaml-cpp-dev \
  libspdlog-dev \
  libgflags-dev && \
  rm -rf /var/lib/apt/lists/*

# Install Python OpenCV.
RUN pip install opencv-python

# Install glog.
RUN cd ${HOME} && \ 
  git clone https://github.com/google/glog.git && \
  cd glog && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -G Ninja .. && \
  ninja -j8 && \
  ninja install && \
  cd ${HOME} && \
  rm -rf glog

# Install Eigen 3.4.
RUN cd ${HOME} && \ 
  wget --no-check-certificate https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz && \ 
  tar xzf ./eigen-3.4.0.tar.gz && \
  cd ./eigen-3.4.0 && \
  mkdir build && \
  cd build && \
  cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release && \
  ninja -j8 && \
  ninja install && \ 
  cd ${HOME} && \
  rm -rf eigen-3.4.0 eigen-3.4.0.tar.gz

# Install Ceres solver.
RUN cd ${HOME} && \
  git clone --recurse-submodules https://github.com/ceres-solver/ceres-solver.git && \
  cd ceres-solver && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -G Ninja .. && \
  ninja -j8 && \
  ninja install && \
  cd ${HOME} && \
  rm -rf ceres-solver

# Install gtsam.
RUN cd ${HOME} && \
  git clone https://github.com/borglab/gtsam && \
  cd gtsam && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DGTSAM_BUILD_TESTS=OFF -DGTSAM_BUILD_UNSTABLE=ON -DTGSAM_BUILD_EXAMPLES=OFF -DGTSAM_SHARED_LIB=ON -G Ninja .. && \
  ninja -j8 && \
  ninja install && \
  cd ${HOME} && \
  rm -rf gtsam

# Install gtest.
RUN cd ${HOME} && \
  git clone https://github.com/google/googletest.git && \
  cd googletest && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release -G Ninja .. && \
  ninja -j8 && \
  ninja install && \
  cd ${HOME} && \
  rm -rf googletest

# Install Pangolin.
RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  libgl-dev 
RUN cd ${HOME} && \
  git clone --recursive https://github.com/stevenlovegrove/Pangolin.git && \
  cd Pangolin && \
  cd scripts && \
  yes | ./install_prerequisites.sh && \
  cd .. && \
  mkdir build && \
  cd build && \
  cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release && \
  ninja -j8 && \
  ninja install && \
  cd ${HOME} && \
  rm -rf Pangolin

# Install Sophus.
RUN cd ${HOME} && \
  git clone https://github.com/strasdat/Sophus.git && \
  cd Sophus && \
  mkdir build && \
  cd build && \
  cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SOPHUS_TESTS=OFF -DBUILD_SOPHUS_EXAMPLES=OFF && \
  ninja -j8 && \
  ninja install && \
  cd ${HOME} && \
  rm -rf Sophus

# Install Navlie.
RUN cd ${HOME} && \
  git clone https://github.com/decargroup/navlie.git && \
  cd navlie && \
  pip install . && \
  cd ${HOME} && \
  rm -rf navlie

  # To enable Matplotlib visualization from python script.
RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  python3-tk 

  # Create user and add it to sudo group.
ARG USERNAME=cv-dev
RUN useradd -m ${USERNAME} && echo "${USERNAME}:${USERNAME}" | chpasswd 
RUN usermod -aG sudo ${USERNAME} 

COPY .bash_aliases /home/${USERNAME}/.bash_aliases