function [stim] = Stimuli_Order_WM(stim,dirs,design)
% Creates the matrices for stimulus presentation
% Input: stim, dirs, design
% Output: stim (with matrices)
% Mod: PRG 11/2019
%
% Original matrices copied from E-prime
% To-Do: random generation of matrices.

Orden_Matlab = 2:19;

%%

%%%%%%%%%% INICIO ESTIMULOS PERCEPCION %%%%%%%%%%

%%% Define Stimuli aparition and order (not randomized for perception)
if isequal(design.AmountOfStimuli, '2')
    stim.Perception_Stimuli = {000 000 000 58 000 000 36 000 000 000 000 000 36 000 000 000 58 000
        000 12 000 000 000 000 000 65 000 000 62 000 000 000 15 000 000 000
        000 000 000 000 78 000 12 000 000 000 000 000 18 000 000 000 000 72
        000 000 21 000 000 000 000 000 18 000 21 000 000 000 18 000 000 000
        000 000 53 31 000 000 000 000 000 31 000 000 000 000 53 000 000 000
        000 000 000 000 000 51 84 000 000 000 000 000 81 000 000 000 000 54
        000 000 81 000 000 000 45 000 000 000 000 85 000 000 41 000 000 000
        000 46 000 000 000 000 000 000 28 000 000 000 000 48 000 000 000 26
        000 17 000 31 000 000 000 000 000 000 000 000 31 000 17 000 000 000
        000 000 000 77 000 000 000 000 88 000 000 000 88 000 77 000 000 000}';
elseif isequal(design.AmountOfStimuli, '3')
    stim.Perception_Stimuli = {000	77	000	22	000	000	000	000	55	000	55	000	000	000	22	77	000	000
        000	000	000	000	42	000	31	28	000	42	000	000	28	000	000	31	000	000
        000	000	31	000	17	000	000	28	000	000	28	000	000	000	000	17	000	31
        000	000	000	000	13	75	000	000	26	000	26	000	000	000	000	15	000	73
        81	000	000	000	000	45	34	000	000	45	000	84	31	000	000	000	000	000
        000	000	51	48	000	000	000	000	73	71	000	53	000	000	000	48	000	000
        000	000	000	54	000	000	32	65	000	32	000	000	000	000	000	65	000	54
        000	000	000	43	25	000	000	34	000	000	000	23	000	000	000	000	45	34
        000	000	000	73	000	000	45	18	000	48	000	000	000	15	000	000	73	000
        000	000	000	61	47	14	000	000	000	000	47	000	14	000	000	000	61	000}';
else isequal(design.AmountOfStimuli, '4')
    stim.Perception_Stimuli = {000	77	000	22	000	000	000	000	55	000	55	000	000	000	22	77	000	000
        000	000	000	000	42	000	31	28	000	42	000	000	28	000	000	31	000	000
        000	000	31	000	17	000	000	28	000	000	28	000	000	000	000	17	000	31
        000	000	000	000	13	75	000	000	26	000	26	000	000	000	000	15	000	73
        81	000	000	000	000	45	34	000	000	45	000	84	31	000	000	000	000	000
        000	000	51	48	000	000	000	000	73	71	000	53	000	000	000	48	000	000
        000	000	000	54	000	000	32	65	000	32	000	000	000	000	000	65	000	54
        000	000	000	43	25	000	000	34	000	000	000	23	000	000	000	000	45	34
        000	000	000	73	000	000	45	18	000	48	000	000	000	15	000	000	73	000
        000	000	000	61	47	14	000	000	000	000	47	000	14	000	000	000	61	000}';
end

    % Re-organize the positions (widths & height)
    Stimuli_Perception_Database_Dummy = stim.Stimuli_Perception_Database; % Dummy of Stimulis
    for rearange = 2:size(stim.Stimuli_Perception_Database,1)
        Stimuli_Perception_Database_Dummy(rearange,1:2) = stim.Stimuli_Perception_Database(Orden_Matlab(rearange-1), 1:2); % Reorder in Dummy
    end
    stim.Stimuli_Perception_Database = Stimuli_Perception_Database_Dummy; % Copy the Dummy

    Counter = 1; % Counter for image deletion

    %%% Delete stimuli which arent Fixation cross TrialPerc (explanation of
    %%% perception), TrialTask (explanation of task) or 'img' in name (All usable stimuli names start with img)
    for SpecificStimuli = 1:size(dirs.PerceptionStimuliDir,1) % Iter through all elements in folder

        % Check for the three specific Stimuli
        if regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'TrialPerc', 'ONCE') % Perception Explanation
            stim.Perception_Trial_Explanation = dirs.PerceptionStimuliDir(SpecificStimuli,1).name;
        elseif regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'TrialTask', 'ONCE') % stim.org.Trial Explanation
            stim.ShapeColor_Trial_Explanation = dirs.PerceptionStimuliDir(SpecificStimuli,1).name;
        elseif regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'FixCross', 'ONCE') % Fixation cross
            stim.FixationCross                = dirs.PerceptionStimuliDir(SpecificStimuli,1).name;
        end

        % Create deletion variable for every non 'img' stimuli
        if isempty(regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'img', 'ONCE'))
            Dir_Del_List(Counter,1) = SpecificStimuli; %#ok<AGROW,*SAGROW>
            Counter                 = Counter + 1;
        end
    end

    %%% Delete from directory unusefull elements (not 'img' ones)
    for Delete_Non_Images = 1:length(Dir_Del_List)
        Images       = 1:length(Dir_Del_List); %#ok<NASGU>
        dirs.PerceptionStimuliDir(Dir_Del_List(Delete_Non_Images),:) = [];
        Dir_Del_List = Dir_Del_List - 1;
    end
    clear Dir_Del_List SpecificStimuli Delete_Non_Images
    
