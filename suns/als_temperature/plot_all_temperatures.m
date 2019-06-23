clear all;
close all;

files = {'suns1',
         'suns2',
         'suns3_time_corrected',
         'suns4',
         'suns5',
         'suns6',
         'suns7',
         'suns8',
         'sunsps1',
         'sunsps2',
         'sunsps3',
         'sunsps4',
         'sunsps5',
         'sunsps6',
         'sunsps7'};

figure;     
hold on;
title('SunS Exp ALS Temperatures')
xlabel('Time (min)')
ylabel('Temperature (\circC)')
grid on
for i = 15:15
    load(strcat('..\..\experiment_data\matlab\', files{i}, '.mat'));
    plot(suns.timestamp/60, suns.SunStemperature_a, '*');
    plot(suns.timestamp/60, suns.SunStemperature_b, '*');
    plot(suns.timestamp/60, suns.SunStemperature_c, '*');
    plot(suns.timestamp/60, suns.SunStemperature_d, '*');
end

% 
% figure;     
% hold on;
% title('SunS Exp Structure Temperatures')
% xlabel('Time (min)')
% ylabel('Temperature (\circC)')
% grid on
% for i = 1:numel(files)
%     load(strcat('..\..\experiment_data\matlab\', files{i}, '.mat'));
%     plot(suns.timestamp/60, suns.SunStemperature_structure, '*');
% end