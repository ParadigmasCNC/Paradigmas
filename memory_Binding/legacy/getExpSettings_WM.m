function [do, ptb, design] = getExpSettings_WM()
% This function defines WHAT you will do and HOW you will do it.
% Please take your time to define the parameters.
% Output: do,ptb,design structures.
% Orig: PRG 11/2019

%% DO-STRUCTURE: define what to DO. 
%-------------------------------------------------------------------------%
% The "do" structure is where you tell the script WHAT TO DO. Modify
% according to your needs.
%
% --> do.SubjData = 'only'/'also'/[];
% If you select do.SubjData = 'only' the script will ONLY run the
% collection of subject data.
% If you select do.SubjData = 'also' this will occur at the beginning.
% If empty --> it skips the collection of subj data (age, education, exp,
% etc).
%
% --> do.SubjVals = {{'SUBJECT_ID'};'SESSION_NR';'AMOUNT_OF_STIMULI'} / [];
% If you give inputs, give ALL as strings.
% Please note that AMOUNT_OF_STIMULI can be 2,3,4. To-do: add safety net.
% If empty -> ui control callback to get Infos. This is the default.
%
% --> do.HowManyTrials = 'all' / 'half' or a NUMBER
% Use this to decide HOW many trials to show (e.g. just to show a couple of
% them. IMPORTANT: This ONLY works for TASK! The perception test will
% always have 10 trials.
%
% --> do.ShowResultsToParticipant == 1 or [];
% Show the results (reaction time + accuracy) in the end of the runs to
% your participant.
%
% --> do.Experiment & do.PerceptionTest == 0 or 1.
% Please notice that the SESSION INPUT will control if you show
% the perception test or run a task!
% If Session = "introduction" -->  Experiment = 0; PerceptionTest = 1
% If Session = "a number"     --> Experiment = 1; PerceptionTest = 0
%
% --> do.fMRI.flag == 0 or 1
% If 1, waits for fMRI triggers, if 0 run without fMRI triggers
%
% --> do.TMS.flag == 0 or 1
% If 1, run with TMS, if 0 run without TMS
%
% --> do.ET.flag == 0 or 1
% If 1, run with EyeTracker, if 0 run without EyeTracker

%....Define "DO" structure
do.HowManyTrials = 'all'; % 'all', 'half' or a NUMBER % Only for TASK!
do.ShowResultsToParticipant = 1;  % If 1 --> show results to participant
do.SubjData   = 'only'; % 'only' / 'also' / [];
do.subjVals   = []; % Some input as: {{'test'};'1';'2'} or [];
do.EEG.flag   = '1'; % '1' / [];
%-------------------------------------------------------------------------%


%% PTB-STRUCTURE: Control PsychToolBox
%-------------------------------------------------------------------------%
% The "ptb" (aka. PsychToolBox) structure defines HOW and WHAT to run 
% the experiment in PTB. This CAN and SHOULD be extended.
%
% --> ptb.debug = 'screen' / 'key' / [];
% 'screen' = Screen debug mode. llows you to run the script in debug mode. 
% It will only show the stimuli in a portion of the screen, save a txt file
% with the history of Command Window, dont hide the cursor and skip sync tests.
% 'key' = Keyboard debug mode. Not implemented yet in detail. For now it's
% the same as the 'screen' mode.
%
% --> ptb.instructions = 'show' or [];
% 'show' = show instructions at the beginning. Default with "perception"
% and "introduction" sessions.

%....Define "PTB" structure
ptb.debug        = ''; % 'screen' or 'key' or []; To-do: key debug mode.
ptb.instructions = []; % 'show' or [];  if [] --> no instructions.
ptb.fontColor    = [255 0 0]; % FontColors in RGB; red letters.
%-------------------------------------------------------------------------%

%% DESIGN-STRUCTURE: Modify your experimental design
%-------------------------------------------------------------------------%
% The "design" structure allows controlling your experimental design, 
% This CAN and SHOULD be extended.
%
% --> design.nTrials = NUMBER_OF_TRIALS;
% To-Do: make it variable; Its hard coded for now. 
% Perception test: ALWAYS 10! 
%
% --> design.showNtrials = HOW_MANY_TRIALS_TO_SHOW
% Experimental Session: depends on the do.HowManyTrials input
% Perception test: design.nTrials = 10; design.showNtrials = design.nTrials;
% Introduction session: design.showNtrials = 5.
%
% --> design.retentionTimes = HOW_MUCH_TIME_BETWEEN_SAMPLE_AND_TEST
% This is an array with the number of trials (not necessarily shown!)
% Please make sure you adapt this according to your needs.
%
% --> design.FixationDuration = TIME_BETWEEN_TRIALS
% This is the time between trials that shows the fixation cross. Here
% subjects will respond.
%
% --> design.SampleDuration = DURATION_OF_SAMPLE_IMAGE
% Duration of the sample images. Make shorter to make task more difficult.
%
% --> design.TestDuration = DURATION_OF_TEST_IMAGE
% Duration the test images are shown. Make shorter to make task more
% difficult.

%....Define "DESIGN" structure
design.nTrials   = 32; 

if     strcmp(do.HowManyTrials,'all'); design.showNtrials  = design.nTrials;
elseif strcmp(do.HowManyTrials,'half'); design.showNtrials = design.nTrials/2;
elseif isnumeric(do.HowManyTrials); design.showNtrials     = do.HowManyTrials;
else   error('do.HowManyTrials wrongly defined. We will stop now');
end

design.retentionTimes    = repmat(2,1,design.nTrials); % allows for different retention times if wanted.
design.FixationDuration  = 2;                          % fixation duration (between trials) - to-do: use to get subject responses to.
design.SampleDuration    = 1;                          % sample images duration
design.TestDuration      = 2;                          % To-do: implement this duration and dont wait for answer.
%-------------------------------------------------------------------------%
end
