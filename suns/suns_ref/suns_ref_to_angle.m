function [] = suns_ref_to_angle(filename)
%SUNS_REF_TO_ANGLE Summary of this function goes here
%   Detailed explanation goes here

load(strcat('..\..\experiment_data\matlab\', filename, '.mat'));
sunsRefV = table2array(suns(:, 6:10));

i = 1;

LIGHT_THRESHOLD = 5000;
for ii=1:size(sunsRefV,1)
    if suns.ALSVL1A(ii) > LIGHT_THRESHOLD && suns.ALSVL1B(ii) > LIGHT_THRESHOLD && suns.ALSVL1C(ii) > LIGHT_THRESHOLD && suns.ALSVL1D(ii) > LIGHT_THRESHOLD
        SunSRefResults(i, :) = suns_ref_meas(sunsRefV(ii,:));
        real_timestamp(i) = suns.timestamp(ii);
        i = i+1;
    end
end

% figure('Name','SunSRef theta rough');
% plot(SunSRefResults(:,3), '.');
% % ylim([0 100])
% figure('Name','SunSRef fi rough');
% plot(SunSRefResults(:,4), '.', 'Color', 'red');
%figure('Name','SunSRef theta fine');
%plot(SunSRefResults(:,1), '.');
% ylim([0 100])
% figure('Name','SunSRef fi fine');
% plot(SunSRefResults(:,2), '.', 'Color', 'red');

for ii=1:size(SunSRefResults,1)
    current = [SunSRefResults(ii,3), SunSRefResults(ii, 4)];
    if current(2) < 0
        temp = [current(1), current(2)+360-90];
    else
        temp = [current(1), current(2)-90];
    end
    
    if temp(2) < 0
        temp(2) = temp(2) + 360;
    end
    
    SunSRefResultsTransformed(ii,:) = temp;
end

mkdir(strcat('outputs\', filename));

f = figure;
plot(real_timestamp/60, SunSRefResultsTransformed(:,1), '*');
title(strcat('SunS Ref Theta - ', filename, ' - not transformed'));
ylabel('Theta Angle (\circ)');
xlabel('Time (min)');
grid on;
saveas(f, strcat('outputs\', filename, '\', filename, '_suns_ref_theta.png'));


f = figure;
plot(real_timestamp/60, SunSRefResultsTransformed(:,2), '*', 'Color', 'red');
title(strcat('SunS Ref Fi - ', filename,  ' - not transformed'));
ylabel('Fi Angle (\circ)');
xlabel('Time (min)');
grid on;
saveas(f, strcat('outputs\', filename, '\', filename, '_suns_ref_fi.png'));
close all;

% [z,y,x] = sph2cart(deg2rad(SunSRefResultsTransformed(:,2)),deg2rad(SunSRefResultsTransformed(:,1)),1);
% figure();
% subplot(3, 1, 1);
% plot(real_timestamp, x, '.');
% subplot(3, 1, 2);
% plot(real_timestamp, y, '.', 'Color', 'r');
% subplot(3, 1, 3);
% plot(real_timestamp, z, '.', 'Color', 'g');
% legend('X','Y','Z');

suns_ref.suns_ref_theta = SunSRefResultsTransformed(:,1);
suns_ref.suns_ref_fi = SunSRefResultsTransformed(:,2);
suns_ref.timestamp = real_timestamp;
suns_ref.meas_file = filename;

save(strcat('outputs\', filename, '\', filename, '_suns_ref.mat'), 'suns_ref');

end