if strcmp(design.session,'Perception')
    dirs.DummyStimuliDir     = {dirs.PerceptionStimuliDir(:,1).name}'; % Creation of a Dummy Stimuli Directory to Modify
    Perception_Stimuli_Dummy = stim.Perception_Stimuli; % Creation of a Dummy Task_ShapeColor_Stimuli to Modify

    %%% Stimuli Name Assignment in Task_ShapeColor_Stimuli_Dummy base
    for ReplaceStimuli = 1:size(dirs.DummyStimuliDir,1)

        % Variable definition
        Counter    = 1; % Letter Deletion Counter
        Num        = regexp(dirs.PerceptionStimuliDir(ReplaceStimuli,1).name,'\d'); % Position of numbers in Image name
        Length_Num = length(Num); % Amount of numbers on image (only take into account 2 number images)

        %%% Iteration per Leter of image
        for Del_Letters = 1:size(dirs.DummyStimuliDir{ReplaceStimuli,1},2)
            if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter) % If Counter get to the positions in NUM skip the deletion
                Counter  = Counter + 1;
            else % If you are not in positions of NUM, Delete in the dummy
                dirs.DummyStimuliDir{ReplaceStimuli,1}(Counter) = [];
            end
        end

        % Search index where the directory image number corresponds to the numbers defined in the Task_ShapeColor_Stimuli_Dummy
        ReplaceList = find([Perception_Stimuli_Dummy{:}] == str2double(dirs.DummyStimuliDir{ReplaceStimuli,1}));

        %%% Replace in the original Task_ShapeColor_Stimuli the images
        for ReplaceIter = 1:length(ReplaceList)
            stim.Perception_Stimuli{ReplaceList(ReplaceIter)} = dirs.PerceptionStimuliDir(ReplaceStimuli,1).name;
        end
    end
    clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir

    %%%%%%%%%% FIN ESTIMULOS PERCEPCION   %%%%%%%%%%
