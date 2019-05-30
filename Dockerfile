FROM alpine:latest
MAINTAINER Ben Plessinger <ben@plessinger.us>
LABEL Description="Provides OpenStack client tools for the University at Buffalo Lake Effect OpenStack Cloud" Version="1"

RUN apk add --update \
  ca-certificates \
  gcc \
  git \
  libffi-dev \
  linux-headers \
  musl-dev \
  openssl-dev \
  py-pip \
  py-setuptools \
  python-dev
RUN pip install --upgrade --no-cache-dir \
  pip \
  python-cinderclient \
  python-openstackclient \
  setuptools
RUN pip install git+https://github.com/ubccr/v3oidcmokeyapikey.git
RUN apk del gcc musl-dev linux-headers libffi-dev
RUN rm -rf /var/cache/apk/*


ENV OS_AUTH_TYPE=v3token
ENV OS_AUTH_URL=https://lakeeffect.ccr.buffalo.edu:8770/v3
ENV OS_IDENTITY_API_VERSION=3
ENV OS_INTERFACE=public
ENV OS_PROJECT_DOMAIN_NAME="lakeeffect"
ENV OS_REGION_NAME="buffalo"

COPY assets/openrc /etc/openrc
# Add a volume so that a host filesystem can be mounted
# Ex. `docker run -v $PWD:/scratch lakeeffect-cli
VOLUME ["/scratch"]


# Always make sure we have the OS_TOKEN for authentication
ENTRYPOINT ["/bin/sh", "/etc/openrc"]

# Default is to start a shell.  A more common behavior would be to override
# the command when starting.
# Ex. `docker run -it lakeeffect-cli openstack server list`
CMD ["/bin/ash", "-l"]
