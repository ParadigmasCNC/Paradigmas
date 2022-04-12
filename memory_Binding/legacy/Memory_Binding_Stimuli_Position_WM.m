function [stim, dirs] = Memory_Binding_Stimuli_Position_WM(stim, design, ptb, dirs)
% Creates a matrix for stimulus presentation.
% The matrix has all trials, positions, and images names.
% Inputs: stim, design, ptb, dirs
% Outputs: stim, dirs
% Orig: INECO; Mod: PRG 11/2019


%%%%%%%%%%%%%%% INICIO CREACION TABLA PERCEPCION %%%%%%%%%%%%%%%
% Defino Tabla Percepcion como cell y agrego headers de Width y Height
stim.Stimuli_Perception_Database      = {};
stim.Stimuli_Task_ShapeOnly_Database  = {};
stim.Stimuli_Perception_Database{1,1} = 'Position_Width';
stim.Stimuli_Perception_Database{1,2} = 'Position_Height';
stim.Stimuli_Task_ShapeOnly_Database{1,1} = 'Position_Width';
stim.Stimuli_Task_ShapeOnly_Database{1,2} = 'Position_Height';

% Defino cantidad de Trials Para las tareas
for a = 1:design.nShapeOnlyTrials
    stim.Stimuli_Perception_Database{1,a + 2}     = ['Trial_', num2str(a)];
    stim.Stimuli_Task_ShapeOnly_Database{1,a + 2} = ['Trial_', num2str(a)];
end

% Tamanio de imagenes e intervalos entre fin e inicio de imagen
% Width

% ceil(length(floor(ptb.w.W/4):floor((ptb.w.W/4)*3))) % 8 is double the max amount of stim
% ceil(length(floor(ptb.w.H/6):floor((ptb.w.H/6)*5))/2) % 8 is double the max amount of stim
% 
% upperPartH = floor(ptb.w.H/12):(floor(ptb.w.H/2)-floor(ptb.w.H/12));
% lowerPartH = floor(ptb.w.H/2)+floor(ptb.w.H/12)):floor(ptb.w.H-floor(ptb.w.H/12);



% stim.Screen_Width_Size       = 2*(design.DistanceToStim * tan(atan(13/0.3)));
stim.Screen_Width_Size       = 2*(tan(atan(13/0.3)));
%stim.Screen_Width_Size       = stim.Screen_Width_Size*ptb.w.W/640;
% stim.Screen_Width_Intervals  = (640*2/100)*design.DistanceToStim;
stim.Screen_Width_Intervals  = ceil(ptb.w.W/40);
%stim.Screen_Width_Intervals  = stim.Screen_Width_Intervals*ptb.w.W/640;

% Height
%stim.Screen_Height_Size      = 2*(design.DistanceToStim * tan(atan(12/0.3)));
stim.Screen_Height_Size      = 2*(tan(atan(12/0.3)));
%stim.Screen_Height_Size      = stim.Screen_Height_Size*ptb.w.H/480;
%stim.Screen_Height_Intervals = (480*2/100)*design.DistanceToStim;
stim.Screen_Height_Intervals = (ptb.w.H/120);
%stim.Screen_Height_Intervals = stim.Screen_Height_Intervals*ptb.w.H/480; 

% Define Distancias para posicionar las imagenes segun porcentajes de
% pantalla de E-Prime para tarea de percepcion
% stim.Screen_Width_Start     = ceil(ptb.w.H/2) - stim.Screen_Height_Size  - (stim.Screen_Height_Size/2) - stim.Screen_Height_Intervals;%*design.DistanceToStim*(1/(ptb.w.W/640));% - ((stim.Screen_Height_Size - 24) + ((480*2/100)*design.DistanceToStim - ptb.w.H*2/100)*design.DistanceToStim) ; %(stim.Screen_Height_Size - (26*ptb.w.H/480))/2 - stim.Screen_Height_Intervals); %ceil(ptb.w.H*44/100) - stim.Screen_Width_Intervals  * 2; % Rest half stimuli width for it to always be centered
% stim.Screen_Height_Start    = ceil(ptb.w.W/2) - 3*stim.Screen_Width_Size - stim.Screen_Width_Intervals;%ceil(ptb.w.W*(design.DistanceToStim*30/0.3)/100);%*design.DistanceToStim*(1/(ptb.w.H/480));%ptb.w.W/1920 + (ceil(ptb.w.W*30/100)*ptb.w.W/1920 - ceil(ptb.w.W*30/100)*ptb.w.W/1920 * (2*(design.DistanceToStim * tan(atan(288)))/576) - 1); % + (stim.Screen_Width_Size - (24*ptb.w.W/640))/2  + stim.Screen_Width_Intervals);  %ceil(ptb.w.W*45/100) - stim.Screen_Height_Intervals * 2; % Rest half stimuli height for it to always be centered

