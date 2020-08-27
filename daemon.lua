--I have no idea, but it just works.
while true do
    local evs = {os.pullEvent("soqet_message")}
    if evs then
        os.queueEvent("modem_message", "soqet", evs[2], (evs[4]["replyChannel"] or evs[2]), evs[3], (evs[4]["dist"] or 1))
        print("Received \"", evs[3], "\" in channel ", evs[2], "(reply channel: ", (evs[4]["replyChannel"] or evs[2]), ")")
    end
end