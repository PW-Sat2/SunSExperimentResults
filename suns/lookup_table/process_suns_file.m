function [] = process_suns_file(meas_file)
%PROCESS_SUNS_FILE Summary of this function goes here
%   Detailed explanation goes here

% load calibration data
% the best calibration right now
calibration_file = '1511865491_resampled_4';
load(strcat('..\..\experiment_data\matlab\calibration_data\results20171128_1238_1.13_1.13\', calibration_file, '.mat'));

% load measurement
load(strcat('..\..\experiment_data\matlab\', meas_file, '.mat'));

als_x = {suns.ALS_1_normalized_x, suns.ALS_2_normalized_x, suns.ALS_3_normalized_x};
als_y = {suns.ALS_1_normalized_y, suns.ALS_2_normalized_y, suns.ALS_3_normalized_y};

real_timestamp_1 = [];
real_timestamp_2 = [];
real_timestamp_3 = [];
all_real_timestamps = {real_timestamp_1, real_timestamp_2, real_timestamp_3};

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
all_y_results = {y_results_1, y_results_2, y_results_3};
als_calib_data_columns = {1, 3, 5};

for als=[1, 2, 3]
    calibration_x = Data.valueVisNormalized(:, :, als_calib_data_columns{als});
    calibration_y = Data.valueVisNormalized(:, :, als_calib_data_columns{als}+1);
    calib_step = Data.xRes;

    orbit_x = als_x{als};
    orbit_y = als_y{als};

    SHADOW_THRESHOLD = 4000;
    RETRIES_THRESHOLD = 200;
    UNCERTAINTY_0 = 0.0001;
    UNCERTAINTY_INC = 0.0001;

    uncertainties = [];
    x_results = [];
    y_results = [];
    real_timestamp = [];

    for i = (1:length(orbit_x))
        picked_x = orbit_x(i);
        picked_y = orbit_y(i);
        uncertainty = UNCERTAINTY_0;
        counter = 0;

        if suns.ALSVL1A(i) > SHADOW_THRESHOLD || suns.ALSVL1B(i) > SHADOW_THRESHOLD || suns.ALSVL1C(i) > SHADOW_THRESHOLD || suns.ALSVL1D(i) > SHADOW_THRESHOLD
            while counter < RETRIES_THRESHOLD
                counter = counter + 1;
                result = raw_to_angle(picked_x, picked_y, calibration_x, calibration_y, uncertainty);

                if (size(result) ~= [0, 0])
                    x_out = calib_step*mean(result(:,1)-1);
                    y_out = calib_step*mean(result(:,2)-1);

                    x_results = [x_results, x_out];
                    y_results = [y_results, y_out];

                    real_timestamp = [real_timestamp, suns.timestamp(i)];
                    uncertainties(counter) = uncertainty;
                    res_size = size(result);

                    %fprintf('T: %.2f; X: %.3f; Y: %.3f; SIZE: %d; UN: %.4f; RET: %d\n', suns.timestamp(i), x_out, y_out, res_size(1), uncertainty, counter);
                    break
                end
                uncertainty = uncertainty + UNCERTAINTY_INC;
            end
        else
            %fprintf('T: %.2f; Shadow!\n', suns.timestamp(i));
        end
    end
    all_real_timestamps{als} = real_timestamp;
    all_uncertainties{als} = uncertainties;
    all_uncertainties_sums{als} = sum(uncertainties);
    all_x_results{als} = x_results;
    all_y_results{als} = y_results;
end

mkdir(strcat('outputs\', meas_file));
legend_items = {'ALS 1', 'ALS 2', 'ALS 3'};

f = figure;
plot(all_real_timestamps{1}/60, all_x_results{1}, '*');
hold on;
plot(all_real_timestamps{2}/60, all_x_results{2}, '*');
plot(all_real_timestamps{3}/60, all_x_results{3}, '*');

title(strcat(meas_file, ' SunS Exp - Theta, Cal:', calibration_file));
ylabel('Theta Angle (\circ)');
xlabel('Time (min)');
legend(legend_items, 'Location', 'Best');
grid on;
saveas(f, strcat('outputs\', meas_file, '\', meas_file, '_suns_exp_theta.png'));

f = figure;
plot(all_real_timestamps{1}/60, all_y_results{1}, '*');
hold on;
plot(all_real_timestamps{2}/60, all_y_results{2}, '*');
plot(all_real_timestamps{3}/60, all_y_results{3}, '*');
legend(legend_items, 'Location', 'Best');

title(strcat(meas_file, ' SunS Exp - Fi, Cal:', calibration_file));
ylabel('Fi Angle (\circ)');
xlabel('Time (min)');
grid on;
saveas(f, strcat('outputs\', meas_file, '\', meas_file, '_suns_exp_fi.png'));
close all;


suns_exp.timestamp_als_1 = all_real_timestamps{1};
suns_exp.theta_als_1 = all_x_results{1};
suns_exp.fi_als_1 = all_y_results{1};
suns_exp.uncertainties_1 = all_uncertainties{1};
suns_exp.uncertainties_sum_1 = all_uncertainties_sums{1};

suns_exp.timestamp_als_2 = all_real_timestamps{2};
suns_exp.theta_als_2 = all_x_results{2};
suns_exp.fi_als_2 = all_y_results{2};
suns_exp.uncertainties_2 = all_uncertainties{2};
suns_exp.uncertainties_sum_2 = all_uncertainties_sums{2};

suns_exp.timestamp_als_3 = all_real_timestamps{3};
suns_exp.theta_als_3 = all_x_results{3};
suns_exp.fi_als_3 = all_y_results{3};
suns_exp.uncertainties_3 = all_uncertainties{3};
suns_exp.uncertainties_sum_3 = all_uncertainties_sums{3};

suns_exp.meas_file = meas_file;
suns_exp.calibration_file = calibration_file;


save(strcat('outputs\', meas_file, '\', meas_file, '.mat'), 'suns_exp');
end

