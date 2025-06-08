
if [[ -z "$ENVIRONMENT" ]]; then
    echo "ENVIRONMENT must be set"
    exit 1
fi

if [[ -z "$SQL_REPO_NAME" ]]; then 
    echo "SQL_REPO_NAME must be set"
    exit 1
fi

if [[ -z "$GH_TOKEN" ]]; then 
    echo "GH_TOKEN must be set"
    exit 1
fi

SQL_SECRET_NAME="${SQL_SECRET_NAME:-DB_CONNECTION_STRING}"
DB_CONNECTION_STRING=$(terraform output -raw db_connection_string)

echo "Updating $SQL_SECRET_NAME in $REPO_NAME..."
gh secret set "$SQL_SECRET_NAME" --body "$DB_CONNECTION_STRING" --repo "$SQL_REPO_NAME" --env "$ENVIRONMENT"
