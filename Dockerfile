# Builds cost_MAP.jar as a "fat jar" into
#   /java/dev/build/gui.jar

# USAGE:
#   docker build -f Dockerfile -t ees16/simccs ./
#   docker run -it -v $(pwd):/java/dev/share ees16/simccs \
#       /bin/bash -c "cp /java/dev/build/SimCCS.jar /java/dev/share/SimCCS.jar"

# docker build \
#     -f Dockerfile \
#     -t ees16/simccs \
#     --build-arg http_proxy="${http_proxy}" \
#     --build-arg https_proxy="${https_proxy}" \
#     --build-arg PROXY_HOST="proxyout.lanl.gov" \
#     --build-arg PROXY_PORT=8080 \
#     --build-arg NON_PROXY_HOSTS='*.lanl.gov|localhost' \
#     ./

# IMPORTANT NOTE:
#   OpenJFX, Gradle, and ARM-based architectures
#   do not play nice. When building, specify --platform=linux/arm64.
FROM ubuntu:20.04

ENV GRADLE_VERSION 6.4.1
ENV JDK_VERSION openjdk-11-jdk

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y \
        build-essential \
        apt-utils \
        ${JDK_VERSION} \
        ssh-client \
        wget \
        vim \
        tar \
        zip \
        unzip \
        curl \
        git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /*.deb

RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --verbose --no-check-certificate --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    && echo "Installing Gradle" \
    && mkdir -p /opt/gradle \
    && unzip -d /opt/gradle gradle.zip && rm gradle.zip \
    && touch /etc/profile.d/gradle.sh \
    && echo "export GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}" >> /etc/profile.d/gradle.sh \
    && echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> /etc/profile.d/gradle.sh
RUN . /etc/profile.d/gradle.sh

ENV GRADLE_HOME "/opt/gradle/gradle-${GRADLE_VERSION}"
ENV PATH "${GRADLE_HOME}/bin:${PATH}"

RUN mkdir $HOME/.gradle && touch $HOME/.gradle/gradle.properties

# Test that Java is working
RUN echo "Testing Java, Gradle, and OpenJFX building" && \
    java -version && gradle -version && \
    mkdir -p /java/dev/test/ && \
    cd /java/dev/test/ && \
    git clone https://github.com/openjfx/samples.git && \
    cd ./samples/CommandLine/Non-modular/Gradle/hellofx && \
    ./gradlew jar

# ============================== #
# Build SimCCS as a 'fat jar'
# ============================== #
WORKDIR /java/dev/costmap/
COPY . .
RUN ./gradlew jar && \
    mkdir -p /java/dev/build/ && \
    cp ./build/libs/gui.jar /java/dev/build/SimCCS.jar

CMD ["/bin/bash"]
