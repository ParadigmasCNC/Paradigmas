function  [log, stim ] = runShapeOnly_WM(ptb,stim,design,log,dirs,marca,EEG)
% This function runs the shape color WM binding experiment.
% Inputs: ptb, stim, design, log, dirs, do
% Outputs: log, stim, 
% Orig: INECO, Mod: PRG 11/2019.

%% Show instructions (if asked for)
%-------------------------------------------------------------------------%
% Shape only instructions:
tic
if EEG
    EnviarMarca(marca.inicioTarea);
    log.EEGData{end+1,1} = marca.inicioTarea;
    log.EEGData{end+1,2} = toc;
end
Screen('Flip',ptb.w.pointer)

stim.intructions_text = ...
    {['Please pay attention to the SHAPE and COLOURS.' ...
    'First, you will see a screen with black shapes.'...
    newline,...
    'Then you will be presented a second screen with black shapes',...
    newline,...
    'Please respond if these shapes are the SAME or DIFFERENT.'...
    newline,...
    'Press RIGHT if they are the SAME, press LEFT if they are DIFFERENT'...
    newline,...
    'The position of the coloured shapes is NOT IMPORTANT.'...
    newline,...
    'Do you have any questions?']};

% Show the introductory text...
Show_task_text = DrawFormattedText(ptb.w.pointer, stim.intructions_text{1,1}, 'center','center',ptb.fontColor);
Screen('Flip',ptb.w.pointer, Show_task_text)
WaitSecs(1);  % PRG: I recommend to use WaitSecs instead of pause; pause(1)
SpaceToContinue(ptb.w.pointer)

% Show explanatory image...
ImgTrial_Exp = imread([dirs.Path_ShapeOnly_Stimuli '/' stim.ShapeOnly_Trial_Explanation]);
ImgTrial_Exp = imresize(ImgTrial_Exp,[size(ImgTrial_Exp,1),size(ImgTrial_Exp,2)]);
imageDisplay = Screen('MakeTexture', ptb.w.pointer, ImgTrial_Exp);
Screen('FillRect', ptb.w.pointer,ptb.backgroundColor)
Screen('DrawTexture', ptb.w.pointer, imageDisplay, [], [],[],0)
Screen('Flip',ptb.w.pointer)
WaitSecs(1);
SpaceToContinue(ptb.w.pointer)

% We will start now....
We_will_start_now_txt = DrawFormattedText(ptb.w.pointer,'We will start now. Ready?', 'center','center', ptb.fontColor);
Screen('Flip',ptb.w.pointer, We_will_start_now_txt)
WaitSecs(1);
SpaceToContinue(ptb.w.pointer)

%% Start presenting the stimuli
%%%%%%% Inicio Bloque ShapesOnly %%%%%%
% See if its correct or incorrect trials
if EEG
    EnviarMarca(marca.inicioBloque);
    log.EEGData{end+1,1} = marca.inicioBloque;
    log.EEGData{end+1,2} = toc;
end
for currTrial = 1:design.Trials
    
    if design.AmountOfStimuli == '2'
        if length(unique(stim.Stimuli_Database(:,currTrial+2))) == 4 % Because: 2 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    elseif design.AmountOfStimuli == '3'
        if length(unique(stim.Stimuli_Database(:,currTrial+2))) == 5 % Because: 3 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    end
        
    %.....Fixation cross
    if EEG
        EnviarMarca(marca.FixCrossStart);
        log.EEGData{end+1,1} = marca.FixCrossStart;
        log.EEGData{end+1,2} = toc;
    end
    Screen('FillRect', ptb.w.pointer, ptb.backgroundColor);
    Screen('DrawTexture', ptb.w.pointer, stim.FixDisplay,[],[],[],0);
    Screen('Flip',ptb.w.pointer);
    WaitSecs(design.FixationDuration);
    if EEG
        EnviarMarca(marca.FixCrossEnd);
        log.EEGData{end+1,1} = marca.FixCrossEnd;
        log.EEGData{end+1,2} = toc;
    end
    
    %.....Show sample images
    if EEG
        EnviarMarca(marca.inicioCodificacion);
        log.EEGData{end+1,1} = marca.inicioCodificacion;
        log.EEGData{end+1,2} = toc;
    end
    Screen('DrawTexture', ptb.w.pointer, stim.ImgDisplay{currTrial},[],[],[],0)
    Screen('Flip',ptb.w.pointer);
    WaitSecs(design.SampleDuration);
    if EEG
        EnviarMarca(marca.finCodificacion);
        log.EEGData{end+1,1} = marca.finCodificacion;
        log.EEGData{end+1,2} = toc;
    end
    
    %.....Retention time
    if EEG
        EnviarMarca(marca.FixCrossStart);
        log.EEGData{end+1,1} = marca.FixCrossStart;
        log.EEGData{end+1,2} = toc;
    end
    Screen('DrawTexture', ptb.w.pointer, stim.FixDisplay,[],[],[],0);
    Screen('Flip',ptb.w.pointer);
    WaitSecs(design.retentionTimes(currTrial));
    if EEG
        EnviarMarca(marca.FixCrossEnd);
        log.EEGData{end+1,1} = marca.FixCrossEnd;
        log.EEGData{end+1,2} = toc;
    end
    

    %....Show test images
    if EEG
        EnviarMarca(marca.inicioTesteo);
        log.EEGData{end+1,1} = marca.inicioTesteo;
        log.EEGData{end+1,2} = toc;
    end
    Screen('DrawTexture', ptb.w.pointer, stim.ImgTest{currTrial},[],[],[],0)
    Screen('Flip',ptb.w.pointer)
    [log.responses_subj] = Left_or_Right_ToContinue_ShapesColor(currTrial, log.responses_subj, Correct_Response, ptb,log,EEG,marca);
    if EEG
        EnviarMarca(marca.finTesteo);
        log.EEGData{end+1,1} = marca.finTesteo;
        log.EEGData{end+1,2} = toc;
    end
