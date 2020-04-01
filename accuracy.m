function [ ] = accuracy( gt, segmentation )

    %% number of objects (labels) in gt
    labels_gt = unique(gt);
    num_labels_gt = length(labels_gt);

    %% number of objects (labels) in segmentation
    labels_segmentation = unique(segmentation);
    num_labels_segmentation = length(labels_segmentation);

    F = zeros(num_labels_gt, num_labels_segmentation);
    P = zeros(num_labels_gt, num_labels_segmentation);
    R = zeros(num_labels_gt, num_labels_segmentation);
    IoU = zeros(num_labels_gt, num_labels_segmentation);

    for i = 1:num_labels_gt
        
        gt_i = zeros(size(gt));
        gt_i(gt == labels_gt(i)) = 1;
        
        for j = 1:num_labels_segmentation
            
            segmentation_j = zeros(size(segmentation));
            segmentation_j(segmentation == labels_segmentation(j)) = 1;
            
            % true positive (intersection)
            A = segmentation_j+gt_i;
            tp = sum(sum(sum(A == 2)));
            % union
            union = sum(sum(sum(A>0)));
            
            %% precision_i
            P(i,j) = tp/sum(sum(sum(segmentation_j)));
            
            %% recall_i
            R(i,j) = tp/sum(sum(sum(gt_i)));
            
            %% f-measure_i
            F(i,j) = (2*P(i,j)*R(i,j))/(P(i,j)+R(i,j));
            
            %% intersection over union
            IoU(i, j) = tp/union;
            
        end
        
    end
    
    P(isnan(P))=0;
    R(isnan(R))=0;
    F(isnan(F))=0;
    IoU(isnan(IoU))=0;

    %% find correct object label matches and corresponing measurements
    [~, selected_idx, num_obj_detected] = multi_label_eval(F, 'threshold', 0.75);

    %% accuracy
    F_obj = F(selected_idx);
    P_obj = P(selected_idx);
    R_obj = R(selected_idx);
    IoU_obj = IoU(selected_idx);
    F_final = sum(F_obj)./num_labels_gt;
    P_final = sum(P_obj)./num_labels_gt;
    R_final = sum(R_obj)./num_labels_gt;
    IoU_final = sum(IoU_obj)./num_labels_gt;
    obj_detected_075 = num_obj_detected;
    obj_detected = num_labels_segmentation;
    obj_gt = num_labels_gt;

end

