#! /bin/bash
vul=false
timestamp=$(date +%d_%m_%Y)
filename="CVE-${timestamp}.csv"
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
            git checkout -b cve_${timestamp}
            git add ${filename}
            git commit -m "${filename}"
            git request-pull

            vul=true
        else
            echo "File is empty"
            vul=false
        fi
    else
        echo "File not exists"
        vul=false
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
}
main
