clear all;
close all;

datanames = {'sunsps5'};

for k=1:length(datanames)
    dataname = datanames{k}
    load(strcat('..\..\experiment_data\matlab\', dataname, '.mat'));
    fs = 1/2; %Hz
    fpass = 1/700; %Hz
    fpassd = fpass/fs;
    
    fhigh = 0.02/fs;


    raw = figure('Renderer', 'painters', 'Position', [10 10 1200 900]);
    title(strcat('Raw gyro values: ', dataname));
    ylabel('angular rate [°/s]');
    xlabel('time [min]');
    hold on;
    plot(suns.timestamp/60, suns.gyro_x, '.-');
    plot(suns.timestamp/60, suns.gyro_y, '.-');
    plot(suns.timestamp/60, suns.gyro_z, '.-');
    legend('X', 'Y', 'Z');
    grid on;


    x_r = resample(suns.gyro_x, suns.timestamp, fs);
    y_r = resample(suns.gyro_y, suns.timestamp, fs);
    z_r = resample(suns.gyro_z, suns.timestamp, fs);

    timestamp = (0:1/fs:(size(x_r)-1)*1/fs)';
    resampled = figure('Renderer', 'painters', 'Position', [10 10 1200 900]);
    title(strcat('Resampled gyro values: ', dataname));
    ylabel('angular rate [°/s]');
    xlabel('time [min]');
    hold on;
    plot(timestamp(1:end-20)/60, x_r(1:end-20), '.-');
    plot(timestamp(1:end-20)/60, y_r(1:end-20), '.-');
    plot(timestamp(1:end-20)/60, z_r(1:end-20), '.-');
    legend('X', 'Y', 'Z');
    grid on;

    if (1)
        x_f = highpass(x_r(1:end-20), fpassd);
        y_f = highpass(y_r(1:end-20), fpassd);
        z_f = highpass(z_r(1:end-20), fpassd);
        
        x_f = lowpass(x_f, fhigh);
        y_f = lowpass(y_f, fhigh);
        z_f = lowpass(z_f, fhigh);        
    else
        Hd = gyroscopeFilter();
        x_f = filter(Hd, x_r(1:end-20));
        y_f = filter(Hd, y_r(1:end-20));
        z_f = filter(Hd, z_r(1:end-20));
    end; 
    

    multiplot = figure('Renderer', 'painters', 'Position', [10 10 900 1200]);
    hold off;

    subplot(4,1,1);
    plot(timestamp(1:end-20)/60, x_f, '.-');
    title(strcat('Filtered gyro values: ', dataname));
    ylabel('angular rate [°/s]');
    xlabel('time [min]');
    grid on;
    legend('X');

    subplot(4,1,2);
    plot(timestamp(1:end-20)/60, y_f, '.-');
    ylabel('angular rate [°/s]');
    xlabel('time [min]');
    grid on;
    legend('Y');

    subplot(4,1,3);
    plot(timestamp(1:end-20)/60, z_f, '.-');
    ylabel('angular rate [°/s]');
    xlabel('time [min]');
    grid on;
    legend('Z');

    sum = sqrt(x_f.^2 + y_f.^2 + z_f.^2);

    subplot(4,1,4);
    plot(timestamp(1:end-20)/60, sum, '.-');
    ylabel('angular rate [°/s]');
    xlabel('time [min]');
    grid on;
    legend('sum');
    
    output = table(timestamp(1:end-20), x_f, y_f, z_f, sum);

%   save figures
    mkdir(strcat('outputs/', dataname));
    save(strcat('outputs/', dataname, '/outputs-', dataname, '.mat'), 'output');
    print(raw,strcat('outputs/', dataname, '/raw-', dataname, '.png'),'-dpng','-r600'); 
    print(resampled, strcat('outputs/', dataname, '/resampled-', dataname, '.png'),'-dpng','-r600');
    print(multiplot, strcat('outputs/', dataname, '/filtered-', dataname, '.png'),'-dpng','-r600');

    

end;