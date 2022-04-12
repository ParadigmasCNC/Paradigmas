function Memory_Binding()
%%%%%%%%%% Memory Binding Paradigma
%%%%%%%%%% Psychtoolbox - Ineco - 2019
% Orig: INECO; Mod: PRG November 2019.
%
% TO-DO:
%  * implement TMS, ET & fMRI triggers.
%  * save times
%  * make log files complete
%  * check frame drops.
%  * transform to visual degrees
%  * Implemente keyboard settings (constrain, more keyboards, avoid
%  KbCheck, etc)
%  ... just look for the to-do's in the script!

home;
close all; % close all
clear log dirs ptb stim design screen do;

%% Genpath the folders for functions
dirs.Path_To_Files      = mfilename('fullpath');                             % Define path
dirs.Length_Script_Name = length(mfilename);                                 % Path name
dirs.ScriptPath         = dirs.Path_To_Files(1:end-dirs.Length_Script_Name); % Shorten and save path
addpath(genpath(dirs.ScriptPath));                                           % Add path for extra functions
cd(dirs.ScriptPath)                                                          % Go to path

%% GET MAIN STRUCTURES: DO, PTB, DESIGN
%-------------------------------------------------------------------------%
disp('Getting main structures: DO, PTB, DESIGN')
[do, ptb, design] = getExpSettings_WM();
%-------------------------------------------------------------------------%

% Skip sync
Screen('Preference', 'SkipSyncTests', 1)
%% Get subject settings
%-------------------------------------------------------------------------%
%......Subjects general data
% if strcmp(do.SubjData,'only')
%     disp('Get subjects general data')
%     SUB_DATA       = subjInfo_WM();
%     SubID          = SUB_DATA{1};
%     strSubjData    = [cd, '/Results/SubjData/', SubID{1}, '_' date, '_SubjData'];
%     save(strSubjData, 'SUB_DATA');
%     return
% elseif strcmp(do.SubjData,'also')
%     disp('Get subjects general data')
%     SUB_DATA       = subjInfo_WM();
%     SubID          = SUB_DATA{1};
%     strSubjData    = [cd '/Results/SubjData/' (SubID)  '_' date '_SubjData'];
%     save(strSubjData, 'SUB_DATA');
% elseif isempty(do.SubjData)
%     disp('');
% else error('do.SubjData wrongly defined. Check this please. We will stop now');
% end

%.....Get sessions data.
if ~iscell(do.subjVals)
    disp('Get the individual session data')
    [SUB] = subjInfo_WM();           % Create shorten GUI and ask for infos.
else
    SUB   = do.subjVals;             % Use given data.
end

% Paste info in matrix
SUBJECT_INFO{1,2} = SUB{1};          % Save subject specific variables (ID, Session, Stimuli)
SUBJECT_INFO{2,2} = SUB{2};
SUBJECT_INFO{3,2} = SUB(3);
SUBJECT_INFO{4,2} = SUB{4};
SUBJECT_INFO{5,2} = SUB(5);
SUBJECT_INFO{6,2} = SUB(6);

% SubjInfo Headears
SUBJECT_INFO{1,1} = 'ID';            % Add names to the variables.
SUBJECT_INFO{2,1} = 'Session';
SUBJECT_INFO{3,1} = 'StimuliAmount';
SUBJECT_INFO{4,1} = 'MetersToScreen';
SUBJECT_INFO{5,1} = 'CentimetersToScreen';
SUBJECT_INFO{6,1} = 'Version';

SubID                    = cell2mat(SUBJECT_INFO{1,2});
design.session           = SUBJECT_INFO{2,2};
design.AmountOfStimuli   = cell2mat(SUBJECT_INFO{3,2});
design.nShapeOnlyTrials  = 32;                 % Values must range from 32:16:inf if going to use fMRI
design.nShapeColorTrials = 32;                 % Define amount of trials, must be even if not in fMRI
design.DistanceToStim    = (str2double(SUB{4})*100 + str2double(SUB{5}))/100; % Define distance to stimuli for stimuli size
design.Version           = SUB(6);

