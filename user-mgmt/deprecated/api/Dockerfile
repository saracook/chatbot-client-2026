# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:24.04

RUN apt-get clean \
    && apt-get -y update

RUN apt-get -y install \
    build-essential \
    curl \
    git \
    jq \
    nginx \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    wget

RUN python3 -m venv /opt/python

RUN /opt/python/bin/python3 -m pip install --upgrade pip

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
      tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
      gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && \
    apt-get -y install google-cloud-sdk

WORKDIR /app
COPY cloudbuild-merge-user-changes.yaml /app/cloudbuild-merge-user-changes.yaml
COPY requirements.txt /app/requirements.txt
RUN /opt/python/bin/python3 -m pip install -r requirements.txt

COPY . .

EXPOSE 5000
CMD [ "/opt/python/bin/python3", "api.py" ]
