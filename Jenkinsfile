def timestamp=new Date().format("dd_MM_yyy_mm")
def branchName="cve_${timestamp}"
def filename="CVE-${timestamp}.csv"
def repo_url="https://github.com/DorZvulun/CVEs_Find_LOG.git"

pipeline{
    agent any
    options{
        timestamps()
        timeout(time:14, unit: 'MINUTES')
        buildDiscarder(logRotator(
            numToKeepStr: '4',
            daysToKeepStr: '1',
            artifactNumToKeepStr: '0'
        ))
    }

    stages{

        stage('PR_fence'){
            steps{
                script{
                    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n~~~~~ Checking if PR exists ~~~~~\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                    withCredentials([sshUserPrivateKey(credentialsId: 'ceb8ef64-63bc-4918-8c7f-a34193776425')]) {
                        sh """
                            git clone git@github.com:dorzvulun/CVEs_Find_Log.git
                            cd CVEs_Find_Log
                            gh pr list
                        """
                        // sh """
                        //     git clone git@github.com:DorZvulun/CVEs_Find_LOG.git
                        //     cd CVEs_Find_LOG
                        //     if ! [[ $(gh pr list) == *"no open pull requests"* ]]
                        //         then
                        //             echo "~~~~~~ no pull requests ~~~~~~"
                        //             exit 0
                        //     fi 
                        // """
                    }
                }
                
            }
        }

        stage('Run_Script'){
            steps{
                script{
                    echo "~~~~~~~ running check vulnerabilities script ~~~~~~"
                    withCredentials([sshUserPrivateKey(credentialsId: 'ceb8ef64-63bc-4918-8c7f-a34193776425')]) {
                        sh """

                        download() {
                            wget -qO- https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-modified.json.zip | bsdtar -xvf-
                        }

                        delete() {
                            rm -f ${filename}
                        }

                        checkVulnerability() {
                            git clone ${repo_url}
                            
                            if [ -f "./nvdcve-1.1-modified.json" ]; then
                                {
                                    echo -e 'ID, Description, Publish Date\n'
                                    cat nvdcve-1.1-modified.json | jq -c -r '.CVE_Items[] | select(.cve.description.description_data[0].value | test(".*(Jenkins|Kubernetes).*")) | [.cve.CVE_data_meta.ID, .cve.description.description_data[0].value, .publishedDate] | @csv'
                                } >./CVEs_Find_LOG/${filename}
                            else
                                echo "Problem with streamfile"
                            fi
                            cd CVEs_Find_LOG
                        }

                        vulnerable() {

                            if [ -f "./${filename}" ]; then
                                if [ -s "./${filename}" ]; then
                                    git config user.name ${env.GIT_COMMITER_NAME}
                                    git config user.email ${env.GIT_COMMITER_EMAIL}
                                    git checkout -b ${branchName}
                                    git add ${filename}
                                    git commit -m "New vulnerabilities list ${filename}"
                                    git push --set-upstream origin ${branchName}
                                    gh pr create --fill ${repo_url} -B main
                                else
                                    echo "File is empty"
                                    return 0
                                fi
                            else
                                echo "File not exists"
                                return 0
                            fi
                        }

                        
                        main() {
                            #delete
                            download
                            checkVulnerability
                            vulnerable
                        }
                        main

                        """
                    }
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