function Prototipos()
%%%%%%%%%% PROTOTIPOS
%%%%%%%%%% Psychtoolbox - CNC 2022

home;
close all; % close all
clear log dirs ptb stim design screen do;

%% Genpath the folders for functions
%% Add paths
log.data.basePath         = mfilename('fullpath');                   % Script Path
log.data.basePath         = strsplit(log.data.basePath,'\');         % Split to go one back
log.data.basePath         = strjoin(log.data.basePath(1:end-1),'\'); % Join to get the base
log.data.stimuliPath      = [log.data.basePath,'\Stimuli'];          % Add stimuli
log.data.stimuliTrainPath = [log.data.stimuliPath,'\Training'];      % Add stimuli
log.data.stimuliTaskPath  = [log.data.stimuliPath,'\Task'];          % Add stimuli
log.data.fxPath           = [log.data.basePath,'\fx'];               % Add functions
log.data.outPath          = [log.data.basePath,'\Results'];          % Add output path

% LEFT = 1; RIGHT = 0; CAMBIAR CON ANTO
log.correctMatTrain       = [1,0,0,1];
log.correctMatTask        = [0,1,0,1];

% Add functions to path
addpath(log.data.fxPath)

%-------------------------------------------------------------------------%
%% Pre-define Stuff
% Triggers, durations and counter for log
log.data.respDur       = 10; % maximum time allowed for responding (in seconds)
log.data.fixationTime  = 0.8; % in seconds
counter                = 2;   % counter for log (start at 2 due to header)
extra                  = struct;

% Add usual stuff: EEG, Training, Code, Age, Laterality.
answer          = menu('Training','Yes','No');
if answer == 2; answer = 0; end 
log.training    = answer;                                   % Training
genre           = {'Mujer','Hombre', 'Otro'};
genero          = menu('Genero','Mujer','Hombre', 'Otro');
log.genre       = genre{genero};
log.age         = inputdlg('Age');                          % Age
log.age         = str2double(log.age);
laterality      = {'Left','Right', 'Ambi'};                 % Define possible lateralities
answer          = menu('Laterality','Left','Right','Ambi'); % Laterality
log.laterality  = laterality{answer};                       % Indexing
log.code        = char(inputdlg('Subject Code'));           % Code
groups          = {'Uno','Dos'};
grupo           = menu('Grupo','Uno','Dos');
log.sham        = groups{grupo};
log.escolaridad = inputdlg('Escolaridad');
log.escolaridad = str2double(log.escolaridad);

% log.language   = menu('Language','Spanish','English');
clear answer

% Create results matrix
log.results{1,1} = 'Trial';
log.results{1,2} = 'Answer';
log.results{1,3} = 'Accuracy';
log.results{1,4} = 'reactionTime';
log.results{1,5} = 'Time';
log.results{1,6} = 'EventName';

%-------------------------------------------------------------------------%
%% Instruction text (This should be moved to fx but im leaving it here,...
%  ... for the researcher to have an easier time modifying it)
% if log.language == 1
  log.texts.welcomeTxt = {['¡Bienvenido/a! Gracias por participar en nuestro experimento.',...
    newline,...
    'Procederemos a explicar la tarea.',... 
    newline,...
    newline,...
    'Aprete espacio para continuar']};

log.texts.insTxt = {['Luego de estas instrucciones apareceran una serie de imagenes formadas por nueve puntos unidos por lineas.',...
    newline,...
    'Hay algunas que se parecen mucho entre si y otras menos.',...
    newline,...
    'Trata de identificar las figuras que se parecen entre si.',...
    newline,...
    newline,...
    'Aprete espacio para continuar']};

log.texts.insTxt2 = {['Aprete la tecla DERECHA para indicar que la figura presentada forma parte del grupo de figuras similares.',...
    newline,...
    'Aprete la IZQUIERDA para indicar que no forma parte.',...
    newline,...
    newline,...
    'Aprete espacio para continuar']};

log.texts.insTxt3 = {['Luego de apretar uno de los dos botones,',...
    newline,...
    'aparecera en pantalla "CORRECTO" si la figura pertenece al grupo o "INCORRECTO" si no pertenece.',...
    newline,...
    'Los colores de las figuras no son importantes para identificar similitud.',...
    newline,...
    newline,...
    'Aprete espacio para continuar']};

log.texts.trainingTxt = {['Para asegurarnos que entendio la tarea y se familiarice,',...
    newline,...
    'vamos a empezar un entrenamiento con imagenes de prueba.',...
    newline,...
    'Los resultados de dicho entrenamiento no seran tenidos en cuenta.',...
    newline,...
    'Si tiene alguna duda, por favor contactese con el/la investigador/a antes de comenzar.',...
    newline,...
    'Si no tiene ninguna duda, puede empezar el entrenamiento.',...
    newline,...
    newline,...
    'Aprete espacio para comenzar el entrenamiento']};

log.texts.startTaskTxtTrain = {['¡Buen trabajo!. Ahora apareceran en pantalla nuevas figuras muy similares a las anteriores.',...
    newline,...
    'En la tarea real, luego de responder no se le dira si fue correcta o incorrecta su respuesta.',...
    newline,...
    'Si aun tiene dudas sobre la tarea, preguntele a el/la investigador/a ahora.',...
    newline,...
    'Si cree que entendio la tarea, aprete espacio para comenzar el experimento.',...
    newline,...
    newline,...
    newline,...
    'Aprete espacio para comenzar la tarea']};

log.texts.startTaskTxtTask = {['¡Buen trabajo!. Ahora apareceran en pantalla nuevas figuras muy similares a las anteriores.',...
    newline,...
    'En la tarea real, luego de responder no se le dira si fue correcta o incorrecta su respuesta.',...
    newline,...
    'Si aun tiene dudas sobre la tarea, preguntele a el/la investigador/a ahora.',...
    newline,...
    'Si cree que entendio la tarea,',...
    newline,...
    'aprete espacio para comenzar el experimento.',...
    newline,...
    newline,...
    'Aprete espacio para comenzar la tarea']};

%-------------------------------------------------------------------------%
%% CONFIRM log.data TO START TASK
disp('=================CHECK SETTINGS====================');
disp(['Subj ID:            ' log.code]);
disp(['Age:                ' num2str(log.age)]);
disp(['Laterality:         ' log.laterality]);
disp(['Training:           ' num2str(log.training)]);
% disp(['Amount of Trials:   ' num2str(log.numTrials)]);
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

%-------------------------------------------------------------------------%
%% Load TRAINING (if doing training) and TASK log.data
if log.training == 1
    % Training
    cd(log.data.stimuliTrainPath)
    prototypeImages = dir(); prototypeImages = {prototypeImages.name}; prototypeImages = prototypeImages(3:end);
    log.trainProtNames = prototypeImages;
    for trialProtLoadIter = 1:length(prototypeImages)
        log.trainProtMat{trialProtLoadIter} = imread([log.data.stimuliTrainPath,'\',prototypeImages{trialProtLoadIter}]);
        log.trainProtImg{trialProtLoadIter} = Screen('MakeTexture', ptb.w.pointer, log.trainProtMat{trialProtLoadIter});
    end

    log.numTrialsTraining        = size(prototypeImages,2);
    clear prototypeImages
end

% Task
cd(log.data.stimuliTaskPath)
prototypeImages = dir(); prototypeImages = {prototypeImages.name}; prototypeImages = prototypeImages(3:end);
log.ProtNames = prototypeImages;
for ProtLoadIter = 1:length(prototypeImages)
    log.ProtMat{ProtLoadIter} = imread([log.data.stimuliTaskPath,'\',prototypeImages{ProtLoadIter}]);
    log.ProtImg{ProtLoadIter} = Screen('MakeTexture', ptb.w.pointer, log.ProtMat{ProtLoadIter});
end

log.numTrials        = size(prototypeImages,2);
clear prototypeImages

% Get ifi, slack, width and height
ptb.scrn.ifi     = Screen('GetFlipInterval', ptb.w.pointer);    % Get inter frame interval
ptb.scrn.Slack   = Screen('GetFlipInterval', ptb.w.pointer)/2;  % Get half of the ifi (take it off RT)
ptb.w.W          = ptb.w.rect(RectRight);                       % screen width
ptb.w.H          = ptb.w.rect(RectBottom);                      % screen height
Screen(ptb.w.pointer,'FillRect',ptb.backgroundColor);           % Fill with background color
Screen('Flip', ptb.w.pointer);                                  % First flip.

% Retreive the maximum priority number and use it!
ptb.topPriorityLevel = MaxPriority(ptb.w.pointer);
Priority(ptb.topPriorityLevel);

%-------------------------------------------------------------------------%
%% Run TASK with TRAINING
if log.training
    [log, extra, counter] = runTraining(log, counter, ptb, extra);
    [counter, log] = saveInLog(log, NaN, NaN, NaN, NaN,'TrainingEnd', toc, counter);
    [log, extra, counter] = runTask(log, counter, ptb, extra); %ok
else % Run TASK without TRAINING
    [log, extra, counter] = runTask(log, counter, ptb, extra); %ok
end

%-------------------------------------------------------------------------%
%% Finish task
% Trigger block finishes
[counter, log] = saveInLog(log, NaN, NaN, NaN, NaN,'BlockEnd', toc, counter);

% Display goodbye text
Instructions = DrawFormattedText(ptb.w.pointer,'Â¡Termino la tarea! Gracias por participar.','center','center',ptb.fontColor);
Screen('Flip',ptb.w.pointer, Instructions)

% Give it 5 seconds
WaitSecs(5);

% Trigger end, enable keyboard, save log.data
[counter, log] = saveInLog(log, NaN, NaN, NaN, NaN, 'TaskEnds', toc, counter); %#ok

% Enable keyboard and close all
ListenChar(0); % enable keyboard
Priority(0);
sca;

% Clear things we dont care about
clear extra cckey counter i jHand keyCode keyCount keyIsDown log.data Instructions laterality ans


%-------------------------------------------------------------------------%
%% Save information, show cursor clear and thanks
cd(log.data.outPath)
save([num2str(log.code) '_' datestr(now,'mm-dd-yyyy HH-MM')])
ShowCursor()
clc
disp('Thanks for participating :)');


%-------------------------------------------------------------------------%
%% Send trigger function
function [counter, log] = saveInLog(log, trial, answer, accuracy, rt, eventName, eventTime, counter)
    % Log
    log.results{counter,1} = trial;
    log.results{counter,2} = answer;
    log.results{counter,3} = accuracy;
    log.results{counter,4} = rt;
    log.results{counter,5} = eventTime;
    log.results{counter,6} = eventName;
    counter = counter + 1;
end

end