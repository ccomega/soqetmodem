--I have no idea, but it just works.
while true do
    parallel.waitForAll(function() local evs = {os.pullEvent("soqet_message")}
    if evs then
        os.queueEvent("modem_message", "soqet", evs[2], (evs[4]["replyChannel"] or evs[2]), evs[3], (evs[4]["dist"] or 1))
    end end, function()
		local event, peripheral_name, channel, replyChannel, message, distance = os.pullEvent("modem_message")
		print("Received \"", message "\"on channel", channel, "at", distance, "blocks away. (reply channel: " replyChannel, ")")
	end)
end
