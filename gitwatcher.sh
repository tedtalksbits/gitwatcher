#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Print the script header
echo -e "${CYAN}"
cat << "EOF"
  _____ _ _    __          __   _       _               
 / ____(_) |   \ \        / /  | |     | |              
| |  __ _| |_   \ \  /\  / /_ _| |_ ___| |__   ___ _ __ 
| | |_ | | __|   \ \/  \/ / _` | __/ __| '_ \ / _ \ '__|
| |__| | | |_     \  /\  / (_| | || (__| | | |  __/ |   
 \_____|_|\__|     \/  \/ \__,_|\__\___|_| |_|\___|_|   

  by: @tedane_blake

EOF
echo -e "${RESET}"


# Check for required argument
# -z checks if the string is empty, alternative we could just check for 1 argument like this: if [ $# -ne 1 ]; then
if [ -z "$1" ]; then
  echo -e "${RED}Usage: $0 <path-to-git-repo>${RESET}"
  exit 1
fi

# Validate the provided path
REPO_PATH=$1
if [ ! -d "$REPO_PATH/.git" ]; then
  echo -e "${RED}Error: The provided path is not a Git repository: $REPO_PATH${RESET}"
  exit 1
fi

# Navigate to the repository path
cd "$REPO_PATH" || exit 1

# Get current username
CURRENT_USER=$(whoami)

# Get the repo name
REPO=$(basename "$(git rev-parse --show-toplevel)")

# Fetch updates from the remote
echo -e "${CYAN}Fetching latest updates from the remote repository...${RESET}"
git fetch > /dev/null 2>&1 # Redirect output to null (this suppresses the output both stdout and stderr)
echo -e "${GREEN}Fetch complete.${RESET}"

# Get branches with changes
echo -e "${CYAN}Checking for branches with changes...${RESET}"

CHANGED_BRANCHES=() # Initialize an empty array to store changed branches

# Loop through all remote branches
for branch in $(git for-each-ref --format='%(refname:short)' refs/remotes/origin); do
  LOCAL_BRANCH=${branch#origin/}
  
  # Check if local branch exists and is different from the remote
  if git show-ref --quiet refs/heads/"$LOCAL_BRANCH"; then
    # Check for differences
    if ! git diff --quiet "$branch" "$LOCAL_BRANCH"; then
      CHANGED_BRANCHES+=("$LOCAL_BRANCH")
    fi
  else
    # Add branches that don't exist locally as "changed"
    CHANGED_BRANCHES+=("$LOCAL_BRANCH")
  fi
done

# Count changes and branches
NUM_BRANCHES=${#CHANGED_BRANCHES[@]}

if [ "$NUM_BRANCHES" -eq 0 ]; then
  echo -e "${GREEN}Hello ${YELLOW}$CURRENT_USER${RESET}"
  echo -e "${CYAN}Your repo: ${YELLOW}$REPO${CYAN} has no changes in any branches.${RESET}"
  exit 0
fi

# Display branches with changes
echo -e "${GREEN}Hello ${YELLOW}$CURRENT_USER${RESET}"
echo -e "${CYAN}Your repo: ${YELLOW}$REPO${CYAN} has ${YELLOW}$NUM_BRANCHES${CYAN} changes in the following branches:${RESET}"
for i in "${!CHANGED_BRANCHES[@]}"; do
  echo -e "${YELLOW}  [$((i + 1))]${RESET} - ${CHANGED_BRANCHES[i]}"
done

# Prompt for branch selection
echo -e "${CYAN}Would you like to pull the latest code?${RESET}"
echo -e "${CYAN}Choose a branch by entering the corresponding number:${RESET} "
read -r CHOICE

# Validate input
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "$NUM_BRANCHES" ]; then
  echo -e "${RED}Invalid choice. Exiting.${RESET}"
  exit 1
fi

# Get the selected branch
SELECTED_BRANCH=${CHANGED_BRANCHES[$((CHOICE - 1))]}

# Check out the selected branch and pull the latest changes
echo -e "${CYAN}Switching to branch: ${YELLOW}$SELECTED_BRANCH${CYAN}...${RESET}"
git checkout "$SELECTED_BRANCH"
echo -e "${GREEN}Switched to branch: $SELECTED_BRANCH.${RESET}"

echo -e "${CYAN}Pulling the latest code for branch: ${YELLOW}$SELECTED_BRANCH${CYAN}...${RESET}"
git pull > /dev/null 2>&1
echo -e "${GREEN}Successfully pulled the latest code for branch: ${YELLOW}$SELECTED_BRANCH${GREEN}.${RESET}"
