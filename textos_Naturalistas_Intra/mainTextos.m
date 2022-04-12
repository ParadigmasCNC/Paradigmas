function mainTextos()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Textos Paradigma
    %
    % Description: This tasks presents 4 naturalistic audios. After each
    %              Audio, 5 questions are asked to the participant regarding information
    %              told by the audio speaker. The subject has to answer from 5 different multiple
    %              choice-style answers provided by the task.
    %              There are 4 different pathological groups to evaluate.
    %              The task will tell you within each group, which one was
    %              the last audio permutation run. For which the researcher
    %              has to choose the permutation that follows to the one
    %              stated in the command window. Doing so will result on
    %              having a counterbalanced number of responses per group once the
    %              data adquisition phase is over.
    %              WHEN IT SAYS THE LAST PERMUTATION WAS 4, GO BACK TO PERM
    %              1.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Outputs: - Log: * Texts (order of texts)
    %                 * behOutputs (answers per question and accuracy)
    %                 * Codigo (subject Code)
    %                 * Edad (subject Age)
    %                 * Lateralidad (laterality: 1 = Left-handed / 2 = Right-handed)
    %                 * Sexo (Sex: 1 = Male / 2 = Female)
    %                 * Date (date: d/m/y/ time: h/m/s)
    %                 * window (defined window in which the experiment run)
    %                 * corrAnswers (correct answers per text)
    %                 * multipleChoice (questions asked to the patient after each text)
    %                 * events (List of events and latencies for audio EEG marking)
    %
    %          - Events: * Motor     = 11 / 21;
    %                    * Mentalist = 12 / 22;
    %                    * SocMot    = 13 / 23;
    %                    * Soc       = 14 / 24;
    %                    * AGREGAR MARCA POR BLOQUE FIN E INICIO
    %                    * SWM 40 Trials
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Author: * Hernando Santamaria - hernando.santamaria@gbhi.org
    %         * Matias Fraile Vazquez - matias.fraile95@gmail.com
    %         
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Clear prompt
    clc
    close all
    Screen('Preference', 'SkipSyncTests', 1);
    
    %% Add paths
    % Get base path
    paths.basePath = mfilename('fullpath');
    paths.basePath = strsplit(paths.basePath,'\');

    % Define paths
    paths.scriptPath   = strjoin(paths.basePath(1:end-1),'\');
    paths.stimuliPath  = [paths.scriptPath,'\Stimuli'];
    paths.functionPath = [paths.scriptPath,'\fx'];
    paths.audiosPath   = [paths.scriptPath,'\Stimuli\Audios'];
    paths.answerPath   = [paths.scriptPath,'\Stimuli\Answers'];
    paths.savePath     = [paths.scriptPath,'\Logs'];
    
    % Add genpath
    addpath(genpath(paths.scriptPath));
    
    %% Add EEG variables and check if EEG
    global EEG
    global iEEG
    global pportobj pportaddr MARCA_DURACION
    MARCA_DURACION = 1e-3;
    EEGcheck = menu('Using EEG?','Yes','No');
    if EEGcheck == 1; EEG = true; else; EEG = false; end
    
    % iEEG CHECK
    iEEGcheck = menu('Using iEEG?','Yes','No');
    if iEEGcheck == 1; iEEG = true; else; iEEG = false; end

    %% Paralel Port
    % Connect to EEG if EEG true
    if EEG
        % Define event structure
        marca = struct;
    
        % Define port address
        pportaddr = 'C020';

        % Connecting...
        if exist('pportaddr','var') && ~isempty(pportaddr)
            % Print Connect
            fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
            pportaddr  = hex2dec(pportaddr); % Get hexdec value
            pportobj   = io64;               % Define IO
            io64status = io64(pportobj);     % Connect to port

            % Ping it
            EnviarMarca(0);

            % If it didnt connect return error
            if io64status ~= 0
                error('io64 failure: could not initialise parallel port.\n');
            end
        end

        %% Define events to use
        % Fixation cross
        marca.FixCrossStart       = 1;
        marca.FixCrossEnd         = 11;
        
        % Start test
        marca.inicioTarea         = 241;
        marca.finTarea            = 251;

        % Start blocks
        marca.inicioBloqueM        = 101;
        marca.finBloqueM           = 111;
        marca.inicioBloqueS        = 102;
        marca.finBloqueS           = 112;
        marca.inicioBloqueNM       = 103;
        marca.finBloqueNM          = 113;
        marca.inicioBloqueNS       = 104;
        marca.finBloqueNS          = 114;
        log.marcas = marca;
    end


    %% Define demographics
    % Subject Code and Age
    prompt   = {'Codigo:','Edad:'};
    dlgtitle = 'Datos del Paciente';
    dims     = [1 35];
    definput = {'',''};
    answer   = inputdlg(prompt,dlgtitle,dims,definput); % Poner tope de edad 120
    log.Codigo = answer{1};
    log.Edad   = answer{2};
    
    % Subject laterality sex and date
    log.Lateralidad = menu('Lateralidad','Zurdo','Diestro');
    log.Sexo        = menu('Sexo','Masculino','Femenino','Otro');
    possibleGroups  = {'AD','bvFTD','PD','COA'};
    log.Group       = menu('Grupo', possibleGroups);
    log.date        = datestr(now);

    
    %% Define log and add texts and answer matrix
    % Get balance
    cd([paths.stimuliPath,'/CounterBalance/',possibleGroups{log.Group}])
    load('NOTOCAR.mat'); %#ok
    log.lastBalance = NOTOCAR; %#ok
    disp(['La ultima permutacion para el grupo ',possibleGroups{log.Group}, ' fue la: ',num2str(NOTOCAR)]);
    
    % Change it for save
    if NOTOCAR == 4
        NOTOCAR = 1;
    else
        NOTOCAR = NOTOCAR + 1;
    end
    save('NOTOCAR','NOTOCAR')
    log.balance = menu('Counter-Balance','1. M-NM-S-NS','2. NM-M-NS-S','3. S-NS-M-NM','4. NS-S-NM-M');
    if log.balance == 1
        log.texts = {'Motor','No_Motor','Social','No_Social'};
    elseif log.balance == 2
        log.texts = {'No_Motor','Motor','No_Social','Social'};
    elseif log.balance == 3
        log.texts = {'Social','No_Social','Motor','No_Motor'};
    else
        log.texts = {'No_Social','Social','No_Motor','Motor'};
    end
    
    % Create matrix for beh data
    for textsIter = 1:length(log.texts)
        log.behOutputs.(log.texts{textsIter}){1,1} = {'-'};
        log.behOutputs.(log.texts{textsIter}){2,1} = {'Answer'};
        log.behOutputs.(log.texts{textsIter}){3,1} = {'Accuracy'};
    end
    
    
    %% Configure constant and variables (log)
    hd.itemsize = 100;
    hd.wsize    = (hd.itemsize/2)+30;
    hd.textsize = 35;
    hd.textfont = 'Helvetica';
    
    %% Pre-define: * Introduction texts
    %              * Events and latencies for EEG
    %              * Multiple choice texts
    %              * Correct answers
    
    % Introduction Texts
    [Bienvenido,Intro,Intro2,Intro3,GetReady,SiguienteAudio,Gracias] = getIntroTxts(paths);
    introduction = {Bienvenido,Intro,Intro2,Intro3,GetReady};
    
    % Excel with latencias and event marks
    if EEG || iEEG
        for xlsIter = 1:length(log.texts)
            [~,~,raw] = xlsread([paths.stimuliPath,'\Codificacion_Tiempos_Textos_Final'],log.texts{xlsIter});
            raw = raw(2:end,:);
            counter = 0;
            for rawIter = 1:length(raw)
                eventList(rawIter+counter,1)     = raw{rawIter,2};      %#ok
                eventList(rawIter+counter+1,1)   = raw{rawIter,2} + 10; %#ok
                latencyList(rawIter+counter,1)   = raw{rawIter,3};      %#ok
                latencyList(rawIter+counter+1,1) = raw{rawIter,4};    %#ok
                counter = counter + 1;
                %latencyList(rawIter) = raw{rawIter,4};
            end
            log.events.(['eventList_',num2str(xlsIter)])   = eventList;
            log.events.(['latencyList_',num2str(xlsIter)]) = latencyList;
            clear eventList latencyList
        end
    end
    
    % Multiple Choice and Correct Answers
    for qIter = 1:length(log.texts)
        cd([paths.answerPath,'/',log.texts{qIter}]);
        directory = dir();
        
        % Correct Answers
        fileID     = fopen('CorrAnswers.txt', 'r');
        formatSpec = '%c'; % Format to read white spaces too
        log.corrAnswers.(log.texts{qIter}) = fscanf(fileID,formatSpec);
        log.corrAnswers.(log.texts{qIter}) = strsplit(log.corrAnswers.(log.texts{qIter}),' ');
        fclose(fileID);
        
        % Delete ./../corrAnswers from directory
        directory(1:3) = [];
        
        % Multiple Choice
        for dirIter = 1:length(directory)
            fileID     = fopen(directory(dirIter).name, 'r');
            formatSpec = '%c'; % Format to read white spaces too
            log.multipleChoice.(log.texts{qIter}).(directory(dirIter).name(1:end-4)) = fscanf(fileID,formatSpec);
            fclose(fileID);
        end
    end
    
    % Clear useless variables
    clear possibleGroups directory qIter dirIter rawIter textsIter xlsIter Bienvenido GetReady Intro Intro2 Intro3 dlgtitle dirIter counter formatSpec fileID dims EEGcheck prompt raw answer definput
    
    
    %% Start Psychtoolbox
    PsychDefaultSetup(2);
    HideCursor();
    Priority(max(Priority));


    %% Configure Screen
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    screens = Screen('Screens');

    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    screenNumber = max(screens);

    % Define black and white (white will be 1 and black 0). This is because
    % in general luminace values are defined between 0 and 1 with 255 steps in
    % between. All values in Psychtoolbox are defined between 0 and 1
    hd.white = WhiteIndex(screenNumber);
    hd.black = BlackIndex(screenNumber);


    %% Present Test to patient
    % Open an on screen window using PsychImaging and color it grey.
    [window, scrnsize] = PsychImaging('OpenWindow', screenNumber, hd.black);
    hd.window  = window;
    hd.centerx = scrnsize(3)/2;
    hd.centery = scrnsize(4)/2;
    hd.bottom  = scrnsize(4);
    hd.right   = scrnsize(3);
    Screen('TextSize', hd.window, hd.textsize);
    Screen('TextFont', hd.window, hd.textfont);       

    % Add window to log
    log.window = hd;
    
    
    %% Present Welcome and Introduction to patients
    % Send task start trigger
    if EEG
        EnviarMarca(marca.inicioTarea);
    end
    
    % Start intro iEEG
    if iEEG
        Screen('FillRect',hd.window,hd.black);
        Screen('FillRect', hd.window, hd.white, [0 0 400 100])
        [~,~,~] = DrawFormattedText(hd.window, introduction{1}, 'center', 'center', hd.white);
        Screen('Flip',hd.window);
        WaitSecs(0.5)
    end
    
    % Start intro iter
    for introIter = 1:length(introduction)
        if introIter == length(introduction) && iEEG
            Screen('FillRect',hd.window,hd.black);
            Screen('FillRect', hd.window, hd.white, [0 0 400 100])
            [~,~,~] = DrawFormattedText(hd.window, introduction{1}, 'center', 'center', hd.white);
            Screen('Flip',hd.window);
            WaitSecs(0.5)
        end
        
        % Welcome
        Screen('FillRect',hd.window,hd.black);
        [~,~,~] = DrawFormattedText(hd.window, introduction{introIter}, 'center', 'center', hd.white);
        Screen('Flip',hd.window);
        
        % wait for space or wait 5 seconds
        if introIter == length(introduction) 
            WaitSecs(5);
        else
            spacePress(paths,log)
        end
    end
    
    %% Start Task!
    for tasksIter = 1:length(log.texts)
        if EEG
            if strcmp(log.texts{tasksIter} ,'Motor')
                EnviarMarca(marca.inicioBloqueM);
            elseif strcmp(log.texts{tasksIter} ,'No_Motor')
                EnviarMarca(marca.inicioBloqueNM);
            elseif strcmp(log.texts{tasksIter} ,'Social')
                EnviarMarca(marca.inicioBloqueS);
            elseif strcmp(log.texts{tasksIter} ,'No_Social')
                EnviarMarca(marca.inicioBloqueNS);                
            end
        end
        % Flip to get rid of the "Get ready" text
        Screen('Flip',hd.window);
        
        %% Set up Audio
        InitializePsychSound(1);
        
        % Read audio and play it
        [soundData, freq] = audioread([paths.audiosPath,'/',[log.texts{tasksIter}],'.wav']);
        pahandle = PsychPortAudio('Open', [], [], 0, freq);
        PsychPortAudio('FillBuffer', pahandle, soundData');
        PsychPortAudio('Start', pahandle, 1, 0);
        
        % Block starts
        if iEEG
            Screen('FillRect', hd.window, hd.white, [0 0 400 100])
            Screen('Flip',hd.window);
            WaitSecs(0.5)
            Screen('FillRect',hd.window,hd.black);
            Screen('Flip',hd.window);
        end
        
        % Send triggers in specific seconds
        if EEG || iEEG
            tic; % Start timer for events
            for eventIter = 1:length(log.events.(['eventList_',num2str(tasksIter)]))
                while toc < log.events.(['latencyList_',num2str(tasksIter)])(eventIter)/1000 - 0.002
                    % Keep checking when toc is higher than the event time.
                    % it has a 0.002 ms error rate for which we deduce it from
                    % the timer
                end
                % text
                if iEEG
                    Screen('FillRect', hd.window, hd.white, [0 0 400 100])
                    Screen('Flip',hd.window);
                    %Screen('FillRect',hd.window,hd.white);
                    Screen('Flip',hd.window);
                end
                if EEG
                    EnviarMarca(log.events.(['eventList_',num2str(tasksIter)])(eventIter))
                end
            end
        end
        [~,~,~,~] = PsychPortAudio('Stop',pahandle,1);
        
        %% Start questions
        questionNames = fieldnames(log.multipleChoice.(log.texts{tasksIter}));
        for mCIter = 1:length(fieldnames(log.multipleChoice.(log.texts{tasksIter})))
            fileID     = fopen([paths.answerPath,'\',log.texts{tasksIter},'\',questionNames{mCIter},'.txt'], 'r');
            formatSpec = '%c'; % Format to read white spaces too
            mChoicQ = fscanf(fileID,formatSpec);
            fclose(fileID);
            
            % Send iEEG per question
            if iEEG
                Screen('FillRect', hd.window, hd.white, [0 0 400 100])
                Screen('Flip',hd.window);
                WaitSecs(0.5)
            end
            
            [~,~,~] = DrawFormattedText(hd.window, mChoicQ, 'centerblock', 'center');
            Screen('Flip',hd.window);
            [log] = numberPress(num2str(log.corrAnswers.(log.texts{tasksIter}){mCIter}),log,log.texts{tasksIter},questionNames{mCIter},paths);
            
            % Answer was given iEEG
            if iEEG
                Screen('FillRect', hd.window, hd.white, [0 0 400 100])
                Screen('Flip',hd.window);
                WaitSecs(0.5)
            end
        end
        
        % Block ends for eeg
        if EEG
            if strcmp(log.texts{tasksIter} ,'Motor')
                EnviarMarca(marca.finBloqueM);
            elseif strcmp(log.texts{tasksIter} ,'No_Motor')
                EnviarMarca(marca.finBloqueNM);
            elseif strcmp(log.texts{tasksIter} ,'Social')
                EnviarMarca(marca.finBloqueS);
            elseif strcmp(log.texts{tasksIter} ,'No_Social')
                EnviarMarca(marca.finBloqueNS);                
            end
        end
        
        % Block ends
        if iEEG
            Screen('FillRect', hd.window, hd.white, [0 0 400 100])
            Screen('Flip',hd.window);
            WaitSecs(0.5)
        end
        
        % Thanks for participating or space press for next audio
        if tasksIter == length(log.texts)
            [~,~,~] = DrawFormattedText(hd.window, Gracias, 'center', 'center');
            Screen('Flip',hd.window);
            spacePress(paths,log);
        else
            [~,~,~] = DrawFormattedText(hd.window, SiguienteAudio, 'center', 'center');
            Screen('Flip',hd.window);
            spacePress(paths,log);
        end
    end
    
    %% Save & Close
    cd(paths.savePath)
    save([log.Codigo ,'_', log.date(1:11), '_Texts.mat'],'log');
    
    % Add eeg event end of task
    if EEG
        EnviarMarca(marca.finTarea);
    end
    
    % End task iEEG
    if iEEG
        Screen('FillRect', hd.window, hd.white, [0 0 400 100])
        Screen('Flip',hd.window);
        WaitSecs(0.5)
    end
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    
    %% FUNCTIONS
    % Wait for space press
    function spacePress(paths,log)
        % Define space as default key to move on
        RestrictKeysForKbCheck([32,81]);
        spacePressed = false;
        while ~spacePressed
            [~, keyCode,~] = KbStrokeWait;
            if strcmp(KbName(find(keyCode)), 'space')
                spacePressed = true;
            elseif strcmp(KbName(find(keyCode)), 'q')
                %% Save & Close
                cd(paths.savePath)
                save([log.Codigo ,'_', log.date(1:11), '_Texts.mat'],'log');
                error('Task forcedly stopped') 
            end
        end
        return
    end
    
    % Wait for number presses
    function [log] = numberPress(corrAnswer,log,specificText,specificQ,paths)
        % Define space as default key to move on
        RestrictKeysForKbCheck([81,97,98,99,100,101]); % Deberia correr bien en Linux, cualquier cosa abrir KbName
        numberPress = false;
        while ~numberPress
            [~, keyCode,~] = KbStrokeWait;
            if strcmp(KbName(find(keyCode)), 'q')
                %% Save & Close
                cd(paths.savePath)
                save([log.Codigo ,'_', log.date(1:11), '_Texts.mat'],'log');
                error('Task forcedly stopped')
            end
            log.behOutputs.(specificText){1,size(log.behOutputs.(specificText),2)+1} = specificQ;
            log.behOutputs.(specificText){2,size(log.behOutputs.(specificText),2)}   = KbName(find(keyCode));
            log.behOutputs.(specificText){3,size(log.behOutputs.(specificText),2)}   = strcmp(corrAnswer,KbName(find(keyCode)));
            numberPress = true;
        end
        return
    end

end