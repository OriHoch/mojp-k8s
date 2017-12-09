FROM google/cloud-sdk:alpine

RUN apk --update --no-cache add bash jq py2-pip openssl curl && pip install --upgrade pip && pip install python-dotenv
RUN gcloud --quiet components install kubectl
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && chmod 700 get_helm.sh && ./get_helm.sh && rm ./get_helm.sh

RUN mkdir /ops

# copy specific file here to prevent exposing secrets
COPY templates /ops/
COPY .env.* /ops/
COPY Chart.yaml /ops/
COPY *.sh /ops/
COPY Dockerfile /ops/
COPY values.yaml /ops/
COPY values.*.yaml /ops/

WORKDIR /ops

RUN echo "gcloud auth activate-service-account --key-file=/k8s-ops/secret.json" >> ~/.bashrc

ENTRYPOINT ["bash"]
