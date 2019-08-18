x = -70:0.1:0;

I1 = cos(deg2rad(x + 20));
I2 = cos(deg2rad(x - 20));

contr = (I2-I1)./(I2+I1);
% figure();
% plot(x, contr);
% %ylim([-1, ]);
% xlim([-70, 0])
% title('Contrast');
% 
% figure();
% plot(fliplr(0:80).*-1.125, Data.valueVisNormalized(321, 1:end, 3));
% ylim([-1, 0]);
% xlim([-70, 0])
% title('Contrast - real');


% a = rad2deg(atan(Data.valueVisNormalized(161, 1:end, 5).*cot(deg2rad(20))));
% 
% %figure();
% plot(fliplr(0:80).*1.125, a);
% %ylim([-75, 0]);
% xlim([-70, 70]);
% title("Restored angle");

% a = rad2deg(atan(generated.valueVisNormalized(1, :, 1).*cot(deg2rad(20))));
x_angle = atan(generated.valueVisNormalized(1, 1:80, 1).*cot(deg2rad(20)));
y_angle = atan(generated.valueVisNormalized(1, 1:80, 2).*cot(deg2rad(20)));

% by x-axis

X = cos(pi/2+x_angle);
Y = cos(pi/2+y_angle);
Z = sqrt((1 - X.^2 - Y.^2));
theta_prim = [];
fi_prim = [];

for index=1:size(x_angle')
    fi = 0;
    theta = 0;
    
    %%%
    
    
    psi = [cos(theta/2), exp(1i*fi)*sin(theta/2)];
    
    R = [cos(x_angle(index)/2), -1i*sin(x_angle(index)/2); -1i*sin(x_angle(index)/2), cos(x_angle(index)/2)];
    %R = [cos(y_angle(index)/2), -sin(y_angle(index)/2); sin(y_angle(index)/2), cos(y_angle(index)/2)];
    %R = [exp(-i*y_angle(index)/2), 0; 0, exp(i*y_angle(index)/2)];

    psi_prim = R*psi';
    theta = 2*atan2(abs(psi_prim(2)), abs(psi_prim(1)));
    fi = angle(psi_prim(2))-angle(psi_prim(1));
    
    
    %%%

    psi = [cos(theta/2), exp(1i*fi)*sin(theta/2)];
    
    %R = [cos(x_angle(index)/2), -1i*sin(x_angle(index)/2); -1i*sin(x_angle(index)/2), cos(x_angle(index)/2)];
    R = [cos(y_angle(index)/2), -sin(y_angle(index)/2); sin(y_angle(index)/2), cos(y_angle(index)/2)];
    %R = [exp(-i*alpha/2), 0; 0, exp(i*alpha/2)];

    psi_prim = R*psi';
    theta = 2*atan2(abs(psi_prim(2)), abs(psi_prim(1)));
    fi = angle(psi_prim(2))-angle(psi_prim(1));
    %%%%%

    
    theta_prim(index) = theta;
    fi_prim(index) = fi;
end

figure
plot(rad2deg(theta_prim), '*-');

figure
plot(rad2deg(fi_prim)-90, '*-');
