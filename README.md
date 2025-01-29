# Database Migration Pipeline

This repository contains pipelines for automating database migrations on an existing RDS cluster using **Azure DevOps**, **GitHub Actions**, and a **bash script**. The pipelines are designed to be reliable, idempotent, and include rollback capabilities.

---

## **Pipeline Overview**

### **Goal**
The pipeline automates the process of applying database migrations to an existing RDS cluster and includes a mechanism for rolling back the database to its previous state if something goes wrong.

### **Key Features**
1. **Validation**: Ensures the pipeline can connect to the RDS instance using the provided credentials.
2. **Migration**: Applies all pending database migrations.
3. **Verification**: Confirms that migrations were applied successfully.
4. **Rollback**: Reverts the database to its previous state in case of failure.

---

## **Pipeline Details**

### **1. Azure DevOps Pipeline**

#### **File**
- **`azure-pipelines.yml`**

#### **Steps**
1. **Validate Database Connection**:
   - Ensures the pipeline can connect to the RDS instance using the provided credentials.
2. **Apply Database Migrations**:
   - Applies all pending migrations using Flyway.
3. **Verify Migrations**:
   - Confirms that the migrations were applied successfully.
4. **Rollback Database Migrations**:
   - Reverts the database to its previous state if the migration fails.

#### **How to Use**
1. **Configure RDS Connection**:
   - Update the `variables` section in `azure-pipelines.yml` with your RDS details:
     ```yaml
     variables:
       DB_HOST: 'your-rds-endpoint'  # Replace with actual RDS endpoint
       DB_NAME: 'your-database'       # Replace with actual database name
       DB_USER: 'your-username'       # Replace with actual DB user
       DB_PASS: $(DB_PASSWORD)        # Securely store this as a pipeline secret
     ```
   - Store sensitive information (e.g., `DB_PASSWORD`) in Azure DevOps pipeline secrets.
2. Push the pipeline file to your repository and configure it in Azure DevOps.

---

### **2. GitHub Actions Pipeline**

#### **File**
- **`.github/workflows/db-migration.yml`**

#### **Steps**
1. **Validate Database Connection**:
   - Ensures the pipeline can connect to the RDS instance using the provided credentials.
2. **Apply Database Migrations**:
   - Applies all pending migrations using Flyway.
3. **Verify Migrations**:
   - Confirms that the migrations were applied successfully.
4. **Rollback Database Migrations**:
   - Reverts the database to its previous state if the migration fails.

#### **How to Use**
1. **Configure RDS Connection**:
   - Store sensitive information (e.g., `DB_HOST`, `DB_USER`, `DB_PASS`) in GitHub Secrets:
     - Navigate to **Settings** > **Secrets and variables** > **Actions**.
     - Add the following secrets:
       - `DB_HOST`: Your RDS endpoint.
       - `DB_NAME`: Your database name.
       - `DB_USER`: Your database username.
       - `DB_PASS`: Your database password.
2. Push the workflow file to your repository under `.github/workflows/`.
3. The pipeline will automatically trigger on changes to the `main` branch.

---

### **3. Bash Script**

#### **File**
- **`run_migration.sh`**

#### **Steps**
1. **Install Flyway**:
   - Downloads and installs Flyway CLI.
2. **Validate Database Connection**:
   - Ensures the script can connect to the RDS instance.
3. **Apply Migrations**:
   - Applies all pending migrations using Flyway.
4. **Verify Migrations**:
   - Confirms that the migrations were applied successfully.
5. **Rollback Migrations**:
   - Reverts the database to its previous state if the migration fails.

#### **How to Use**
1. **Configure RDS Connection**:
   - Update the following variables in the script with your RDS details:
     ```bash
     DB_HOST="your-rds-endpoint"  # Replace with actual RDS endpoint
     DB_NAME="your-database"       # Replace with actual database name
     DB_USER="your-username"       # Replace with actual DB user
     DB_PASS="your-password"       # Replace with actual DB password
     ```
2. Ensure the `migrations` and `rollbacks` directories contain the necessary SQL scripts.
3. Make the script executable:
   ```bash
   chmod +x run_migration.sh
