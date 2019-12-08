clear all;
close all;

folders = {
%     'generated_hires'
%     'generated'
%     'results20171121_1231_1.13_1.13'
%     'results20171122_1146_1.13_1.13'
%     'results20171122_1625_1.13_1.13'
%     'results20171123_0958_1.13_1.13'
%     'results20171123_1417_1.13_1.13'
%     'results20171124_0730_1.13_1.13'
%     'results20171124_1136_1.13_1.13'
%     'results20171127_1432_1.13_1.13'
     'results20171128_1238_1.13_1.13'
%     'results20171129_0707_1.13_1.13'
    'results20171129_1357_1.13_1.13'
%     'results20171130_1242_1.13_1.13'
%     'results20171204_1432_1.13_1.13'
};

files = {
%     'generated_hires'
%     'generated'
%     '1511260304'
%     '1511343969'
%     '1511360702'
%     '1511423914'
%     '1511439430'
%     '1511501431'
%     '1511516211'
%     '1511785970c'
     '1511865491'
%     '1511932042'
    '1511956631'
%     '1512038550'
%     '1512390730'
};

files_resampled = {
%     ' '
%     ' '
%     '1511260304_resampled_4'
%     '1511343969_resampled_4'
%     '1511360702_resampled_4'
%     '1511423914_resampled_4'
%     '1511439430_resampled_4'
%     '1511501431_resampled_4'
%     '1511516211_resampled_4'
%     '1511785970c_resampled_4'
    '1511865491_resampled_4'
%     '1511932042_resampled_4'
    '1511956631_resampled_4'
%     '1512038550_resampled_4'
%     '1512390730_resampled_4'
};

% _resampled_4
% load calibration data
% the best calibration right now


% for i = 1:4

ref_no = 1
calibration_file_ref = files_resampled{ref_no};
folder_ref = folders{ref_no};

%     for j = 1:4
        
        test_no = 2
        calibration_file_test = files{test_no};
        folder_test = folders{test_no};

            t = cputime;
            angle_from_calibration(folder_ref, calibration_file_ref, folder_test, calibration_file_test);
            e = cputime-t

            
            close all;
%     end
% end
