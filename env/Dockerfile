#
# MIT License
#
# Copyright (c) 2020-present Cloudogu GmbH and Contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

FROM adoptopenjdk/openjdk11:jdk-11.0.7_10-alpine-slim as build

ARG PYTHON=python3
ENV PYTHON=${PYTHON}

ARG MERCURIAL=mercurial-5.4.1
ENV MERCURIAL=${MERCURIAL}

WORKDIR /src
RUN apk add --upgrade alpine-sdk ${PYTHON} ${PYTHON}-dev
RUN set -x \
 && wget https://www.mercurial-scm.org/release/${MERCURIAL}.tar.gz \
 && tar xvfz ${MERCURIAL}.tar.gz \
 && rm -f ${MERCURIAL}.tar.gz
WORKDIR /src/${MERCURIAL}
RUN make build
RUN make PREFIX=/usr install-bin

FROM adoptopenjdk/openjdk11:jdk-11.0.7_10-alpine-slim

ARG PYTHON_DIR=/usr/lib/python3.8
ENV PYTHON_DIR=${PYTHON_DIR}

ENV SCM_HOME=/var/lib/scm
ENV CACHE_DIR=/var/cache/scm/work

# TODO add download
COPY . /

RUN set -x \
 && apk add --no-cache ${PYTHON} bash ca-certificates \
 && addgroup -S -g 1000 scm \
 && adduser -S -s /bin/false -G scm -h ${SCM_HOME} -D -H -u 1000 scm \
 && mkdir -p ${SCM_HOME} ${CACHE_DIR} \
 && chmod +x /opt/scm-server/bin/scm-server \
 && chown scm:scm ${SCM_HOME} ${CACHE_DIR}

# copy mercurial installation
COPY --from=build /usr/bin/hg /usr/bin/hg
COPY --from=build ${PYTHON_DIR} ${PYTHON_DIR}

WORKDIR "/opt/scm-server"
VOLUME ["${SCM_HOME}", "${CACHE_DIR}"]
EXPOSE 8080
USER scm

ENTRYPOINT [ "/opt/scm-server/bin/scm-server" ]
