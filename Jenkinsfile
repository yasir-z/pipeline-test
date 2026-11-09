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
                    
                    # 2. Dependencies aur tools install karein (requirements.txt se gitleaks hata hua hona chahiye)
                    .venv/bin/pip install --upgrade pip
                    .venv/bin/pip install -r requirements.txt
                    
                    # 3. Code quality aur testing tools (Direct .venv binaries)
                    .venv/bin/flake8 . --exclude .venv
                    .venv/bin/pytest tests/tests_app.py -v
                    .venv/bin/bandit -r . -x ./.venv,./tests
                    .venv/bin/pip-audit -r requirements.txt
                    
                    # 4. Gitleaks binary check aur download (Agar pehle se nahi hai)
                    if ! command -v gitleaks &> /dev/null; then
                        echo "Gitleaks not found. Downloading..."
                        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz -o gitleaks.tar.gz
                        tar -xzf gitleaks.tar.gz
                        sudo mv gitleaks /usr/local/bin/
                        rm gitleaks.tar.gz LICENSE README.md
                    fi
                    
                    # 5. Secret scanning run karein
                    gitleaks detect --source . --verbose --redact
                """
            }
        }
    }
}
