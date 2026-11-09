pipeline {
    agent any 
    stages {
        stage ("check") {
            steps {
                sh """
                    test -f app/app.py
                    test -f tests/tests_app.py
                    test -f requirements.txt
                """
            }
        }    
        stage("test & security") {
            steps {
                sh """
                    # 1. Virtual environment setup
                    if [ ! -d "./.venv" ]; then
                        python3 -m venv .venv
                    fi
                    
                    # 2. Upgrade pip and install Python dependencies
                    .venv/bin/pip install --upgrade pip
                    .venv/bin/pip install -r requirements.txt
                    
                    # 3. Code quality and testing tools (Direct .venv binaries)
                    .venv/bin/flake8 . --exclude .venv
                    .venv/bin/pytest tests/tests_app.py -v
                    .venv/bin/bandit -r . -x ./.venv,./tests
                    .venv/bin/pip-audit -r requirements.txt
                    
                    # 4. Gitleaks binary setup (Locally in workspace - No sudo required)
                    if [ ! -f "./bin/gitleaks" ]; then
                        echo "Gitleaks not found. Downloading locally..."
                        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz -o gitleaks.tar.gz
                        tar -xzf gitleaks.tar.gz
                        
                        mkdir -p bin
                        mv gitleaks bin/
                        chmod +x bin/gitleaks
                        rm -f gitleaks.tar.gz LICENSE README.md
                    fi
                    
                    # 5. Secret scanning run via local binary
                    ./bin/gitleaks detect --source . --verbose --redact
                """
            }
        }
    }
}
