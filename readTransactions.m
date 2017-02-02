function raw = readTransactions(filename)

% Check if user provided a filename
if nargin == 0
    %TODO: Change to ui selecting desired file
    fprintf('No filename given, using "sales.xls"')
    filename = 'sales.xls';
elseif nargin ~= 1
    error('Invalid amount of arguments, expected 1 or 0 and recieved %d', nargin)
end

[~, ~, raw] = xlsread(filename);

end