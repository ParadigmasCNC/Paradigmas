%%%%%%%% Action-word semantic task %%%%%%%%
% Task definition: (FILL IT WITH INFO OF THE TASK)
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:  - EEG           - Training
%          - Code          - Age
%          - Laterality    - Subject Number
%          - Stimuli list  - Training List (Column 1 of xlsx)
%          - Stimuli code  - Stimuli corr answer  (Columns 2 and 3 of xlsx)
%
%
% Outputs: - log: .inputs 
%                 .response matrix
%                 .texts
%                 .events 
%                 .word lists
%                 .amount of trials (same as size of lists)
%                 .log.data structure with stuff
%
%          - ptb: .psychtoolbox stuff
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Event codes: - trainingStart     = 200;
%              - trainingEnd       = 210;
%              - taskStart         = 201;
%              - taskEnd           = 211;
%              - instructionsStart = 202;
%              - instructionsEnd   = 212;
%              - firstBlockStart   = 203;
%              - firstBlockEnd     = 213;
%              - breakStart        = 205;
%              - breakEnd          = 215;
%              - secondBlockStart  = 204;
%              - secondBlockEnd    = 214;
%              - fixCrossStart     = 1;
%              - fixCrossEnd       = 11;
%              - IAmStart          = 101;
%              - IAmEnd            = 111;
%              - wordStart         = 102;
%              - wordEnd           = 112;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% created 17th December 2021 by JBerger
% 27/12/21 start mod: Matias E. Fraile-Vazquez
% 4/1/22 end mod: Matias E. Fraile-Vazquez
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------------------------------------------------%
%% Start code by clearing
clear; close all; clc


