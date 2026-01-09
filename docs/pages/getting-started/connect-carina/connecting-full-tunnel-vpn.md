---
title: "Connecting to the full-tunnel VPN"
permalink: /carina-resources/connect-carina/connecting-full-tunnel-vpn
toc: true
---

## Main navigation

Connecting to the full-tunnel Stanford VPN is a necessary requirement for accessing Carina resources. Whether our clients are connecting from Stanford campus or from remote locations, the full-tunnel Stanford VPN is necessary to access the Carina environment.

Step 1 - Install the Stanford VPN

If not already done, please download the VPN client by connecting to the following page: [https://uit.stanford.edu/service/vpn](https://uit.stanford.edu/service/vpn.html)

Step 2 - Access the VPN client application

The Cisco VPN client can be accessed within the list of applications installed on a given computer or server by clicking on this icon:

Step 3 - Set up your VPN connection

Without Cardinal Key

a. Enter "su-vpn.stanford.edu"as shown below:

b. Click on "Connect".

c. On the drop-down menu for Group, select the option "Full Traffic non-split tunnel" and enter your sunet ID username and password.

d. Click on OK and enter the option that generates a duo-push notification, as shown below:

e. Click on Continue and accept the duo-push notification on your mobile device.

With [Cardinal Key](https://uit.stanford.edu/service/cardinalkey.html#section--get-started)

a. Enter "su-vpn.stanford.edu"as shown below:

b. Click on "Connect".

c. On the drop-down menu for Group, select the option "CardinalKey - FullTraffic". Click "OK".

Step 4 - Confirm that you are on the full-tunnel Stanford VPN

Confirm that you are on the full-tunnel Stanford VPN by opening an internet browser and typing "what is my ip".The result should show something that starts with 171.x. If, instead, you get a result that is formatted like this 2001:0db8:85a3:0000:0000:8a2e:0370:7334, you need to disable IPv6 on your laptop. This new IP address format is not currently supported by the Cisco VPN client. Keep reading to disable IPv6.

Step 5 - Disable IPv6

If you are using a Mac

a. Click on "System Preferences"

b. Click on "Network"

c. Select Wi-fi and click on "Advanced"

d. Select TC/IP and on the option "Configure IPv6" select "Link-local only". Click "OK" when done.

e. Repeat Step 4 above and confirm that your IP starts with "171.x".

If you are using a Windows machine

Follow these [instructions](https://answers.uillinois.edu/uis/page.php%EF%B9%96id=99981.html).
