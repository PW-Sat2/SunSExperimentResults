function [] = angle_from_calibration(folder_ref, calibration_file_ref, folder_test, calibration_file_test)

test_calibration_file = load(strcat('..\..\experiment_data\matlab\calibration_data\', folder_ref, '\', calibration_file_ref, '.mat'));

% load calibration under tests
reference_calibration_file = load(strcat('..\..\experiment_data\matlab\calibration_data\', folder_test, '\', calibration_file_test, '.mat'));

als_x = {reference_calibration_file.Data.valueVisNormalized(:, :, 1), reference_calibration_file.Data.valueVisNormalized(:, :, 3), reference_calibration_file.Data.valueVisNormalized(:, :, 5)};
als_y = {reference_calibration_file.Data.valueVisNormalized(:, :, 2), reference_calibration_file.Data.valueVisNormalized(:, :, 4), reference_calibration_file.Data.valueVisNormalized(:, :, 6)};

uncertainties_1 = [];
uncertainties_2 = [];
uncertainties_3 = [];
all_uncertainties = {uncertainties_1, uncertainties_2, uncertainties_3};

uncertainties_sums_1 = [];
uncertainties_sums_2 = [];
uncertainties_sums_3 = [];
all_uncertainties_sums = {uncertainties_sums_1, uncertainties_sums_2, uncertainties_sums_3};

x_results_1 = [];
x_results_2 = [];
x_results_3 = [];
all_x_results = {x_results_1, x_results_2, x_results_3};

y_results_1 = [];
y_results_2 = [];
y_results_3 = [];

calib_step = 1.125/4;
all_y_results = {y_results_1, y_results_2, y_results_3};
als_calib_generated_columns = {1, 3, 5};

for als=[1]
    als
    calibration_x = test_calibration_file.Data.valueVisNormalized(:, :, als_calib_generated_columns{als});
    calibration_y = test_calibration_file.Data.valueVisNormalized(:, :, als_calib_generated_columns{als}+1);
    

    orbit_x = als_x{als};
    orbit_y = als_y{als};

    orbit_x = orbit_x(:);
    orbit_y = orbit_y(:);
    
    RETRIES_THRESHOLD = 2000;
    UNCERTAINTY_0 = 0.001;
    UNCERTAINTY_INC = 0.0001;

    uncertainties = [];
    x_results = [];
    y_results = [];

    for i = (1:length(orbit_x))
        picked_x = orbit_x(i);
        picked_y = orbit_y(i);
        uncertainty = UNCERTAINTY_0;
        counter = 0;
        found = false;

        while counter < RETRIES_THRESHOLD
            counter = counter + 1;
            result = raw_to_angle(picked_x, picked_y, calibration_x, calibration_y, uncertainty);

            if (size(result) ~= [0, 0])
                found = true;
                x_out = 90-calib_step*(median(result(:,1)-1));
                y_out = calib_step*(median(result(:,2)-1));

                x_results = [x_results, x_out];
                y_results = [y_results, y_out];

                uncertainties(counter) = uncertainty;
                res_size = size(result);

                fprintf('X: %.3f; Y: %.3f; SIZE: %d; UN: %.4f; RET: %d\n', x_out, y_out, res_size(1), uncertainty, counter);
                break
            end
            uncertainty = uncertainty + UNCERTAINTY_INC;
        end
        
        if found == false
            x_results = [x_results, NaN];
            y_results = [y_results, NaN];
            fprintf('Not found!\n');
        end
    end
    
    all_uncertainties{als} = uncertainties;
    all_uncertainties_sums{als} = sum(uncertainties);
    all_x_results{als} = x_results;
    all_y_results{als} = y_results;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    all_results.all_x_results = all_x_results;
    all_results.all_y_results = all_y_results;
    
    true_array_x = [];
    for i = 1:321
        for j = 1:81
            true_array_x(i, j) = 90-((j-1)*reference_calibration_file.Data.xRes);
        end
    end

    true_array_y = [];
    for i = 1:81
        for j = 1:321
            true_array_y(i, j) = ((j-1)*reference_calibration_file.Data.xRes);
        end
    end  
    
    all_results.true_array_x = true_array_x;
    all_results.true_array_y = true_array_y;
    

    all_results.x_results_array = reshape(x_results, [321, 81]);
    all_results.y_results_array = reshape(y_results, [321, 81]);

    
    save(strcat('calibration_evaluation_outputs\', calibration_file_ref, '-vs-', calibration_file_test, ' angular_results.mat'), 'all_results');
end
% 
% f = figure;
% plot(x_results);
% grid on;
% title(strcat(calibration_file_ref, ' vs ', calibration_file_test, ' theta ALS ', string(als)));
% saveas(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, ' vs ', calibration_file_test, ' theta ALS-', string(als), '.png'));
% savefig(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, ' vs ', calibration_file_test, ' theta ALS-', string(als), '.fig'));
% 
% f = figure;
% plot(y_results);
% grid on;
% title(strcat(calibration_file_ref, ' vs ', calibration_file_test, ' phi ALS', string(als)));
% saveas(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, ' vs ', calibration_file_test, ' phi ALS-', string(als), '.png'));
% savefig(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, ' vs ', calibration_file_test, ' phi ALS-', string(als), '.fig'));
% 
% 

% 
% XX = 0:reference_calibration_file.Data.xRes:90;
% YY = 0:reference_calibration_file.Data.xRes:360;
% 
% size(x_results)
% size(y_results)
% x_results_array = reshape(x_results, [321, 81]);
% y_results_array = reshape(y_results, [321, 81]);
% 
% err_x = x_results_array;
% err_y = y_results_array;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% f = figure;
% 
% surf(XX, YY, err_x)
% shading flat;
% colorbar
% view(0, 90);
% xlim([0, 90]);
% ylim([0, 360]);
% 
% caxis([0, 10]);
% zlim([0, 10]);
% 
% title(strcat(calibration_file_ref, ' vs ', calibration_file_test, ' error theta ', 'ALS ', string(als)));
% xlabel('\Theta (\circ)');
% ylabel('\Phi (\circ)');
% zlabel('Error (\circ)');
% 
% saveas(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, '-vs-', calibration_file_test, 'ALS ', string(als), ' error theta.png'));
% savefig(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, '-vs-', calibration_file_test, 'ALS ', string(als), ' error theta.fig'));
% save(strcat('calibration_evaluation_outputs\', calibration_file_ref, '-vs-', calibration_file_test, 'ALS ', string(als), ' error theta.mat'), 'err_x');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     f = figure;
% 
%     surf(XX, YY, err_y)
%     shading flat;
%     colorbar
%     view(0, 90);
%     xlim([0, 90]);
%     ylim([0, 360]);
% 
%     caxis([0, 10]);
%     zlim([0, 10]);
% 
%     title(strcat(calibration_file_ref, ' vs ', calibration_file_test, ' error phi ', 'ALS ', string(als)));
%     xlabel('\Theta (\circ)');
%     ylabel('\Phi (\circ)');
%     zlabel('Error (\circ)');
% 
%     saveas(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, '-vs-', calibration_file_test, 'ALS ', string(als), ' error phi.png'));
%     savefig(f, strcat('calibration_evaluation_outputs\', calibration_file_ref, '-vs-', calibration_file_test, 'ALS ', string(als), ' error phi.fig'));
%     save(strcat('calibration_evaluation_outputs\', calibration_file_ref, '-vs-', calibration_file_test, 'ALS ', string(als), ' error phi.mat'), 'err_y');


end

