%clear all;
FileName = uigetfile('*.mat','Select the tissue mesh files to open', 'MultiSelect', 'on');
if iscell(FileName)
    for m = 1:length(FileName)
        load(FileName{m});
        display(FileName{m})
        fv.vertices = P;
        fv.faces = t;
        NewName =  strcat(FileName{m}(1:end-4), '.stl');
        stlwrite(NewName, fv);           
    end
else
        load(FileName);        
        display(FileName)
        fv.vertices = P;
        fv.faces = t;
        NewName =  strcat(FileName(1:end-4), '.stl');
        stlwrite(NewName, fv);     
end