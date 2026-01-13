---
title: "Carina vs. Nero GCP"
permalink: /prem-vs-cloud
toc: false
---

Carina is Stanford University’s on-prem computing environment for [high-risk data](https://uit.stanford.edu/guide/riskclassifications). [Carina](/carina-facts.html) leverages the Stanford Research Computing private cloud. 

The Nero GCP environment is Stanford's cloud service for high risk data, built on Google Cloud Platform.

Please take a look at our overview of services below. Our team remains available via email at [srcc-support@stanford.edu(link sends email)](mailto:srcc-support@stanford.edu) and via [office hours](/office-hours).

<table class="horizontal-border tablesaw tablesaw-stack" data-tablesaw-mode="stack">
  <thead>
    <tr>
      <th scope="col" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="1">&nbsp;</th>
      <th class="text-align-center" scope="col" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="2">
        {% include image.html file="/assets/images/carina-logo.png" alt="Carina" class="mx-3" max-width = 200 %}
      </th>
      <th class="text-align-center" scope="col" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="3">
      {% include image.html file="/assets/images/gcp-logo.png" alt="Nero GCP" class="mx-3" max-width= 200 caption= "Nero GCP" caption-class="text-center" %}
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="5">
        <p class="su-intro-text"><strong>Pre-Requisites</strong></p>
      </th>
      <td class="vertical-align-top">
        <ul>
          <li>Project led by a Stanford PI</li>
          <li>Users must have a full Stanford affiliation</li>
          <li>Completed Data Risk Assessment</li>
        </ul>
      </td>
      <td class="vertical-align-top">
        <ul>
          <li>Project led by a Stanford PI</li>
          <li>Users must have a full Stanford affiliation</li>
          <li>Completed Data Risk Assessment</li>
          <li>A valid PTA</li>
        </ul>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="6">
        <p class="su-intro-text"><strong>Application and Services</strong></p>
      </th>
      <td class="vertical-align-top">
        <ul>
          <li>
            <p class="plain-text">Slurm</p>
          </li>
          <li>
            <p class="plain-text">Open OnDemand</p>
          </li>
          <li>
            <p class="plain-text">NoVNC</p>
          </li>
        </ul>
      </td>
      <td class="vertical-align-top">
        <ul>
          <li>
            <p class="plain-text">JuypterHub</p>
          </li>
          <li>
            <p class="plain-text">Native <a href="https://cloud.google.com/products" class="ext su-link--external" data-extlink="">Google Cloud services</a> like BigQuery, Compute, Storage, Vertex AI, Kubernetes Engine, etc.&nbsp;</p>
          </li>
        </ul>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="7">
        <p class="su-intro-text"><strong>Analytical Tools</strong></p>
      </th>
      <td class="vertical-align-top" colspan="2" data-tablesaw-maxcolspan="2">
        <p class="plain-text">No difference between Carina and Nero GCP.</p>
        <dl><dt>
            <p>Analytical software:</p>
          </dt>
          <dd>
            <p>Python, R, RStudio, SAS, Stata (with proof of existing license)</p>
          </dd><dt>
            <p>Package management tools:</p>
          </dt>
          <dd>
            <p>Anaconda (Python and R), Pip (Python), Lmod</p>
          </dd><dt>
            <p>Source code management tools:</p>
          </dt>
          <dd>
            <p>GitLab</p>
          </dd>
        </dl>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="8">
        <p class="su-intro-text"><strong>Application Access Methods</strong></p>
      </th>
      <td class="vertical-align-top">
        <p class="plain-text"><strong>SSH:</strong> Slurm</p>
        <p class="plain-text"><strong>Interactive: </strong>Open OnDemand, NoVNC</p>
      </td>
      <td class="vertical-align-top">
        <p><strong>SSH:</strong> Command Line Interface</p>
        <p><strong>Interactive:&nbsp;</strong>JupyterHub, GCP console, or gcloud command to native GCP services</p>
        <p><strong>Programmatic</strong>:&nbsp;Restful APIs and Client lib for native GCP Services&nbsp;</p>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="9">
        <p class="su-intro-text"><strong>Storage</strong></p>
      </th>
      <td class="vertical-align-top">
        <p><strong>Storage Type:&nbsp;</strong>File system</p>
        <p><strong>Base Allocation:</strong>&nbsp;&nbsp;<br>Home Directory: 25 GB<br>/home/$SUNETID</p>
        <p>Shared Project Directory: 1 TB<br>/share/pi/$PROJECT_ID</p>
        <p>Additional storage may be purchased in 10TB units at a rate of $97.50/month.</p>
      </td>
      <td class="vertical-align-top">
        <p><strong>Storage Type:</strong>&nbsp;Object Storage (GCS), File system (Filestore), Data warehouse (BigQuery), and RDBMS (Cloud SQL)</p>
        <p><strong>Base Allocation:</strong>&nbsp;($) Unlimited, cost quotas can be set up based on user preference.</p>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="10">
        <p class="su-intro-text"><strong>Data Transfer Methods</strong></p>
      </th>
      <td class="vertical-align-top">
        <p><strong>SFTP (Secure File Transfer Protocol):&nbsp;</strong></p>
        <ul>
          <li>Cyberduck (interactive), SFTP command (Terminal)</li>
        </ul>
        <p><strong>Rsync/rclone</strong></p>
        <p><strong>gsutil rsync and gsutil cp:</strong></p>
        <ul>
          <li class="plain-text">Command line utility, move data between Carina and Nero.</li>
        </ul>
      </td>
      <td class="vertical-align-top">
        Move data between Carina and Nero GCP, and between Nero GCP and other cloud systems such as AWS.
        <h4 class="my-3">gsutil rsync and gsutil cp:</h4>
        <ul>
          <li>Command line utility for medium and small (&lt;1TB) transfers</li>
        </ul>
        <p><strong>TSOP (</strong><a href="https://cloud.google.com/storage-transfer-service" class="ext su-link--external" data-extlink=""><strong>Storage Transfer Service</strong></a><strong>):</strong></p>
        <ul>
          <li>Managed service, move data from on-prem to GCS, AWS to GCS, GCS to GCS, and file-system to file-system.</li>
          <li>Handles large volume transfer (&gt;1TB) smoothly</li>
        </ul>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="11">
        <p class="su-intro-text"><strong>Compute Options</strong></p>
      </th>
      <td class="vertical-align-top">
        <p><a href="https://carinadocs.sites.stanford.edu/carina-premise-resources" class="ext su-link--external" data-extlink=""><strong>Login node</strong></a><strong>: 1</strong></p>
        <p><a href="https://carinadocs.sites.stanford.edu/carina-premise-resources" class="ext su-link--external" data-extlink=""><strong>Compute nodes</strong></a><strong>: 16 - </strong>Dual Core Intel Xeon Gold 6130 (16C 2.1GHz),&nbsp;</p>
        <p>384 GB RAM</p>
        <p><a href="https://carinadocs.sites.stanford.edu/carina-premise-resources" class="ext su-link--external" data-extlink=""><strong>GPU nodes</strong></a><strong>: 14</strong>&nbsp;- (2) Dual Core Intel Xeon Gold 6130 (16C 2.1GHz),&nbsp;384 GB RAM + Dual P100 GPUs</p>
        <p>(6) Dual Intel Xeon Silver 4114 (10C 2.2GHz), 256 GB RAM, Quad NVIDIA Tesla V100</p>
        <p>(6)&nbsp;Dual Core Intel Xeon Gold 6330 (28C 2GHz), 512 GB RAM, Quad NVIDIA A100 (40GB)</p>
        <p><a href="https://carinadocs.sites.stanford.edu/carina-premise-resources" class="ext su-link--external" data-extlink=""><strong>OS</strong></a><strong> - Ubuntu 20.04</strong></p>
      </td>
      <td class="vertical-align-top">
        <p>($) <strong>Scalable depending on research needs and budget</strong></p>
        <ul>
          <li><a href="https://cloud.google.com/custom-machine-types" class="ext su-link--external" data-extlink="">Custom machine</a> size to meet research needs.</li>
          <li>A large variety of <a href="https://cloud.google.com/compute/docs/machine-types" class="ext su-link--external" data-extlink="">machine types</a> to choose from: general purpose, compute-optimized, memory-optimized, accelerated optimized.</li>
          <li><a href="https://cloud.google.com/compute/docs/gpus" class="ext su-link--external" data-extlink="">GPU</a>: A100, T4, V100, P100, P4, K80</li>
          <li><a href="https://cloud.google.com/tpu/docs/types-zones-tpu-vm" class="ext su-link--external" data-extlink="">TPU</a>: V2-8/512, V3-8/32<strong>&nbsp;</strong></li>
        </ul>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="12">
        <p class="su-intro-text"><strong>Security and Compliance</strong></p>
      </th>
      <td class="vertical-align-top">
        <ul>
          <li>Is compliant with <a href="https://minsec.stanford.edu/" class="ext su-link--external" data-extlink=""><strong>Stanford’s minimum security requirement for high-risk data</strong></a></li>
          <li>Is covered under<strong> Data Risk Assessment #1479</strong></li>
        </ul>
      </td>
      <td class="vertical-align-top">
        <ul>
          <li>Is compliant with<strong> </strong><a href="https://minsec.stanford.edu/" class="ext su-link--external" data-extlink=""><strong>Stanford’s minimum security requirement for high-risk data</strong></a></li>
          <li>Is covered under<strong> Data Risk Assessment #1479</strong></li>
          <li><strong>Certified</strong> Platform for <strong>High Risk Data</strong>, <strong>HIPAA Compliant</strong>, Covered under the Google-Stanford BAA. Please check out <a href="https://cloud.google.com/security/compliance/offerings" class="ext su-link--external" data-extlink=""><strong>GCP Compliance Resource Center</strong></a> for covered products and services.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="13">
        <p class="su-intro-text"><strong>What to Expect</strong></p>
      </th>
      <td class="vertical-align-top">
        <p><strong>Cost:&nbsp;</strong>Fully subsidized as of 2025</p>
        <p><strong>Experience:</strong></p>
        <ul>
          <li>Access to a shared cluster with a variety of compute options</li>
          <li>Compute experience offers interactive and SSH options, with job scheduler (via Slurm) available.</li>
        </ul>
      </td>
      <td class="vertical-align-top">
        <p><strong>Cost</strong>: Explicit GCP costs with negotiated discount, pass through to faculty via a Stanford Billing Account, called a PTA number.&nbsp;</p>
        <p><strong>Experience</strong>:</p>
        <ul>
          <li>Scalable</li>
          <li>Unified console to access a rich set of hardwares and services</li>
        </ul>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="14">
        <p class="su-intro-text"><strong>How to Get Started</strong></p>
      </th>
      <td class="vertical-align-top">
        <p><strong>High Level Steps:</strong></p>
        <ul>
          <li>Complete User prerequisites (DRA)</li>
          <li><a href="https://stanford.service-now.com/it_services?id=sc_cat_item&amp;sys_id=4d60831e1bacd010685d4377cc4bcb26" class="ext su-link--external" data-extlink="">Request a Carina On-prem account</a></li>
          <li>Connect to <a href="https://carinadocs.sites.stanford.edu/carina-premise-resources" class="ext su-link--external" data-extlink="">Carina On-Prem</a></li>
        </ul>
      </td>
      <td class="vertical-align-top">
        <p><strong>High Level Steps</strong>:</p>
        <ul>
          <li>Complete User prerequisites (DRA)</li>
          <li><a href="https://stanford.service-now.com/it_services?id=sc_cat_item&amp;sys_id=8966bdf0132bebc0f4573262f244b0d1" class="ext su-link--external" data-extlink="">Request a Nero GCP project</a></li>
          <li>Connect to your Nero GCP Project</li>
          <li>Access your application and native GCP Services</li>
        </ul>
      </td>
    </tr>
    <tr>
      <th class="vertical-align-top" role="columnheader" data-tablesaw-sortable-col="" data-tablesaw-priority="15">
        <p class="su-intro-text"><strong>Support</strong></p>
      </th>
      <td class="vertical-align-top">
        <p><strong>Available Options:</strong></p>
        <ul>
          <li><a href="srcc-support@stanford.edu"><strong>SRC Team</strong></a>: account and environment provisioning, office hours for onboarding and troubleshooting</li>
          <li><a href="https://srcc.slack.com" class="ext su-link--external" data-extlink=""><strong>Stanford SRC Slack Channels</strong></a><strong>:</strong> #carina-announce, #carina-users</li>
        </ul>
      </td>
      <td class="vertical-align-top">
        <p><strong>Available Options:</strong></p>
        <ul>
          <li><a href="srcc-support@stanford.edu"><strong>SRC Team</strong></a>: project and environment provisioning, office hours for onboarding and troubleshooting</li>
          <li><a href="https://srcc.stanford.edu/support/slack" class="ext su-link--external" data-extlink=""><strong>Stanford SRCSlack Channels</strong></a>: #nero-announce, #nero-users</li>
          <li><a href="https://cloud.google.com/support/docs#contacting_technical_support" class="ext su-link--external" data-extlink=""><strong>GCP Technical Support</strong></a>: technical issue with GCP products and services, suggestions, feature request</li>
          <li><a href="stanford-gcp@google.com"><strong>GCP Account Team for Stanford</strong></a><strong>: </strong>architecture mapping, use case discussion, cost estimation, enablement, support ticket escalation, early access to new features,&nbsp; office hours.</li>
          <li><strong>GCP Slack Channel @Stanford</strong>: #googlecloudplatform</li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>
