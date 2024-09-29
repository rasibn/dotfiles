if [ -z "$HOME_EMAIL" ]; then
  echo "HOME_EMAIL environment variable is not set."
  return 1
fi
git config user.name "Rasib Nadeem"
git config user.email "$HOME_EMAIL"
echo "Configured Git locally for home with email: $HOME_EMAIL"
