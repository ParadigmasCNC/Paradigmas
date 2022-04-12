% Consigna 1 de la tarea
Memory_TaskShapesOnlyOnly_Procedure = DrawFormattedText(window1,Textos_Tarea{1,1}, 'center','center');
Screen('TextSize',window1 , (ceil(Pix_SS(1,3)/50)))
Screen('Flip',window1, Memory_TaskShapesOnlyOnly_Procedure)
pause(1)
SpaceToContinue(window1)

% Muestro como van a ser los trials (explico el exp)
ImgTrial_Exp = imread([Path_ShapeOnly_Stimuli '/' Task_Trial_Explanation]);
imageDisplay = Screen('MakeTexture', window1, ImgTrial_Exp);
Screen('FillRect', window1,backgroundColor)
Screen('DrawTexture', window1, imageDisplay, [], [],[],0)
Screen('Flip',window1)
pause(1)
SpaceToContinue(window1)

% Consigna 2 de  la     tarea
Memory_TaskShapesOnly_Procedure_deux = DrawFormattedText(window1,Textos_Tarea{1,2}, 'center','center');
Screen('TextSize',window1 , (ceil(Pix_SS(1,3)/50)))
Screen('Flip',window1, Memory_TaskShapesOnly_Procedure_deux)
pause(1)
SpaceToContinue(window1)

%%%%%%% Inicio Bloque ShapesOnly %%%%%%%
for TaskShapesOnlyIterations = 1:length(Stimuli_Task_ShapeOnly_Database(1,3:end))
    disp(TaskShapesOnlyIterations)
    if AmountOfStimuli == '2'
        if length(unique(Stimuli_Task_ShapeOnly_Database(:,TaskShapesOnlyIterations+2))) == 4
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    elseif AmountOfStimuli == '3'
        if length(unique(Stimuli_Task_ShapeOnly_Database(:,TaskShapesOnlyIterations+2))) == 5
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    elseif AmountOfStimuli == '4'
        if length(unique(Stimuli_Task_ShapeOnly_Database(:,TaskShapesOnlyIterations+2))) == 6
            Correct_Response = 1;
        else
            Correct_Response = 0;
        end
    end
    Image_Dummy = Image_Dummy1;
    % Cruz de fijacion
    % Pantalla 1 segundo blanco
    Screen('Flip',window1)
    pause(1)
    
    fixationDuration = 0.5;
    FixationCross_Img = imread([Path_Perception_Stimuli '/' FixationCross]);
    FixationCross_Img = imresize(FixationCross_Img,[30,30]);
    FixDisplay = Screen('MakeTexture', window1, FixationCross_Img);
    Screen('FillRect', window1, backgroundColor)
    Screen('DrawTexture', window1, FixDisplay,[],[],[],0)
    Screen('Flip',window1,Screen('Flip',window1) + fixationDuration - Slack - ifi,0)
    Screen('Flip',window1)
    pause(0.250)
    
    for Imagen_Reproducir = 1:(length(Stimuli_Task_ShapeOnly_Database(:,1))-1)/2
        AssignedCell = Stimuli_Task_ShapeOnly_Database(Imagen_Reproducir+1,TaskShapesOnlyIterations+2);
        WidthCell = Stimuli_Task_ShapeOnly_Database{Imagen_Reproducir+1,TaskShapesOnlyIterations-(TaskShapesOnlyIterations-1)};
        HeightCell = ceil(Stimuli_Task_ShapeOnly_Database{Imagen_Reproducir+1,TaskShapesOnlyIterations+1 -(TaskShapesOnlyIterations-1)});
        if isequal(char(AssignedCell),'img000.bmp') ~= 1
            Img = imread([Path_ShapeOnly_Stimuli '/', char(Stimuli_Task_ShapeOnly_Database(Imagen_Reproducir+1,TaskShapesOnlyIterations+2))]);
            Img = imresize(Img,[Screen_Width_Size, Screen_Height_Size]);
            Image_Dummy(WidthCell - Screen_Width_Size + Screen_Width_Intervals  :WidthCell + Screen_Width_Intervals -1, HeightCell + Screen_Height_Intervals - Screen_Height_Size:HeightCell + Screen_Height_Intervals -1,:) = Img(:,:,:);
        end
    end
    ImgDisplay = Screen('MakeTexture', window1, Image_Dummy);
    %     Screen('FillRect', window1,backgroundColor)
    Screen('DrawTexture', window1, ImgDisplay,[],[],[],0)
    %     Screen('Flip',window1,Screen('Flip',window1) + 10 - Slack,0)
    Screen('Flip',window1)
    pause(2)
    
    % Segunda presentacion
    Image_Dummy = Image_Dummy1;
    for Imagen_Reproducir = 10:length(Stimuli_Task_ShapeOnly_Database(:,1))-1
        AssignedCell = Stimuli_Task_ShapeOnly_Database(Imagen_Reproducir+1,TaskShapesOnlyIterations+2);
        WidthCell = Stimuli_Task_ShapeOnly_Database{Imagen_Reproducir+1,TaskShapesOnlyIterations-(TaskShapesOnlyIterations-1)};
        HeightCell = ceil(Stimuli_Task_ShapeOnly_Database{Imagen_Reproducir+1,TaskShapesOnlyIterations+1 -(TaskShapesOnlyIterations-1)});
        if isequal(char(AssignedCell),'img000.bmp') ~= 1
            Img = imread([Path_ShapeOnly_Stimuli '/', char(Stimuli_Task_ShapeOnly_Database(Imagen_Reproducir+1,TaskShapesOnlyIterations+2))]);
            Img = imresize(Img,[Screen_Width_Size, Screen_Height_Size]);
            Image_Dummy(WidthCell + Screen_Width_Intervals - Screen_Width_Size :WidthCell + Screen_Width_Intervals-1 , HeightCell+ Screen_Height_Intervals -  Screen_Height_Size:HeightCell + Screen_Height_Intervals-1,:) = Img(:,:,:);
        end
    end
    ImgDisplay = Screen('MakeTexture', window1, Image_Dummy);
    %     Screen('FillRect', window1,backgroundColor)
    Screen('DrawTexture', window1, ImgDisplay,[],[],[],0)
    %     Screen('Flip',window1,Screen('Flip',window1) + 10 - Slack,0)
    Screen('Flip',window1)
    [Answers_Task_ShapeOnly] = Left_or_Right_ToContinue_ShapesOnly(window1,TaskShapesOnlyIterations, Answers_Task_ShapeOnly, Correct_Response, Slack,ifi);
