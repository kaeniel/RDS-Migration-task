#!/bin/bash

# Database Configuration
DB_HOST="your-rds-endpoint"  # Replace with actual RDS endpoint
DB_NAME="your-database"       # Replace with actual database name
DB_USER="your-username"       # Replace with actual DB user
DB_PASS="your-password"       # Replace with actual DB password

# Flyway Configuration
FLYWAY_VERSION="9.0.0"
FLYWAY_URL="https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/$FLYWAY_VERSION/flyway-commandline-$FLYWAY_VERSION-linux-x64.tar.gz"
MIGRATION_SCRIPTS_DIR="./migrations"  # Directory containing migration scripts
ROLLBACK_SCRIPTS_DIR="./rollbacks"    # Directory containing rollback scripts

# Install Flyway
install_flyway() {
  echo "Installing Flyway..."
  wget -qO- $FLYWAY_URL | tar xvz
  export PATH=$(pwd)/flyway-$FLYWAY_VERSION:$PATH
  echo "Flyway installed."
}

# Validate Database Connection
validate_connection() {
  echo "Validating database connection..."
  mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "SELECT 1;" $DB_NAME
  if [ $? -eq 0 ]; then
    echo "Database connection validated."
  else
    echo "Failed to connect to the database."
    exit 1
  fi
}

# Apply Migrations
apply_migrations() {
  echo "Applying database migrations..."
  flyway -url=jdbc:mysql://$DB_HOST:3306/$DB_NAME -user=$DB_USER -password=$DB_PASS -locations=filesystem:$MIGRATION_SCRIPTS_DIR migrate
  if [ $? -eq 0 ]; then
    echo "Migrations applied successfully."
  else
    echo "Migrations failed."
    exit 1
  fi
}

# Verify Migrations
verify_migrations() {
  echo "Verifying migrations..."
  flyway -url=jdbc:mysql://$DB_HOST:3306/$DB_NAME -user=$DB_USER -password=$DB_PASS info
  if [ $? -eq 0 ]; then
    echo "Migrations verified."
  else
    echo "Migrations verification failed."
    exit 1
  fi
}

# Rollback Migrations
rollback_migrations() {
  echo "Rolling back migrations..."
  flyway -url=jdbc:mysql://$DB_HOST:3306/$DB_NAME -user=$DB_USER -password=$DB_PASS -locations=filesystem:$ROLLBACK_SCRIPTS_DIR undo
  if [ $? -eq 0 ]; then
    echo "Rollback successful."
  else
    echo "Rollback failed."
    exit 1
  fi
}

# Main Script Execution
install_flyway
validate_connection
apply_migrations
verify_migrations

# Rollback on failure
if [ $? -ne 0 ]; then
  rollback_migrations
fi
