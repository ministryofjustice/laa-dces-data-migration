# dces-check-attachment-exists

This is an Ubuntu based application which will run as a Docker container. The application loops through a table in Postgres, where file_exists is NULL or FALSE, which contains metadata about what physical attachments Marston is supposed to give to us. For each record, it checks in the path denoted by the S3_PREFIX input paramater, if those records exist. If the records exist then the table file_exists column is updated to TRUE or it is updated to FALSE.

### Application Set up

Clone Repository

```sh
git clone git@github.com:ministryofjustice/laa-dces-data-migration.git

cd laa-dces-data-migration/dces-check-attachment-exists
```

### To build the container

In the directory where the Dockerfile is located, run the following 
```
docker build -t <image_name> .
```

### Assumptions and pre-requisites
This application runs on Docker as a container and has some assumptions/pre-requisites:
- you have AWS CLI is installed and you have valid user credentials (**dces-admin-user-dev**) to access the s3 bucket => application needs to mount the 'credentials' file located in /.aws to the container
-  BATCH_SIZE is mandatory. This value should identify the number of records that should be processed in memory before retrieving the next batch
-  S3_PREFIX is mandatory. This value will identify the s3 directory (prefix) that the attachment files are located
-  PGUSER is mandatory. This value is the user that can access the postgres database. You must retrieve this value from Kubernetes secrets.
-  PGPASSWORD is mandatory. This is the password for the postgres database. You must retrieve this value from Kubernetes secrets.
- The ***secrets.env*** is unencrypted using **git-crypt unlock**

### To run the container, navigate to the directory where the Dockerfile is located

```
docker run -it --env-file ../secrets.env \
  -v <USER_HOME>/.aws:/root/.aws \
  -e BATCH_SIZE=<BATCH_SIZE> \
  -e PGUSER=<PGUSER> \
  -e PGPASSWORD=<PGPASSWORD>
  -e S3_PREFIX=<PREFIX> \
  <image_name>
```

***An example***

```
docker run -it --env-file ../secrets.env \
  -v ~/.aws:/root/.aws \
  -e BATCH_SIZE=10 \
  -e PGUSER=cp1234 \
  -e PGPASSWORD=jhgdkjfhgsk \
  -e S3_PREFIX=DRC/Attachments \
  my_app_image
```

### During container run

You will be prompted for the database password which you should enter by retrieving from Kubernetes secrets

### After container runs
- Check any error messages.
- Check the postgres database for the tables that you think should have been created


### To decrypt the secrets.env

The `secrets.env` is encrypted using [git-crypt](https://github.com/AGWA/git-crypt).

To run the app locally you need to be able to decrypt this file.

You will first need to create a GPG key. See [Create a GPG Key](https://docs.publishing.service.gov.uk/manual/create-a-gpg-key.html) for details on how to do this with `GPGTools` (GUI) or `gpg` (command line).
You can install either from a terminal or just download the UI version.

```
brew update
brew install gpg
brew install git-crypt
```

Once you have done this, a team member who already has access can add your key by running `git-crypt add-gpg-user USER_ID`\* and creating a pull request to this repo.

Once this has been merged you can decrypt your local copy of the repository by running `git-crypt unlock`.

\*`USER_ID` can be your key ID, a full fingerprint, an email address, or anything else that uniquely identifies a public key to GPG (see "HOW TO SPECIFY A USER ID" in the gpg man page).

### How to access the pods:

In order to access the pods, it is required to have Kubernetes installed and configured in your local machine. If you need help, check these documents:

- [Java Project Setup - Accessing Clusters](https://dsdmoj.atlassian.net/wiki/spaces/ASLST/pages/3761963077/Java+Project+Setup+with+CircleCI+and+Helm+on+Cloud+Platform#Accessing-the-clusters)
- [Connecting to the Cloud Platform's Kubernetes cluster - Cloud Platform User Guide](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/kubectl-config.html#installing-kubectl)

Assuming Kubernetes is all setup, follow these steps to access the pods.

1. Use the following command from terminal:

```sh
kubectl get pods -n {nameSpace}
```

Possible values for `nameSpace` are:

- laa-dces-data-migration-dev


Check response from command below, you will need that for the following step

```sh
kubectl get pods -n {nameSpace}
```

Output:

    NAME                                 READY   STATUS    RESTARTS   AGE
    {poddName}                           1/1     Running   0          18m

2. Access the pod console using the following command:

```sh
kubectl exec -it {podName} -n {nameSpace} -- sh
```

Example:

```sh
kubectl get pods -n laa-dces-data-migration-dev-readme
```

Output should be similar to this:

    NAME                                  READY   STATUS    RESTARTS   AGE
    laa-dces-data-migration-dev-00000-xxxxx   1/1     Running   0          18m

```shell
kubectl exec -it laa-dces-data-migration-00000-xxxxx -n laa-dces-data-migration-readme -- sh
```

That should give you access to the pods terminal.
