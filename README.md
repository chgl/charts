# Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/chgl)](https://artifacthub.io/packages/search?repo=chgl)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/chgl/charts/badge)](https://api.securityscorecards.dev/projects/github.com/chgl/charts)

> A collection of Helm charts

```sh
helm repo add chgl https://chgl.github.io/charts
helm repo update
```

> [!NOTE]
> Also available as OCI artifacts: <https://github.com/chgl?tab=packages&repo_name=charts>.

## Compliance Reports

Each update to the charts is scanned using [Kubescape](https://kubescape.io/) against several [security frameworks](https://kubescape.io/docs/frameworks-and-controls/). The reports are published online at:

- NSA: <https://chgl.github.io/charts/kubescape-reports/nsa.html>
- MITRE: <https://chgl.github.io/charts/kubescape-reports/mitre.html>
- CIS: https://chgl.github.io/charts/kubescape-reports/cis-v1.23-t1.0.1.html

## Development

1. (Optional) Install the [pre-commit](https://pre-commit.com/) hooks

   ```sh
   pip install pre-commit
   pre-commit install
   ```

1. (Optional) Setup a KinD cluster with Nginx ingress

   ```sh
   # configures kind to listen on port 80 and 443 and make nodes ingress-ready
   kind create cluster --config=hack/kind-config.yaml
   # setup NGINX Ingress controller
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
   # (optional) install metrics-server to test VPA & HPA
   helm repo add metrics-server -n kube-system https://kubernetes-sigs.github.io/metrics-server/
   helm upgrade --install --set="args[0]=--kubelet-insecure-tls" metrics-server metrics-server/metrics-server
   ```

1. Make changes to the charts

1. Mount the folder in the [kube-powertools](https://github.com/chgl/kube-powertools) container to easily run linters and checks

   ```sh
   docker run --rm -it -v $PWD:/root/workspace ghcr.io/chgl/kube-powertools:v2.3.67@sha256:cc54c6f1c342fbf2108d5e398370fefbcb25389f24800467a86f14a838156248
   ```

1. Run chart-testing and the `chart-powerlint.sh` script to lint the chart

   ```sh
   chart-powerlint.sh
   ```

1. (Optional) View the results of the [polaris audit check](https://github.com/FairwindsOps/polaris) in your browser

   ```sh
   $ docker run --rm -it -p 9090:8080 -v $PWD:/root/workspace ghcr.io/chgl/kube-powertools:v2.3.67@sha256:cc54c6f1c342fbf2108d5e398370fefbcb25389f24800467a86f14a838156248
   bash-5.0: helm template charts/fhir-server/ | polaris dashboard --config=.polaris.yaml --audit-path=-
   ```

   You can now open your browser at <http://localhost:9090> and see the results and recommendations.

1. Bump the version in the changed Chart.yaml according to SemVer (The `ct lint` step above will complain if you forget to update the version.)

1. Run `generate-docs.sh` to auto-generate an updated README

   ```sh
   generate-docs.sh
   ```
