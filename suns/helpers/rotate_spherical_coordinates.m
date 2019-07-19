clear all;

files = {
%          'suns1',
%          'suns2',
%          'suns3_time_corrected',
%          'suns4',
%          'suns5',
%          'suns6',
%          'suns7',
%          'suns8',
%          'sunsps1',
%          'sunsps2',
%          'sunsps3',
%          'sunsps4',
%          'sunsps5',
%          'sunsps6',
%          'sunsps7',
%          'sunsps8',
         'sunsps9'};
     
%numel(files)
for jj = 1:numel(files)
    files{jj}
    load(strcat('..\combined_plots\suns_exp_and_ref_not_corrected\', files{jj}, '/', files{jj}, '_suns_exp_ref_not_corrected.mat'));
    
    theta_all = deg2rad((all_data.suns_ref_theta));
    fi_all = deg2rad(all_data.suns_ref_fi);
    alpha = deg2rad(-15);

    timestamp_theta = [];
    theta_prim = [];
    fi_prim = [];
    for x=1:size(theta_all)
        theta = theta_all(x);
        if theta ~= NaN
            timestamp_theta = [timestamp_theta, all_data.suns_ref_timestamp(x)/60];
            fi = fi_all(x);
            psi = [cos(theta/2), exp(i*fi)*sin(theta/2)];

            R = [cos(alpha/2), -i*sin(alpha/2); -i*sin(alpha/2), cos(alpha/2)];
            %R = [cos(alpha/2), -sin(alpha/2); sin(alpha/2), cos(alpha/2)];
            %R = [exp(-i*alpha/2), 0; 0, exp(i*alpha/2)];

            psi_prim = R*psi';
            theta_prim = [theta_prim, 2*atan2(abs(psi_prim(2)), abs(psi_prim(1)))];
            fi_temp = -angle(psi_prim(2))-angle(psi_prim(1));

            if fi_temp < 0
                fi_prim = [fi_prim, fi_temp + 2*pi];
            else
                fi_prim = [fi_prim, fi_temp];
            end
        end
        
    end
    
    mkdir(strcat('..\combined_plots\suns_exp_and_ref_corrected\', files{jj}, '\'));

    %close all;
    save_data = all_data;
    save_data.suns_ref_timestamp = timestamp_theta;
    save_data.suns_ref_theta = rad2deg(theta_prim);
    save_data.suns_ref_fi = rad2deg(fi_prim);
    save(strcat('..\combined_plots\suns_exp_and_ref_corrected\', files{jj}, '\', files{jj}, '_suns_exp_ref_corrected.mat'));
    
    f = figure('Renderer', 'painters', 'Position', [10 10 1600 1000]);
    hold on;
    plot(all_data.timestamp_als_1/60, (all_data.theta_als_1), '*');
    plot(all_data.timestamp_als_2/60, (all_data.theta_als_2), '*');
    plot(all_data.timestamp_als_3/60, (all_data.theta_als_3), '*');

    %plot(all_data.suns_ref_timestamp, rad2deg(theta_all), '*');
    plot(timestamp_theta, rad2deg(theta_prim), '*');
    
    title(strcat(files{jj}, ' - Theta (elevation)'));
    grid on;
    legend('SunS Exp ALS 1', 'SunS Exp ALS 2', 'SunS Exp ALS 3', 'Sun Ref', 'Location', 'Best');
    ylabel('Angle (\circ)');
    xlabel('Time (min)');
    
    print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected\', files{jj}, '\', files{jj}, '_suns_exp_ref_corrected_theta.png'),'-dpng','-r600');
    
    savefig(f, strcat('..\combined_plots\suns_exp_and_ref_corrected\', files{jj}, '\', files{jj}, '_suns_exp_ref_corrected_theta.fig'));

    f = figure('Renderer', 'painters', 'Position', [10 10 1600 1000]);
    %plot(all_data.suns_ref_timestamp, rad2deg(fi_prim), '.');
    hold on;
    plot(all_data.timestamp_als_1/60, all_data.fi_als_1, '*');
    plot(all_data.timestamp_als_2/60, all_data.fi_als_2, '*');
    plot(all_data.timestamp_als_3/60, all_data.fi_als_3, '*');

    %plot(all_data.suns_ref_timestamp/60, rad2deg(fi_all), '*');
    plot(all_data.suns_ref_timestamp/60, rad2deg(fi_prim), '*');
    title(strcat(files{jj}, ' - Phi (azimuth)'));
    grid on;
    legend('SunS Exp ALS 1', 'SunS Exp ALS 2', 'SunS Exp ALS 3', 'Sun Ref', 'Location', 'Best');
    ylabel('Angle (\circ)');
    xlabel('Time (min)');
    print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected\', files{jj}, '\', files{jj}, '_suns_exp_ref_corrected_fi.png'),'-dpng','-r600');
    
    savefig(f, strcat('..\combined_plots\suns_exp_and_ref_corrected\', files{jj}, '\', files{jj}, '_suns_exp_ref_corrected_fi.fig'));

    %close all;

end
