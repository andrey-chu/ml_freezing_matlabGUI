close all;
clear all;
clc;

dirs384 = {'/data/Freezing_samples/Test384Bakterie_1/', '/data/Freezing_samples/Test384Vand_1/'};
temps384 = {'Temperatur/Test_384_-_Bakterie_1.csv', 'Temperatur/Test_384_-_Vand_1.csv'};

dirs96 = {'/data/Freezing_samples/Test96Bakterie_1/', '/data/Freezing_samples/Test96Bakterie_2/','/data/Freezing_samples/Test96Vand_1/'};
temps96 = {'Temperatur/Test_96_-_Bakterie_1.csv', 'Temperatur/Test_96_-_Bakterie_2.csv', 'Temperatur/Test_96_-_Vand_1.csv'};
for i = 1:2
    save_wells_384_images(dirs384{i});
end

% for i = 3
%     divide_and_run96_function_v3(dirs96{i}, temps96{i});
% end