else
    %%
    %%%%%%%%%% INICIO ESTIMULOS SHAPEONLY %%%%%%%%%%
    % Variables for stimuli selection and position
    stim.Task_ShapeOnly_Stimuli  = {}; % Cell array for stimuli
    stim.ShapeOnly_Names         = (11:10:81); % Possible Stimuli Numbers
    Congruent                    = 0; % Congruent stimuli trials created counter
    stim.org.NonCongruent        = 0; % Non congruent stimuli trials created counter
    DifferentTrials              = struct;
    BaseColumni                  = 0;
    FourTrainings                = {'TrainingOne','TrainingTwo','TrainingThree','TrainingFour'};
    EightTrials                  = {'FirstTrial', 'SecondTrial', 'ThirdTrial', 'FourthTrial', 'FifthTrial',...
        'SixthTrial', 'SeventhTrial', 'EighthTrial'};

    %%% Create the stimuli order database being number of stimuli dependant
    % if strcmp(design.Version,'fMRI')
    %     for AmountOfTrials = 1:design.nShapeOnlyTrials/8 % Iter ntrials times (1/8 of the total amount will represent the original Trials)
    %         
    %         ShapeOnlyDeletion      = stim.ShapeOnly_Names;
    %         DeletionCounter        = 0;
    %         stim.org.Trial         = zeros(18,1); % Pre-Allocate for speed
    %         stim.org.TrialStimuli  = 0; % Reset each stim.org.Trial
    %         
    %         % Define congruent stimulis if NonCongruents have already been defined (define *StimuliAmount* stimuli and copy paste)
    %         for Amount_of_Stimuli = 1:str2double(design.AmountOfStimuli)+1 % Add Stimuli according to AmountOfStimuli
    %             if stim.org.TrialStimuli == 0
    %                 DeletionCounter                     = DeletionCounter + 1;
    %                 stim.org.TrialStimuli               = ShapeOnlyDeletion(randperm(numel(ShapeOnlyDeletion), 1));
    %                 ShapeOnlyDeletion(ShapeOnlyDeletion == stim.org.TrialStimuli) = []; % Delete Stimuli for it not to be repeated
    %                 
    %             elseif str2double(design.AmountOfStimuli) ~= DeletionCounter
    %                 DeletionCounter                     = DeletionCounter + 1;
    %                 DeletionDummy                       = ShapeOnlyDeletion(randperm(numel(ShapeOnlyDeletion), 1));
    %                 stim.org.TrialStimuli               = [stim.org.TrialStimuli, DeletionDummy]; %#ok<*SAGROW>
    %                 ShapeOnlyDeletion(ShapeOnlyDeletion == DeletionDummy) = []; % Delete Stimuli for it not to be repeated
    %                 
    %             else % First two defined, define last two stimuli
    %                 for Repeted_Trials_Amount = 1:(design.nShapeOnlyTrials/4)
    %                     DeletionDummy    = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names), 1));
    %                     DeletionDummy2   = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names), 1));
    %                     RandomDummy      = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names), 1));
    %                     RandomDummy2     = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names), 1));
    %                     % Dont let both last numbers be the same
    %                     while DeletionDummy2 == DeletionDummy
    %                         DeletionDummy    = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names), 1));
    %                     end
    %                     % Dont let it be congruent by randomization
    %                     while length(unique([stim.org.TrialStimuli, DeletionDummy, DeletionDummy2])) <= str2double(design.AmountOfStimuli)
    %                         DeletionDummy2   = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names), 1));
    %                     end
    %                     % Structure with new trials per training
    %                     if ~isfield(DifferentTrials,(FourTrainings{AmountOfTrials})) % Create it if it doesnt exist
    %                         DifferentTrials.(FourTrainings{AmountOfTrials}) = struct;
    %                     end
    %                     % Do half of them congruent and other half stim.org.NonCongruent
    %                     if numel(fieldnames(DifferentTrials.(FourTrainings{AmountOfTrials}))) >= design.nShapeOnlyTrials/8
    %                         DifferentTrials.(FourTrainings{AmountOfTrials}).(EightTrials{Repeted_Trials_Amount}) = [stim.org.TrialStimuli, stim.org.TrialStimuli];
    %                     else
    %                         if isequal(design.AmountOfStimuli,'2')
    %                             DifferentTrials.(FourTrainings{AmountOfTrials}).(EightTrials{Repeted_Trials_Amount}) = [stim.org.TrialStimuli, DeletionDummy, DeletionDummy2];
    %                         elseif isequal(design.AmountOfStimuli,'3')
    %                             DifferentTrials.(FourTrainings{AmountOfTrials}).(EightTrials{Repeted_Trials_Amount}) = [stim.org.TrialStimuli, DeletionDummy, DeletionDummy2, RandomDummy];
    %                         else
    %                             DifferentTrials.(FourTrainings{AmountOfTrials}).(EightTrials{Repeted_Trials_Amount}) = [stim.org.TrialStimuli, DeletionDummy, DeletionDummy2,RandomDummy, RandomDummy2];
    %                         end
    %                     end
    %                 end
    %                 % Define the stim.org.Trial
    %                 stim.org.TrialStimuli = [stim.org.TrialStimuli, DeletionDummy, DeletionDummy2]; %#ok<*SAGROW>
    %             end
    %         end
    %         
    %         %%% Copy stim.org.Trial into Task_ShapeOnly_Stimuli Cell field
    %         for TrialToBase = 1:numel(fieldnames(DifferentTrials.(FourTrainings{AmountOfTrials})))
    %             % Position Randomization (as there are 18 possible possition
    %             % add 9 to the second half of screen picks)
    %             stim.org.TrialStimuliPosition = [randperm(length(stim.org.Trial)/2,str2double(design.AmountOfStimuli)),randperm(length(stim.org.Trial)/2,str2double(design.AmountOfStimuli))+9];
    %             % Copy Stimuli to stim.org.Trial
    %             for StimuliToPosition = 1:numel(DifferentTrials.(FourTrainings{AmountOfTrials}).(EightTrials{TrialToBase}))
    %                 stim.org.Trial(stim.org.TrialStimuliPosition(StimuliToPosition)) = DifferentTrials.(FourTrainings{AmountOfTrials}).(EightTrials{TrialToBase})(StimuliToPosition);
    %             end
    %             % Copy in database
    %             for TaskTrialCreation = 1:length(stim.org.Trial)
    %                 stim.Task_ShapeOnly_Stimuli{TaskTrialCreation,TrialToBase + BaseColumni} = stim.org.Trial(TaskTrialCreation,1);
    %             end
    %             % Redefine stim.org.Trial
    %             stim.org.Trial = zeros(18,1);
    %         end
    %         % Add Column for next Trials positioning in data base
    %         BaseColumni = BaseColumni + numel(fieldnames(DifferentTrials.(FourTrainings{AmountOfTrials})));
    %     end
    %     
    % else % If its not for MVP analysis
    for AmountOfTrials = 1:design.nShapeOnlyTrials % Iter ntrials times

        stim.org.Trial        = zeros(18,1); % Pre-Allocate for speed
        stim.org.TrialStimuli = 0;

        % Define congruent stimulis if NonCongruents have already been defined (define *StimuliAmount* stimuli and copy paste)
        if stim.org.NonCongruent == design.nShapeOnlyTrials/2
            for Amount_of_Stimuli = 1: str2double(design.AmountOfStimuli) % Add Stimuli according to AmountOfStimuli
                if stim.org.TrialStimuli == 0
                    stim.org.TrialStimuli  = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names)));
                else
                    stim.org.TrialStimuli  = [stim.org.TrialStimuli, stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names)))]; %#ok<*SAGROW>
                end
            end
            % Copy stim.org.Trial for it to be Congruent
            stim.org.TrialStimuli         = [stim.org.TrialStimuli,stim.org.TrialStimuli]; %#ok<*SAGROW>
        else % If half the trials havent been defined as stim.org.NonCongruent, random pick *StimuliAmount*2* stimuli from the stimuli pool
            for Amount_of_Stimuli = 1: str2double(design.AmountOfStimuli)*2 % Add Stimuli according to AmountOfStimuli
                if stim.org.TrialStimuli == 0
                    stim.org.TrialStimuli = stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names)));
                else
                    stim.org.TrialStimuli = [stim.org.TrialStimuli, stim.ShapeOnly_Names(randperm(numel(stim.ShapeOnly_Names)))]; %#ok<*SAGROW>
                end
            end
        end
        % Random Pick two top and two bottom positions for the stimuli
        stim.org.TrialStimuliPosition = [randperm(length(stim.org.Trial)/2,str2double(design.AmountOfStimuli)),randperm(length(stim.org.Trial)/2, str2double(design.AmountOfStimuli))+9];
        % Check if random Stimuli picked are Congruent or stim.org.NonCongruent
        if length(unique(stim.org.TrialStimuli)) ~= str2double(design.AmountOfStimuli)
            stim.org.NonCongruent = stim.org.NonCongruent +1;
        else
            Congruent    = Congruent +1;
        end
        %%% Position stimuli into stim.org.Trial variable with 0s where there is no
        %%% stimuli
        for StimuliToPosition = 1:length(stim.org.TrialStimuliPosition)
            stim.org.Trial(stim.org.TrialStimuliPosition(StimuliToPosition)) = stim.org.TrialStimuli(StimuliToPosition);
        end
        %%% Copy stim.org.Trial into Task_ShapeOnly_Stimuli Cell field
        for TaskTrialCreation = 1:length(stim.org.Trial)
            stim.Task_ShapeOnly_Stimuli{TaskTrialCreation,AmountOfTrials} = stim.org.Trial(TaskTrialCreation,1);
        end
    end
    %end
    clear Congruent stim.org.NonCongruent

    Counter = 1; % Counter for image deletion

    %%% Delete stimuli which arent Fixation cross,
    %%% TrialTask (explanation of task) or 'img' in name (All usable stimuli names start with img)
    for SpecificStimuli = 1:size(dirs.TaskShapeOnlyStimuliDir,1)

        % Check for the specific Stimuli
        if regexp(dirs.TaskShapeOnlyStimuliDir(SpecificStimuli,1).name, 'TrialTask', 'ONCE')
            dirs.Task_Trial_Explanation = dirs.TaskShapeOnlyStimuliDir(SpecificStimuli,1).name;
        end
        % Create deletion variable for every non 'img' stimuli
        if isempty(regexp(dirs.TaskShapeOnlyStimuliDir(SpecificStimuli,1).name, 'img', 'ONCE'))
            Dir_Del_List(Counter,1) = SpecificStimuli;
            Counter                 = Counter + 1;
        end

    end

    %%% Delete from directory unusefull elements (not 'img' ones)
    for Delete_Non_Images = 1:length(Dir_Del_List)

        dirs.TaskShapeOnlyStimuliDir(Dir_Del_List(Delete_Non_Images),:) = [];
        Dir_Del_List = Dir_Del_List - 1;

    end
    clear Dir_Del_List SpecificStimuli Delete_Non_Images

    DummyStimuliDir              = {dirs.TaskShapeOnlyStimuliDir(:,1).name}'; % Creation of a Dummy Stimuli Directory to Modify
    Task_ShapeOnly_Stimuli_Dummy = stim.Task_ShapeOnly_Stimuli; % Creation of a Dummy Task_ShapeOnly_Stimuli to Modify

    %%% Stimuli Name Assignment in Task_ShapeOnly_Stimuli_Dummy base
    for ReplaceStimuli = 1:size(DummyStimuliDir,1)

        % Variable definition
        Counter    = 1; % Letter Deletion Counter
        Num        = regexp(dirs.TaskShapeOnlyStimuliDir(ReplaceStimuli,1).name,'\d'); % Position of numbers in Image name
        Length_Num = length(Num); % Amount of numbers on image (only take into account 2 number images)

        %%% Iteration per Leter of image
        for Del_Letters = 1:size(DummyStimuliDir{ReplaceStimuli,1},2)
            if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter)% If Counter get to the positions in NUM skip the deletion
                Counter  = Counter + 1;
            else % If you are not in positions of NUM, Delete in the dummy
                DummyStimuliDir{ReplaceStimuli,1}(Counter) = [];
            end
        end

        % Search index where the directory image number corresponds to the numbers defined in the Task_ShapeOnly_Stimuli_Dummy
        ReplaceList = find([Task_ShapeOnly_Stimuli_Dummy{:}] == str2double(DummyStimuliDir{ReplaceStimuli,1}));

        %%% Replace in the original Task_ShapeOnly_Stimuli_Dummy the images
        for ReplaceIter = 1:length(ReplaceList)
            stim.Task_ShapeOnly_Stimuli{ReplaceList(ReplaceIter)} = dirs.TaskShapeOnlyStimuliDir(ReplaceStimuli,1).name;
        end

    end
    clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir
    %%%%%%%%%% FIN ESTIMULOS SHAPEONLY     %%%%%%%%%%

    %%

    %%%%%%%%%% INICIO ESTIMULOS SHAPECOLOR %%%%%%%%%%

    %%% Variables for stimuli selection and position
    stim.Task_ShapeColor_Stimuli = {}; % Cell array for stimuli
    stim.ShapeColor_Names        = [11:18, 21:28, 31:38, 41:48, 51:58, 61:68, 71:78, 81:88]; % Possible Stimuli Numbers
    stim.ShapeColor_NamesMod     = stim.ShapeColor_Names;
    CongruentTrials              = 1;
    CongruentFmriTrial           = 1;
    stim.org.AllTrialStimuli     = 0;
    IdenticalCol                 = 0;
    %%% Pick two random numbers between 1:9 and 10:18 which will represent
    %%% positions for each stim.org.Trial iteration
    if strcmp(design.AmountOfStimuli,'2');     AmountOfPositions = 2;
    elseif strcmp(design.AmountOfStimuli,'3'); AmountOfPositions = 3;
    elseif strcmp(design.AmountOfStimuli,'4'); AmountOfPositions = 4;
    end



    %%% Create the stimuli order database being number of stimuli dependant
    for AmountOfTrials = 1:design.nShapeColorTrials % Iter ntrials times
        % Will keep itering until contrains are satisfied
        disp(stim.org.AllTrialStimuli)
        TrialIsNew            = 0;
        if CongruentFmriTrial == 9; CongruentFmriTrial = 1; stim.ShapeColor_NamesMod = stim.ShapeColor_Names; end % Reset CongruentFmriTrial for new trial 

        % Empty NumberList
    %     if strcmp(design.Version,'fMRI')
    %         if     CongruentFmriTrial > 5;   NewNumberList      = OriginalNumberList(1:str2double(design.AmountOfStimuli)-1);
    %         elseif CongruentFmriTrial == 2;  OriginalNumberList = NewNumberList; NewNumberList = [];
    %         else   NewNumberList      = [];
    %         end
    %     else
            NewNumberList = [];
        %end

        %% Start new trial iteration
        while TrialIsNew == 0
            stim.org.TrialStimuli = [];
            IncongruentTrials = 0;
            CopyTrial         = 0;

            % If we are re-rolling trial on an MVPA task, we rest the congruent trial counted before
            if IdenticalCol == 1 
              CongruentFmriTrial    = CongruentFmriTrial - 1;
              NewNumberList         = [];
            end
            % Define variables to use (numbers constrain dependant)
            stim.org.Trial           = zeros(18,1); % Pre-Allocate for speed
            stim.org.TrialStimuli    = stim.ShapeColor_Names(randperm(numel(stim.ShapeColor_Names),1)); % Pick a random number from our stimuli pool

            % Dependant of stimuli type length
            NegDec                   = [-1 -7];
            PosDec                   = [1 7];
            Eleven                   = [-1, 1];

            % Define our Trial Stimuli (repeat randompick number design.AmountOfStimuli times*2)
            stim.org.TrialStimuli    = repmat(stim.org.TrialStimuli,1,str2double(design.AmountOfStimuli)*2);
            stim.org.TrialStimuli    = stim.org.TrialStimuli';

            % Get first and last number which will define how to modify the number
            stim.org.FirstNumber     = num2str(stim.org.TrialStimuli); stim.org.FirstNumber = str2double(stim.org.FirstNumber(1)); % Check starting number (ej: 72, CheckFirstNumber = 7)
            stim.org.LastNumber      = mod(stim.org.TrialStimuli,10); % Checking last number in case its 8 or 1

    %       % In case you want to mod every number
    % %         % If it ends with 8, modification will be -1 or -7, if it ends with 1
    % %         % it will be + 1 or + 7
    % %         if stim.org.LastNumber == 8; NumMod =  NegDec(randperm(2,1));
    % %         elseif stim.org.LastNumber == 1; NumMod =  NegDec(randperm(2,1))*-1;
    % %         else NumMod =  Eleven(randperm(2,1));
    % %         end

            % Make first number of test congruent
    %         if ~strcmp(design.Version,'fMRI')
    %             if CongruentTrials <= str2double(design.AmountOfStimuli)/2
    %             else stim.org.TrialStimuli(str2double(design.AmountOfStimuli)+1) = stim.org.TrialStimuli(1); % + NumMod; (In case mod every number)
    %             end
    %         end
    %         
    %         % Define how many times it iters depending if its a congruent or incongruent trial
    %         if ~strcmp(design.Version,'fMRI'); TimesTrialIters = str2double(design.AmountOfStimuli)*2-2;
    %         else                               
                TimesTrialIters = str2double(design.AmountOfStimuli)*2;
    %         end


            %% Iterate (n*2) times (Required amount to do 2 congruent and 2 incongruent for incongruent trials) to check if modified number is ok
            for TrialIter = 2:TimesTrialIters

                % For incongruent trials skip if not in the test modifications (only run first to copy the last trial)
                if CongruentFmriTrial > 4 && TrialIter > 2 && TrialIter < str2double(design.AmountOfStimuli) + 1
                    continue
                end


                %% If doing MPVA with fmri, no need to iter that much
    %             if strcmp(design.Version,'fMRI')
    %                 if TrialIter > str2double(design.AmountOfStimuli) && CongruentFmriTrial < str2double(design.AmountOfStimuli)+1
    %                     break
    % %                 % If we are on the iter needed to mod the incongruent stimuli copy the last trial
    %                 elseif CongruentFmriTrial > 4 && CopyTrial == 0
    %                     stim.org.TrialStimuli    = stim.org.AllTrialStimuli(1:length(stim.org.TrialStimuli),AmountOfTrials-1);
    %                     CopyTrial = 1;
    %                     [stim] = EraseTrialNumber(stim.org.TrialStimuli,stim);
    %                     continue
    %                 end
    %             end

                %% Local iter variables definition
                IncongruentTrials = IncongruentTrials + 1; % Make first two stimuli from incongruent trials congruent
                CheckingMod       = 1;                     % Check Modification for each stimuli
                NotEdge           = 0;                     % Check if its a starting edge or not (1x,8x)

                %% Redefine First and Last number for the iteration
                if TrialIter > str2double(design.AmountOfStimuli)
                    stim.org.FirstNumber     = num2str(stim.org.TrialStimuli(TrialIter-2)); stim.org.FirstNumber = str2double(stim.org.FirstNumber(1)); % Check starting number (ej: 72, CheckFirstNumber = 7)
                    stim.org.LastNumber      = mod(stim.org.TrialStimuli(TrialIter-2),10); % Checking last number in case its 8 or 1
                else %% for MVPA we define first and last above
                    stim.org.FirstNumber     = num2str(stim.org.TrialStimuli(TrialIter-1)); stim.org.FirstNumber = str2double(stim.org.FirstNumber(1)); % Check starting number (ej: 72, CheckFirstNumber = 7)
                    stim.org.LastNumber      = mod(stim.org.TrialStimuli(TrialIter-1),10); % Checking last number in case its 8 or 1
                end

                %% While its still not acceptable keep itering
                while CheckingMod == 1            
                    %% Mod depending on first number
                    if     stim.org.FirstNumber == 8;                    NewFirstNumb = NegDec(randperm(2,1)); % If it starts with 8
                    elseif stim.org.FirstNumber == 1;                    NewFirstNumb = PosDec(randperm(2,1)); % If it starts with 1
                    else   NewFirstNumb         = Eleven(randperm(2,1)); NotEdge      = 1;                     % Its not an edge
                    end

                    %% Define what to do in case number is an edge LastNumbers
                    % If its (x8 / x > 1 & x < 8)
                    if  stim.org.LastNumber == 8 && NotEdge == 1
                        NewFirstNumb               = str2double([num2str(NewFirstNumb),'0']);
                        NewNumberGenerator         = NewFirstNumb + NegDec(randperm(2,1));
                        NewNumberList(TrialIter-1) = NewNumberGenerator;
                        % If its (x1/ x > 1 & x < 8)
                    elseif stim.org.LastNumber == 1 && NotEdge == 1
                        NewFirstNumb               = str2double([num2str(NewFirstNumb),'0']);
                        NewNumberGenerator         = (NewFirstNumb + NegDec(randperm(2,1)))*-1;
                        NewNumberList(TrialIter-1) = NewNumberGenerator; 
                        % If its 18 or 88
                    elseif stim.org.LastNumber == 8 && NotEdge == 0
                        NewFirstNumb               = str2double([num2str(NewFirstNumb),'0']);
                        NewLastNumb                = NegDec(randperm(2,1));
                        NewNumberGenerator         = (NewFirstNumb + NewLastNumb);
                        NewNumberList(TrialIter-1) = NewNumberGenerator; 
                        % If its 11 or 81
                    elseif stim.org.LastNumber == 1 && NotEdge == 0
                        NewFirstNumb               = str2double([num2str(NewFirstNumb),'0']);
                        NewLastNumb                = PosDec(randperm(2,1));
                        NewNumberGenerator         = (NewFirstNumb + NewLastNumb);
                        NewNumberList(TrialIter-1) = NewNumberGenerator;
                        % If its any other number
                    else NewLastNumb = 1;
                    end

                    %% Create list of mods to not mirror modifications 
                    if exist('NewNumberGenerator', 'var') == 0
                        NewNumberGenerator         = [num2str(NewFirstNumb),num2str(NewLastNumb)];
                        NewNumberGenerator         = str2double(NewNumberGenerator);
                        NewNumberList(TrialIter-1) = NewNumberGenerator; 
                    else
                        NewNumberList(TrialIter-1) = NewNumberGenerator; 
                    end

                    disp(NewNumberGenerator)

                    %% Check for mirror mods or errors
                    if length(NewNumberList) > 1
                        FirstNewNumb = stim.org.TrialStimuli(TrialIter-1) + NewNumberGenerator; %#ok<NASGU>
                        FirstNewNumb = num2str(stim.org.TrialStimuli(TrialIter-1) + NewNumberGenerator); FirstNewNumb = str2double(stim.org.FirstNumber(1)); %#ok<NASGU> % Check starting number (ej: 72, CheckFirstNumber = 7)

                        % Dont do mirror numbers to avoid same img
                        if NewNumberList(TrialIter-2) == NewNumberGenerator*-1;
                            clear NewNumberGenerator;
                            continue
                        % If difference between subsequent numbers is less than 10 you only changed color not shape.
                        elseif FirstNewNumb == stim.org.FirstNumber
                            clear NewNumberGenerator;
                            continue
                        else CheckingMod = 0;
                        end
                    else CheckingMod = 0;
                    end
                end % Leave 'while' for study modification


                %% Define Study Stimuli
                %if ~strcmp(design.Version,'fMRI') 
                    if TrialIter == str2double(design.AmountOfStimuli) + 1
                        stim.org.TrialStimuli(TrialIter + 2) = stim.org.TrialStimuli(TrialIter - 2) + NewNumberGenerator;
                    elseif TrialIter > str2double(design.AmountOfStimuli) + 1
                        stim.org.TrialStimuli(TrialIter + 2) = stim.org.TrialStimuli(TrialIter + 1) + NewNumberGenerator;
                    else
                        stim.org.TrialStimuli(TrialIter)     = stim.org.TrialStimuli(TrialIter - 1) + NewNumberGenerator;
                    end

    %             % MVPA study Stimuli     
    %             elseif strcmp(design.Version,'fMRI')
    %                 % Modify subsequent number on study
    %                 stim.org.TrialStimuli(TrialIter)     = stim.ShapeColor_NamesMod(randi(numel(stim.ShapeColor_NamesMod)));
    %                 
    %                 % Check if number already exist in trial, if it does dont use it
    %                 if sum(ismember(stim.ShapeColor_NamesMod,stim.org.TrialStimuli(TrialIter))) > 1
    %                 stim.ShapeColor_NamesMod(stim.ShapeColor_NamesMod == stim.org.TrialStimuli(TrialIter)) = [];
    %                 end
    %                 
    %                 % Check last and first number of modification for control purpouses
    %                 stim.org.FirstNumber     = num2str(stim.org.TrialStimuli(TrialIter)); stim.org.FirstNumber = str2double(stim.org.FirstNumber(1)); % Check starting number (ej: 72, CheckFirstNumber = 7)
    %                 stim.org.LastNumber      = mod(stim.org.TrialStimuli(TrialIter),10); % Checking last number in case its 8 or 1
    %                 
    %                 % Modification depending on last number
    % %                 if stim.org.LastNumber == 8;     NumMod =  NegDec(randperm(2,1));
    % %                 elseif stim.org.LastNumber == 1; NumMod =  NegDec(randperm(2,1))*-1;
    % %                 else                             NumMod =  Eleven(randperm(2,1)); 
    % %                 end
    %             end

                %% Define the test Stimuli
                %if ~strcmp(design.Version,'fMRI')
                    if TrialIter <= str2double(design.AmountOfStimuli)
                        if CongruentTrials <= str2double(design.AmountOfStimuli)/2
                            stim.org.TrialStimuli(TrialIter + str2double(design.AmountOfStimuli)) = stim.org.TrialStimuli(TrialIter);
                        elseif CongruentTrials > str2double(design.AmountOfStimuli)/2 && IncongruentTrials < 2
                            stim.org.TrialStimuli(TrialIter + str2double(design.AmountOfStimuli)) = stim.org.TrialStimuli(TrialIter);
                            % In case you want to mod every number
                            % else
                            % stim.org.TrialStimuli(TrialIter + str2double(design.AmountOfStimuli)) = stim.org.TrialStimuli(TrialIter) + NumMod;
                        end
                    end
                    clear NewNumberGenerator

                % MVPA test Stimuli definition
    %             elseif strcmp(design.Version,'fMRI')
    %                 if TrialIter <= str2double(design.AmountOfStimuli)
    %                     
    %                     % If first trial, make test equal to study (congruent)
    %                     if CongruentFmriTrial == 1     
    %                        stim.org.TrialStimuli(TrialIter + str2double(design.AmountOfStimuli)) = stim.org.TrialStimuli(TrialIter);
    %                        
    %                     % If 2nd to 4th trial, make whole trial equal to last trial   
    %                     elseif CongruentFmriTrial <= 4 
    %                        stim.org.TrialStimuli = stim.org.AllTrialStimuli(1:length(stim.org.TrialStimuli),AmountOfTrials-1);
    %                        CongruentFmriTrial    = CongruentFmriTrial + 1;
    %                        SkipThisCounter       = 0;
    %                        break
    % %                     elseif CongruentFmriTrial > 4 && CongruentFmriTrial <= 8 % If its incongruent and 2 stimulis done, mod rest
    % %                        stim.org.TrialStimuli(TrialIter + str2double(design.AmountOfStimuli)) = stim.org.TrialStimuli(TrialIter) + NumMod;                     
    %                     end
    %                 end
    %                 clear NewNumberGenerator
    %             end
            end
            clear IncongruentTrials


            %% fMRI MVPA
    %         if strcmp(design.Version,'fMRI')
    %             % Add one if its first for it to save then add per iter (Bigger than 5 cause at 4 it adds 1 to counter else it would double sum)
    %             if CongruentFmriTrial  == 1 || CongruentFmriTrial >= 5 && SkipThisCounter == 1 && CongruentFmriTrial <= 8
    %                 CongruentFmriTrial = CongruentFmriTrial + 1;
    %             end
    %             SkipThisCounter = 1;
    %         end


            %% Check repeated trials and uniqueness of stimuli
            IdenticalCol = 0;
                % First trial wont check for repeated trials
                if AmountOfTrials == 1
                    stim.org.AllTrialStimuli(1:length(stim.org.TrialStimuli),1) = stim.org.TrialStimuli;
                    % Check unique last numbers on both study and test stimuli
                    for AllTrialsColIter = 1:size(stim.org.AllTrialStimuli, 2)
                        % Check number and color uniqueness for encoding
                        CheckNum             = num2str(stim.org.TrialStimuli(1:length(stim.org.TrialStimuli)/2,1));
                        CheckLastNum         = length(unique(CheckNum(:,2)));             % Unique study stimuli
                        CheckFirstNumb       = length(unique(CheckNum(:,1)));
                        % Check number and color uniqueness for test 
                        CheckSecondNum       = num2str(stim.org.TrialStimuli(length(stim.org.TrialStimuli)/2+1:length(stim.org.TrialStimuli),1));
                        CheckSecondLastNum   = length(unique(CheckSecondNum(:,2))); % Unique test stimuli
                        CheckSecondFirstNum  = length(unique(CheckSecondNum(:,1)));
                        LengthNeeded         = str2double(design.AmountOfStimuli);

                        if  CheckLastNum  ~= LengthNeeded || CheckSecondLastNum ~= LengthNeeded || CheckFirstNumb ~= LengthNeeded || CheckSecondFirstNum ~= LengthNeeded; IdenticalCol = 1; disp('Repeated Color!')
                        else TrialIsNew   = 1; break; end
                    end
                % If more than one trial, check for repeated trials
                elseif AmountOfTrials > 1                       
                    % Iter through all trials to check if its equal to any old trial
                    for AllTrialsColIter = 1:size(stim.org.AllTrialStimuli, 2)
                        % Check number and color uniqueness for encoding
                        CheckNum            = num2str(stim.org.TrialStimuli(1:length(stim.org.TrialStimuli)/2,1));
                        CheckLastNum        = length(unique(CheckNum(:,2)));
                        CheckFirstNumb      = length(unique(CheckNum(:,1)));
                        % Check number and color uniqueness for test 
                        CheckSecondNum      = num2str(stim.org.TrialStimuli(length(stim.org.TrialStimuli)/2+1:length(stim.org.TrialStimuli),1));
                        CheckSecondLastNum  = length(unique(CheckSecondNum(:,2)));
                        CheckSecondFirstNum = length(unique(CheckSecondNum(:,1)));
                        LengthNeeded        = str2double(design.AmountOfStimuli);

                    % Check for repeated trials and for amount of uniques required
                    %if ~strcmp(design.Version,'fMRI')                    
    %                     if sum(ismember(stim.org.AllTrialStimuli(1:length(stim.org.TrialStimuli),AllTrialsColIter), stim.org.TrialStimuli(1:length(stim.org.TrialStimuli)))) < length(stim.org.TrialStimuli) && CheckLastNum == LengthNeeded && CheckSecondLastNum == LengthNeeded && CheckFirstNumb == LengthNeeded && CheckSecondFirstNum == LengthNeeded              
    %                         disp('Not equal keep checking!');
    %                     else IdenticalCol = 1; disp('Repeated Value or Color!'); break;
    %                     end   
                    % MVPA Uniqueness check    
                    % else    
                        % Check for congruent stimuli unique colors
                        if CongruentFmriTrial <= 4 
                            if CheckLastNum == LengthNeeded && CheckFirstNumb == LengthNeeded && CheckSecondLastNum == LengthNeeded && CheckSecondFirstNum == LengthNeeded
                                disp('Good stimuli :3')
                            else
                                IdenticalCol = 1; disp('Repeated colors :O'); break;
                            end
                        end
                        % Check for incongruent stimuli unique colorss
                        if CongruentFmriTrial > 4 && CongruentFmriTrial <= 8
                            if CheckSecondLastNum == LengthNeeded && CheckSecondFirstNum == LengthNeeded
                            disp(stim.org.TrialStimuli)
                            disp('Good stimuli :3')
                            else
                            IdenticalCol = 1; disp('Repeated colors :O'); break;
                            end 
                        end
                    %end
                    end
                    % If its identical stay inside while and reroll the trialStim for a unique trial
                    if     IdenticalCol == 0; disp('Unique Value!'); stim.org.AllTrialStimuli(:,AllTrialsColIter+1) = stim.org.TrialStimuli'; TrialIsNew = 1;
                    elseif IdenticalCol == 1; TrialIsNew = 0; end
                    clear CheckLastNum
                end
        end

        % Random position definition leave always 9
        stim.org.TrialStimuliPosition = [randperm(length(stim.org.Trial)/2,AmountOfPositions),randperm(length(stim.org.Trial)/2,AmountOfPositions)+9];

        % All Trials Structure without positioning
        stim.org.AllTrialStimuli(1:length(stim.org.TrialStimuli),AmountOfTrials) = stim.org.TrialStimuli;

        %%% Position stimuli into stim.org.Trial variable with 0s where there is no
        %%% stimuli
        for StimuliToPosition = 1:length(stim.org.TrialStimuliPosition)
            stim.org.Trial(stim.org.TrialStimuliPosition(StimuliToPosition)) = stim.org.TrialStimuli(StimuliToPosition);
        end

        %%% Copy stim.org.Trial into Task_ShapeOnly_Stimuli Cell field
        for TaskTrialCreation = 1:length(stim.org.Trial)
            stim.Task_ShapeColor_Stimuli{TaskTrialCreation,AmountOfTrials} = stim.org.Trial(TaskTrialCreation,1);
        end
        clear TaskTrialCreation
    end

    DummyStimuliDir               = {dirs.PerceptionStimuliDir(:,1).name}'; % Creation of a Dummy Stimuli Directory to Modify
    Task_ShapeColor_Stimuli_Dummy = stim.Task_ShapeColor_Stimuli; % Creation of a Dummy Task_ShapeColor_Stimuli to Modify

    %%% Stimuli Name Assignment in Task_ShapeColor_Stimuli_Dummy base
    for ReplaceStimuli = 1:size(DummyStimuliDir,1)

        % Variable definition
        Counter    = 1; % Letter Deletion Counter
        Num        = regexp(dirs.PerceptionStimuliDir(ReplaceStimuli,1).name,'\d'); % Position of numbers in Image name
        Length_Num = length(Num); % Amount of numbers on image (only take into account 2 number images)

        %%% Iteration per Leter of image
        for Del_Letters = 1:size(DummyStimuliDir{ReplaceStimuli,1},2)
            if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter) % If Counter get to the positions in NUM skip the deletion
                Counter  = Counter + 1;
            else % If you are not in positions of NUM, Delete in the dummy
                DummyStimuliDir{ReplaceStimuli,1}(Counter) = [];
            end
        end

        % Search index where the directory image number corresponds to the numbers defined in the Task_ShapeColor_Stimuli_Dummy
        ReplaceList = find([Task_ShapeColor_Stimuli_Dummy{:}] == str2double(DummyStimuliDir{ReplaceStimuli,1}));

        %%% Replace in the original Task_ShapeColor_Stimuli the images
        for ReplaceIter = 1:length(ReplaceList)
            stim.Task_ShapeColor_Stimuli{ReplaceList(ReplaceIter)} = dirs.PerceptionStimuliDir(ReplaceStimuli,1).name;
        end
    end
             clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir

    %%%%%%%%%% FIN ESTIMULOS SHAPECOLOR %%%%%%%%%%
end
end

function [stim] = EraseTrialNumber(x,stim)
for IterArray = 1:length(x)
    stim.ShapeColor_NamesMod(stim.ShapeColor_NamesMod == x(IterArray)) = [];
end
end


