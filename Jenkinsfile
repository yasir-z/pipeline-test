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
        stage("test") {
            steps {
                sh """
                    if [ ! -d "./.venv" ]; then
                        python3 -m venv .venv
                    fi
                    . .venv/bin/activate
                    pip install -r requirements.txt
                    flake8 . --exclude .venv
                    pytest tests/tests_app.py
                """    
            }
        }
    }
}
