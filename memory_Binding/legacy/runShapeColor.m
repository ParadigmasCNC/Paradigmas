function  [log, ptb, stim, design] = runShapeColor(ptb,stim,design,log,dirs)
%% Show instructions
% Shape colour instructions:
if strcmp(ptb.instructions,'show') == 1
    Texto_Continuar_ShapeOnly = ...
        {['Please pay attention to the SHAPE and COLOURS.' ...
        'First, you will see a screen with coloured shapes.'...
        sprintf('\n'),...
        'Then you will be presented a second screen with coloured shapes',...
        sprintf('\n'),...
        'Please respond if these shapes are the SAME or DIFFERENT.'...
        sprintf('\n'),...
        'Press RIGHT if they are the SAME, press LEFT if they are DIFFERENT'...
        sprintf('\n'),...
        'The position of the coloured shapes is NOT IMPORTANT.'...
        sprintf('\n'),...
        'Do you have any questions?']};
    
    % Show the text.
    Continue_Memory_TaskShapesColor = DrawFormattedText(ptb.w.pointer,Texto_Continuar_ShapeOnly{1,1}, 'center','center');
    Screen('TextSize',ptb.w.pointer , (ceil(ptb.w.rect(1,3)/50)))
    Screen('Flip',ptb.w.pointer, Continue_Memory_TaskShapesColor)
    WaitSecs(1);  % PRG: I recommend to use WaitSecs instead of pause; pause(1)
    SpaceToContinue(ptb.w.pointer)
    
    % Show explanatory image.
    ImgTrial_Exp = imread([dirs.Path_Perception_Stimuli '/' stim.ShapeColor_Trial_Explanation]);
    imageDisplay = Screen('MakeTexture', ptb.w.pointer, ImgTrial_Exp);
    Screen('FillRect', ptb.w.pointer,ptb.backgroundColor)
    Screen('DrawTexture', ptb.w.pointer, imageDisplay, [], [],[],0)
    Screen('Flip',ptb.w.pointer)
    WaitSecs(1);
    SpaceToContinue(ptb.w.pointer)
    
    % Consigna 2 de la tarea
    Memory_TaskShapesOnly_Procedure_deux = DrawFormattedText(ptb.w.pointer,stim.Textos_Tarea{1,2}, 'center','center');
    Screen('TextSize',ptb.w.pointer , (ceil(ptb.w.rect(1,3)/50)))
    Screen('Flip',ptb.w.pointer, Memory_TaskShapesOnly_Procedure_deux)
    WaitSecs(1);
    SpaceToContinue(ptb.w.pointer)
    
    % Consigna 1 de la tarea
    Memory_TaskShapesOnlyOnly_Procedure = DrawFormattedText(ptb.w.pointer,'We will start now. Ready?', 'center','center');
    Screen('TextSize',ptb.w.pointer , (ceil(ptb.w.rect(1,3)/50)))
    Screen('Flip',ptb.w.pointer, Memory_TaskShapesOnlyOnly_Procedure)
    WaitSecs(1);
    SpaceToContinue(ptb.w.pointer)    
end

%% Start presenting the stimuli
%%%%%%% Inicio Bloque ShapesColor %%%%%%
% See if its correct or incorrect trials
for currTrial = 1:length(stim.Stimuli_Task_ShapeColor_Database(1,3:end))
    
    if design.AmountOfStimuli == '2'
        if length(unique(stim.Stimuli_Task_ShapeColor_Database(:,currTrial+2))) == 4 % Because: 2 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    elseif design.AmountOfStimuli == '3'
        if length(unique(stim.Stimuli_Task_ShapeColor_Database(:,currTrial+2))) == 5 % Because: 3 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    elseif design.AmountOfStimuli == '4'
        if length(unique(stim.Stimuli_Task_ShapeColor_Database(:,currTrial+2))) == 6 % Because: 4 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    end
        
    %.....Fixation cross
    Screen('FillRect', ptb.w.pointer, ptb.backgroundColor);
    Screen('DrawTexture', ptb.w.pointer, stim.FixDisplay,[],[],[],0);
    Screen('Flip',ptb.w.pointer);
    WaitSecs(design.FixationDuration);
    
    %.....Show sample images
    Screen('DrawTexture', ptb.w.pointer, stim.ImgDisplay{currTrial},[],[],[],0)
    Screen('Flip',ptb.w.pointer);
    WaitSecs(design.SampleDuration);
     
    %.....Retention time   
    Screen('DrawTexture', ptb.w.pointer, stim.FixDisplay,[],[],[],0);
    Screen('Flip',ptb.w.pointer);
    WaitSecs(design.retentionTimes(currTrial));
    
    %....Show test images
    Screen('DrawTexture', ptb.w.pointer, stim.ImgTest{currTrial},[],[],[],0)
    Screen('Flip',ptb.w.pointer)
    [log.responses_subj] = Left_or_Right_ToContinue_ShapesColor(currTrial, log.responses_subj, Correct_Response, ptb);
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

    function [responses_subj] = Left_or_Right_ToContinue_ShapesColor(trl, responses_subj, Correct_Response, ptb)
        onsetTime = GetSecs - ptb.scrn.Slack - ptb.scrn.ifi;
        while 1
            [~,secs,keyCode] = KbCheck;
            if keyCode(KbName('LeftArrow')) == 1
                responses_subj{trl+1,2} = 1; % answer
                responses_subj{trl+1,3} = 0; % no answer 
                responses_subj{trl+1,4} = secs - onsetTime; % reaction time
                if Correct_Response == 1
                    responses_subj{trl+1,5} = 0; 
                elseif Correct_Response == 0
                    responses_subj{trl+1,5} = 1;
                end
                break
            elseif keyCode(KbName('RightArrow'))== 1
                responses_subj{trl+1,2} = 0; % no answer
                responses_subj{trl+1,3} = 1; % answer
                responses_subj{trl+1,4} = secs - onsetTime; % reaction time
                if Correct_Response == 1
                    responses_subj{trl+1,5} = 1;
                elseif Correct_Response == 0
                    responses_subj{trl+1,5} = 0;
                end
                break
            elseif keyCode(KbName('ESCAPE')) == 1 
                Screen(ptb.w.pointer,'Close') % close if escape is pressed. This sends an error
                break
            end
        end
    end
end