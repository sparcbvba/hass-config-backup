# GitHub Config Backup for Home Assistant

This Home Assistant add-on provides a simple and secure way to apply version control to your most important configuration files using GitHub. 

Instead of creating a full system backup, this add-on focuses specifically on the files you frequently edit manually. This GitOps approach gives you a clean and organized commit history of your changes and allows you to sync your configuration across different setups.

## How it works

When you start the add-on, it performs the following steps:
1. **Initialization:** The add-on checks if the Home Assistant `/config` directory is already linked to a Git repository. If not, it initializes one.
2. **Authentication:** It securely connects to GitHub using your provided Personal Access Token (PAT).
3. **Syncing (The Loop):** The add-on runs continuously in the background. On a set interval (e.g., every 3600 seconds), it performs a two-way sync:
   - **Pull:** It first checks GitHub for any new changes and pulls them into your local setup. *(Note: You may need to reload your YAML in Home Assistant for these changes to take effect).*
   - **Check:** It then checks your local `configuration.yaml` and the `template/` directory for any modifications.
4. **Commit:** If a local change is detected in any of these targets, the add-on automatically creates a commit with the message: `Automatische backup: [Date and Time]`.
5. **Push:** The changes are instantly pushed to the `main` branch of your configured GitHub repository.

*Note: If no changes are detected, the add-on simply waits until the next scheduled check.*

## Safety (Why no secrets.yaml?)

This add-on is explicitly designed **not** to use commands like `git add .` (which stages all files). By specifically targeting `git add configuration.yaml` and `git add template/`, it eliminates the risk of accidentally pushing your `secrets.yaml` (which contains your passwords, API keys, and tokens) or large database files to a public or remote GitHub repository.

## Configuration Options

In the "Configuration" tab of the add-on, the user must provide the following parameters:

| Option | Description | Example |
| :--- | :--- | :--- |
| `github_repo` | The full HTTPS URL of your repository. | `https://github.com/YOUR_NAME/HA-Config.git` |
| `github_token` | Your GitHub Personal Access Token (PAT). Ensure this token has the `repo` scope permissions. | `ghp_abCDefGHIjkLMNopQRS...` |
| `git_name` | The author name displayed on your commits. | `Home Assistant` |
| `git_email` | The email address associated with your GitHub commits. | `your@email.com` |
| `commit_interval` | The time in seconds between each sync cycle. | `3600` (1 hour) or `86400` (24 hours) |

## Troubleshooting (Logs)

If you don't see changes appearing on GitHub, or if files aren't downloading to Home Assistant, check the **Log** tab in the add-on. 
- You will see messages like `[Info] Wijziging(en) gedetecteerd! Bezig met pushen naar GitHub...` when a push is successful.
- If the Personal Access Token is expired or incorrect, the Git output in this log will display the error (e.g., *Authentication failed*).
- If you edit the same file locally and on GitHub simultaneously, you might encounter a *Merge Conflict*. The logs will warn you if a `git pull` fails.