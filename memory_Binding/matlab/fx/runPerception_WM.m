function [log, stim] = runPerception_WM(ptb,stim,design,log,dirs)
% This function runs the shape color WM binding experiment.
% Inputs: ptb, stim, design, log, dirs, do
% Outputs: log, ptb, stim, design.
% Orig: INECO, Mod: PRG 11/2019.

%% Show instructions (if asked for)
%-------------------------------------------------------------------------%
% Shape color instructions:


%Screen('TextSize', ptb.w.pointer, 30*(design.DistanceToStim/0.3));
Screen('Flip',ptb.w.pointer)

stim.intructions_text = ...
    {['You will be presented with coloured shapes on the top and bottom of the screen.', ...
    newline,...
    'Your task is to decide if both groups are the SAME or DIFFERENT ',...
    newline,...
    '(ie. same coloured shapes in both groups)',...
    newline,...
    'Note: the location and arrangement of the shapes is NOT IMPORTANT'...
    newline,...
    'Please press RIGHT if they are the SAME and LEFT is they are DIFFERENT.'...
    newline,...
    'Do you have any questions?']};

% Show the introductory text...
Show_task_text = DrawFormattedText(ptb.w.pointer, stim.intructions_text{1,1}, 'center','center',ptb.fontColor);
Screen('Flip',ptb.w.pointer, Show_task_text)
WaitSecs(1);  % PRG: I recommend to use WaitSecs instead of pause; pause(1)
SpaceToContinue(ptb.w.pointer)

% Show explanatory image...
ImgTrial_Exp = imread([dirs.Path_Perception_Stimuli '/' stim.Perception_Trial_Explanation]);
%ImgTrial_Exp = imresize(ImgTrial_Exp,[size(ImgTrial_Exp,1)*(design.DistanceToStim/0.3),size(ImgTrial_Exp,2)*(design.DistanceToStim/0.3)]);
ImgTrial_Exp = imresize(ImgTrial_Exp,[size(ImgTrial_Exp,1),size(ImgTrial_Exp,2)]);
imageDisplay = Screen('MakeTexture', ptb.w.pointer, ImgTrial_Exp);
Screen('FillRect', ptb.w.pointer,ptb.backgroundColor)
Screen('DrawTexture', ptb.w.pointer, imageDisplay, [], [],[],0)
Screen('Flip',ptb.w.pointer)
WaitSecs(1);
SpaceToContinue(ptb.w.pointer)

% We will start now....
We_will_start_now_txt = DrawFormattedText(ptb.w.pointer,'We will start now. Ready?', 'center','center',ptb.fontColor);
%Screen('TextSize', ptb.w.pointer, 30*(design.DistanceToStim/0.3));
Screen('Flip',ptb.w.pointer, We_will_start_now_txt)
WaitSecs(1);
SpaceToContinue(ptb.w.pointer)



%%%%%%% Inicio Bloque Percepcion %%%%%%%
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
    Screen('FillRect', ptb.w.pointer, ptb.backgroundColor);
    Screen('DrawTexture', ptb.w.pointer, stim.FixDisplay,[],[],[],0);
    Screen('Flip',ptb.w.pointer);
    WaitSecs(design.FixationDuration);
    
    %.....Show sample images
    Screen('DrawTexture', ptb.w.pointer, stim.ImgDisplay{currTrial},[],[],[],0)
    Screen('Flip',ptb.w.pointer);
    [log.responses_subj] = Left_or_Right_ToContinue_ShapesColor(currTrial, log.responses_subj, Correct_Response, ptb);
 end

%.....Compute results and show them
stim.Results_text = {['Perception test results:',...
    newline,...
    newline,...
    newline,...
    'Reaction time: ' , num2str(mean([log.responses_subj{2:end,4}])),...
    newline,...
    newline,...
    newline,...
    'Hits: ' , num2str(sum([log.responses_subj{2:end,5}])),'/10',...
    newline]};

%.....Show final results...
stim.Perception_Results = DrawFormattedText(ptb.w.pointer,stim.Results_text{1,1}, 'center','center',ptb.fontColor);
%Screen('TextSize', ptb.w.pointer, 30*(design.DistanceToStim/0.3));
Screen('Flip',ptb.w.pointer, stim.Perception_Results)
WaitSecs(1)
SpaceToContinue(ptb.w.pointer)

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
                    responses_subj{trl+1,5} = 0; % wrong
                elseif Correct_Response == 0
                    responses_subj{trl+1,5} = 1; % correct
                end
                break
            elseif keyCode(KbName('RightArrow'))== 1
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
end % Function
