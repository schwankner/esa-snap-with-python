# use debian as base image
FROM mrmoor/esa-snap:latest

# install jdk and python3 with required modules
RUN apt-get update && \
    apt-get -y install default-jdk python3 python3-pip git maven
RUN python3 -m pip install --user --upgrade setuptools wheel

# set JDK_HOME env
RUN export JDK_HOME="/usr/lib/jvm/default-java"

# build jpy module from source
RUN cd /tmp/ && \
    git clone https://github.com/bcdev/jpy.git && \
    cd /tmp/jpy/ && \
    python3 setup.py --maven bdist_wheel && \
    mkdir -p /root/.snap/snap-python/snappy/&& \
    cp /tmp/jpy/dist/* /root/.snap/snap-python/snappy/


# install snappy the SNAP python module
RUN /usr/local/snap/bin/snappy-conf /usr/bin/python3
RUN cd /root/.snap/snap-python/snappy/ && \
    python3 setup.py install
RUN ln -s /root/.snap/snap-python/snappy /usr/lib/python3/dist-packages/snappy