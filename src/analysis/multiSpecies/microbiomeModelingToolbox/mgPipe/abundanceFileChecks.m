function [alt_abundance_filepath] = abundanceFileChecks(abunFilePath,resPath)

% Function to check if the abundance data is normalized and if there are
% empty columns.
% It normalizes each column which sum is not equal to 1 and removes all
% columns that which sum is equal to 0. It saves the altered abundance file
% in the resPath folder and returns its new location

% Usage alt_abundance_filepath = abundanceFileChecks(abunFilePath, resPath)
% Inputs:
%   abundFilePath = file path to the abundance file
%   resPath = path to the results directory

% Output:
%   alt_abundance_filepath = If changes were made to the abundance file,
%   the new file path. If no changes were made, it is the old file path

% Author: Bram Nap 04/2022

% Read the abundance table
abundance = readtable(abunFilePath);

% Initialise variables
cols2beRemoved = [];
changes =0;

% Check for each column the sum. If something has to be changed set changes
% to 1
for i = 2:size(abundance,2)
    col = table2array(abundance(:,i));
    if sum(col) == 0
        changes =1;
        message = strcat('Your sample ', abundance.Properties.VariableNames{i},' had a total relative abundance of 0, we removed the data for you');
        warning(message)
        cols2beRemoved(end+1) = i;
    elseif sum(col) ~= 1
        changes = 1;
        message = strcat('Your sample ', abundance.Properties.VariableNames{i},' relative abundances did not add up to 1, we normalised the data for you so the relative abundance add up to 1');
        warning(message)
        col_norm = col/sum(col);
        abundance(:,i) = array2table(col_norm);
    end
end

% Remove empty columns
abundance(:,cols2beRemoved) = [];

% Save the new file and obtain the new filepath
if strcmp(resPath(end), '\')
    savePath = strcat(resPath,'Abundances_altered_MgPipe.csv');
    writetable(abundance, savePath);
else
    savePath = strcat(resPath,'\','Abundances_altered_MgPipe.csv');
    writetable(abundance, savePath);
end

% Return the new filepath or the old filepath
if changes == 1
    warning('We altered your abundance data, the updated file can be found xx and will be used in the rest of MgPipe')
    alt_abundance_filepath = savePath;
else
    alt_abundance_filepath = abunFilePath;
end
end