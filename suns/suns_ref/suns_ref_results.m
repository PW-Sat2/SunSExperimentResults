clear all;
close all;

files = {
%          'suns1',
%          'suns2',
%          'suns3_time_corrected',
%          'suns4',
%          'suns5',
%          'suns6',
%          'suns7',
%          'suns8',
%          'sunsps1',
%          'sunsps2',
%          'sunsps3',
%          'sunsps4',
%          'sunsps5',
%          'sunsps6',
%          'sunsps7',
%          'sunsps8',
           'sunsps9'};
     
for i=1:numel(files)
    suns_ref_to_angle(files{i});
end
