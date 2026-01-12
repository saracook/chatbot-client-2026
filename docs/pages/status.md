---
status: "maint"
title: "Carina Status"
permalink: /status
toc: false
customjs: "/assets/js/maintenancedate.js"
---

{% comment %} status is one of: up/maint/down {% endcomment %}
<div class="row g-5">
    <div class="col-sm-12 col-md-8 mb-4">
{% include photo-card.html
  file="/assets/images/carina-nebula.png"
  alt="The Carina Nebula"
  status = page.status
  title=""
  text=""
  class="shadow-lg"
%}

{% if page.status != "up" %}
<p class="my-4 h3">Follow <a href="https://stanford.enterprise.slack.com/archives/C041U1025MX">#carina-users</a> on Slack for the latest updates.</p>
{% endif %}

</div>
    <div class="col-sm-12 col-md-4">
        {% include next-maint.html %}
    </div>
</div>

<div class="row">
    <div class="col-12 border-top py-4 my-4">

        <h2>Scheduled Maintenance</h2>

        Carina's maintenance happens on the 4th Tuesday of every month.

        Carina will be offline on maintenance day. Users will not be able to log in or connect to Carina.

        Slurm will pause the job queue during the downtime and resume when the environment is back online. Jobs will not be interrupted or deleted.
    </div>

</div>