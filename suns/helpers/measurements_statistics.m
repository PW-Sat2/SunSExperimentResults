clear all;
close all;

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
         'sunsps10'};

for i = 1:size(files)
    path = strcat('..\combined_plots\suns_exp_and_ref_corrected_ref_range_4\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.mat');
    data = load(path);
%     close all;
    
    fi_als_stdev = [];
    for i=1:size(data.save_data.fi_als_1')
        fi_als_stdev = [fi_als_stdev, std([data.save_data.fi_als_1(i), data.save_data.fi_als_2(i), data.save_data.fi_als_3(i)])];
    end
    
    suns_ref_fi = data.save_data.suns_ref_fi;
    suns_ref_fi(isnan(suns_ref_fi)) = [];

    figure();
    hist(fi_als_stdev);
    %plot(data.save_data.timestamp_als_1, fi_als_stdev, '*')
%     plot(data.save_data.timestamp_als_1, data.save_data.fi_als_1-suns_ref_fi, '*')
    grid on;
    mean(fi_als_stdev)
%     std(data.save_data.fi_als_1-suns_ref_fi)
    
    theta_als_stdev = [];
    for i=1:size(data.save_data.theta_als_1')
        theta_als_stdev = [theta_als_stdev, std([data.save_data.theta_als_1(i), data.save_data.theta_als_2(i), data.save_data.theta_als_3(i)])];
    end
    
    suns_ref_theta = data.save_data.suns_ref_theta;
    suns_ref_theta(isnan(suns_ref_theta)) = [];

%     figure();
%     plot(data.save_data.timestamp_als_1, theta_als_stdev, '*')
%     plot(data.save_data.timestamp_als_1, data.save_data.theta_als_1-suns_ref_theta, '*')
%     hist(theta_als_stdev)
%     grid on;
%     mean(theta_als_stdev)
%     std(data.save_data.theta_als_1-suns_ref_theta)
end