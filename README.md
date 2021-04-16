# Helm Action

Contains multiple github actions for helm 3

# Helm Action Build

Package chart with version and publish to an OCI-based (Docker) registry.\
See full parameter documentation at build/action.yml

## Usage

```yaml
    steps:
    - uses: actions/checkout@v2
    - uses: azure/setup-helm@v1
    - uses: chrisdickinson/setup-yq@latest
    - uses: SamhammerAG/helm-action/build
        with:
        registry: ${{ secrets.DOCKER_REGISTRY }}
        registry_user: ${{ secrets.DOCKER_REGISTRY_USER }}
        registry_password: ${{ secrets.DOCKER_REGISTRY_PW }}
        registry_path: charts/my-chart
        chart_folder: ./my-chart
        chart_version: 1.0
```

# Helm Action Deploy

Deploy chart from an OCI-based (Docker) registry.\
See full parameter documentation at deploy/action.yml

## Usage

```yaml
    steps:
    - uses: actions/checkout@v2
    - uses: azure/setup-helm@v1
    - uses: chrisdickinson/setup-yq@latest
    - uses: SamhammerAG/helm-action/deploy
      with:
        registry: ${{ secrets.DOCKER_REGISTRY }}
        registry_user: ${{ secrets.DOCKER_REGISTRY_USER }}
        registry_password: ${{ secrets.DOCKER_REGISTRY_PW }}
        registry_path: charts/my-chart
        chart_version: 1.0
        namespace: my-namespace
        release_name: my-release
        values_file: ./my-chart/values.yaml #optional
        set_string: test=1 #optional
```

## License

This project is distributed under the [MIT license](LICENSE.md).
