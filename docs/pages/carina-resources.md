---
title: "Carina Resources"
permalink: /carina-resources
customjs: /assets/js/tablesaw-init.js
toc: true
---



The Carina platform offers access to Stanford-managed compute resources for research projects using high-risk data.

The platform is designed for interactive data analytics and offers access to Stanford-managed high-memory servers and GPU-enabled servers.

Disaster recovery and long-term access to data are provided via a combination of on-premise and cloud archive solutions.

A typical suite of analytics tools such as Jupyter, R, Python, and SAS are available.

All available servers can also run traditional jobs through the Slurm scheduler.

Collaboration with other researchers within Stanford is controlled via [Stanford workgroups](https://workgroup.stanford.edu/).

The [On-Premise vs. Cloud](/prem-vs-cloud) page has some more detailed information about the differences between the Carina On-Prem and Nero GCP environments.

## Hardware Technical Specifications
<table class="tablesaw tablesaw-stack" data-tablesaw-mode="stack">
  <p class="text-secondary mb-0">Available to Everyone</p>
  <thead>
    <tr>
      <th scope="col" role="columnheader" data-tablesaw-priority="persist">Type</th>
      <th scope="col" role="columnheader">Quantity</th>
      <th scope="col" role="columnheader">Details</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">Login nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">2</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">&nbsp;</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">Compute nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">5</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6130 (16C 2.1GHz), 370 GB RAM</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">2</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6130 (16C 2.1GHz), 370 GB RAM,&nbsp;Dual P100 GPUs (16GB)</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">6</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Silver 4114 (10C 2.2GHz), 250 GB RAM, Quad NVIDIA Tesla V100</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">6</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6330 (56C 2GHz), 250 GB RAM, Quad NVIDIA A100</span></td>
    </tr>
  </tbody>
</table>

 <p class="text-secondary mb-0">Dedicated hardware, not available to everyone</p>
<table class="tablesaw tablesaw-stack" data-tablesaw-mode="stack">
  <thead>
    <tr>
      <th scope="col" role="columnheader" data-tablesaw-priority="persist">Type</th>
      <th scope="col" role="columnheader">Quantity</th>
      <th scope="col" role="columnheader">Details</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">Compute nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">1</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6330 (56C 2GHz), 190 GB RAM</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">2</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6330 (28C 2GHz), 450 GB RAM, Quad NVIDIA A100 (40GB)</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">1</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6330 (28C 2GHz), 450 GB RAM, Quad NVIDIA A100 (80GB)</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">1</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6226 (12C 2.7GHz), 1450 GB RAM, 8 NVIDIA Tesla V100 (32GB)</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">1</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Core Intel Xeon Gold 6258R (28C 2.7GHz), 700 GB RAM, 8 NVIDIA Tesla V100 (32GB)</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">GPU nodes</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">1</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Dual Intel Xeon Platinum 8480+ (56C 2GHz), 940 GB RAM, 8 NVIDIA H100 (80GB)</span></td>
    </tr>
  </tbody>
</table>

## Carina Facts
<table class="tablesaw tablesaw-stack" data-tablesaw-mode="stack">
  <thead>
    <tr>
      <th scope="col" role="columnheader" data-tablesaw-priority="persist">Type</th>
      <th scope="col" role="columnheader">Quantity</th>
      <th scope="col" role="columnheader">Details</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">OS</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">&nbsp;</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">Ubuntu 20.04</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">Total Cores</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">1,264</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">across 6 CPU models</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">Total GPUs</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">88</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">across 5 GPU models</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">Ethernet Switches</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">9</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">&nbsp;</span></td>
    </tr>
    <tr>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Type</strong> <span class="tablesaw-cell-content">Storage</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Quantity</strong> <span class="tablesaw-cell-content">4.5PB</span></td>
      <td><strong class="tablesaw-cell-label" aria-hidden="true">Details</strong> <span class="tablesaw-cell-content">research data storage</span></td>
    </tr>
  </tbody>
</table>

## Requesting a Carina On-Premise Project

1. Take a look at the [Carina versus Nero GCP](/prem-vs-cloud.html) cheat sheet to identify whether you need an on-premise solution, a cloud solution or both.

2. Request a Carina project using this [Carina Request Form](https://stanford.service-now.com/it_services%EF%B9%96id=sc_cat_item&sys_id=4d60831e1bacd010685d4377cc4bcb26.html). Carina projects are exclusively designed for projects using high-risk data. Per Stanford University's guidance, a Data Risk Assessment may be required as part of your work with high-risk data. Find out more [here](https://uit.stanford.edu/security/dra.html).

3. Wait for an email notification confirming your Carina resources are ready.
