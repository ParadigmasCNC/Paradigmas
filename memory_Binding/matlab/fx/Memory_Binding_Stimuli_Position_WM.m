function [stim, dirs] = Memory_Binding_Stimuli_Position2_WM(stim, design, ptb, dirs)
% Creates a matrix for stimulus presentation.
% The matrix has all trials, positions, and images names.
% Inputs: stim, design, ptb, dirs
% Outputs: stim, dirs
% Orig: INECO; Mod: PRG 11/2019


%%%%%%%%%%%%%%% INICIO CREACION TABLA PERCEPCION %%%%%%%%%%%%%%%
% Defino Tabla Percepcion como cell y agrego headers de Width y Height
stim.Stimuli_Database      = {};
stim.Stimuli_Database{1,1} = 'Position_Width';
stim.Stimuli_Database{1,2} = 'Position_Height';


% Defino cantidad de Trials Para las tareas
for a = 1:design.Trials
    stim.Stimuli_Database{1,a + 2} = ['Trial_', num2str(a)];
end


% Get amount of pixels equal to centimeter (get inches and divide by amount
% of cm in inch - As stimuli image has blank space, when we resize to 1cm with the 2.54cm to inch conversion,
% the stimuli appears smaller than 1cm, for which we reduced the conversion
% to 1.8cm per inch.
ScreenPixelsPerCm = round(java.awt.Toolkit.getDefaultToolkit().getScreenResolution()/1.9);

% Width
stim.Screen_Width_Size = ptb.w.W;
stim.Screen_Width_Intervals  = round(ScreenPixelsPerCm/2);

% Height
stim.Screen_Height_Size      = ptb.w.H;
stim.Screen_Height_Intervals = round(ScreenPixelsPerCm/2);


%% If perception
if strcmp(design.session, 'Perception')
    
    % Amount of half intervals to position grid form the center of the screen
    startAndEndsUpDown = [-10,-7,-4,2,5,8];
    startAndEndsLeftRight = [-1,-4,2];

    % Define counter for positioning values in matrix
    counter = 2;
    
    % Iter through columns defining positions to stick images in
    for sidesIter = 1:length(startAndEndsLeftRight)
        for downIter = 1:length(startAndEndsUpDown)
            stim.Stimuli_Database{counter,1} = (ptb.w.W/2)+ stim.Screen_Height_Intervals*startAndEndsLeftRight(sidesIter);
            stim.Stimuli_Database{counter,2} = (ptb.w.H/2)+ stim.Screen_Width_Intervals*startAndEndsUpDown(downIter);
            counter = counter+1;
        end
    end
    
    % Re-organize positions for e-prime matrix compatibility
    % Define dummy and values to move around
    dummy =  stim.Stimuli_Database;
    dummyVals = [8,2,14];
    
    % Iter throught columns and append values from dummy into real one
    for colIter = 1:2
        dummyCounter = 1;
        for colIter2 = 2:3:8
            stim.Stimuli_Database(colIter2:colIter2+2,colIter) = dummy(dummyVals(dummyCounter):dummyVals(dummyCounter)+2,colIter);
            dummyCounter = dummyCounter + 1;
        end
        stim.Stimuli_Database(14:16,colIter) = dummy(5:7,colIter);
    end
    
    % clear vars
    clear dummy dummyVals dummyCounter counter sidesIter downIter colIter colIter2
    
    % Define middle screen bar
    stim.width_Bar{1,1}  = min([stim.Stimuli_Database{2:end,1}])-ScreenPixelsPerCm;
    stim.width_Bar{1,2}  = max([stim.Stimuli_Database{2:end,1}])+ScreenPixelsPerCm*2;
    stim.height_Bar{1,1} = stim.Screen_Height_Size/2 - 2;
    stim.height_Bar{1,2} = stim.Screen_Height_Size/2 + 2;
    
    %%%%%%%%%%%%%%% PERCEPTION TABLE END %%%%%%%%%%%%%%%
else
    %%%%%%%%%%%%%%% SHAPEONLY/SHAPECOLOR START %%%%%%%%%%%%%%%
    % Starts for Perception
    startAndEndsUpDown = [-5,-1,4];
    startAndEndsLeftRight = [-5,-1,3];
    
    % Define counter for positioning values in matrix
    counter = 2;
    
    % Iter through columns defining positions to stick images in
    for sidesIter = 1:length(startAndEndsLeftRight)
        for downIter = 1:length(startAndEndsUpDown)
            stim.Stimuli_Database{counter,1} = (ptb.w.W/2) + (stim.Screen_Height_Intervals*startAndEndsLeftRight(sidesIter));
            stim.Stimuli_Database{counter,2} = (ptb.w.H/2) + (stim.Screen_Width_Intervals*startAndEndsUpDown(downIter));
            counter = counter+1;
        end
    end
    stim.Stimuli_Database = [stim.Stimuli_Database;stim.Stimuli_Database(2:end,:)];
    % clear vars
    clear counter sidesIter downIter
    
    %%%%%%%%%%%%%%% SHAPEONLY/SHAPECOLOR END %%%%%%%%%%%%%%%
end
%% Ordeno los estimulos, y los agrego a las Tablas
[stim] = Stimuli_Order_WM(stim, dirs, design);

if strcmp(design.session, 'Perception')
    % Same for the Perception database, but first delete the rest.
    stim.Stimuli_Database(:,13:end) = [];
    stim.Stimuli_Database(2:end,3:end) = stim.Perception_Stimuli;
elseif strcmp(design.session, 'ShapeOnly')
    % Add image names to the matrices.
    stim.Stimuli_Database(2:end,3:end) = stim.ShapesOnly;
else
    stim.Stimuli_Database(2:end,3:end) = stim.ShapesColor;
end


end  

