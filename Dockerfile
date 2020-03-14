# use debian as base image
FROM mrmoor/esa-snap:latest

# install jdk and python3 with required modules
RUN apt-get update && \
    apt-get -y install default-jdk python3 python3-pip git maven
RUN python3 -m pip install --user --upgrade setuptools wheel

# set JDK_HOME env
ENV JDK_HOME="/usr/lib/jvm/default-java"
ENV JAVA_HOME=$JDK_HOME
ENV PATH=$PATH:/root/.local/bin
ENV LD_LIBRARY_PATH=.

# install snappy the SNAP python module
# Add Python3.7 support via fork : 
# https://github.com/illumon-public/illumon-jpy/releases/download/1.20190816.73/deephaven_jpy-1.20190816.73-cp37-cp37m-linux_x86_64.whl
RUN /usr/bin/python3 --version
# Create ~/.snap temp directory to install from
RUN /usr/local/snap/bin/snappy-conf /usr/bin/python3 || true
RUN wget https://github.com/illumon-public/illumon-jpy/releases/download/1.20190816.73/deephaven_jpy-1.20190816.73-cp37-cp37m-linux_x86_64.whl
RUN mv deephaven_jpy-1.20190816.73-cp37-cp37m-linux_x86_64.whl /root/.snap/snap-python/snappy/jpy-1.20190816.73-cp37-cp37m-linux_x86_64.whl

# This ends with code 30 which may be a premonition of later failure, but hey we can run setup.py
RUN cd /root/.snap/snap-python/snappy/ && \
    /usr/bin/python3 ./snappyutil.py --snap_home /usr/local/snap --java_module /usr/local/snap/snap/modules/org-esa-snap-snap-python.jar \
    --force --log_file ./snappyutil.log --jvm_max_mem 1G --java_home /usr/local/snap/jre --req_arch amd64 || true
RUN cat /root/.snap/snap-python/snappy/snappyutil.log
RUN cd /root/.snap/snap-python/snappy/ && \
    python3 setup.py install
RUN ln -s /root/.snap/snap-python/snappy /usr/local/lib/python3.7/dist-packages/snappy

ENTRYPOINT ["/usr/bin/python3"]

