% clear all;
close all;

gen_theta = 0:0.1:90;
gen_theta = 90 - gen_theta;

gen_fi = 0:0.1:360;
gen_fi = gen_fi + 270;
theta_all = [];
fi_all = [];

for i=1:size(gen_theta')
    theta_all = [theta_all, ones(size(gen_fi))*gen_theta(i)];
    fi_all = [fi_all, gen_fi];
end


alpha = deg2rad(20);
theta_all = deg2rad(theta_all);
fi_all = deg2rad(fi_all);

theta_prim = zeros(size(theta_all));
fi_prim = zeros(size(fi_all));

R = [cos(alpha/2), -sin(alpha/2); sin(alpha/2), cos(alpha/2)];

for x=1:size(theta_all')
    theta = theta_all(x);
    fi = fi_all(x);

    psi = [cos(theta/2), exp(1i*fi)*sin(theta/2)];

    %R = [cos(alpha/2), -1i*sin(alpha/2); -1i*sin(alpha/2), cos(alpha/2)];
    %R = [exp(-i*alpha/2), 0; 0, exp(i*alpha/2)];

    psi_prim = R*psi';
    theta_prim(x) = 2*atan2(abs(psi_prim(2)), abs(psi_prim(1)));
    fi_prim(x) = -angle(psi_prim(2))-angle(psi_prim(1));
end

theta_prim_positive = cos(theta_prim);

% really don't know why
theta_prim_positive(theta_prim_positive < 0) = 0;

figure;
plot(rad2deg(theta_prim_positive))
figure;
plot(rad2deg(fi_prim))

matr_4 = reshape(theta_prim_positive, 3601, 901);
figure()
surf(matr_4);
shading flat;

