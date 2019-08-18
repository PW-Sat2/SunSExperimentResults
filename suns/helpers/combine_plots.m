clear all;
close all;

files_ref = {
    'suns1_suns_ref'
    'suns2_suns_ref'
    'suns3_time_corrected_suns_ref'
    'suns4_suns_ref'
    'suns5_suns_ref'
    'suns6_suns_ref'
    'suns7_suns_ref'
    'suns8_suns_ref'
    'sunsps1_suns_ref'
    'sunsps2_suns_ref'
    'sunsps3_suns_ref'
    'sunsps4_suns_ref'
    'sunsps5_suns_ref'
    'sunsps6_suns_ref'
    'sunsps7_suns_ref'
    'sunsps8_suns_ref'
    'sunsps9_suns_ref'
    'sunsps10_suns_ref'
         };
     
files_exp = {
    'suns1_suns_exp'
    'suns2_suns_exp'
    'suns3_time_corrected_suns_exp'
    'suns4_suns_exp'
    'suns5_suns_exp'
    'suns6_suns_exp'
    'suns7_suns_exp'
    'suns8_suns_exp'
    'sunsps1_suns_exp'
    'sunsps2_suns_exp'
    'sunsps3_suns_exp'
    'sunsps4_suns_exp'
    'sunsps5_suns_exp'
    'sunsps6_suns_exp'
    'sunsps7_suns_exp'
    'sunsps8_suns_exp'
    'sunsps9_suns_exp'
    'sunsps10_suns_exp'
};

folders = {
    'suns1'
    'suns2'
    'suns3_time_corrected'
    'suns4'
    'suns5'
    'suns6'
    'suns7'
    'suns8'
    'sunsps1'
    'sunsps2'
    'sunsps3'
    'sunsps4'
    'sunsps5'
    'sunsps6'
    'sunsps7'
    'sunsps8'
    'sunsps9'
    'sunsps10'
    }; 

legend_items = {'SunS Exp ALS 1', 'SunS Exp ALS 2', 'SunS Exp ALS 3', 'SunS Ref'};
     
for i=1:numel(folders)
    load(strcat('../suns_ref/outputs/', folders{i}, '/', files_ref{i}, '.mat'));
    load(strcat('../lookup_table/outputs/', folders{i}, '/', files_exp{i}, '.mat'));
    
    mkdir(strcat('..\combined_plots\suns_exp_and_ref_not_corrected\', folders{i}));
    
    f = figure;
    plot(suns_exp.timestamp_als_1, suns_exp.theta_als_1, '*');
    hold on;
    plot(suns_exp.timestamp_als_2, suns_exp.theta_als_2, '*');
    plot(suns_exp.timestamp_als_3, suns_exp.theta_als_3, '*');
    plot(suns_ref.timestamp, suns_ref.suns_ref_theta, '*');
    title(strcat('SunS Exp + Ref (not corrected) - Theta - ', folders{i}));
    legend(legend_items, 'Location', 'Best');
    ylabel('Theta Angle (\circ)');
    xlabel('Time (min)');
    grid on;
    saveas(f, strcat('..\combined_plots\suns_exp_and_ref_not_corrected\', folders{i}, '\', folders{i}, '_suns_exp_ref_not_corrected_theta.png'));

    
    close all;
    
    f = figure;
    plot(suns_exp.timestamp_als_1, suns_exp.fi_als_1, '*');
    hold on;
    plot(suns_exp.timestamp_als_2, suns_exp.fi_als_2, '*');
    plot(suns_exp.timestamp_als_3, suns_exp.fi_als_3, '*');
    plot(suns_ref.timestamp, suns_ref.suns_ref_fi, '*');
    title(strcat('SunS Exp + Ref  (not corrected) - Fi - ', folders{i}));
    legend(legend_items, 'Location', 'Best');
    ylabel('Fi Angle (\circ)');
    xlabel('Time (min)');
    saveas(f, strcat('..\combined_plots\suns_exp_and_ref_not_corrected\', folders{i}, '\', folders{i}, '_suns_exp_ref_not_corrected_fi.png'));
    close all;
    
    all_data.timestamp_als_1 = suns_exp.timestamp_als_1;
    all_data.timestamp_als_2 = suns_exp.timestamp_als_2;
    all_data.timestamp_als_3 = suns_exp.timestamp_als_3;

    all_data.fi_als_1 = suns_exp.fi_als_1;
    all_data.fi_als_2 = suns_exp.fi_als_2;
    all_data.fi_als_3 = suns_exp.fi_als_3;
    
    all_data.theta_als_1 = suns_exp.theta_als_1;
    all_data.theta_als_2 = suns_exp.theta_als_2;
    all_data.theta_als_3 = suns_exp.theta_als_3;
    
    all_data.suns_ref_timestamp = suns_ref.timestamp;
    all_data.suns_ref_theta = suns_ref.suns_ref_theta;
    all_data.suns_ref_fi = suns_ref.suns_ref_fi;
    
    save(strcat('..\combined_plots\suns_exp_and_ref_not_corrected\', folders{i}, '\', folders{i}, '_suns_exp_ref_not_corrected.mat'), 'all_data');
end
