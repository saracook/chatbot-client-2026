---
title: "Data Migration"
permalink: /migrate
toc: true
---
You are responsible for migrating any desired files in your personal $HOME directory from Carina 1.0 to Carina 2.0. 

There is no direct connection between the two systems, so you will need to download your files from Carina 1.0 and upload them to Carina 2.0. We recommend using your secure Stanford laptop as the intermediary. 


To move files between your home directory on Carina, your Stanford laptop, and Carina 2.0 using `rclone`, follow the instructions below. 

On Carina 1.0

`ml rclone`

```bash
   ml rclone
   rclone config
   ```




### Instructions

#### Step 1: Configure Rclone

Before moving files, you need to set up `rclone` on both systems.

install: https://rclone.org/downloads/

ml rclone

1. **On Carina**:
   Open a terminal and run:

   ```bash
   rclone config
   ```


Run rclone config in your terminal.
Create a new remote (e.g., n) and choose alias as the type.
Set the alias name (e.g., localfolder).
Specify the remote path (e.g., /home/user/mydata or C:\Users\User\MyData).
Use it: rclone copy localfolder: /backup/ or rclone ls localfolder:. 


   Follow these steps:
   - Choose `n` to create a new remote.
   - Provide a name (e.g., `carina_remote`).
   - For the storage type, select `Local`.
   - Set the path to your home directory on Carina (e.g., `/home/users/your_username`).
   - Complete the configuration by following any additional prompts.

2. **On Stanford Laptop**:
   Similarly, run `rclone config` and set up a remote for the location where you want to store files on your laptop:

   ```bash
   rclone config
   ```

   Follow the same steps as above, providing appropriate names and paths (e.g., `laptop_remote` pointing to your Documents folder).

#### Step 2: Move Files from Carina to Stanford Laptop

1. **Open a terminal** on Carina.
2. Use the following `rclone` command to transfer files from Carina to your Stanford laptop:

   ```bash
   rclone sync carina_remote: laptop_remote:/path/to/destination/
   ```

   Replace:
   - `laptop_remote:/path/to/destination/` with the destination path on your Stanford laptop, e.g., `laptop_remote:/home/your_laptop_username/Documents/`.

### Step 3: Move Files from Stanford Laptop Back to Carina 2.0

1. **Open a terminal** on your Stanford laptop.
2. Use the following `rclone` command to transfer files back to Carina 2.0:

   ```bash
   rclone sync laptop_remote:/path/to/source/ carina_remote:@carina2_ip:/home/users/your_username/
   ```

   Replace:
   - `laptop_remote:/path/to/source/` with the path to the files you want to move on your Stanford laptop (e.g., `laptop_remote:/home/your_laptop_username/Documents/`).
   - `@carina2_ip` with your username and the IP address or hostname of your Carina 2.0.

### Common rclone Options
- `sync`: Syncs files between the source and destination, making the destination mirror the source. Use with caution.
- `copy`: Copies files from source to destination without removing files in the destination that do not exist in the source, useful for backup.
- `-v` or `--verbose`: Provides more details during the transfer process.

### Example Commands
Here are the example commands for better clarity:

1. From Carina to Stanford Laptop:

   ```bash
   rclone sync carina_remote: laptop_remote:/home/johndoe/Documents/
   ```

2. From Stanford Laptop to Carina 2.0:

   ```bash
   rclone sync laptop_remote:/home/johndoe/Documents/ carina_remote:@carina2_ip:/home/users/johndoe/
   ```

### Verification
After the transfers, you can verify the files by checking their existence and comparing sizes on both systems.

### Notes
- You may need to set up SSH key access for `rclone` to authenticate automatically, which can simplify the process.
- If you encounter permission issues, ensure that you have the appropriate access rights for the files and directories involved.
- Use `dry run` mode with `rclone` to test your command without making any changes. For example, add `--dry-run` at the end of your command:
  
  ```bash
  rclone sync carina_remote: laptop_remote:/home/johndoe/Documents/ --dry-run
  ```

This guide should help you transfer files using `rclone` effectively between Carina, your Stanford laptop, and Carina 2.0!
