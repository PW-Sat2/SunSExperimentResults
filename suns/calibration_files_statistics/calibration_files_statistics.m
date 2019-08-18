path = '..\lookup_table\calibration_evaluation_outputs\selected_best_based_on_raw_2';
listing = dir(path);

phi_fov_theta = 3:318;
theta_fov_theta = 18:81;

phi_fov_phi = 3:318;
theta_fov_phi = 18:81;

for i = 1:size(listing)
%     close all;
    if contains(listing(i).name, 'mat')
        
        load(strcat(path, '\', listing(i).name));
        
        if contains(listing(i).name, 'theta')
            err_x_cut = err_x(phi_fov_theta, theta_fov_theta);
            err_x_cut(isnan(err_x_cut)) = [];
            
            err_x_corrected = err_x_cut;
            
            %err_x_corrected(abs(err_x_corrected) > 50) = [];
            
            err_x_rms = rms(err_x_corrected(:));
            err_x_std = std(err_x_corrected(:));
            err_x_mean = mean(err_x_corrected(:));
            
%             figure();
%             hist(err_x_corrected(:), min(err_x_corrected(:)):0.5:max(err_x_corrected(:)))
%             title(listing(i).name);
%             xlim([err_x_mean-4*err_x_std, err_x_mean+4*err_x_std]);
            
            fprintf("%s;%f\n", listing(i).name, err_x_rms);            
        else
            err_y_cut = err_y(phi_fov_phi, theta_fov_phi);
            err_y_cut(isnan(err_y_cut)) = [];
            
            err_y_corrected = err_y_cut;
            
            err_y_corrected(abs(err_y_corrected) > 170) = [];
            
            err_y_rms = rms(err_y_corrected(:));
            err_y_std = std(err_y_corrected(:));
            err_y_mean = mean(err_y_corrected(:));
            
%             figure();
%             hist(err_y_corrected(:), min(err_y_corrected(:)):0.5:max(err_y_corrected(:)))
%             title(listing(i).name);
%             xlim([err_y_mean-4*err_y_std, err_y_mean+4*err_y_std]);
            
%             fprintf("%s;%f\n", listing(i).name, err_y_rms);            
        end
    end
end