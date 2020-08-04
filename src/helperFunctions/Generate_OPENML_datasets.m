function [Data, label, num_labels] = Generate_OPENML_datasets(case_name)
% Generate OPENML datapoints and labels

    file_name = strcat(case_name,'_all.mat');
    
    try
        M = load(file_name);
    catch
        error('You must load a .mat file');
    end

    % Takes the original labels for every point of the dataset
    data_labels   = table2array(M.(strcat(case_name,'_labels')));
    % Compute unique values of the labels with no repetition
    unique_labels = unique(data_labels);
    % Compute the number of unique labels
    num_labels    = size(unique_labels,1);

    % Take data points features from the dataset
    Data          = M.(strcat(case_name,'_data'));
    Data          = double(Data);
    n             = size(Data,1);
    label         = zeros(n,1);

    % Returns the labels normalized(from 0 to n)
    for i = 1:n
        % Returns the index of the array unique_labels that matches the value i 
        % of the original data_label
        label(i)  = find(unique_labels == data_labels(i))-1; %0 based labels
    end
end