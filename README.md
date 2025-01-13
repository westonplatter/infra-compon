# Simple Infra Components

## Overview

This is a collection of AWS specific components focused on helping
beginners, solopreneurs, and small teams deploy infrastructure quickly
and with as few headaches as possible.

All software makes trade-offs, and this project is no exception. I/We
have intentionally made the following trade-offs:

- Keep it dead simple. If you need more, use other open source modules.
- Convention over configuration.
- Use sane defaults for that work for individuals to ship projects. Ie, batteries included.

Much of the code is inspired by Cloud Posse's
[terraform-aws-modules](https://github.com/terraform-aws-modules/terraform-aws-modules),
and pulls in their terraform modules. This repo/project differs from Cloud Posse's
approach by providing opinionated defaults to help get things going for
those who are just starting out.

## Components

Each component is a terraform module that can be deployed independently and has it's own README + docs.

- [x] [ECR](./ecr)
- [x] [Lambda](./lambda)
- [x] [Lambda Eventbridge](./lambda_eventbridge)
- [ ] Lambda Api Gateway
- [ ] SQS
- [ ] Lambda Api SQS
- [ ] AWS System use for Github Actions

## License

This project is licensed under the [BSD-3](./LICENSE) license.
