function [freezing_num, freezing_temp]=pupi_run(data_mat, temp_mat, a, b)
% data_mat = zeros(128,128,30);
% temp_mat = -1:-1:-30;
% a = 1;
% b =10;
% f = figure;
aa=imgbr3(data_mat, temp_mat, a, b);
waitfor(aa);
% uiwait(gcf)
freezing_num = evalin('base', 'UI_return_num');
freezing_temp = evalin('base', 'UI_return_temp');
end