# Jenkins Pipeline with Git SCM, SonarQube Analysis, Docker Build, and Application Testing

This repository demonstrates a Jenkins pipeline for a CI/CD workflow. The pipeline performs the following steps:

1. **Pulls code from a Git repository**.
2. **Analyzes the code using SonarQube** for static code analysis and quality gate validation.
3. **Builds a Docker image** of a simple web application.
4. **Runs the Docker container** to deploy the application.
5. **Tests the deployed application** to ensure it is running correctly.

## **Workflow Overview**

### 1. **Development Workflow**
- Code is developed on a local machine (e.g., laptop).
- The code is committed and pushed to a Git repository.

### 2. **Jenkins Pipeline Execution**
- The pipeline is triggered when new code is pushed to the Git repository.
- The pipeline runs on a Jenkins server, leveraging Docker to isolate the build and test environments.

### 3. **Pipeline Stages**
#### a. **SonarQube Analysis**
- The code is analyzed using SonarQube to check for code quality, security issues, and maintainability.
- If the SonarQube Quality Gate fails, the pipeline stops.

#### b. **Quality Gate Check**
- Waits for SonarQube to process the analysis and ensures the Quality Gate passes before proceeding.

#### c. **Docker Image Build**
- A `Dockerfile` is dynamically created to build a Docker image of the application.
- The image includes an Apache web server with the application files.

#### d. **Run Docker Container**
- The Docker image is used to start a container, exposing the application on port `8080`.

#### e. **Application Testing**
- A simple HTTP request is made to the application to validate that it is running as expected.
- If the application returns an HTTP status of `200`, it is deemed successful.


## **Requirements**

### 1. **Environment Setup**
- **Jenkins**:
  - Installed with the necessary plugins:
    - Git Plugin
    - Pipeline Plugin
    - SonarQube Plugin
    - Docker Pipeline Plugin
- **Docker**:
  - Installed on the Jenkins server for building and running containers.

### 2. **SonarQube Configuration**
- Ensure that SonarQube is up and running.
- Add a tool configuration in Jenkins for `sonar-scanner` (named `sonar4.7` in the script).
- Configure a SonarQube server in Jenkins (named `sonar-pro` in the script).

### 3. **Git Repository**
- Push your project code to a Git repository (e.g., GitHub, GitLab, or Bitbucket).
- The Jenkins job should be configured to pull the code from this repository.

---

## **How to Use**

1. **Clone this repository** to your local machine:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Edit the Jenkinsfile**:
   - Replace `my-html-css-project`, `sonar-pro`, and paths in the `SonarQube` step as per your project structure and setup.

3. **Push the code to your Git repository**:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

4. **Create a Jenkins Pipeline Job**:
   - Set the pipeline to "Pipeline script from SCM."
   - Provide the URL to your Git repository.

5. **Run the pipeline**:
   - Trigger the Jenkins pipeline manually or configure it to run automatically on new commits.

---

## **Expected Outcome**

1. The pipeline will pull the code from the Git repository.
2. SonarQube will analyze the code and verify the Quality Gate.
3. A Docker image will be built and a container will be launched.
4. The application will be tested to confirm it is running correctly.

---

## **Cleanup**

After the pipeline runs, you can stop and remove the Docker container:
```bash
docker stop test-apache
docker rm test-apache
```
