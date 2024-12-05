# Transfer Files from Azure Storage to FTP Server

In this repository, I'll teach you how to migrate files from Azure Storage to an FTP server. This approach is based on a real-world scenario I encountered at one of the companies I worked for. Azure storage costs were becoming a concern, and since we weren’t utilizing it for highly professional workflows, we decided to transfer files to our on-premises server using FTP.

---

## Scenario

In this project:
1. **Azure Usage**: Files are stored in Azure Storage, and each file's path is saved in our database.
2. **File Paths**: We store a `file_path` (the relative path in Azure) for each file.
3. **Download Method**: Instead of using SDKs or advanced APIs, we use static URLs for simplicity.
4. **CSV File**: We export the `file_path` and corresponding static URLs into a CSV file.
5. **Automation**: A Bash script parses the CSV file, downloads files from Azure, and uploads them directly to the FTP server using `lftp`.

---

## Accessing Azure Files with Static URLs

To generate static URLs for accessing your Azure Storage files, you can use a **Shared Access Signature (SAS)**. Here’s how to create and implement it:

### Steps to Create a SAS Token:
1. **Go to Azure Storage Account**:
   - Navigate to the Azure portal and select your storage account.

2. **Open the "Shared Access Signature" Page**:
   - Under the **Security + networking** section, click **Shared access signature**.

3. **Set Permissions**:
   - Select the required permissions (e.g., **Read**, **Write**, **List**, etc.).
   - Set a start and expiry date/time.

4. **Generate the SAS Token**:
   - Click **Generate SAS and connection string**. Copy the **SAS Token** provided.

### Implement the SAS Token in a Static URL:
To create a static URL for your file, append the SAS token to your blob's base URL in this format:

`https://<storage_account>.blob.core.windows.net/<container_name>/<file_path>?<SAS_token>`
For example:
`https://example.blob.core.windows.net/documents/employee/report.pdf?sp=racw&st=2024-02-25T10:02:34Z&se=2027-12-31T18:02:34Z&spr=https&sv=2022-11-02&sr=c&sig=YOUR_GENERATED_SIGNATURE`
Replace:
- `<storage_account>` with your Azure storage account name.
- `<container_name>` with the container where your file is stored.
- `<file_path>` with the path to your file.
- `<SAS_token>` with the SAS token you generated.
---

## How It Works

1. Export file paths and their corresponding static URLs to a CSV file.
2. Use the Bash script to:
   - Parse the CSV file.
   - Download the files from Azure Storage using `curl`.
   - Upload the files to the FTP server using `lftp` with FTP credentials.

---

## Getting Started

### Prerequisites
- **Bash**: Ensure your system supports Bash scripting.
- **lftp**: Install `lftp` for FTP uploads.
  ```bash
  sudo apt install lftp
  ```
  - **curl**: For downloading files from Azure.

### Instructions

1. **Clone the Repository**  
   Clone the repository to your local machine.  
   ```bash
   git clone https://github.com/your-username/azure-to-ftp-file-migration.git
   cd azure-to-ftp-file-migration
   ```
2. **Prepare the CSV File**  
   - Create a CSV file with two columns: `file_path` and `url`.
   - Ensure each row contains the file's Azure path and its static URL with a valid SAS token.

3. **Run the Script**  
   Execute the Bash script to parse the CSV file, download files, and upload them to the FTP server:  
   `./transfer-files.sh`

4. **FTP Credentials**  
   Make sure you update the FTP credentials in the script. The script uses `lftp` to upload the files, so ensure the following parameters are set:
   - FTP host
   - FTP username
   - FTP password

5. **Logs and Monitoring**  
   The script will generate logs during the process. Make sure to monitor the output to ensure everything is running smoothly. Logs will display success or failure messages for each file transfer.


**License**

This project is licensed under the MIT License.
