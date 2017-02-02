function filename = splitTickets(events)

[~, ~, raw] = xlsread('sales.xls');

newestTime = datetime(1990, 1, 1);

id_col = strcmp(raw(1, :), 'id');
payment_id_col = strcmp(raw(1, :), 'payment_tid');
description_col = strcmp(raw(1, :), 'description');
menu_col = strcmp(raw(1, :), 'menu');
timestamp_col = strcmp(raw(1, :), 'timestamp');
name_col = strcmp(raw(1, :), 'customer_data.name');
mail_col = strcmp(raw(1, :), 'customer_data.email');
tlf_col = strcmp(raw(1, :), 'customer_data.phone_number');

for rad = 3:size(raw, 1)
    
    % Hent info fra excelarket
    % TODO: Endre så ikke kolonnenummer er hardkodet
    id = raw{rad, id_col};
    payment_id = raw{rad, payment_id_col};   
    description = raw{rad, description_col};
    menu = raw{rad, menu_col};
    timestamp = raw{rad, timestamp_col};
    name = raw{rad, name_col};
    mail = raw{rad, mail_col};
    tlf = raw{rad, tlf_col};
    
    person = {name, NaN, mail, tlf, timestamp, menu, id, payment_id};
    
    t = parseTime(timestamp);
    if t > newestTime
        newestTime = t;
    end
    
    %Skill ut de forskjellige linjene i description
    tickets = strsplit(description, '\n');
    
    %TODO: Splitt dette opp bedre, så hver funksjon bare gjør 1 ting
    events = parseTickets(tickets, events, person);
    
end

%TODO Write raw file to first sheet

%Filename containing the date of the latest sale
filename = sprintf('Tickets - %s', datestr(t, 'yyyy-mm-dd'));
% filename = 'tickets.xls';
for e = 1:length(events)
    xlswrite(filename, events(e).sheet, events(e).eventName)
end

end
function [events] = parseTickets(tickets, events, person)

%Løkk gjennom billetter og tilvalg
j = 1;
while j <= length(tickets)
    
    % Sjekk om har kommet til en ny billett
    if ~isempty(strfind(tickets{j}, ' x '))
        
        % Hent ut hvilken billett og hvor mange
        tick_parts = strsplit(tickets{j}, ' x ');
        tick_parts = strtrim(tick_parts);
        amount = str2double(tick_parts{1});
        event = tick_parts{2};
        
        % Fjern evt kolon på slutten av eventnavnet
        if event(end) == ':'
            event = event(1:end-1);
        end
        
        [events, j] = getEventInfo(tickets, events, j, person, amount, event);
        
    end
    
    j = j + 1;
    
end

end
function [events, j] = getEventInfo(tickets, events, j, person, amount, event)

% Løkke gjennom alle eventene
for eventNum = 1:length(events)
    
    % Sjekk om eventen matcher den i eventlisten
    if any(strcmp(event, events(eventNum).ticketNames))
        eventInfo = struct;
        eventInfo.amount = amount;
        eventInfo.ticket = event;
        
        [events, j] = parseTilvalg(tickets, events, j, person, eventInfo, eventNum);
        
        % Break the loop, no need to check more events
        % Means that double event entries won't be detected
        break
    end
    
    % Errorcheck that event did not pass through witout being picked up
    if eventNum == length(events)
        error('Could not find an event match for ticket "%s"', event)
    end
end


end
function [events, j] = parseTilvalg(tickets, events, j, person, eventInfo, eventNum)

% Les inn tilvalg og legg de inn i sheeten bare hvis eventen har tilvalg
if ~isempty(events(eventNum).tilvalg)
    eventInfo.tilvalg = events(eventNum).tilvalg;
    eventInfo.tilvalg(2, :) = {NaN};
    
    % Hent ut tilvalg
    while j + 1 <= length(tickets) && isempty(strfind(tickets{j+1}, ' x '))
        j = j + 1;
        line = tickets{j};
        [tilvalg, info] = strtok(line, ':');
        info = strtrim(info(2:end));
        
        tilvalgIndex = strcmp(tilvalg, eventInfo.tilvalg(1, :));
        
        if sum(tilvalgIndex) > 1
            error('Matchet på flere enn ett tilvalg, sjekk at eventen er riktig lagt inn')
        end
        
        eventInfo.tilvalg(2, tilvalgIndex) = {info};
        
    end
    
    sheetRow = [person(1) eventInfo.amount eventInfo.tilvalg(2, :) person(2:6) eventInfo.ticket person(7:end)];
    events(eventNum).sheet(end+1, :) = sheetRow;
    
else
    sheetRow = [person(1) eventInfo.amount person(2:6) eventInfo.ticket person(7:end)];
    events(eventNum).sheet(end+1, :) = sheetRow;
end

end
function t = parseTime(time)

year = str2double(time(1:4));
month = str2double(time(6:7));
day = str2double(time(9:10));

t = datetime(year, month, day);

end