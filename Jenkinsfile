pipeline {
    agent any 
    stages {
        stage("check") {
            steps {
                sh '''
                    test -f app/app.py
                    test -f tests/tests_app.py
                    test -f requirements.txt
                    test -f Dockerfile
                '''
            }
        }    
        stage("test & security") {
            steps {
                sh '''
                    # 1. Virtual environment setup
                    if [ ! -d "./.venv" ]; then
                        python3 -m venv .venv
                    fi
                    
                    # 2. Upgrade pip and install Python dependencies
                    .venv/bin/pip install --upgrade pip
                    .venv/bin/pip install -r requirements.txt
                    
                    # 3. Code quality and security testing tools (Direct .venv binaries)
                    .venv/bin/flake8 . --exclude .venv
                    .venv/bin/pytest tests/tests_app.py -v
                    .venv/bin/bandit -r . -x ./.venv,./tests
                    .venv/bin/pip-audit -r requirements.txt
                    
                    # 4. Secret scanning run via globally installed gitleaks
                    gitleaks detect --source . --verbose --redact
                '''
            }
        }
        stage("Docker Build") {
            steps {
                sh '''
                    COMMIT_SHA=\$(git rev-parse --short HEAD)
                    IMAGE_TAG="\${COMMIT_SHA}-\${BUILD_NUMBER}"

                    echo "Building Docker image with tag: my-flask-app:\${IMAGE_TAG}"
                    docker build -t my-flask-app:\${IMAGE_TAG} .
                '''
            }
        }
        stage("Container Security Scan (Trivy)") {
            steps {
                sh '''
                    COMMIT_SHA=\$(git rev-parse --short HEAD)
                    IMAGE_TAG="\${COMMIT_SHA}-\${BUILD_NUMBER}"

                    echo "Scanning Docker image my-flask-app:\${IMAGE_TAG} for vulnerabilities..."
                    trivy image --skip-version-check --exit-code 1 --severity HIGH,CRITICAL my-flask-app:\${IMAGE_TAG}
                '''
            }
        }
    }
}
