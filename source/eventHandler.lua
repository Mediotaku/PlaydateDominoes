local eventsTable = {}

function EventSubscribe(eventName, functionReference)
  eventsTable[eventName].insert(functionReference)
end

function EventUnsubscribe(eventName)

end

function EventFire(eventName)

end
