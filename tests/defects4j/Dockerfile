FROM ubuntu:20.04

ARG DEFECTS4J_PROJECT=JacksonCore
ARG DEFECTS4J_BUG_NUMBER=3

RUN \
  apt-get update -y && \
  apt-get install software-properties-common -y && \
  apt-get update -y && \
  apt-get install -y openjdk-11-jdk \
                git \
                build-essential \
                subversion \
                perl \
                curl \
                unzip \
                cpanminus \
                make \
                python3 \
                python3-pip \
                python3-venv \
                && \
  rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /
RUN git clone https://github.com/rjust/defects4j.git defects4j

WORKDIR /defects4j
RUN cpanm --installdeps .
RUN ./init.sh

ENV PATH="/defects4j/framework/bin:${PATH}"

# Copy the agent source code
COPY src /agent/src
COPY pyproject.toml /agent/
COPY uv.lock /agent/

WORKDIR /agent
RUN uv sync --frozen

WORKDIR /defects4j
RUN defects4j checkout -p ${DEFECTS4J_PROJECT} -v ${DEFECTS4J_BUG_NUMBER}b -w /workspace

ARG TASK_FILE
COPY ${TASK_FILE} /agent/task.txt

RUN echo '#!/bin/bash\n\
cd /agent\n\
uv run src/minisweagent/__main__.py -f /agent/task.txt\n\
' > /usr/local/bin/run-agent && chmod +x /usr/local/bin/run-agent

WORKDIR /workspace

RUN defects4j compile

# Example usage:
# docker build -t agent-defects4j .
# docker run --env-file .env -it agent-defects4j run-agent

# Build with custom project and bug:
# docker build --build-arg DEFECTS4J_PROJECT=Lang --build-arg DEFECTS4J_BUG_NUMBER=1 -t agent-defects4j .
