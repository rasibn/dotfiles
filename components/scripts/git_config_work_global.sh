if [ -z "$WORK_EMAIL" ]; then
  echo "WORK_EMAIL environment variable is not set."
  return 1
fi
git config --global user.name "Rasib Nadeem"
git config --global user.email "$WORK_EMAIL"
echo "Configured Git globally for work with email: $WORK_EMAIL"


