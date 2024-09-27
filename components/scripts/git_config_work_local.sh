if [ -z "$WORK_EMAIL" ]; then
  echo "WORK_EMAIL environment variable is not set."
  return 1
fi
git config user.name "Rasib Nadeem"
git config user.email "$WORK_EMAIL"
echo "Configured Git locally for work with email: $WORK_EMAIL"


