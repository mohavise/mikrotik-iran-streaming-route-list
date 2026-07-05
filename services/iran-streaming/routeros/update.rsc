# managed-by=mohavise-iran-streaming-route-list
# project=iran-streaming-route-list
# service=iran-streaming
# script=update-iran-streaming-outbound
# source-file=services/iran-streaming/output/list-all.rsc

/system script
:if ([:len [find name="update-iran-streaming-outbound"]] > 0) do={ remove [find name="update-iran-streaming-outbound"] }
add dont-require-permissions=no name=update-iran-streaming-outbound owner=admin policy=read,write,policy,test source=":local fileName \"iran-streaming-outbound.rsc\"
:local dnsBackup \"iran-streaming-dns-backup-before-update.rsc\"
:local url \"https://raw.githubusercontent.com/mohavise/iran-streaming-route-list/main/services/iran-streaming/output/list-all.rsc\"
:local addrList \"DST-IRAN-STREAMING-TO-OUTBOUND\"
:local minFileSize 1000
:if ([:len [/file find name=\$fileName]] > 0) do={ /file remove \$fileName }
:if ([:len [/file find name=\$dnsBackup]] > 0) do={ /file remove \$dnsBackup }
:do { /ip dns static export file=\$dnsBackup where address-list=\$addrList } on-error={ :log warning \"Iran streaming outbound update: could not create DNS backup; stopping\"; :return }
:do { /tool fetch url=\$url dst-path=\$fileName mode=https } on-error={ :log warning \"Iran streaming outbound update: download failed; keeping old DNS static rules\"; :return }
:if ([:len [/file find name=\$fileName]] = 0) do={ :log warning \"Iran streaming outbound update: downloaded file not found; keeping old DNS static rules\"; :return }
:local fileSize [/file get [find name=\$fileName] size]
:if (\$fileSize < \$minFileSize) do={ :log warning (\"Iran streaming outbound update: downloaded file too small (\" . \$fileSize . \" bytes); keeping old DNS static rules\"); /file remove \$fileName; :return }
:do { /import file-name=\$fileName } on-error={ :log error \"Iran streaming outbound update: import failed; restoring DNS backup\"; :do { /import file-name=\$dnsBackup } on-error={}; :return }
:if ([:len [/ip dns static find address-list=\$addrList comment~\"iran-streaming:\"]] = 0) do={ :log error \"Iran streaming outbound update: DNS static list empty after import; restoring backup\"; :do { /import file-name=\$dnsBackup } on-error={}; :return }
/file remove \$fileName
:if ([:len [/file find name=\$dnsBackup]] > 0) do={ /file remove \$dnsBackup }
:log warning \"Iran streaming outbound update: completed successfully\"
"
