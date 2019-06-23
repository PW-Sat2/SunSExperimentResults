function result = raw_to_angle(picked_x, picked_y, calibration_x, calibration_y, uncertainty)
    [sc_y, sc_x] = size(calibration_y);
    result = [];
    
    x = abs(calibration_x - picked_x) < uncertainty;
    y = abs(calibration_y - picked_y) < uncertainty;

    [xx_c, xx_r] = find(x);
    [yy_c, yy_r] = find(y);

    result = intersect([xx_r, xx_c], [yy_r, yy_c], 'rows');
end