function events = createEvents()
%Function that returns a struct array containg all the possible events

% Standard columns in the sheets
standardSheet = {'Navn', 'Antall', 'Kommentar', 'Email', 'Telefon', 'Timestamp', 'Meny', 'Billettnavn', 'Id', 'Payment_id'};

% Create a struct array of all events and their info
events(1).eventName = 'Galla';
events(1).ticketNames = {'Galla', 'Galla rabatt'};
events(1).tilvalg = {'Allergier', 'Årskull'};

% Flytte ventelister til eget event?
events(2).eventName = 'Fredagspakke';
events(2).ticketNames = {'Revy + inngang / konsert', 'Revy + inngang / konsert rabatt', 'Revy + inngang / konsert venteliste',...
    'Revy + konsert ikke funk'};
events(2).tilvalg = {};

events(3).eventName = 'Supperevy';
events(3).ticketNames = {'Supperevy', 'Supperevy rabatt'};
events(3).tilvalg = {};

events(4).eventName = 'Genser';
events(4).ticketNames = {'Jubkomgenser'};
events(4).tilvalg = {'Allergier', 'Årskull', 'Hva synes du om genseren?', 'Hva synes du om denne mcash menyen?', 'Hvilket kjønn er du?'};

events(5).eventName = 'Konsert PGB';
events(5).ticketNames = {'Inngang / konsert venteliste', 'Inngang / konsert Postgirobygget', 'Konsert - Postgirobygget'};
events(5).tilvalg = {};

events(6).eventName = 'E&K';
events(6).ticketNames = {'Konsert - Erik og Kriss'};
events(6).tilvalg = {};

events(7).eventName = 'Jubileumsboken';
events(7).ticketNames = {'Jubileumsboken'};
events(7).tilvalg = {};

events(8).eventName = 'Revy torsdag';
events(8).ticketNames = {'Revy (MSK)', 'Revy jubkom'};
events(8).tilvalg = {};

events(9).eventName = 'MSK';
events(9).ticketNames = {'Student (MSK)'};
events(9).tilvalg = {};

events(10).eventName = 'Revy tidlig';
events(10).ticketNames = {'Revy'};
events(10).tilvalg = {};

events(11).eventName = 'Bonger';
events(11).ticketNames = {'Bong - liten', 'Bong - stor'};
events(11).tilvalg = {};

kurs = {'Kaffekurs', 'Memo', 'Vinkurs', 'Humorkveld', 'Magikershow', 'Salsakurs', 'IMPROschmimpro'};
l = length(events);
for n = 1:length(kurs)
    
    i = n + l;
    events(i).eventName = kurs{n};
    events(i).ticketNames = kurs(n);
    events(i).tilvalg = {};
    
end



for i = 1:length(events)
    
   events(i).sheet = [standardSheet(1:2) events(i).tilvalg standardSheet(3:end)]; 
    
end


end