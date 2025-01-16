# Simple Infra Components

## Overview

This is a collection of AWS specific components focused on helping beginners, 'solopreneurs', and small teams deploy infrastructure quickly and with as few headaches as possible. Much of the code is inspired by Cloud Posse's [terraform-aws-modules](https://github.com/terraform-aws-modules/terraform-aws-modules), and relies on their terraform modules. This project expands on the modules and tries to provide a "batteries included" experience for users wanting to application services.

All software makes trade-offs, including this project. This project has intentionally made the following trade-offs:

- Keep it explicitly simple.
- Convention over configuration.
- Use sane defaults that help individuals ship projects (batteries included).

## Components

Each component is a terraform module that can be deployed independently and has it's own README + docs.

- [x] [ECR](./ecr)
- [x] [Lambda - Docker](./lambda)
- [x] [Lambda - Docker Eventbridge](./lambda_docker_eventbridge)
- [ ] Lambda Api Gateway
- [ ] SQS
- [ ] Lambda Api SQS
- [ ] AWS System use for Github Actions

## License

This project is licensed under the [BSD-3](./LICENSE) license.

## Contributing

Contributions are welcome! Please feel free to submit a PR.
