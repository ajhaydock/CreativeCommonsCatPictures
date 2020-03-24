# GitOps Workflow: GitLab CI --> Terraform --> Ansible --> Docker
This is a GitOps-style workflow for deploying the DWK server with DoH, Pi-Hole and a WireGuard VPN.

This is the actual code I use to deploy the site, but mildly sanitised (I'm working on eliminating the bad practices such as secrets being stored in CI logs).

### Variables that need exporting in GitLab CI settings
* `AWS_ACCESS_KEY_ID`
* `AWS_DEFAULT_REGION`
* `AWS_SECRET_ACCESS_KEY`
* `CLOUDFLARE_EMAIL`
* `CLOUDFLARE_API_KEY`
* `GITLAB_TOKEN` = Generate an API token with GitLab's settings so we can post comments on the Merge Request
* `TFCLOUD_API_KEY` = Terraform Cloud API key

### Files that need creating in this directory before running
* `id_rsa_AWS` - AWS private SSH key.
* `id_rsa_AWS.pub` - AWS public SSH key.

### Notes
* Create an empty `master` branch before adding the new branch and pushing files to it, otherwise there's no `master` branch created for us to create a merge request for!
* Change the settings in GitLab to stop anyone from pushing to `master`.
  * After the first commit, go to `Settings` > `Repository` > `Branches` > and set `"Allowed to push"` to `"No One"`
* In order to avoid issue where Terraform refuses to use the `-out` flag to produce a local plan, make sure the workspace's `Execution Mode` on Terraform Cloud is set to `Local` and not `Remote`
  * This means that Terraform will store the **state** remotely in Terraform Cloud, but it will not perform the whole execution process remotely.
* Do not "Protect" vital variables in GitLab CI. This means they'll only be exported for protected branches (i.e. `master`).
