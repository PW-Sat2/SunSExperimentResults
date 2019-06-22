clear all;

files = {'suns1',
         'suns2',
         'suns3_time_corrected',
         'suns4',
         'suns5',
         'suns6',
         'suns7',
         'suns8',
         'sunsps1',
         'sunsps2',
         'sunsps3',
         'sunsps4',
         'sunsps5',
         'sunsps6',
         'sunsps7'};
     
%numel(files)
for i = 1:numel(files)
    load(strcat('../suns_ref/outputs/', files{i}, '/', files{i}, '_suns_ref.mat'));
    load(strcat('../lookup_table/outputs/', files{i}, '/', files{i}, '_suns_exp.mat'));
    
    [z_exp_1,y_exp_1,x_exp_1] = sph2cart(deg2rad(suns_exp.fi_als_1), deg2rad(suns_exp.theta_als_1), 1);
    [z_exp_2,y_exp_2,x_exp_2] = sph2cart(deg2rad(suns_exp.fi_als_2), deg2rad(suns_exp.theta_als_2), 1);
    [z_exp_3,y_exp_3,x_exp_3] = sph2cart(deg2rad(suns_exp.fi_als_3), deg2rad(suns_exp.theta_als_3), 1);

    [z_ref,y_ref,x_ref] = sph2cart(deg2rad(suns_ref.suns_ref_fi), deg2rad(suns_ref.suns_ref_theta), 1);
    
    % Correct for mounting angle of the SunS Ref
    Ro = deg2rad(-15);  % SunS Ref mounting angle
    Rz = [cos(Ro) -sin(Ro) 0 ; sin(Ro) cos(Ro) 0 ; 0 0 1] ;

    zzz = [];
    for jj=1:size(z_ref)
        zzz(:, jj) = Rz*[(x_ref(jj)), (y_ref(jj)), (z_ref(jj))]';
    end
    
    f = figure('Renderer', 'painters', 'Position', [10 10 1200 900]);
    title(strcat('SunS Ref and exp cartesian ', files{i})); 
    subplot(3, 1, 1);
    hold on;
    plot(suns_ref.timestamp/60, zzz(1, :), '.');
    plot(suns_exp.timestamp_als_1/60, (x_exp_1), '.');
    plot(suns_exp.timestamp_als_2/60, (x_exp_2), '.');
    plot(suns_exp.timestamp_als_3/60, (x_exp_3), '.');
    legend('X Ref', 'X Exp ALS 1', 'X Exp ALS 2', 'X Exp ALS 3', 'Location', 'Best');
    grid on;
    ylabel('X coordinate');
    xlabel('Time (min)');
    
    subplot(3, 1, 2);
    hold on;
    plot(suns_ref.timestamp/60, zzz(2, :), '.');
    plot(suns_exp.timestamp_als_1/60, (y_exp_1), '.');
    plot(suns_exp.timestamp_als_2/60, (y_exp_2), '.');
    plot(suns_exp.timestamp_als_3/60, (y_exp_3), '.');
    legend('Y Ref', 'Y Exp ALS 1', 'Y Exp ALS 2', 'Y Exp ALS 3', 'Location', 'Best');
    grid on;
    ylabel('Y coordinate');
    xlabel('Time (min)');
    
    subplot(3, 1, 3);
    hold on;
    plot(suns_ref.timestamp/60, zzz(3, :), '.');
    plot(suns_exp.timestamp_als_1/60, (z_exp_1), '.');
    plot(suns_exp.timestamp_als_2/60, (z_exp_2), '.');
    plot(suns_exp.timestamp_als_3/60, (z_exp_3), '.');
    legend('Z Ref', 'Z Exp ALS 1', 'Z Exp ALS 2', 'Z Exp ALS 3', 'Location', 'Best');
    grid on;
    ylabel('Z coordinate');
    xlabel('Time (min)');
    
    mkdir(strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}));
    print(f, strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.png'),'-dpng','-r600');
    
    all_results.timestamp_als_1 = suns_exp.timestamp_als_1;
    all_results.timestamp_als_2 = suns_exp.timestamp_als_1;
    all_results.timestamp_als_3 = suns_exp.timestamp_als_1;
    
    all_results.suns_exp_z_als_1 = (z_exp_1);
    all_results.suns_exp_z_als_2 = (z_exp_2);
    all_results.suns_exp_z_als_3 = (z_exp_3);
    
    all_results.suns_exp_y_als_1 = (y_exp_1);
    all_results.suns_exp_y_als_2 = (y_exp_2);
    all_results.suns_exp_y_als_3 = (y_exp_3);
    
    all_results.suns_exp_x_als_1 = (x_exp_1);
    all_results.suns_exp_x_als_2 = (x_exp_2);
    all_results.suns_exp_x_als_3 = (x_exp_3);
    
    all_results.timestamp_suns_ref = suns_ref.timestamp;
    all_results.suns_ref_x = zzz(1, :);
    all_results.suns_ref_y = zzz(2, :);
    all_results.suns_ref_z = zzz(3, :);
    
    save(strcat('..\combined_plots\suns_exp_and_ref_corrected_in_cartesian\', files{i}, '\', files{i}, '_suns_exp_ref_corrected.mat'), 'all_results');
end