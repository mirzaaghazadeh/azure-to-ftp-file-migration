# Transfer Files from Azure Storage to FTP Server

In this repository, I'll teach you how to migrate files from Azure Storage to an FTP server. This approach is based on a real-world scenario I encountered at one of the companies I worked for. Azure storage costs were becoming a concern, and since we weren’t utilizing it for highly professional workflows, we decided to transfer files to our on-premises server using FTP.

---

## Scenario

In this project:
1. **Azure Usage**: Files are stored in Azure Storage, and each file's path is saved in our database.
2. **File Paths**: We store a `file_path` (the relative path in Azure) for each file in the database.
3. **Download Method**: Instead of using SDKs or complex APIs, we use static URLs with Shared Access Signatures (SAS) for simplicity and security.
4. **CSV File**: We export the `file_path` and corresponding static URLs (with SAS tokens) into a CSV file for easy reference.
5. **Automation**: A Bash script is used to parse the CSV file, download files from Azure using the static URLs, and upload them directly to the FTP server using `lftp`.

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

1. **Export file paths and their corresponding static URLs to a CSV file**.  
   The CSV file should contain two columns:
   - The first column (`file_path`) represents the relative path of the file in Azure Storage.
   - The second column (`url`) contains the static URL for each file, which includes the Shared Access Signature (SAS) token.

   Example of the CSV file format:
   ```csv
   file_path,url
   documents/navid/filename.pdf,https://yourstorageaccount.blob.core.windows.net/container/documents/navid/filename.pdf?sp=racw&st=2024-02-25T10:02:34Z&se=2027-12-31T18:02:34Z&spr=https&sv=2022-11-02&sr=c&sig=EXAMPLE_SIGNATURE
   documents/amir/report.pdf,https://yourstorageaccount.blob.core.windows.net/container/documents/amir/report.pdf?sp=racw&st=2024-02-25T10:02:34Z&se=2027-12-31T18:02:34Z&spr=https&sv=2022-11-02&sr=c&sig=EXAMPLE_SIGNATURE
   ```

2. **Use the Bash script to:**
    Parse the CSV file.
    Download the files from Azure Storage using curl.
    Upload the files to the FTP server using lftp with FTP credentials.
   
---

## Getting Started

### Prerequisites
- **Bash**: Ensure your system supports Bash scripting.
- **lftp**: Install `lftp` for FTP uploads.
  ```bash
  sudo apt install lftp
  ```
- **curl**: For downloading files from Azure.

### Creating CSV File
To create the CSV file for this script, follow these general steps:

1. **Database Query**: In your PHP application, query the database to retrieve all the file paths you need for downloading. This assumes that you have a table in your database where each file has a corresponding path stored.

2. **Generate Static URLs**: For each file path in the database, generate a static URL pointing to the file's location on the server or the location where it can be accessed for download. For example, if the file is stored on Azure or another cloud service, create a URL that allows public access or direct download.

3. **CSV Format**: The CSV file should consist of two columns:
        File Path: The local file path where the file should be saved after download (e.g., /home/user/files/test/file.txt).
        URL: The corresponding URL where the file can be downloaded from (e.g., https://example.com/files/test/file.txt).

4. **CSV Creation in PHP**: Once you have all the data (file paths and URLs), write a PHP script that generates a CSV file by combining these two pieces of information. You can use PHP's fputcsv function to create the CSV file, ensuring the values are properly formatted.

5. **Save the CSV File**: Save the CSV file locally on your server, and ensure that it is in the correct location so that the Bash script can read it.

By following these steps, you will generate a CSV file that the Bash script can then use to download files and upload them to the FTP server. The CSV will serve as a data source containing both the file paths and download URLs needed for the process.

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

   Example FTP configuration in the script:

   ```bash
   csv_file="file_data.csv"

   # FTP credentials and server information
   ftp_user="username"
   ftp_pass="password"
   ftp_host="ip-or-domain"
   ftp_remote_prefix=""  # The prefix for the remote directory , It can be empty
   ```
Update the `ftp_user`, `ftp_pass`, `ftp_host`, and `ftp_remote_prefix` with your actual FTP details.

5. **Logs and Monitoring**  
   The script will generate logs during the process. Make sure to monitor the output to ensure everything is running smoothly. Logs will display success or failure messages for each file transfer.


**License**

This project is licensed under the MIT License.