end
if EEG
    EnviarMarca(marca.finBloque);
    log.EEGData{end+1,1} = marca.finBloque;
    log.EEGData{end+1,2} = toc;
end
if design.ShowResultsToParticipant == 1
%.....Compute results and show them
stim.Results_text = {['Results:',...
    newline,...
    newline,...
    newline,...
    'Reaction time: ' , num2str(mean([log.responses_subj{2:end,4}])),...
    newline,...
    newline,...
    newline,...
    'Percent correct: ' , num2str(sum([log.responses_subj{2:end,5}]/design.Trials*100)),...
    newline]};

%.....Show final results...
stim.Perception_Results = DrawFormattedText(ptb.w.pointer,stim.Results_text{1,1}, 'center','center', ptb.fontColor);
Screen('Flip',ptb.w.pointer, stim.Perception_Results)
WaitSecs(1)
SpaceToContinue(ptb.w.pointer)
end

%-------------------------------------------------------------------------%
% Sub-functions for presentation (key presses)
%-------------------------------------------------------------------------%
    function SpaceToContinue(ptb)
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space')) == 1
                break
            elseif keyCode(KbName('ESCAPE')) == 1
                Screen(ptb.w.pointer,'Close') % PRG this sends an error
                break
            end
        end
    end

    function [responses_subj] = Left_or_Right_ToContinue_ShapesColor(trl, responses_subj, Correct_Response, ptb,log,EEG,marca)
        onsetTime = GetSecs - ptb.scrn.Slack - ptb.scrn.ifi;
        while 1
            [~,secs,keyCode] = KbCheck;
            if keyCode(KbName('LeftArrow')) == 1
                if EEG
                    EnviarMarca(marca.izquierda);
                    log.EEGData{end+1,1} = marca.izquierda;
                    log.EEGData{end+1,2} = toc;
                end
                responses_subj{trl+1,2} = 1; % answer
                responses_subj{trl+1,3} = 0; % no answer 
                responses_subj{trl+1,4} = secs - onsetTime; % reaction time
                if Correct_Response == 1
                    responses_subj{trl+1,5} = 0; % wrong
                elseif Correct_Response == 0
                    responses_subj{trl+1,5} = 1; % correct
                end
                break
            elseif keyCode(KbName('RightArrow'))== 1
                if EEG
                    EnviarMarca(marca.izquierda);
                    log.EEGData{end+1,1} = marca.derecha;
                    log.EEGData{end+1,2} = toc;
                end
                responses_subj{trl+1,2} = 0; % no answer
                responses_subj{trl+1,3} = 1; % answer
                responses_subj{trl+1,4} = secs - onsetTime; % reaction time
                if Correct_Response == 1
                    responses_subj{trl+1,5} = 1; % correct
                elseif Correct_Response == 0
                    responses_subj{trl+1,5} = 0; % wrong
                end
                break
            elseif keyCode(KbName('ESCAPE')) == 1 
                Screen(ptb.w.pointer,'Close') % close if escape is pressed. This sends an error
                break
            end
        end
    end
end