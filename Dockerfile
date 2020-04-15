FROM python
MAINTAINER Harsha Krishnareddy <c0mpiler@outlook.com>

# Replace sh with bash
RUN cd /bin && rm sh && ln -s bash sh

# Set environment
RUN \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/lib/apt/lists/partial/* && \
DEBIAN_FRONTEND=noninteractive apt-get update -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends apt-utils && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q locales sudo wget && \
echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_COLLATE C
ENV TERM xterm
ENV HOME /root
ENV TZ America/Los_Angeles

USER root

# Config for unicode input/output
RUN \
echo "set input-meta on" >> ~/.inputrc && \
echo "set output-meta on" >> ~/.inputrc && \
echo "set convert-meta off" >> ~/.inputrc && \
echo

# Console colors
RUN echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /root/.bashrc

# Ubuntu requirements
ENV REQUIRE="\
    apt-utils \
    apt-file \
    autoconf \
    automake \
    build-essential \
    cmake \
    wget \
    curl \
    default-jdk \
    default-jre \
    gfortran \
    git \
    libboost-all-dev \
    make \
    openssl \
    pkg-config \
"

# PYTHON DATA SCIENCE PACKAGES
#   * numpy: support for large, multi-dimensional arrays and matrices
#   * matplotlib: plotting library for Python and its numerical mathematics extension NumPy.
#   * scipy: library used for scientific computing and technical computing
#   * scikit-learn: machine learning library integrates with NumPy and SciPy
#   * pandas: library providing high-performance, easy-to-use data structures and data analysis tools
#   * nltk: suite of libraries and programs for symbolic and statistical natural language processing for English
ENV PYTHON_PACKAGES="\
    numpy \
    matplotlib \
    scipy \
    scikit-learn \
    pandas \
    seaborn \
    nltk \
    omxware \
"

RUN \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/apt/lists/partial/*

RUN \
    DEBIAN_FRONTEND=noninteractive apt-get clean -y && \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q ca-certificates && update-ca-certificates && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q ${REQUIRE} && \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && \
    DEBIAN_FRONTEND=noninteractive apt-get clean

RUN \
    python3 -m pip install pip -U

RUN \
    python3 -m pip install $PYTHON_PACKAGES

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

ENTRYPOINT ["docker-entrypoint.sh"]
