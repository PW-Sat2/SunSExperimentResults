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
%numel(files)
for i = 5:5
    load(strcat('../lookup_table/outputs/', files{i}, '/', files{i}, '_suns_exp.mat'));
    
    [z,y,x] = sph2cart(deg2rad(suns_exp.fi_als_1), deg2rad(suns_exp.theta_als_1), 1);

    f = figure;
    title(strcat('SunS Exp cartesian ', files{i})); 
    subplot(3, 1, 1);
    plot(suns_exp.timestamp_als_1, rad2deg(x), '.');
    legend('X');
    
    subplot(3, 1, 2);
    plot(suns_exp.timestamp_als_1, rad2deg(y), '.', 'Color', 'r');
    legend('Y');
    
    subplot(3, 1, 3);
    plot(suns_exp.timestamp_als_1, rad2deg(z), '.', 'Color', 'g');
    legend('Z');
end