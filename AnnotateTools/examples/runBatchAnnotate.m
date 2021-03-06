%% This script annotates a data collection that has been classified 
%
% The results are written as annotData structures to files
%
%% Set the directories for input and output as well as the other parameters
inPathBase = 'D:\Research\Annotate\Kay\Data2\VEP_PREP_ICA_VEP2_MARA_averagePower';
outPathBase = 'D:\Research\Annotate\Kay\Data2\VEP_PREP_ICA_VEP2_MARA_averagePower';
targetClasses = {'34', '35'};
targetClassifiers = {'LDA', 'ARRLS', 'ARRLSMod', 'ARRLSimb'};
params = struct();
outType = '_Annotation_';
%params.AnnotateBadTrainFiles = {'vep_17'};

%% BCIT
% inPathBase = 'D:\Research\Annotate\Kay\Data1\BCIT_ESS_PREP_ICA_BCIT2_MARA_averagePower';
% outPathBase = 'D:\Research\Annotate\Kay\Data1\BCIT_ESS_PREP_ICA_BCIT2_MARA_averagePower';
% targetClasses = {'34', '35'};
% %targetClassifiers = {'LDA', 'ARRLS', 'ARRLSMod', 'ARRLSimb'};
% targetClassifiers = {'ARRLSimb'};
% params = struct();
% outType = '_Annotation_No17_';
% params.AnnotateBadTrainIndices = 17;


%% Perform the annotation
for n = 1:length(targetClassifiers)
    for k = 1:length(targetClasses)
        inPath = [inPathBase '_' targetClassifiers{n} '_' targetClasses{k}]; 
        outPath = [outPathBase '_' targetClassifiers{n} outType targetClasses{k}]; 
        batchAnnotate(inPath, outPath, targetClasses{k}, params);
    end
end