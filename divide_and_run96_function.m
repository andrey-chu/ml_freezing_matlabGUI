function divide_and_run96_function(directory, tempfile)
cwd = pwd;
% directory ='/data/Freezing_samples/Test96Bakterie_1/';
fprintf('Working in directory %s\n', directory);
fprintf('Tempfile is %s\n',strcat(directory, tempfile));
cd(directory)
figlist = dir('*PNG');
% tempfile = 'Temperatur/Test_96_-_Bakterie_1.csv';

cd(pwd)
fig1=imread([directory, figlist(1).name]);%extract experiment name and sort
size_wells = 96;
size96 = [106, 106];
start96 = [22, 20];
fignum =length(figlist);

for i = 1:length(figlist)
   name_split = split(figlist(i).name, {'_','.'});
   figlist(i).number = str2num(name_split{7});
end
centers_x = (56+72/2):106:1340;
centers_y = (54+72/2):106:900;

wells = zeros(size96(1), size96(2), length(figlist), length(centers_x), length(centers_y));
[~,index] = sortrows({figlist.number}.'); figlist = figlist(index); 

for i = 1:length(figlist)
    fig=imread([directory, figlist(i).name]);
    for j = 1:length(centers_x)
        for k = 1:length(centers_y)
            
            wells(:,:,i,j,k) = fig(centers_y(k)-106/2+1:centers_y(k)+106/2,centers_x(j)-106/2+1:centers_x(j)+106/2, 1);
            
        end
    end
end
% now let us segment
freeze_num =zeros(length(centers_x),length(centers_y));
freeze_temp =zeros(length(centers_x),length(centers_y));

opts = delimitedTextImportOptions("NumVariables", fignum);
% let's first translate  commas rto dots because the one who decided upon
% commas is a moron
% Specify range and delimiter
unix(strcat("cat ",directory, tempfile," | tr ',' '.' >", directory,tempfile, "normal.csv"))
newtempname = strcat(tempfile,"normal.csv");
opts.DataLines = [1, 1];
opts.Delimiter = "\t";

opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";


temperatures_cells1 = readmatrix(strcat(directory, newtempname), opts);
for i = 1:fignum
    temperature_array(i) = str2double(temperatures_cells1{i});
end


for j = 1:length(centers_x)
   for k = 1:length(centers_y)
%             fprintf('Column %i out of %i: %4.2f%% ', j, length(centers_x), (j/length(centers_x))*100);
%             fprintf('Column %i out of %i: %4.2f%%\n', k, length(centers_y), (k/length(centers_y))*100);
            fprintf('Well %i out of %i: %4.2f%%\n', length(centers_y)*(j-1)+k, length(centers_y)*length(centers_x), (((j-1)*(length(centers_y))+k)/(length(centers_x)*length(centers_y)))*100);  
            [freeze_num(j,k), freeze_temp(j,k)]=pupi_run(squeeze(wells(:,:,:,j,k)), temperature_array, j, k);
            
            
   end
end
save(strcat(directory,'freezing_points.mat'), 'freeze_num', 'freeze_temp');
% 
%     for j = 1:length(centers_x)
%         for k = 1:length(centers_y)
%             
%             
%             imagebrowser(squeeze(wells(:,:,:,5,7)))
%         end
%     end
