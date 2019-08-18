files = {'suns1'
         'suns2'
         'suns3_time_corrected'
         'suns4'
         'suns5'
         'suns6'
         'suns7'
         'suns8'
         'sunsps1'
         'sunsps2'
         'sunsps3'
         'sunsps4'
         'sunsps5'
         'sunsps6'
         'sunsps7'
         'sunsps8'
         'sunsps9'
         'sunsps10'};
%numel(files)
for no = 1:1
    load(strcat('../lookup_table/outputs/', files{no}, '/', files{no}, '_suns_exp.mat'));
    theta_prim = [];
    fi_prim = [];
    for index=1:size(suns_exp.fi_als_1')
        fi = suns_exp.fi_als_1(index);
        theta = deg2rad(30);

        alpha = deg2rad(suns_exp.theta_als_1(index)-30);

        psi = [cos(theta/2), exp(1i*fi)*sin(theta/2)];

        R = [cos(alpha/2), -1i*sin(alpha/2); -1i*sin(alpha/2), cos(alpha/2)];
        %R = [cos(alpha/2), -sin(alpha/2); sin(alpha/2), cos(alpha/2)];
        %R = [exp(-i*alpha/2), 0; 0, exp(i*alpha/2)];

        psi_prim = R*psi';
        theta_prim = [theta_prim, 2*atan2(abs(psi_prim(2)), abs(psi_prim(1)))];
        fi_temp = -angle(psi_prim(2))-angle(psi_prim(1));

        if 0
            fi_prim = [fi_prim, fi_temp + 2*pi];
        else
            fi_prim = [fi_prim, fi_temp];
        end 
    end
    
    figure
    plot(suns_exp.timestamp_als_1, rad2deg(theta_prim), '*');
    hold on;
    plot(suns_exp.timestamp_als_1, suns_exp.theta_als_1, '*');
    
    figure
    plot(suns_exp.timestamp_als_1, rad2deg(fi_prim), '*');
    hold on;
    plot(suns_exp.timestamp_als_1, suns_exp.fi_als_1, '*');    

%     f = figure;
%     title(strcat('SunS Exp cartesian ', files{no})); 
%     subplot(3, 1, 1);
%     plot(suns_exp.timestamp_als_1, rad2deg(x), '.');
%     legend('X');
%     
%     subplot(3, 1, 2);
%     plot(suns_exp.timestamp_als_1, rad2deg(y), '.', 'Color', 'r');
%     legend('Y');
%     
%     subplot(3, 1, 3);
%     plot(suns_exp.timestamp_als_1, rad2deg(z), '.', 'Color', 'g');
%     legend('Z');
%     
end