stim.Screen_Width_Start     = floor(ptb.w.W/4.2);
stim.Screen_Height_Start    = floor(ptb.w.H/2.3);

if strcmp(design.session, 'Perception')

    % Black bar
    stim.Midpoint_Width      = ceil(ptb.w.W*11/100);%*design.DistanceToStim*ptb.w.W/640;
    stim.Midpoint_Bar_Place  = ceil(ptb.w.W*50/100);

    % Mitad de los dos cuadrados en tarea de percepcion
    mitad = 0;

    % Defino Posiciones de percepcion en la pantalla y los agrego a la tabla de
    % posiciones y estimulos para percepcion
    for a = 1:2
        widthCounter = 0;
        if a == 2
            mitad = 1;
        end
        for b = 1:9
            widthCounter = widthCounter + 1;
            if mitad ~= 1
                if b == 1
                    stim.Stimuli_Perception_Database{b+1,1} = stim.Screen_Height_Start;
                    stim.Stimuli_Perception_Database{b+1,2} = stim.Screen_Width_Start;
                else
                    if widthCounter ~= 4
                        stim.Stimuli_Perception_Database{b+1,2} = stim.Stimuli_Perception_Database{b,2} + stim.Screen_Height_Size + stim.Screen_Height_Intervals;
                        stim.Stimuli_Perception_Database{b+1,1} = stim.Stimuli_Perception_Database{b,1};
                    else
                        stim.Stimuli_Perception_Database{b+1,2} = stim.Stimuli_Perception_Database{2,2};
                        stim.Stimuli_Perception_Database{b+1,1} = stim.Stimuli_Perception_Database{b,1} + stim.Screen_Width_Size + stim.Screen_Width_Intervals;
                        widthCounter = 1;
                    end
                end
            else
                if b == 1
                    stim.Stimuli_Perception_Database{b+10,1} = stim.Midpoint_Bar_Place + (stim.Screen_Height_Intervals*3.5);
                    stim.Stimuli_Perception_Database{b+10,2} = stim.Stimuli_Perception_Database{2,2};
                else
                    if widthCounter ~= 4
                        stim.Stimuli_Perception_Database{b+10,2} = stim.Stimuli_Perception_Database{b+9,2} + stim.Screen_Height_Size + stim.Screen_Height_Intervals;
                        stim.Stimuli_Perception_Database{b+10,1} = stim.Stimuli_Perception_Database{b+9,1};
                    else
                        stim.Stimuli_Perception_Database{b+10,2} = stim.Stimuli_Perception_Database{2,2};
                        stim.Stimuli_Perception_Database{b+10,1} = stim.Stimuli_Perception_Database{b+9,1} + stim.Screen_Width_Size + stim.Screen_Width_Intervals;
                        widthCounter = 1;
                    end
                end
            end
        end
    end

    % Posicion de barra de donde a donde (despues se modifica a gusto para el largo deseado
       stim.Min_Bar = 1;
    for width_max_min = 2:length(stim.Stimuli_Perception_Database(:,1))
        stim.Min_Bar(width_max_min-1,2) = stim.Stimuli_Perception_Database{width_max_min,2};
        stim.Min_Bar(width_max_min-1,1) = stim.Stimuli_Perception_Database{width_max_min,1};
    end

    %%%%%%%%%%%%%%% FIN CREACION TABLA PERCEPCION %%%%%%%%%%%%%%%
else
    %%%%%%%%%%%%%%% INICIO CREACION TABLAS TAREAS %%%%%%%%%%%%%%%
    % Defino Tabla como cell y agrego headers de Width y Height
    stim.Stimuli_Task_ShapeOnly_Database{1,1} = 'Position_Width';
    stim.Stimuli_Task_ShapeOnly_Database{1,2} = 'Position_Height';

    % Define Distancias para posicionar las imagenes segun porcentajes de
    % pantalla de E-Prime para las tareas
    stim.Screen_Task_Width_Start = ceil(ptb.w.H/2) - (stim.Screen_Height_Size/2) - stim.Screen_Height_Intervals;   % - ((stim.Screen_Height_Size - 24) + ((480*2/100)*design.DistanceToStim - ptb.w.H*2/100)*design.DistanceToStim); %ceil(ptb.w.H*44/100) - stim.Screen_Width_Intervals  * 2; % Rest half stimuli width for it to always be centered
    stim.Screen_Height_Start     = ceil(ptb.w.W/2) - (stim.Screen_Width_Size/2)  - stim.Screen_Width_Intervals;  % - ((stim.Screen_Width_Size - 26)  + ((640*2/100)*design.DistanceToStim - ptb.w.W*2/100)*design.DistanceToStim); % Rest half stimuli height for it to always be centered

    % Defino Posiciones de estimulos en la pantalla y los agrego a la tabla de
    % posiciones y estimulos para las tareas
    widthCounter = 0;
    for b = 1:9
        widthCounter = widthCounter + 1;
        if b == 1
            stim.Stimuli_Task_ShapeOnly_Database{b+1,1} = stim.Screen_Height_Start;
            stim.Stimuli_Task_ShapeOnly_Database{b+1,2} = stim.Screen_Task_Width_Start;
        else
            if widthCounter ~= 4
                stim.Stimuli_Task_ShapeOnly_Database{b+1,2} = stim.Stimuli_Task_ShapeOnly_Database{b,2} + stim.Screen_Height_Size + stim.Screen_Height_Intervals;
                stim.Stimuli_Task_ShapeOnly_Database{b+1,1} = stim.Stimuli_Task_ShapeOnly_Database{b,1};
            else
                stim.Stimuli_Task_ShapeOnly_Database{b+1,2} = stim.Stimuli_Task_ShapeOnly_Database{2,2};
                stim.Stimuli_Task_ShapeOnly_Database{b+1,1} = stim.Stimuli_Task_ShapeOnly_Database{b,1} + stim.Screen_Width_Size + stim.Screen_Width_Intervals;
                widthCounter = 1;
            end
        end
    end
    stim.Stimuli_Task_ShapeOnly_Database(11:19,2) = stim.Stimuli_Task_ShapeOnly_Database(2:10,2);
    stim.Stimuli_Task_ShapeOnly_Database(11:19,1) = stim.Stimuli_Task_ShapeOnly_Database(2:10,1);


    % Its the same for Task Shape only as Shape Color
    stim.Stimuli_Task_ShapeColor_Database = stim.Stimuli_Task_ShapeOnly_Database;
    %%%%%%%%%%%%%%% FIN CREACION TABLAS TAREAS %%%%%%%%%%%%%%%
end
%% Ordeno los estimulos, y los agrego a las Tablas
 [stim] = Stimuli_Order_WM(stim, dirs, design);

if strcmp(design.session, 'Perception')
    % Same for the Perception database, but first delete the rest.
    stim.Stimuli_Perception_Database(:,13:end) = [];
    stim.Stimuli_Perception_Database(2:end,3:end) = stim.Perception_Stimuli;
else
    % Add image names to the matrices.
    stim.Stimuli_Task_ShapeOnly_Database(2:end,3:end)   = stim.Task_ShapeOnly_Stimuli;
    stim.Stimuli_Task_ShapeColor_Database(2:end,3:end)  = stim.Task_ShapeColor_Stimuli;
end


end  

