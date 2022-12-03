def index=1
def timestamp=new Date().format("dd_mm_yyy")
def branchName="cve_${timestamp}_${index}"
def filename="CVE-${timestamp}_${index}.csv"
def repo_url="https://github.com/DorZvulun/CVEs_Find_LOG.git"

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

        // stage('PR_fence'){
        //     when{
        //         sh """
        //             git clone ${repo_url}
        //             cd CVEs_Find_LOG
        //             pr_list=$(gh pr list)
        //             if [[ "${pr_list}" == *"${no open pull requests}"* ]]
        //                 then
        //                     exit 0
        //             fi 

        //             """
        //     }
        //     steps{
        //         script{
        //             echo "~~~~~ Checking if PR exists ~~~~~"
                    
        //         }
                
        //     }
        // }

        stage('Run_Script'){
            steps{
                script{
                    echo "~~~~~~~ running check vulnerabilities script ~~~~~~"
                    sh """

                    download() {
                        wget -qO- https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-modified.json.zip | bsdtar -xvf-
                    }

                    delete() {
                        rm -f ${filename}
                    }

                    checkVulnerability() {
                        git clone git@github.com:DorZvulun/CVEs_Find_LOG.git
                        
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
                                gh pr create --title "New vulnerabilities list ${branchName} ${timestamp}" --body "Check new vulnerabilities ${timestamp}" -B main
                                gh pr create --fill -B main
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
                        logCVE

                        ${index}=${index}+1

                        
                    }
                    main

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