# Overview

This is a quickstart guide on running a monitoring stack for Confluent for Kubernetes kafka.

## Prerequisites
A running Kubernetes cluster (v1.23 or later)
kubectl installed and configured to interact with your cluster
Helm v3.x installed

## Components

* **Kind** - Used for running a local k8s cluster
* **Helm** - K8s package manager
* **CFK** - Confluent for K8s
* **Prometheus** - An open-source systems monitoring and alerting toolkit
* **Grafana** - An open-source platform for data visualization, monitoring, and analytics
* **Kafka-monitoring-tool** -


## Install Kind Cluster

```
kind create cluster
```

## Install Confluent for Kuberentes

Create `confluent` namespace

```
kubectl create namespace confluent
```

Install operator

```
helm repo add confluentinc https://packages.confluent.io/helm
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --namespace confluent
```

Install the custom resources and wait for Confluent components to start up
```
kubectl -n confluent apply -f k8s/cfk/confluent-platform-singlenode.yaml
```

## Install Prometheus
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update
```

```
helm upgrade --install demo-test prometheus-community/kube-prometheus-stack \
 --set alertmanager.persistentVolume.enabled=false \
 --set server.persistentVolume.enabled=false \
 --namespace default
```

## Install Grafana


```
helm upgrade --install grafana grafana/grafana --namespace default
```

## Open Grafana in Browser

```
 kubectl port-forward \
  $(kubectl get pods -n default -l app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana -o name) \
  3000 --namespace default
```

Get your 'admin' user password:

```
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```
Visit http://localhost:3000 in your browser, and login as the admin user with the decoded password.

## Configure Grafana with a Prometheus Data Source

```
http://demo-test-kube-prometheus-prometheus.default.svc.cluster.local:9090
```
Click "Save & Test". You should see a green alert at the bottom of the page saying "Data source is working".

## Import Grafana Dashboard Configuration

Follow the in-browser instructions to import a dashboard JSON configuration, or consult the online documentation.

* Select the confluent-platform.json file located in this folder to load dashboard for Confluent Platform, and then select the previously-configured Prometheus data source.
* Select the confluent-operator.json file located in this folder to load dashboard for Confluent Operator, and then select the previously-configured Prometheus data source.


## Delete Cluster

```
kind delete cluster
```