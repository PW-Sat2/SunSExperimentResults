% Purpose:
% gets calibration file and resamples by RESAMPLE_FACTOR
% output is written to a file

clear all;

file = '..\..\experiment_data\matlab\calibration_data\results20171204_1432_1.13_1.13/1512390730';

RESAMPLE_FACTOR = 4;

load(strcat(file, '.mat'));
DataTMP = Data;

for jj = [1, 3, 5]
    contrast_x = Data.valueVisNormalized(:,:,jj);
    contrast_y = Data.valueVisNormalized(:,:,jj+1);

    % resample to gain resolution
    contrast_x_vec = reshape(contrast_x, [], 1);
    contrast_y_vec = reshape(contrast_y, [], 1);

    xx = [];
    for ii=1:Data.xSize
        xx = [xx, ones(1, Data.ySize).*ii];
    end
    y = linspace(Data.angleYmin, Data.angleYmax, Data.ySize);
    yy = repmat(y, [1, Data.xSize]);

    xx4 = [];
    for ii=1:Data.xSize*RESAMPLE_FACTOR
        xx4 = [xx4, ones(1, Data.ySize*RESAMPLE_FACTOR).*ii/RESAMPLE_FACTOR];
    end
    y4 = linspace(Data.angleYmin, Data.angleYmax, Data.ySize*RESAMPLE_FACTOR);
    yy4 = repmat(y4, [1, Data.xSize*RESAMPLE_FACTOR]);

    % smoth
    contrast_x_vec_4 = griddata(xx, yy, contrast_x_vec, xx4, yy4, 'cubic');
    contrast_y_vec_4 = griddata(xx, yy, contrast_y_vec, xx4, yy4, 'cubic');

    contrast_x_4 = reshape(contrast_x_vec_4, Data.ySize*RESAMPLE_FACTOR, Data.xSize*RESAMPLE_FACTOR);
    contrast_y_4 = reshape(contrast_y_vec_4, Data.ySize*RESAMPLE_FACTOR, Data.xSize*RESAMPLE_FACTOR);

    if jj==1
        DataTMP.valueVisNormalized = contrast_x_4;
    else
        DataTMP.valueVisNormalized(:,:,jj) = contrast_x_4;
    end

    DataTMP.valueVisNormalized(:,:,jj+1) = contrast_y_4;
    DataTMP.xSize = Data.xSize*RESAMPLE_FACTOR;
    DataTMP.ySize = Data.ySize*RESAMPLE_FACTOR;
    DataTMP.xRes = Data.xRes/RESAMPLE_FACTOR;
    DataTMP.yRes = Data.yRes/RESAMPLE_FACTOR;
end

Data = DataTMP;
save(strcat(file, '_resampled_', string(RESAMPLE_FACTOR), '.mat'), 'Data');