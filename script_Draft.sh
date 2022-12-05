#! /bin/bash
vul=false
timestamp=$(date +%d_%m_%Y)
filename="CVE-${timestamp}.csv"
branchName="cve_${timestamp}"

download() {
    wget -qO- https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-modified.json.zip | bsdtar -xvf-
}

delete() {
    rm -f $filename
}

checkVulnerability() {
    if [ -f "./nvdcve-1.1-modified.json" ]; then
        {
            echo -e 'ID, Description, Publish Date\n'
            cat nvdcve-1.1-modified.json | jq -c -r '.CVE_Items[] | select(.cve.description.description_data[0].value | test(".*(Jenkins|Kubernetes).*")) | [.cve.CVE_data_meta.ID, .cve.description.description_data[0].value, .publishedDate] | @csv'
        } >${filename}
    else
        echo "Problem with streamfile"
    fi
}

vulnerable() {

    if [ -f "./${filename}" ]; then
        if [ -s "./${filename}" ]; then
            return 1
        else
            echo "File is empty"
            return 0
        fi
    else
        echo "File not exists"
        return 0
    fi
}

logCVE() {
    if ${vul}; then
        echo "vul is true"
    fi
}
main() {
    delete
    download
    checkVulnerability
    vulnerable
    logCVE

    if vulnerable; then
        git checkout -b ${branchName}
        git add ${filename}
        git commit -m "New vulnerabilities list ${filename}"
        git push --set-upstream origin ${branchName}
        gh pr create --title "New vulnerabilities list ${branchName} ${timestamp}" --body "Check new vulnerabilities ${timestamp}" https://github.com/DorZvulun/CVEs_Find_LOG.git -B main
    fi
}
main

if [[ "${string}" == *"${substring}"* ]]; then
    echo "${string} contains: ${substring}"
fi
