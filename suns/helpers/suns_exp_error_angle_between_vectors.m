%%% STATUS: OK, working properly, must be used!

clear all;
close all;

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
     
ref_range = 1
ERROR_TO_COUNT = 5
CUT_ANGULAR_ERROR = 80
ALS_between_ALS = 1

error_of_all_times = [];
error_of_all_times_als = [];

%numel(files)
for i = 1:numel(files)
%     files{i}

%     data = load(strcat('..\combined_plots\suns_exp_and_ref_corrected_all_range_3\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.mat'));
    data = load(strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.mat'));
%      data = load(strcat('..\combined_plots\suns_exp_and_ref_corrected_generated_3\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.mat'));
    
    %close all;
    
    mkdir(strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\'));
    
    [z_exp_1,y_exp_1,x_exp_1] = sph2cart(deg2rad(data.save_data.fi_als_1), deg2rad(90-data.save_data.theta_als_1), 1);
    [z_exp_2,y_exp_2,x_exp_2] = sph2cart(deg2rad(data.save_data.fi_als_2), deg2rad(90-data.save_data.theta_als_2), 1);
    [z_exp_3,y_exp_3,x_exp_3] = sph2cart(deg2rad(data.save_data.fi_als_3), deg2rad(90-data.save_data.theta_als_3), 1);

    if ref_range
        [z_ref,y_ref,x_ref] = sph2cart(deg2rad(data.save_data.suns_ref_fi), deg2rad(90-data.save_data.suns_ref_theta), 1);
        z_ref(isnan(z_ref)) = [];
        y_ref(isnan(y_ref)) = [];
        x_ref(isnan(x_ref)) = [];

        % angular error between suns ref and suns exp
        angular_error = [];
        for d=1:size(z_exp_1, 2)

            Va = [z_exp_1(d);y_exp_1(d);x_exp_1(d)];
            Vb = [z_ref(d);y_ref(d);x_ref(d)];
            
%             atan2(dot(cross(Vb, Va), 1), dot(Va, Vb));
            ae = acos(dot(Va, Vb));

            
            angular_error = [angular_error, rad2deg(ae)];
        end

        f = figure('Renderer', 'painters', 'Position', [10 10 1600 1000]); 
        plot(data.save_data.timestamp_als_1/60, angular_error, '*');
        title(strcat(files{i}, " - angular error ALS 1 vs. SunS Ref"));
        ylabel('Angular error (\circ)');
        xlabel('Time (min)');
        grid on;
        error_of_all_times = [error_of_all_times, angular_error];
        savefig(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs SunS Ref.fig'));        
        print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs SunS Ref.png'),'-dpng','-r600');
%         figure();
%         angular_error(angular_error > CUT_ANGULAR_ERROR) = [];
%         histogram(angular_error, 'BinWidth', 1);   
%         title(strcat(files{i}, " - angular error ALS 1 vs. SunS Ref"));

        angular_error_mean = mean(abs(angular_error));
        angular_error_std = std(angular_error);
        
        count_angular_error = size(angular_error(angular_error > angular_error_mean), 2);
        fprintf("ref;als1;%s;%f;%f;%d;%d\n", files{i}, angular_error_mean, angular_error_std, count_angular_error, size(z_exp_1, 2));

    end
    
    if ALS_between_ALS
        % angular error between suns exp ALS 1 and suns exp ALS 2
        angular_error = [];
        for d=1:size(z_exp_1, 2)
            angular_error = [angular_error, rad2deg(subspace([z_exp_1(d);y_exp_1(d);x_exp_1(d)],[z_exp_2(d);y_exp_2(d);x_exp_2(d)]))];
        end

        f = figure('Renderer', 'painters', 'Position', [10 10 1600 1000]);
        plot(data.save_data.timestamp_als_1/60, angular_error, '*');
        title(strcat(files{i}, " - angular error ALS 1 vs. ALS 2"));
        ylabel('Angular error (\circ)');
        xlabel('Time (min)');
        grid on;
        error_of_all_times_als = [error_of_all_times_als, angular_error];
        savefig(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs ALS 2.fig'));        
        print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs ALS 2.png'),'-dpng','-r600');

        figure(); 
        angular_error(angular_error > CUT_ANGULAR_ERROR) = []; histogram(angular_error, 'BinWidth', 1);  
        title(strcat(files{i}, " - angular error ALS 1 vs. ALS 2"));

        angular_error_mean = mean(abs(angular_error));
        angular_error_std = std(angular_error);

        count_angular_error = size(angular_error(angular_error > angular_error_mean), 2);
        fprintf("als1;als2;%s;%f;%f;%d;%d\n", files{i}, angular_error_mean, angular_error_std, count_angular_error, size(z_exp_1, 2));

        % angular error between suns exp ALS 1 and suns exp ALS 3
        angular_error = [];
        for d=1:size(z_exp_1, 2)
            angular_error = [angular_error, rad2deg(subspace([z_exp_1(d);y_exp_1(d);x_exp_1(d)],[z_exp_3(d);y_exp_3(d);x_exp_3(d)]))];
        end

        f = figure('Renderer', 'painters', 'Position', [10 10 1600 1000]);
        plot(data.save_data.timestamp_als_1/60, angular_error, '*');
        title(strcat(files{i}, " - angular error ALS 1 vs. ALS 3"));
        ylabel('Angular error (\circ)');
        xlabel('Time (min)');
        grid on;
        
        savefig(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs ALS 3.fig'));        
        print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs ALS 3.png'),'-dpng','-r600');

        figure(); 
        angular_error(angular_error > CUT_ANGULAR_ERROR) = []; histogram(angular_error, 'BinWidth', 1);    
        title(strcat(files{i}, " - angular error ALS 1 vs. ALS 3"));
        
        angular_error_mean = mean(abs(angular_error));
        angular_error_std = std(angular_error);

        count_angular_error = size(angular_error(angular_error > angular_error_mean), 2);
        fprintf("als1;als3;%s;%f;%f;%d;%d\n", files{i}, angular_error_mean, angular_error_std, count_angular_error, size(z_exp_1, 2));

        % angular error between suns exp ALS 2 and suns exp ALS 3
        angular_error = [];
        for d=1:size(z_exp_1, 2)
            angular_error = [angular_error, rad2deg(subspace([z_exp_2(d);y_exp_2(d);x_exp_2(d)],[z_exp_3(d);y_exp_3(d);x_exp_3(d)]))];
        end

        f = figure('Renderer', 'painters', 'Position', [10 10 1600 1000]); 
        plot(data.save_data.timestamp_als_1/60, angular_error, '*');
        title(strcat(files{i}, " - angular error ALS 2 vs. ALS 3"));
        ylabel('Angular error (\circ)');
        xlabel('Time (min)');
        grid on;
        
        savefig(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs ALS 3.fig'));        
        print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4_errors\', files{i}, '\', files{i}, ' - angular error ALS 1 vs ALS 3.png'),'-dpng','-r600');
        

        figure(); 
        angular_error(angular_error > CUT_ANGULAR_ERROR) = []; histogram(angular_error, 'BinWidth', 1);
        title(strcat(files{i}, " - angular error ALS 2 vs. ALS 3"));


        angular_error_mean = mean(abs(angular_error));
        angular_error_std = std(angular_error);

        count_angular_error = size(angular_error(angular_error > angular_error_mean), 2);
        fprintf("als2;als3;%s;%f;%f;%d;%d\n", files{i}, angular_error_mean, angular_error_std, count_angular_error, size(z_exp_1, 2));
    end

% %     f = figure('Renderer', 'painters', 'Position', [10 10 1200 900]);
%     figure();
%     subplot(3, 1, 1);
%     title(strcat('SunS Ref and exp cartesian ', files{i})); 
%     hold on;
%     plot(data.save_data.suns_ref_timestamp, x_ref, '.');
%     plot(data.save_data.timestamp_als_1/60, (x_exp_1), '.');
%     plot(data.save_data.timestamp_als_2/60, (x_exp_2), '.');
%     plot(data.save_data.timestamp_als_3/60, (x_exp_3), '.');
%     legend('X Ref', 'X Exp ALS 1', 'X Exp ALS 2', 'X Exp ALS 3', 'Location', 'Best');
%     grid on;
%     ylabel('X coordinate');
%     xlabel('Time (min)');
%     
%     subplot(3, 1, 2);
%     hold on;
%     title(strcat('SunS Ref and exp cartesian ', files{i})); 
%     plot(data.save_data.suns_ref_timestamp, y_ref, '.');
%     plot(data.save_data.timestamp_als_1/60, (y_exp_1), '.');
%     plot(data.save_data.timestamp_als_2/60, (y_exp_2), '.');
%     plot(data.save_data.timestamp_als_3/60, (y_exp_3), '.');
%     legend('Y Ref', 'Y Exp ALS 1', 'Y Exp ALS 2', 'Y Exp ALS 3', 'Location', 'Best');
%     grid on;
%     ylabel('Y coordinate');
%     xlabel('Time (min)');
%     
%     subplot(3, 1, 3);
%     hold on;
%     title(strcat('SunS Ref and exp cartesian ', files{i})); 
%     plot(data.save_data.suns_ref_timestamp, z_ref, '.');
%     plot(data.save_data.timestamp_als_1/60, (z_exp_1), '.');
%     plot(data.save_data.timestamp_als_2/60, (z_exp_2), '.');
%     plot(data.save_data.timestamp_als_3/60, (z_exp_3), '.');
%     legend('Z Ref', 'Z Exp ALS 1', 'Z Exp ALS 2', 'Z Exp ALS 3', 'Location', 'Best');
%     grid on;
%     ylabel('Z coordinate');
%     xlabel('Time (min)');
%     
%     hold on;
% %     
%     mkdir(strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}));
%     print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.png'),'-dpng','-r600');
%     
%     all_results.timestamp_als_1 = data.save_data.timestamp_als_1/60;
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

figure();
error_of_all_times(error_of_all_times > CUT_ANGULAR_ERROR) = [];
histogram(error_of_all_times, 'BinWidth', 1, 'Normalization', 'Probability');   
title("ALL TIMES angular error ALS 1 vs. SunS Ref");
xlabel('Angular error (\circ)');
ylabel('Probability');
grid on

figure();
error_of_all_times(error_of_all_times_als > CUT_ANGULAR_ERROR) = [];
histogram(error_of_all_times_als, 'BinWidth', 0.5, 'Normalization', 'Probability');   
title("ALL TIMES angular error ALS 1 vs. ALS 2");
xlabel('Angular error (\circ)');
ylabel('Probability');
grid on

angular_error_mean = mean(abs(error_of_all_times_als))
angular_error_std = std(error_of_all_times_als)