function runShapeColor(ptb, stim, design, dirs)
% This functions runs the Shape Color binding WM task
% Input: ptb, stim, design.
% Output: none
% Orig: INECO; Mod: PRG 11/2019

%% Show instructions
% Shape colour instructions:
if strcmp(ptb.instructions,'show') == 1
    stim.Texto_Continuar_ShapeColor = ...
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
    
    % Show the introductory text.
    Show_task_text = DrawFormattedText(ptb.w.pointer, stim.Texto_Continuar_ShapeColor{1,1}, 'center','center');
    Screen('Flip',ptb.w.pointer, Show_task_text)
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
        
    % We will start now....
    We_will_start_now_txt = DrawFormattedText(ptb.w.pointer,'We will start now. Ready?', 'center','center');
    Screen('Flip',ptb.w.pointer, We_will_start_now_txt)
    WaitSecs(1);
    SpaceToContinue(ptb.w.pointer)    
end

%% Start presenting the stimuli
%%%%%%% Inicio Bloque ShapesColor %%%%%%
% See if its correct or incorrect trials
for currTrial = 1:length(stim.Stimuli_Task_ShapeColor_Database(1,3:end))
    
    if AmountOfStimuli == '2'
        if length(unique(stim.Stimuli_Task_ShapeColor_Database(:,currTrial+2))) == 4 % Because: 2 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    elseif AmountOfStimuli == '3'
        if length(unique(stim.Stimuli_Task_ShapeColor_Database(:,currTrial+2))) == 5 % Because: 3 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    elseif AmountOfStimuli == '4'
        if length(unique(stim.Stimuli_Task_ShapeColor_Database(:,currTrial+2))) == 6 % Because: 4 images repeated once, several 000 and Trial Name.
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    end
     
    % Pantalla 1 segundo blanco 
    Screen('Flip',ptb.w.pointer);
    WaitSecs(1);
    
    % Fixation cross
    Screen('FillRect', ptb.w.pointer, ptb.backgroundColor);
    Screen('DrawTexture', ptb.w.pointer, stim.FixDisplay,[],[],[],0);
    Screen('Flip',ptb.w.pointer,Screen('Flip',ptb.w.pointer) + stim.fixationDuration - ptb.scrn.Slack,0);
    
    % Pantalla 1 segundo blanco
    Screen('Flip',ptb.w.pointer);
    WaitSecs(0.250);
    
    % Show sample images
    Screen('DrawTexture', ptb.w.pointer, stim.ImgDisplay{currTrial},[],[],[],0)
    Screen('Flip',ptb.w.pointer);
    
    % Retention time
    WaitSecs(design.retentionTimes(currTrial));
    
    % Show test images
    Screen('DrawTexture', ptb.w.pointer, stim.ImgTest{currTrial},[],[],[],0)
    Screen('Flip',ptb.w.pointer)
    [log.Answers_Task_ShapeColor] = Left_or_Right_ToContinue_ShapesColor(ptb.w.pointer,currTrial, log.Answers_Task_ShapeColor, stim.Correct_Response, ptb);
end
%%%%%%% Final Bloque ShapesColor %%%%%%%

% Estructura con field de respuestas percepcion
Subject_Answers.TaskShapeOnly = Answers_Task_ShapeColor;

%% Print a last text
RunFinishedTxt = DrawFormattedText(ptb.w.pointer,'Run completed', 'center','center');
Screen('Flip',ptb.w.pointer, RunFinishedTxt)
WainSecs(2)



    function SpaceToContinue(ptb.w.pointer)
        while 1
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('space')) == 1
                break
            elseif keyCode(KbName('ESCAPE')) == 1
                Screen(ptb.w.pointer,'Close')
                break
            end
        end
    end

    function [log] = Left_or_Right_ToContinue_ShapesColor(ptb.w.pointer,trl, Answers_Task_ShapeColor, stim.Correct_Response, ptb)
        onsetTime = GetSecs - ptb.scrn.Slack - ptb.scrn.ifi;
        while 1
            [~,secs,keyCode] = KbCheck;
            if keyCode(KbName('LeftArrow')) == 1
                Answers_Task_ShapeColor{trl+1,2} = 1;
                Answers_Task_ShapeColor{trl+1,3} = 0;
                Answers_Task_ShapeColor{trl+1,4} = secs- onsetTime;
                if Correct_Response == 1
                    Answers_Task_ShapeColor{trls+1,5} = 0;
                elseif Correct_Response == 0
                    Answers_Task_ShapeColor{trl+1,5} = 1;
                end
                break
            elseif keyCode(KbName('RightArrow'))== 1
                Answers_Task_ShapeColor{trls+1,2} = 0;
                Answers_Task_ShapeColor{trl+1,3} = 1;
                Answers_Task_ShapeColor{trl+1,4} = secs- onsetTime;
                if Correct_Response == 1
                    Answers_Task_ShapeColor{trl+1,5} = 1;
                elseif Correct_Response == 0
                    Answers_Task_ShapeColor{trl+1,5} = 0;
                end
                break
            elseif keyCode(KbName('ESCAPE')) == 1
                Screen(window1,'Close')
                break
            end
        end
    end

end