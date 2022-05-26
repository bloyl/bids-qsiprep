# editme: Change this to the BIDS App container
FROM pennbbl/qsiprep:0.15.4 as base

# editme: Change this to your email.
LABEL maintainer="support@flywheel.io"

# Hopefully You won't need to change anything below this.

# this npm install throws all types or deprecation/not supported errors?
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC && \
    apt-get update && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y \
    build-essential \
    nodejs \
    tree \
    zip && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g bids-validator@1.5.7


# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="/usr/local/miniconda/bin:$PATH" \
    CPATH="/usr/local/miniconda/include/:$CPATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1

# Python 3.8.3 (default, May 19 2020, 18:47:26)
# [GCC 7.3.0] :: Anaconda, Inc. on linux
COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/pip && \
    rm -rf /tmp/requirements.txt

ENV FLYWHEEL /flywheel/v0
WORKDIR ${FLYWHEEL}

# Save docker environ here to keep it separate from the Flywheel gear environment
RUN python -c 'import os, json; f = open("/flywheel/v0/gear_environ.json", "w"); json.dump(dict(os.environ), f)'

ENV PYTHONUNBUFFERED 1

COPY manifest.json ${FLYWHEEL}/manifest.json
COPY utils ${FLYWHEEL}/utils
COPY run.py ${FLYWHEEL}/run.py
RUN chmod -R a+rx ${FLYWHEEL}

ENTRYPOINT ["/flywheel/v0/run.py"]
