% Purpose:
% gets calibration file and resamples by RESAMPLE_FACTOR
% output is written to a file

clear all;

folders = {
    'results20171121_1231_1.13_1.13'
    'results20171122_1146_1.13_1.13'
    'results20171122_1625_1.13_1.13'
    'results20171123_0958_1.13_1.13'
    'results20171123_1417_1.13_1.13'
    'results20171124_0730_1.13_1.13'
    'results20171124_1136_1.13_1.13'
    'results20171127_1432_1.13_1.13'
    'results20171128_1238_1.13_1.13'
    'results20171129_0707_1.13_1.13'
    'results20171129_1357_1.13_1.13'
    'results20171130_1242_1.13_1.13'
    'results20171204_1432_1.13_1.13'
};

files = {
    '1511260304'
    '1511343969'
    '1511360702'
    '1511423914'
    '1511439430'
    '1511501431'
    '1511516211'
    '1511785970c'
    '1511865491'
    '1511932042'
    '1511956631'
    '1512038550'
    '1512390730'
};

for i = 1:13
    i
    file = strcat('..\..\experiment_data\matlab\calibration_data\', folders{i}, '/', files{i});

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
end