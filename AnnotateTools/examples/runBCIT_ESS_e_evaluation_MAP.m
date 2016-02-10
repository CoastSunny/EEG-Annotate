%% evaluation
% 
%  Assumption: VEP training set of (18 subjects odd-test)
%

targetClasses = {'1311', '1321', '1331', '1341', '1351', '1361'};   % hit if it is any one of these class
t_tolerance = 0:7;      % timing tolerance

%% set path to test set
level2DerivedFile = 'studyLevelDerived_description.xml';

fileListIn = 'Z:\Data 3\BCIT_ESS\BCIT_ESS_256Hz_ICA_Informax_MARA\';	% to get the list of test files
scoreIn = 'Z:\Data 3\BCIT_ESS\BCIT_ESS_256Hz_ICA_Informax_MARA_featureA_scoreA\';
resultOut = 'Z:\Data 3\BCIT_ESS\BCIT_ESS_256Hz_ICA_Informax_MARA_featureA_scoreA_results\';

testNames = {'X3 Baseline Guard Duty'; ...
            'X4 Advanced Guard Duty'; ...
            'Experiment X2 Traffic Complexity'; ...
            'Experiment X6 Speed Control'; ...
            'Experiment XB Baseline Driving'; 
            'Experiment XC Calibration Driving'; ...
            'X1 Baseline RSVP'; ...
            'X2 RSVP Expertise'};

for t=1:length(testNames)
    testName = testNames{t};
    
    fileListDir = [fileListIn testName]; 

    % Create a level 2 derevied study
    %  To get the list of file names
    derivedXMLFile = [fileListDir filesep level2DerivedFile];
    obj = levelDerivedStudy('levelDerivedXmlFilePath', derivedXMLFile);
    [filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = getFilename(obj);
    
    % go over all test sets and estimate scores
    testsetNumb = length(filenames);
    
    APs = zeros(testsetNumb, length(t_tolerance)); % avrage precisions
    
%    for testSubjID=1:testsetNumb
    for testSubjID=1:2
        [path, name, ext] = fileparts(filenames{testSubjID});
        scoreDir = [scoreIn testName filesep 'session' filesep sessionNumbers{testSubjID}];
        load([scoreDir filesep name '.mat']);  % load scoreData

        trueLabel = scoreData.trueLabelOriginal{1};
        trueLabelBinary = zeros(size(trueLabel));
        
        numbEvent = 0;
        for s=1:length(trueLabel)
            if ~isempty(trueLabel{s})
                for i1=1:length(trueLabel{s})
                    numbEvent = numbEvent + 1;
                    for i2=1:length(targetClasses)
                        if strcmp(trueLabel{s}{i1}, targetClasses{i2})
                            trueLabelBinary(s) = 1;
                        end
                    end
                end
            end
        end
        fprintf('test subject, %d, has %d targets, in %d events, in %d samples\n', ...
                    testSubjID, sum(trueLabelBinary), numbEvent, length(trueLabel));
                
        score = scoreData.combinedScore{1};
        if length(trueLabelBinary) ~= length(score)
            error('data lengths are not matched');
        end
        for tID = 1:length(t_tolerance)
            tol = t_tolerance(tID);
            APs(testSubjID, tID) = evaluate_AP(trueLabelBinary, score, tol);
        end
    end
    saveName = 'target';
    for cID = 1:length(targetClasses)
        saveName = [saveName '_' targetClasses{cID}];
    end
    saveName = [saveName '_MAP'];
    resultDir = [resultOut testName];
    if ~isdir(resultDir)   % if the directory is not exist
        mkdir(resultDir);  % make the new directory
    end        
    save([resultDir filesep saveName '.mat'], 'APs', '-v7.3');
    disp(mean(APs, 1));   % MAP (mean of average precision)
end