function [log, extra, counter] = runTraining(log, counter, ptb, extra)

%% Start trining
for i = 1:log.numTrialsTraining
    
    %-------------------------------------------------------------------------%
    %% Task instructions
    if i == 1 %% for instructions to display
        % Start counting right before drawing instructions
        tic
        
        % Save in log
        [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN, 'TrainingStart', toc, counter);
        [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN, 'InstructionsTrainingStart', toc, counter);
        
        % Draw welcome
        Welcome = DrawFormattedText(ptb.w.pointer,log.texts.welcomeTxt{1,1},'center','center',ptb.fontColor);
        Screen('Flip',ptb.w.pointer, Welcome)
        WaitSecs(1);
        
        % Press space
        SpaceToContinue(ptb)
        
        % Draw instructions
        Instructions = DrawFormattedText(ptb.w.pointer,log.texts.insTxt{1,1},'center','center',ptb.fontColor);
        Screen('Flip',ptb.w.pointer, Instructions)
        WaitSecs(1);
        
        % Press space
        SpaceToContinue(ptb)
        
        %Draw instructions
        Instructions = DrawFormattedText(ptb.w.pointer,log.texts.insTxt{1,1},'center','center',ptb.fontColor);
        Screen('Flip',ptb.w.pointer, Instructions)
        WaitSecs(1);

        %Press space
        SpaceToContinue(ptb)

        % Draw instructions
        Instructions = DrawFormattedText(ptb.w.pointer,log.texts.insTxt2{1,1},'center','center',ptb.fontColor);
        Screen('Flip',ptb.w.pointer, Instructions)
        WaitSecs(1);

        % Press space
        SpaceToContinue(ptb)
        
        
        % Draw instructions
        Instructions = DrawFormattedText(ptb.w.pointer,log.texts.insTxt3{1,1},'center','center',ptb.fontColor);
        Screen('Flip',ptb.w.pointer, Instructions)
        WaitSecs(1);

        % Press space
        SpaceToContinue(ptb)
        
        % Draw training instructions
        Training = DrawFormattedText(ptb.w.pointer,log.texts.trainingTxt{1,1},'center','center',ptb.fontColor);
        Screen('Flip',ptb.w.pointer, Training)
        WaitSecs(1);
        
        % Press space
        SpaceToContinue(ptb)
        
        % Save in log
        [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN,'InstructionsTrainingEnd', toc, counter);
    end
    
    
    %-------------------------------------------------------------------------%
    %% Display fixation cross
    Instructions = DrawFormattedText(ptb.w.pointer,'+','center','center',ptb.fontColor);
    Screen('Flip',ptb.w.pointer, Instructions)
    
    % send trigger (at fixation cross onset)
    [counter, log] = sendTrigger(log, i, NaN, NaN, NaN,'FixationCrossStart', toc, counter);
    WaitSecs(log.data.fixationTime) % Wait for fixation cross time
    [counter, log] = sendTrigger(log, i, NaN, NaN, NaN,'FixationCrossEnd', toc, counter);
    
    % Run Images
    Screen('FillRect', ptb.w.pointer,ptb.backgroundColor)
    Screen('DrawTexture', ptb.w.pointer, log.trainProtImg{i}, [], [],[],0)
    
    Screen('Flip',ptb.w.pointer)
%     % set up and present "I am" text
%     extra.currTrialIAm(i) = log.data.randTimes.IAmmin + (log.data.randTimes.IAmmax-log.data.randTimes.IAmmin).*rand(1,1);
%     
%     % display word
%     Instructions = DrawFormattedText(ptb.w.pointer,'I am','center','center',ptb.fontColor);
%     Screen('Flip',ptb.w.pointer, Instructions)
%     
%     % send trigger (at "I am" onset)
%     [counter, log] = sendTrigger(log, i, NaN, NaN, NaN, log.events.IAmStart, 'IAmStart', toc, counter);
%     WaitSecs(extra.currTrialIAm(i))
%     [counter, log] = sendTrigger(log, i, NaN, NaN, NaN, log.events.IAmEnd, 'IAmEnd', toc, counter);
%     
%     % send trigger (at word onset)
%     [counter, log] = sendTrigger(log, i, NaN, NaN, NaN, log.events.wordStart, log.wordListTraining{i,2}, toc, counter);
%     
%     % display word
%     Instructions = DrawFormattedText(ptb.w.pointer,log.wordListTraining{i,1},'center','center',ptb.fontColor);
%     Screen('Flip',ptb.w.pointer, Instructions)
    
    % set up timing for word display
    extra.t0resp = tic;
    
    %-------------------------------------------------------------------------%
    %% Response
    keyCount = 0; % Initialise key counter for every button press
    while (toc(extra.t0resp) < log.data.respDur)
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            keyCount = keyCount+1;
            cckey = KbName(keyCode);            % Find out which key was pressed
            if iscell(cckey)                    % If more than one key pressed, only take first key
                cckey = cckey{1};
            end
            if strcmp(cckey,'LeftArrow')
                respCode = 'left';
                extra.respTimeTraining(i) = toc(extra.t0resp); %- ptb.scrn.Slack;
                    if log.correctMatTrain(i) == 1; extra.correct = 1; 
                        correct = DrawFormattedText(ptb.w.pointer,'¡CORRECTO!','center','center',ptb.fontColor);
                        Screen('Flip',ptb.w.pointer, correct)
                        WaitSecs(1);
                    else; extra.correct = 0; 
                        inorrect = DrawFormattedText(ptb.w.pointer,'¡INCORRECTO!','center','center',ptb.fontColor);
                        Screen('Flip',ptb.w.pointer, inorrect)
                        WaitSecs(1);
                    end
                break
            elseif strcmp(cckey,'RightArrow')
                respCode = 'right';
                extra.respTimeTraining(i) = toc(extra.t0resp); %- ptb.scrn.Slack;
                    if log.correctMatTrain(i) == 0; extra.correct = 1; 
                        correct = DrawFormattedText(ptb.w.pointer,'¡CORRECTO!','center','center',ptb.fontColor);
                        Screen('Flip',ptb.w.pointer, correct)
                        WaitSecs(1);
                    else; extra.correct = 0;
                        inorrect = DrawFormattedText(ptb.w.pointer,'¡INCORRECTO!','center','center',ptb.fontColor);
                        Screen('Flip',ptb.w.pointer, inorrect)
                        WaitSecs(1);
                    end
                break
            end
        end
    end

    % Check if no press
    if ~exist('respCode', 'var')
        respCode = 'NoPress';
        extra.respTimeTraining(i) = -1;
        extra.correct = -1;
    else
        if isempty(respCode)
            respCode{i} = 'NoPress';
            extra.respTimeTraining(i) = -1;
            extra.correct = -1;
        end
    end

    % Save information
    [counter, log] = sendTrigger(log, i, respCode, extra.correct, extra.respTimeTraining(i), [log.trainProtNames{i},'_Answer'], toc, counter);
    disp(['Completed trial ' num2str(i) ' / ' num2str(log.numTrialsTraining)])

end


%-------------------------------------------------------------------------%
%% Space to continue function
% Space to continue function for training
    function SpaceToContinue(ptb)
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space')) == 1
                break
            elseif keyCode(KbName('ESCAPE')) == 1
                Screen(ptb.w.pointer,'Close') % This sends an error
                break
            end
        end
    end

%% Send trigger function
    function [counter, log] = sendTrigger(log, trial, answer, accuracy, rt, eventName, eventTime, counter)
        % Send Trigger
%         if log.EEG
%             outportb(888,eventNumber);
%             pause(0.001)
%             outportb(888,0);
%         end
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