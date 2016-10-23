clear all;
FileName = uigetfile('*.stl','Select the tissue mesh file to open', 'MultiSelect', 'on');
if iscell(FileName)
    for m = 1:length(FileName)
        [t, P, normals]= stlread(FileName{m}); 
        display(FileName{m});
        NewName =  strcat(FileName{m}(1:end-4), '.mat');
        save(NewName, 'P', 't');           
    end
else
        [t, P, normals]= stlread(FileName); 
        display(FileName);
        NewName =  strcat(FileName(1:end-4), '.mat');
        save(NewName, 'P', 't');        
end