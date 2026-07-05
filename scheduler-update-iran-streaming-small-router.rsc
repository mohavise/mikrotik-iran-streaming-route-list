# managed-by=mohavise-mikrotik-iran-streaming
# project=iran-streaming-route-list
# do-not-edit-manually

:do {
    :local scheduleName "run-update-iran-streaming-small-router"
    :local scheduleEvent "/system script run update-iran-streaming-small-router"

    :if ([:len [/system scheduler find name=$scheduleName]] = 0) do={
        /system scheduler add name=$scheduleName start-time=04:00:00 interval=1d on-event=$scheduleEvent policy=read,write,policy,test comment="managed-by=mohavise-mikrotik-iran-streaming project=iran-streaming-route-list"
    } else={
        /system scheduler set [/system scheduler find name=$scheduleName] start-time=04:00:00 interval=1d on-event=$scheduleEvent policy=read,write,policy,test comment="managed-by=mohavise-mikrotik-iran-streaming project=iran-streaming-route-list"
    }
}
