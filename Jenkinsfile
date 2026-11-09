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
                    python3 -m venv .venv
                    .venv/bin/pip install -r requirements.txt
                    .venv/bin/flake8 app/ --max-line-length=120
                    .venv/bin/pytest
                """
            }
        }
   }
}
