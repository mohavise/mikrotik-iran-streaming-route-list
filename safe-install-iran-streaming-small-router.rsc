# managed-by=mohavise-iran-streaming-route-list
# project=iran-streaming-route-list
# service=iran-streaming
# installer=safe-install-iran-streaming-outbound

:do {
    :local updateUrl "https://raw.githubusercontent.com/mohavise/iran-streaming-route-list/main/services/iran-streaming/routeros/update.rsc"
    :local schedulerUrl "https://raw.githubusercontent.com/mohavise/iran-streaming-route-list/main/services/iran-streaming/routeros/scheduler.rsc"
    :local updateFile "update-iran-streaming-outbound.rsc"
    :local schedulerFile "scheduler-update-iran-streaming-outbound.rsc"

    /tool fetch url=$updateUrl dst-path=$updateFile mode=https
    /import file-name=$updateFile
    /file remove [find name=$updateFile]

    /tool fetch url=$schedulerUrl dst-path=$schedulerFile mode=https
    /import file-name=$schedulerFile
    /file remove [find name=$schedulerFile]

    /system script run update-iran-streaming-outbound
}
