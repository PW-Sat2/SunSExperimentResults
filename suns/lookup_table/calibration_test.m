clear all;

filename = 'results20171121_1231_1.13_1.13\1511260304';
filename = 'results20171122_1146_1.13_1.13\1511343969';
filename = 'results20171122_1625_1.13_1.13\1511360702';
filename = 'results20171123_0958_1.13_1.13\1511423914';
filename = 'results20171123_1417_1.13_1.13\1511439430';
filename = 'results20171124_0730_1.13_1.13\1511501431';
filename = 'results20171124_1136_1.13_1.13\1511516211';
filename = 'results20171127_1432_1.13_1.13\1511785970c';
filename = 'results20171128_1238_1.13_1.13\1511865491';
filename = 'results20171129_0707_1.13_1.13\1511932042';
%filename = 'results20171129_1357_1.13_1.13\1511956631';
%filename = 'results20171130_1242_1.13_1.13\1512038550';
%filename = 'results20171204_1432_1.13_1.13\1512390730';


load(strcat('..\..\experiment_data\matlab\calibration_data\', filename, '.mat'));
Data_meas = Data;


calibration_file = '1511956631';
load(strcat('..\..\experiment_data\matlab\calibration_data\results20171129_1357_1.13_1.13\', calibration_file, '.mat'));


all_uncertainties = {};
all_uncertainties_sums = {};

all_x_results = {};
all_y_results = {};

calib_step = Data.xRes;
data_step = Data_meas.xRes;
als_calib_data_columns = {1, 3, 5};

% load measurement
als_x = {Data.valueVisNormalized(:, :, 1), Data.valueVisNormalized(:, :, 3), Data.valueVisNormalized(:, :, 5)};
als_y = {Data.valueVisNormalized(:, :, 2), Data.valueVisNormalized(:, :, 4), Data.valueVisNormalized(:, :, 6)};

ss = size(als_x{1});


real_timestamp = [];
SHADOW_THRESHOLD = 1000;
RETRIES_THRESHOLD = 200;
UNCERTAINTY_0 = 0.0001;
UNCERTAINTY_INC = 0.0001;

for als=[1, 2, 3]
    uncertainties = [];
    x_results = [];
    y_results = [];
    
    x_angle = [];
    y_angle = [];
    calibration_x = Data.valueVisNormalized(:, :, als_calib_data_columns{als});
    calibration_y = Data.valueVisNormalized(:, :, als_calib_data_columns{als}+1);

    orbit_x = als_x{als};
    orbit_y = als_y{als};
    als
    
    for ix = 1:ss(2)
        for iy = 1:ss(1)
                

                picked_x = orbit_x(iy, ix);
                picked_y = orbit_y(iy, ix);
                uncertainty = UNCERTAINTY_0;
                counter = 0;

                while counter < RETRIES_THRESHOLD
                    counter = counter + 1;
                    result = raw_to_angle(picked_x, picked_y, calibration_x, calibration_y, uncertainty);

                    if (size(result) ~= [0, 0])
                        x_out = calib_step*(mean(result(:,1)-1));
                        y_out = calib_step*(mean(result(:,2)-1));

                        x_results = [x_results, x_out];
                        y_results = [y_results, y_out];
                        
                        x_angle = [x_angle, (ix-1)*data_step];
                        y_angle = [y_angle, (iy-1)*data_step];

                        % real_timestamp = [real_timestamp, suns.timestamp(i)];
                        uncertainties = [uncertainties, uncertainty];
                        res_size = size(result);

%                       fprintf('T: %.2f; X: %.3f; Y: %.3f; SIZE: %d; UN: %.4f; RET: %d\n', i, x_out, y_out, res_size(1), uncertainty, counter);
                        break
                    end
                    uncertainty = uncertainty + UNCERTAINTY_INC;
                end

                if (size(result) == [0, 0])
                    x_results = [x_results, NaN];
                    y_results = [y_results, NaN];

                    x_angle = [x_angle, (ix-1)*data_step];
                    y_angle = [y_angle, (iy-1)*data_step];
                    fprintf('dupa');
                end
            %mkdir(strcat('outputs\', meas_file));
            % legend_items = {'ALS 1', 'ALS 2', 'ALS 3'};
            % 
            % f = figure;
            % plot(all_real_timestamps{1}/60, all_x_results{1}, '*');
            % hold on;
            % plot(all_real_timestamps{2}/60, all_x_results{2}, '*');
            % plot(all_real_timestamps{3}/60, all_x_results{3}, '*');
            % 
            % title(strcat(meas_file, ' SunS Exp - Theta, Cal:', calibration_file));
            % ylabel('Theta Angle (\circ)');
            % xlabel('Time (min)');
            % legend(legend_items, 'Location', 'Best');
            % grid on;
            % %saveas(f, strcat('outputs\', meas_file, '\', meas_file, '_suns_exp_theta.png'));
            % 
            % f = figure;
            % plot(all_real_timestamps{1}/60, all_y_results{1}, '*');
            % hold on;
            % plot(all_real_timestamps{2}/60, all_y_results{2}, '*');
            % plot(all_real_timestamps{3}/60, all_y_results{3}, '*');
            % legend(legend_items, 'Location', 'Best');
            % 
            % title(strcat(meas_file, ' SunS Exp - Fi, Cal:', calibration_file));
            % ylabel('Fi Angle (\circ)');
            % xlabel('Time (min)');
            % grid on;
            % %saveas(f, strcat('outputs\', meas_file, '\', meas_file, '_suns_exp_fi.png'));
            % %close all;
            % 
            % 
            % suns_exp.timestamp_als_1 = all_real_timestamps{1};
            % suns_exp.theta_als_1 = all_x_results{1};
            % suns_exp.fi_als_1 = all_y_results{1};
            % suns_exp.uncertainties_1 = all_uncertainties{1};
            % suns_exp.uncertainties_sum_1 = all_uncertainties_sums{1};
            % 
            % suns_exp.timestamp_als_2 = all_real_timestamps{2};
            % suns_exp.theta_als_2 = all_x_results{2};
            % suns_exp.fi_als_2 = all_y_results{2};
            % suns_exp.uncertainties_2 = all_uncertainties{2};
            % suns_exp.uncertainties_sum_2 = all_uncertainties_sums{2};
            % 
            % suns_exp.timestamp_als_3 = all_real_timestamps{3};
            % suns_exp.theta_als_3 = all_x_results{3};
            % suns_exp.fi_als_3 = all_y_results{3};
            % suns_exp.uncertainties_3 = all_uncertainties{3};
            % suns_exp.uncertainties_sum_3 = all_uncertainties_sums{3};
            % 
            % suns_exp.meas_file = meas_file;
            % suns_exp.calibration_file = calibration_file;


            %save(strcat('outputs\', meas_file, '\', meas_file, '_suns_exp.mat'), 'suns_exp');
        end
    end
    
    all_x_results{als} = x_results;
    all_y_results{als} = y_results;
    all_x_angles{als} = x_angle;
    all_y_angles{als} = y_angle;
    
    all_uncertainties{als} = uncertainties;
    all_uncertainties_sums{als} = sum(uncertainties);

end

