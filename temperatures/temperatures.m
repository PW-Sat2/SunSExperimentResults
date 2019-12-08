clear all;
close all;

datanames = {
%          'suns1'
%          'suns2'
%          'suns3_time_corrected'
%          'suns4'
%          'suns5'
%          'suns6'
%          'suns7'
%          'suns8'
%          'sunsps1'
%          'sunsps2'
%          'sunsps3'
%          'sunsps4'
%          'sunsps5'
%          'sunsps6'
%          'sunsps7'
%          'sunsps8'
%          'sunsps9'
         'sunsps10'};

for k=1:length(datanames)
    dataname = datanames{k}
    load(strcat('..\experiment_data\matlab\', dataname, '.mat'));

    temp = figure('Renderer', 'painters', 'Position', [10 10 1200 900]);
    
    ylabel('Temperature [°C]');
    xlabel('Time [min]');
    hold on;
    plot(suns.timestamp/60, suns.SunStemperature_a, '.-');
    plot(suns.timestamp/60, suns.SunStemperature_b, '.-');
    plot(suns.timestamp/60, suns.SunStemperature_c, '.-');
    plot(suns.timestamp/60, suns.SunStemperature_d, '.-');
    plot(suns.timestamp/60, suns.SunStemperature_structure, '.-');
    legend('Panel A', 'Panel B', 'Panel C', 'Panel D', 'Main PCB', 'Location', 'best');
    grid on;
    
    print(temp,strcat('outputs/', '/temperatures-', dataname, '.pdf'),'-dpdf','-bestfit');
    title(strcat('Temperature ALS panels: ', dataname));
    
    print(temp,strcat('outputs/', '/temperatures-', dataname, '.png'),'-dpng','-r600');
    
    close all;

end