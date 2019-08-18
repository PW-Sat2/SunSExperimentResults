clear all;
close all;

base_path = '..\..\..\experiment_data\matlab\calibration_data\';
output_path = 'outputs';

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

X = 0:1.125:80*1.125;
Y = 0:1.125:320*1.125;

for i = 1:numel(files)
    current_file = strcat(base_path, folders{i}, '\', files{i}, '.mat');
    load(current_file);
    Data_1 = Data;
    
    for als = 1:12
        name = strcat(folders{i}, ' ', files{i}, ' valueVis - ALS ', string(als));
        mkdir(strcat('outputs\', folders{i}));
        f = figure;
        surf(X, Y, Data_1.valueVis(:, :, als));
        title(name);
        shading flat;
        view(0, 90);

        xlabel("\Theta (\circ)");
        ylabel("\Phi (\circ)");
        %colormap copper;
        colorbar
        
        xlim([0, 90]);
        ylim([0, 360]);
        
        mkdir(strcat('outputs\', folders{i}, '\valueVis\'));
        saveas(f, strcat('outputs\', folders{i}, '\valueVis\', name, '.png'));
        savefig(f, strcat('outputs\', folders{i}, '\valueVis\', name, '.fig'));
        close all;
    end
    
    
    for als_pair = 1:6
        name = strcat(folders{i}, ' ', files{i}, ' valueVisNormalized - ALS PAIR ', string(als_pair));
        mkdir(strcat('outputs\', folders{i}));
        f = figure;
        surf(X, Y, Data_1.valueVisNormalized(:, :, als_pair));
        title(name);
        shading flat;
        view(0, 90);

        xlabel("\Theta (\circ)");
        ylabel("\Phi (\circ)");
        %colormap copper;
        
        xlim([0, 90]);
        ylim([0, 360]);
        caxis([-1, 1]);
        colorbar
        
        mkdir(strcat('outputs\', folders{i}, '\valueVisNormalized\'));
        saveas(f, strcat('outputs\', folders{i}, '\valueVisNormalized\', name, '.png'));
        savefig(f, strcat('outputs\', folders{i}, '\valueVisNormalized\', name, '.fig'));
        
        close all;
    end
    
%     for j = 1:numel(files)
%         current_file = strcat(base_path, folders{j}, '\', files{j}, '.mat');
%         load(current_file);
%         Data_2 = Data;
% 
%         valueVis_diff = Data_1.valueVis - Data_2.valueVis;
%         valuevisNormalized_diff = Data_1.valueVisNormalized - Data_2.valueVisNormalized;
% 
%         f = figure;
%         surf(X, Y, valueVis_diff(:,:, 1));
%         title(strcat(folders{i}, '/', files{i}, ' vs. ', folders{j}, '/', files{j}, ' valueVis Diff'));
%         shading flat;
%         colormap copper
%         close all;
% 
%         f = figure;
%         surf(X, Y, valuevisNormalized_diff(:,:, 1));
%         shading flat;
%         colormap copper
%         close all;
%     end
end