%% Add paths
log.data.basePath    = mfilename('fullpath');                   % Script Path
log.data.basePath    = strsplit(log.data.basePath,'\');         % Split to go one back
log.data.basePath    = strjoin(log.data.basePath(1:end-1),'\'); % Join to get the base
log.data.stimuliPath = [log.data.basePath,'\Stimuli'];          % Add stimuli
log.data.fxPath      = [log.data.basePath,'\fx'];               % Add functions
log.data.outPath     = [log.data.basePath,'\Results'];          % Add output path

% Add functions to path
addpath(log.data.fxPath)


%-------------------------------------------------------------------------%
%% Pre-define Stuff
% Triggers, durations and counter for log
log.data.send_triggers = 0;   % boolean for sending triggers
log.data.respDur       = 1.4; % maximum time allowed for responding (in seconds)
log.data.fixationTime  = 0.8; % in seconds
counter                = 2;   % counter for log (start at 2 due to header)

% Will randomise between these two values
log.data.randTimes.IAmmin = 0.3; % in seconds
log.data.randTimes.IAmmax = 0.5; % in seconds

% Space presses to map instructions
extra.pressedSpace1 = 0;
extra.pressedSpace2 = 0;

% Add usual stuff: EEG, Training, Code, Age, Laterality. (Subject number should be in code but im leaving...
% it due in case you need it as a single variable)
answer         = menu('EEG','Yes','No');
if answer == 2; answer = 0; end 
log.EEG        = answer;                             % EEG
answer         = menu('Training','Yes','No');
if answer == 2; answer = 0; end 
log.training   = answer;                           % Training
log.code       = char(inputdlg('Subject Code'));           % Code
log.age        = inputdlg('Age');                    % Age
log.age        = str2double(log.age);
laterality     = {'Left','Right', 'Ambi'};           % Define possible lateralities
answer         = menu('Laterality','Left','Right','Ambi'); % Laterality
log.laterality = laterality{answer};                 % Indexing
log.subj_num   = inputdlg('Subject Number');    % Subject number (should be in code)
log.subj_num   = str2double(log.subj_num);
clear answer

% Create results matrix
log.results{1,1} = 'Trial';
log.results{1,2} = 'Answer';
log.results{1,3} = 'Accuracy';
log.results{1,4} = 'reactionTime';
log.results{1,5} = 'Time';
log.results{1,6} = 'EventNumber';
log.results{1,7} = 'EventName';


%-------------------------------------------------------------------------%
%% Instruction text (This should be moved to fx but im leaving it here,...
%  ... for the researcher to have an easier time modifying it)

log.texts.welcomeTxt = {['Welcome! Thank you for participating in our experiment.',...
    newline,...
    'We will proceed to explain the task.',... 
    newline,...
    newline,...
    'Press space to continue']};

log.texts.insTxt = {['Please focus on the cross between trials. You will then see the words "I am".',...
    newline,...
    'These will be followed by a single word. When this word comes up, please ',...
    newline,...
    'respond as quickly as possible to indicate whether this word was a real',...
    newline,...
    'English word (left arrow) or not a real English word (right arrow).',...
    newline,...
    newline,...
    'Press space to continue']};

log.texts.startTaskTxtNT = {['If you have doubts about the task, ask the researcher now.',...
    newline,...
    'If you feel confident about your understanding of the task,',...
    newline,...
    'press space and start the real task.',...
    newline,...
    newline,...
    'Press space to start the task']};

log.texts.trainingTxt = {['In order for us to make sure you understood the task',...
    newline,...
    'we will test you with some training trials.',...
    newline,...
    'This results will not be taken into account.',...
    newline,...
    'If you have any doubt, please contact the researchers before continuing.',...
    newline,...
    'If you have no more questions, you can start the training.',...
    newline,...
    newline,...
    'Press space to start the training']};

log.texts.startTaskTxt = {['Good job! If you still have doubts about the task, ask the researcher now.',...
    newline,...
    'If you feel confident about your understanding of the task,',...
    newline,...
    'press space and start the real task.',...
    newline,...
    newline,...
    'Press space to start the task']};

log.texts.breakTxt = {['You are doing great',...
    newline,...
    'You will now take a short break before continuing',...
    newline,...
    newline,...
    'Press space to continue the task']};


%-------------------------------------------------------------------------%
%% Define event numbers (this ones will be triggered to the EEG)
log.events.trainingStart     = 200;
log.events.trainingEnd       = 210;
log.events.taskStart         = 201;
log.events.taskEnd           = 211;
log.events.instructionsStart = 202;
log.events.instructionsEnd   = 212;
log.events.firstBlockStart   = 203;
log.events.firstBlockEnd     = 213;
log.events.breakStart        = 205;
log.events.breakEnd          = 215;
log.events.secondBlockStart  = 204;
log.events.secondBlockEnd    = 214;
log.events.fixCrossStart     = 1;
log.events.fixCrossEnd       = 11;
log.events.IAmStart          = 101;
log.events.IAmEnd            = 111;
log.events.wordStart         = 102;
log.events.wordEnd           = 112;


%-------------------------------------------------------------------------%
%% Ensure triggers cleared (if sending) and set up audio buffer & levels
[counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN, 888, 'ClearTrigger', NaN, counter);


%-------------------------------------------------------------------------%
%% Load TRAINING (if doing training) and TASK log.data
cd(log.data.stimuliPath)
% Training
if log.training
[~, ~, log.wordListTraining] = xlsread('ActionVerbWordsTraining.xlsx');
log.numTrialsTraining        = size(log.wordListTraining,1);
extra.currTrialIAmTraining   = nan(1,log.numTrialsTraining);
extra.respTimeTraining       = nan(1,log.numTrialsTraining);  
end

% Task
[~, ~, log.wordList] = xlsread('ActionVerbWords.xlsx');
log.numTrials        = size(log.wordList,1);
extra.currTrialIAm   = nan(1,log.numTrials);
extra.respTime       = nan(1,log.numTrials);


%-------------------------------------------------------------------------%
%% CONFIRM log.data TO START TASK
disp('=================CHECK SETTINGS====================');
disp(['Subj ID:            ' log.code]);
disp(['Subj Number:        ' num2str(log.subj_num)]);
disp(['Age:                ' num2str(log.age)]);
disp(['Laterality:         ' log.laterality]);
disp(['EEG:                ' num2str(log.EEG)]);
disp(['Training:           ' num2str(log.training)]);
disp(['Amount of Trials:   ' num2str(log.numTrials)]);
disp('===================================================');
log.reply = input('START EXPERIMENT WITH THESE SETTINGS? y/n [y]:','s');

% Check if we stop or continue
if strcmp(log.reply,'n') == 1
    warning('We are now stopping this run.');
    return;
elseif strcmp(log.reply,'y') == 1
    disp('STARTING THE EXPERIMENT')
else
    log.reply = 'y';
    disp('STARTING THE EXPERIMENT BY DEFAULT')
end


%-------------------------------------------------------------------------%
%% PTB Initialize
% Keyboard setup, cursor and sync test
KbName('UnifyKeyNames');
Screen('Preference', 'SkipSyncTests', 1); 
HideCursor(); % Hide the cursor

% Define screen and windows settings
ptb.scrn.n          = max(Screen('Screens'));             % get maximum screen.
ptb.scrn.res        = Screen('Resolution', ptb.scrn.n);   % get resolution from the screen you use.
ptb.w.white         = WhiteIndex(ptb.scrn.n);             % white
ptb.w.black         = BlackIndex(ptb.scrn.n);             % black
ptb.w.gray          = round((ptb.w.white+ptb.w.black)/2); % gray
ptb.backgroundColor = 192;                                % background --> Same colour as Text; keep it this way.
ptb.fontColor       = [255 0 0];

% Open window
[ptb.w.pointer, ptb.w.rect] = Screen('Openwindow',ptb.scrn.n,ptb.backgroundColor,[0 0 ptb.scrn.res.width ptb.scrn.res.height],[],2);

% Get ifi, slack, width and height
ptb.scrn.ifi     = Screen('GetFlipInterval', ptb.w.pointer);    % Get inter frame interval
ptb.scrn.Slack   = Screen('GetFlipInterval', ptb.w.pointer)/2;  % Get half of the ifi (take it off RT)
ptb.w.W          = ptb.w.rect(RectRight);                       % screen width
ptb.w.H          = ptb.w.rect(RectBottom);                      % screen height
Screen(ptb.w.pointer,'FillRect',ptb.backgroundColor);           % Fill with background color
Screen ('TextSize',ptb.w.pointer,ptb.w.H/20);                   % Change text size to match screen
Screen('Flip', ptb.w.pointer);                                  % First flip.

% Retreive the maximum priority number and use it!
ptb.topPriorityLevel = MaxPriority(ptb.w.pointer);
Priority(ptb.topPriorityLevel);


%-------------------------------------------------------------------------%
%% Run TASK with TRAINING
if log.training
    [log, extra, counter] = runTraining(log, counter, ptb, extra);
    [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN, log.events.trainingEnd, 'TrainingEnd', toc, counter);
    [log, extra, counter] = runTask(log, counter, ptb, extra); %#ok
else % Run TASK without TRAINING
    [log, extra, counter] = runTask(log, counter, ptb, extra); %#ok
end

%-------------------------------------------------------------------------%
%% Finish task
% Trigger block finishes
[counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN, log.events.secondBlockEnd, 'SecondBlockEnd', toc, counter);

% Display goodbye text
Instructions = DrawFormattedText(ptb.w.pointer,'All done! Thank you for your time!','center','center',ptb.fontColor);
Screen('Flip',ptb.w.pointer, Instructions)

% Give it 5 seconds
WaitSecs(5);

% Trigger end, enable keyboard, save log.data
[counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN, log.events.taskEnd, 'TaskEnds', toc, counter); %#ok

% Enable keyboard and close all
ListenChar(0); % enable keyboard
Priority(0);
sca;

% Clear things we dont care about
clear extra cckey counter i jHand keyCode keyCount keyIsDown log.data Instructions laterality ans


%-------------------------------------------------------------------------%
%% Save information, show cursor clear and thanks
cd(log.data.outPath)
save([num2str(log.subj_num) '_' datestr(now,'mm-dd-yyyy HH-MM')])
ShowCursor()
clc
disp('Thanks for participating :)');


%-------------------------------------------------------------------------%
%% Send trigger function
function [counter, log] = sendTrigger(log, trial, answer, accuracy, rt, eventNumber, eventName, eventTime, counter)
    % Send Trigger
    if log.EEG
        outportb(888,eventNumber);
        pause(0.001)
        outportb(888,0);
    end
    % Log
    log.results{counter,1} = trial;
    log.results{counter,2} = answer;
    log.results{counter,3} = accuracy;
    log.results{counter,4} = rt;
    log.results{counter,5} = eventTime;
    log.results{counter,6} = eventNumber;
    log.results{counter,7} = eventName;
    counter = counter + 1;
end