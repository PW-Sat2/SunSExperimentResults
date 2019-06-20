function result = raw_to_angle(picked_x, picked_y, calibration_x, calibration_y, uncertainty)
    arr_x = [];
    arr_y = [];
    [sc_y, sc_x] = size(calibration_y);
    
        for n = (1:sc_y)
            for m = (1:sc_x)
                if abs(picked_x-calibration_x(n, m)) < uncertainty
                    arr_x = [arr_x; [m, n]];
                end
                
                if abs(picked_y-calibration_y(n, m)) < uncertainty
                    arr_y = [arr_y; [m, n]];
                end
            end
        end
    
    [s_x, temp] = size(arr_x);
    [s_y, temp] = size(arr_y);
    
     result = [];    
   
    for i = (1:s_x)
        for j = (1:s_y)
            if (isequal(arr_x(i,:), arr_y(j,:)))
                result = [result; arr_x(i,:)];
            end
        end   
    end
end