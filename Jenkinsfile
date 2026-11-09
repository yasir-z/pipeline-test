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
                // Jenkins runs sh with "-e": the first failing command fails the build.
                sh '''
                    python3 -m venv .venv
                    . .venv/bin/activate
                    pip install -r requirements.txt
                    pip install flake8 pytest bandit pip-audit
 
                    echo "== Linter ==";                 flake8 . --exclude .venv
                    echo "== Unit tests ==";             pytest tests/tests_app.py
                    echo "== Integration tests ==";      pytest tests/tests_app.py
                    echo "== Security scan (SAST) ==";   bandit -r . -x ./.venv,./tests
                    echo "== Dependency scan ==";        pip-audit -r requirements.txt
                    echo "== Secret leak scan ==";       gitleaks detect --source . --verbose
                '''
            }
        } 
    }
}
