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
      with:
        version: 'v3.6.3'
    - uses: chrisdickinson/setup-yq@latest
    - uses: SamhammerAG/helm-action/build@v1.5
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

### Action inputs

| Name | Description | Required | Default |
| --- | --- | --- | --- |
| `registry` | OCI registry | true | |
| `registry_user` | OCI registry username | true | |
| `registry_password` | OCI registry password | true | |
| `registry_path` | Chart registry path | true | |
| `chart_version` | Chart version (only optional, when defined in Chart.yaml) | false | |
| `app_version` | App version (will be tagged and updated in Chart.yaml) | true | |
| `chart_folder` | Chart folder | true | |
| `chart_annotations` | Chart annotations that should be added (e.g. company 'samhammer ag' author 'alwin schiffman') | false | |

### Action outputs

| Name | Description |
| --- | --- |
| `image` | Chart image (Default '{registry}/{registry_path}:{chart_version}')


# Helm Action Deploy

Deploy chart from an OCI-based (Docker) registry.\
See full parameter documentation at deploy/action.yml

## Usage

```yaml
    steps:
    - uses: actions/checkout@v2
    - uses: azure/setup-helm@v1
      with:
        version: 'v3.6.3'
    - uses: chrisdickinson/setup-yq@latest
    - uses: SamhammerAG/helm-action/deploy@v1.5
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

### Action inputs

| Name | Description | Required | Default |
| --- | --- | --- | --- |
| `registry` | OCI registry | true | |
| `registry_user` | OCI registry username | true | |
| `registry_password` | OCI registry password | true | |
| `registry_path` | Chart registry path | true | |
| `app_version` | The app version tag | true | |
| `release_name` | Helm release name | true | |
| `release_name_max_length` | Helm release name chars before cut (defaults to 53, deactivate with 0) | false | 53 |
| `namespace` | Kubernetes namespace | true | |
| `values_file` | Values file (for multiple files use comma as delimiter) | false | |
| `set_string` | Single string parameter | false | |
| `kube_config` | Kubernetes custom config | false | |
| `additional_flags` | Additional flat flags | false | |


# Helm Action Uninstall

Uninstall helm releases, by matching release name.\
See full parameter documentation at uninstall/action.yml

## Usage (simple)

```yaml
    steps:
    - uses: azure/setup-helm@v1
      with:
        version: 'v3.6.3'
    - uses: SamhammerAG/helm-action/uninstall@v1.5
      with:
        namespace: my-namespace
        release_filter: ^my-release$ #regex filter
```

## Usage (with branch filter)

When you have deploy releases for feature branches you may set "branch" value (set-string/values-file) for this releases.
Then you can delete that release when your branch is merged/deleted. The "branch" Helm release parameter can be changed through
the "branch_helm_property" setting of the action.

```yaml
    steps:
    - uses: azure/setup-helm@v1
      with:
        version: 'v3.6.3'
    - run: echo "branch=${GITHUB_REF##*/}" | tr '[:upper:]' '[:lower:]' >> $GITHUB_OUTPUT 
      id: version
    - uses: SamhammerAG/helm-action/uninstall@v1.5
      with:
        namespace: my-namespace
        release_filter: ^my-release$ #regex filter
        branch_filter: ${{ steps.version.outputs.branch }}
```

### Action inputs

| Name | Description | Required | Default |
| --- | --- | --- | --- |
| `release_filter` | Helm release name (regular expression e.g. ^my-relase$). Lookaheads are supported. | true | |
| `branch_filter` | Branch name | false | |
| `branch_helm_property` | Property-Path in Helm-Release JSON for branch detection. (JQ format) | false | .branch |
| `namespace` | Kubernetes namespace | true | |
| `kube_config` | Kubernetes custom config | false | |
| `additional_flags` | Additional flat flags (e.g. --dry-run) | false | |
| `max_age_in_days` | All releases older than given day-count would be marked for deletion. | false | |

## License

This project is distributed under the [MIT license](LICENSE.md).
