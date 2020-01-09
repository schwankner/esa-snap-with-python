# use debian as base image
FROM mrmoor/esa-snap:latest

# install jdk and python3 with required modules
RUN apt-get update && \
    apt-get -y install default-jdk python python-pip git maven python-jpy
RUN python -m pip install --user --upgrade setuptools wheel

# set JDK_HOME env
ENV JDK_HOME="/usr/lib/jvm/default-java"
ENV JAVA_HOME=$JDK_HOME
ENV PATH=$PATH:/root/.local/bin

# install snappy the SNAP python module
RUN /usr/local/snap/bin/snappy-conf /usr/bin/python
RUN cd /root/.snap/snap-python/snappy/ && \
    python setup.py install
RUN ln -s /root/.snap/snap-python/snappy /usr/lib/python2.7/dist-packages/snappy

