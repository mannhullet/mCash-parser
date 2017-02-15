function splitMenus()

[~, ~, raw] = xlsread('sales.xls');
% [~, ~, raw] = xlsread('vv5ngx-transactions-1475272800-1485903541.xls');

filename = 'menus.xls';
num_rows = size(raw, 1);
header = raw(1, :);

% Find out which column has the menus in it
menu_column = strcmp(raw(1,:), 'menu');

% Find the name of all the different menus.
menus = unique(raw(3:end, menu_column));

% Create the information for each excel sheet.
for i = 1:length(menus)
    if length(menus{i}) > 31
        sheets(i).name = menus{i}(1:31);
    else
        sheets(i).name = menus{i};
    end
    sheets(i).sheet = header;
end

% Copy each row to its correct sheet, based on menu
for i = 3:num_rows
    
    row = raw(i, :);
    menu = row{menu_column};
    menu_index = strcmp(menu, menus);
    
    sheets(menu_index).sheet(end + 1, :) = row;
    
end

% Write all sheets to excelfile
xlswrite(filename, raw);
for j = 1:length(sheets)
    xlswrite(filename, sheets(j).sheet, sheets(j).name)
end

end