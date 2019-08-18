clear all;

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
     
%numel(files)
for jj = 1:numel(files)
    files{jj}
    
    load(strcat('..\combined_plots\suns_exp_and_ref_corrected_all_range_3\', files{jj}, '/', files{jj}, '_suns_exp_ref_corrected.mat'));
    %load(strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4\', files{jj}, '/', files{jj}, '_suns_exp_ref_corrected.mat'));
    load(strcat('..\..\experiment_data\matlab\', '\', files{jj}, '.mat'));

    multiplot = figure('Renderer', 'painters', 'Position', [10 10 900 1200]);
   
    subplot(4,1,1);
    
    plot(save_data.timestamp_als_1/60, save_data.fi_als_1, '*');
    title(files{jj})
    hold on;
    plot(save_data.timestamp_als_2/60, save_data.fi_als_2, '*');
    plot(save_data.timestamp_als_3/60, save_data.fi_als_3, '*');
    
    plot(save_data.suns_ref_timestamp, save_data.suns_ref_fi, '*');
    
    grid on;
    xlim([0, max(save_data.suns_ref_timestamp)]);
    ylim([min(save_data.fi_als_1), max(save_data.fi_als_1)]);
%     legend('ALS 1', 'ALS 2', 'ALS 3', 'Ref');
    
    
    subplot(4,1,2);
    plot(save_data.timestamp_als_1/60, save_data.theta_als_1, '*');
    hold on;
    plot(save_data.timestamp_als_2/60, save_data.theta_als_2, '*');
    plot(save_data.timestamp_als_3/60, save_data.theta_als_3, '*');
    
    plot(save_data.suns_ref_timestamp, save_data.suns_ref_theta, '*');
    grid on;
    xlim([0, max(save_data.suns_ref_timestamp)]);
    ylim([min(save_data.theta_als_1), max(save_data.theta_als_1)]);
%     legend('ALS 1', 'ALS 2', 'ALS 3', 'Ref');
    
    
    subplot(4,1,3);
    plot(suns.timestamp/60, suns.ALSVL1A, '.-');
    hold on;
    plot(suns.timestamp/60, suns.ALSVL1C, '.-');
    grid on;
    xlim([0, max(save_data.suns_ref_timestamp)]);
    
    subplot(4,1,4);
    plot(suns.timestamp/60, suns.ALSVL1B, '.-');
    hold on;
    plot(suns.timestamp/60, suns.ALSVL1D, '.-');
    grid on;
    xlim([0, max(save_data.suns_ref_timestamp)]);
    
end
