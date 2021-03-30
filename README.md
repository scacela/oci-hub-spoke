# oci-hub-spoke
## Deploy and manage the network and compute layers of a hub-spoke topology using Terraform

### Workshop Prerequisites
- Access to an OCI Tenancy (account)
- OCI Policies:
<pre>
Allow group GROUPNAME to manage instance-family in compartment COMPARTMENTNAME
Allow group GROUPNAME to manage virtual-network-family in compartment COMPARTMENTNAME
Allow group GROUPNAME to read app-catalog-listing in tenancy
</pre>
- Sufficient availability of resources. You can check resource availability:
<pre>
Hamburger Menu &gt Governance &gt Limits, Quotas and Usage
</pre>

### Deployment via Resource Manager
1. Navigate to <a href="https://cloud.oracle.com/" target="_blank">cloud.oracle.com</a> on a web browser.
2. Sign into OCI
3. Click the hamburger icon
4. Hover over 'Resource Manager' from the dropdown menu, and click 'Stacks'
5. Under 'List Scope', Select the Compartment where you wish to create the stack
6. Click 'Create Stack'
7. On the 'Stack Information' page, under 'Stack Configuration', browse for and select the this project folder from your local machine.
8. Click 'Next'
9. On the 'Configure Variables' page, edit the variables that will influence the stack topology according to your preferences.
10. Click 'Next'
11. On the 'Review' page, review your choices for the stack deployment.
12. Click 'Create'
13. Click 'Terraform Actions' > 'Apply' > 'Apply'.
14. You can track the logs associated with the job by clicking Jobs > Logs. After the deployment has finished, review the output information at the bottom of the logs for instructions on how to access the nodes in the topology. You can also find outputs at Jobs > Outputs.

### Deployment via CLI Terraform



1. [Set up CLI Terraform on your local machine.](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformgetstarted.htm) 
2. Navigate to project folder on your local machine via CLI.
<pre>
cd YOUR_PATH/oci-hub-spoke
</pre>
3. Open env.sh and edit the variables of prefix 'TF_VAR_', which will influence the stack topology according to your preferences.
<pre>
vi env.sh
</pre>
4. Export the TF_VAR_ variables to the environment of the CLI instance.
<pre>
source env.sh
</pre>
5. Initialize your Terraform project, downloading necessary packages for the deployment
<pre>
terraform init
</pre>
6. View the plan of the Terraform deployment, and confirm that the changes described in the plan reflect the changes you wish to make in your OCI environment.
<pre>
terraform plan
</pre>
7. Apply the changes described in the plan, and answer yes when prompted for confirmation.
<pre>
terraform apply
</pre>
8. You can track the logs associated with the job by monitoring the output on the CLI. After the deployment has finished, review the output information at the bottom of the logs for instructions on how to access the nodes in the topology.