%......Introductory session? --> run perception!
if strcmp(design.session,'Perception')
    do.Experiment      = 0;          % If its the very first session, show perception test and instructions
    do.Perception      = 1;
    do.ShowResultsToParticipant = 1; % Always for introduction and perception test. If 1 --> it will show the participant how good they were.
    ptb.instructions   = 'show';     % Always show instructions in the perception session.
    design.nTrials     = 10;
    design.showNtrials = design.nTrials;
    do.fMRI.flag       = [];
    do.TMS.flag        = [];
    do.ET.flag         = [];
elseif strcmp(design.session,'Task')
    do.Experiment      = 1;          % Show instructions and make a short test
    do.Perception      = 0;
    do.ShowResultsToParticipant = 1; % Always for introduction and perception test. If 1 --> it will show the participant how good they were.
    ptb.instructions   = 'show';     % Always show instructions in the introductory session.
    design.showNtrials = design.nTrials;
    do.fMRI.flag       = []; 
    do.TMS.flag        = [];
    do.ET.flag         = [];
else
    do.Experiment = 1;               % If its not the first session, start task and ALWAYS skip perception test
    do.Perception = 0;
end
%-------------------------------------------------------------------------%

%% Save diary for debugging and documentation reasons
%-------------------------------------------------------------------------%
ptb.debug = [];%'screen';
if ptb.debug
    log.diary = [SubID '_' design.session '_' date '_debug'];
    diary(log.diary);
    diary on
end

%% Print settings and wait for operator to accept
%-------------------------------------------------------------------------%
disp('=================CHECK SETTINGS====================');
disp(['Subj ID:   ' SubID]);
disp(['Running Session:  ' design.session]);
disp(['Amount of Stimuli:   ' num2str(design.AmountOfStimuli)]);
disp(['Amount of Trials:   ' num2str(design.showNtrials)]);
disp(['     inst.:  ' ptb.instructions]);
disp('===================================================');
log.reply = input('START EXPERIMENT WITH THESE SETTINGS? y/n [y]:','s');
if strcmp(log.reply,'n') == 1
    warning('We are now stopping this run.');
    return;
elseif strcmp(log.reply,'y') == 1
    disp('STARTING THE EXPERIMENT')
else
    log.reply = 'y';
    disp('STARTING THE EXPERIMENT BY DEFAULT')
end

%% Define paths, add path and go to path.
%-------------------------------------------------------------------------%
imageFolder = 'Stimuli'; TaskShapesOnly = 'ShapesOnly'; PerceptionShapes = 'ShapesColor';

%.....How many stimuli to use?
if isequal(design.AmountOfStimuli, '2'),     StimuliFolder = 'two';
elseif isequal(design.AmountOfStimuli, '3'), StimuliFolder = 'three';
elseif isequal(design.AmountOfStimuli, '4'), StimuliFolder = 'four';
end

%....Path to stimuli folder
dirs.Path_ShapeOnly_Stimuli  = [dirs.ScriptPath, imageFolder, '/', StimuliFolder, '/', TaskShapesOnly];
dirs.Path_Perception_Stimuli = [dirs.ScriptPath, imageFolder, '/', StimuliFolder, '/', PerceptionShapes];
dirs.Path_Black_Bar          = [dirs.ScriptPath, imageFolder, '/'];

%....Get image names
dirs.TaskShapeOnlyStimuliDir = dir(dirs.Path_ShapeOnly_Stimuli);
dirs.PerceptionStimuliDir    = dir(dirs.Path_Perception_Stimuli);

%% Start PTB settings.
%-------------------------------------------------------------------------%
% Keyboard setup; To-do receive answer from 2 keyboards, keyQueueCheck and
% KbEventAvail. Also: constrain the buttons you read.
KbName('UnifyKeyNames');

% Define screen and windows settings
ptb.scrn.n          = max(Screen('Screens'));             % get maximum screen.
ptb.scrn.res        = Screen('Resolution', ptb.scrn.n);   % get resolution from the screen you use.
ptb.w.white         = WhiteIndex(ptb.scrn.n);             % white
ptb.w.black         = BlackIndex(ptb.scrn.n);             % black
ptb.w.gray          = round((ptb.w.white+ptb.w.black)/2); % gray
ptb.backgroundColor = 192;                                % background --> Same colour as images; keep it this way.

