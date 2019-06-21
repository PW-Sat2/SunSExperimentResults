function angles = suns_ref_meas(V)

if (4*V(5)-V(1)-V(2)-V(3)-V(4)<0.7)
    angles = [0, 0, 0, 0];
    return
end

% V = [2136.08398438000 2516.45507812000 2190.13671875000 2510.44921875000 2801.73339844000];
k = [4.659947, -4.494205, 4.502442, -4.336701, -0.331483];
n = [4.506646, -4.334436, -4.491975, 4.664185, -0.344420];
m = [-1.392388, -1.584140, -1.395687, -1.580841, 5.953056];
l = [43.963707     NaN           NaN            NaN           NaN;
    -76.541577   41.494717       NaN            NaN           NaN;
      5.361475    2.892485     42.397768        NaN           NaN;
      6.024362    3.555372    -76.541577      43.060655       NaN;
    -22.771673  -12.895714    -16.507920     -19.159467     35.667387];
v_r = atan2(sum(k.*V),sum(n.*V));

sqrt_sum = 0;
for ii=1:5
    for jj=ii:5
        sqrt_sum = sqrt_sum + l(jj,ii)*V(ii)*V(jj);
    end
end
lambda_r = acos(sum(m.*V)/sqrt(sqrt_sum));

% 00 10 20 30 40 50;
% 01 11 21 31 41 51;...
p = [-1.73550E+0    -6.93915E-3     8.43811E-5    8.34127E-7    -3.28638E-9     -2.48739E-11;
      1.62413E+0     1.16755E-3    -2.60204E-6   -2.55581E-8     1.07057E-10    NaN;
     -5.50691E-2    -5.40386E-5    -7.52657E-9    7.68524E-10   NaN             NaN;
      1.96849E-3    9.11648E-7     -4.96364E-10     NaN         NaN             NaN;
     -3.16603E-5    -8.18875E-9         NaN         NaN         NaN             NaN;
      1.97578E-7        NaN             NaN         NaN         NaN             NaN];

  
q = [7.85314E-1      1.01425E+0    -2.51006E-4   -1.07789E-6     4.84849E-9      2.02376E-11;
     -8.49996E-3    -8.88851E-4     1.58090E-5    8.35056E-9    -2.52939E-10    NaN;
     -3.80006E-3     4.28998E-5    -2.50897E-7   -4.91279E-11   NaN             NaN;
     1.46654E-4     -9.18320E-7     3.55865E-9      NaN         NaN             NaN;
     -2.48870E-6     6.71439E-9         NaN         NaN         NaN             NaN;
     1.20984E-8         NaN             NaN         NaN         NaN             NaN];
 
lambda = 0;
v = 0;
for ii=0:5
    for jj=0:5-ii
        lambda = lambda + p(jj+1,ii+1).*v_r^(ii).*lambda_r^(jj);
        v = v + q(jj+1,ii+1).*v_r^(ii).*lambda_r^(jj);
    end
end

angles = rad2deg([pi/2-lambda, v, pi/2-lambda_r, v_r]);
%angles = rad2deg([lambda, v, lambda_r, v_r]);
end