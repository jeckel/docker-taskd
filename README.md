[![Twitter](https://img.shields.io/badge/Twitter-%40jeckel4-blue.svg)](https://twitter.com/jeckel4) [![LinkedIn](https://img.shields.io/badge/LinkedIn-Julien%20Mercier-blue.svg)](https://www.linkedin.com/in/jeckel/)
# Taskwarrior Server (taskd) Docker

*Forked from [8sd/docker-taskd](https://github.com/8sd/docker-taskd)

(c) 2015-2016 Óscar García Amor
Redistribution, modifications and pull requests are welcomed under the terms
of MIT license.

[Taskwarrior](https://www.taskwarrior.org) is Free and Open Source Software
that manages your TODO list from your command line. It is flexible, fast,
efficient, and unobtrusive. It does its job then gets out of your way.

This docker packages **taskd**, Taskwarrior sync server, under [Alpine
Linux](https://alpinelinux.org/), a lightweight Linux distribution.

Visit [Docker Hub](https://hub.docker.com/r/ogarcia/taskd/) to see all
available tags.

## Run

To run this container exposing taskd default port and making the data volume
permanent in `/srv/taskd`, simply run.

```sh
docker run -d \
  --name=taskd \
  -p 53589:53589 \
  -v /srv/taskd:/var/taskd \
  andir/docker-taskd
```

This makes a set of self signed certificates and minimal configuration to
run server.

### Run on remote server

To run this container on a remote server, simply run

```sh
docker run -d \
  --name=taskd \
  -p 53589:53589 \
  -v /srv/taskd:/var/taskd \
  -h <hostname>
  andir/docker-taskd
```

Where `<hostname>` is the domain how the remote server can be reached.

## Manual setup

The `run.sh` script that launch **taskd** server always look for config file
in data volume `/var/taskd`. If found it, simply run the server, but if
config file is absent `run.sh` will build a new default config and its
certificates.

If you make the data volume permanent you'll can access to its contents and
make modifications that you need. The significant files are.

* `config` taskd config itself.
* `log` directory of log.
* `org` taskd data.
* `pki` directory that contains certs and certs generation helpers.

You can do any changes to this, but remember that if you delete `config`
file, the `run.sh` script will rebuild everything.

Please refer to [Taskwarrior Docs](https://taskwarrior.org/docs/) to know
how do modifications, add users, etc.

## Shell run

In some cases, you could need to run `taskd` command. You can run this
docker in interactive mode, simply do.

```sh
docker run -ti --rm \
  -v /srv/taskd:/var/taskd \
  andir/docker-taskd /bin/sh
```

This mounts the permanent data volume `/srv/taskd` into **taskd** data
directory and gives you a interactive shell to work.

Please note that the `--rm` modifier destroy the docker after shell exit.

## Env variables

- `TASKDDATA` : (mounted) folder where taskwarrior data will be stored
- `CLIENT_CERT_PATH` : (mounted) folder where client certificate and credentials will be stored
- `TASKD_ORGANIZATION` : Default organisation when creating new user
- `TASKD_USERNAME` : User name for the first user

## Use your own certificate configuration file with swarm

If you want to customize certificate generation, you can mount your own configuration.

This can really useful when using [configs](https://docs.docker.com/engine/swarm/configs/) in a docker swarm.

First create a `vars` file like:
```
BITS=4096
EXPIRATION_DAYS=365
ORGANIZATION="My Organization"
CN=my.organization.com
COUNTRY=FR
STATE="FRANCE"
LOCALITY="Paris"
```

And then mount it:
```sh
docker run -d \
  --name=taskd \
  -p 53589:53589 \
  -v /srv/taskd:/var/taskd \
  -v ./vars:/var/taskd/pki/vars
  andir/taskd
```

Or with the docker configs storage: 
```sh
docker config create taskd_vars vars
docker run -d \
  --name=taskd \
  -p 53589:53589 \
  -v /srv/taskd:/var/taskd \
  --config source=taskd_vars,target=/var/taskd/pki/vars,mode=0440
  andir/taskd
```