% Skip tests only if debugging, else don't.y
if     ~ptb.debug;                 Screen('Preference', 'SkipSyncTests', 0);
elseif strcmp(ptb.debug,'key');    Screen('Preference', 'SkipSyncTests', 1);
elseif strcmp(ptb.debug,'screen'); Screen('Preference', 'SkipSyncTests', 0);
end

% Open screen and get size.
if strcmp(ptb.debug,'screen') == 1 % if no debug - open full size
    [ptb.w.pointer, ptb.w.rect] = Screen('Openwindow',ptb.scrn.n,ptb.backgroundColor,[0 0 640 480],[],2); % 640*480 a modificar
else
    HideCursor()                   % only if you are not debugging or keypress debugging.
    [ptb.w.pointer, ptb.w.rect] = Screen('Openwindow',ptb.scrn.n,ptb.backgroundColor,[0 0 ptb.scrn.res.width ptb.scrn.res.height],[],2); % 640*480 a modificar
end

ptb.scrn.ifi     = Screen('GetFlipInterval', ptb.w.pointer);                  % Get inter frame interval
ptb.scrn.Slack   = Screen('GetFlipInterval', ptb.w.pointer)/2;                % Get half of the ifi
ptb.w.W          = ptb.w.rect(RectRight);                                     % screen width
ptb.w.H          = ptb.w.rect(RectBottom);                                    % screen height
%ptb.New.fontSize = 30*(design.DistanceToStim/0.3)*ptb.w.W/640;                % default fontsize for the whole experiment.(requires distancetostim)
%disp(ptb.New.fontSize);
%ptb.Old.fontSize = Screen('Preference', 'DefaultFontSize', [ptb.New.fontSize]);

Screen(ptb.w.pointer,'FillRect',ptb.backgroundColor);                         % Fill with background color
Screen('Flip', ptb.w.pointer);                                                % First flip.

% Retreive the maximum priority number and use it!
ptb.topPriorityLevel = MaxPriority(ptb.w.pointer);
Priority(ptb.topPriorityLevel);

% Preallocate dummy image.
stim.Image_Dummy1                         = uint8(zeros(ptb.w.W,ptb.w.H,3)); % create
stim.Image_Dummy1(stim.Image_Dummy1 == 0) = ptb.backgroundColor;             % make it background
%-------------------------------------------------------------------------%

%% Create Stimulation design
%-------------------------------------------------------------------------%
[stim, dirs] = Memory_Binding_Stimuli_Position_WM(stim,design,ptb,dirs);

%% Permute trials
%-------------------------------------------------------------------------%
% To-do: either sub-function, optimize, clear.
if strcmp(design.session, 'Perception')
    Permutation_Perception = randperm(size(stim.Stimuli_Perception_Database,2));
    Permutation_Perception(Permutation_Perception == 1 | Permutation_Perception == 2) = [];
    stim.Stimuli_Perception_Database = stim.Stimuli_Perception_Database(:,[1,2,Permutation_Perception]);
    
else
    Permutation_TaskShapeOnly = randperm(size(stim.Stimuli_Task_ShapeOnly_Database,2));
    Permutation_TaskShapeOnly(Permutation_TaskShapeOnly == 1 | Permutation_TaskShapeOnly == 2) = [];
    
    Permutation_TaskShapeColor = randperm(size(stim.Stimuli_Task_ShapeColor_Database,2));
    Permutation_TaskShapeColor(Permutation_TaskShapeColor == 1 | Permutation_TaskShapeColor == 2) = [];
    
    stim.Stimuli_Task_ShapeOnly_Database  = stim.Stimuli_Task_ShapeOnly_Database(:,[1,2,Permutation_TaskShapeOnly]);
    stim.Stimuli_Task_ShapeColor_Database = stim.Stimuli_Task_ShapeColor_Database(:,[1,2,Permutation_TaskShapeColor]);
end


