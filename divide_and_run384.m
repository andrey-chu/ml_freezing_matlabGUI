clear all;
close all;
clc;
cwd = pwd;
directory ='/data/Freezing_samples/Test384Bakterie_1/';
cd(directory)
figlist = dir('*PNG');
tempfile = 'Temperatur/Test_384_-_Bakterie_1.csv';
cd(pwd)
fig1=imread([directory, figlist(1).name]);%extract experiment name and sort
size_wells = 384;
size384 = [52, 52];
start384 = [40, 40];
fignum =length(figlist);

for i = 1:length(figlist)
   name_split = split(figlist(i).name, {'_','.'});
   figlist(i).number = str2num(name_split{7});
end
% centers_x = (38+42/2):52:1340;
% centers_y = (38+42/2):52:900;

centers_x = 60:53:1300;
centers_y = 60:52:860;



wells = zeros(size384(1), size384(2), length(figlist), length(centers_x), length(centers_y));
[~,index] = sortrows({figlist.number}.'); figlist = figlist(index); 

for i = 1:length(figlist)
    fig=imread([directory, figlist(i).name]);
    for j = 1:length(centers_x)
        for k = 1:length(centers_y)
            
            wells(:,:,i,j,k) = fig(round(centers_y(k)-52/2+1-j*0.5):round(centers_y(k)+52/2-j*0.5),round(centers_x(j)-53/2+2):round(centers_x(j)+53/2), 1);
            
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
