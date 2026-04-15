# GitHub Config Backup for Home Assistant

This Home Assistant add-on provides a simple and secure way to apply version control to your configuration files using GitHub. 

Instead of creating a full system backup, this add-on focuses specifically on the files you manage yourself. Using a GitOps approach, you keep a clean history of your changes and can easily synchronize configurations across different systems.

## How it works

When the add-on is running, it performs the following steps:
1. **Initialization:** The add-on checks if the `/config` directory is already a Git repository. If not, it initializes one.
2. **Authentication:** It securely connects to GitHub using your Personal Access Token (PAT).
3. **Syncing (The Loop):** The add-on runs continuously in the background and performs a two-way sync on a set interval (e.g., every hour):
   - **Pull:** It first fetches new changes from GitHub and applies them to your local Home Assistant files.
   - **Check:** It then checks if there are any local modifications in your specified target files or directories.
4. **Commit & Push:** If local changes are detected, they are automatically committed with a timestamp and pushed to GitHub.

## Installation

Follow these steps to install and configure the add-on:

### 1. Preparation on GitHub
* **Create a Backup Repository:** Create a new repository on GitHub. **Ensure it is set to 'Private'** to protect your configuration data.
* **Generate a Token:** Go to *Settings > Developer Settings > Personal access tokens (Tokens (classic))* on GitHub. Create a token with the `repo` scope/permissions and save it securely.

### 2. Adding the Add-on to Home Assistant
* In Home Assistant, go to **Settings** > **Add-ons** > **Add-on Store**.
* Click the three dots in the top right corner and select **Repositories**.
* Add the URL of *this* add-on's public GitHub repository.
* Search the store for "GitHub Config Backup" and click **Install**.

### 3. Configuration
Go to the **Configuration** tab of the add-on and fill in the following fields:
* `github_repo`: The full HTTPS URL of your private backup repository.
* `github_token`: Your newly created Personal Access Token.
* `target_paths`: A list of files or directories you want to back up (e.g., `configuration.yaml`, `automations.yaml`, `integrations/`).

Click **Save** and then click **Start** on the Information tab.

## Safety (secrets.yaml)

This add-on is explicitly designed to only stage and push the exact files and directories you specify in `target_paths`. This prevents sensitive files like `secrets.yaml` (which contains your passwords) or large database files from accidentally ending up on GitHub.

## Configuration Options

| Option | Description |
| :--- | :--- |
| `github_repo` | The full HTTPS URL of your private repository. |
| `github_token` | Your GitHub Personal Access Token (PAT). |
| `git_name` | The author name displayed on the commits. |
| `git_email` | The email address associated with the commits. |
| `commit_interval` | The time in seconds between each sync cycle (default is 3600). |
| `target_paths` | A list of files and directories to synchronize. |

## Manual Sync Trigger (Dashboard Button)

If you don't want to wait for the automatic sync interval, you can force an instant sync by creating a button on your Home Assistant dashboard.

**Step 1: Create a Shell Command**
Add the following lines to your `configuration.yaml` file to allow Home Assistant to create a hidden trigger file:
```yaml
shell_command:
  trigger_github_backup: "touch /config/.sync_now"