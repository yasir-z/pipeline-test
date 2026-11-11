pipeline {
    agent any 
    
    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'docker-hub-credentials'
        DOCKER_REPO = 'shepherd777/my-flask-app' // Apna Docker Hub username yahan confirm kar lein
        IMAGE_TAG = "${env.GIT_COMMIT.take(7)}-${env.BUILD_NUMBER}"
    }

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
                    if [ ! -d "./.venv" ]; then
                        python3 -m venv .venv
                    fi
                    
                    .venv/bin/pip install --upgrade pip
                    .venv/bin/pip install -r requirements.txt
                    
                    .venv/bin/flake8 . --exclude .venv
                    .venv/bin/pytest tests/tests_app.py -v
                    .venv/bin/bandit -r . -x ./.venv,./tests
                    .venv/bin/pip-audit -r requirements.txt
                    
                    gitleaks detect --source . --verbose --redact
                '''
            }
        }
        stage("Docker Build") {
            steps {
                sh '''
                    echo "Building Docker image with tag: my-flask-app:$IMAGE_TAG"
                    docker build -t my-flask-app:$IMAGE_TAG .
                '''
            }
        }
        stage("Container Security Scan (Trivy)") {
            steps {
                sh '''
                    echo "Scanning Docker image my-flask-app:$IMAGE_TAG for vulnerabilities..."
                    trivy image --skip-version-check --ignore-unfixed --exit-code 1 --severity HIGH,CRITICAL my-flask-app:$IMAGE_TAG
                '''
            }
        }
        stage("Push docker image to registry") {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag my-flask-app:$IMAGE_TAG $DOCKER_REPO:$IMAGE_TAG
                        docker push $DOCKER_REPO:$IMAGE_TAG
                        
                    '''
                }
            }
        }

        post {
            always {
                sh '''
                docker logout || true
                docker rmi my-flask-app:$IMAGE_TAG $DOCKER_REPO:$IMAGE_TAG || true
                '''
            }

        }

    }
}




