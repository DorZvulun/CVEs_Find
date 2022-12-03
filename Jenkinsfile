def branchName=""
def filename=""
def repo_url="https://github.com/DorZvulun/CVEs_Find_LOG.git"
def GH_TOKEN="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"
pipeline{
    agent any
    options{
        timestamps()
        timeout(time:14, unit: 'MINUTES')
        buildDiscarder(logRotator(
            numToKeepStr: '6',
            daysToKeepStr: '7',
            artifactNumToKeepStr: '30'
        ))
    }

    stages{

        stage('PR_fence'){
            steps{
                sh """
                git clone https://github.com/DorZvulun/CVEs_Find_LOG.git
                cd CVEs_Find_LOG
                gh pr view ${branchName}

                """
            }
        }

        stage('Run_Script'){
            steps{
                script{
                    echo "~~~~~~~"
                    sshagent([''])
                        sh """

                        """
                }

                
            }
        }

    }

    post{
        success {
            script{
                echo "success"
            }
        }
        failure{
            script{
                echo "failure"
            }
        }
        always{
            cleanWs()
        }
    }
}