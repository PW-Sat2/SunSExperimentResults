function [] = generate_sphere()
%GENERATE_SPHERE Summary of this function goes here
%   Detailed explanation goes here
[x,y,z] = sphere(100);

hs = surf(x, y, z);
set(hs, 'FaceColor', [0.5 0.5 0.5]);
set(hs, 'FaceAlpha', 0.5);
set(hs, 'EdgeColor', 'none');

axis equal;
zlim([-1, 1])
ylim([-1, 1])
xlim([0, 1])

hold on;

fi = deg2rad(0:1:360);
theta = ones(size(fi))*deg2rad(57);
alpha = deg2rad(-15);
theta_prim = [];
fi_temp = [];
for j=1:size(fi')
    psi = [cos(theta(j)/2), exp(1i*fi(j))*sin(theta(j)/2)];
    R = [cos(alpha/2), -1i*sin(alpha/2); -1i*sin(alpha/2), cos(alpha/2)];
    
    psi_prim = R*psi';
    theta_prim(j) = 2*atan2(abs(psi_prim(2)), abs(psi_prim(1)));
    fi_temp(j) = -angle(psi_prim(2))-angle(psi_prim(1));

end

[z, y, x] = sph2cart(fi_temp, deg2rad(90)-theta_prim, 1);
plot3(x, y, z, '-');

hold on;

%%%%%%%%%%%%%%%
% suns exp boundaries
%%%%%%%%%%%%%%%

fi = 0:1:360;
theta = ones(size(fi))*70;

[z, y, x] = sph2cart(deg2rad(fi), deg2rad(90-theta), 1);
plot3(x, y, z, '-');

%%%%%%%%%%%%%%%

end

