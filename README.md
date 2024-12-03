# Git Branch Checker and Pull Script

A Bash script to check for changes in branches of a Git repository, allowing the user to select a branch to switch to and pull the latest changes.

## Features

- Fetches the latest updates from the remote repository.
- Lists branches with actual changes (new commits or differences between local and remote).
- Allows the user to select a branch and pull the latest changes.
- Can be executed from any location by specifying the path to the Git repository.
- User-friendly output with colored messages.

## Requirements

- A Unix-based system with Bash installed.
- `git` installed and available in the system's PATH.
- A valid Git repository.

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the repository:
   ```bash
   cd <repository-folder>
   ```
3. Make the script executable:
   ```bash
   chmod +x gitwatcher.sh
   ```

## Usage

To run the script, use the following syntax:

```bash
./gitwatcher.sh <path-to-git-repo>
```

### Arguments

- `<path-to-git-repo>`: The path to the Git repository you want to check.

## Examples

### Check and Pull Changes

```bash
./gitwatcher.sh ~/Documents/my-git-project
```

Example Output:

```
Fetching latest updates from the remote repository...
Fetch complete.
Checking for branches with changes...
Hello alyss
Your repo: my-git-project has 2 changes in the following branches:
  1 - main
  2 - feature-branch
Would you like to pull the latest code?
Choose a branch by entering the corresponding number: 2
Switching to branch: feature-branch...
Switched to branch: feature-branch.
Pulling latest changes...
Successfully pulled the latest code for branch: feature-branch.
```

### Handle No Changes

If there are no changes in any branches:

```bash
./gitwatcher.sh ~/Documents/my-git-project
```

Output:

```
Fetching latest updates from the remote repository...
Fetch complete.
Checking for branches with changes...
Hello alyss
Your repo: my-git-project has no changes in any branches.
```

## Contributing

Feel free to open issues or submit pull requests for bug fixes, improvements, or new features.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
