% method is OK - should be used

clear all;
close all;

plot_hist = true
plot_points = false
plot_surf = false

path = '..\lookup_table\calibration_evaluation_outputs\selected_best_based_on_raw_3';
listing = dir(path);

phi_fov_theta = 2:320;
theta_fov_theta = 18:81;

phi_fov_phi = 2:320;
theta_fov_phi = 18:81;

ERROR_TO_COUNT = 5;

for i = 1:size(listing)
    if contains(listing(i).name, 'mat')
        
        load(strcat(path, '\', listing(i).name));
        
        file = listing(i).name;

        load(strcat(path, '\', file));
        x_reference = {all_results.true_array_x, reshape(all_results.all_x_results{1}, [321, 81]), reshape(all_results.all_x_results{2}, [321, 81]), reshape(all_results.all_x_results{3}, [321, 81])};
        y_reference = {all_results.true_array_y', reshape(all_results.all_y_results{1}, [321, 81]), reshape(all_results.all_y_results{2}, [321, 81]), reshape(all_results.all_y_results{3}, [321, 81])};

        ref_names = {'stand', 'ALS 1', 'ALS 2', 'ALS 3'};
        test_names = {'ALS 1', 'ALS 2', 'ALS 3'};

        for ref=1:4
            x_reference_array = x_reference{ref};
            y_reference_array = y_reference{ref};

            x_reference_array = x_reference_array(phi_fov_theta, theta_fov_theta);
            x_reference_array = x_reference_array(:);

            y_reference_array = y_reference_array(phi_fov_phi, theta_fov_phi);
            y_reference_array = y_reference_array(:);    

            for als=1:3
                x_results_array = reshape(all_results.all_x_results{als}, [321, 81]);
                y_results_array = reshape(all_results.all_y_results{als}, [321, 81]);

                x_results_array = x_results_array(phi_fov_theta, theta_fov_theta);
                x_results_array = x_results_array(:);

                y_results_array = y_results_array(phi_fov_phi, theta_fov_phi);
                y_results_array = y_results_array(:);

                    %close all;
                    [z_exp_1,y_exp_1,x_exp_1] = sph2cart(deg2rad(y_results_array), deg2rad(90-x_results_array), 1);
                    [z_ref,y_ref,x_ref] = sph2cart(deg2rad(y_reference_array), deg2rad(90-x_reference_array), 1);

                    % angular error between stand and suns exp
                    angular_error = [];
                    for d=1:size(z_exp_1, 1)
                        angular_error = [angular_error, rad2deg(subspace([z_exp_1(d);y_exp_1(d);x_exp_1(d)],[z_ref(d);y_ref(d);x_ref(d)]))];
                    end

                    if als+1 ~= ref
                        if plot_points
                            figure(); 
                            plot(angular_error, '*');
                            title(strcat(file, ': ', ref_names{ref}, ' - ', test_names{als}));
                            ylabel('Angular error (\circ)');
                            xlabel('Time (min)');
                            grid on;
                        end
                        
                        if plot_hist
                            figure(); 
                            if ref == 1
                                histogram(angular_error, 'BinWidth', 0.25);
                            else
                                histogram(angular_error, 'BinWidth', 1);
                            end
                            title(strcat(file, ': ', ref_names{ref}, ' - ', test_names{als}));
                            xlabel('Angular error (\circ)');
                            grid on;                            
                        end

                        angular_error_rms = mean(abs(angular_error));
                        count_errors = size(angular_error(angular_error > ERROR_TO_COUNT), 2);
                        fprintf("%s;%s;%s;%f;%d\n", file, ref_names{ref}, test_names{als}, angular_error_rms, count_errors);
                        
                        if plot_surf
                            figure();
                            surf(reshape(angular_error, [319, 64]));
                            title(strcat(file, ': ', ref_names{ref}, ' - ', test_names{als}));
                            colorbar
                            zlim([0, 2.5]);
                            view(0, 90);
                            caxis([0, 2.5]);
                            shading flat;
                        end
                    end
            end
        end
    end
end
