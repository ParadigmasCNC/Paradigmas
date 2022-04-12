function [stim] = generate_Textures_WM(stim,ptb,dirs,design,do)
% This functions generates the WM binding textures before drawing them.
% Inputs: stim, ptb, dirs
% Output: stim
% Orig: INECO; Mod: PRG 11/2019.

% Generate fixation cross
stim.FixationCross_Img = imread([dirs.Path_Perception_Stimuli '/' stim.FixationCross]);
%stim.FixationCross_Img = imresize(stim.FixationCross_Img,[30*design.DistanceToStim*ptb.w.W/640,30*design.DistanceToStim*ptb.w.H/480]);
stim.FixationCross_Img = imresize(stim.FixationCross_Img,[ptb.w.W/640,ptb.w.H/480]);
stim.FixDisplay        = Screen('MakeTexture', ptb.w.pointer, stim.FixationCross_Img);

if do.Experiment == 1
    % Generate stimuli
    for tmpTrial = 1:design.nTrials
        % Create n DISPLAY textures
        tmpImage_Dummy  = stim.Image_Dummy1;
        for tmpImg = 1:9 % PRG (length(Stimuli_Task_ShapeColor_Database(:,1))-1)/2 This corresponds to 9.
            AssignedCell    = stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,1};          % this is 1
            tmpHeightCell   = ceil(stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,2});    % this is 2
            if isequal(AssignedCell,'img000.bmp') ~= 1
                WithResize   = length(tmpWidthCell - stim.Screen_Width_Size + stim.Screen_Width_Intervals : tmpWidthCell + stim.Screen_Width_Intervals);
                HeightResize = length(tmpHeightCell + stim.Screen_Height_Intervals - stim.Screen_Height_Size : tmpHeightCell + stim.Screen_Height_Intervals);
                tmpImg2      = imread([dirs.Path_Perception_Stimuli, '/', stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,tmpTrial+2}]);
                tmpImg2      = imresize(tmpImg2,[WithResize, HeightResize]);
                tmpImage_Dummy(tmpWidthCell - stim.Screen_Width_Size + stim.Screen_Width_Intervals : tmpWidthCell + stim.Screen_Width_Intervals , tmpHeightCell + stim.Screen_Height_Intervals - stim.Screen_Height_Size : tmpHeightCell + stim.Screen_Height_Intervals,:) = tmpImg2(:,:,:);
            end
        end
        stim.ImgDisplay{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy);
        
        % Create n TEST textures
        tmpImage_Dummy2 = stim.Image_Dummy1;
        for tmpImg = 10:18 % PRG (length(Stimuli_Task_ShapeColor_Database(:,1))-1)/2 This corresponds to 9.
            AssignedCell    = stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,1}; % this is 1
            tmpHeightCell   = ceil(stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,2}); % this is 2
            if isequal(AssignedCell,'img000.bmp') ~= 1
                WithResize   = length(tmpWidthCell - stim.Screen_Width_Size + stim.Screen_Width_Intervals : tmpWidthCell + stim.Screen_Width_Intervals);
                HeightResize = length(tmpHeightCell + stim.Screen_Height_Intervals - stim.Screen_Height_Size : tmpHeightCell + stim.Screen_Height_Intervals);
                tmpImg2      = imread([dirs.Path_Perception_Stimuli, '/', char(stim.Stimuli_Task_ShapeColor_Database{tmpImg+1,tmpTrial+2})]);
                tmpImg2      = imresize(tmpImg2,[WithResize, HeightResize]);
                tmpImage_Dummy2(tmpWidthCell - stim.Screen_Width_Size + stim.Screen_Width_Intervals : tmpWidthCell + stim.Screen_Width_Intervals , tmpHeightCell + stim.Screen_Height_Intervals - stim.Screen_Height_Size : tmpHeightCell + stim.Screen_Height_Intervals,:) = tmpImg2(:,:,:);
            end
        end
        stim.ImgTest{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy2);
    end
    
elseif do.Perception == 1
    for tmpTrial = 1:10 % To-do: perception is now only 10 trials long.
        % Create n DISPLAY textures
        tmpImage_Dummy  = stim.Image_Dummy1;
        for tmpImg = 1:length(stim.Stimuli_Perception_Database(:,1))-1
            AssignedCell    = stim.Stimuli_Perception_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Perception_Database{tmpImg+1,1}; % this is 1
            tmpHeightCell   = ceil(stim.Stimuli_Perception_Database{tmpImg+1,2}); % this is 2
            if isequal(AssignedCell,'img000.bmp') ~= 1
                WithResize   = length(tmpWidthCell : tmpWidthCell + stim.Screen_Width_Size);
                HeightResize = length(tmpHeightCell:tmpHeightCell + stim.Screen_Height_Size);
                disp(WithResize);
                disp(HeightResize);
                tmpImg2 = imread([dirs.Path_Perception_Stimuli '/', char(stim.Stimuli_Perception_Database(tmpImg+1,tmpTrial+2))]);
                tmpImg2 = imresize(tmpImg2,[WithResize, HeightResize]);
                tmpImage_Dummy(tmpWidthCell: tmpWidthCell + stim.Screen_Width_Size, tmpHeightCell:tmpHeightCell + stim.Screen_Height_Size,:) = tmpImg2(:,:,:);
            end
        end
        
        BarResizeW = length(stim.Midpoint_Bar_Place:stim.Midpoint_Bar_Place+1);
        BarResizeH = length(min([stim.Stimuli_Perception_Database{2:end,2}])-100: max([stim.Stimuli_Perception_Database{2:end,2}])+stim.Screen_Height_Size+100);
        Barra      = imread([dirs.Path_Black_Bar, 'black_line/Barra.PNG']);
        Barra      = imresize(Barra,[BarResizeW,BarResizeH]);
        tmpImage_Dummy(stim.Midpoint_Bar_Place : stim.Midpoint_Bar_Place + 1 , min(stim.Min_Bar(:,2))-100 : max(stim.Min_Bar(:,2))+stim.Screen_Height_Size+100 ,:) = Barra(:,:,:);
        stim.ImgDisplay{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy);
    end % for n trials
end % if do.experiment or do.perception
end % generate_Textures_WM function end