%% Make log cell for saving responses per trial
%-------------------------------------------------------------------------%
if strcmp(design.session,'Task')
    log.Trial_Order_TaskShapeColor = stim.Stimuli_Task_ShapeColor_Database(1,3:end)';
    log.responses_subj(2:length(log.Trial_Order_TaskShapeColor)+1,1) = log.Trial_Order_TaskShapeColor(:,1);
    log.responses_subj{1,1} = 'Trials';
    log.responses_subj{1,2} = 'Different';
    log.responses_subj{1,3} = 'Same';
    log.responses_subj{1,4} = 'Reaction_Time';
    log.responses_subj{1,5} = 'Hits';
else
    log.Trial_Order_Perception = stim.Stimuli_Perception_Database(1,3:end)';
    log.responses_subj(2:length(log.Trial_Order_Perception)+1,1) = log.Trial_Order_Perception(:,1);
    log.responses_subj{1,1} = 'Trials';
    log.responses_subj{1,2} = 'Different';
    log.responses_subj{1,3} = 'Same';
    log.responses_subj{1,4} = 'Reaction_Time';
    log.responses_subj{1,5} = 'Hits';
end

%% Generate Textures for presentation
%-------------------------------------------------------------------------%
 [stim] = generate_Textures_WM(stim,ptb,dirs,design,do);

%% Start TMS
%-------------------------------------------------------------------------%
if do.TMS.flag == 1
    % PLACE HOLDER; To-do
end

%% Start ET
%-------------------------------------------------------------------------%
if do.ET.flag == 1
    % PLACE HOLDER; To-do
end

%% Start fMRI
%-------------------------------------------------------------------------%
if do.fMRI.flag == 1
    % PLACE HOLDER; To-do
end

%% Run perception or experiment
%-------------------------------------------------------------------------%
if do.Perception == 1
    [log, stim] = runPerception_WM(ptb,stim,design,log,dirs,do);
elseif do.Experiment == 1
    [log, stim] = runShapeColor_WM(ptb,stim,design,log,dirs,do);
end

%% Print a last text regardless of what happened before
%-------------------------------------------------------------------------%
RunFinishedTxt = DrawFormattedText(ptb.w.pointer,'Run completed! Congratulations!', 'center','center',ptb.fontColor);
%Screen('TextSize', ptb.w.pointer, 30*(design.DistanceToStim/0.3));
Screen('Flip',ptb.w.pointer, RunFinishedTxt)
WaitSecs(2)

%% Save everything (Subj Answers + SubjData)
%-------------------------------------------------------------------------%
% We are now going to save the: SUBJ_ANSWERS and if necessary SUBJECT_DATA
% Regardless of what happened before.
% To-do: IT WILL NOW OVERWRITE IF YOU USE THE SAME SESSIONS DURING THE SAME
% DAY! Add safety net.
strSubjAnswers  = [cd '/Results/SubjAnswers/' 'Subject_' (SubID) '_' design.session '_' date '_Answers.mat'];
save(strSubjAnswers,'SUB','log', 'ptb','stim','design','dirs', 'do');

if ischar(do.SubjData)
    strSubjData = [cd '/Results/SubjData/' (SubID) '_' design.session '_' date '_SubjData'];
    save(strSubjData, 'SUB_DATA');
end

%% Print some information
%-------------------------------------------------------------------------%
if do.Experiment == 1
    disp(cell2table(stim.Stimuli_Task_ShapeColor_Database(2:end,:),'VariableNames', stim.Stimuli_Task_ShapeColor_Database(1,:)));
    disp(['Subj ID:   ' SubID]);
    disp(['Session Nr. or Type:   ' design.session]);
    disp(['Mean reaction time is:   ' num2str(mean(cell2mat(log.responses_subj(2:end,4))))]);
    disp(['Mean retention times:    ' num2str(mean(design.retentionTimes))]);
    disp(['Total number of trials shown:   ' num2str(design.showNtrials) '  out of  ' num2str(design.nTrials)]);
    disp(['Amount of stimuli:    ' num2str(design.AmountOfStimuli)]);
    disp(['Accuracy as %-correct:    ' num2str(sum(cell2mat(log.responses_subj(2:end,5)))/design.showNtrials*100)]);
end

%% Close everything
%-------------------------------------------------------------------------%
if ptb.debug; diary off; end
Priority(0);
sca;

end