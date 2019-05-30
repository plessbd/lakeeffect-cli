# LakeEffect OpenStack cli

This docker image is specifically for use on the UB CCR LakeEffect Cloud.
This is an alternative to using the python environment as explained on the [UB Help page][ub-le-cli]

You will still need to use that link to set up your API Key (start from step 2)

## Manual Build
Clone this repository, then:

```bash
# Build a local docker image
docker build -t plessbd/lakeeffect-cli .
```

## Docker Hub

```bash
docker pull plessbd/lakeeffect-cli
```

## Configuration

After building or pulling from docker hub you will need to create a env file.
A sample can be found in envfile.sample

```bash
OS_PROJECT_NAME='your project name'
OS_USERNAME='your username'
OS_API_KEY='your API key'
```

If you work with multiple projects

### Set your token (makes things faster)
By default this will always try to get a new token, this is not the best thing to do.
So the following will set your token and reuse it.

**NOTE: If you get errors after a while you can rerun the `refresh token` command and replace it in the `envfile`**

**NOTE: the following commands assume you have a scratch sub directory**

```bash
docker run -it --rm -v $(pwd)/scratch:/scratch --env-file envfile plessbd/lakeeffect-cli refresh token
echo "OS_TOKEN='"`cat scratch/OS_TOKEN`"'" >> envfile
```
If you don't want to set this in your env file, and you always mount /scratch as long as there is a file called OS_TOKEN in there it will use that.  So use as you please.

## Running commands

Run one off commands using:

```bash
docker run -it --rm --env-file envfile plessbd/lakeeffect-cli openstack server list
```

If you are going to have to run multiple commands just drop into the shell
```bash
docker -h 'le-os' run -ti --rm --env-file envfile plessbd/lakeeffect-cli
```

### Simplify your typing with aliases
```bash
# Get into a shell to run openstack commands
alias leshell='docker run -it --rm -v $(pwd):/scratch --env-file $(pwd)/envfile plessbd/lakeeffect-cli'
# Make it look like you're running openstack locally
alias lakeeffect='leshell openstack'
```

## Inspiration
[jmcvea][]

[jmcvea]: https://github.com/jmcvea/docker-openstack-client
[ub-le-cli]: https://ubccr.freshdesk.com/support/solutions/articles/13000044362-setting-up-openstack-cli-tools
