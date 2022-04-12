function [log, extra, counter] = runTask(log, counter, ptb, extra)

%% Start task
for i = 1:log.numTrials
    
    %-------------------------------------------------------------------------%
    %% Task instructions
    if i == 1 %% for instructions to display
        % Save in log
        [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN,'TaskStart', toc, counter);
        [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN,'InstructionsTaskStart', toc, counter);
        
        % Task instructions if training done before
        if log.training
            % Draw instructions
            Instructions = DrawFormattedText(ptb.w.pointer,log.texts.startTaskTxtTrain{1,1},'center','center',ptb.fontColor);
            Screen('Flip',ptb.w.pointer, Instructions)
            WaitSecs(1);
            
            % Press space
            SpaceToContinue(ptb);
            
        else % Task instructions if training NOT done before
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
            
            % Draw start
            Instructions = DrawFormattedText(ptb.w.pointer,log.texts.startTaskTxtTask{1,1},'center','center',ptb.fontColor);
            Screen('Flip',ptb.w.pointer, Instructions)
            WaitSecs(1);
            
            % Press space
            SpaceToContinue(ptb)            
        end
            
        % Save in log
        [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN,'InstructionsTrainingEnd', toc, counter);
        [counter, log] = sendTrigger(log, NaN, NaN, NaN, NaN,'FirstBlockStart', toc, counter);
    end
     
    %-------------------------------------------------------------------------%
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
    Screen('DrawTexture', ptb.w.pointer, log.ProtImg{i}, [], [],[],0)

    Screen('Flip',ptb.w.pointer)

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
                extra.respTime(i) = toc(extra.t0resp); %- ptb.scrn.Slack;
                if log.correctMatTask(i) == 1; extra.correct = 1; else; extra.correct = 0; end
                break
            elseif strcmp(cckey,'RightArrow')
                respCode = 'right';
                extra.respTime(i) = toc(extra.t0resp); %- ptb.scrn.Slack;
                if log.correctMatTask(i) == 0; extra.correct = 1; else; extra.correct = 0; end
                break
            end
        end
    end

    % Check if no press
    if ~exist('respCode', 'var')
        respCode = 'NoPress';
        extra.respTime(i) = -1;
        extra.correct = -1;
    else
        if isempty(respCode)
            respCode{i} = 'NoPress';
            extra.respTime(i) = -1;
            extra.correct = -1;
        end
    end

    % Save information
    [counter, log] = sendTrigger(log, i, respCode, extra.correct, extra.respTime(i),[log.ProtNames{i},'_Answer'], toc, counter);
    disp(['Completed trial ' num2str(i) ' / ' num2str(log.numTrials)])
end


%-------------------------------------------------------------------------%
%% Space to continue function
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
%         % Send Trigger
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