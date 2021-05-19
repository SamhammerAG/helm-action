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
    - uses: SamhammerAG/helm-action/build@v1.3
      with:
        registry: ${{ secrets.DOCKER_REGISTRY }}
        registry_user: ${{ secrets.DOCKER_REGISTRY_USER }}
        registry_password: ${{ secrets.DOCKER_REGISTRY_PW }}
        registry_path: charts/my-chart
        chart_folder: ./my-chart
        chart_version: 1.0 #optional
        app_version: 1.0
        chart_annotations: company 'samhammer ag' #optional
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
    - uses: SamhammerAG/helm-action/deploy@v1.3
      with:
        registry: ${{ secrets.DOCKER_REGISTRY }}
        registry_user: ${{ secrets.DOCKER_REGISTRY_USER }}
        registry_password: ${{ secrets.DOCKER_REGISTRY_PW }}
        registry_path: charts/my-chart
        app_version: 1.0
        namespace: my-namespace
        release_name: my-release
        values_file: ./my-chart/values.yaml #optional
        set_string: test=1 #optional
        additional_flags: --wait #optional
```

# Helm Action Uninstall

Uninstall helm release.\
See full parameter documentation at uninstall/action.yml

## Usage

```yaml
    steps:
    - uses: actions/checkout@v2
    - uses: azure/setup-helm@v1
    - uses: SamhammerAG/helm-action/uninstall@v1.4
      with:
        namespace: my-namespace
        release_filter: ^my-release$ #regex filter
        additional_flags: --dry-run #optional
```

## License

This project is distributed under the [MIT license](LICENSE.md).