end
%%%%%%% Final Bloque ShapesOnly %%%%%%%

% Estructura con field de respuestas percepcion
Subject_Answers.TaskShapeOnly = Answers_Task_ShapeOnly;

function SpaceToContinue(window1)
    while 1
    [keyIsDown,secs,keyCode] = KbCheck;
        if keyCode(KbName('space')) == 1
            break
        elseif keyCode(KbName('ESCAPE')) == 1
        Screen(window1,'Close')
        break
        end
    end
end
function [Answers_Task_ShapeOnly] = Left_or_Right_ToContinue_ShapesOnly(window1,PerceptionIterations, Answers_Task_ShapeOnly, Correct_Response, Slack, ifi)
    onsetTime = GetSecs - Slack - ifi;
    while 1
    [keyIsDown,secs,keyCode] = KbCheck;
        if keyCode(KbName('LeftArrow')) == 1
        Answers_Task_ShapeOnly{PerceptionIterations+1,2} = 1;
        Answers_Task_ShapeOnly{PerceptionIterations+1,3} = 0;
        Answers_Task_ShapeOnly{PerceptionIterations+1,4} = secs- onsetTime; 
        if Correct_Response == 1
        Answers_Task_ShapeOnly{PerceptionIterations+1,5} = 0;
        elseif Correct_Response == 0 
        Answers_Task_ShapeOnly{PerceptionIterations+1,5} = 1;
        end
            break
        elseif keyCode(KbName('RightArrow'))== 1
        Answers_Task_ShapeOnly{PerceptionIterations+1,2} = 0;
        Answers_Task_ShapeOnly{PerceptionIterations+1,3} = 1;
        Answers_Task_ShapeOnly{PerceptionIterations+1,4} = secs- onsetTime;
        if Correct_Response == 1
        Answers_Task_ShapeOnly{PerceptionIterations+1,5} = 1;
        elseif Correct_Response == 0 
        Answers_Task_ShapeOnly{PerceptionIterations+1,5} = 0;
        end
            break
        elseif keyCode(KbName('ESCAPE')) == 1
        Screen(window1,'Close')
        break
        end
    end
end
