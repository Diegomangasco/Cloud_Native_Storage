# Cloud_Native_Storage
Enabling cloud-native storage in [CrownLabs](https://github.com/netgroup-polito/CrownLabs)

## Quick start
```
curl -s https://raw.githubusercontent.com/Diegomangasco/Cloud_Native_Storage/main/prepare.sh | bash
```
Do a reboot and then:
- For a cluster of 4 machines (mimic production)
```
curl -s https://raw.githubusercontent.com/Diegomangasco/Cloud_Native_Storage/main/init.sh | bash
```
- For a test environment
```
curl -s https://raw.githubusercontent.com/Diegomangasco/Cloud_Native_Storage/main/init-test.sh | bash
```

For launching the integration tests (the default branch is `"nfs-storage"`)
```
curl -s https://raw.githubusercontent.com/Diegomangasco/Cloud_Native_Storage/main/integration-test.sh | bash -s -- <BRANCH_NAME>
```
PS: For launching instance and tenant operator simultaneously we have to change in one of the operators:
- `metrics-addr`, adding it as a parameter in the makefile (set it to something like `:6547`)
- `HealthProbeBindAddress`, modifying `operators/cmd/(tenant|instance)-operator/main.go` in the creation of the manager