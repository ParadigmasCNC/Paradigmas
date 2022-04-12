function [stim] = generate_Textures_WM2(stim,ptb,dirs,design)
% This functions generates the WM binding textures before drawing them.
% Inputs: stim, ptb, dirs
% Output: stim
% Orig: INECO; Mod: PRG 11/2019.

% Generate fixation cross
stim.FixationCross_Img = imread([dirs.Path_Perception_Stimuli '/' stim.FixationCross]);
stim.FixationCross_Img = imresize(stim.FixationCross_Img,[round(stim.Screen_Width_Intervals*3),round(stim.Screen_Height_Intervals*3)]);
stim.FixDisplay        = Screen('MakeTexture', ptb.w.pointer, stim.FixationCross_Img);

if strcmp(design.session, 'ShapeOnly')
    % Generate stimuli
    for tmpTrial = 1:design.Trials
        disp(tmpTrial)
        % Create n DISPLAY textures
        tmpImage_Dummy  = stim.Image_Dummy1;
        for tmpImg = 1:9
            AssignedCell    = stim.Stimuli_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Database{tmpImg+1,1};          % this is 1
            tmpHeightCell   = ceil(stim.Stimuli_Database{tmpImg+1,2});    % this is 2
            if ~isequal(AssignedCell,'img000.bmp') 
                WithResize   = round(stim.Screen_Width_Intervals*2);
                HeightResize = round(stim.Screen_Height_Intervals*2);
                tmpImg2      = imread([dirs.Path_ShapeOnly_Stimuli, '/', stim.Stimuli_Database{tmpImg+1,tmpTrial+2}]);
                tmpImg2      = imresize(tmpImg2,[HeightResize, WithResize]);
                tmpImage_Dummy(tmpHeightCell : tmpHeightCell + HeightResize - 1, tmpWidthCell: tmpWidthCell + WithResize - 1,:) = tmpImg2(:,:,:);
            end
        end
        stim.ImgDisplay{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy);
        
        % Create n TEST textures
        tmpImage_Dummy2 = stim.Image_Dummy1;
        for tmpImg = 10:18
            AssignedCell    = stim.Stimuli_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Database{tmpImg+1,1}; % this is 1
            tmpHeightCell   = ceil(stim.Stimuli_Database{tmpImg+1,2}); % this is 2
            if ~isequal(AssignedCell,'img000.bmp') 
                WithResize   = round(stim.Screen_Width_Intervals*2);
                HeightResize = round(stim.Screen_Height_Intervals*2);
                tmpImg2      = imread([dirs.Path_ShapeOnly_Stimuli, '/', char(stim.Stimuli_Database{tmpImg+1,tmpTrial+2})]);
                tmpImg2      = imresize(tmpImg2,[HeightResize, WithResize]);
                tmpImage_Dummy2(tmpHeightCell : tmpHeightCell + HeightResize - 1, tmpWidthCell: tmpWidthCell + WithResize - 1, :) = tmpImg2(:,:,:);
            end
        end
        stim.ImgTest{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy2);
    end
elseif strcmp(design.session, 'ShapeColor')
        % Generate stimuli
    for tmpTrial = 1:design.Trials
        % Create n DISPLAY textures
        tmpImage_Dummy  = stim.Image_Dummy1;
        for tmpImg = 1:9
            AssignedCell    = stim.Stimuli_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Database{tmpImg+1,1};          % this is 1
            tmpHeightCell   = ceil(stim.Stimuli_Database{tmpImg+1,2});    % this is 2
            if ~isequal(AssignedCell,'img000.bmp') 
                WithResize   = round(stim.Screen_Width_Intervals*2);
                HeightResize = round(stim.Screen_Height_Intervals*2);
                tmpImg2      = imread([dirs.Path_ShapeColor_Stimuli, '/', stim.Stimuli_Database{tmpImg+1,tmpTrial+2}]);
                tmpImg2      = imresize(tmpImg2,[HeightResize, WithResize]);
                tmpImage_Dummy(tmpHeightCell : tmpHeightCell + HeightResize - 1, tmpWidthCell: tmpWidthCell + WithResize - 1,:) = tmpImg2(:,:,:);
            end
        end
        stim.ImgDisplay{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy);
        
        % Create n TEST textures
        tmpImage_Dummy2 = stim.Image_Dummy1;
        for tmpImg = 10:18
            AssignedCell    = stim.Stimuli_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Database{tmpImg+1,1}; % this is 1
            tmpHeightCell   = ceil(stim.Stimuli_Database{tmpImg+1,2}); % this is 2
            if ~isequal(AssignedCell,'img000.bmp') 
                WithResize   = round(stim.Screen_Width_Intervals*2);
                HeightResize = round(stim.Screen_Height_Intervals*2);
                tmpImg2      = imread([dirs.Path_ShapeColor_Stimuli, '/', char(stim.Stimuli_Database{tmpImg+1,tmpTrial+2})]);
                tmpImg2      = imresize(tmpImg2,[HeightResize, WithResize]);
                tmpImage_Dummy2(tmpHeightCell : tmpHeightCell + HeightResize - 1,tmpWidthCell: tmpWidthCell + WithResize - 1, :) = tmpImg2(:,:,:);
            end
        end
        stim.ImgTest{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy2);
    end
else
    for tmpTrial = 1:design.Trials % To-do: perception is now only 10 trials long.
        % Create n DISPLAY textures
        tmpImage_Dummy  = stim.Image_Dummy1;
        for tmpImg = 1:length(stim.Stimuli_Database(:,1))-1
            AssignedCell    = stim.Stimuli_Database{tmpImg+1,tmpTrial+2}; % + 1 and + 2 because of the names.
            tmpWidthCell    = stim.Stimuli_Database{tmpImg+1,1}; % this is 1
            tmpHeightCell   = stim.Stimuli_Database{tmpImg+1,2}; % this is 2
            if ~isequal(AssignedCell,'img000.bmp') 
                WidthResize  = length(tmpWidthCell:tmpWidthCell + stim.Screen_Width_Intervals*2);
                HeightResize = length(tmpHeightCell:tmpHeightCell + stim.Screen_Height_Intervals*2);
                tmpImg2 = imread([dirs.Path_Perception_Stimuli '/', char(stim.Stimuli_Database(tmpImg+1,tmpTrial+2))]);
                tmpImg2 = imresize(tmpImg2,[HeightResize,WidthResize]);
                tmpImage_Dummy(tmpHeightCell:tmpHeightCell + stim.Screen_Height_Intervals*2,tmpWidthCell: tmpWidthCell + stim.Screen_Width_Intervals*2, :) = tmpImg2(:,:,:);
            end
        end
        
        BarResizeW = length(stim.width_Bar{1,1}:stim.width_Bar{1,2});
        BarResizeH = length(stim.height_Bar{1,1}:stim.height_Bar{1,2});
        Barra      = imread([dirs.Path_Black_Bar, 'black_line/Barra.PNG']);
        Barra      = imresize(Barra,[BarResizeH,BarResizeW]);
        tmpImage_Dummy(stim.height_Bar{1,1}:stim.height_Bar{1,2},stim.width_Bar{1,1}:stim.width_Bar{1,2},:) = Barra(:,:,:);
        stim.ImgDisplay{tmpTrial} = Screen('MakeTexture', ptb.w.pointer, tmpImage_Dummy);
    end % for n trials
end % if do.experiment or do.perception
end % generate_Textures_WM function end

