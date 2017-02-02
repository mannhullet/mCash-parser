function expandDuplicates(filename, sheetname)

if nargin == 1
    [~, ~, raw] = xlsread(filename);
elseif nargin == 2
    [~, ~, raw] = xlsread(filename, sheetname);
else
    error('Wrong amount of input arguments')
end

% Initialiser tomt sheet med riktig headerline
header = raw(1, :);
newSheet = header;


% Assumes that file is on format from splitTickets
for row = 2:size(raw, 1)
    
    entry = raw(row, :);
    
    if entry{2} > 1
        numDuplicates = entry{2};
        entry{2} = 1;
        
        sanitizedEntry = entry;
%         sanitizedEntry{strcmp(header, 'Navn')} = NaN; 
        sanitizedEntry{strcmp(header, 'Email')} = NaN;
        sanitizedEntry{strcmp(header, 'Telefon')} = NaN;
        sanitizedEntry{strcmp(header, 'Kommentar')} = sprintf('Automatically expanded. Bought by: %s', entry{1});
        tilvalgPos = find(strcmp(header, 'Antall')) + 1 : find(strcmp(header, 'Kommentar')) - 1;
        sanitizedEntry(tilvalgPos) = {NaN};
        
        % Sett inn en rad for hver duplicate
        newSheet(end + 1, :) = entry;
        for i = 2:numDuplicates
            newSheet(end + 1, :) = sanitizedEntry;
        end
    else
        % Sett inn original
        newSheet(end + 1, :) = entry;
    end
    
end

if nargin == 1
    xlswrite(filename, newSheet);
elseif nargin == 2
    sheet = sprintf('%s expanded', sheetname);
    xlswrite(filename, newSheet, sheet);
end

end