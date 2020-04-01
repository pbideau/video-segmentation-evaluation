function [ ] = evaluation( pathResult, pathFrames, pathGroundtruth, varargin )
    %% Parse varargins
    for i = 1:length(varargin)
        if (strcmp(varargin{i}, 'mode'))
            assert(length(varargin) > i, 'missing value for option ''mode''');
            assert(ischar(varargin{i+1}), 'value for option ''mode'' must be a string');
            mode = varargin{i+1};
        end
    end

    %% read video names
    video = dir(pathResult);
    video = video(~ismember({video(:).name},{'.','..'}));
    
    %% initialize
    F_final_all = zeros(length(video),1);
    P_final_all = zeros(length(video),1);
    R_final_all = zeros(length(video),1);
    IoU_final_all = zeros(length(video),1);
    obj_detected_all = zeros(length(video),1);
    obj_detected_075_all = zeros(length(video),1);
    obj_gt_all = zeros(length(video),1);
    
    %% loop over videos in data set
    for u = 1:length(video)
 
        gt =[];
        segmentation = [];

        %% read segmentations (png)
        pathResultVideo = fullfile(pathResult, video(u).name);
        listSegments = dir(fullfile(pathResultVideo, '*.png'));
        listSegments = extractfield(listSegments, 'name')';

        %% read frames
        pathFramesVideo = fullfile(pathFrames, video(u).name);
        listFrames = [dir(fullfile(pathFramesVideo, '*.pgm')); dir(fullfile(pathFramesVideo, '*.png')); dir(fullfile(pathFramesVideo, '*.jpg'))];
        listFrames = extractfield(listFrames, 'name');
        
        %% read frames
        pathGroundtruthVideo = fullfile(pathGroundtruth, video(u).name);

        %% load all gt and segmentation files
        t = 1;
        for i = 1:length(listFrames)-1
            [~,frame_name,~] = fileparts(fullfile(pathFramesVideo, listFrames{i}));
            
            frame_name = split(frame_name, "_");
            frame_name = frame_name{end};
            num = str2num(cell2mat(regexp(frame_name,'\d*','Match'))); % extract frame number
            
            gt_name = sprintf('%05d.png', num); % needs to be modified if naming of gt file is different
            
            %% load estimated segmentation if matching gt file exists
            if isfile(fullfile(pathGroundtruthVideo, gt_name))
                gt(:,:,t) = imread(fullfile(pathGroundtruthVideo, gt_name));
                [h, w, ~] = size(gt);
                s = imread(fullfile(pathResultVideo, listSegments{i}));
                segmentation(:,:,t) = s(:,:,1);
                t = t+1;
            end
        end
        
        %% compute accuracy
        if strcmp(mode, 'binary')
            gt(gt>0)=1; % make multilabel segmentation binary
        end

        [ F_final, P_final, R_final, IoU_final, obj_detected, obj_detected_075, obj_gt ] = accuracy( gt, segmentation );
               
        F_final_all(u) = F_final;
        P_final_all(u) = P_final;
        R_final_all(u) = R_final;
        IoU_final_all(u) = IoU_final;
        obj_detected_075_all(u) = obj_detected_075;
        obj_detected_all(u) = obj_detected;
        obj_gt_all(u) = obj_gt;

    end
    
    fprintf('P-mean: %02f\n', mean(P_final_all)*100);
    fprintf('R-mean: %02f\n', mean(R_final_all)*100);
    fprintf('F-mean: %02f\n', mean(F_final_all)*100);
    fprintf('IoU-mean: %02f\n', mean(IoU_final_all)*100);
    fprintf('delta-object: %02f\n', mean(abs(obj_detected_all-obj_gt_all)));
    
end

