function [stim] = Stimuli_Order_WM2(stim,dirs,design)
% Creates the matrices for stimulus presentation
% Input: stim, dirs, design
% Output: stim (with matrices)
% Mod: PRG 11/2019
%
% Original matrices copied from E-prime
% To-Do: random generation of matrices.

%%
%%%%%%%%%% DEFINE STIMULI MATRIXES FROM E-PRIME %%%%%%%%%%
%%% Define Stimuli aparition and order
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
    stim.ShapesOnly = {000 000 000 11 000 000 21 000 000 000 51 000 000 000 000 000 61 000
        000 000 000 000 71 000 61 000 000 000 000 21 000 000 000 000 000 81
        000 000 51 31 000 000 000 000 000 000 000 000 000 000 51 81 000 000
        000 000 71 000 000 000 41 000 000 000 41 000 000 000 000 000 000 21
        000 11 000 31 000 000 000 000 000 000 000 000 61 000 000 000 000 81
        000 000 000 31 000 000 000 51 000 000 61 000 000 000 11 000 000 000
        000 000 000 41 000 000 000 000 61 000 21 000 000 000 31 000 000 000
        71 000 000 000 000 51 000 000 000 000 000 000 81 000 000 000 000 51
        000 000 31 000 000 41 000 000 000 000 000 000 000 61 000 000 000 21
        000 000 000 11 000 31 000 000 000 000 000 000 81 000 41 000 000 000}';
    stim.ShapesColor = {000 000 000 58 000 000 36 000 000 000 000 000 36 000 000 000 58 000
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
    stim.Perception_Stimuli = {
        000	77	000	22	000	000	000	000	55	000	55	000	000	000	22	77	000	000
        000	000	000	000	42	000	31	28	000	42	000	000	28	000	000	31	000	000
        000	000	31	000	17	00	000	28	000	000	28	000	000	000	000	17	000	31
        000	000	000	000	13	75	000	000	26	000	26	000	000	000	000	15	000	73
        81	000	000	000	000	45	34	000	000	45	000	84	31	000	000	000	000	000
        000	000	51	48	000	000	000	000	73	71	000	53	000	000	000	48	000	000
        000	000	000	54	000	000	32	65	000	32	000	000	000	000	000	65	000	54
        000	000	000	43	25	000	000	34	000	000	000	23	000	000	000	000	45	34
        000	000	000	73	000	000	45	18	000	48	000	000	000	15	000	000	73	000
        000	000	000	61	47	14	000	000	000	000	47	000	14	000	000	000	61	000}';
    stim.ShapesOnly = {000	71	000	21	000	000	000	000	51 000	000	000	000	41	000	31	21	000
        000	000	31	000	11	00	000	21	000 000	000	000	000	11	71	000	000	21
        81	000	000	000	000	41	31	000	000 000	000	51	41	000	000	000	000	71
        000	000	000	51	000	000	31	61	000 000	000	000	41	21	000	000	31	000
        000	000	000	71	000	000	41	11	000 000	000	000	61	41	11	000	000	000
        000	51	000	000	000	21	71	000	000 41	000	000	21	000	000	31	000	000
        000	21	000	000	000	000	11	000	31 000	21	000	000	000	000	11	000	71
        41	000	81	31	000	000	000	000	000 71	000	51	000	000	000	41	000	000
        31	000	000	000	000	000	61	000	51 000	000	21	000	000	000	000	41	31
        41	000	000	000	11	000	000	71	000 000	41	000	11	000	000	000	61	000}';
    stim.ShapesColor = {000	77	000	22	000	000	000	000	55 000	55	000	000	000	22	77	000	000
        000	000	000	000	42	000	31	28	000 42	000	000	28	000	000	31	000	000
        000	000	31	000	17	00	000	28	000 000	28	000	000	000	000	17	000	31
        000	000	000	000	13	75	000	000	26 000	26	000	000	000	000	15	000	73
        81	000	000	000	000	45	34	000	000 45	000	84	31	000	000	000	000	000
        000	000	51	48	000	000	000	000	73 71	000	53	000	000	000	48	000	000
        000	000	000	54	000	000	32	65	000 32	000	000	000	000	000	65	000	54
        000	000	000	43	25	000	000	34	000 000	000	23	000	000	000	000	45	34
        000	000	000	73	000	000	45	18	000 48	000	000	000	15	000	000	73	000
        000	000	000	61	47	14	000	000	000 000	47	000	14	000	000	000	61	000}';
end

%% General mods
%%% Delete stimuli which arent Fixation cross TrialPerc (explanation of
%%% perception), TrialTask (explanation of task) or 'img' in name (All
%%% usable stimuli names start with img)
if strcmp(design.AmountOfStimuli,'2')
    stim.Perception_Trial_Explanation = 'TrialPerc.JPG';
    stim.ShapeColor_Trial_Explanation = 'TrialTask.JPG';
    stim.ShapeOnly_Trial_Explanation  = 'TrialTask.JPG';
else
    stim.Perception_Trial_Explanation = 'TrialPerc.bmp';
    stim.ShapeColor_Trial_Explanation = 'TrialTask.bmp';
    stim.ShapeOnly_Trial_Explanation  = 'TrialTask.bmp';
end


stim.FixationCross                = 'FixCross.JPG';

% Delete non images in folder
Counter = 1; % Counter for image deletion
for SpecificStimuli = 1:size(dirs.PerceptionStimuliDir,1) % Iter through all elements in folder  
    % Create deletion variable for every non 'img' stimuli
    if isempty(regexp(dirs.PerceptionStimuliDir(SpecificStimuli,1).name, 'img', 'ONCE'))
        Dir_Del_List(Counter,1) = SpecificStimuli; %#ok<AGROW,*SAGROW>
        Counter                 = Counter + 1;
    end
end

%%% Delete from directory unusefull elements (not 'img' ones)
for Delete_Non_Images = 1:length(Dir_Del_List)
    Images = 1:length(Dir_Del_List); %#ok<NASGU>
    dirs.PerceptionStimuliDir(Dir_Del_List(Delete_Non_Images),:)     = [];
    dirs.TaskShapeColorStimuliDir(Dir_Del_List(Delete_Non_Images),:) = [];
    Dir_Del_List = Dir_Del_List - 1;
end
clear Dir_Del_List SpecificStimuli Delete_Non_Images


%% Replace the matrix numbers for the stimuli image name for each task
if strcmp(design.session,'Perception')
    dirs.DummyStimuliDir     = {dirs.PerceptionStimuliDir(:,1).name}'; % Creation of a Dummy Stimuli Directory to Modify
    Perception_Stimuli_Dummy = stim.Perception_Stimuli; % Creation of a Dummy Task_ShapeColor_Stimuli to Modify
    
    %%% Stimuli Name Assignment in Task_ShapeColor_Stimuli_Dummy base
    for ReplaceStimuli = 1:size(dirs.DummyStimuliDir,1)
        
        % Variable definition
        Counter    = 1; % Letter Deletion Counter
        Num        = regexp(dirs.PerceptionStimuliDir(ReplaceStimuli,1).name,'\d'); % Position of numbers in Image name
        Length_Num = length(Num); % Amount of numbers on image (only take into account 2 number images)
        
        %%% Iteration per letter of image
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
    clear Counter Deletion Num Length_Num Deletion ReplaceList dirs.DummyStimuliDir
    
    %%%%%%%%%% FIN ESTIMULOS PERCEPCION   %%%%%%%%%%
elseif strcmp(design.session,'ShapeOnly')
    %%
    dirs.DummyStimuliDir    = {dirs.TaskShapeOnlyStimuliDir(:,1).name}'; % Creation of a Dummy Stimuli Directory to Modify
    ShapeOnly_Stimuli_Dummy = stim.ShapesOnly; % Creation of a Dummy Task_ShapeColor_Stimuli to Modify
    
    %%% Stimuli Name Assignment in Task_ShapeColor_Stimuli_Dummy base
    for ReplaceStimuli = 1:size(dirs.DummyStimuliDir,1)
        
        % Variable definition
        Counter    = 1; % Letter Deletion Counter
        Num        = regexp(dirs.TaskShapeOnlyStimuliDir(ReplaceStimuli,1).name,'\d'); % Position of numbers in Image name
        Length_Num = length(Num); % Amount of numbers on image (only take into account 2 number images)
        
        %%% Iteration per letter of image
        for Del_Letters = 1:size(dirs.DummyStimuliDir{ReplaceStimuli,1},2)
            if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter) % If Counter get to the positions in NUM skip the deletion
                Counter  = Counter + 1;
            else % If you are not in positions of NUM, Delete in the dummy
                dirs.DummyStimuliDir{ReplaceStimuli,1}(Counter) = [];
            end
        end
        
        % Search index where the directory image number corresponds to the numbers defined in the Task_ShapeColor_Stimuli_Dummy
        ReplaceList = find([ShapeOnly_Stimuli_Dummy{:}] == str2double(dirs.DummyStimuliDir{ReplaceStimuli,1}));
        
        %%% Replace in the original Task_ShapeColor_Stimuli the images
        for ReplaceIter = 1:length(ReplaceList)
            stim.ShapesOnly{ReplaceList(ReplaceIter)} = dirs.TaskShapeOnlyStimuliDir(ReplaceStimuli,1).name;
        end
    end
    clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir
    
