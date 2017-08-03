# Gitlab Alpine

# Introduction

Dockerfile to build a [GitLab](https://about.gitlab.com/) image for the [Docker](https://www.docker.com/products/docker-engine) opensource container platform.

GitLab CE is set up in the Docker image using the [install from source](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md) method as documented in the the official GitLab documentation.

For other methods to install GitLab please refer to the [Official GitLab Installation Guide](https://about.gitlab.com/installation/) which includes a [GitLab image for Docker](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/docker).

Build the application using the following command
```
docker-compose -f docker-compose.yml up -d --build
```

## License and Support
### Apache 2.0 License
[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)  

This code is released into the public domain by [Guillem Hernández Sola](https://www.linkedin.com/in/guillemhernandezsola/) under [![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)  

This README file was originally written by [Guillem Hernández Sola](https://www.linkedin.com/in/guillemhernandezsola/) and is likewise released into the public domain.

Please contact [Guillem Hernández Sola](https://www.linkedin.com/in/guillemhernandezsola/) for further details.
