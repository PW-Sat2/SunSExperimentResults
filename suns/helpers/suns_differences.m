clear all;
close all;

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

files = {
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
    load(strcat('../combined_plots/suns_exp_and_ref_corrected_ref_range_4/', folders{i}, '/', files{i}, '_suns_exp_ref_corrected.mat'));
    
    all_als_data_fi = [];
    all_als_data_fi(:, 1) = save_data.fi_als_1;
    all_als_data_fi(:, 2) = save_data.fi_als_2;
    all_als_data_fi(:, 3) = save_data.fi_als_3;
    between_als_fi = std(all_als_data_fi, 0, 2);
    
    overall_rms_fi = rms(between_als_fi);
    
%     figure
%     plot(save_data.timestamp_als_1/60, between_als_fi, '*')
%     grid on
    
    %%%%%
    
    all_als_data_theta = [];
    all_als_data_theta(:, 1) = save_data.theta_als_1;
    all_als_data_theta(:, 2) = save_data.theta_als_2;
    all_als_data_theta(:, 3) = save_data.theta_als_3;
    between_als_theta = std(all_als_data_theta, 0, 2);
    
%     figure
%     plot(save_data.timestamp_als_1/60, between_als_theta, '*')
%     grid on
    
    overall_rms_theta = rms(between_als_theta);
    fprintf("%s;%f;%f\n", files{i}, overall_rms_theta, overall_rms_fi);    
    
end