else
    dirs.DummyStimuliDir     = {dirs.TaskShapeColorStimuliDir(:,1).name}'; % Creation of a Dummy Stimuli Directory to Modify
    ShapeColor_Stimuli_Dummy = stim.ShapesColor; % Creation of a Dummy Task_ShapeColor_Stimuli to Modify
    
    %%% Stimuli Name Assignment in Task_ShapeColor_Stimuli_Dummy base
    for ReplaceStimuli = 1:size(dirs.DummyStimuliDir,1)
        
        % Variable definition
        Counter    = 1; % Letter Deletion Counter
        Num        = regexp(dirs.TaskShapeColorStimuliDir(ReplaceStimuli,1).name,'\d'); % Position of numbers in Image name
        Length_Num = length(Num); % Amount of numbers on image (only take into account 2 number images)
        
        %%% Iteration per letter of image
        for Del_Letters = 1:size(dirs.DummyStimuliDir{ReplaceStimuli,1},2)
            if  Counter ~= Length_Num + 1  && Del_Letters == Num(Counter) % If Counter get to the positions in NUM skip the deletion
                Counter  = Counter + 1;
            else % If you are not in positions of NUM, Delete in the dummy
                dirs.DummyStimuliDir{ReplaceStimuli,1}(Counter) = [];
            end
        end
        
        % Search index where the directory image number corresponds to the numbers defined in the Task_ShapeColor_Stimuli_Dummy
        ReplaceList = find([ShapeColor_Stimuli_Dummy{:}] == str2double(dirs.DummyStimuliDir{ReplaceStimuli,1}));
        
        %%% Replace in the original Task_ShapeColor_Stimuli the images
        for ReplaceIter = 1:length(ReplaceList)
            stim.ShapesColor{ReplaceList(ReplaceIter)} = dirs.TaskShapeColorStimuliDir(ReplaceStimuli,1).name;
        end
    end
    clear Counter Deletion Num Length_Num Deletion ReplaceList DummyStimuliDir
end

