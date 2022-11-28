# Sysdig Threat Generator

This repo hosts combinations of tools, both public and private, for generating test scenarios.

# Getting Started

You can build your own Docker image with the files provided in `docker/`, with the following command:
`cd docker && docker build -t sysdig-threat-generator`.  

Or, you can simply create a Kubernetes pod using a pre-built image from the YAML in `kubernetes/`.  

Supporting scripts and other tools are located in `scripts/`.

## Example Syntax

### Docker
To run some container tests in local Docker:
`docker run -it --rm sysdig-threat-generator:latest /bin/bash -c "pwsh RunTests.ps1 BASE64.SHELLSCRIPT <NAME.OF.OTHER.TEST> <TEST3> <...>"`

### Kubernetes
To run the same, but in K8s:
change line 20 of `Sysdig-Threat_Generator.yaml` from 

```yaml
command: ["pwsh", "-c", "(./RunTests.ps1 XMRIG.EXEC)"]
```

to

```yaml
command: ["pwsh", "-c", "(./RunTests.ps1 BASE64.SHELLSCRIPT <NAME.OF.OTHER.TEST> <...>)"]
```

### Fargate
A minimal set of terraform files that are compatible with STG and Fargate can be found at [minimal-fargate-stg](https://github.com/sysdig/minimal_fargate_stg). The only variables you *should* need to change are in [`variables.tf`](https://github.com/sysdig/minimal_fargate_stg/blob/master/variables.tf). Note that for the VPC Subnets, one must be public and the other private. Edit [`workload.tf`](https://github.com/sysdig/minimal_fargate_stg/blob/master/workload.tf#L12) with your desired tests, similarly to how we did in the K8s yaml file.
Please raise any issues/concerns with your Sysdig Technical Contact.

# Example Tests, with Descriptions, and associated Rules
A brief description of some tests and the related alert/purpose:
| Test  | Description   |Sysdig Rule  | Caveat |
|---|---|---|---|
|  XMRIG.EXEC |Malware injected into container, cryptominer, new files/drift detection   | Cryptominer Pool, Cryptominer ML, new malicious binary  |
| STDIN.NETWORK  | Network anomaly, rev shell   | Reverse Shell to network socket  |   |   |
| DEV.SHM.EXEC  |In-mem malware    | Execution from /dev/shm  |   |   |
|T1048 |Data Exfiltration| Remote File Copy Tools in Container |
|RECON.FIND.SUID | Reconnaisance for SUID Binaries | Recon SUID Binary |
| T1611.002| Container Escape | Attempted Container Escape| 
| CREDS.DUMP.MEMORY | Dumps system memory via Lazagne, looking for credentials |Dump Memory for Credentials | Needs --privileged|
|KILL.MALICIOUS.PROC | Kills a known malicious process, simulating an adversary taking down other cryptominers on a target system. | Kill Malicious Process
|MEMFD.EXEC| Writes and then executes an ELF File to/from a `memfd`, an in-memory file descriptor (medium to advanced malware technique). | TBC (needs agent support)
|SUBTERFUGE.CURL.SOCKS| Uses a SOCKS proxy to get on the Tor network. |TBD
|LOAD.BPF.PROG| Creates and then loads a BPF program into the kernel| BPFDoor
|BASE64.CLI| Uses the base64 utility to decode some commands| Base64 on Command Line
|Base64.SHELLSCRIPT| Uses the base64 utility to decode and write a shell script| Base64 Shell Script
|CONNECT.UNEXPECTED| Creates a connection from an "unexpected" process, as if someone had pwned a server and hijacked control to their c2 server| 
Runtime threat/threat actor behavior - LD.LINUX.EXEC, LOAD.BPF.PROG, RECON.FIND.SUID, BASE64.CLI

Lateral movement/privesc/container escape - RECON.FIND.SUID, T1611.002

Stratus GCP Impersonate Service Account:
```bash
gcloud auth application-default login --no-browser
export GOOGLE_PROJECT=rule-testing-123456
./stratus warmup gcp.privilege-escalation.impersonate-service-accounts
./stratus detonate gcp.privilege-escalation.impersonate-service-accounts
./stratus cleanup gcp.privilege-escalation.impersonate-service-accounts
```

# Tools

## Atomic Red Team

Atomic Red Team™ is a library of tests mapped to the MITRE ATT&CK® framework for testing container security. Security teams can use Atomic Red Team to quickly, portably, and reproducibly test their environments.

https://github.com/redcanaryco/atomic-red-team/

## Stratus Red Team
Stratus Red Team is a library for testing cloud security on various cloud service providers.  Some configuration of this tool for your cloud environment is required before using.  Refer to the user guide on how to configure the tool for your cloud environment: https://stratus-red-team.cloud/user-guide/getting-started/

https://github.com/DataDog/stratus-red-team

