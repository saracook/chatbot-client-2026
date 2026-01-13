---
title: "Launching Apps in Carina OnDemand"
permalink: /ood-apps
folder: "getting-started"
seealso: true
toc: true
---

Carina OnDemand lets you run interactive applications directly on the cluster's powerful hardware via a web browser. 

{% include note.html content="Interactive applications are only available on the dev partition, with a twohour time limit." %}

### The 4-Step Launch Process

Getting started is simple and follows the same pattern for any app:

1.  **Choose Your App:** From the top menu, click **Interactive Apps** and select the tool you want, such as **JupyterLab** or **RStudio Server**, or select an application icon on the dashboard.

2.  **Configure Your Session:** A form will appear asking for the resources you need. Tell Carina how much time, CPU power, and memory your session requires. (More on this below!)

3.  **Launch:** Click the form's blue **Launch** button. OnDemand will submit your request to the cluster scheduler.

4.  **Connect:** Your session will appear in the "My Interactive Sessions" list and on the dashboard. Once the cluster assigns resources, the card will turn green. Just click **Connect** to open your app in a new tab!


### Understanding the Session Request Form

When you launch an app, you're asking the cluster for a dedicated slice of its resources. Here’s what the most common options mean:

{% include image.html file="/assets/images/ood-form.png" alt="Open OnDemand Form for JupyterLab"  class="mb-5 p-4 border border-dark-subtle"  %} 

*   **Size:** Choose the resources you need based on your compute needs. Our pre-defined sizes offer the right balance of cores and memory, and keep the resource requests tidy.
*   **GPU:** If your work requires a GPU, you can request one here. *Note: GPU nodes are a limited resource.*
*   **Time Limit:** How long you want your session to be active. Your session will automatically close when this time is up. Two hours is the time limit.
*   **Email Notification:** Carina can send you an email when your session starts. This is especially useful if you are requesting a lot of resources and expect to be in the queue for a while.

**Pro-Tip:** Always request only the resources you truly need. This helps your session start faster and leaves resources available for other users.

### Managing Active Sessions

All your running, pending, and finished apps appear on the **My Interactive Sessions** page. 

For an active or starting session, you can:

{% include image.html file="/assets/images/ood-running.png" alt="Open OnDemand Session for JupyterLab"  class="mb-5 p-4 border border-dark-subtle"  %} 

*   **See the Status:** Quickly check if your session is starting, running, or finished.
*   **View Details:** See how much time is left and what resources you requested.
*   **Connect:** Reconnect to any active session.
*   **Stop a Session:** If you finish before the your requested time, click the **cancel** button to end your session and free up the resources for others. 

For a finished session, you can:

{% include image.html file="/assets/images/ood-finished.png" alt="Finished Open OnDemand Session for JupyterLab"  class="mb-5 p-4 border border-dark-subtle"  %} 

*   **Repeat the session:** The circled buttons will:
<ul class="m-2 ps-3 list-unstyled">
  <li><i class="fa-solid fa-pencil"></i> open a new form for the app with this session's attributes pre-filled</li>
  <li><i class="fa-solid fa-arrows-rotate"></i> launch a session with the same attributes as the finished one.</li>
</ul>
*   **See output:** click on the Session ID to see files that were created by this session

{% include image.html file="/assets/images/ood-app-output.png" alt="Files from Open OnDemand Session for JupyterLab"  class="mb-5 p-4 border border-dark-subtle"  %} 

*   **Open a Support Ticket:** Clicking on the support ticket link from a session adds the session data to the ticket and helps the Carina team troubleshoot your issue.
*   **Delete:** The session card says when it will be automatically deleted, but you can remove uninteresting sessions from the list yourself with the **delete** button.
