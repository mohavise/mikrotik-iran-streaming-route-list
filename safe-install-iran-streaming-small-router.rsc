# managed-by=mohavise-mikrotik-iran-streaming
# project=iran-streaming-route-list
# do-not-edit-manually

:do {
    :local updateUrl "https://raw.githubusercontent.com/mohavise/iran-streaming-route-list/main/update-iran-streaming-small-router.rsc"
    :local schedulerUrl "https://raw.githubusercontent.com/mohavise/iran-streaming-route-list/main/scheduler-update-iran-streaming-small-router.rsc"
    :local updateFile "update-iran-streaming-small-router.rsc"
    :local schedulerFile "scheduler-update-iran-streaming-small-router.rsc"

    /tool fetch url=$updateUrl dst-path=$updateFile mode=https
    /import file-name=$updateFile
    /file remove [find name=$updateFile]

    /tool fetch url=$schedulerUrl dst-path=$schedulerFile mode=https
    /import file-name=$schedulerFile
    /file remove [find name=$schedulerFile]

    /system script run update-iran-streaming-small-router
}
