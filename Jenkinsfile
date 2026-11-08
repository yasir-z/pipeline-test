pipeline {
    agent any 
    stages {
        stage ("check"){
            steps {
                sh """
                    test -f app/app.py
                    test -f tests/tests_app.py
                    test -f requirements.txt
                """
            }
        }    
    }
}
