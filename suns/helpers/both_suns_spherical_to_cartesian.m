clear all;

files = {'suns1'
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
         'sunsps10'};
     
%numel(files)
for i = 1:numel(files)
    files{i}
    data = load(strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.mat'));
    close all;
    [z_exp_1,y_exp_1,x_exp_1] = sph2cart(deg2rad(data.save_data.fi_als_1), deg2rad(90-data.save_data.theta_als_1), 1);
    [z_exp_2,y_exp_2,x_exp_2] = sph2cart(deg2rad(data.save_data.fi_als_2), deg2rad(90-data.save_data.theta_als_2), 1);
    [z_exp_3,y_exp_3,x_exp_3] = sph2cart(deg2rad(data.save_data.fi_als_3), deg2rad(90-data.save_data.theta_als_3), 1);

    [z_ref,y_ref,x_ref] = sph2cart(deg2rad(data.save_data.suns_ref_fi), deg2rad(90-data.save_data.suns_ref_theta), 1);
    
%     f = figure('Renderer', 'painters', 'Position', [10 10 1200 900]);
    figure();
    subplot(3, 1, 1);
    title(strcat('SunS Ref and exp cartesian ', files{i})); 
    hold on;
    plot(data.save_data.suns_ref_timestamp, x_ref, '.');
    plot(data.save_data.timestamp_als_1/60, (x_exp_1), '.');
    plot(data.save_data.timestamp_als_2/60, (x_exp_2), '.');
    plot(data.save_data.timestamp_als_3/60, (x_exp_3), '.');
    legend('X Ref', 'X Exp ALS 1', 'X Exp ALS 2', 'X Exp ALS 3', 'Location', 'Best');
    grid on;
    ylabel('X coordinate');
    xlabel('Time (min)');
    
    subplot(3, 1, 2);
    hold on;
    title(strcat('SunS Ref and exp cartesian ', files{i})); 
    plot(data.save_data.suns_ref_timestamp, y_ref, '.');
    plot(data.save_data.timestamp_als_1/60, (y_exp_1), '.');
    plot(data.save_data.timestamp_als_2/60, (y_exp_2), '.');
    plot(data.save_data.timestamp_als_3/60, (y_exp_3), '.');
    legend('Y Ref', 'Y Exp ALS 1', 'Y Exp ALS 2', 'Y Exp ALS 3', 'Location', 'Best');
    grid on;
    ylabel('Y coordinate');
    xlabel('Time (min)');
    
    subplot(3, 1, 3);
    hold on;
    title(strcat('SunS Ref and exp cartesian ', files{i})); 
    plot(data.save_data.suns_ref_timestamp, z_ref, '.');
    plot(data.save_data.timestamp_als_1/60, (z_exp_1), '.');
    plot(data.save_data.timestamp_als_2/60, (z_exp_2), '.');
    plot(data.save_data.timestamp_als_3/60, (z_exp_3), '.');
    legend('Z Ref', 'Z Exp ALS 1', 'Z Exp ALS 2', 'Z Exp ALS 3', 'Location', 'Best');
    grid on;
    ylabel('Z coordinate');
    xlabel('Time (min)');
    
    hold on;
%     
%     mkdir(strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}));
%     print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.png'),'-dpng','-r600');
%     
%     all_results.timestamp_als_1 = data.save_data.timestamp_als_1;
%     all_results.timestamp_als_2 = data.save_data.timestamp_als_2;
%     all_results.timestamp_als_3 = data.save_data.timestamp_als_3;
%     
%     all_results.suns_exp_z_als_1 = (z_exp_1);
%     all_results.suns_exp_z_als_2 = (z_exp_2);
%     all_results.suns_exp_z_als_3 = (z_exp_3);
%     
%     all_results.suns_exp_y_als_1 = (y_exp_1);
%     all_results.suns_exp_y_als_2 = (y_exp_2);
%     all_results.suns_exp_y_als_3 = (y_exp_3);
%     
%     all_results.suns_exp_x_als_1 = (x_exp_1);
%     all_results.suns_exp_x_als_2 = (x_exp_2);
%     all_results.suns_exp_x_als_3 = (x_exp_3);
%     
%     all_results.timestamp_suns_ref = data.save_data.suns_ref_timestamp;
%     all_results.suns_ref_x = x_ref;
%     all_results.suns_ref_y = y_ref;
%     all_results.suns_ref_z = z_ref;
%     
%     save(strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.mat'), 'all_results');
end