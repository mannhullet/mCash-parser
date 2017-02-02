function parseMcash()

events = createEvents();

filename = splitTickets(events);

for i = 1:length(events)
   expandDuplicates(filename, events(i).eventName); 
end

end