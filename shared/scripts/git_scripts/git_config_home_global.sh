if [ -z "$HOME_EMAIL" ]; then
  echo "HOME_EMAIL environment variable is not set."
  return 1
fi
git config --global user.name "Rasib Nadeem"
git config --global user.email "$HOME_EMAIL"
echo "Configured Git globally for home with email: $HOME_EMAIL"
