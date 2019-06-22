theta_all = deg2rad(all_data.suns_ref_theta);
fi_all = deg2rad(all_data.suns_ref_fi);
alpha = deg2rad(15);

theta_exp = deg2rad(all_data.theta_als_1);
fi_exp = deg2rad(all_data.fi_als_1);

for x=1:size(theta_all)
    theta = theta_all(x);
    fi = fi_all(x);
    psi = [cos(theta/2), exp(i*fi)*sin(theta/2)];
    
    R = [cos(alpha/2), -i*sin(alpha/2); -i*sin(alpha/2), cos(alpha/2)];
    %R = [cos(alpha/2), -sin(alpha/2); sin(alpha/2), cos(alpha/2)];
    %R = [exp(-i*alpha/2), 0; 0, exp(i*alpha/2)];
    
    psi_prim = R*psi';
    theta_prim(x) = 2*atan2(abs(psi_prim(2)), abs(psi_prim(1)));
    fi_temp = -angle(psi_prim(2))-angle(psi_prim(1));
    
    if fi_temp < 0
        fi_prim(x) = fi_temp + 2*pi;
    else
        fi_prim(x) = fi_temp;
    end
end

close all;
figure;
plot(all_data.suns_ref_timestamp, rad2deg(theta_prim), '*');
hold on;
plot(all_data.timestamp_als_1, all_data.theta_als_1, '*');
plot(all_data.timestamp_als_2, all_data.theta_als_2, '*');
plot(all_data.timestamp_als_3, all_data.theta_als_3, '*');

%plot(all_data.suns_ref_timestamp, rad2deg(theta_all), '*');
title('Theta');
grid on;

figure;
%plot(all_data.suns_ref_timestamp, rad2deg(fi_prim), '.');
hold on;
plot(all_data.timestamp_als_1, all_data.fi_als_1, '*');
plot(all_data.timestamp_als_2, all_data.fi_als_2, '*');
plot(all_data.timestamp_als_3, all_data.fi_als_3, '*');

plot(all_data.suns_ref_timestamp, rad2deg(fi_all), '*');
title('Fi');
grid on;
