function expandAll(filename)

[~, sheets] = xlsfinfo(filename);

for i = 1:length(sheets)
    
    expandDuplicates(filename, sheets{i})
    
end


end